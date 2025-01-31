part of '../fields.dart';

class ServerNameField extends StatelessWidget {
  final FormGroup form;
  final VoidCallback onSubmitted;

  const ServerNameField(
      {Key? key, required this.form, required this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
        formControlName: FieldsType.SERVER_NAME.getValue(),
        onSubmitted: onSubmitted,
        textInputAction: TextInputAction.next,
        autofocus: true,
        keyboardType: TextInputType.name,
        style: INPUT_TEXT_STYLE,
        decoration: InputDecoration(
            labelText: 'server_name_field_label'.tr(),
            labelStyle: INPUT_TEXT_STYLE,
            prefixIcon: Icon(Icons.label_outline, color: Colors.black),
            border: DEFAULT_BORDER,
            errorBorder: ERROR_BORDER,
            enabledBorder: ENABLED_BORDER,
            focusedBorder: FOCUSED_BORDER));
  }
}
