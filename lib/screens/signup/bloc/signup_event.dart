part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

class SignupSendOtp extends SignupEvent {
  final String phone, hash;
  SignupSendOtp({required this.phone, required this.hash});
}

class SignupValidateOtp extends SignupEvent {
  final String phone, otp;
  final SignupTypes type;
  SignupValidateOtp({required this.phone, required this.otp, required this.type});
}

class SignupSubmitStepOne extends SignupEvent {
  final String fname, lname, fatherName, nc, certId, sex, birthDate, place, job, inviterCode;
  final SignupTypes type;
  SignupSubmitStepOne(
      {required this.fname,
      required this.lname,
      required this.fatherName,
      required this.nc,
      required this.certId,
      required this.sex,
      required this.birthDate,
      required this.place,
      required this.job,
      required this.type,
      required this.inviterCode});
}

class SignupGetCities extends SignupEvent {
  final int provinceId;
  SignupGetCities(this.provinceId);
}

class SignupSaveInsuranceOffice extends SignupEvent {
  final int provinceId, cityId;
  final double lat, lng;
  final String insuranceCompanyId, officeName, officeCode, address, postalCode, phone;
  SignupSaveInsuranceOffice(
      {required this.provinceId,
      required this.cityId,
      required this.insuranceCompanyId,
      required this.officeName,
      required this.officeCode,
      required this.address,
      required this.postalCode,
      required this.lat,
      required this.lng,
      required this.phone});
}

class SignupSaveVendor extends SignupEvent {
  final int provinceId, cityId;
  final double lat, lng;
  final String categoryId, shopName, address, postalCode, phone;
  SignupSaveVendor(
      {required this.provinceId,
      required this.cityId,
      required this.categoryId,
      required this.shopName,
      required this.address,
      required this.postalCode,
      required this.lat,
      required this.lng,
      required this.phone});
}
