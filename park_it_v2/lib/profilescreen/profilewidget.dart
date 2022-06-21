import 'package:flutter/material.dart';
import 'package:park_it_v2/config/theme.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  const ProfileWidget(
      {Key? key, required this.imagePath, required this.onClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Palette.primary;
    return Center(
      child: Stack(children: [
        buildImage(),
        Positioned(bottom: 0, right: 4, child: buildEditIcon(color))
      ]),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          height: 128,
          width: 128,
          child: InkWell(
            onTap: onClicked,
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        all: 3,
        color: Palette.textWhite,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            size: 20,
            color: Palette.textWhite,
          ),
        ),
      );

  buildCircle(
          {required Color color, required double all, required Widget child}) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
