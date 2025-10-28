import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Use TextEditingControllers to manage the input fields
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data (we'll use dummy data for now)
    _nameController = TextEditingController(text: "Sheldon Cooper");
    _emailController = TextEditingController(text: "sheldon.cooper@caltech.edu");
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          // Add a "Save" button to the AppBar
          TextButton(
            onPressed: () {
              // TODO: Implement save logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile saved successfully!')),
              );
              Navigator.of(context).pop(); // Go back to the previous screen
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // --- PROFILE PICTURE SECTION ---
            _buildProfilePicture(),
            const SizedBox(height: 32),

            // --- TEXT FIELDS SECTION ---
            _buildTextField(
              controller: _nameController,
              labelText: 'Full Name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _emailController,
              labelText: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the profile picture
  Widget _buildProfilePicture() {
    return Stack(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage(
              "https://i.pinimg.com/736x/1b/62/22/1b6222355866184a5699b3350f29a73e4.jpg"),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // TODO: Implement image picker logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change profile picture')),
              );
            },
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper widget for text fields to avoid code duplication
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
