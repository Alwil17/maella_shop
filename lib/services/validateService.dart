class ValidateService{
  String isEmptyField(String value) {
    if (value.isEmpty) {
      return 'Obligatoire';
    }
    return null;
  }

  String validatePhoneNumber(String value){
    String isEmpty = isEmptyField(value);
    int len = value.length;

    if(isEmpty != null){
      return isEmpty;
    }
    else if(len != 8){
      return "Le numero de telephone est compose de 8 chiffres";
    }
    return null;
  }

  String validateEmail(String value){
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    String isEmpty = isEmptyField(value);

    if(isEmpty != null){
      return isEmpty;
    }
    else if(!regExp.hasMatch(value)){
      return "Email invalide";
    }
    return null;
  }

  String validatePassword(String value){
    String isEmpty = isEmptyField(value);
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    RegExp regExp = new RegExp(pattern);

    if(isEmpty != null){
      return isEmpty;
    }
    else if(!regExp.hasMatch(value)){
      return "Le mot de passe doit contenir au minimum 8 caracteres dont au moins 1 chiffre et 1 lettre";
    }
    return null;
  }
}