import 'package:flutter/material.dart';

class ListTileSetting extends StatelessWidget {
  final String title;
  final Function onTap;
  final IconData iconData;
  final Widget subtitle;

  const ListTileSetting(
      {super.key,
      required this.title,
      required this.iconData,
      required this.onTap,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          onTap: () => onTap(),
          leading: Icon(
            iconData,
            color: Theme.of(context).iconTheme.color,
          ),
          title: Text(title),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).iconTheme.color,
          ),
          subtitle: subtitle,
        ),
        const Divider(
          indent: 60,
          thickness: 2,
        ),
      ],
    );
  }
}
