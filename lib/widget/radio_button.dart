import 'package:flutter/material.dart';

class RadioButton<T> extends StatefulWidget {
  /// Creates a material design radio button.
  ///
  /// The radio button itself does not maintain any state. Instead, when the
  /// radio button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio button with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  const RadioButton({
    Key key,
    @required this.value,
    @required this.groupValue,
    @required this.title,
    @required this.onChanged,
    this.activeColor,
    this.materialTapTargetSize,
  }) : super(key: key);

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for this group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final T groupValue;

  // The label to be shown.
  final String title;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio button with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// Radio<SingingCharacter>(
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<T> onChanged;

  /// The color to use when this radio button is selected.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  final Color activeColor;

  /// Configures the minimum size of the tap target.
  ///
  /// Defaults to [ThemeData.materialTapTargetSize].
  ///
  /// See also:
  ///
  ///   * [MaterialTapTargetSize], for a description of how this affects tap targets.
  final MaterialTapTargetSize materialTapTargetSize;

  @override
  _RadioButtonState<T> createState() => _RadioButtonState<T>();
}

class _RadioButtonState<T> extends State<RadioButton<T>>
    with TickerProviderStateMixin {
  bool get _enabled => widget.onChanged != null;

  void _handleChanged(bool selected) {
    if (selected) widget.onChanged(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    bool selected = widget.value == widget.groupValue;

    return OutlineButton(
      highlightedBorderColor: themeData.accentColor,
      borderSide: selected ? BorderSide(color: themeData.accentColor) : null,
      child: selected
          ? Text(widget.title)
          : Text(
              widget.title,
              style: TextStyle(color: Colors.grey),
            ),
      onPressed: () {
        _handleChanged(_enabled);
      },
    );
  }
}
