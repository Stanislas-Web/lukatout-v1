import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lukatout/business_logic/cubit/signup/cubit/signup_cubit.dart';

class TransAcademiaPhoneNumberFlag extends StatefulWidget {
  const TransAcademiaPhoneNumberFlag({
    Key? key,
    this.controller,
    this.color,
    this.hintText,
    this.validator,
    this.field,
    this.fieldValue,
    this.number,
  }) : super(key: key);

  final TextEditingController? controller;
  final String? hintText;
  final String? validator;
  final Color? color;
  final int? number;
  final String? field;
  final String? fieldValue;

  @override
  _TransAcademiaPhoneNumberFlagState createState() =>
      _TransAcademiaPhoneNumberFlagState();
}

class _TransAcademiaPhoneNumberFlagState extends State<TransAcademiaPhoneNumberFlag> {
  TextEditingController _controller = TextEditingController();
  String? pays;
  String? codePays;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.fieldValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return phoneForm(context, _controller, widget.field, pays, codePays);
  }
}

Widget phoneForm(context, _controller, field, pays, codePays) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).backgroundColor, width: 1),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 90,
          padding: const EdgeInsets.only(bottom: 4.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(.1),
                width: 2,
              ),
            ),
          ),
          child: CountryCodePicker(
            onChanged: (CountryCode value) {
              pays = value.name;
              codePays = value.dialCode;
              print(value.name);
              print(value.dialCode);
            },
            initialSelection: 'CD',
            favorite: ['+243', 'CD'],
            showCountryOnly: true,
            showOnlyCountryWhenClosed: true,
            alignLeft: false,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.tertiary.withOpacity(.1),
                  width: 2,
                ),
              ),
            ),
            child: Row(
              // direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      onChanged: (value) {
                        BlocProvider.of<SignupCubit>(context).updateField(
                            context,
                            data: value.toString(),
                            field: field.toString());
                      },
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(9),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: _controller,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8),
                        border: InputBorder.none,
                        hintText: "XXX XXX XXX",
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Ink(
                  width: 40,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      BlocProvider.of<SignupCubit>(context).updateField(context,
                          data: "", field: field.toString());
                      _controller.text = "";
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: const Icon(
                      Icons.highlight_remove,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    
  );
}
