import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/local/signup_step_one_data.dart';
import 'package:insurance_map/data/local/signup_types.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/repo/insurance_repository.dart';
import 'package:insurance_map/repo/place_repository.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _userRepository;
  final InsuranceRepository _insuranceRepository;
  final PlaceRepository _placeRepository;
  String type = '', phone = '', otp = '';

  SignupBloc(this._userRepository, this._insuranceRepository, this._placeRepository) : super(SignupInitial()) {
    on<SignupSendOtp>((event, emit) async {
      String phone = '0${event.phone}';
      if (int.tryParse(phone) == null || phone.length != 11) {
        emit(SignupError('شماره وارد شده غلط است'));
        return;
      }

      emit(SignupLoading());

      DataState<String> result = await _userRepository.sendOtp(phone);
      if (result is DataSucces) type = result.data!;

      emit(result is DataSucces
          ? SignupGetOtp(event.phone)
          : SignupError(result.errorMessage!));
    });

    on<SignupValidateOtp>((event, emit) async {
      phone = '0${event.phone}';
      otp = event.otp;
      if (int.tryParse(otp) == null || otp.length != 6) {
        emit(SignupError('کد وارد شده غلط است'));
        return;
      }

      emit(SignupLoading());

      DataState<void> result = await _userRepository.validateOtp(phone, otp, type);
      if (result is DataError) {
        emit(SignupError(result.errorMessage!));
        return;
      }

      emit(type == 'register' ? SignupDoSignup() : SignupDoLogin());
    });

    on<SignupSubmitStepOne>((event, emit) async {
      if (event.fname.length < 3) {
        emit(SignupError('نام خود را وارد کنید'));
        return;
      }

      if (event.lname.length < 3) {
        emit(SignupError('نام خانوادگی خود را وارد کنید'));
        return;
      }

      if (event.fatherName.length < 3) {
        emit(SignupError('نام پدر خود را وارد کنید'));
        return;
      }

      if (event.nc.length != 10 || int.tryParse(event.nc) == null) {
        emit(SignupError('کد خود را وارد کنید'));
        return;
      }

      if (event.certId.isEmpty || int.tryParse(event.certId) == null) {
        emit(SignupError('شماره شناسنامه خود را وارد کنید'));
        return;
      }

      if (event.sex.isEmpty) {
        emit(SignupError('جنسیت خود را وارد کنید'));
        return;
      }

      emit(SignupLoading());

      SignupStepOneData data = SignupStepOneData(
          phone.trim(),
          otp.trim(),
          event.fname.trim(),
          event.lname.trim(),
          event.fatherName.trim(),
          event.nc.trim(),
          event.certId.trim(),
          event.sex.trim(),
          event.birthDate.trim(),
          event.place.trim(),
          event.job.trim());

      DataState<void> result = await _userRepository.signupStepOne(data);
      if (result is DataError) {
        emit(SignupError(result.errorMessage ?? ''));
        return;
      }

      DataState<List<ProvinceAndCity>> provinces =
          await _placeRepository.getAllProvinces();
      if (provinces is DataError) {
        emit(SignupError(provinces.errorMessage ?? ''));
        return;
      }
      List<InsuranceCompany>? companies;
      if (event.type == SignupTypes.representatives) {
        companies = (await _insuranceRepository.getInsuranceCampanies()).data;
      }
      emit(SignupDoSignupStepTwo(provinces.data!, companies ?? []));
    });

    on<SignupGetCities>((event, emit) async {
      if (event.provinceId == 0) return;

      emit(SignupLoading());

      DataState<List<ProvinceAndCity>> result =
          await _placeRepository.getCities(event.provinceId);
      if (result is DataError) {
        emit(SignupError(result.errorMessage ?? ''));
        return;
      }
      emit(SignupUpdateCities(result.data!));
    });

    on<SignupSaveInsuranceOffice>((event, emit) async {
      if (event.provinceId == 0) {
        emit(SignupError('لطفا استان را انتخاب کنید'));
        return;
      }

      if (event.cityId == 0) {
        emit(SignupError('لطفا شهر را انتخاب کنید'));
        return;
      }

      if (event.insuranceCompanyId == '') {
        emit(SignupError('لطفا شرکت بیمه را انتخاب کنید'));
        return;
      }

      if (event.officeName == '') {
        emit(SignupError('لطفا نام نمایندگی را وارد کنید'));
        return;
      }

      if (event.officeCode == '') {
        emit(SignupError('لطفا کد شعبه را وارد کنید'));
        return;
      }

      if (event.address == '') {
        emit(SignupError('لطفا آدرس را وارد کنید'));
        return;
      }

      if (event.postalCode == '') {
        emit(SignupError('لطفا کد پستی را وارد کنید'));
        return;
      }

      if (event.lat == 0 || event.lng == 0) {
        emit(SignupError('لطفا مکان نمایندگی را روی نقشه انتخاب کنید'));
        return;
      }

      emit(SignupLoading());
      DataState<void> result = await _insuranceRepository.saveInsuranceOffice(
          event.provinceId,
          event.cityId,
          event.insuranceCompanyId,
          event.officeName,
          event.officeCode,
          event.address,
          event.postalCode,
          event.lat.toString(),
          event.lng.toString());

      emit(result is DataError ? SignupError(result.errorMessage!) : SignupDoLogin());
    });
  }
}
