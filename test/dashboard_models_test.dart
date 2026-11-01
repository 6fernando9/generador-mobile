// Parsing tests for the personal dashboard models. They mirror the real
// payloads returned by Backend-Draw (snake_case names, porTipo map, nullable
// deltas and partial technology dimensions).
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/data/models/dashboard_actividad.dart';
import 'package:mobile/data/models/dashboard_catalogos.dart';
import 'package:mobile/data/models/dashboard_resumen.dart';
import 'package:mobile/data/models/dashboard_tecnologias.dart';
import 'package:mobile/data/models/dashboard_tendencia.dart';

void main() {
  test('DashboardResumen parses snake_case fields and nullable deltas', () {
    final resumen = DashboardResumen.fromJson(const {
      'hoy': 2,
      'ayer': 0,
      'semana': 66,
      'semana_pasada': 11,
      'mes': 2,
      'mes_pasado': 0,
      'total': 77,
      'deltas': {'hoy': null, 'semana': 500, 'mes': null},
    });

    expect(resumen.semanaPasada, 11);
    expect(resumen.mesPasado, 0);
    expect(resumen.total, 77);
    expect(resumen.deltas.hoy, isNull);
    expect(resumen.deltas.semana, 500);
    expect(resumen.deltas.mes, isNull);
  });

  test('TimeSeriesPoint reads the porTipo map', () {
    final tendencia = DashboardTendencia.fromJson(const {
      'total': 4,
      'granularidad': 'dia',
      'desde': '2026-10-03T18:49:16.228Z',
      'hasta': '2026-11-01T18:49:16.228Z',
      'serie': [
        {
          'periodo': '2026-10-19',
          'total': 4,
          'porTipo': {'backend': 2, 'frontend': 1, 'mobile': 1, 'reporte': 0},
        },
      ],
    });

    final point = tendencia.serie.single;
    expect(point.total, 4);
    expect(point.backend, 2);
    expect(point.frontend, 1);
    expect(point.mobile, 1);
    expect(point.reporte, 0);
  });

  test(
    'DashboardTecnologias exposes the 8 dimensions with snake_case keys',
    () {
      final data = DashboardTecnologias.fromJson(const {
        'total': 3,
        'lenguajes': [],
        'frameworks': [],
        'arquitecturas': [],
        'orms': [],
        'bases_datos': [
          {
            'id': 1,
            'nombre': 'PostgreSQL',
            'nombre_code': 'postgresql',
            'icono': 'http://localhost:4566/x.svg',
            'icono_tipo': 'upload',
            'total': 2,
            'porcentaje': 66.7,
          },
        ],
        'tipos_artefacto': [
          {
            'id': 8,
            'nombre': 'Reporte',
            'nombre_code': 'reporte',
            'icono': 'file-text',
            'icono_tipo': 'icono',
            'total': 3,
            'porcentaje': 100,
          },
        ],
        'tipos_reporte': [],
        'tipos_xml': [],
      });

      expect(data.basesDatos.single.nombre, 'PostgreSQL');
      expect(data.basesDatos.single.iconoTipo, 'upload');
      expect(data.itemsDe(TecnologiaCategoria.tiposArtefacto).single.total, 3);
      expect(data.itemsDe(TecnologiaCategoria.tiposXml), isEmpty);
    },
  );

  test('DashboardActividad parses por_dia_semana / por_hora', () {
    final data = DashboardActividad.fromJson(const {
      'total': 2,
      'por_dia_semana': [
        {'dia': 1, 'nombre': 'Lunes', 'total': 2},
      ],
      'por_hora': [
        {'hora': 12, 'total': 2},
      ],
      'heatmap': [
        {'dia': 1, 'hora': 12, 'total': 2},
      ],
    });

    expect(data.porDiaSemana.single.nombre, 'Lunes');
    expect(data.porHora.single.hora, 12);
    expect(data.heatmap.single.total, 2);
  });

  test('DashboardCatalogos parses without a root total', () {
    final data = DashboardCatalogos.fromJson(const {
      'lenguajes': [
        {
          'id': 17,
          'nombre': 'Go',
          'nombre_code': 'go',
          'icono': 'go',
          'icono_tipo': 'icono',
          'total': 60,
          'porcentaje': 81.1,
        },
      ],
      'frameworks': [],
      'arquitecturas': [],
      'orms': [],
      'bases_datos': [],
      'tipos_artefacto': [],
      'tipos_reporte': [],
      'tipos_xml': [],
    });

    expect(data.itemsDe(TecnologiaCategoria.lenguajes).single.total, 60);
    expect(data.itemsDe(TecnologiaCategoria.tiposXml), isEmpty);
  });
}
