import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';
import 'package:lukatout/theme.dart';

class LukaAdresseInput extends StatefulWidget {
  const LukaAdresseInput(
      {super.key,
      this.field,
      this.fieldValue,
      this.controller,
      this.color,
      this.hintText,
      this.validator,
      this.label,
      this.number});
  final TextEditingController? controller;
  final String? hintText;
  final String? validator;
  final Color? color;
  final int? number;
  final String? label;
  final String? field;
  final String? fieldValue;
  @override
  // ignore: library_private_types_in_public_api
  _LukaAdresseInputState createState() => _LukaAdresseInputState();
}

class _LukaAdresseInputState extends State<LukaAdresseInput> {
  // final GlobalKey<ScaffoldState> _fieldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text =widget.fieldValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        
        return TextField(
         
          key: widget.key,
            onChanged: (String value) {
              BlocProvider.of<SignupCubit>(context)
                  .updateField(context, data: value.toString(), field: widget.field.toString());
            },
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.place_outlined, color: LukaPrimary,),
              // label: Text(
              //   widget.label.toString(),
              //   style: TextStyle(
              //     color: Theme.of(context).backgroundColor,
              //   ),
              // ),
              hintText: widget.hintText,
              // hintStyle: const TextStyle(color: Colors.black54),
              border: myinputborder(), //normal border
              enabledBorder: myfocusborder(context), //enabled border
              focusedBorder: myfocusborder(context),
              //focused border
              // set more border style like disabledBorder
            ));
      },
    );
  }
}

OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return const OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Colors.redAccent,
        width: 1,
      ));
}

OutlineInputBorder myfocusborder(context) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        // color: Colors.black26,
        color: Colors.white,
        width: 1,
      ));
}
