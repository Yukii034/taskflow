## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación

1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos

Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas

- Lista: tarjetas de tareas y acción para crear.
- Detalle: información completa y futuras acciones de editar o eliminar.
- Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales

- La navegación debe tener textos comprensibles.
- Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos

| Operación | Endpoint | Descripción |
|-----------|----------|-------------|
| GET | /tasks | listar tareas |
| GET | /tasks/:id | consultar detalle |
| POST | /tasks | crear tarea |
| PATCH | /tasks/:id | actualizar tarea |
| DELETE | /tasks/:id | eliminar tarea |

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.

## API de tareas

TaskFlow consulta las tareas desde JSONPlaceholder, una API pública de datos de prueba.

**URL exacta:** `https://jsonplaceholder.typicode.com/todos?userId=2`

**Parámetro:** `userId=2` filtra las tareas del usuario 2. Este valor está definido en la constante `userId` de `TaskApiService` (`lib/features/tasks/data/task_api_service.dart`).

### Campos que llegan de la API

| Campo remoto | Campo en TaskFlow | Descripción |
|--------------|-------------------|-------------|
| `id` | `id` | Identificador único de la tarea |
| `title` | `title` | Título de la tarea |
| `completed` | `isCompleted` | Estado: completada o pendiente |
| `userId` | `userId` | Usuario propietario de la tarea |

### Valores que TaskFlow completa por defecto

La API no entrega `description` ni `priority`, así que `Task.fromJson` usa valores de ejemplo:

- `description`: "Sin descripción (API)"
- `priority`: "Sin prioridad (API)"

Estos valores no vienen del servidor.

### Limitaciones actuales

Marcar una tarea como completada solo modifica una copia en memoria (`RemoteTaskRepository.save`). JSONPlaceholder no guarda cambios, así que al reiniciar la app el estado vuelve al valor remoto original. Las operaciones remotas (crear, editar, eliminar) se implementarán en sesiones posteriores.

### Flujo de datos

`main.dart` → `TasksViewModel.loadTasks()` → `RemoteTaskRepository.getTasks()` → `TaskApiService` (Dio, GET) → `Task.fromJson()` → `notifyListeners()` → lista y detalle.

## Estados de la lista de tareas

La pantalla "Mis tareas" distingue cuatro estados, controlados por `TasksViewModel`:

| Estado | Qué se muestra | Cómo provocarlo |
|--------|----------------|-----------------|
| Carga | Indicador circular de progreso | Abrir la app o pulsar el botón de actualizar; limitar la red del emulador si responde muy rápido |
| Éxito | Una tarjeta por cada tarea | Tener internet y un `userId` válido en `TaskApiService` |
| Vacío | Mensaje "Todavía no tienes tareas registradas." y botón **Actualizar** | Cambiar temporalmente `userId` a `9999` en `TaskApiService` y reiniciar |
| Error | Mensaje de error y botón **Reintentar** | Desactivar internet en el emulador y pulsar actualizar |

### Reintento

Al reactivar internet y pulsar **Reintentar**, `loadTasks()` vuelve a consultar la API y la lista se recupera sin reiniciar la aplicación. También se puede actualizar con el botón de la barra superior o deslizando hacia abajo (`RefreshIndicator`).

### Diferencia entre vacío y error

Una lista vacía es una respuesta válida del servidor; un error significa que no se pudo obtener la respuesta. Por eso tienen mensajes y botones distintos.

### Nota

Al actualizar se vuelve a leer el servidor, por lo que una tarea marcada como completada localmente vuelve a su estado remoto original.