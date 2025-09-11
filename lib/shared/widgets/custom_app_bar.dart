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
  final PreferredSizeWidget? bottom; // Add bottom property for TabBar support

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
    this.bottom, // Add bottom parameter
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
      bottom: bottom, // Add bottom property
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)); // Account for bottom widget height
}

// Alternative approach if you want to keep your CustomAppBar simpler:
// You can also create a separate widget for the complete app bar with tabs:

class CustomAppBarWithTabs extends StatelessWidget
    implements PreferredSizeWidget {
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
  final TabController? tabController;
  final List<Widget> tabs;

  const CustomAppBarWithTabs({
    super.key,
    required this.title,
    required this.tabs,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.showBackButton = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.centerTitle = false,
    this.onBackPressed,
    this.tabController,
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
      bottom: TabBar(
        controller: tabController,
        tabs: tabs,
        labelColor: foregroundColor ?? Colors.white,
        unselectedLabelColor: (foregroundColor ?? Colors.white).withOpacity(
          0.7,
        ),
        indicatorColor: foregroundColor ?? Colors.white,
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + kTextTabBarHeight);
}
