const passwordRegex =
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,}$';
const nameRegex = r'^[A-Za-z\s]{1,40}$';
const phoneRegex = r'^[\d]{10}';
const idTypeRegex = r'^[\d-]*$';
const phoneLocalRegex = r'^[\d]*$';
const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
const nitRegex = r'^\d+(-\d+)*-?$';

extension StringX on String {
  bool get validateName => RegExp(nameRegex).hasMatch(this);
  bool get validatePassword => RegExp(passwordRegex).hasMatch(this);
  bool get validatePhone => RegExp(phoneRegex).hasMatch(this);
  bool get validateEmail => RegExp(emailRegex).hasMatch(this);
}
