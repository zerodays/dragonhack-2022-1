class Address {
  final String streetAddress;
  final String addressLocality;
  final String postalCode;
  final String addressCountry;

  const Address(
      {required this.streetAddress,
      required this.addressLocality,
      required this.postalCode,
      required this.addressCountry});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        streetAddress: json['street_address'],
        addressLocality: json['address_locality'],
        postalCode: json['postal_code'],
        addressCountry: json['address_country']);
  }
}
