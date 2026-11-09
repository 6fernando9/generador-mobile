import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'package:mobile/data/models/chat_models.dart';
import 'package:mobile/data/models/entitlement_models.dart';
import 'package:mobile/data/models/report_models.dart';

/// Base SQLite local del asistente: conversaciones, mensajes, caché de
/// reportes y derechos cacheados. No reemplaza a PostgreSQL.
class LocalDatabase {
  LocalDatabase._();

  static final LocalDatabase instance = LocalDatabase._();

  static const String _dbName = 'kraken_draw_local.db';
  static const int _version = 1;

  Database? _db;

  Future<Database> get database async {
    final existing = _db;
    if (existing != null) return existing;

    final path = p.join(await getDatabasesPath(), _dbName);
    final db = await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
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
        titulo TEXT NOT NULL,
        creada_en INTEGER NOT NULL,
        actualizada_en INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE mensajes (
        id TEXT PRIMARY KEY,
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
      'ON mensajes(conversacion_id, creado_en)',
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
        id INTEGER PRIMARY KEY CHECK (id = 1),
        es_admin INTEGER NOT NULL,
        puede_reportes INTEGER NOT NULL,
        plan_code TEXT,
        username TEXT,
        validado_en INTEGER NOT NULL
      )
    ''');
  }

  // ---------------------------------------------------------------------------
  // Conversaciones
  // ---------------------------------------------------------------------------

  Future<void> insertConversation(ChatConversation conversation) async {
    final db = await database;
    await db.insert('conversaciones', {
      'id': conversation.id,
      'titulo': conversation.titulo,
      'creada_en': conversation.creadaEn.millisecondsSinceEpoch,
      'actualizada_en': conversation.actualizadaEn.millisecondsSinceEpoch,
    });
  }

  Future<List<ChatConversation>> listConversations() async {
    final db = await database;
    final rows = await db.query(
      'conversaciones',
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
    String id, {
    String? titulo,
    DateTime? actualizadaEn,
  }) async {
    final db = await database;
    await db.update(
      'conversaciones',
      {
        if (titulo != null) 'titulo': titulo,
        'actualizada_en':
            (actualizadaEn ?? DateTime.now()).millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteConversation(String id) async {
    final db = await database;
    await db.delete('conversaciones', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------------
  // Mensajes
  // ---------------------------------------------------------------------------

  Future<void> insertMessage(ChatMessage message) async {
    final db = await database;
    await db.insert(
      'mensajes',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateMessage(ChatMessage message) async {
    final db = await database;
    await db.update(
      'mensajes',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<List<ChatMessage>> listMessages(
    String conversationId, {
    int? limit,
  }) async {
    final db = await database;
    List<Map<String, Object?>> rows;
    if (limit == null) {
      rows = await db.query(
        'mensajes',
        where: 'conversacion_id = ?',
        whereArgs: [conversationId],
        orderBy: 'creado_en ASC',
      );
    } else {
      rows = await db.query(
        'mensajes',
        where: 'conversacion_id = ?',
        whereArgs: [conversationId],
        orderBy: 'creado_en DESC',
        limit: limit,
      );
      rows = rows.reversed.toList();
    }
    return rows.map(ChatMessage.fromMap).toList();
  }

  Future<void> clearMessages(String conversationId) async {
    final db = await database;
    await db.delete(
      'mensajes',
      where: 'conversacion_id = ?',
      whereArgs: [conversationId],
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
  // Derechos (entitlements)
  // ---------------------------------------------------------------------------

  Future<void> saveEntitlement(CachedEntitlement entitlement) async {
    final db = await database;
    await db.insert(
      'derechos',
      entitlement.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CachedEntitlement?> loadEntitlement() async {
    final db = await database;
    final rows = await db.query('derechos', where: 'id = 1', limit: 1);
    if (rows.isEmpty) return null;
    return CachedEntitlement.fromMap(rows.first);
  }

  Future<void> clearAll() async {
    final db = await database;
    await db.delete('mensajes');
    await db.delete('conversaciones');
    await db.delete('cache_reportes');
    await db.delete('derechos');
  }
}
