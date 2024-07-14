import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/map_position.dart';
import 'package:insurance_map/data/remote/model/province_city.dart';
import 'package:insurance_map/repo/insurance_repository.dart';
import 'package:insurance_map/repo/place_repository.dart';
import 'package:insurance_map/repo/shop_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final ShopRepository _shopRepository;
  final InsuranceRepository _insuranceRepository;
  final PlaceRepository _placeRepository;

  MapBloc(this._insuranceRepository, this._shopRepository, this._placeRepository) : super(MapInitial()) {
    on<MapGetPositions>((event, emit) async {
      DataState<List<MapPositionData>> result = event.type == 'vendor'
          ? await _shopRepository.getVendor(event.id, event.fromLat.toString(), event.fromLng.toString(), event.toLat.toString(), event.toLng.toString())
          : await _insuranceRepository.getInsuranceOffices(event.id, event.fromLat.toString(), event.fromLng.toString(), event.toLat.toString(), event.toLng.toString());

      if (result is DataSucces) emit(MapShowPositions(result.data!));
    });

    on<MapGetProvinces>((event, emit) async {
      emit(MapLoading());

      DataState<List<ProvinceAndCity>> result = await _placeRepository.getAllProvinces();
      
      emit(result is DataSucces ? MapShowProvinces(result.data!) : MapInitial());
    });

    on<MapGetCities>((event, emit) async {
      emit(MapLoading());

      DataState<List<ProvinceAndCity>> result = await _placeRepository.getCities(event.provinceId);
      
      emit(result is DataSucces ? MapShowCities(result.data!) : MapInitial());
    });
  }
}
