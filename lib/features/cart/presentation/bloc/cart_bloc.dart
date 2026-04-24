import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../domain/entities/cart_item.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<IncrementQuantityEvent>(_onIncrementQuantity);
    on<DecrementQuantityEvent>(_onDecrementQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == event.product.id);
    
    if (existingIndex >= 0) {
      
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      emit(state.copyWith(items: updatedItems));
    } else {
      
      final updatedItems = List<CartItem>.from(state.items)..add(CartItem(product: event.product));
      emit(state.copyWith(items: updatedItems));
    }
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final updatedItems = state.items.where((item) => item.product.id != event.productId).toList();
    emit(state.copyWith(items: updatedItems));
  }

  void _onIncrementQuantity(IncrementQuantityEvent event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == event.productId);
    if (existingIndex >= 0) {
      final updatedItems = List<CartItem>.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
      emit(state.copyWith(items: updatedItems));
    }
  }

  void _onDecrementQuantity(DecrementQuantityEvent event, Emitter<CartState> emit) {
    final existingIndex = state.items.indexWhere((item) => item.product.id == event.productId);
    if (existingIndex >= 0) {
      final currentQuantity = state.items[existingIndex].quantity;
      if (currentQuantity > 1) {
        final updatedItems = List<CartItem>.from(state.items);
        updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
          quantity: currentQuantity - 1,
        );
        emit(state.copyWith(items: updatedItems));
      } else {
        
        final updatedItems = List<CartItem>.from(state.items)..removeAt(existingIndex);
        emit(state.copyWith(items: updatedItems));
      }
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}
