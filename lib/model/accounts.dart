class Accounts {
  String mail;
  String password;
  String name;
  String surname;
  String phone;

  Accounts(this.mail, this.password, this.name, this.surname,this.phone);

  Accounts.forAuth(this.mail, this.password);
  
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["mail"] = mail;
    map["password"] = password;
    map["name"] = name;
    map["surname"] = surname;
    map["phone"] = phone;
    return map;
  }

  Accounts.fromMap(Map<String, dynamic> gelenMap) {
    this.mail = gelenMap["mail"];
    this.password = gelenMap["password"];
    this.name = gelenMap["name"];
    this.surname = gelenMap["surname"];
    this.phone = gelenMap["phone"];
  }
}