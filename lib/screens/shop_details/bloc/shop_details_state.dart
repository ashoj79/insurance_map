part of 'shop_details_bloc.dart';

@immutable
sealed class ShopDetailsState {}

final class ShopDetailsInitial extends ShopDetailsState {}

class ShopDetailsLoading extends ShopDetailsState {}

class ShopDetailsMessage extends ShopDetailsState {
  final String message;
  ShopDetailsMessage({required this.message});
}