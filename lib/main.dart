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
      home: const WelcomeScreen(),
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
            // Botón para probar la función
            ElevatedButton.icon(
              onPressed: completeTask, // Llama la función aquí
              icon: const Icon(Icons.check),
              label: const Text('Completar tarea'),
            ),
            const SizedBox(height: 24),
            // Botón para probar la función
            ElevatedButton.icon(
              onPressed: addTask, // Llama la función aquí
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
          ],
        ),
      ),
    );
  }
}