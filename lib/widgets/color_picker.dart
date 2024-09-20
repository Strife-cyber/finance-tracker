import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  final String text;
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerWidget(
      {super.key,
      required this.text,
      required this.initialColor,
      required this.onColorChanged});

  @override
  State<ColorPickerWidget> createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State<ColorPickerWidget> {
  Color _textColor = Colors.black;

  // List of 25 popular colors
  final List<Color> _colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.amber,
    Colors.teal,
    Colors.deepOrange,
    Colors.blue,
    Colors.yellow,
    Colors.grey,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.blueGrey,
    Colors.pink[100]!,
    Colors.purple[700]!,
    Colors.cyan[100]!,
  ];

  @override
  void initState() {
    super.initState();
    _textColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.text, style: const TextStyle(color: Colors.black)),
        DropdownButton<Color>(
          value: _textColor,
          items: _colors.map((Color color) {
            return DropdownMenuItem<Color>(
              value: color,
              child: Container(
                width: 24,
                height: 24,
                color: color,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              widget.onColorChanged(
                  value); // Call the callback to update the state
            }
            setState(() {
              _textColor = value!;
            });
          },
        ),
      ],
    );
  }
}
