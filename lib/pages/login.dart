import 'package:aibstract_app/services/analytics.dart';
import 'package:aibstract_app/utils/common_widgets.dart';
import 'package:aibstract_app/utils/strings.dart';
import 'package:aibstract_app/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.auth, this.analytics, {this.loginCallback}) {}
  final BaseAuth auth;
  final BaseAnalytics analytics;

  final VoidCallback loginCallback;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _errorMessage;

  bool _isLoginForm;
  bool _isLoading;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter login demo'),
      ),
      body: Stack(
        children: <Widget>[
          _showForm(),
          CommonWidgets.circularLoadingProgress(_isLoading),
        ],
      ),
    );
  }

  Widget _showForm() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            showRepeatPasswordInput(),
            showPrimaryButton(),
            showSecondaryButton(),
            showErrorMessage(),
          ],
        ),
      ),
    );
  }

  // Check if form is valid before perform login or signup
  bool validateFormAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (!validateFormAndSave()) return;

    FirebaseUser user = null;
    try {
      if (_isLoginForm) {
        user = await widget.auth.signIn(_email, _password);
        print('Signed in: ${user.uid}');
      } else {

        user = await widget.auth.signUp(_email, _password);
        //widget.auth.sendEmailVerification();
        //_showVerifyEmailSentDialog();
        print('Signed up user: ${user.uid}');
      }
      setState(() {
        _isLoading = false;
      });

      if (user != null && _isLoginForm) {
        widget.loginCallback?.call();
      }

      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool(Keys.loggedIn, true);
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
          builder: (ctx) => HomePage(widget.auth, widget.analytics, user: user)));

    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = e.message.toString();
        _formKey.currentState.reset();
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }
  
//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset(Assets.logo),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: new InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: Strings.emailFieldHint,
          prefixIcon: new Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
            value.isEmpty ? Strings.emailValidatorEmpty : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        obscureText: true,
        decoration: new InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          hintText: Strings.passwordFieldHint,
          prefixIcon: new Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: (value) =>
            value.isEmpty ? Strings.passwordValidatorEmpty : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showRepeatPasswordInput() {
    if (_isLoginForm)
      return Container(
        height: 0.0,
      );
    else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: new TextFormField(
          obscureText: true,
          decoration: new InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            hintText: Strings.passwordRepeatFieldHint,
            prefixIcon: new Icon(
              Icons.lock,
              color: Colors.grey,
            ),
          ),
          validator: (value) => value.trim() == _password
              ? Strings.passwordValidatorDoesntMatch
              : null,
        ),
      );
    }
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            _isLoginForm
                ? Strings.createAccountText
                : Strings.alreadyHaveAccountText,
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: new RaisedButton(
          elevation: 5.0,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: new Text(
              _isLoginForm
                  ? Strings.loginButtonText
                  : Strings.createAccountButtonText,
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }
}
