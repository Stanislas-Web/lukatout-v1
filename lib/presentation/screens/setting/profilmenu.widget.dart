import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';



class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.isRemoved = false,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon, isRemoved;
  final Color? textColor;


  @override
  Widget build(BuildContext context) {

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    // var iconColor = isDark ? tPrimaryColor : tAccentColor;

    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color:  Colors.blue.withOpacity(0.1),
          border: Border.all(width: 1, color: isRemoved == true ? Colors.red: Colors.blue.withOpacity(0.1))
        ),
        child: Icon(icon, color: Color(0xFF204f97)),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyText1?.apply(color: isRemoved == true?Colors.red: textColor)),
      trailing: endIcon? Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1),
          ),
          child: const Icon(LineAwesomeIcons.angle_right, size: 18.0, color: Colors.grey)) : null,
    );
  }
}