

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'products_repository_provider.dart';

/*
SE AGREGA EL AUTODISPOSE PARA QUE SE LIMPIE CADA VEZ QUE YA NO SE VA A UTILIZAR
Y EL .family PARA ESPERAR UN VALOR A LA HORA DE UTILIZAR ESTE PROVIDER
*/

final productProvider = StateNotifierProvider.autoDispose.family< ProductNotifier, ProductState, String >((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductNotifier(productId: productId, productsRepository: productsRepository);
});

class ProductNotifier extends StateNotifier<ProductState> {

  final ProductsRepository productsRepository;

  ProductNotifier({
    required String productId, 
    required this.productsRepository
    }): super( ProductState(id: productId) ){
      loadProduct();
    }

  Future<void> loadProduct () async {
    try {
      final product = await productsRepository.getProductsById( state.id );
      state = state.copyWith(
        isLoading: false,
        product: product,
      );
    } catch (e) {
      // 404 PRODUCT NOT FOUND
      print(e);
      
    }
  }
  
}


class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id, 
    this.product, 
    this.isLoading=true, 
    this.isSaving= false,
    });

  ProductState copyWith ({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving, 
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product, 
    isLoading: isLoading ?? this.isLoading, 
    isSaving: isSaving ?? this.isSaving, 
    );


}