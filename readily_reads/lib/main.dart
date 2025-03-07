import 'package:flutter/material.dart';
import 'add_book_page.dart';
import 'splash_screen.dart'; // Import the new splash screen file

void main() {
  runApp(const ReadilyReads());
}

class ReadilyReads extends StatelessWidget {
  const ReadilyReads({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Readily Reads',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home:
          const SplashScreen(), // Start with the splash screen instead of login page
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Readily Reads'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 80,
              color: Colors.blue,
            ),
            SizedBox(height: 24),
            Text(
              'Welcome to Readily Reads',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Your personal reading habit tracker',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Readily Reads'),
            ),
            ListTile(
              title: const Text('Books'),
              onTap: () {
                // Navigate to books page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Books page coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Authors'),
              onTap: () {
                // Navigate to authors page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Authors page coming soon!'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Genres'),
              onTap: () {
                // Navigate to genres page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Genres page coming soon!'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new book action
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookPage()),
          );
        },
        tooltip: 'Add Book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
