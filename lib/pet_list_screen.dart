import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'add_edit_pet_screen.dart';
import 'pet_details_screen.dart';
import 'database/db_helper.dart';
import 'models/pet_model.dart';

class PetListScreen extends StatefulWidget {
  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Pet> _pets = [];

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    final pets = await DBHelper().fetchPets();
    setState(() {
      _pets = pets;
    });
  }


  Future<void> _addOrEditPet({pet}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditPetScreen(pet: pet)),
    );
    _loadPets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Care Organizer',
          style: GoogleFonts.cabin( // Replace 'lato' with your preferred font
            textStyle: TextStyle(
              color: Colors.black, // Customize the color if needed
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.purple[50],
        iconTheme: IconThemeData(color: Colors.black), // Ensures icons match the title color
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _pets.length,
          itemBuilder: (context, index) {
            final pet = _pets[index];
            return ListTile(
              leading: Image.file(File(pet.photo), width: 50, height: 50, fit: BoxFit.cover),
              title: Text(pet.name),
              subtitle: Text(
                  'Age: ${DateTime.now().year - DateTime.parse(pet.dateOfBirth).year} years\nColor: ${pet.color ?? 'Unknown'}'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PetDetailsScreen(pet: pet)),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEditPetScreen(pet: pet)),
                  );
                  _loadPets();
                },
              ),
            );

          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditPet(),
        child: Icon(Icons.add),
      ),
    );
  }
}
