
// medical_history_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class MedicalHistoryScreen extends StatefulWidget {
  @override
  _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  List<Map<String, dynamic>> _images = [];
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final databasePath = path.join(databasesPath, 'medical_history.db');
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE images (id INTEGER PRIMARY KEY, name TEXT, date TEXT, path TEXT)',
        );
      },
    );

    _loadImages();
  }

  Future<void> _loadImages() async {
    final List<Map<String, dynamic>> maps = await _database?.query('images') ?? [];
    setState(() {
      _images = maps;
    });
  }

  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();  //change from get to pickImage
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _showImageDetailsDialog(File(pickedFile.path));
    }
  }

  void _showImageDetailsDialog(File imageFile) {
    final nameController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Image Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Image Name'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date (MM/dd/yyyy)'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final dateText = dateController.text.trim();

                if (name.isNotEmpty && dateText.isNotEmpty) {
                  try {
                    // Log the dateText for debugging
                    print("Entered date: $dateText");

                    // Ensure date format is MM/dd/yyyy using parseStrict
                    final date = DateFormat('MM/dd/yyyy').parseStrict(dateText);
                    print("Parsed date: $date"); // Debugging line

                    await _saveImage(imageFile, name, date);
                    Navigator.of(context).pop();
                  } catch (e) {
                    print("Error: $e"); // Debugging line to show parse errors

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid date format. Please use MM/dd/yyyy."),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in both name and date.")),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }


  // only

  Future<void> _saveImage(File imageFile, String name, DateTime date) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final localImage = await imageFile.copy('${appDir.path}/$imageName');

    final formattedDate = DateFormat.yMd().format(date);
    await _database?.insert('images', {
      'name': name,
      'date': formattedDate,
      'path': localImage.path,
    });

    _loadImages();
  }

  Future<void> _deleteImage(int id) async {
    await _database?.delete('images', where: 'id = ?', whereArgs: [id]);
    _loadImages();
  }

  void _showFullScreenImage(String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(File(imagePath)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _pickAndSaveImage,
              child: const Text('Upload Image'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final image = _images[index];
                  final imageName = image['name'] ?? 'Unknown';
                  final imageDate = image['date'] ?? 'Unknown';

                  return Card(
                    child: ListTile(
                      leading: Image.file(
                        File(image['path'] ?? ''),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(imageName),
                      subtitle: Text(imageDate),
                      onTap: () {
                        _showFullScreenImage(image['path'] ?? '');
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _deleteImage(image['id']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final File image;

  const FullScreenImageView(this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.file(image),
        ),
      ),
    );
  }
}




// medical_history_screen.dart


// //this code working quite good  3 *

//this code is working
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as path;
// import 'package:sqflite/sqflite.dart';
//
// class MedicalHistoryScreen extends StatefulWidget {
//   @override
//   _MedicalHistoryScreenState createState() => _MedicalHistoryScreenState();
// }
//
// class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
//   List<String> _imagePaths = [];
//   Database? _database;
//
//   @override
//   void initState() {
//     super.initState();
//     _initDatabase();
//     _loadImagePaths();
//   }
//
//   Future<void> _initDatabase() async {
//     // Create a new SQLite database or open an existing one
//     final databasesPath = await getDatabasesPath();
//     final databasePath = path.join(databasesPath, 'medical_history.db');
//     _database = await openDatabase(
//       databasePath,
//       version: 1,
//       onCreate: (db, version) {
//         // Create a table to store image paths
//         return db.execute(
//           'CREATE TABLE images (id INTEGER PRIMARY KEY, path TEXT)',
//         );
//       },
//     );
//   }
//
//   Future<void> _loadImagePaths() async {
//     // Retrieve the image paths from the database
//     final List<Map<String, dynamic>> maps = await _database!.query('images');
//     setState(() {
//       _imagePaths = maps.map((map) => map['path'] as String).toList();
//     });
//   }
//
//   Future<void> _pickAndSaveImage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       final appDir = await getApplicationDocumentsDirectory();
//       final imageName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
//       final localImage = File('${appDir.path}/$imageName');
//       await localImage.writeAsBytes(await pickedFile.readAsBytes());
//
//       // Save the image path to the database
//       await _database!.insert('images', {'path': localImage.path});
//       setState(() {
//         _imagePaths.add(localImage.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medical History'),
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _pickAndSaveImage,
//             child: const Text('Upload Image'),
//           ),
//           const SizedBox(height: 16.0),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 8.0,
//                 mainAxisSpacing: 8.0,
//               ),
//               itemCount: _imagePaths.length,
//               itemBuilder: (context, index) {
//                 return Image.file(
//                   File(_imagePaths[index]),
//                   fit: BoxFit.cover,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

