import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:mobile/core/storage/local_database.dart';
import 'package:mobile/data/models/entitlement_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late String dbPath;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    dbPath = p.join(await getDatabasesPath(), 'kraken_draw_local.db');
    await deleteDatabase(dbPath);
  });

  tearDownAll(() async {
    await deleteDatabase(dbPath);
  });

  test('migra derechos de v2 (una sola fila) a v3 por usuario', () async {
    // Base v2 como la dejaba la versión anterior: `derechos` solo admitía
    // `id = 1` aunque tuviera una columna user_id.
    final old = await openDatabase(
      dbPath,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE conversaciones (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            titulo TEXT NOT NULL,
            creada_en INTEGER NOT NULL,
            actualizada_en INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE mensajes (
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            conversacion_id TEXT NOT NULL,
            rol TEXT NOT NULL,
            contenido TEXT NOT NULL,
            tipo TEXT NOT NULL DEFAULT 'texto',
            metadata TEXT,
            creado_en INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE cache_reportes (
            clave TEXT PRIMARY KEY,
            metrica TEXT NOT NULL,
            categoria TEXT,
            desde TEXT NOT NULL,
            hasta TEXT NOT NULL,
            tz TEXT NOT NULL,
            payload TEXT NOT NULL,
            generado_en INTEGER NOT NULL,
            guardado_en INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE derechos (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            user_id TEXT NOT NULL,
            es_admin INTEGER NOT NULL,
            puede_reportes INTEGER NOT NULL,
            plan_code TEXT,
            username TEXT,
            validado_en INTEGER NOT NULL
          )
        ''');
      },
    );
    await old.insert('derechos', {
      'id': 1,
      'user_id': '7',
      'es_admin': 0,
      'puede_reportes': 1,
      'plan_code': 'pro',
      'username': 'mateo',
      'validado_en': DateTime.now().millisecondsSinceEpoch,
    });
    await old.close();

    // Abrir con LocalDatabase dispara la migración a v3.
    final heredado = await LocalDatabase.instance.loadEntitlement('7');
    expect(heredado, isNotNull);
    expect(heredado!.puedeReportes, isTrue);
    expect(heredado.planCode, 'pro');

    // La nueva tabla admite derechos distintos por usuario.
    await LocalDatabase.instance.saveEntitlement(
      CachedEntitlement(
        esAdmin: false,
        puedeReportes: false,
        planCode: 'free',
        username: 'saitama',
        validadoEn: DateTime.now(),
      ),
      '8',
    );

    final free = await LocalDatabase.instance.loadEntitlement('8');
    expect(free, isNotNull);
    expect(free!.puedeReportes, isFalse);

    final pro = await LocalDatabase.instance.loadEntitlement('7');
    expect(pro, isNotNull);
    expect(pro!.puedeReportes, isTrue);
  });
}
