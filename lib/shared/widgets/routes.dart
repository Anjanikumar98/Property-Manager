import 'package:flutter/material.dart';
import 'package:property_manager/app/theme/app_theme.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final SlideDirection direction;

  SlidePageRoute({
    required this.child,
    this.direction = SlideDirection.rightToLeft,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: AppTheme.normalAnimation,
         reverseTransitionDuration: AppTheme.normalAnimation,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           Offset begin;
           const Offset end = Offset.zero;

           switch (direction) {
             case SlideDirection.rightToLeft:
               begin = const Offset(1.0, 0.0);
               break;
             case SlideDirection.leftToRight:
               begin = const Offset(-1.0, 0.0);
               break;
             case SlideDirection.topToBottom:
               begin = const Offset(0.0, -1.0);
               break;
             case SlideDirection.bottomToTop:
               begin = const Offset(0.0, 1.0);
               break;
           }

           const curve = Curves.easeInOutCubic;
           final tween = Tween(begin: begin, end: end);
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: curve,
           );

           return SlideTransition(
             position: tween.animate(curvedAnimation),
             child: child,
           );
         },
       );
}

class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  FadePageRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionDuration: AppTheme.normalAnimation,
        reverseTransitionDuration: AppTheme.normalAnimation,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
}

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  ScalePageRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionDuration: AppTheme.normalAnimation,
        reverseTransitionDuration: AppTheme.normalAnimation,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOutCubic;
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return ScaleTransition(
            scale: Tween<double>(begin: 0.0, end: 1.0).animate(curvedAnimation),
            child: child,
          );
        },
      );
}

enum SlideDirection { rightToLeft, leftToRight, topToBottom, bottomToTop }
