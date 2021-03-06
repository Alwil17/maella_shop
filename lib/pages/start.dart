import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:maella_shop/services/userService.dart';


class Start extends StatelessWidget{
  final UserService _userService = new UserService();

  validateToken(context) async{
    final storage = new FlutterSecureStorage();
    String value = await storage.read(key: 'token');
    if(value != null){
      String decodedToken = _userService.validateToken(value);
      if(decodedToken != null){
        Navigator.of(context).pushReplacementNamed('/home');
      }
      else{
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
    else{
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 100.0),
                Image.asset('assets/sIcon.png', height: 100.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: Text(
                      'Bienvenue sur Maella Shop',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NovaSquare',
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48.0, 15.0, 48.0, 0.0),
                  child: Text(
                    'Shop & get updates on new Products and sales with our mobile app',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 19.0,
                        letterSpacing: 1.0
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: ButtonTheme(
                    minWidth: 220.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text(
                        'Connexion',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                        validateToken(context);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                  child: ButtonTheme(
                    minWidth: 220.0,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36),
                          side: BorderSide(color: Colors.black)
                      ),
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text(
                        'Inscription',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
