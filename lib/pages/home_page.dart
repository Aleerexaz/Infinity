import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_project/buttons/create_button.dart';
import 'package:new_project/actions/generate_image.dart';
import 'package:new_project/helper/my_dialogue.dart';
import 'package:new_project/widget/custon_loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';

final _c = ImageController(); // Initialize the controller globally

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _aiImage() {
    return Obx(() {
      switch (_c.status.value) {
        case Status.none:
          return Text(
            _c.errorMessage.isEmpty
                ? 'No image generated yet.'
                : _c.errorMessage,
            style: TextStyle(
              color: _c.errorMessage.isEmpty ? Colors.grey : Colors.red,
            ),
            textAlign: TextAlign.center,
          );
        case Status.loading:
          return const CustomLoading(); // Show loading animation
        case Status.complete:
          return GestureDetector(
            onTap: () {
              // Open the full-screen image on tap
              Get.to(() => FullScreenImage(imageUrl: _c.url));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: _c.url,
                fit: BoxFit.cover, // Ensures the image covers the container
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => const CustomLoading(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              ),
            ),
          );

        default:
          return const Text(
            'Unknown state.',
            style: TextStyle(color: Colors.red),
          );
      }
    });
  }

  Future<void> _downloadImage(String imageUrl) async {
    // Check for storage permissions
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    // Create the directory to save images
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/infinityImage';
    await Directory(path).create(recursive: true);

    // Save the image to the directory
    final response = await HttpClient().getUrl(Uri.parse(imageUrl));
    final bytes = await response
        .close()
        .then((resp) => resp.fold<List<int>>([], (a, b) => a..addAll(b)));

    final file = File('$path/${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes);

    // Save to gallery
    final result = await ImageGallerySaver.saveFile(file.path);
    if (result['isSuccess']) {
      Get.snackbar('Success', 'Image saved to gallery!',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to save image.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedTextField(),
                ),
                const SizedBox(height: 30),
                CreateButton(
                  text: 'Generate',
                  onPressed: () => _c.createImage(),
                ),
                const SizedBox(height: 40),
                Container(
                  width: 300,
                  height: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 50, 50, 50),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _aiImage(),
                ),
                const SizedBox(
                    height: 20), // Space between the image and button
                Obx(() {
                  if (_c.status.value == Status.complete) {
                    return ElevatedButton(
                      onPressed: () => _downloadImage(_c.url),
                      child: const Text('Download Image'),
                    );
                  } else {
                    return SizedBox
                        .shrink(); // Empty space if no image is generated
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedTextField extends StatefulWidget {
  const AnimatedTextField({super.key});

  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: Colors.purple,
      end: Colors.cyan,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 270,
          height: 130,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 2,
              color: _animation.value ?? Colors.blue,
            ),
          ),
          child: TextField(
            controller: _c.textC,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter text',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            cursorColor: Colors.white,
          ),
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          child: SizedBox.expand(
            // Ensures the image expands to the screen
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit
                  .cover, // Change to BoxFit.contain if you don't want cropping
              placeholder: (context, url) => const CustomLoading(),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
