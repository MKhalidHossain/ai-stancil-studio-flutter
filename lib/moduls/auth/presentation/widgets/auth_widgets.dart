import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthColors {
  static const Color purple = Color(0xFF6C1BD1);
  static const Color purpleDark = Color(0xFF5412B0);
  static const Color fieldFill = Color(0xFFF3F3F3);
  static const Color fieldIcon = Color(0xFF9B9B9B);
  static const Color hintText = Color(0xFFB0B0B0);
  static const Color textPrimary = Color(0xFF1C1C1C);
  static const Color textSecondary = Color(0xFF6C6C6C);
  static const Color border = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFD8D8D8);
}

TextStyle authTitleStyle() => GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: AuthColors.textPrimary,
);

TextStyle authSubtitleStyle() => GoogleFonts.poppins(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: AuthColors.textSecondary,
);

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AuthColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AuthColors.hintText,
        ),
        prefixIcon: Icon(prefixIcon, size: 20, color: AuthColors.fieldIcon),
        suffixIcon: suffix,
        filled: true,
        fillColor: AuthColors.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AuthColors.purple, width: 1),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthColors.purple,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AuthColors.disabled,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

class AuthOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AuthOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AuthColors.purple,
          side: const BorderSide(color: AuthColors.purple, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AuthColors.purple,
          ),
        ),
      ),
    );
  }
}

class AuthBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AuthBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      color: AuthColors.textPrimary,
    );
  }
}
