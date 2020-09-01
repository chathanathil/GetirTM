class AppContent {
  final Map<String, dynamic> myProfile;
  final Map<String, dynamic> myAddresses;
  final Map<String, dynamic> myOrders;
  final Map<String, dynamic> favourites;
  final Map<String, dynamic> discountCart;
  final Map<String, dynamic> home;
  final Map<String, dynamic> privacy;
  final Map<String, dynamic> terms;
  final Map<String, dynamic> faq;
  final Map<String, dynamic> feedback;
  final Map<String, dynamic> about;
  final Map<String, dynamic> contact;
  final Map<String, dynamic> version;
  final Map<String, dynamic> language;
  final Map<String, dynamic> login;
  final Map<String, dynamic> logout;
  final Map<String, dynamic> name;
  final Map<String, dynamic> callCustomerService;
  final Map<String, dynamic> yes;
  final Map<String, dynamic> no;

  AppContent(
      {this.myOrders,
      this.privacy,
      this.name,
      this.terms,
      this.faq,
      this.favourites,
      this.feedback,
      this.callCustomerService,
      this.yes,
      this.no,
      this.contact,
      this.version,
      this.language,
      this.login,
      this.logout,
      this.myProfile,
      this.discountCart,
      this.home,
      this.myAddresses,
      this.about});

  factory AppContent.fromJson(Map<String, dynamic> json) {
    return AppContent(
      myProfile: json['myProfile'] as Map<String, dynamic>,
      myAddresses: json['myAddresses'] as Map<String, dynamic>,
      discountCart: json['discountCart'] as Map<String, dynamic>,
      favourites: json['favourites'] as Map<String, dynamic>,
      myOrders: json['myOrders'] as Map<String, dynamic>,
      home: json['home'] as Map<String, dynamic>,
      terms: json['terms'] as Map<String, dynamic>,
      privacy: json['privacy'] as Map<String, dynamic>,
      login: json['login'] as Map<String, dynamic>,
      logout: json['logout'] as Map<String, dynamic>,
      version: json['version'] as Map<String, dynamic>,
      language: json['language'] as Map<String, dynamic>,
      faq: json['faq'] as Map<String, dynamic>,
      feedback: json['feedback'] as Map<String, dynamic>,
      contact: json['contact'] as Map<String, dynamic>,
      about: json['about'] as Map<String, dynamic>,
      name: json['name'] as Map<String, dynamic>,
      callCustomerService:
          json['call_customer_service'] as Map<String, dynamic>,
      yes: json['yes'] as Map<String, dynamic>,
      no: json['no'] as Map<String, dynamic>,
    );
  }
}
