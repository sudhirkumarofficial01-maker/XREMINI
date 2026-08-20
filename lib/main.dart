import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
void main() {
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090A0F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7656FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------------- SPLASH ----------------

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF8B6CFF),
                    Color(0xFF4C2EDB),
                  ],
                ),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'XRemini',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'AI Photo Enhancer',
              style: TextStyle(
                color: Colors.white.withOpacity(.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- HOME ----------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int credits = 5;

  Future<void> selectPhoto() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 95,
    );

    if (image == null || !mounted) return;

    if (credits <= 0) {
      showNoCredits();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EnhanceScreen(
          file: File(image.path),
          onUseCredit: () {
            setState(() {
              credits--;
            });
          },
        ),
      ),
    );
  }

  void rewardAd() {
    // Real AdMob rewarded ad will be connected later.
    setState(() {
      credits += 2;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo: +2 credits added'),
      ),
    );
  }

  void showNoCredits() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF15161E),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bolt,
                size: 45,
                color: Color(0xFFB39AFF),
              ),
              const SizedBox(height: 12),
              const Text(
                'No Credits Left',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Watch an ad to get 2 more credits.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    rewardAd();
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Watch Ad +2 Credits'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'XRemini',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF171523),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.bolt,
                  size: 18,
                  color: Color(0xFFB39AFF),
                ),
                const SizedBox(width: 5),
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
        children: [
          const Text(
            'Make every photo\nlook amazing.',
            style: TextStyle(
              fontSize: 32,
              height: 1.08,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Enhance faces, restore old photos and create sharper HD images.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(.58),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // MAIN BUTTON
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: selectPhoto,
            child: Ink(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7656FF),
                    Color(0xFF4C2EDB),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.14),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enhance Photo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'AI HD enhancement',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: featureCard(
                  Icons.face_retouching_natural,
                  'Face Enhance',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: featureCard(
                  Icons.history,
                  'Old Restore',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // CREDIT CARD
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF14151D),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(.06),
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF28213E),
                  child: Icon(
                    Icons.play_arrow,
                    color: Color(0xFFB39AFF),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need more credits?',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Watch a short ad and get +2 credits.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: rewardAd,
                  child: const Text('WATCH'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'How it works',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 12),

          step('1', 'Choose a photo'),
          step('2', 'Choose enhancement'),
          step('3', 'Save your result'),
        ],
      ),
    );
  }

  Widget featureCard(
    IconData icon,
    String title,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: selectPhoto,
      child: Container(
        height: 112,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF14151D),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: const Color(0xFFB39AFF),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget step(
    String number,
    String title,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF1C1930),
        child: Text(
          number,
          style: const TextStyle(
            color: Color(0xFFB39AFF),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: const Text(
        'XRemini makes the process simple.',
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}

// ---------------- ENHANCE ----------------

class EnhanceScreen extends StatefulWidget {
  final File file;
  final VoidCallback onUseCredit;

  const EnhanceScreen({
    super.key,
    required this.file,
    required this.onUseCredit,
  });

  @override
  State<EnhanceScreen> createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  int selectedMode = 0;
  bool processing = false;

  Future<void> processPhoto() async {
    setState(() {
      processing = true;
    });

    await Future.delayed(
      const Duration(seconds: 2),
    );

    widget.onUseCredit();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          file: widget.file,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhance Photo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.file(
              widget.file,
              height: 360,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Choose enhancement',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 12),

          option(
            0,
            'HD Enhance',
            'Sharper and clearer',
            Icons.hd,
          ),

          option(
            1,
            'Face Enhance',
            'Improve facial details',
            Icons.face,
          ),

          option(
            2,
            'Old Photo Restore',
            'Restore faded photos',
            Icons.photo_library,
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: processing ? null : processPhoto,
              icon: processing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(
                processing
                    ? 'Processing...'
                    : 'Enhance • 1 Credit',
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 17,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget option(
    int index,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final selected = selectedMode == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMode = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF211A3B)
              : const Color(0xFF14151D),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? const Color(0xFF7656FF)
                : Colors.white.withOpacity(.06),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFFB39AFF)
                  : Colors.white54,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFB39AFF),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------- RESULT ----------------

class ResultScreen extends StatelessWidget {
  final File file;

  const ResultScreen({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),

                    const Positioned(
                      left: 14,
                      top: 14,
                      child: ResultTag('BEFORE'),
                    ),

                    const Positioned(
                      right: 14,
                      top: 14,
                      child: ResultTag('AFTER'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.refresh),
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
                    onPressed: () async {
  try {
    final hasAccess = await Gal.hasAccess();

    if (!hasAccess) {
      final granted = await Gal.requestAccess();

      if (!granted) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gallery permission is required.'),
          ),
        );
        return;
      }
    }

    await Gal.putImage(
      file.path,
      album: 'XRemini',
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo saved successfully!'),
      ),
    );
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Unable to save photo.'),
      ),
    );
  }
},
