// pet_model.dart
import 'package:flutter/material.dart';

class Pet {
  final int? id;
  final String name;
  final String photo;
  final String breed;
  final String color;
  final String dateOfBirth;
  final String? additionalDetails;
  final List<DateTime>? vaccineDates;

  Pet({
    this.id,
    required this.name,
    required this.photo,
    required this.breed,
    required this.color,
    required this.dateOfBirth,
    this.additionalDetails,
    this.vaccineDates,
  });

  // Convert Pet object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'breed': breed,
      'color': color,
      'date_of_birth': dateOfBirth,
      'additional_details': additionalDetails,
      'vaccine_dates': vaccineDates != null
          ? vaccineDates!.map((date) => date.toIso8601String()).join(',')
          : null,
    };
  }

  // Convert Map to Pet object
  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      photo: map['photo'],
      breed: map['breed'],
      color: map['color'],
      dateOfBirth: map['date_of_birth'],
      additionalDetails: map['additional_details'],
      vaccineDates: map['vaccine_dates'] != null
          ? (map['vaccine_dates'] as String)
          .split(',')
          .map((date) => DateTime.parse(date))
          .toList()
          : null,
    );
  }
}
