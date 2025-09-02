// lib/shared/widgets/custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.showBackButton = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: foregroundColor ?? Colors.white,
        ),
      ),
      actions: actions,
      leading:
          !showBackButton
              ? null
              : leading ??
                  (automaticallyImplyLeading && Navigator.canPop(context)
                      ? IconButton(
                        onPressed:
                            onBackPressed ?? () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios),
                      )
                      : null),
      automaticallyImplyLeading:
          showBackButton ? automaticallyImplyLeading : false,
      backgroundColor: backgroundColor ?? Colors.blue[600],
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: elevation,
      centerTitle: centerTitle,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
