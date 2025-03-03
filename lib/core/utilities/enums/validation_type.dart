enum ValidationType {
  none,
  required,
  onlyNumbers,
  onlyNumbersWithDecimal,
  onlyNumbersWithoutDecimal,
  email,
  phoneNumber,
  password,
  fullName,
  name,
  egyptainFullName,
  nationalId,
  passport,
  positiveIntOrDouble,
  isPositiveNumberGreaterThanOrEqual,
  onlyEnglishLetters,
  onlyArabicLetters,
  jobTitle,
  company,
  companyWebsite,
  socialLink,
  address, // Add this for address validation
  personalLink, // Add this for general personal links
  instagramAccount, // Add this for Instagram validation
  tiktokAccount, // Add this for TikTok validation
  linkedinAccount, // Add this for LinkedIn validation
  facebookAccount, // Add this for Facebook validation
  youtubeChannel, // Add this for YouTube validation
  xAccount, // Add this for X (Twitter) validation
  dropdown,
}
