import 'package:flutter/material.dart';
import '../core/theme.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const PageHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: C.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 20, right: 20, bottom: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26, fontWeight: FontWeight.w800,
              color: C.black, letterSpacing: -0.6,
            ),
          ),
          if (action != null) ...[const Spacer(), action!],
        ],
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;
  final String? linkText;
  final VoidCallback? onLink;

  const SectionLabel({super.key, required this.text, this.linkText, this.onLink});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: C.black)),
        if (linkText != null)
          GestureDetector(
            onTap: onLink,
            child: Text(linkText!, style: const TextStyle(fontSize: 13, color: C.grey, fontWeight: FontWeight.w500)),
          ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const Tile({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(14)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: C.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: C.border),
        ),
        child: child,
      ),
    );
  }
}

class FilledBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool outlined;
  final double height;

  const FilledBtn({super.key, required this.label, required this.onTap, this.outlined = false, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: outlined ? C.white : C.black,
          borderRadius: BorderRadius.circular(13),
          border: outlined ? Border.all(color: C.black, width: 1.5) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: outlined ? C.black : C.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class QtyRow extends StatelessWidget {
  final int value;
  final VoidCallback onInc;
  final VoidCallback onDec;

  const QtyRow({super.key, required this.value, required this.onInc, required this.onDec});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: C.lightGrey, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Btn(icon: Icons.remove, onTap: onDec, filled: false),
          SizedBox(
            width: 32,
            child: Center(child: Text('$value', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: C.black))),
          ),
          _Btn(icon: Icons.add, onTap: onInc, filled: true),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  const _Btn({required this.icon, required this.onTap, required this.filled});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: filled ? C.black : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 15, color: filled ? C.white : C.black),
      ),
    );
  }
}

IconData iconForCat(String cat) {
  switch (cat) {
    case 'Microcontroladores': return Icons.memory_rounded;
    case 'Sensores':           return Icons.sensors_rounded;
    case 'Pantallas':          return Icons.desktop_windows_rounded;
    default:                   return Icons.electrical_services_rounded;
  }
}
