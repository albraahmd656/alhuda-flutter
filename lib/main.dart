import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AlhudaApp());
}

class AlhudaApp extends StatelessWidget {
  const AlhudaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مركز الهدى العلمي',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ar', '')],
      locale: const Locale('ar', ''),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _onStartClicked() async {
    try {
      await _audioPlayer.play(AssetSource('raw/click_sound.mp3'));
    } catch (e) {
      debugPrint("خطأ في تشغيل الصوت: $e");
    }
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_main.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo_alhuda.png',
                            width: 90,
                            height: 90,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.school, size: 80, color: Color(0xFF4A2C2A));
                            },
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'تطبيق حلقات الهدى',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4A2C2A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      Custom3DButton(
                        text: 'دخول التطبيق',
                        onPressed: _onStartClicked,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo_alhuda.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                'واصل مسيرتك المباركة! 🚀',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2C2A),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'تم تفعيل الواجهة والصوت بنجاح.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6F4E37),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 36),
              Custom3DButton(
                text: 'العودة للرئيسية 💡',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Custom3DButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const Custom3DButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  State<Custom3DButton> createState() => _Custom3DButtonState();
}

class _Custom3DButtonState extends State<Custom3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        height: 62,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF3D1810),
        ),
        child: Transform.translate(
          offset: Offset(0, _isPressed ? 4 : 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFF6F4E37),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
