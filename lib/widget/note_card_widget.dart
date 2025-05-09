import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../model/note.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    // Extract first image if there are any
    String? imagePath;
    if (note.images != null && note.images!.isNotEmpty) {
      final images = note.images!.split(',');
      if (images.isNotEmpty && images[0].isNotEmpty) {
        imagePath = images[0];
      }
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Color(note.color),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      margin: const EdgeInsets.all(4),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: GoogleFonts.poppins(
                      color: _getTextColor(note.color),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ).animate(delay: Duration(milliseconds: 100 + index * 30))
                   .fadeIn(duration: const Duration(milliseconds: 200))
                   .slideY(begin: 0.2, end: 0),
                ),
                if (note.isImportant)
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 20,
                  ).animate(delay: Duration(milliseconds: 200 + index * 30))
                   .fadeIn(duration: const Duration(milliseconds: 300))
                   .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1)),
              ],
            ),
            const SizedBox(height: 8),
            if (imagePath != null)
              Container(
                height: 100,
                margin: const EdgeInsets.only(bottom: 8),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  image: DecorationImage(
                    image: FileImage(File(imagePath)),
                    fit: BoxFit.cover,
                  ),
                ),
              ).animate(delay: Duration(milliseconds: 150 + index * 30))
               .fadeIn(duration: const Duration(milliseconds: 300))
               .slideY(begin: 0.3, end: 0),
            Text(
              note.description,
              style: GoogleFonts.poppins(
                color: _getTextColor(note.color),
                fontSize: 14,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ).animate(delay: Duration(milliseconds: 200 + index * 30))
             .fadeIn(duration: const Duration(milliseconds: 300))
             .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                if (note.tags.isNotEmpty) ..._buildTags(),
              ],
            ).animate(delay: Duration(milliseconds: 250 + index * 30))
             .fadeIn(duration: const Duration(milliseconds: 300)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.MMMd().format(note.createdTime),
                  style: GoogleFonts.poppins(
                    color: _getTextColor(note.color).withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                _buildPriorityIcon(),
              ],
            ).animate(delay: Duration(milliseconds: 300 + index * 30))
             .fadeIn(duration: const Duration(milliseconds: 300))
             .slideY(begin: 0.2, end: 0),
          ],
        ),
      ),
    ).animate(onPlay: (controller) => controller.repeat(reverse: true))
     .shimmer(duration: const Duration(seconds: 3), color: Colors.white24)
     .animate() // Second animation after shimmer
     .elevation(
       begin: 4, 
       end: 6,
       curve: Curves.easeInOut,
       duration: const Duration(seconds: 2),
     );
  }

  Widget _buildPriorityIcon() {
    IconData icon;
    Color color;

    switch (note.priority) {
      case 3: // High
        icon = Icons.arrow_upward;
        color = Colors.red;
        break;
      case 2: // Medium
        icon = Icons.remove;
        color = Colors.orange;
        break;
      case 1: // Low
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
      default:
        icon = Icons.arrow_downward;
        color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            note.priority == 3
                ? 'High'
                : note.priority == 2
                    ? 'Med'
                    : 'Low',
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildTags() {
    final tags = note.getTagsList();
    return tags.take(2).map((tag) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          '#$tag',
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: _getTextColor(note.color),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  Color _getTextColor(int backgroundColor) {
    // Logic to determine if text should be white or black based on background color
    final color = Color(backgroundColor);
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
