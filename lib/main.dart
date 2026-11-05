import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const TaskListScreen(), // pantalla
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


class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

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
        trailing: IconButton(
          icon: Icon(Icons.chevron_right, color: _priorityColor()),
          tooltip: 'Ver detalle',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Detalle de: ${task.title}')),
            );
          },
        ),
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
          return TaskCard(task: task);
        },
      ),
    );
  }
}