import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/map_position.dart';
import 'package:insurance_map/repo/insurance_repository.dart';
import 'package:insurance_map/repo/shop_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';

part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final ShopRepository _shopRepository;
  final InsuranceRepository _insuranceRepository;

  MapBloc(this._insuranceRepository, this._shopRepository) : super(MapInitial()) {
    on<MapGetPositions>((event, emit) async {
      DataState<List<MapPositionData>> result = event.type == 'vendor'
          ? await _shopRepository.getVendor(event.id, event.fromLat.toString(), event.fromLng.toString(), event.toLat.toString(), event.toLng.toString())
          : await _insuranceRepository.getInsuranceOffices(event.id, event.fromLat.toString(), event.fromLng.toString(), event.toLat.toString(), event.toLng.toString());

      if (result is DataSucces) emit(MapShowPositions(result.data!));
    });
  }
}
