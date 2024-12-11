
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'blog_detail_screen.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<dynamic> blogs = [];
  List<dynamic> userBlogs = [];
  String apiUrl = 'https://newsapi.org/v2/everything?q=health&apiKey=5b7887b949f74244a5ecb25506ce83c8';
  TextEditingController searchController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBlogs();
  }

  Future<void> fetchBlogs([String query = '']) async {
    final response = await http.get(Uri.parse('$apiUrl&q=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        blogs = data['articles'];
      });
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  void addBlog(String title, String content) {
    setState(() {
      userBlogs.insert(0, {'title': title, 'content': content, 'isUserBlog': true});
    });
  }

  void deleteBlog(int index) {
    setState(() {
      userBlogs.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search for blogs...',
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.blueAccent),
                  onPressed: () {
                    fetchBlogs(searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blogs.length + userBlogs.length,
              itemBuilder: (context, index) {
                final blog = index < userBlogs.length
                    ? userBlogs[index]
                    : blogs[index - userBlogs.length];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.purple[50],
                  child: ListTile(
                    title: Text(
                      blog['title'] ?? 'No Title',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      blog['content'] != null
                          ? (blog['content'].length > 100
                          ? blog['content'].substring(0, 100) + '...'
                          : blog['content'])
                          : 'No Content',
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailScreen(blog: blog),
                        ),
                      );
                    },
                    trailing: blog['isUserBlog'] == true
                        ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteBlog(index),
                    )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBlogDialog(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddBlogDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add a Blog',
          style: TextStyle(color: Colors.blueAccent),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: contentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Content',
                filled: true,
                fillColor: Colors.purple[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              addBlog(titleController.text, contentController.text);
              titleController.clear();
              contentController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Post', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}







//
// //blog_screen.dart
// import 'package:flutter/material.dart';
// // http : enable to api calls
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// //Imports the BlogDetailScreen widget for navigation to a detailed blog view.
// import 'blog_detail_screen.dart';
//
// class BlogScreen extends StatefulWidget {
//   @override
//   _BlogScreenState createState() => _BlogScreenState();
// }
//
// class _BlogScreenState extends State<BlogScreen> {
//   List<dynamic> blogs = [];    // Stores blogs fetched from the News API.
//   List<dynamic> userBlogs = [];  // Stores blogs added by the user locally
//   String apiUrl = 'https://newsapi.org/v2/everything?q=health&apiKey=5b7887b949f74244a5ecb25506ce83c8';
//   TextEditingController searchController = TextEditingController();
//   TextEditingController titleController = TextEditingController();  // this will manage title of user blog
//   TextEditingController contentController = TextEditingController();  // user content
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBlogs();   // fetches the blog
//   }
//
//   Future<void> fetchBlogs([String query = '']) async {
//     final response = await http.get(Uri.parse('$apiUrl&q=$query'));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         blogs = data['articles'];
//       });
//     } else {
//       throw Exception('Failed to load blogs');
//     }
//   }
//
//   void addBlog(String title, String content) {
//     setState(() {
//       userBlogs.insert(0, {'title': title, 'content': content, 'isUserBlog': true});
//     });
//   }
//
//   void deleteBlog(int index) {
//     setState(() {
//       userBlogs.removeAt(index);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Blog Page'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search for blogs...',
//                 suffixIcon: IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: () {
//                     fetchBlogs(searchController.text);
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: blogs.length + userBlogs.length,
//               itemBuilder: (context, index) {
//                 final blog = index < userBlogs.length
//                     ? userBlogs[index]
//                     : blogs[index - userBlogs.length];
//
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(
//                     title: Text(blog['title'] ?? 'No Title'),
//                     subtitle: Text(blog['content'] != null
//                         ? (blog['content'].length > 100
//                         ? blog['content'].substring(0, 100) + '...'
//                         : blog['content'])
//                         : 'No Content'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BlogDetailScreen(blog: blog),
//                         ),
//                       );
//                     },
//                     trailing: blog['isUserBlog'] == true
//                         ? IconButton(
//                       icon: const Icon(Icons.delete),
//                       onPressed: () => deleteBlog(index),
//                     )
//                         : null,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showAddBlogDialog(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   void _showAddBlogDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add a Blog'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(hintText: 'Title'),
//             ),
//             TextField(
//               controller: contentController,
//               decoration: const InputDecoration(hintText: 'Content'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               addBlog(titleController.text, contentController.text);
//               titleController.clear();
//               contentController.clear();
//               Navigator.of(context).pop();
//             },
//             child: const Text('Post'),
//           ),
//         ],
//       ),
//     );
//   }
// }
