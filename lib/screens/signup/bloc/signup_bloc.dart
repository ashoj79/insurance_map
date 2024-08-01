import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/local/signup_step_one_data.dart';
import 'package:insurance_map/data/local/signup_types.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/data/remote/model/shop_category.dart';
import 'package:insurance_map/data/remote/model/user_info.dart';
import 'package:insurance_map/repo/insurance_repository.dart';
import 'package:insurance_map/repo/place_repository.dart';
import 'package:insurance_map/repo/shop_repository.dart';
import 'package:insurance_map/repo/user_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:insurance_map/utils/di.dart';
import 'package:meta/meta.dart';
import 'package:sms_autofill/sms_autofill.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final UserRepository _userRepository;
  final InsuranceRepository _insuranceRepository;
  final PlaceRepository _placeRepository;
  final ShopRepository _shopRepository;
  String type = '', phone = '', otp = '';

  SignupBloc(this._userRepository, this._insuranceRepository,
      this._placeRepository, this._shopRepository)
      : super(SignupInitial()) {
    on<SignupSendOtp>((event, emit) async {
      String phone = event.phone;
      if (int.tryParse(phone) == null || phone.length != 11) {
        emit(SignupError('شماره وارد شده غلط است'));
        return;
      }

      emit(SignupLoading());
      
      DataState<bool> existsResult = await _userRepository.isMobileExists(phone, event.hash);
      if (existsResult is DataError) {
        emit(SignupError(existsResult.errorMessage!));
        return;
      }

      if (existsResult.data! && event.isSignup) {
        emit(SignupError('این شماره قبلا ثبت نام کرده است. لطفا از گزینه ورود وارد حساب کاربری خود شوید'));
        return;
      }

      if (!existsResult.data! && !event.isSignup) {
        emit(SignupError('این شماره در سیستم ثبت نشده است. لطفا ابتدا ثبت نام کنید'));
        return;
      }

      DataState<String> result = await _userRepository.sendOtp(phone, event.hash);
      if (result is DataSucces) type = result.data!;

      emit(result is DataSucces
          ? SignupGetOtp(event.phone)
          : SignupError(result.errorMessage!));
    });

    on<SignupValidateOtp>((event, emit) async {
      phone = event.phone;
      otp = event.otp;
      if (int.tryParse(otp) == null || otp.length != 6) {
        emit(SignupError('کد وارد شده غلط است'));
        return;
      }

      emit(SignupLoading());

      DataState<UserInfo> result =
          await _userRepository.validateOtp(phone, otp, type);
      if (result is DataError) {
        emit(SignupError(result.errorMessage!));
        return;
      }

      if (type == 'register') {
        emit(SignupDoSignup());
        return;
      }

      if (event.type == SignupTypes.businesses &&
          result.data!.vendorCount <= 0) {
        emit(SignupDoSignupStepTwo(
          await _getProvinces(),
          categories: await _getCategories()
        ));
        return;
      }

      if (event.type == SignupTypes.representatives && result.data!.insuranceOfficeCount <= 0) {
        emit(SignupDoSignupStepTwo(
          await _getProvinces(),
          companies: await _getCompanies()
        ));
        return;
      }

      String topMessage = '';

      if (result.data!.vehicleCount <= 0) {
        topMessage = 'برای ثبت اطلاعات وسایل نقلیه';
      }

      if (result.data!.bankCartCount <= 0) {
        topMessage = topMessage.isEmpty ? 'برای ثبت اطلاعات کارت های بانکی' : '$topMessage و کارت های بانکی';
      }

      if (topMessage.isNotEmpty) {
        topMessage += ' از گزینه کارت ها و وسایل نقلیه استفاده کنید';
      }

      locator<SharedPreferenceHelper>().saveTopMessage(topMessage);

      emit(SignupDoLogin());
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
          event.job.trim(),
          event.inviterCode.trim()
      );

      DataState<void> result = await _userRepository.signupStepOne(data);
      if (result is DataError) {
        emit(SignupError(result.errorMessage ?? ''));
        return;
      }

      if (event.type == SignupTypes.vehicles) {
        emit(SignupGoToVehicles());
        return;
      }

      List<ProvinceAndCity> provinces = await _getProvinces();
      List<InsuranceCompany> companies =
          event.type == SignupTypes.representatives
              ? await _getCompanies()
              : [];
      List<ShopCategory> categories =
          event.type == SignupTypes.businesses ? await _getCategories() : [];

      emit(SignupDoSignupStepTwo(provinces,
          companies: companies, categories: categories));
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
          event.lng.toString(),
          event.phone);

      emit(result is DataError
          ? SignupError(result.errorMessage!)
          : SignupDoLogin());
    });

    on<SignupSaveVendor>((event, emit) async {
      if (event.provinceId == 0) {
        emit(SignupError('لطفا استان را انتخاب کنید'));
        return;
      }

      if (event.cityId == 0) {
        emit(SignupError('لطفا شهر را انتخاب کنید'));
        return;
      }

      if (event.categoryId == '') {
        emit(SignupError('لطفا دسته بندی را انتخاب کنید'));
        return;
      }

      if (event.shopName == '') {
        emit(SignupError('لطفا نام کسب و کار را وارد کنید'));
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
        emit(SignupError('لطفا مکان کسب و کار را روی نقشه انتخاب کنید'));
        return;
      }

      emit(SignupLoading());
      DataState<void> result = await _shopRepository.saveVendor(
          event.provinceId,
          event.cityId,
          event.categoryId,
          event.shopName,
          event.address,
          event.postalCode,
          event.lat.toString(),
          event.lng.toString(),
          event.phone);

      emit(result is DataError
          ? SignupError(result.errorMessage!)
          : SignupDoLogin());
    });
  }

  Future<List<ProvinceAndCity>> _getProvinces() async {
    DataState<List<ProvinceAndCity>> result =
        await _placeRepository.getAllProvinces();
    return result is DataSucces ? result.data! : [];
  }

  Future<List<InsuranceCompany>> _getCompanies() async {
    DataState<List<InsuranceCompany>> result =
        await _insuranceRepository.getInsuranceCampanies();
    return result is DataSucces ? result.data! : [];
  }

  Future<List<ShopCategory>> _getCategories() async {
    DataState<List<ShopCategory>> result =
        await _shopRepository.getAllCategories();
    return result is DataSucces ? result.data! : [];
  }
}
