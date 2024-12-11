import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Status { none, loading, complete }

class ImageController extends GetxController {
  final textC = TextEditingController();//
  final status = Status.none.obs;
  String url = '';
  String errorMessage = '';

  // OpenAI API Key (Replace with your actual API key)
  final openAiApiKey =
      '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'; // Replace this with your OpenAI API Key

  Future<void> createImage() async {
    if (textC.text.trim().isEmpty) {
      errorMessage = 'Prompt cannot be empty.';
      status.value = Status.none;
      update();
      return;
    }

    try {
      status.value = Status.loading;
      update();

      // OpenAI DALL-E API Endpoint
      final uri = Uri.parse("https://api.openai.com/v1/images/generations");

      final body = jsonEncode({
        "prompt": textC.text.trim(),
        "n": 1, // Number of images to generate
        "size": "1024x1024" // Size of the image
      });

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $openAiApiKey",
          "Content-Type": "application/json",
        },
        body: body,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          url = data['data'][0]['url']; // Extract the image URL
          errorMessage = '';
          status.value = Status.complete;
        } else {
          errorMessage = 'No image URL found in the response.';
          status.value = Status.none;
        }
      } else {
        final errorData = jsonDecode(response.body);
        errorMessage =
            "Error: ${response.statusCode} - ${errorData['error']['message'] ?? 'Unknown error'}";
        status.value = Status.none;
      }
    } catch (e) {
      status.value = Status.none;
      errorMessage = "Error: ${e.toString()}";
    }
    update();
  }
}
