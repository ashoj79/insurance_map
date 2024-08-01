import 'package:bloc/bloc.dart';
import 'package:insurance_map/data/remote/model/bank.dart';
import 'package:insurance_map/repo/bank_repository.dart';
import 'package:insurance_map/repo/vehicles_repository.dart';
import 'package:insurance_map/utils/data_state.dart';
import 'package:insurance_map/utils/extensions_method.dart';
import 'package:meta/meta.dart';

part 'c_a_v_event.dart';
part 'c_a_v_state.dart';

class CAVBloc extends Bloc<CAVEvent, CAVState> {
  final BankRepository _bankRepository;
  final VehiclesRepository _vehiclesRepository;
  
  CAVBloc(this._bankRepository, this._vehiclesRepository) : super(CAVInitial()) {
    on<CAVGetData>((event, emit) async {
      emit(CAVLoading());

      DataState<List<Bank>> banksResult = await _bankRepository.getBanks();
      if (banksResult is DataError) {
        emit(CAVError(banksResult.errorMessage!));
        return;
      }
      
      DataState<List<String>> cardsResult = await _bankRepository.getUserCards();
      if (cardsResult is DataError) {
        emit(CAVError(cardsResult.errorMessage!));
        return;
      }

      DataState<List<String>> vehiclesResult = await _vehiclesRepository.getVehiclesLicense();
      if (vehiclesResult is DataError) {
        emit(CAVError(vehiclesResult.errorMessage!));
        return;
      }

      var banks = banksResult.data!;
      Map<String, Bank> cards = {};
      for (String num in cardsResult.data!){
        int bankIndex = banks.indexWhere((element) => element.prefixs.contains(num.substring(0, 6)));
        cards.addAll({num.formatCardNumber(): banks[bankIndex]});
      }

      emit(CAVShowData(cards: cards, vehicles: vehiclesResult.data!));
    });
  }
}
