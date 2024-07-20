import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/data/remote/model/social_responsibility.dart';
import 'package:insurance_map/repo/place_repository.dart';
import 'package:insurance_map/repo/social_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 's_r_event.dart';
part 's_r_state.dart';

class SRBloc extends Bloc<SREvent, SRState> {
  final SocialRepository _socialRepository;
  final PlaceRepository _placeRepository;

  SRBloc(this._socialRepository, this._placeRepository) : super(SRInitial()) {
    on<SRGetInitData>((event, emit) async {
      emit(SRLoading());

      DataState<List<ProvinceAndCity>> result1 = await _placeRepository.getAllProvinces();
      DataState<List<SocialResponsibility>> result2 = await _socialRepository.getResponsibilities();

      emit(SRShowProvinces(result1.data ?? []));
      await Future.delayed(const Duration(seconds: 1));
      emit(SRShowResponsibilities(result2.data ?? []));
    });

    on<SRGetProvinceData>((event, emit) async {
      emit(SRLoading());

      DataState<List<ProvinceAndCity>> result1 = await _placeRepository.getCities(event.provinceId);
      DataState<List<SocialResponsibility>> result2 = await _socialRepository.getResponsibilities(provinceId: event.provinceId.toString());

      emit(SRShowCities(result1.data ?? []));
      await Future.delayed(const Duration(seconds: 1));
      emit(SRShowResponsibilities(result2.data ?? []));
    });

    on<SRGetCityData>((event, emit) async {
      emit(SRLoading());

      DataState<List<SocialResponsibility>> result = await _socialRepository.getResponsibilities(cityId: event.cityId.toString());

      emit(SRShowResponsibilities(result.data ?? []));
    });
  }
}
