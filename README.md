# App Finance

App financiera personal hecha en Flutter para controlar gastos, presupuestos y metas sin perder claridad.

## Estado actual

Este repositorio contiene el cascaron inicial de la app:

- Arquitectura feature-first bajo `lib/src`.
- Tema visual centralizado con Material 3.
- Navegacion base con `NavigationBar`.
- Estado reactivo nativo con `ChangeNotifier` e `InheritedNotifier`.
- Nomina mensual editable desde el dashboard.
- Secciones de presupuesto dinamicas para dividir el dinero disponible.
- Registro de movimientos que actualiza el gasto de cada seccion.
- Tests base de render y calculos financieros.

## Estructura

```text
lib/
  main.dart
  src/
    app/
      app.dart
      router/
    core/
      constants/
      state/
      theme/
      utils/
    features/
      budgets/
      dashboard/
      settings/
      transactions/
    shared/
      presentation/
test/
```

## Primer arranque

Las plataformas nativas `android/` e `ios/` ya estan generadas. Para trabajar en la app:

```sh
flutter pub get
flutter test
flutter run
```

Si `flutter` no esta en tu `PATH`, usa la ruta completa a `flutter.bat`.

## Siguientes pasos recomendados

1. Agregar persistencia local para que nomina, secciones y movimientos no se pierdan al cerrar la app.
2. Separar gastos en efectivo, gastos fijos y ahorro/meta.
3. Agregar edicion completa de secciones, no solo limite.
4. Agregar resumen por quincena o periodo de nomina.
5. Agregar alertas cuando una seccion llegue a 80% o 100%.
