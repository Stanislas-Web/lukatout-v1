import 'package:flutter/services.dart';
import 'package:lukatout/locale/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransAcademiaPasswordField extends StatefulWidget {
  const TransAcademiaPasswordField(
      {super.key,
      this.controller,
      this.hintText,
      this.validator,
      this.color,
      this.focusNode,
      this.label,
      this.field,
      this.fieldValue,
      this.onEditingComplete});
  final TextEditingController? controller;
  final String? hintText;
  final String? validator;
  final String? label;
  final Color? color;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final String? field;
  final String? fieldValue;
  @override
  // ignore: library_private_types_in_public_api
  _TransAcademiaPasswordFieldState createState() =>
      _TransAcademiaPasswordFieldState();
}

class _TransAcademiaPasswordFieldState
    extends State<TransAcademiaPasswordField> {
  bool obscure = true;
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = widget.fieldValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        toolbarOptions: const ToolbarOptions(
          copy: true,
          cut: true,
          paste: false,
          selectAll: false,
        ),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(4),
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        controller: _controller,
        obscureText: obscure,
        onChanged: (String value) {
          BlocProvider.of<SignupCubit>(context).updateField(context,
              data: value.toString(), field: widget.field.toString());
        },
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () => setState(() => obscure = !obscure),
            child: Icon(
              obscure ? Icons.visibility_off : Icons.visibility,
              color: obscure
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).backgroundColor,
            ),
          ),

          label: Text(
            widget.label.toString(),
            style: TextStyle(
              color: Theme.of(context).backgroundColor,
            ),
          ),
          hintText: widget.hintText,
          // hintStyle: const TextStyle(color: Colors.black54),
          border: myinputborder(), //normal border
          enabledBorder: myfocusborder(context), //enabled border
          focusedBorder: myfocusborder(context), //focused border
          // set more border style like disabledBorder
        ));
  }
}

OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return const OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        // color: Colors.redAccent,
        width: 1,
      ));
}

OutlineInputBorder myfocusborder(context) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Theme.of(context).backgroundColor,
        // color: const Brightness.light,
        width: 1,
      ));
}
