import 'package:flutter/material.dart';
import 'package:whatsapp/core/res/colors.dart';

class GlobalTile extends StatelessWidget {
  const GlobalTile({
    required this.profileImage,
    required this.onTap,
    this.title,
    this.titleWidget,
    this.trailing,
    this.subtitle,
    super.key,
  })  : assert(
          title != null || titleWidget != null,
          'title or titleWidget must be provided',
        ),
        assert(
          title == null || titleWidget == null,
          'title and titleWidget cannot be provided at the same time',
        );

  final String profileImage;
  final Widget? trailing;
  final String? title;
  final Widget? titleWidget;
  final Widget? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: titleWidget ??
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
              subtitle: subtitle,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  profileImage,
                ),
                radius: 30,
              ),
              trailing: trailing,
            ),
          ),
        ),
        const Divider(color: dividerColor, indent: 85),
      ],
    );
  }
}
