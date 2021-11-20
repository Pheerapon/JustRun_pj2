import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_habit_run/app/widget_support.dart';
import 'package:flutter_habit_run/common/constant/colors.dart';
import '../bloc/create_group/bloc_create_group.dart';

class FormCreateGroup extends StatefulWidget {
  const FormCreateGroup({Key key, this.controller, this.label, this.focusNode})
      : super(key: key);
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  @override
  _FormCreateGroupState createState() => _FormCreateGroupState();
}

class _FormCreateGroupState extends State<FormCreateGroup> {
  String _nameGroupError;

  UnderlineInputBorder createInputDecoration() {
    return UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).color3));
  }

  Widget checkErrorText(String error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            onFieldSubmitted: (term) {
              widget.focusNode.unfocus();
            },
            style: AppWidget.simpleTextFieldStyle(
                color: Theme.of(context).color7, fontSize: 16, height: 24),
            decoration: InputDecoration(
              hintText: widget.label,
              hintStyle: AppWidget.simpleTextFieldStyle(
                  fontSize: 16, height: 24, color: Theme.of(context).color7),
              focusedErrorBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide(color: primary)),
              errorBorder: createInputDecoration(),
              focusedBorder: createInputDecoration(),
              enabledBorder: createInputDecoration(),
            )),
        error != null
            ? Text(
                error,
                style: AppWidget.simpleTextFieldStyle(
                    fontSize: 12, height: 18, color: primary),
              )
            : const SizedBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateGroupBloc, CreateGroupState>(
      builder: (context, state) {
        if (state is CreateGroupFailure) {
          _nameGroupError = state.errorNameGroup;
        }
        if (state is CreateGroupSuccess) {
          _nameGroupError = null;
        }
        return checkErrorText(_nameGroupError);
      },
    );
  }
}
