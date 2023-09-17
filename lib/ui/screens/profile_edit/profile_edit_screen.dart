import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masterstudy_app/data/core/constants/assets_path.dart';
import 'package:masterstudy_app/data/env.dart';
import 'package:masterstudy_app/data/models/account.dart';
import 'package:masterstudy_app/data/utils.dart';
import 'package:masterstudy_app/main.dart';
import 'package:masterstudy_app/theme/app_color.dart';
import 'package:masterstudy_app/theme/dimensions.dart';
import 'package:masterstudy_app/ui/bloc/edit_profile_bloc/edit_profile_bloc.dart';
import 'package:masterstudy_app/ui/bloc/profile/profile_bloc.dart';
import 'package:masterstudy_app/ui/bloc/profile/profile_event.dart';
import 'package:masterstudy_app/ui/screens/change_password/change_password_screen.dart';
import 'package:masterstudy_app/ui/screens/splash/splash_screen.dart';
import 'package:masterstudy_app/ui/widgets/loader_widget.dart';
import 'package:masterstudy_app/ui/widgets/widgets.dart';

class ProfileEditScreenArgs {
  final Account? account;

  ProfileEditScreenArgs(this.account);
}

// ignore: must_be_immutable
class ProfileEditScreen extends StatelessWidget {
  static const routeName = "profileEditScreen";
  ProfileEditScreenArgs? args;
  final EditProfileBloc bloc;

  ProfileEditScreen(this.bloc) : super();

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as ProfileEditScreenArgs;
    return BlocProvider(
      create: (context) => bloc..account = args!.account!,
      child: _ProfileEditWidget(
        account: args!.account,
      ),
    );
  }
}

class _ProfileEditWidget extends StatefulWidget {
  final Account? account;

  const _ProfileEditWidget({Key? key, this.account}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProfileEditWidgetState();
}

class _ProfileEditWidgetState extends State<_ProfileEditWidget> {
  final _formKey = GlobalKey<FormState>();
  FocusNode myFocusNode = new FocusNode();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();

  var enableInputs = true;
  late bool demoEnableInputs;
  var passwordVisible = false;
  late EditProfileBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<EditProfileBloc>(context);
    passwordVisible = true;
    _firstNameController.text = _bloc.account.meta!.first_name;
    _lastNameController.text = _bloc.account.meta!.last_name;
    _emailController.text = _bloc.account.email!;
    _bioController.text = _bloc.account.meta!.description;
    _occupationController.text = _bloc.account.meta!.position!;
    _facebookController.text = _bloc.account.meta!.facebook!;
    _twitterController.text = _bloc.account.meta!.twitter;
    _instagramController.text = _bloc.account.meta!.instagram;
    if (preferences.getBool('demo') == null) {
      demoEnableInputs = false;
    } else {
      demoEnableInputs = preferences.getBool('demo')!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _occupationController.dispose();
    _passwordController.dispose();
    _facebookController.dispose();
    _twitterController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        centerTitle: true,
        title: Text(
          localizations!.getLocalization("edit_profile_title"),
          textScaleFactor: 1.0,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: BlocListener(
        bloc: _bloc,
        listener: (context, state) {
          if (state is UpdatedEditProfileState) {
            BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());

            Fluttertoast.showToast(
              msg: localizations!.getLocalization("profile_updated_message"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.grey,
              fontSize: 14.0,
            );
          }

          if (state is CloseEditProfileState) {
            //SnackBar after edit profile
            BlocProvider.of<ProfileBloc>(context).add(FetchProfileEvent());
            Fluttertoast.showToast(
              msg: localizations!.getLocalization("profile_change_canceled"),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.grey,
              fontSize: 14.0,
            );
          }

          if (state is SuccessDeleteAccountState) {
            preferences.setBool('demo', false);
            BlocProvider.of<ProfileBloc>(context).add(LogoutProfileEvent());
            Navigator.of(context).pushNamedAndRemoveUntil(
              SplashScreen.routeName,
              (Route<dynamic> route) => false,
            );
          }

          if (state is ErrorDeleteAccountState) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) => showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      localizations?.getLocalization("error_dialog_title") ?? 'Error',
                      textScaleFactor: 1.0,
                      style: TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                    content: Text(
                      localizations?.getLocalization("error_dialog_title") ?? 'Error',
                      textScaleFactor: 1.0,
                    ),
                    actions: [],
                  );
                },
              ),
            );
          }
        },
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  File? _image;

  _buildBody(state) {
    enableInputs = !(state is LoadingEditProfileState);
    Widget buildImage;
    String userRole = '';

    if (_bloc.account.roles!.isEmpty) {
      userRole = 'subscriber';
    } else {
      userRole = _bloc.account.roles![0];
    }

    ///Check avatar
    if (_image == null && (widget.account!.avatar_url != null || widget.account!.avatar_url != '')) {
      buildImage = CachedNetworkImage(
        width: 100.0,
        height: 100.0,
        fit: BoxFit.fill,
        imageUrl: widget.account!.avatar_url!,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) {
          return SizedBox(
            width: 120.0,
            child: Image.asset(ImageRasterPath.logo),
          );
        },
      );
    } else if (_image != null) {
      buildImage = Image.file(
        _image!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    } else {
      buildImage = SizedBox(
        width: 100,
        height: 100,
        child: SvgPicture.asset(
          ImageVectorPath.emptyUser,
        ),
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          //Image
          Center(
            child: Stack(
              children: [
                Container(
                  width: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8),
                    child: CircleAvatar(
                      radius: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60.0)),
                        child: buildImage,
                      ),
                    ),
                  ),
                ),
                if (_image != null)
                  Positioned(
                    right: -0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _image = null;
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          //Button "Change Photo"
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: BorderSide(color: AppColor.secondaryColor),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(AppColor.secondaryColor),
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(8)),
              ),
              onPressed: () async {
                if (demoEnableInputs) {
                  showDialogError(context, 'Demo Mode');
                } else {
                  XFile? image = await picker.pickImage(source: ImageSource.gallery);

                  if (image != null) {
                    setState(() {
                      _image = File(image.path);
                    });
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      child: SvgPicture.asset(
                        ImageVectorPath.file,
                        color: Colors.white,
                      ),
                      width: 23,
                      height: 23,
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      localizations!.getLocalization("change_photo_button"),
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          //FirstName
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextFormField(
              controller: _firstNameController,
              enabled: enableInputs,
              readOnly: demoEnableInputs,
              cursorColor: AppColor.mainColor,
              decoration: InputDecoration(
                labelText: localizations!.getLocalization("first_name"),
                filled: true,
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                ),
              ),
            ),
          ),
          //LastName
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextFormField(
              controller: _lastNameController,
              enabled: enableInputs,
              readOnly: demoEnableInputs,
              cursorColor: AppColor.mainColor,
              decoration: InputDecoration(
                labelText: localizations!.getLocalization("last_name"),
                filled: true,
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                ),
              ),
            ),
          ),
          //Occupation
          userRole != 'subscriber'
              ? Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
                  child: TextFormField(
                    controller: _occupationController,
                    enabled: enableInputs,
                    readOnly: demoEnableInputs,
                    cursorColor: AppColor.mainColor,
                    decoration: InputDecoration(
                      labelText: localizations!.getLocalization("occupation"),
                      filled: true,
                      labelStyle: TextStyle(
                        color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          //Email
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextFormField(
              controller: _emailController,
              enabled: enableInputs,
              validator: _validateEmail,
              readOnly: demoEnableInputs,
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
                  borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                ),
              ),
            ),
          ),
          //Bio
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextFormField(
              controller: _bioController,
              enabled: enableInputs,
              maxLines: 5,
              readOnly: demoEnableInputs,
              textCapitalization: TextCapitalization.sentences,
              cursorColor: AppColor.mainColor,
              decoration: InputDecoration(
                labelText: localizations!.getLocalization("bio"),
                helperText: localizations!.getLocalization("bio_helper"),
                filled: true,
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                ),
              ),
            ),
          ),
          //Facebook
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextFormField(
              controller: _facebookController,
              enabled: enableInputs,
              readOnly: demoEnableInputs,
              cursorColor: AppColor.mainColor,
              decoration: InputDecoration(
                labelText: 'Facebook',
                hintText: localizations!.getLocalization("enter_url"),
                filled: true,
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                ),
              ),
            ),
          ),
          //Twitter
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextFormField(
              controller: _twitterController,
              enabled: enableInputs,
              cursorColor: AppColor.mainColor,
              readOnly: demoEnableInputs,
              decoration: InputDecoration(
                labelText: 'Twitter',
                hintText: localizations!.getLocalization("enter_url"),
                filled: true,
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                ),
              ),
            ),
          ),
          //Instagram
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: TextFormField(
              controller: _instagramController,
              enabled: enableInputs,
              cursorColor: AppColor.mainColor,
              readOnly: demoEnableInputs,
              decoration: InputDecoration(
                labelText: 'Instagram',
                hintText: localizations!.getLocalization("enter_url"),
                filled: true,
                labelStyle: TextStyle(
                  color: myFocusNode.hasFocus ? Colors.black : Colors.black,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.mainColor, width: 2),
                ),
              ),
            ),
          ),
          //Button Save
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: SizedBox(
              height: kButtonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.mainColor,
                ),
                onPressed: state is LoadingEditProfileState
                    ? null
                    : () {
                        if (demoEnableInputs) {
                          showDialogError(context, 'Demo Mode');
                        } else {
                          if (_formKey.currentState!.validate()) {
                            _bloc.add(
                              SaveEvent(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                password: _passwordController.text,
                                description: _bioController.text,
                                position: _occupationController.text,
                                facebook: _facebookController.text,
                                twitter: _twitterController.text,
                                instagram: _instagramController.text,
                                photo: _image,
                              ),
                            );
                          }
                        }
                      },
                child: state is LoadingEditProfileState
                    ? LoaderWidget()
                    : Text(
                        localizations!.getLocalization("save_button"),
                        textScaleFactor: 1.0,
                      ),
              ),
            ),
          ),
          // Button Change Password
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: new MaterialButton(
              minWidth: double.infinity,
              color: AppColor.mainColor,
              onPressed: () {
                if (demoEnableInputs) {
                  showDialogError(context, 'Demo Mode');
                } else {
                  Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
                }
              },
              child: Text(
                localizations?.getLocalization("change_password") ?? 'Change Password',
                textScaleFactor: 1.0,
              ),
              textColor: Colors.white,
            ),
          ),
          // Button Delete Account
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 18.0),
            child: new MaterialButton(
              minWidth: double.infinity,
              color: Colors.red.shade600,
              onPressed: () {
                if (demoEnableInputs) {
                  showDialogError(context, 'Demo Mode');
                } else {
                  showDeleteAccountDialog(context, state);
                }
              },
              child: Text(
                localizations?.getLocalization("delete_account") ?? 'Delete Account',
                textScaleFactor: 1.0,
              ),
              textColor: Colors.white,
            ),
          ),
          // Cancel button
          Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              right: 18.0,
            ),
            child: TextButton(
              child: Text(
                localizations!.getLocalization("cancel_button"),
                textScaleFactor: 1.0,
                style: TextStyle(color: AppColor.mainColor),
              ),
              onPressed: () => _bloc.add(CloseScreenEvent()),
            ),
          )
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null) {
      // The form is empty
      return localizations!.getLocalization("email_empty_error_text");
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return localizations!.getLocalization("email_invalid_error_text");
  }

  showDeleteAccountDialog(BuildContext context, EditProfileState state) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        localizations!.getLocalization("cancel_button"),
        textScaleFactor: 1.0,
        style: TextStyle(
          color: AppColor.mainColor,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: state is LoadingDeleteAccountState
          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator())
          : Text(
              localizations?.getLocalization("delete_account") ?? 'Delete Account',
              textScaleFactor: 1.0,
              style: TextStyle(color: AppColor.mainColor),
            ),
      onPressed: state is LoadingDeleteAccountState
          ? null
          : () {
              BlocProvider.of<EditProfileBloc>(context)
                  .add(DeleteAccountEvent(accountId: int.parse(widget.account!.id.toString())));
            },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(localizations?.getLocalization("delete_account") ?? 'Delete Account',
          textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontSize: 20.0)),
      content: Text(
        /*localizations?.getLocalization("delete_account_subscription") ??*/
        localizations?.getLocalization("delete_account_subscription") ?? "Do you really want to delete account?",
        textScaleFactor: 1.0,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

Widget setUpButtonChild(enable) {
  if (enable == true) {
    return new Text(
      localizations!.getLocalization("save_button"),
      textScaleFactor: 1.0,
    );
  } else {
    return SizedBox(
      width: 30,
      height: 30,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.white),
      ),
    );
  }
}
