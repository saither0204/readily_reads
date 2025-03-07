import 'package:flutter/material.dart';
import 'package:readily_reads/book_model.dart';
import 'package:readily_reads/user_session.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  _AddBookPageState createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool showForm = false;
  DateTime? publicationDate;
  bool isCurrentlyReading = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Book',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.1),
              Colors.white,
            ],
            stops: const [0.0, 0.2],
          ),
        ),
        child: showForm ? _buildBookForm(context) : _buildInitialView(context),
      ),
    );
  }

  Widget _buildInitialView(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                showForm = true;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.surface,
                    colorScheme.tertiaryContainer.withOpacity(0.3),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add_circle_outline,
                      size: 80,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Add a new book to your library',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tap to start tracking your next great read',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        showForm = true;
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Book'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookForm(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Form title
              Text(
                'Book Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Book cover placeholder
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 48,
                        color: colorScheme.primary.withOpacity(0.6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Cover Image',
                        style: TextStyle(
                          color: colorScheme.primary.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Title field with custom decoration
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter book title',
                  prefixIcon: Icon(Icons.book, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Author field
              TextField(
                controller: authorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  hintText: 'Enter author name',
                  prefixIcon: Icon(Icons.person, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Genre field
              TextField(
                controller: genreController,
                decoration: InputDecoration(
                  labelText: 'Genre',
                  hintText: 'Enter book genre',
                  prefixIcon: Icon(Icons.category, color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
              ),
              const SizedBox(height: 16),

              // Pages field
              TextField(
                controller: pagesController,
                decoration: InputDecoration(
                  labelText: 'Pages',
                  hintText: 'Enter number of pages',
                  prefixIcon: Icon(Icons.format_list_numbered,
                      color: colorScheme.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Publication date picker
              GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: colorScheme.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      publicationDate = picked;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                    color: colorScheme.surface,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        publicationDate == null
                            ? 'Publication Date (Optional)'
                            : 'Published: ${publicationDate!.day}/${publicationDate!.month}/${publicationDate!.year}',
                        style: TextStyle(
                          color: publicationDate == null
                              ? Colors.grey.shade600
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Currently reading switch
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorScheme.tertiaryContainer.withOpacity(0.3),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Currently Reading',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    'Mark this book as currently being read',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  value: isCurrentlyReading,
                  onChanged: (bool value) {
                    setState(() {
                      isCurrentlyReading = value;
                    });
                  },
                  secondary: Icon(
                    Icons.auto_stories,
                    color: colorScheme.primary,
                  ),
                  activeColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description field
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter book description (optional)',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: colorScheme.surface,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          showForm = false;
                        });
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _isLoading ? null : _saveBook,
                      icon: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(_isLoading ? 'Saving...' : 'Save'),
                      style: FilledButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveBook() async {
    final String title = titleController.text.trim();
    final String author = authorController.text.trim();
    final String genre = genreController.text.trim();

    if (title.isEmpty || author.isEmpty || genre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID from session
      int? currentUserId = await UserSession.getCurrentUserId();

      if (currentUserId == null) {
        _showErrorSnackBar('User session not found. Please log in again.');
        return;
      }

      // Create book object
      final book = Book(
        title: title,
        author: author,
        genre: genre,
        pages: pagesController.text.isNotEmpty
            ? int.tryParse(pagesController.text)
            : null,
        description: descriptionController.text.isNotEmpty
            ? descriptionController.text
            : null,
        publicationDate: publicationDate,
        isCurrentlyReading: isCurrentlyReading,
        userId: currentUserId,
      );

      // Save book to database
      final BookService bookService = BookService();
      final success = await bookService.addBook(book);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Book added successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Return true to indicate that a book was added (for refreshing the list)
        Navigator.pop(context, true);
      } else {
        _showErrorSnackBar('Failed to add book. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    genreController.dispose();
    pagesController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
