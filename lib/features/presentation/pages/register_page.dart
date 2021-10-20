import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vantypesapp/core/error/failure.dart';
import 'package:vantypesapp/features/presentation/bloc/registration/registration_bloc.dart';

import '../../../injection_container.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerKey = GlobalKey<FormState>();
  String userName, inputEmail, password, passwordConf;
  RegistrationBloc registrationBloc;

  @override
  void initState() {
    registrationBloc = sl<RegistrationBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.blue,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: BlocListener<RegistrationBloc, RegistrationState>(
            bloc: registrationBloc,
            listener: (BuildContext context, state) {
              if (state is RegistrationSuccess) {
                print("success");
                Navigator.of(context).pushReplacementNamed('/main');
              } else if (state is RegistrationError) {
                print(state.message);
              }
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Form(
                  key: _registerKey,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1,
                        left: 15,
                        right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image(
                          image: AssetImage('assets/images/login.png'),
                          width: MediaQuery.of(context).size.width / 3.5,
                          color: Theme.of(context).accentColor,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.subtitle2,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: "username_hint".tr(),
                            labelText: "username".tr(),
                          ),
                          onChanged: (value) {
                            userName = value;
                          },
                          onSaved: (String value) {
                            userName = value;
                          },
                          validator: (String value) {
                            return value.isEmpty ? 'username_man'.tr() : null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.subtitle2,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: "email_man".tr(),
                            labelText: "email".tr(),
                          ),
                          onChanged: (value) {
                            inputEmail = value;
                          },
                          onSaved: (String value) {
                            inputEmail = value;
                          },
                          validator: (String value) {
                            return value.isEmpty ? 'email_man'.tr() : null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          style: Theme.of(context).textTheme.subtitle2,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: "password_hint".tr(),
                            labelText: "password".tr(),
                          ),
                          onChanged: (value) {
                            password = value;
                          },
                          onSaved: (String value) {
                            password = value;
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "password_man".tr();
                            } else if (value != passwordConf) {
                              return "";
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          obscureText: true,
                          style: Theme.of(context).textTheme.subtitle2,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(),
                            hintText: "password_hint".tr(),
                            labelText: "password_again".tr(),
                          ),
                          onChanged: (value) {
                            passwordConf = value;
                          },
                          onSaved: (String value) {
                            passwordConf = value;
                          },
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "password_conf_man".tr();
                            } else if (value != password) {
                              return "password_conf_err".tr();
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_registerKey.currentState.validate()) {
                              registrationBloc.add(RegisterEvent(
                                  userName: userName,
                                  email: inputEmail,
                                  password: password));
                            }
                          },
                          child: Text(
                            "register".tr(),
                            style: Theme.of(context).textTheme.button,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
