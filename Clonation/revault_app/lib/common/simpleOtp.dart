import 'dart:math';
//import 'package:flutter_sms/flutter_sms.dart';
import 'package:sms/sms.dart';

class SimpleOtp {
  int _otp, _minOtpValue, _maxOtpValue;

  void generateOtp([int min = 1000, int max = 9999]) {
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

  // TODO: flutter_sms로 바꾸기
  // void sendOTP(List<String> recipents) async {
  //   try {
  //     generateOtp(1000, 9999);
  //     String _result = await sendSMS(
  //       message: '[Revault] 인증번호는 [$_otp]입니다',
  //       recipients: recipents
  //     );
  //     print(_result);
  //   }
  //   catch (error) {
  //     print(error);
  //   }
  // }

  // void canSendOTP() async {
  //   bool _result = await canSendSMS();
  // }

}