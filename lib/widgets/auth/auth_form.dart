import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterfirebasechatapp/picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final bool isLoading;
  final void Function(String email, String userName, String password,
      bool isLogin, BuildContext context, File userImage) _submitFn;

  const AuthForm(this._submitFn, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = "";
  var _userName = "";
  var _userPasswrod = "";
  var _userImageFile = File('');

  void _pickedImage(File image) {
    setState(() {
      _userImageFile = image;
    });

  }

  void _trySubmit() {
    final bool isVAlid = _formKey.currentState?.validate() as bool;

    FocusScope.of(context).unfocus();

    if (_userImageFile.path.isEmpty && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
          'Please pick an image',
        ),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (isVAlid) {
      _formKey.currentState?.save();
      print(_userName.trim());
      print(_userEmail.trim());
      print(_userPasswrod.trim());
      widget._submitFn(_userEmail, _userName, _userPasswrod, _isLogin, context, _userImageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter valid email address.';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'EmailAddress',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: true,
                      key: ValueKey('name'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 character';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userName = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'UserName',
                      ),
                    ),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'Password at least 7 character long';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPasswrod = value!;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Signup'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create New Account'
                            : 'I alread have Account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
