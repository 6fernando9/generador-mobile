// Parseo de los payloads reales de `/logs/mis-logs` y `filter-options`.
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/log_models.dart';

Map<String, dynamic> _logJson() => {
  'id': '6008e3b0-57df-4a63-b5d5-9eb20d34f1cb',
  'proyecto_id': '4326aa5f-85ab-44d2-b251-aff67d6bb1cc',
  'usuario_id': 1,
  'rol_id': 18,
  'rol_momento_code': 'propietario',
  'tipo_artefacto_id': 8,
  'lenguaje_id': 1,
  'framework_id': null,
  'arquitectura_id': null,
  'orm_id': null,
  'base_datos_id': 3,
  'tipo_reporte_id': 1,
  'tipo_xml_id': null,
  'version_generador': '1.0.0',
  'created_at': '2026-11-01T12:56:10.103Z',
  'updated_at': '2026-11-01T12:56:10.103Z',
  'tipo_artefacto': {
    'id': 8,
    'nombre': 'Reporte',
    'nombre_code': 'reporte',
    'icono': 'file-text',
    'icono_tipo': 'icono',
  },
  'lenguaje': {
    'id': 1,
    'nombre': 'Java',
    'nombre_code': 'java',
    'icono': null,
    'icono_tipo': 'none',
  },
  'framework': null,
  'arquitectura': null,
  'orm': null,
  'base_datos': {
    'id': 3,
    'nombre': 'PostgreSQL',
    'nombre_code': 'postgresql',
    'icono': 'https://cdn.example.com/postgres.svg',
    'icono_tipo': 'upload',
  },
  'tipo_reporte': {
    'id': 1,
    'nombre': 'PDF',
    'nombre_code': 'pdf',
    'icono': 'file-text',
    'icono_tipo': 'icono',
  },
  'tipo_xml': null,
  'proyecto': {
    'id': '4326aa5f-85ab-44d2-b251-aff67d6bb1cc',
    'nombre': 'Kraken',
  },
  'usuario': {
    'id': 1,
    'username': 'fernando',
    'profile_icon': null,
    'profile_icon_tipo': 'none',
  },
};

void main() {
  group('PaginatedLogs.fromJson', () {
    test('parsea items y meta', () {
      final page = PaginatedLogs.fromJson({
        'items': [_logJson()],
        'meta': {
          'totalItems': 80,
          'totalPages': 8,
          'currentPage': 1,
          'pageSize': 10,
        },
      });

      expect(page.items, hasLength(1));
      expect(page.meta.totalItems, 80);
      expect(page.meta.totalPages, 8);
      expect(page.meta.currentPage, 1);
      expect(page.meta.pageSize, 10);

      final log = page.items.single;
      expect(log.proyectoNombre, 'Kraken');
      expect(log.rolMomentoCode, 'propietario');
      expect(log.versionGenerador, '1.0.0');
      expect(log.createdAt, DateTime.utc(2026, 11, 1, 12, 56, 10, 103));
      expect(log.tipoArtefacto?.nombre, 'Reporte');
      expect(log.arquitectura, isNull);
      expect(log.orm, isNull);
      expect(log.tipoXml, isNull);
    });

    test('dimensiones omite las relaciones nulas', () {
      final log = LogGeneracion.fromJson(_logJson());

      expect(log.dimensiones.map((d) => d.nombre), [
        'Reporte',
        'Java',
        'PostgreSQL',
        'PDF',
      ]);
    });

    test('proyectoNombre usa fallback cuando no hay proyecto', () {
      final json = _logJson()..remove('proyecto');
      final log = LogGeneracion.fromJson(json);

      expect(log.proyectoNombre, 'Proyecto sin nombre');
    });
  });

  group('LogFilterOptions.fromJson', () {
    test('parsea los 8 catálogos', () {
      final options = LogFilterOptions.fromJson({
        'tipos_artefacto': [
          {
            'id': 1,
            'nombre': 'Backend',
            'nombre_code': 'backend',
            'icono': 'server',
            'icono_tipo': 'icono',
          },
        ],
        'lenguajes': [
          {
            'id': 1,
            'nombre': 'Java',
            'nombre_code': 'java',
            'icono': 'java',
            'icono_tipo': 'icono',
          },
        ],
        'frameworks': [],
        'arquitecturas': [],
        'orms': [],
        'bases_datos': [],
        'tipos_reporte': [],
        'tipos_xml': [],
      });

      expect(options.tiposArtefacto.single.nombre, 'Backend');
      expect(options.lenguajes.single.nombreCode, 'java');
      expect(options.frameworks, isEmpty);
      expect(options.basesDatos, isEmpty);
    });
  });
}
