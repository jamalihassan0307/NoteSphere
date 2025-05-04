import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_sql/controller/signupcontroller.dart';
import 'package:notes_app_with_sql/controller/authcontroller.dart';
import 'package:notes_app_with_sql/controller/notecontroller.dart';
import 'package:notes_app_with_sql/db/sql.dart';
// import '../db/notes_database.dart';
import '../model/note.dart';
import '../page/edit_note_page.dart';
import '../page/note_detail_page.dart';
import '../widget/note_card_widget.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../page/profile_page.dart';
import '../page/settings_page.dart';
import 'package:intl/intl.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _advancedDrawerController = AdvancedDrawerController();
  bool isGridView = true;
  String searchQuery = '';
  int currentFilter = 0; // 0: All, 1: Important, 2: High Priority
  
  @override
  void initState() {
    super.initState();
    Get.put(SignupController());
    // Clear notes before refreshing to avoid duplicates
    SignupController.to.clearNotes();
    refreshNotes();
  }

  @override
  void dispose() {
    // No need to call dispose here as it will be handled in the controller's onClose
    super.dispose();
  }

  Future refreshNotes() async {
    SignupController.to.isLoading.value = true;
    // Ensure notes are cleared before fetching
    SignupController.to.clearNotes();
    await SQL.readAllNotes();
    SignupController.to.isLoading.value = false;
    // Use update() instead of setState to refresh GetX state
    if (mounted) setState(() {});
  }

  List<Note> getFilteredNotes(List<Note> allNotes) {
    if (searchQuery.isNotEmpty) {
      allNotes = allNotes
          .where((note) =>
              note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              note.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
              note.tags.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    switch (currentFilter) {
      case 1: // Important
        return allNotes.where((note) => note.isImportant).toList();
      case 2: // High Priority
        return allNotes.where((note) => note.priority == 3).toList();
      case 3: // Medium Priority
        return allNotes.where((note) => note.priority == 2).toList();
      case 4: // Low Priority
        return allNotes.where((note) => note.priority == 1).toList();
      default: // All
        return allNotes;
    }
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) => AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
            ),
          ),
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade900,
              blurRadius: 20.0,
              spreadRadius: 5.0,
              offset: const Offset(-20.0, 0.0),
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        drawer: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Image.asset(
                    'assets/images.png',
                    height: 70,
                  ),
                ),
                Divider(color: Colors.grey.shade700),
                _buildDrawerItem(
                  icon: Icons.notes,
                  title: 'All Notes',
                  isSelected: currentFilter == 0,
                  onTap: () {
                    setState(() {
                      currentFilter = 0;
                    });
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.star,
                  title: 'Important',
                  isSelected: currentFilter == 1,
                  onTap: () {
                    setState(() {
                      currentFilter = 1;
                    });
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.arrow_upward,
                  title: 'High Priority',
                  isSelected: currentFilter == 2,
                  onTap: () {
                    setState(() {
                      currentFilter = 2;
                    });
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.remove,
                  title: 'Medium Priority',
                  isSelected: currentFilter == 3,
                  onTap: () {
                    setState(() {
                      currentFilter = 3;
                    });
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.arrow_downward,
                  title: 'Low Priority',
                  isSelected: currentFilter == 4,
                  onTap: () {
                    setState(() {
                      currentFilter = 4;
                    });
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                Divider(color: Colors.grey.shade700),
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Profile',
                  onTap: () {
                    // Navigate to profile page
                    Get.to(() => ProfilePage(userId: SignupController.to.currentUserId ?? ''));
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // Navigate to settings page
                    Get.to(() => const SettingsPage());
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                const Spacer(),
                Divider(color: Colors.grey.shade700),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    // Logout functionality using AuthController
                    AuthController.to.logout();
                    _advancedDrawerController.hideDrawer();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        child: GetBuilder<SignupController>(
          builder: (obj) {
            final filteredNotes = getFilteredNotes(obj.notes);
            
            return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  _getAppBarTitle(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  onPressed: _handleMenuButtonPressed,
                  icon: ValueListenableBuilder<AdvancedDrawerValue>(
                    valueListenable: _advancedDrawerController,
                    builder: (_, value, __) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          value.visible ? Icons.clear : Icons.menu,
                          key: ValueKey<bool>(value.visible),
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isGridView ? Icons.view_list : Icons.grid_view,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isGridView = !isGridView;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      _showSearchDialog();
                    },
                  ),
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: const Icon(Icons.more_vert, color: Colors.black),
                    onSelected: (String result) {
                      SQL.selectJoinType(result);
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'ALL',
                        child: Text('ALL'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'LIMIT',
                        child: Text('LIMIT (Top 10 records)'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'ORDER BY',
                        child: Text('ORDER BY (number descending)'),
                      ),
                    ],
                  ),
                ],
              ),
              body: Column(
                children: [
                  if (searchQuery.isNotEmpty)
                    Container(
                      color: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Search: "$searchQuery"',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchQuery = '';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: obj.isLoading.value
                        ? Center(
                            child: Lottie.network(
                              'https://assets3.lottiefiles.com/private_files/lf30_ijwulw45.json',
                              width: 200,
                              height: 200,
                            ),
                          )
                        : filteredNotes.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.network(
                                      'https://assets8.lottiefiles.com/packages/lf20_ydo1amjm.json',
                                      width: 200,
                                      height: 200,
                                    ),
                                    Text(
                                      'No Notes Found',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      searchQuery.isNotEmpty
                                          ? 'Try a different search term'
                                          : 'Add your first note!',
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : isGridView
                                ? buildGridNotes(filteredNotes)
                                : buildListNotes(filteredNotes),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AddEditNotePage()),
                  );
                  refreshNotes();
                },
                backgroundColor: Colors.blueGrey.shade800,
                icon: const Icon(Icons.add),
                label: Text(
                  'New Note',
                  style: GoogleFonts.poppins(),
                ),
              ),
            );
          },
        ),
      );

  String _getAppBarTitle() {
    switch (currentFilter) {
      case 1:
        return 'Important Notes';
      case 2:
        return 'High Priority Notes';
      case 3:
        return 'Medium Priority Notes';
      case 4:
        return 'Low Priority Notes';
      default:
        return 'My Notes';
    }
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Function() onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey.shade400,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.white : Colors.grey.shade400,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: Colors.black26,
    );
  }

  void _showSearchDialog() {
    final controller = TextEditingController(text: searchQuery);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Search Notes',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter search term...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          autofocus: true,
          onSubmitted: (value) {
            setState(() {
              searchQuery = value;
            });
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                searchQuery = controller.text;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Search', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Widget buildGridNotes(List<Note> notes) => MasonryGridView.count(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(
                  note: note,
                  color: Color(note.color),
                ),
              ));
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index).animate().fadeIn(
              duration: const Duration(milliseconds: 350),
              delay: Duration(milliseconds: index * 50),
            ),
          );
        },
      );

  Widget buildListNotes(List<Note> notes) => ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Slidable(
            key: Key(note.id.toString()),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AddEditNotePage(note: note),
                    ));
                    refreshNotes();
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Note?', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                        content: Text('Are you sure you want to delete this note?', style: GoogleFonts.poppins()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel', style: GoogleFonts.poppins()),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            child: Text('Delete', style: GoogleFonts.poppins()),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete ?? false) {
                      await SQL.delete(note);
                      refreshNotes();
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 12,
                  height: double.infinity,
                  color: Color(note.color),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (note.isImportant)
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: note.priority == 3
                            ? Colors.red.withOpacity(0.2)
                            : note.priority == 2
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        note.priority == 3
                            ? 'High'
                            : note.priority == 2
                                ? 'Med'
                                : 'Low',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: note.priority == 3
                              ? Colors.red
                              : note.priority == 2
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.description,
                      style: GoogleFonts.poppins(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat.yMMMd().format(note.createdTime),
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    if (note.tags.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.tag, size: 12, color: Colors.grey),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              note.tags,
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteDetailPage(
                      note: note,
                      color: Color(note.color),
                    ),
                  ));
                  refreshNotes();
                },
              ),
            ).animate().slideX(
                  duration: const Duration(milliseconds: 350),
                  delay: Duration(milliseconds: index * 50),
                  begin: 1,
                  end: 0,
                  curve: Curves.easeOut,
                ),
          );
        },
      );
}
