import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<dynamic> _posts = [];
  bool _isLoading = true;
  Map<int, int> _ratings = {};
  bool _showFiltered = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://jsonplaceholder.typicode.com/posts');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _posts = data;
          _isLoading = false;
        });
      } else {
        print('Failed to fetch posts');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _setRating(int postId, int rating) {
    setState(() {
      _ratings[postId] = rating;
    });
  }

  List<dynamic> getSortedPosts() {
    List<dynamic> sortedPosts = List.from(_posts);
    sortedPosts.sort((a, b) {
      final int ratingA = _ratings[a['id']] ?? 0;
      final int ratingB = _ratings[b['id']] ?? 0;
      return ratingB.compareTo(ratingA);
    });
    return sortedPosts;
  }

  List<dynamic> getSortedPostsBackwards() {
    List<dynamic> sortedPosts = List.from(_posts);
    sortedPosts.sort((a, b) {
      final int ratingA = _ratings[b['id']] ?? 0;
      final int ratingB = _ratings[a['id']] ?? 0;
      return ratingB.compareTo(ratingA);
    });
    return sortedPosts;
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> postsToShow = _showFiltered ? getSortedPostsBackwards() : getSortedPosts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Page'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showFiltered = !_showFiltered;
                });
              },
              child: Text(_showFiltered ? 'ver mejores scores' : 'ver peores scores'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: postsToShow.length,
              itemBuilder: (context, index) {
                final post = postsToShow[index];
                final postId = post['id'];
                final rating = _ratings[postId] ?? 0;

                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'estrellas: $rating',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text(post['body']),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: List.generate(
                                5,
                                    (index) => IconButton(
                                  onPressed: () => _setRating(postId, index + 1),
                                  icon: Icon(
                                    Icons.star,
                                    color: index < rating ? Colors.amber : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
