import 'dart:math';
import 'package:sms/sms.dart';

class SimpleOtp {
  int _otp, _minOtpValue, _maxOtpValue; // Generated OTP

  void generateOtp([int min = 1000, int max = 9999]) {
    //Generates four digit OTP by default
    _minOtpValue = min;
    _maxOtpValue = max;
    _otp = _minOtpValue + Random().nextInt(_maxOtpValue - _minOtpValue);
  }

  void sendOtp(String phoneNumber,
      [String messagePrefix,
      String messageSuffix,
      String countryCode = '+82',
      int min = 1000,
      int max = 9999,]) {
    //function parameter 'message' is optional.
    generateOtp(min, max);
    SmsSender sender = new SmsSender();
    String address = (countryCode ?? '+82') + phoneNumber;

    sender.sendSms(new SmsMessage(
        address, (messagePrefix ?? '[Revault] 인증번호는 [') + _otp.toString() + (messageSuffix ?? ']입니다')));
  }

  bool resultChecker(int enteredOtp) {
    //To validate OTP
    return enteredOtp == _otp;
  }
}