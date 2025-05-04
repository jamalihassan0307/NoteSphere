import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:notes_app_with_sql/db/sql.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  String _appVersion = '';
  int _noteCount = 0;
  bool _isLoading = true;
  
  // Theme options
  String _selectedTheme = 'Default';
  final List<String> _themeOptions = [
    'Default',
    'Dark',
    'Light',
    'Blue',
    'Green',
    'Purple',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get app version
      final packageInfo = await PackageInfo.fromPlatform();
      
      // Get note count
      await SQL.readAllNotes();
      final noteCount = SignupController.to.notes.length;
      
      // Get saved theme preference
      final prefs = await SharedPreferences.getInstance();
      final theme = prefs.getString('theme') ?? 'Default';
      final isDarkMode = prefs.getBool('darkMode') ?? false;
      
      setState(() {
        _appVersion = packageInfo.version;
        _noteCount = noteCount;
        _selectedTheme = theme;
        _isDarkMode = isDarkMode;
      });
    } catch (e) {
      print('Error loading settings: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveThemePreference(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
    setState(() {
      _selectedTheme = theme;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Theme updated',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              children: [
                // Appearance Section
                _buildSectionHeader('Appearance'),
                const SizedBox(height: 8),
                _buildSettingCard(
                  title: 'Dark Mode',
                  description: 'Enable dark mode for the app',
                  icon: Icons.dark_mode,
                  trailingWidget: Switch(
                    value: _isDarkMode,
                    onChanged: _toggleDarkMode,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  title: 'Theme',
                  description: 'Change app color theme',
                  icon: Icons.color_lens,
                  onTap: () {
                    _showThemeSelector();
                  },
                  trailingWidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedTheme,
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Data Section
                _buildSectionHeader('Data'),
                const SizedBox(height: 8),
                _buildSettingCard(
                  title: 'Backup Notes',
                  description: 'Export your notes to a file',
                  icon: Icons.backup,
                  onTap: () {
                    // Implement backup functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Backup feature coming soon',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  title: 'Restore Notes',
                  description: 'Import notes from a backup file',
                  icon: Icons.restore,
                  onTap: () {
                    // Implement restore functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Restore feature coming soon',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // App Information
                _buildSectionHeader('App Information'),
                const SizedBox(height: 8),
                _buildSettingCard(
                  title: 'Version',
                  description: _appVersion,
                  icon: Icons.info_outline,
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  title: 'Total Notes',
                  description: '$_noteCount notes stored',
                  icon: Icons.note,
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  title: 'About',
                  description: 'Learn more about NoteSphere',
                  icon: Icons.help_outline,
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
              ],
            ).animate().fadeIn(duration: const Duration(milliseconds: 300)),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade800,
        ),
      ),
    );
  }
  
  Widget _buildSettingCard({
    required String title,
    required String description,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailingWidget,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.blueGrey.shade700,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        trailing: trailingWidget,
        onTap: onTap,
      ),
    );
  }
  
  void _showThemeSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Theme',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _themeOptions.map((theme) {
                final isSelected = theme == _selectedTheme;
                
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _saveThemePreference(theme);
                  },
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueGrey.shade200 : Colors.blueGrey.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blueGrey.shade800 : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: _getThemeColor(theme),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          theme,
                          style: GoogleFonts.poppins(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getThemeColor(String theme) {
    switch (theme) {
      case 'Default': return Colors.blueGrey;
      case 'Dark': return Colors.black87;
      case 'Light': return Colors.white70;
      case 'Blue': return Colors.blue;
      case 'Green': return Colors.green;
      case 'Purple': return Colors.purple;
      default: return Colors.blueGrey;
    }
  }
  
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About NoteSphere',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images.png',
                height: 80,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'NoteSphere v$_appVersion',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'NoteSphere is a powerful note-taking app with SQLite database, allowing you to store and manage your notes with advanced features like tagging, priorities, reminders and more.',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2023 NoteSphere',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
} 