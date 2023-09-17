import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/ui/bloc/restore_password/restore_password_bloc.dart';
import 'package:masterstudy_app/ui/widgets/alert_dialogs.dart';
import 'package:masterstudy_app/ui/widgets/loader_widget.dart';

class RestorePasswordScreen extends StatelessWidget {
  static const routeName = "restorePasswordScreen";
  final RestorePasswordBloc bloc;

  const RestorePasswordScreen(this.bloc) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
      ),
      body: BlocProvider<RestorePasswordBloc>(
        create: (context) => bloc,
        child: _RestorePasswordWidget(),
      ),
    );
  }
}

class _RestorePasswordWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RestorePasswordWidgetState();
}

class _RestorePasswordWidgetState extends State<_RestorePasswordWidget> {
  late RestorePasswordBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  FocusNode myFocusNode = new FocusNode();

  @override
  void initState() {
    _bloc = BlocProvider.of<RestorePasswordBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SuccessRestorePasswordState) {
          Fluttertoast.showToast(
            msg: localizations?.getLocalization("restore_password_info") ?? "Restore password, check email",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            fontSize: 14.0,
          );
        }
          
        if (state is ErrorRestorePasswordState) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => showAlertDialog(
              context,
              content: state.message,
            ),
          );
        }
      },
      child: BlocBuilder<RestorePasswordBloc, RestorePasswordState>(
        bloc: _bloc,
        builder: (context, state) {
          var enableInputs = !(state is LoadingRestorePasswordState);
          return Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
              child: Column(
                children: [
                  //Email
                  TextFormField(
                    controller: _emailController,
                    enabled: enableInputs,
                    cursorColor: AppColor.mainColor,
                    decoration: InputDecoration(
                      labelText: localizations!.getLocalization("email_label_text"),
                      helperText: localizations!.getLocalization("email_helper_text"),
                      filled: true,
                      labelStyle: TextStyle(
                        color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mainColor),
                      ),
                    ),
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 20.0),
                  //Button "Restore password"
                  MaterialButton(
                    minWidth: double.infinity,
                    color: AppColor.mainColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _bloc.add(SendRestorePasswordEvent(_emailController.text));
                      }
                    },
                    child: state is LoadingRestorePasswordState
                        ? LoaderWidget()
                        : Text(
                            localizations?.getLocalization("restore_password_button") ?? 'Restore Password',
                            textScaleFactor: 1.0,
                          ),
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
