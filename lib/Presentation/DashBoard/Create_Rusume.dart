import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRusume extends StatefulWidget {
  const CreateRusume({Key? key}) : super(key: key);

  @override
  State<CreateRusume> createState() => _CreateRusumeState();
}

class _CreateRusumeState extends State<CreateRusume> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }
  Future<void> saveResumeData() async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uid = generateRandomString(30);

    var data =   await FirebaseFirestore.instance.collection('UserResume').doc(uid).set({
        'uid': uid,
        'name': nameController.text,
        'email': emailController.text,
        'education': educationController.text,
        'experience': experienceController.text,
        'skills': skillsController.text,

      });

      print('Resume data saved successfully!');

      prefs.setString("uid", uid);
      Fluttertoast.showToast(
        msg: "Resume Created Successfully",
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 5,
      );
    } catch (e) {

      print('Error saving resume data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Resume'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Text('Personal Information', style: Theme.of(context).textTheme.headline6),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 16),

              // Education
              Text('Education', style: Theme.of(context).textTheme.headline6),
              TextFormField(
                controller: educationController,
                decoration: InputDecoration(labelText: 'Education Details'),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Work Experience
              Text('Work Experience', style: Theme.of(context).textTheme.headline6),
              TextFormField(
                controller: experienceController,
                decoration: InputDecoration(labelText: 'Work Experience'),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Skills
              Text('Skills', style: Theme.of(context).textTheme.headline6),
              TextFormField(
                controller: skillsController,
                decoration: InputDecoration(labelText: 'Skills'),
                maxLines: 3,
              ),
              SizedBox(height: 16),

              // Save Button
              ElevatedButton(
                onPressed: () async {

                  await saveResumeData();
                },
                child: Text('Save Resume'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
