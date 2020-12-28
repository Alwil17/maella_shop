import 'package:flutter/material.dart';
import 'package:maella_shop/component/loader.dart';
import 'package:maella_shop/component/profileAppBar.dart';
import 'package:maella_shop/services/profileService.dart';
import 'package:maella_shop/services/validateService.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValidateService _validateService  = new ValidateService();
  ProfileService _profileService = new ProfileService();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  bool showCartIcon = true;
  bool _autoValidate = false;
  String firstName, lastName, mobileNumber, email;

  setProfileDetails(){
    dynamic args = ModalRoute.of(context).settings.arguments;
    setState(() {
      firstName = args['firstName'];
      lastName = args['lastName'];
      mobileNumber = args['mobileNumber'];
      email = args['email'];
    });
  }

  InputDecoration customFormField(text){
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: text,
      labelText: text,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
              width: 2.0,
              color: Colors.black
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
              width: 2.0,
              color: Colors.black
          )
      ),
    );
  }

  validateProfile(context) async{
    if(this._formKey.currentState.validate()){
      _formKey.currentState.save();
      Loader.showLoadingScreen(context, _keyLoader);
      await _profileService.updateAccountDetails(firstName, lastName, email, mobileNumber);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    else{
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    setProfileDetails();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      appBar: ProfileAppBar('Modification du profil', context),
      body: Container(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0),
                child: Text(
                  'PROFIL PUBLIC',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 40.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        decoration: customFormField('Prenoms'),
                        initialValue: firstName,
                        keyboardType: TextInputType.text,
                        validator: (value)=> _validateService.isEmptyField(value),
                        onSaved: (String value) => firstName = value,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: customFormField('Nom'),
                      initialValue: lastName,
                      keyboardType: TextInputType.text,
                      validator: (value)=> _validateService.isEmptyField(value),
                      onSaved: (String value) => lastName = value,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                child: Text(
                  'INFORMATION PRIVEES',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: customFormField('E-mail'),
                      initialValue: email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value)=> _validateService.isEmptyField(value),
                      onSaved: (String value) => email = value,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: customFormField('Contact'),
                      initialValue: mobileNumber,
                      validator: (value)=> _validateService.isEmptyField(value),
                      keyboardType: TextInputType.phone,
                      onSaved: (String value) => mobileNumber = value,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200],
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          child: ButtonTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                side: BorderSide(color: Colors.black,width: 2.0)
            ),
            minWidth: MediaQuery.of(context).size.width,
            height: 50.0,
            child: RaisedButton(
              color: Colors.white,
              onPressed: (){
                validateProfile(context);
              },
              child: Text(
                'METTRE A JOUR',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
