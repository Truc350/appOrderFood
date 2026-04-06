import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/search_screen.dart';

class SearchDropdown extends StatefulWidget {
  final String? initialQuery;
  final Function(String)? onSearch; // if provided, overrides the default navigation
  final bool autoFocus;

  const SearchDropdown({
    super.key,
    this.initialQuery,
    this.onSearch,
    this.autoFocus = false,
  });

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  Timer? _debounceTimer;

  bool _isLoadingProducts = false;
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _filteredProducts = [];
  List<String> _searchHistory = [];
  
  final List<String> _popularKeywords = [
    'Cơm tấm', 'Phở', 'Bún bò', 'Gà rán', 'Trà sữa', 'Pizza'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _controller.text = widget.initialQuery!;
    }
    _loadHistory();
    _loadProducts();
    
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _hideOverlay();
      }
    });
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _searchHistory = prefs.getStringList('search_history') ?? [];
    });
  }

  Future<void> _saveHistory(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_history') ?? [];
    
    // Remove if exists to move to top
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    history.insert(0, query.trim());
    
    // Keep max 10
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }
    
    await prefs.setStringList('search_history', history);
    setState(() {
      _searchHistory = history;
    });
  }

  Future<void> _removeHistoryItem(String query) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('search_history') ?? [];
    history.remove(query);
    await prefs.setStringList('search_history', history);
    setState(() {
      _searchHistory = history;
    });
    // rebuild overlay if opened
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _clearAllHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    setState(() {
      _searchHistory = [];
    });
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoadingProducts = true);
    try {
      final String response = await rootBundle.loadString('assets/products.json');
      final List<dynamic> data = json.decode(response);
      _allProducts = data.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint("Error loading products for search: $e");
    } finally {
      if (mounted) setState(() => _isLoadingProducts = false);
    }
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      _filterProducts(value);
      if (_overlayEntry != null) {
        _overlayEntry!.markNeedsBuild();
      }
    });
  }

  void _filterProducts(String query) {
    if (query.trim().isEmpty) {
      _filteredProducts = [];
      return;
    }
    final lowercaseQuery = query.toLowerCase();
    _filteredProducts = _allProducts.where((product) {
      final name = (product['name'] as String).toLowerCase();
      // we can match by name or category maybe, but sticking to name for highlight
      return name.contains(lowercaseQuery);
    }).take(5).toList(); // only show top 5 suggestions
  }

  void _submitSearch(String query) {
    if (query.trim().isEmpty) return;
    
    _focusNode.unfocus(); // hides overlay
    _saveHistory(query);

    if (widget.onSearch != null) {
      widget.onSearch!(query);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchScreen(initialQuery: query),
        ),
      );
    }
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: size.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(0.0, size.height + 5.0),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              clipBehavior: Clip.antiAlias,
              child: _buildOverlayContent(),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildOverlayContent() {
    final query = _controller.text;
    if (query.trim().isEmpty) {
      // Show History and Popular keys
      return ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 350),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_searchHistory.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Lịch sử tìm kiếm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      GestureDetector(
                        onTap: _clearAllHistory,
                        child: Text('Xoá tất cả', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                ..._searchHistory.map((item) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, size: 20, color: Colors.grey),
                  title: Text(item, style: const TextStyle(fontSize: 14)),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                    onPressed: () => _removeHistoryItem(item),
                  ),
                  onTap: () {
                    _controller.text = item;
                    _submitSearch(item);
                  },
                )),
                const Divider(),
              ],
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Text('Từ khóa phổ biến', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _popularKeywords.map((keyword) {
                    return GestureDetector(
                      onTap: () {
                        _controller.text = keyword;
                        _submitSearch(keyword);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(keyword, style: const TextStyle(fontSize: 12)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    } else {
      // Show Search Results / Suggestions
      if (_isLoadingProducts) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (_filteredProducts.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Text('Không tìm thấy kết quả phù hợp', style: TextStyle(color: Colors.grey)),
          ),
        );
      }

      return ConstrainedBox(
         constraints: const BoxConstraints(maxHeight: 350),
         child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product['imageUrl'],
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 40, height: 40, color: Colors.grey[200],
                      child: const Icon(Icons.fastfood, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
                title: _buildHighlightedText(product['name'], query),
                onTap: () {
                   _controller.text = product['name'];
                   _submitSearch(product['name']);
                },
              );
            },
         ),
      );
    }
  }

  Widget _buildHighlightedText(String text, String query) {
    if (query.isEmpty) return Text(text);
    
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    
    int startIndex = lowerText.indexOf(lowerQuery);
    if (startIndex == -1) {
      return Text(text);
    }

    int endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87, fontSize: 14),
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE53935)), // Theme Red
          ),
          TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: widget.autoFocus,
          onChanged: (val) {
            _onSearchChanged(val);
            if (val.isEmpty && _overlayEntry != null) {
               _overlayEntry!.markNeedsBuild();
            }
          },
          onSubmitted: _submitSearch,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm món ăn mà bạn thích...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
            suffixIcon: _controller.text.isNotEmpty 
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                  onPressed: () {
                    _controller.clear();
                    _onSearchChanged('');
                    if (_overlayEntry != null) _overlayEntry!.markNeedsBuild();
                    setState(() {});
                  },
                )
              : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE53935)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
