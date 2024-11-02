class MyUser {
  final String odataContext;
  final List<dynamic>? businessPhones;
  final String displayName;
  final String givenName;
  final String? jobTitle;
  final String? mail;
  final String? mobilePhone;
  final String? officeLocation;
  final String? preferredLanguage;
  final String? surname;
  final String? userPrincipalName;
  final String? id;

  MyUser({
    required this.odataContext,
    required this.businessPhones,
    required this.displayName,
    required this.givenName,
    this.jobTitle,
    this.mail,
    this.mobilePhone,
    this.officeLocation,
    required this.preferredLanguage,
    required this.surname,
    required this.userPrincipalName,
    required this.id,
  });

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      odataContext: json['@odata.context'],
      businessPhones: json['businessPhones'],
      displayName: json['displayName'],
      givenName: json['givenName'],
      jobTitle: json['jobTitle'],
      mail: json['mail'],
      mobilePhone: json['mobilePhone'],
      officeLocation: json['officeLocation'],
      preferredLanguage: json['preferredLanguage'],
      surname: json['surname'],
      userPrincipalName: json['userPrincipalName'],
      id: json['id'],
    );
  }
}
