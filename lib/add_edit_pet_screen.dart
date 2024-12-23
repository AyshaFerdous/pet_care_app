import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'models/pet_model.dart';
import 'database/db_helper.dart';

class AddEditPetScreen extends StatefulWidget {
  final Pet? pet;

  AddEditPetScreen({this.pet});

  @override
  _AddEditPetScreenState createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _additionalDetailsController = TextEditingController();
  String? _photoPath;
  DateTime? _selectedDate;
  List<DateTime> _vaccineDates = [];

  @override
  void initState() {
    super.initState();
    if (widget.pet != null) {
      _nameController.text = widget.pet!.name;
      _breedController.text = widget.pet!.breed;
      _colorController.text = widget.pet!.color ?? '';
      _additionalDetailsController.text = widget.pet!.additionalDetails ?? '';
      _photoPath = widget.pet!.photo;
      _selectedDate = DateTime.parse(widget.pet!.dateOfBirth);
      if (widget.pet!.vaccineDates != null) {
        _vaccineDates = widget.pet!.vaccineDates!;
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickVaccineDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _vaccineDates.add(pickedDate);
      });
    }
  }

  Future<void> _savePet() async {
    if (_nameController.text.isNotEmpty &&
        _breedController.text.isNotEmpty &&
        _photoPath != null &&
        _selectedDate != null) {
      final pet = Pet(
        id: widget.pet?.id,
        name: _nameController.text,
        photo: _photoPath!,
        breed: _breedController.text,
        color: _colorController.text,
        dateOfBirth: _selectedDate!.toIso8601String(),
        additionalDetails: _additionalDetailsController.text,
        vaccineDates: _vaccineDates.isNotEmpty ? _vaccineDates : null,
      );

      if (widget.pet == null) {
        await DBHelper().insertPet(pet);
      } else {
        await DBHelper().updatePet(pet);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet == null ? 'Add New Pet' : 'Edit Pet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Pet Name'),
              ),
              TextField(
                controller: _breedController,
                decoration: InputDecoration(labelText: 'Breed'),
              ),
              TextField(
                controller: _colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: _additionalDetailsController,
                decoration: InputDecoration(
                  labelText: 'Additional Details',
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              Row(
                children: [
                  ElevatedButton(onPressed: _pickDate, child: Text('Select Date of Birth')),
                  SizedBox(width: 10),
                  Text(
                    _selectedDate == null
                        ? 'No date selected'
                        : '${_selectedDate!.toLocal()}'.split(' ')[0],
                  ),
                ],
              ),
              ElevatedButton(onPressed: _pickImage, child: Text('Select Photo')),
              if (_photoPath != null)
                Image.file(
                  File(_photoPath!),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _pickVaccineDate, child: Text('Add Vaccine Date')),
              if (_vaccineDates.isNotEmpty)
                Column(
                  children: _vaccineDates.map((date) {
                    return Text(
                      'Vaccine Date: ${date.toLocal()}'.split(' ')[0],
                      style: TextStyle(fontSize: 20),
                    );
                  }).toList(),
                ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _savePet, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
