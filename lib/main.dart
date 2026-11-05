import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
  routerConfig: appRouter,
);
  }
}

// WelcomeScreen cambia a un StatefulWidget
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Variables de estado
  final String studentName = 'Pierina';
  int pendingTasks = 3;
  final String courseName = 'Desarrollo de aplicaciones móviles';
  final String motivationalMessage = 'OWO';

  // Completar tarea
  void completeTask() {
    if (pendingTasks == 0) return;
    setState(() {
      pendingTasks--;
    });
  }

  // Agregar tarea
  void addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.check_circle_outline, size: 56),
            const SizedBox(height: 24),
            Text(
              '¡Hola, $studentName!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text('Bienvenido/a a $courseName.'),
            const SizedBox(height: 32),
            Text('Este es mi mensaje: $motivationalMessage.'),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.pending_actions),
                    const SizedBox(width: 12),
                    Text('Tareas pendientes: $pendingTasks'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar tarea'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: completeTask,
                  icon: const Icon(Icons.check),
                  label: const Text('Completar tarea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Lista de tareas
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
}

const demoTasks = [
  Task(id: 1, title: 'Definir requisitos del proyecto', description: 'Listar funcionalidades principales de la app', priority: 'Alta', isCompleted: true),
  Task(id: 2, title: 'Diseñar la pantalla principal', description: 'Boceto de la lista de tareas y la tarjeta', priority: 'Alta', isCompleted: true),
  Task(id: 3, title: 'Crear el modelo de datos', description: 'Definir campos de Task y sus tipos', priority: 'Media', isCompleted: true),
  Task(id: 4, title: 'Redactar el backlog inicial', description: 'Ordenar tareas pendientes por prioridad', priority: 'Media', isCompleted: true),
  Task(id: 5, title: 'Preparar la demostración', description: 'Ensayar la presentación y tomar capturas', priority: 'Baja', isCompleted: false),
];

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final taskId = int.parse(state.pathParameters['id']!);
        return TaskDetailScreen(taskId: taskId);
      },
    ),
  ],
);

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  Color _priorityColor() {
    switch (task.priority) {
      case 'Alta':
        return Colors.red;
      case 'Media':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration:
                task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: Icon(Icons.chevron_right, color: _priorityColor()),
      ),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')) ,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return TaskCard(
            task: task, 
            onTap: () => context.push('/task/${task.id}'),);
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    final task = demoTasks.firstWhere((item) => item.id == taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')) ,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted ? Colors.green : null,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(task.description),
            const SizedBox(height: 16),
            Chip(
              avatar: const Icon(Icons.flag, size: 18),
              label: Text('Prioridad: ${task.priority}'),
            ),
            const SizedBox(height: 12),
            Text(task.isCompleted ? 'Estado: completada' : 'Estado: pendiente'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      task.isCompleted
                          ? 'Esta tarea ya está completada'
                          : 'Marcada para trabajar: ${task.title}',
                    ),
                  ),
                );
              },
              icon: Icon(task.isCompleted ? Icons.check : Icons.play_arrow),
              label: Text(task.isCompleted ? 'Completada' : 'Empezar tarea'),
            ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al listado'),
            ),
          ],
        ),
      ),
    );
  }
}