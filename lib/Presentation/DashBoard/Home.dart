import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> resumeDataList = [];
  late String uid;

  @override
  void initState() {
    super.initState();
    fetchUid(); // Fetch UID when the widget initializes
  }

  Future<void> fetchUid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
    fetchResumeData(); // Fetch resume data after getting the UID
  }

  Future<void> fetchResumeData() async {
    try {
      var resumeData = await FirebaseFirestore.instance
          .collection('UserResume')
          .get();

      resumeDataList = resumeData.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['documentId'] = doc.id; // Add document ID to the data
        return data;
      }).toList();

      setState(() {});
      print('Resume data: $resumeDataList');
    } catch (e) {
      print('Error fetching resume data: $e');
    }
  }

  Future<void> updateOrderInDatabase() async {
    for (int i = 0; i < resumeDataList.length; i++) {
      await FirebaseFirestore.instance
          .collection('UserResume')
          .doc(resumeDataList[i]['documentId'])
          .update({'order': i});
    }
  }

  Future<void> updateField(String field, String value, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserResume')
          .doc(resumeDataList[index]['documentId'])
          .update({
        field: value,
      });

      fetchResumeData();
    } catch (e) {
      print('Error updating $field: $e');
    }
  }

  Future<void> deleteField(String field, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('UserResume')
          .doc(resumeDataList[index]['documentId'])
          .delete(); // Use delete() instead of update() for deleting the document

      fetchResumeData();
    } catch (e) {
      print('Error deleting $field: $e');
    }
  }

  Future<void> _showEditDialog(String field, int index) async {
    String editedValue = resumeDataList[index][field] ?? '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: TextFormField(
            initialValue: editedValue,
            onChanged: (value) {
              editedValue = value;
            },
            decoration: InputDecoration(labelText: field),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                updateField(field, editedValue, index);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(String field, int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $field'),
          content: Text('Are you sure you want to delete this $field?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteField(field, index);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resume List'),
      ),
      body: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final item = resumeDataList.removeAt(oldIndex);
          resumeDataList.insert(newIndex, item);

          updateOrderInDatabase(); // Update the order in the database after reordering
          setState(() {

          });
        },
        children: List.generate(
          resumeDataList.length,
              (index) {
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              key: Key('$index'),
              child: ListTile(
                onTap: () {
                  _showEditDialog('name', index);
                },
                title: Text(
                  resumeDataList[index]['name'] ?? 'No Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        _showEditDialog('email', index);
                      },
                      child: Text(
                        resumeDataList[index]['email'] ?? 'No Email',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        _showEditDialog('education', index);
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Education: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                              '${resumeDataList[index]['education'] ?? 'No Education'}',
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        _showEditDialog('experience', index);
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Experience : ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                              '${resumeDataList[index]['experience'] ?? 'Experience'}',
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        _showEditDialog('skills', index);
                      },
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Skills: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text:
                              '${resumeDataList[index]['skills'] ?? 'Skills'}',
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteDialog('profile', index);
                  },
                ),
                // Add the handle for reordering
                // leading: ReorderableDragStartListener(
                //   index: 1,
                //   child: Icon(Icons.drag_handle),
                // ),
              ),
            );
          },
        ),
      ),
    );
  }
}
