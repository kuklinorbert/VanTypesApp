import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:vantypesapp/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:vantypesapp/features/presentation/widgets/snackbar.dart';

import '../../../../injection_container.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String inputEmail;
  String inputPassword;
  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();
  AuthBloc authBloc;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    authBloc = sl<AuthBloc>()..add(CheckAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: _buildBody(context),
        ),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is LoginErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(buildSnackBar(context, state.message));
        } else if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (BuildContext context, state) {
          if (state is CheckingAuthState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LoggingInState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is Authenticated) {
            return Center(child: CircularProgressIndicator());
          } else {
            return _buildForm(context);
          }
        },
      ),
    );
  }

  _buildForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Form(
        key: _loginKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Image(
                image: AssetImage('assets/images/login.png'),
                width: MediaQuery.of(context).size.width / 2.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
              SizedBox(
                height: 30.0,
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
                height: 30.0,
              ),
              TextFormField(
                obscureText: true,
                style: Theme.of(context).textTheme.subtitle2,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(),
                  hintText: "password_man".tr(),
                  labelText: "password".tr(),
                ),
                onChanged: (value) {
                  inputPassword = value;
                },
                onSaved: (String value) {
                  inputPassword = value;
                },
                validator: (String value) {
                  return value.isEmpty ? 'password_man'.tr() : null;
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_loginKey.currentState.validate()) {
                    authBloc.add(
                        LoginEvent(email: inputEmail, password: inputPassword));
                  }
                },
                child: Text(
                  "login".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: Text(
                  "register".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
