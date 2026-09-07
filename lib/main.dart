import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart' as firebase_db;
import 'package:mappls_gl/mappls_gl.dart';
import 'issue_report.dart';
import 'report_provider.dart';
import 'firebase_options.dart';

List<CameraDescription> _cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ReportProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InfraCare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB089FF)),
        useMaterial3: true,
      ),
      home: const WelcomePage(), // Always show WelcomePage, no admin console
    );
  }
}
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD7C3FF), Color(0xFF7B42FF)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                image: const DecorationImage(
                  image: AssetImage('assets/logo1.png'), 
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Text(
                  'InfraCare',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
            const SizedBox(height: 30),
            // The Description
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Turning reports into repairs.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300),
              ),
            ),
            const SizedBox(height: 60),
            // Button to navigate to Login
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF7B42FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // The gradient background
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD7C3FF), 
              Color(0xFF915DFF), 
              Color(0xFF7B42FF), 
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                // Logo placeholder
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    image: const DecorationImage(
                      image: AssetImage('assets/logo1.png'), 
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'InfraCare Hello',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 60),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Username field
                const TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Password field
                const TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                  const SizedBox(height: 30),
                const SizedBox(height: 60),
                // Log In Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Reverting to local dashboard navigation
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF915DFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GeneralSignUpForm()),
                    );
                  },
                  child: const Text("Don't have an account? Sign Up", 
                    style: TextStyle(color: Colors.white70)),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GeneralSignUpForm extends StatefulWidget {
  const GeneralSignUpForm({super.key});

  @override
  State<GeneralSignUpForm> createState() => _GeneralSignUpFormState();
}

class _GeneralSignUpFormState extends State<GeneralSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD7C3FF), 
              Color(0xFF915DFF), 
              Color(0xFF7B42FF), 
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Glow for Glass Effect
            Positioned(
              top: -100,
              left: -100,
              child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.indigo.withOpacity(0.3))),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Join InfraCare", 
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 8),
                            const Text("Help us fix your city", 
                              style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 40),

                            // Full Name Field
                            _buildGlassTextField(
                              controller: _nameController,
                              hint: "Full Name",
                              icon: Icons.person_outline,
                              validator: (val) => val!.isEmpty ? "Enter your name" : null,
                            ),
                            const SizedBox(height: 20),

                            // Email Field
                            _buildGlassTextField(
                              controller: _emailController,
                              hint: "Email Address",
                              icon: Icons.email_outlined,
                              validator: (val) => !val!.contains("@") ? "Enter a valid email" : null,
                            ),
                            const SizedBox(height: 20),

                            // Password Field
                            _buildGlassTextField(
                              controller: _passwordController,
                              hint: "Password",
                              icon: Icons.lock_outline,
                              obscure: true,
                              validator: (val) => val!.length < 6 ? "Minimum 6 characters" : null,
                            ),
                            const SizedBox(height: 40),

                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.indigo[900],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Show a small success snackbar (Optional but looks professional)
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Account Created Successfully!')),
                                    );

                                    // This sends the user back to the previous screen (the Login Page)
                                    Navigator.pop(context); 
                                  }
                                },
                                child: const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Already have an account? Login", style: TextStyle(color: Colors.white70)),
                            ),
                          ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white60),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white)),
        errorStyle: const TextStyle(color: Colors.redAccent),
      ),
    );
  }
}

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  // The actual Firebase function
  Future resetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your email")));
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset link sent! Check email.')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD7C3FF), 
              Color(0xFF915DFF), 
              Color(0xFF7B42FF), 
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background Glow
            Positioned(top: 100, right: -50, child: Container(width: 200, height: 200, decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), shape: BoxShape.circle))),
          
            Center(
              child: SingleChildScrollView( // Prevents "Field is gone" error when keyboard opens
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.mark_email_read_outlined, size: 60, color: Colors.white),
                          const SizedBox(height: 20),
                          const Text("Reset Password", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 30),
                          
                          // THE EMAIL FIELD
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: "Enter registered email",
                              hintStyle: const TextStyle(color: Colors.white38),
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                            ),
                          ),
                          
                          const SizedBox(height: 25),
                          
                          // THE BUTTON
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: resetPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.indigo[900],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                              child: const Text("Send Reset Link", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                    ),
                  ),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('InfraCare', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.account_circle, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFD7C3FF),
                  Color(0xFF915DFF),
                  Color(0xFF7B42FF),
                ],
              ),
            ),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 110, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Welcome back,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                const Text("Citizen!", 
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 25),

                const Text("Active Status", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                
                // 1. Dynamic Status Counter Row via Snapshot Streams
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('reports').snapshots(),
                  builder: (context, snapshot) {
                    int activeCount = 0;
                    int resolvedCount = 0;
                    int totalCount = 0;

                    if (snapshot.hasData && snapshot.data != null) {
                      totalCount = snapshot.data!.docs.length;
                      for (var doc in snapshot.data!.docs) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        String status = (data['status'] ?? 'pending').toString().toLowerCase().trim();
                        
                        if (status == 'resolved') {
                          resolvedCount++;
                        } else {
                          activeCount++; 
                        }
                      }
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatTile("$activeCount Active", Icons.assignment_late_outlined),
                        _buildStatTile("$totalCount Total", Icons.engineering_outlined),
                        _buildStatTile("$resolvedCount Resolved", Icons.history),
                      ],
                    );
                  },
                ),
            
                const SizedBox(height: 35),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Recent Reports", 
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(onPressed: () {}, 
                      child: const Text("See All", style: TextStyle(color: Colors.white70))),
                  ],
                ),
                
                // 2. Real-time Database Pipeline rendering submitted cards automatically
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('reports')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }
                    
                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text("Error loading updates: ${snapshot.error}", 
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
                        ),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 25, bottom: 10),
                          child: Text("No data found in Firestore collection", 
                            style: TextStyle(color: Colors.white60, fontSize: 14)),
                        ),
                      );
                    }

                    return Column(
                      children: snapshot.data!.docs.map((doc) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        String category = data['category'] ?? 'Issue';
                        String description = data['description'] ?? '';
                        String status = data['status'] ?? 'Pending';
                        
                        // Selects card icons dynamically based on category
                        IconData icon;
                        switch (category) {
                          case 'Pothole': icon = Icons.add_road; break;
                          case 'Broken Light': icon = Icons.lightbulb; break;
                          case 'Water Leak': icon = Icons.water_drop; break;
                          case 'Garbage': icon = Icons.delete_outline; break;
                          default: icon = Icons.report_problem;
                        }

                        return _buildUserReportCard(context, "$category - $description", status, icon);
                      }).toList(),
                    );
                  },
                ),

                const SizedBox(height: 25),

                const Text("Happening Nearby", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildNeighborhoodAlert("New infrastructure project started in your area."),
                
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportIssuePage()),
          );
        },
        label: const Text("New Report", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B42FF))),
        icon: const Icon(Icons.add_a_photo, color: Color(0xFF7B42FF)),
        backgroundColor: Colors.white,
      ),
    );
  }

  // --- COMPONENT BUILDERS ---

  Widget _buildStatTile(String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label, 
          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)
        ),
      ],
    );
  }

  Widget _buildUserReportCard(BuildContext context, String title, String status, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReportDetailPage(title: title, status: status, icon: icon),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(status, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeighborhoodAlert(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(message, style: const TextStyle(color: Colors.white)),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureScreen({super.key, required this.camera});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Take a Photo'), backgroundColor: Colors.transparent),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Camera Error: ${snapshot.error}', 
              style: const TextStyle(color: Colors.white))
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            if (!mounted) return;
            Navigator.pop(context, image);
          } catch (e) {
            debugPrint(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({super.key});

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  String? _selectedCategory;
  XFile? _imageFile;
  String _locationName = "Not set";
  bool _isLocating = false;
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _categories = ['Pothole', 'Broken Light', 'Water Leak', 'Garbage', 'Other'];

  Future<void> _getCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location services are disabled. Please enable them in settings.")),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permissions are permanently denied. Please enable them in settings.")),
        );
        return;
      }
      
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition();
        setState(() => _locationName = "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLocating = false);
    }
  }

  void _showManualLocationDialog() {
    final controller = TextEditingController(text: _locationName == "Not set" ? "" : _locationName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Enter Location"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "e.g. 123 Maple St or Sector 4"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() => _locationName = controller.text);
              Navigator.pop(context);
            },
            child: const Text("Set"),
          ),
        ],
      ),
    );
  }

  void _openMapPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerPage()),
    );
    if (result != null && result is LatLng) {
      setState(() {
        _locationName = "${result.latitude.toStringAsFixed(4)}, ${result.longitude.toStringAsFixed(4)}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Report New Issue', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD7C3FF), Color(0xFF915DFF), Color(0xFF7B42FF)],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Image Upload Area
                  _buildGlassContainer(
                    child: InkWell(
                      onTap: () async {
                        if (_cameras.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No cameras found. Please check device permissions.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TakePictureScreen(camera: _cameras.first),
                          ),
                        );
                        if (result != null) {
                          setState(() => _imageFile = result as XFile);
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        child: _imageFile == null 
                        ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, color: Colors.white, size: 40),
                            SizedBox(height: 10),
                            Text("Take/Upload Image", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ) : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: kIsWeb 
                                ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                                : Image.file(File(_imageFile!.path), fit: BoxFit.cover)
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Drop-down Menu for Issue Selection
                  const Text("Select Issue Category", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildGlassContainer(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: const Text("Select Issue Type", style: TextStyle(color: Colors.white70)),
                        dropdownColor: const Color(0xFF915DFF),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: _categories.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (newValue) => setState(() => _selectedCategory = newValue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Add Location
                  const Text("Location", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildGlassContainer(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: _isLocating 
                              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.location_on, color: Colors.white),
                          title: Text(_locationName, style: const TextStyle(color: Colors.white)),
                          subtitle: const Text("Tap icons to set location", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.map, color: Colors.white70), onPressed: _openMapPicker),
                              IconButton(icon: const Icon(Icons.gps_fixed, color: Colors.white70), onPressed: _getCurrentLocation),
                              IconButton(icon: const Icon(Icons.edit_location_alt, color: Colors.white70), onPressed: _showManualLocationDialog),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4. Detailed Explanation
                  const Text("Detailed Explanation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildGlassContainer(
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Describe the issue here...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Submit Button (Check for incomplete issues)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        // 1. Validate Form Fields
                        if (_imageFile == null || 
                            _selectedCategory == null || 
                            _descriptionController.text.isEmpty || 
                            _locationName == "Not set") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete all fields, including location.'),
                              backgroundColor: Colors.orangeAccent,
                            ),
                          );
                          return;
                        }

                        // 2. Prepare Report Data Structure
                        final newReport = IssueReport(
                          category: _selectedCategory!,
                          description: _descriptionController.text,
                          imagePath: _imageFile!.path,
                          timestamp: DateTime.now(),
                          location: _locationName,
                          icon: _getIconForCategory(_selectedCategory!),
                        );

                        // 3. Perform Backend Writes Securely
                        try {
                          // Show a loading indicator so user knows it's working
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Uploading report...'), duration: Duration(seconds: 1)),
                          );

                          await FirebaseFirestore.instance.collection('reports').add({
                            'category': newReport.category,
                            'description': newReport.description,
                            'location': newReport.location,
                            'timestamp': FieldValue.serverTimestamp(),
                            'status': 'pending',
                          });

                          // 4. Guard against asynchronous context drops
                          if (!mounted) return;

                          // Update Local Provider State
                          Provider.of<ReportProvider>(context, listen: false).addReport(newReport);

                          // Navigate to Success Screen Cleanly
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SuccessScreen()),
                          );

                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Database Error: $e'), 
                              backgroundColor: Colors.red
                            ),
                          );
                        }
                      },
                      child: const Text("Submit Report", style: TextStyle(color: Color(0xFF7B42FF), fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Pothole': return Icons.add_road;
      case 'Broken Light': return Icons.lightbulb;
      case 'Water Leak': return Icons.water_drop;
      case 'Garbage': return Icons.delete_outline;
      default: return Icons.report_problem;
    }
  }

  Widget _buildGlassContainer({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  MapplsMapController? mapController; // Set to Hyderabad

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Bright background so we know the app is actually drawing
      backgroundColor: Colors.red, 
      body: Column(
        children: [
          const SizedBox(height: 50, child: Center(child: Text("InfraCare Map Test"))),
          
          // 2. Expanded forces the map to take up all remaining space
          Expanded(
            child: Container(
              color: Colors.blue, // If you see blue, the map widget isn't loading
              child: MapplsMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(17.3850, 78.4867),
                  zoom: 14.0,
                ),
                onMapCreated: (controller) {
                  debugPrint("--- MAP SUCCESSFULLY CREATED ---");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD7C3FF), 
              Color(0xFF915DFF), 
              Color(0xFF7B42FF)
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. Success Header
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Report Submitted!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 2. Embedded Timeline
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tracking Status",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildEmbeddedTimeline(0), // Current step is 1 (Submitted)

                          const SizedBox(height: 40),

                          // 3. Bottom Action Buttons
                          
                          SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Direct navigation to the DashboardPage class
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => const DashboardPage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF915DFF),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              "Return to Dashboard",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to build the timeline inside the success card
  Widget _buildEmbeddedTimeline(int currentStep) {
    final List<String> statuses = ["Submitted", "Under Review", "Resolving", "Resolved"];

    return Column(
      children: List.generate(statuses.length, (index) {
        bool isCompleted = index < currentStep;
        bool isCurrent = index == currentStep;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Line and Dot
            Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isCurrent ? Colors.white : Colors.white24,
                    boxShadow: isCurrent 
                        ? [const BoxShadow(color: Colors.white, blurRadius: 10)] 
                        : [],
                  ),
                  child: isCompleted 
                      ? const Icon(Icons.check, size: 10, color: Color(0xFF915DFF)) 
                      : null,
                ),
                if (index != statuses.length - 1)
                  Container(
                    width: 2,
                    height: 30,
                    color: isCompleted ? Colors.white : Colors.white24,
                  ),
              ],
            ),
            const SizedBox(width: 15),
            // Status Text
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                statuses[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isCurrent || isCompleted 
                      ? Colors.white 
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ReportDetailPage extends StatelessWidget {
  final String title;
  final String status;
  final IconData icon;

  const ReportDetailPage({
    super.key,
    required this.title,
    required this.status,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Report Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Gradient matching your theme
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD7C3FF), Color(0xFF915DFF), Color(0xFF7B42FF)],
              ),
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Map/Location Preview Header
                  _buildGlassSection(
                    height: 200,
                    child: Stack(
                      children: [
                        Center(child: Icon(Icons.map_outlined, size: 50, color: Colors.white.withOpacity(0.5))),
                        const Positioned(
                          bottom: 15,
                          left: 15,
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 18),
                              SizedBox(width: 5),
                              Text("Sector 4, Main Square", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Main Detail Card
                  _buildGlassSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: Icon(icon, color: Colors.white),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            _buildStatusBadge(status),
                          ],
                        ),
                        const Divider(height: 40, color: Colors.white24),
                        const Text("Description", style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 8),
                        const Text(
                          "The pipe has been leaking for 2 days, causing water logging near the primary school entrance.",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 25),
                        const Text("Recent Updates", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        _buildTimelineStep("Team dispatched to site", "2 hours ago", true),
                        _buildTimelineStep("Report verified by Admin", "Yesterday", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper for Glass Containers
  Widget _buildGlassSection({required Widget child, double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }

  // Helper for status badge
  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(color: Color(0xFF7B42FF), fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  // Helper for mini-updates timeline
  Widget _buildTimelineStep(String text, String time, bool isLatest) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Icon(isLatest ? Icons.radio_button_checked : Icons.radio_button_off, size: 16, color: Colors.white),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: TextStyle(color: isLatest ? Colors.white : Colors.white70))),
          Text(time, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }
}
