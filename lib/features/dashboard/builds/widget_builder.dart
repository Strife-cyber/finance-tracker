import 'package:flutter/material.dart';
import '../../../widgets/color_picker.dart';

class WidgetBuilderPage extends StatefulWidget {
  final Function(Widget) onSave; // Callback for saving the widget

  const WidgetBuilderPage({super.key, required this.onSave});

  @override
  State<WidgetBuilderPage> createState() => _WidgetBuilderPageState();
}

class _WidgetBuilderPageState extends State<WidgetBuilderPage> {
  // Properties the user can customize
  String _text = "Hello World!";
  String _description =
      "Here you can build a custom widget with a title and description for your liking";
  Color _backgroundColor = Colors.blue;
  Color _textColor = Colors.black;
  Color _cardColor = Colors.white;
  double _borderRadius = 10.0;
  double _padding = 16.0;
  double _fontSize = 16.0;

  // Function to build the custom widget based on user selections
  Widget buildUserWidget() {
    return Container(
      padding: EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Card(
        color: _cardColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  _text,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: _fontSize + 5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _description,
                style: TextStyle(color: _textColor, fontSize: _fontSize),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to save the built widget
  void saveWidget() {
    final widgetToSave = buildUserWidget();
    widget.onSave(widgetToSave); // Use the passed callback to save the widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // This is the widget that the user builds
                Expanded(
                  flex: 2,
                  child: Center(
                    child: buildUserWidget(), // Display the built widget
                  ),
                ),
                const SizedBox(height: 20),
                // This section contains the UI for customizing the widget
                Expanded(
                  flex: 3,
                  child: ListView(
                    children: [
                      // Text input
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Text',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _text = value;
                          });
                        },
                      ),
                      TextField(
                          maxLines: 5,
                          decoration:
                              const InputDecoration(labelText: 'Description'),
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          }),
                      const SizedBox(height: 10),
                      // Card color picker
                      ColorPickerWidget(
                        text: 'Card Color: ',
                        initialColor: _cardColor,
                        onColorChanged: (color) {
                          setState(() {
                            _cardColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      // Background color picker
                      ColorPickerWidget(
                        text: 'Background Color: ',
                        initialColor: _backgroundColor,
                        onColorChanged: (color) {
                          setState(() {
                            _backgroundColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      // Text color picker
                      ColorPickerWidget(
                        text: 'Text Color: ',
                        initialColor: _textColor,
                        onColorChanged: (color) {
                          setState(() {
                            _textColor = color;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      // Padding slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Padding:'),
                          Slider(
                            value: _padding,
                            min: 0,
                            max: 32,
                            divisions: 16,
                            onChanged: (value) {
                              setState(() {
                                _padding = value;
                              });
                            },
                          ),
                        ],
                      ),
                      // Font size slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Font Size:'),
                          Slider(
                            value: _fontSize,
                            min: 10,
                            max: 40,
                            divisions: 15,
                            onChanged: (value) {
                              setState(() {
                                _fontSize = value;
                              });
                            },
                          ),
                        ],
                      ),
                      // Border radius slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Border Radius:'),
                          Slider(
                            value: _borderRadius,
                            min: 0,
                            max: 50,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                _borderRadius = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: saveWidget,
              child: const Icon(Icons.save),
            ),
          ),
        ],
      )),
    );
  }
}
