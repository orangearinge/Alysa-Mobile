import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:alysa_speak/theme/app_color.dart';

class ErrorDialog {
  static void show(
    BuildContext context, {
    required String message,
    String title = "Error",
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _contentBox(context, message, title),
        );
      },
    );
  }

  static Widget _contentBox(
    BuildContext context,
    String message,
    String title,
  ) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 45 + 20,
            right: 20,
            bottom: 20,
          ),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 10),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                message,
                style: GoogleFonts.poppins(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.redAccent,
            radius: 45,
            child: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }
}
