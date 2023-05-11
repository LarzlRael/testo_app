import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onFormSubmitted;
  final String? Function(String?)? validator;
  final bool? isPassword;

  const CustomTextFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.onFormSubmitted,
    this.isPassword = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(40));

    const borderRadius = Radius.circular(15);

    return Container(
      padding: const EdgeInsets.only(
        bottom: 8,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: borderRadius,
              bottomLeft: borderRadius,
              bottomRight: borderRadius),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: TextFormField(
        onChanged: widget.onChanged,
        validator: widget.validator,
        obscureText: widget.obscureText ? !showPassword : false,
        keyboardType: widget.keyboardType,
        onFieldSubmitted: widget.onFormSubmitted,
        style: const TextStyle(fontSize: 20, color: Colors.black54),
        decoration: InputDecoration(
            floatingLabelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            enabledBorder: border,
            focusedBorder: border,
            errorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.transparent)),
            focusedErrorBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.transparent)),
            isDense: true,
            label: widget.label != null ? Text(widget.label!) : null,
            hintText: widget.hint,
            errorText: widget.errorMessage,
            focusColor: colors.primary,
            //icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
            suffixIcon: widget.isPassword!
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      showPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  )
                : const SizedBox
                    .shrink() // agregando un widget vacío para evitar el warning
            ),
      ),
    );
  }
}
