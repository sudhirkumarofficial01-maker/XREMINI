import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const XReminiApp());
}

class XReminiApp extends StatelessWidget {
  const XReminiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'XRemini',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C4DFF),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  int credits = 5;
  bool picking = false;

  Future<void> pickPhoto() async {
    if (picking) return;

    setState(() {
      picking = true;
    });

    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (!mounted) return;

      if (picked != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EnhanceScreen(
              file: File(picked.path),
              credits: credits,
              onUseCredit: () {
                if (mounted) {
                  setState(() {
                    credits--;
                  });
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo select failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          picking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'XRemini',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 14),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bolt,
                  size: 18,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  '$credits',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              const Text(
                'Make your photos\nlook amazing.',
                style: TextStyle(
                  fontSize: 34,
                  height: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Enhance, restore and improve your photos with XRemini.',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 35),

              GestureDetector(
                onTap: credits > 0 ? pickPhoto : showNoCredits,
                child: Container(
                  width: double.infinity,
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF7C4DFF),
                        Color(0xFF4527A0),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.16),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        'Choose a Photo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 7),

                      Text(
                        credits > 0
                            ? 'Tap to select a photo'
                            : 'No credits available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(.75),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Enhance modes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: const [
                  Expanded(
                    child: ModeCard(
                      icon: Icons.face_retouching_natural,
                      title: 'Face',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ModeCard(
                      icon: Icons.hd,
                      title: 'HD',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ModeCard(
                      icon: Icons.restore,
                      title: 'Restore',
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Center(
                child: Text(
                  '5 free credits • Watch ads to earn more',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void showNoCredits() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'No credits. Rewarded ads will be added next.',
        ),
      ),
    );
  }
}

class ModeCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const ModeCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(.06),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFFB388FF),
            size: 28,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class EnhanceScreen extends StatefulWidget {
  final File file;
  final int credits;
  final VoidCallback onUseCredit;

  const EnhanceScreen({
    super.key,
    required this.file,
    required this.credits,
    required this.onUseCredit,
  });

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  int selectedMode = 0;
  bool processing = false;
  bool enhanced = false;

  final List<String> modes = [
    'Enhance',
    'Face',
    'HD',
    'Restore',
  ];

  Future<void> processPhoto() async {
    if (processing) return;

    if (widget.credits <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No credits available.'),
        ),
      );
      return;
    }

    setState(() {
      processing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    widget.onUseCredit();

    setState(() {
      processing = false;
      enhanced = true;
    });
  }

  Future<void> savePhoto() async {
    try {
      final bytes = await widget.file.readAsBytes();

      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: 'XRemini_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (!mounted) return;

      final success =
          result is Map && result['isSuccess'] == true;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Photo saved to Gallery successfully!'
                : 'Photo save request completed.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Save failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enhance Photo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  16,
                  10,
                  16,
                  16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      widget.file,
                      fit: BoxFit.contain,
                    ),

                    if (processing)
                      Container(
                        color: Colors.black.withOpacity(.65),
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 18),
                              Text(
                                'Enhancing photo...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (enhanced && !processing)
                      Positioned(
                        left: 15,
                        top: 15,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text('Enhanced'),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 58,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: modes.length,
                itemBuilder: (context, index) {
                  final selected = selectedMode == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMode = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF7C4DFF)
                            : const Color(0xFF181818),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        modes[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Again'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      onPressed: enhanced ? savePhoto : processPhoto,
                      icon: Icon(
                        enhanced
                            ? Icons.download
                            : Icons.auto_fix_high,
                      ),
                      label: Text(
                        enhanced ? 'Save' : 'Enhance',
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
