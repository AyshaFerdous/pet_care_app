import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Google Fonts
import '../models/pet_model.dart';
import 'dart:io';

class PetDetailsScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailsScreen({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int age = DateTime.now().year - DateTime.parse(pet.dateOfBirth).year;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Details'),
        backgroundColor: Colors.purple[50],
      ),
      body: Column(
        children: [
          // Top section for the image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(pet.photo)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Bottom section for details
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pet Name
                    Center(
                      child: Text(
                        pet.name,
                        style: GoogleFonts.archivoBlack(
                          textStyle: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // General Details
                    _buildDetailRow('Age', '$age years'),
                    _buildDetailRow('Breed', pet.breed),
                    _buildDetailRow('Color', pet.color),
                    // Additional Details in a Box
                    if (pet.additionalDetails != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.teal),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Additional Details',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                pet.additionalDetails!,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Vaccine Dates
                    if (pet.vaccineDates != null && pet.vaccineDates!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vaccine Dates:',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          ...pet.vaccineDates!.map(
                                (date) => Text(
                              date.toLocal().toString().split(' ')[0],
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
