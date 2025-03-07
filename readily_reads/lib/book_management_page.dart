import 'package:flutter/material.dart';
import 'book_model.dart';
import 'user_session.dart';

class BookManagementPage extends StatefulWidget {
  const BookManagementPage({Key? key}) : super(key: key);

  @override
  _BookManagementPageState createState() => _BookManagementPageState();
}

class _BookManagementPageState extends State<BookManagementPage>
    with SingleTickerProviderStateMixin {
  final BookService _bookService = BookService();
  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  List<Book> _currentlyReadingBooks = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  late TabController _tabController;

  // Filter options
  String _selectedGenre = 'All Genres';
  List<String> _genres = ['All Genres'];
  String _sortBy = 'Title (A-Z)';
  final List<String> _sortOptions = [
    'Title (A-Z)',
    'Title (Z-A)',
    'Author (A-Z)',
    'Author (Z-A)',
    'Recently Added'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadBooks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {}); // Refresh UI when tab changes
    }
  }

  Future<void> _loadBooks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final userId = await UserSession.getCurrentUserId();

      if (userId != null) {
        // Load all books
        final allBooks = await _bookService.getAllBooks(userId);
        // Load currently reading books
        final currentlyReading =
            await _bookService.getCurrentlyReadingBooks(userId);

        // Extract unique genres
        Set<String> genreSet = {'All Genres'};
        for (var book in allBooks) {
          genreSet.add(book.genre);
        }

        setState(() {
          _allBooks = allBooks;
          _currentlyReadingBooks = currentlyReading;
          _filteredBooks = allBooks;
          _genres = genreSet.toList()..sort();
          _isLoading = false;
        });

        _applyFilters();
      } else {
        setState(() {
          _errorMessage = 'User session not found. Please log in again.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load books: $e';
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<Book> booksToFilter =
        _tabController.index == 0 ? _allBooks : _currentlyReadingBooks;

    // Apply genre filter
    if (_selectedGenre != 'All Genres') {
      booksToFilter =
          booksToFilter.where((book) => book.genre == _selectedGenre).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      booksToFilter = booksToFilter.where((book) {
        return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Title (A-Z)':
        booksToFilter.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Title (Z-A)':
        booksToFilter.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Author (A-Z)':
        booksToFilter.sort((a, b) => a.author.compareTo(b.author));
        break;
      case 'Author (Z-A)':
        booksToFilter.sort((a, b) => b.author.compareTo(a.author));
        break;
      case 'Recently Added':
        // Sort by ID (assuming higher ID means more recently added)
        booksToFilter.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
    }

    setState(() {
      _filteredBooks = booksToFilter;
    });
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  // Function to handle book deletion
  Future<void> _deleteBook(Book book) async {
    try {
      bool success = await _bookService.deleteBook(book.id!);
      if (success) {
        setState(() {
          _allBooks.removeWhere((b) => b.id == book.id);
          _currentlyReadingBooks.removeWhere((b) => b.id == book.id);
          _filteredBooks.removeWhere((b) => b.id == book.id);
        });
        _showSnackBar('Book deleted successfully', Colors.green);
      } else {
        _showSnackBar('Failed to delete book', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  // Function to update reading status
  Future<void> _toggleReadingStatus(Book book) async {
    // Create updated book with toggled reading status
    Book updatedBook = Book(
      id: book.id,
      title: book.title,
      author: book.author,
      genre: book.genre,
      pages: book.pages,
      description: book.description,
      publicationDate: book.publicationDate,
      isCurrentlyReading: !book.isCurrentlyReading,
      userId: book.userId,
    );

    try {
      bool success = await _bookService.updateBook(updatedBook);
      if (success) {
        setState(() {
          // Update book in lists
          int allIndex = _allBooks.indexWhere((b) => b.id == book.id);
          if (allIndex != -1) {
            _allBooks[allIndex] = updatedBook;
          }

          // Update in currently reading list
          if (updatedBook.isCurrentlyReading) {
            if (!_currentlyReadingBooks.any((b) => b.id == book.id)) {
              _currentlyReadingBooks.add(updatedBook);
            }
          } else {
            _currentlyReadingBooks.removeWhere((b) => b.id == book.id);
          }

          // Update in filtered list
          int filteredIndex = _filteredBooks.indexWhere((b) => b.id == book.id);
          if (filteredIndex != -1) {
            _filteredBooks[filteredIndex] = updatedBook;
          }
        });

        String message = updatedBook.isCurrentlyReading
            ? 'Added to currently reading'
            : 'Removed from currently reading';
        _showSnackBar(message, Colors.green);

        // If on Currently Reading tab and removed book, reapply filters
        if (_tabController.index == 1 && !updatedBook.isCurrentlyReading) {
          _applyFilters();
        }
      } else {
        _showSnackBar('Failed to update reading status', Colors.red);
      }
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  // Display a snackbar with message
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Books',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Books'),
            Tab(text: 'Currently Reading'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBooks,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingView(colorScheme)
          : _errorMessage.isNotEmpty
              ? _buildErrorView(colorScheme)
              : _buildMainView(colorScheme),
    );
  }

  Widget _buildLoadingView(ColorScheme colorScheme) {
    return Center(
      child: CircularProgressIndicator(
        color: colorScheme.primary,
      ),
    );
  }

  Widget _buildErrorView(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadBooks,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainView(ColorScheme colorScheme) {
    return Column(
      children: [
        // Search and filter section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              TextField(
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Search by title or author',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Filters row
              Row(
                children: [
                  // Genre dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGenre,
                      decoration: InputDecoration(
                        labelText: 'Genre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: _genres.map((genre) {
                        return DropdownMenuItem(
                          value: genre,
                          child: Text(
                            genre,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedGenre = value!;
                        });
                        _applyFilters();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Sort dropdown
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sortBy,
                      decoration: InputDecoration(
                        labelText: 'Sort By',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      items: _sortOptions.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(
                            option,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value!;
                        });
                        _applyFilters();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Results count
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredBooks.length} ${_filteredBooks.length == 1 ? 'book' : 'books'} found',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              if (_searchQuery.isNotEmpty || _selectedGenre != 'All Genres')
                TextButton.icon(
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Clear Filters'),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _selectedGenre = 'All Genres';
                    });
                    _applyFilters();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // Book list
        Expanded(
          child: _filteredBooks.isEmpty
              ? _buildEmptyView(colorScheme)
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = _filteredBooks[index];
                    return _buildBookCard(context, book);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyView(ColorScheme colorScheme) {
    String message = _tabController.index == 0
        ? 'No books found'
        : 'No books currently being read';

    String subMessage =
        _searchQuery.isNotEmpty || _selectedGenre != 'All Genres'
            ? 'Try changing your filters'
            : _tabController.index == 0
                ? 'Tap the + button to add your first book'
                : 'Mark a book as "Currently Reading" to see it here';

    IconData icon =
        _tabController.index == 0 ? Icons.menu_book : Icons.auto_stories;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 72,
                color: colorScheme.primary.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              subMessage,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Book book) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover placeholder
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.book,
                  size: 40,
                  color: colorScheme.primary.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Book details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: colorScheme.primary,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditPlaceholder();
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(book);
                          } else if (value == 'details') {
                            _showBookDetails(book);
                          } else if (value == 'reading') {
                            _toggleReadingStatus(book);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'details',
                            child: Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(width: 8),
                                Text('Details'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'reading',
                            child: Row(
                              children: [
                                Icon(Icons.auto_stories),
                                SizedBox(width: 8),
                                Text(book.isCurrentlyReading
                                    ? 'Remove from Reading'
                                    : 'Add to Reading'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Author
                  Text(
                    'by ${book.author}',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Genre and reading status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          book.genre,
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (book.isCurrentlyReading)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.auto_stories,
                                size: 12,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Reading Now',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Pages info
                  if (book.pages != null)
                    Text(
                      '${book.pages} pages',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Reading toggle button
                      OutlinedButton.icon(
                        icon: Icon(
                          book.isCurrentlyReading
                              ? Icons.check_circle
                              : Icons.auto_stories,
                          size: 16,
                        ),
                        label: Text(
                          book.isCurrentlyReading ? 'Reading' : 'Start Reading',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onPressed: () => _toggleReadingStatus(book),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: book.isCurrentlyReading
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          side: BorderSide(
                            color: book.isCurrentlyReading
                                ? colorScheme.primary
                                : colorScheme.outline,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Edit button
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                        onPressed: _showEditPlaceholder,
                        tooltip: 'Edit',
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),

                      // Delete button
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () => _showDeleteConfirmation(book),
                        tooltip: 'Delete',
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(Book book) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to delete "${book.title}"?'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteBook(book);
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show book details dialog
  void _showBookDetails(Book book) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Author: ${book.author}'),
              const SizedBox(height: 8),
              Text('Genre: ${book.genre}'),
              if (book.pages != null) ...[
                const SizedBox(height: 8),
                Text('Pages: ${book.pages}'),
              ],
              if (book.publicationDate != null) ...[
                const SizedBox(height: 8),
                Text('Published: ${_formatDate(book.publicationDate!)}'),
              ],
              if (book.description != null && book.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(book.description!),
              ],
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder for edit functionality
  void _showEditPlaceholder() {
    _showSnackBar('Edit functionality will be implemented soon', Colors.orange);
  }

  // Helper to format date
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
