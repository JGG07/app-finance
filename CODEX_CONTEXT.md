# Contexto de trabajo para Codex

## Proposito de este archivo

Este documento es una bitacora tecnica viva para mantener el contexto del
trabajo realizado con Codex en App Finance. Debe actualizarse cuando cambien
las prioridades, se tome una decision de arquitectura o se complete una etapa
relevante.

No es documentacion para usuarios finales. El `README.md` sigue siendo la
entrada publica del proyecto.

## Objetivo general

Llevar App Finance, paso a paso, desde su estado actual de prototipo funcional
hacia una aplicacion confiable y mantenible, con especial atencion a:

1. Integridad y persistencia de los datos financieros.
2. Reglas de negocio consistentes y comprobables.
3. Pruebas automatizadas proporcionales al riesgo.
4. Una arquitectura que permita evolucionar la aplicacion sin concentrar toda
   la complejidad en pantallas y en un unico estado global.
5. Documentacion que refleje lo que realmente esta implementado.

## Estado actual observado

- Aplicacion Flutter organizada principalmente por funcionalidades bajo
  `lib/src/features`.
- Estado global basado en `FinanceState`, `ChangeNotifier` e
  `InheritedNotifier`.
- Persistencia local con Drift/SQLite en proceso de integracion.
- Funcionalidades presentes: resumen financiero, movimientos, presupuestos,
  tarjetas, compras a meses, suscripciones, plan de excedente y tareas
  financieras.
- La base de codigo manuscrita tiene aproximadamente 11 mil lineas Dart.
- Existen 21 pruebas automatizadas. Cubren principalmente calculos de
  `FinanceState`, el bloqueo y reintento durante el arranque, el vaciado de
  escrituras pendientes, la recuperacion de errores de guardado, el ciclo real
  de guardado, cierre y reapertura con Drift, el resumen financiero vacio, la
  navegacion desde su desglose y un smoke test de widgets.
- El `README.md` esta desactualizado: aun describe un cascaron inicial y pone la
  persistencia como trabajo futuro.
- La rama observada es `dev`, sincronizada con `origin/dev` al momento del
  primer analisis.
- Hay cambios locales sin commit. La capa `lib/src/core/database/` aparecia sin
  seguimiento, por lo que se deben preservar esos cambios y evitar sobrescribir
  trabajo existente.
- Flutter esta disponible en WSL bajo `/home/jazigg/develop/flutter/bin`.
- El 2026-07-13 se ejecutaron las 21 pruebas desde una copia temporal del
  proyecto y todas pasaron. El analisis estatico termino sin errores ni
  advertencias, con 12 avisos informativos relacionados principalmente con APIs
  de Flutter recientemente deprecadas.

## Riesgos identificados

### Prioridad alta

1. **Relacion fragil entre movimientos y categorias:** los movimientos guardan
   el nombre de la categoria en vez de su identificador. Renombrar, eliminar o
   duplicar nombres puede romper los totales historicos.

### Prioridad media

2. Cada modificacion guarda un snapshot completo, borrando y reinsertando todas
   las tablas dentro de una transaccion. Es consistente para pocos datos, pero
   costoso y poco escalable.
3. No hay una estrategia explicita de migraciones para versiones futuras del
   esquema Drift.
4. La validacion del dominio es inconsistente; algunos metodos permiten texto
   vacio, importes negativos o valores fuera de rango.
5. Varias clases son demasiado grandes: las pantallas principales superan con
   facilidad las 1,000 lineas y `FinanceState` concentra estado, calculos,
   mutaciones y persistencia.
6. La cobertura de pruebas aun no incluye migraciones, fallos reales de base de
   datos, el ciclo de vida completo de la aplicacion ni varios flujos
   principales.
7. El repositorio contiene archivos generados y configuraciones locales de
   Android e iOS modificados. Deben revisarse antes de preparar un commit para
   evitar publicar rutas o archivos especificos de una maquina.
8. `git diff --check` detecta espacios finales asociados a finales de linea en
   los `.gitignore` de Android e iOS.

## Ruta de trabajo propuesta

El orden inicial recomendado es:

1. Migrar la relacion movimiento-categoria de nombre a identificador estable.
2. Definir una estrategia de migraciones Drift.
3. Mejorar la persistencia para evitar snapshots completos en cada cambio.
4. Centralizar y probar las validaciones de dominio.
5. Dividir `FinanceState` y las pantallas grandes en componentes y casos de uso
   mas pequenos.
6. Actualizar el README y la documentacion de arquitectura.

Este orden puede cambiar por decision del propietario del proyecto. Antes de
cada etapa se debe revisar el codigo actual, confirmar el alcance y ejecutar las
pruebas disponibles.

## Forma de trabajo acordada

- Avanzar por pasos pequenos y verificables.
- No mezclar refactorizaciones amplias con correcciones funcionales salvo que
  sea necesario.
- Preservar todos los cambios locales preexistentes.
- No hacer commit, push ni publicar cambios sin una solicitud explicita.
- Para cada cambio: explicar el objetivo, implementar el alcance minimo,
  verificarlo y registrar aqui cualquier decision relevante.
- Ejecutar las verificaciones desde WSL con la instalacion disponible en
  `/home/jazigg/develop/flutter/bin`. Si el acceso al proyecto bajo `/mnt/e`
  resulta demasiado lento, usar una copia temporal exclusivamente para las
  verificaciones y mantener intacto el repositorio original.

## Registro de avances

### 2026-07-21 - Estabilizacion local y CI

- El entorno reproducible queda fijado en Flutter 3.44.0 estable y Dart 3.12.0.
- El fallo local de `ink_sparkle.frag` se diagnostico como una incompatibilidad
  entre el asset Vulkan del SDK local y el backend SkSL de `flutter test`.
  Los widgets usan un tema comun exclusivo de pruebas con `NoSplash`; los
  temas de produccion permanecen sin cambios visuales.
- GitHub Actions verifica formato, analisis y tests en `main` y `dev`.
- Drift mantiene precision temporal de segundos y la persistencia por snapshots
  completos continua documentada como deuda tecnica.

### 2026-07-21 - Recepcion de tandas como ingreso vinculado

- Cada tanda tiene una recepcion esperada persistente e independiente del
  progreso de aportaciones. Registrar manualmente la fecha real crea un unico
  ingreso determinista con categoria `Tanda recibida`.
- La recepcion puede deshacerse o repararse sin modificar aportaciones ni sus
  gastos. La eliminacion de la tanda contempla tambien el ingreso vinculado.
- Drift avanzo a `schemaVersion` 4. La migracion crea una recepcion pendiente
  por tanda existente sin generar ingresos y SQLite habilita explicitamente
  `PRAGMA foreign_keys = ON` para cascadas reales.
- El baseline previo fue de 95 pruebas aprobadas y tres fallos ambientales por
  `ink_sparkle.frag` (Vulkan frente a SkSL); esos tests no se omitieron.

### 2026-07-21 - Aportaciones de tandas vinculadas a movimientos

- Cada aportacion nueva registrada crea atomicamente un movimiento de gasto
  con categoria `Tanda`, fecha real de pago e ID determinista basado en la
  aportacion; deshacer elimina exclusivamente ese movimiento vinculado.
- El historial deriva los estados de vinculacion y permite registrar o recrear
  explicitamente movimientos de aportaciones heredadas sin alterar saldos al
  cargar la aplicacion.
- Al eliminar una tanda se puede conservar el historial financiero o eliminar
  solo los movimientos vinculados y verificados como generados por ella.
- Se mantuvo Drift en `schemaVersion` 3 y se comprobo el ciclo de guardar,
  cerrar, reabrir y deshacer con una base SQLite real.
- `build_runner` finalizo correctamente. Las pruebas funcionales nuevas pasan;
  la suite completa conserva un fallo ambiental intermitente al cargar
  `ink_sparkle.frag` porque el asset del SDK solo contiene etapa Vulkan y el
  backend de pruebas solicita SkSL.

### 2026-07-20 - Dinero libre y eleccion inicial del plan

- El dinero libre ahora parte del ingreso mensual menos presupuesto, apartados
  incluidos en el plan y pagos mensuales de tarjetas.
- La distribucion del plan de excedente se calcula sobre ese sobrante planeado,
  no sobre el sobrante real reducido por movimientos ya registrados.
- `Total libre` y `Te queda libre este mes` usan la porcion de uso libre del
  plan. Por ello, ahorro e inversion reducen el indicador cuando existe un plan.
- Se agregaron los estados persistibles `unconfigured` y `none` al plan de
  excedente. Un usuario nuevo debe elegir entre un plan balanceado o continuar
  sin plan antes de entrar a la aplicacion.
- Al elegir continuar sin plan, el 100% del sobrante planeado queda como dinero
  libre y no se generan tareas de ahorro, inversion ni separacion de uso libre.
- Los planes ya persistidos se conservan; el flujo inicial solo aparece para
  instalaciones nuevas cuyo plan esta `unconfigured`.
- Las 30 pruebas pasaron. El analisis estatico termino sin errores, con 10
  avisos informativos por APIs de Flutter deprecadas y estilo preexistente.

### 2026-07-20 - Separacion de presupuesto, libre y gastos hormiga

- Se centralizo en `FinanceState` la clasificacion de egresos: los movimientos
  cuyo nombre de categoria coincide con una categoria editable son gastos
  presupuestados; los demas son gastos hormiga. Los ingresos quedan excluidos.
- Los movimientos historicos cuya categoria ya no existe se consideran gasto
  hormiga, conservando compatibilidad con el esquema actual basado en nombres.
- Presupuesto ahora muestra exactamente Total presupuestado, Total utilizado,
  Total libre y Total gasto hormiga, con una cuadricula adaptable.
- Total libre se calcula como ingreso mensual total menos las partidas
  presupuestadas y no se reduce por el gasto ya realizado.
- Movimientos muestra `Gastos` como la suma de todos los egresos.
- Resumen muestra el total y porcentaje de gastos hormiga respecto del dinero
  libre, con proteccion explicita contra divisiones entre cero.
- Los porcentajes fijos de Resumen rapido en Plan se reemplazaron por calculos
  reales de deudas, utilizacion de presupuesto y ahorro. Todos devuelven cero
  cuando su denominador no es positivo.
- Se agregaron casos para los escenarios sin datos, solo presupuesto, gasto
  presupuestado, gasto hormiga, movimientos historicos e ingreso libre en cero.
  Las 29 pruebas pasaron y el analisis estatico termino sin errores, con 9
  avisos informativos preexistentes.

### 2026-07-20 - Presupuesto y control de Gasto Hormiga

- Presupuesto permite modificar nombre, limite y color de cada categoria, asi
  como eliminarla desde su tarjeta.
- Se agrego la categoria protegida `Gasto Hormiga`, disponible desde el primer
  arranque y no editable ni eliminable desde Presupuesto o Movimientos.
- Su limite se calcula desde la asignacion `Libre del Mes`; los movimientos de
  esta categoria reducen el dinero libre mostrado sin duplicar el monto dentro
  de los gastos planeados.
- La tarjeta cambia gradualmente de verde a naranja y rojo conforme aumenta el
  porcentaje utilizado.
- Presupuesto muestra primero Total presupuestado, Utilizado y Disponible.
- El Resumen incluye una metrica de Gasto Hormiga y muestra el libre restante
  despues de esos consumos.
- Se reemplazo la etiqueta Gastado por Utilizado en los resumenes afectados.
- Se agregaron pruebas de proteccion, calculos y presencia en el dashboard. Las
  26 pruebas pasaron; el analisis estatico no reporto errores y mantuvo solo los
  avisos informativos preexistentes de APIs de Flutter deprecadas.

### 2026-07-14 - Gestion de categorias desde Movimientos

- El formulario de nuevo movimiento ya no inventa la categoria `General` cuando
  no hay categorias registradas.
- El primer uso muestra un estado vacio con una accion para crear la primera
  categoria antes de registrar el movimiento.
- Tanto gastos como ingresos utilizan las categorias creadas por el usuario.
- Desde el formulario se pueden crear categorias adicionales y abrir un
  administrador para editarlas o eliminarlas.
- Cada categoria permite definir nombre, color y un presupuesto mensual
  opcional.
- Al renombrar una categoria se actualiza tambien su etiqueta en los movimientos
  existentes. Al eliminarla, los movimientos historicos se conservan con el
  ultimo nombre registrado.
- Se agregaron pruebas para el renombrado y la eliminacion sin perdida de
  movimientos.
- Se corrigio el ciclo de vida de los controladores de texto de los dialogos
  anidados. Antes se liberaban mientras Flutter aun desmontaba el formulario y
  podian provocar la asercion `_dependents.isEmpty` al crear una categoria.
- Una prueba de widget reproduce el flujo completo de crear la primera categoria
  desde Movimientos. Las 24 pruebas pasaron y el analisis enfocado de los
  archivos modificados termino sin incidencias.

### 2026-07-13 - Resumen inicial limpio y desglose navegable

- Se eliminaron del resumen los importes de demostracion que todavia estaban
  codificados para deudas, apartados y ahorro/inversion.
- Deudas ahora se calcula desde los pagos mensuales de tarjetas; apartados desde
  presupuestos y extras incluidos; ahorro/inversion desde la asignacion del plan
  de excedente; y el dinero libre desde la porcion de uso libre.
- Con un primer arranque sin datos, ingreso, disponible, deudas, apartados,
  ahorro/inversion y toda la distribucion aparecen en cero.
- Los recuadros del desglose ahora son interactivos: Deudas abre Tarjetas,
  Apartados abre Presupuesto y Ahorro/inversion abre Plan.
- Se agregaron pruebas para el resumen en cero y para las tres rutas de
  navegacion.
- Las 21 pruebas pasaron y el analisis estatico termino sin errores ni
  advertencias, con los mismos 12 avisos informativos preexistentes.
- Se realizo un hot restart exitoso del servidor web activo.

### 2026-07-13 - Persistencia habilitada en Flutter Web

- Se corrigio el arranque web de `AppDatabase`: `drift_flutter` ahora recibe
  `DriftWebOptions` con las rutas del modulo SQLite y del worker de Drift.
- Se agrego `sqlite3.wasm` compatible con `sqlite3` 3.3.2.
- Se agrego y compilo `drift_worker.dart.js` con Drift 2.33.0 a partir del
  entrypoint `web/drift_worker.dart`.
- El servidor web entrega la aplicacion, el modulo WASM y el worker con respuesta
  HTTP 200 y el tipo `application/wasm` correcto para SQLite.
- Se realizo un hot restart exitoso del servidor Flutter activo en el puerto
  8080.
- El analisis estatico termino sin errores ni advertencias, con los mismos 12
  avisos informativos preexistentes, y la prueba de integracion de persistencia
  continuo pasando.

### 2026-07-13 - Prueba de integracion real para Drift

- `AppDatabase` ahora permite inyectar un `QueryExecutor` exclusivamente para
  construir bases controladas en pruebas.
- Se agrego una prueba de integracion que usa un archivo SQLite temporal y un
  `FinanceRepository` real.
- La prueba guarda un snapshot representativo con datos de todas las tablas,
  cierra completamente el repositorio, abre una nueva conexion al mismo archivo
  y verifica campo por campo el snapshot recuperado.
- La cobertura incluye ingreso, categorias, movimientos, gastos planeados,
  tarjetas, compras, suscripciones, pagos mensuales, extras, plan de excedente,
  tareas manuales y overrides de tareas generadas.
- El archivo temporal y la conexion se limpian incluso si la prueba falla.
- Las 19 pruebas pasaron y el analisis estatico termino sin errores ni
  advertencias, con los mismos 12 avisos informativos preexistentes.

### 2026-07-13 - Errores de guardado visibles y recuperables

- Los errores de carga y de guardado ahora se mantienen en estados separados.
- Cuando falla `saveSnapshot()`, la aplicacion conserva los cambios en memoria y
  muestra un aviso persistente sin ocultar el contenido principal.
- El aviso explica que los cambios siguen en la sesion, muestra el detalle del
  fallo y ofrece una accion para reintentar antes de cerrar la aplicacion.
- El reintento encola un snapshot del estado mas reciente, por lo que tambien
  incluye cambios realizados despues del fallo original.
- Un guardado posterior exitoso limpia automaticamente el aviso de error.
- Se agrego una prueba de widget que provoca un fallo, verifica que el usuario lo
  vea y confirma que el reintento persiste el ingreso mensual actual.
- Las 18 pruebas pasaron y el analisis estatico termino sin errores ni
  advertencias, con los mismos 12 avisos informativos preexistentes.

### 2026-07-13 - Segunda revision tecnica y verificacion automatizada

- Se releyo esta bitacora antes de continuar el analisis y se confirmo que sigue
  siendo la fuente principal de continuidad tecnica del proyecto.
- Se localizo Flutter en WSL y se pudo ejecutar la verificacion automatizada.
- Las 17 pruebas existentes en ese momento pasaron correctamente.
- El analisis estatico termino sin errores ni advertencias. Reporto 12 avisos
  informativos, principalmente por propiedades de formularios y radios
  deprecadas en versiones recientes de Flutter.
- Las pruebas se ejecutaron desde una copia temporal porque el analisis directo
  sobre `/mnt/e` quedaba esperando durante demasiado tiempo. No se modifico el
  proyecto durante la revision.
- Se confirmo que las protecciones de inicializacion y vaciado de escrituras
  descritas en los avances del 2026-07-10 ya estan implementadas.
- Se identifico como riesgo prioritario que los errores al guardar se capturaban,
  pero no se comunicaban al usuario una vez inicializada la aplicacion. Este
  riesgo se resolvio en la etapa registrada arriba.
- Se confirmo que aun no existen pruebas con una base Drift real que cubran el
  ciclo guardar, cerrar y reabrir.
- El `README.md` continua desactualizado y la relacion entre movimientos y
  categorias sigue dependiendo del nombre de la categoria.

### 2026-07-10 - Vaciado de escrituras y ciclo de vida

- `FinanceState` expone `flushPendingSaves()` para esperar hasta que no quede
  ningun snapshot en la cola de persistencia.
- La aplicacion observa el ciclo de vida de Flutter y solicita el vaciado de la
  cola al quedar inactiva, oculta, pausada o separada del motor.
- Al destruir la aplicacion, Drift se cierra solamente despues de completar las
  escrituras encoladas.
- Se evitan notificaciones de `ChangeNotifier` despues de haberlo destruido.
- Se agrego una prueba que demuestra que el vaciado no termina mientras una
  escritura simulada continua pendiente.
- Esta proteccion complementa el guardado inmediato de cada cambio. No puede
  garantizar ejecucion adicional si el sistema operativo mata el proceso de
  forma abrupta.

### 2026-07-10 - Primer arranque sin datos precargados

- El snapshot inicial ahora comienza con ingreso en cero y todas las colecciones
  de datos personales vacias.
- Se eliminaron del arranque las categorias, movimientos, gastos planeados,
  tarjetas, compras, suscripciones y apartados de demostracion.
- Se agrego el alta de tarjetas, porque la pantalla anterior dependia de las
  tarjetas precargadas y no permitia comenzar desde cero.
- La pantalla de tarjetas ahora tiene un estado vacio y oculta las acciones de
  compras y suscripciones hasta que exista al menos una tarjeta.
- Las pruebas de `FinanceState` ahora construyen sus propios datos y verifican
  explicitamente que el estado inicial este vacio.
- Este cambio no elimina automaticamente una base ya inicializada. Hacerlo
  requiere una decision explicita porque puede destruir informacion existente.

### 2026-07-10 - Inicializacion asincrona segura

- Se agrego `AppStartupGate` para impedir que la interfaz editable se muestre
  mientras Drift carga el snapshot persistido.
- Se definio una pantalla de carga y una pantalla de error con detalle tecnico y
  accion para reintentar.
- `FinanceState` ahora diferencia entre estar cargando y haber terminado
  correctamente la inicializacion, y evita ejecutar dos cargas simultaneas.
- Se extrajo el contrato `FinanceStorage` para desacoplar el estado de la
  implementacion concreta de Drift y permitir pruebas controladas.
- Se agregaron pruebas de widget para carga, error y reintento.
- En ese momento la ejecucion de `flutter analyze` y `flutter test` quedo
  pendiente por no haberse localizado Flutter. La verificacion se completo el
  2026-07-13, como se registra arriba.

### 2026-07-10 - Analisis inicial

- Se revisaron la estructura, el estado global, la capa Drift, modelos, pruebas,
  README y estado de Git.
- Se identificaron los riesgos y la ruta de trabajo descritos arriba.
- Se creo este archivo para conservar el contexto antes de comenzar cambios de
  implementacion.

## Siguiente paso

Migrar la relacion entre movimientos y categorias para guardar un identificador
estable de categoria sin perder compatibilidad con los datos existentes.
