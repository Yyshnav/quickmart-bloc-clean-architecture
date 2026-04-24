import 'package:equatable/equatable.dart';
import '../../../dashboard/domain/entities/product_entity.dart';

class CartItem extends Equatable {
  final ProductEntity product;
  final int quantity;

  const CartItem({
    required this.product,
    this.quantity = 1,
  });

  CartItem copyWith({
    ProductEntity? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
