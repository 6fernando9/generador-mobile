import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'package:mobile/data/models/chat_models.dart';
import 'package:mobile/data/models/entitlement_models.dart';
import 'package:mobile/data/models/report_models.dart';
import 'package:mobile/data/models/saved_download.dart';

/// Base SQLite local del asistente: conversaciones, mensajes, caché de
/// reportes y derechos cacheados. No reemplaza a PostgreSQL.
class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  static const String _dbName = 'kraken_draw_local.db';
  static const int _version = 4;

  Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null) return existing;

    final path = p.join(await getDatabasesPath(), _dbName);
    final db = await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
    _db = db;
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
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
        creado_en INTEGER NOT NULL,
        FOREIGN KEY (conversacion_id) REFERENCES conversaciones(id)
          ON DELETE CASCADE
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_mensajes_conversacion '
      'ON mensajes(user_id, conversacion_id, creado_en)',
    );

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
        user_id TEXT PRIMARY KEY,
        es_admin INTEGER NOT NULL,
        puede_reportes INTEGER NOT NULL,
        plan_code TEXT,
        username TEXT,
        validado_en INTEGER NOT NULL
      )
    ''');

    await _crearTablaRegeneraciones(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // La versión 1 compartía las conversaciones entre cuentas. Se añade el
      // propietario con un valor por defecto válido (las comillas simples
      // importan: `DEFAULT 'unknown'`, no `DEFAULT unknown`).
      await _addColumnIfMissing(
        db,
        'conversaciones',
        'user_id',
        "TEXT NOT NULL DEFAULT 'unknown'",
      );
      await _addColumnIfMissing(
        db,
        'mensajes',
        'user_id',
        "TEXT NOT NULL DEFAULT 'unknown'",
      );
      await db.execute('DROP INDEX IF EXISTS idx_mensajes_conversacion');
      await db.execute(
        'CREATE INDEX IF NOT EXISTS idx_mensajes_conversacion '
        'ON mensajes(user_id, conversacion_id, creado_en)',
      );
      await _addColumnIfMissing(
        db,
        'derechos',
        'user_id',
        "TEXT NOT NULL DEFAULT 'unknown'",
      );
    }

    if (oldVersion < 3) {
      // La tabla antigua solo admitía una fila (`id = 1`). Se reconstruye con
      // el usuario como clave para no pisar los derechos al cambiar de cuenta.
      await _rebuildDerechos(db);
    }

    if (oldVersion < 4) await _crearTablaRegeneraciones(db);
  }

  Future<void> _crearTablaRegeneraciones(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS regeneraciones (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        nombre TEXT NOT NULL,
        extension TEXT NOT NULL,
        ubicacion TEXT NOT NULL,
        ruta_local TEXT NOT NULL,
        creado_en INTEGER NOT NULL,
        predeterminado INTEGER NOT NULL DEFAULT 0,
        copia_interna INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute(
      'CREATE INDEX IF NOT EXISTS idx_regeneraciones_usuario_fecha '
      'ON regeneraciones(user_id, creado_en DESC)',
    );
  }

  Future<bool> _hasColumn(Database db, String table, String column) async {
    final rows = await db.rawQuery('PRAGMA table_info($table)');
    return rows.any((row) => row['name'] == column);
  }

  Future<void> _addColumnIfMissing(
    Database db,
    String table,
    String column,
    String definition,
  ) async {
    if (await _hasColumn(db, table, column)) return;
    await db.execute('ALTER TABLE $table ADD COLUMN $column $definition');
  }

  Future<void> _rebuildDerechos(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(derechos)');
    if (columns.isEmpty) return;
    final names = columns.map((row) => row['name']).toSet();
    if (!names.contains('user_id')) return;

    const temp = 'derechos_v3';
    await db.execute('DROP TABLE IF EXISTS $temp');
    await db.execute('''
      CREATE TABLE $temp (
        user_id TEXT PRIMARY KEY,
        es_admin INTEGER NOT NULL,
        puede_reportes INTEGER NOT NULL,
        plan_code TEXT,
        username TEXT,
        validado_en INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      INSERT OR REPLACE INTO $temp
        (user_id, es_admin, puede_reportes, plan_code, username, validado_en)
      SELECT
        COALESCE(NULLIF(user_id, ''), 'unknown'),
        es_admin, puede_reportes, plan_code, username, validado_en
      FROM derechos
    ''');

    await db.execute('DROP TABLE derechos');
    await db.execute('ALTER TABLE $temp RENAME TO derechos');
  }

  // ---------------------------------------------------------------------------
  // Conversaciones
  // ---------------------------------------------------------------------------

  Future<void> insertConversation(
    ChatConversation conversation,
    String userId,
  ) async {
    final db = await database;
    await db.insert('conversaciones', {
      'id': conversation.id,
      'user_id': userId,
      'titulo': conversation.titulo,
      'creada_en': conversation.creadaEn.millisecondsSinceEpoch,
      'actualizada_en': conversation.actualizadaEn.millisecondsSinceEpoch,
    });
  }

  Future<List<ChatConversation>> listConversations(String userId) async {
    final db = await database;
    final rows = await db.query(
      'conversaciones',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'actualizada_en DESC',
    );
    return rows.map((row) {
      return ChatConversation(
        id: row['id'] as String,
        titulo: row['titulo'] as String? ?? 'Conversación',
        creadaEn: DateTime.fromMillisecondsSinceEpoch(
          row['creada_en'] as int? ?? 0,
        ),
        actualizadaEn: DateTime.fromMillisecondsSinceEpoch(
          row['actualizada_en'] as int? ?? 0,
        ),
      );
    }).toList();
  }

  Future<void> touchConversation(
    String userId,
    String id, {
    String? titulo,
    DateTime? actualizadaEn,
  }) async {
    final db = await database;
    await db.update(
      'conversaciones',
      {
        'titulo': ?titulo,
        'actualizada_en':
            (actualizadaEn ?? DateTime.now()).millisecondsSinceEpoch,
      },
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  Future<void> deleteConversation(String userId, String id) async {
    final db = await database;
    await db.delete(
      'conversaciones',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }

  // ---------------------------------------------------------------------------
  // Mensajes
  // ---------------------------------------------------------------------------

  Future<void> insertMessage(ChatMessage message, String userId) async {
    final db = await database;
    final map = message.toMap();
    map['user_id'] = userId;
    await db.insert(
      'mensajes',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMessage(ChatMessage message, String userId) async {
    final db = await database;
    final map = message.toMap();
    map['user_id'] = userId;
    await db.update(
      'mensajes',
      map,
      where: 'id = ? AND user_id = ?',
      whereArgs: [message.id, userId],
    );
  }

  Future<List<ChatMessage>> listMessages(
    String userId,
    String conversationId, {
    int? limit,
  }) async {
    final db = await database;
    List<Map<String, Object?>> rows;
    if (limit == null) {
      rows = await db.query(
        'mensajes',
        where: 'conversacion_id = ? AND user_id = ?',
        whereArgs: [conversationId, userId],
        orderBy: 'creado_en ASC',
      );
    } else {
      rows = await db.query(
        'mensajes',
        where: 'conversacion_id = ? AND user_id = ?',
        whereArgs: [conversationId, userId],
        orderBy: 'creado_en DESC',
        limit: limit,
      );
      rows = rows.reversed.toList();
    }
    return rows.map(ChatMessage.fromMap).toList();
  }

  Future<void> clearMessages(String userId, String conversationId) async {
    final db = await database;
    await db.delete(
      'mensajes',
      where: 'conversacion_id = ? AND user_id = ?',
      whereArgs: [conversationId, userId],
    );
  }

  // ---------------------------------------------------------------------------
  // Caché de reportes
  // ---------------------------------------------------------------------------

  Future<void> saveReport(CachedReport report) async {
    final db = await database;
    await db.insert(
      'cache_reportes',
      report.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CachedReport?> getReport(String clave) async {
    final db = await database;
    final rows = await db.query(
      'cache_reportes',
      where: 'clave = ?',
      whereArgs: [clave],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return CachedReport.fromMap(rows.first);
  }

  /// La caché de reportes se conserva 30 días para el modo offline.
  Future<void> purgeOldReports({int days = 30}) async {
    final db = await database;
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    await db.delete(
      'cache_reportes',
      where: 'guardado_en < ?',
      whereArgs: [cutoff],
    );
  }

  // ---------------------------------------------------------------------------
  // Historial local de regeneraciones
  // ---------------------------------------------------------------------------

  /// Registra una descarga y conserva solo las 20 más recientes por cuenta.
  /// Devuelve rutas de copias privadas antiguas que ya se pueden borrar.
  Future<List<String>> recordSavedDownload(
    SavedDownload download,
    String userId,
  ) async {
    final db = await database;
    await db.insert(
      'regeneraciones',
      download.toMap(userId),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final rows = await db.query(
      'regeneraciones',
      columns: ['id', 'ruta_local', 'copia_interna'],
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'creado_en DESC',
    );
    if (rows.length <= 20) return const [];

    final antiguas = rows.skip(20).toList();
    final batch = db.batch();
    for (final row in antiguas) {
      batch.delete(
        'regeneraciones',
        where: 'id = ? AND user_id = ?',
        whereArgs: [row['id'], userId],
      );
    }
    await batch.commit(noResult: true);

    return [
      for (final row in antiguas)
        if (row['copia_interna'] == 1) row['ruta_local'] as String,
    ];
  }

  Future<List<SavedDownload>> listSavedDownloads(
    String userId, {
    int limit = 20,
  }) async {
    final db = await database;
    final rows = await db.query(
      'regeneraciones',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'creado_en DESC',
      limit: limit,
    );
    return rows.map(SavedDownload.fromMap).toList();
  }

  Future<SavedDownload?> getSavedDownload(String userId, String id) async {
    final db = await database;
    final rows = await db.query(
      'regeneraciones',
      where: 'user_id = ? AND id = ?',
      whereArgs: [userId, id],
      limit: 1,
    );
    return rows.isEmpty ? null : SavedDownload.fromMap(rows.first);
  }

  // ---------------------------------------------------------------------------
  // Derechos (entitlements)
  // ---------------------------------------------------------------------------

  Future<void> saveEntitlement(
    CachedEntitlement entitlement,
    String userId,
  ) async {
    final db = await database;
    final map = entitlement.toMap();
    map['user_id'] = userId;
    await db.insert(
      'derechos',
      map,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CachedEntitlement?> loadEntitlement(String userId) async {
    final db = await database;
    final rows = await db.query(
      'derechos',
      where: 'user_id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return CachedEntitlement.fromMap(rows.first);
  }

  Future<void> clearAll(String userId) async {
    final db = await database;
    final copias = await db.query(
      'regeneraciones',
      columns: ['ruta_local'],
      where: 'user_id = ? AND copia_interna = 1',
      whereArgs: [userId],
    );
    for (final copia in copias) {
      final archivo = File(copia['ruta_local'] as String);
      if (await archivo.exists()) await archivo.delete();
    }
    await db.delete('mensajes', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(
      'conversaciones',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    // La caché usa claves con prefijo de usuario; borrar solo la propia evita
    // dejar sin reportes offline a otras cuentas del mismo dispositivo.
    await db.delete(
      'cache_reportes',
      where: "clave LIKE ? ESCAPE '\\'",
      whereArgs: ['${userId.replaceAll('%', '\\%').replaceAll('_', '\\_')}|%'],
    );
    await db.delete('derechos', where: 'user_id = ?', whereArgs: [userId]);
    await db.delete(
      'regeneraciones',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
}
