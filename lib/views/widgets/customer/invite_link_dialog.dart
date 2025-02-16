import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class InviteLinkDialog extends StatelessWidget {
  final String link;

  const InviteLinkDialog({
    super.key,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Invite Link",
              style: GoogleFonts.montserratAlternates(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              )),
          const SizedBox(height: 16),
          SelectableText(link,
              style: GoogleFonts.montserratAlternates(
                color: AppColors().teal,
              )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // نسخ الرابط إلى الحافظة
              Clipboard.setData(ClipboardData(text: link)).then((_) {
                // إغلاق الواجهة
                if (!context.mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Link copied to clipboard!"),
                    duration: Duration(seconds: 2),
                  ),
                );
              });
            },
            icon: Icon(Icons.copy_all_outlined, color: AppColors().white),
            label: const Text("Copy Link"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors().orange,
              foregroundColor: AppColors().white,
            ),
          ),
        ],
      ),
    );
  }
}
