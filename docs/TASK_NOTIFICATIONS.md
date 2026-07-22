# Recordatorios de tareas

App Finance puede programar notificaciones locales para tareas financieras con
fecha límite. No son notificaciones push, no usan Firebase y no necesitan
internet.

## Permisos y valores predeterminados

El permiso se solicita únicamente cuando la persona activa **Recordatorios de
tareas** desde Ajustes o desde la tarjeta contextual de Tareas del mes. Nunca se
solicita durante el arranque.

Los recordatorios generales comienzan desactivados. La hora predeterminada es
9:00 a. m. y el aviso predeterminado es el mismo día. Cada tarea comienza con
su recordatorio desactivado y conserva su configuración cuando los avisos
generales se pausan.

## Programación

Android usa `AndroidScheduleMode.inexactAllowWhileIdle`. No se solicitan
alarmas exactas, pantalla completa ni permisos de alarma. El sistema puede
entregar el aviso algunos minutos después de la hora seleccionada.

El canal estable es `task_reminders`, con nombre **Recordatorios de tareas**,
importancia alta y contenido privado en la pantalla bloqueada. El mensaje no
incluye montos, saldos, tarjetas, notas, movimientos ni tandas.

Los receivers oficiales de `flutter_local_notifications` restauran la
programación después de reiniciar el teléfono o actualizar la aplicación. Los
fabricantes que restringen agresivamente el trabajo en segundo plano todavía
pueden retrasar notificaciones; en esos casos se deben revisar los ajustes de
batería del equipo.

## Persistencia y reconciliación

Drift guarda preferencias generales en `AppSettings` y recordatorios
individuales en `TaskReminders`. El esquema 5 agrega esa tabla sin modificar
datos financieros existentes. Al iniciar y al volver desde los ajustes del
sistema se consulta el permiso real, se cancelan recordatorios inválidos y se
reprograman los vigentes con el mismo ID estable.

Completar, omitir o eliminar una tarea cancela su aviso. Editar título, fecha,
estado, modo u hora cancela primero el ID anterior y lo programa nuevamente,
evitando duplicados.

## Prueba manual Android

1. Abrir Ajustes y activar Recordatorios de tareas.
2. Aceptar el permiso y enviar una notificación de prueba.
3. Crear una tarea con fecha límite cercana.
4. Activar Recordarme y elegir una fecha personalizada futura.
5. Cerrar la aplicación y esperar el aviso.
6. Tocar el aviso y confirmar que se abre Plan → Tareas del mes.
7. Editar la hora y comprobar que sólo quede un aviso.
8. Completar la tarea y comprobar que el aviso pendiente se cancele.
9. Reiniciar el teléfono y verificar que los avisos válidos se restauren.

Estas comprobaciones requieren un dispositivo Android real o emulador con
permisos habilitados.
