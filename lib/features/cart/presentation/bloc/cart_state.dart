import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  final List<CartItem> items;

  const CartState({this.items = const []});

  CartState copyWith({
    List<CartItem>? items,
  }) {
    return CartState(
      items: items ?? this.items,
    );
  }

  double get totalAmount {
    return items.fold(0, (total, current) => total + current.totalPrice);
  }

  int get totalItems {
    return items.fold(0, (total, current) => total + current.quantity);
  }

  int getQuantity(int productId) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      return items[index].quantity;
    }
    return 0;
  }

  @override
  List<Object?> get props => [items];
}
