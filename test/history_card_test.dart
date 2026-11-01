// Overflow / responsive tests de la card del historial.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/data/models/log_models.dart';
import 'package:mobile/presentation/dashboard/history/generation_log_card.dart';

LogGeneracion _log() => LogGeneracion(
  id: 'log-1',
  proyectoId: 'p-1',
  rolId: 18,
  rolMomentoCode: 'propietario',
  tipoArtefactoId: 1,
  lenguajeId: 1,
  frameworkId: 2,
  arquitecturaId: 3,
  ormId: 4,
  baseDatosId: 5,
  tipoReporteId: 6,
  tipoXmlId: 7,
  versionGenerador: '1.0.0',
  createdAt: DateTime(2026, 11, 1, 12, 56),
  tipoArtefacto: const LogDimensionRef(
    id: 1,
    nombre: 'Backend',
    nombreCode: 'backend',
    icono: 'server',
    iconoTipo: 'icono',
  ),
  lenguaje: const LogDimensionRef(
    id: 1,
    nombre: 'Java',
    nombreCode: 'java',
    icono: 'java',
    iconoTipo: 'icono',
  ),
  framework: const LogDimensionRef(
    id: 2,
    nombre: 'Spring Boot',
    nombreCode: 'spring_boot',
    icono: 'spring',
    iconoTipo: 'icono',
  ),
  arquitectura: const LogDimensionRef(
    id: 3,
    nombre: 'DDD',
    nombreCode: 'ddd',
    icono: 'ddd',
    iconoTipo: 'icono',
  ),
  orm: const LogDimensionRef(
    id: 4,
    nombre: 'Hibernate',
    nombreCode: 'hibernate',
    icono: 'hibernate',
    iconoTipo: 'icono',
  ),
  baseDatos: const LogDimensionRef(
    id: 5,
    nombre: 'PostgreSQL',
    nombreCode: 'postgresql',
    icono: 'database',
    iconoTipo: 'icono',
  ),
  tipoReporte: const LogDimensionRef(
    id: 6,
    nombre: 'Reporte de Proyecto',
    nombreCode: 'reporte_proyecto',
    icono: 'file-text',
    iconoTipo: 'icono',
  ),
  tipoXml: const LogDimensionRef(
    id: 7,
    nombre: 'XMI 1.1',
    nombreCode: 'xmi_11',
    icono: 'xml',
    iconoTipo: 'icono',
  ),
  proyecto: const LogProyectoRef(
    id: 'p-1',
    nombre: 'Kraken Draw - Plataforma de generación',
  ),
);

Future<void> _pumpAtSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [GenerationLogCard(log: _log())],
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 200));
}

void main() {
  const sizes = [
    Size(360, 800),
    Size(390, 844),
    Size(414, 896),
    Size(768, 1024),
    Size(1280, 900),
  ];

  testWidgets('GenerationLogCard no desborda en varios tamaños', (
    tester,
  ) async {
    for (final size in sizes) {
      await _pumpAtSize(tester, size);
      expect(
        tester.takeException(),
        isNull,
        reason: 'GenerationLogCard desbordó en $size',
      );
    }
  });

  testWidgets('GenerationLogCard no desborda con textScale 1.4', (
    tester,
  ) async {
    tester.platformDispatcher.textScaleFactorTestValue = 1.4;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    for (final size in sizes) {
      await _pumpAtSize(tester, size);
      expect(
        tester.takeException(),
        isNull,
        reason: 'GenerationLogCard desbordó con textScale 1.4 en $size',
      );
    }
  });

  testWidgets('el botón de ojo está habilitado y sin acción visible', (
    tester,
  ) async {
    await _pumpAtSize(tester, const Size(390, 844));

    final boton = tester.widget<IconButton>(
      find.widgetWithIcon(IconButton, Icons.visibility_rounded),
    );
    expect(boton.onPressed, isNotNull);

    await tester.tap(find.widgetWithIcon(IconButton, Icons.visibility_rounded));
    await tester.pump();
    expect(find.byType(SnackBar), findsNothing);
  });
}
