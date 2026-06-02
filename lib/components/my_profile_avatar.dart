import 'dart:convert';
import 'package:flutter/material.dart';

class MyProfileAvatar extends StatelessWidget {
  final String? profileUrl;
  final double size;

  //constructor
  const MyProfileAvatar({
    super.key,
    required this.profileUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: Colors.grey.shade400,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    //builds the image
    final url = profileUrl ?? '';

    //check if url not empty
    if (url.isNotEmpty && url.startsWith('data:image')) {
      final bytes = base64Decode(url
          .split(',')
          .last);
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        width: size,
        height: size,
      );
    }

    return Icon(
      Icons.person_4_outlined,
      size: size / 2,
      color: Colors.grey.shade500,
    );
  }

}