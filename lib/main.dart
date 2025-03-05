import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/post_provider.dart';
import 'screens/create_post_screen.dart';
import 'screens/post_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (context) => PostProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ElectroSeedCoin",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton(
              context,
              title: "Create a Post",
              icon: Icons.add_photo_alternate_rounded,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreatePostScreen()),
                  ),
            ),
            SizedBox(height: 20),
            _buildActionButton(
              context,
              title: "View Posts",
              icon: Icons.feed_rounded,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostScreen()),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Card(
        elevation: 5,
        color: Colors.grey[850],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
