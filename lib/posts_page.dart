import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<dynamic> _posts = [];

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
        });
        _printPosts();
      } else {
        print('Failed to fetch posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Page'),
      ),
      body: Center(
        child: Text('Hello World'),
      ),
    );
  }
}