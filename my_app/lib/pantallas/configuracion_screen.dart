import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('es', 'ES')],
      path: 'assets/translations',
      fallbackLocale: const Locale('es', 'ES'),
      startLocale: const Locale('es', 'ES'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const ConfiguracionScreen(),
    );
  }
}

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen>
    with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'es';
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'es';
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', _selectedLanguage);
    await prefs.setBool('notifications', _notificationsEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('config').tr(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: const [
                      Colors.lightGreen,
                      Colors.green,
                      Colors.teal,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      _controller.value,
                      _controller.value + 0.5,
                      _controller.value + 1.0,
                    ].map((stop) => stop % 1.0).toList(),
                  ),
                ),
              );
            },
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Solo disponible en español',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                    ),
                    const SizedBox(height: 20),
                    _buildSettingItem(
                      context,
                      Icons.language,
                      'language'.tr(),
                      _showLanguageSelection,
                    ),
                    const SizedBox(height: 10),
                    _buildSettingItem(
                      context,
                      Icons.notifications,
                      'notifications'.tr(),
                      _toggleNotifications,
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                            _savePreferences();
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildSettingItem(
                      context,
                      Icons.privacy_tip,
                      'privacy'.tr(),
                      _showPrivacyPolicy,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        trailing: trailing,
        onTap: trailing == null ? onTap : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }

  Future<void> _showLanguageSelection() async {
    await showDialog<Locale>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('selectLanguage'.tr()),
          content: const Text('Solo disponible en español'),
        );
      },
    );
  }

  void _toggleNotifications() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      setState(() => _notificationsEnabled = true);
    } else {
      setState(() => _notificationsEnabled = false);
    }
    _savePreferences();
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Política de privacidad'),
          content: const Text('Esta es la política de privacidad de la aplicación.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class AppLocalizations {
  static String get config => 'Config'.tr();
  static String get configTitle => 'Configuration'.tr();
  static String get language => 'Language'.tr();
  static String get notifications => 'Notifications'.tr();
  static String get privacy => 'Privacy Policy'.tr();
  static String get selectLanguage => 'Select Language'.tr();
}
