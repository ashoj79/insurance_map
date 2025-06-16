part of 'shop_details_bloc.dart';

@immutable
sealed class ShopDetailsEvent {}

class ShopDetailsCreateRequest extends ShopDetailsEvent {
  final String amount, vendorId;
  ShopDetailsCreateRequest({required this.vendorId, required this.amount});
}