class ReferralService {
  ReferralService._();
  static final ReferralService instance = ReferralService._();

  static const _validCodes = {
    'COCONUTTIES',
    'MANGOTRAVEL',
    'HOAZEN',
    'FLUENTISH',
    'MISSPAOLA',
  };

  bool isValid(String code) =>
      _validCodes.contains(code.trim().toUpperCase());
}
