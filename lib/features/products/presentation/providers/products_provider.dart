

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'products_repository_provider.dart';


//STATENOTIFIERPROVIDER

final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  
  final productsRepository = ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
});




//SATATENOTIFIER

class ProductsNotifier extends StateNotifier<ProductsState> {

  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository
    }): super( ProductsState() ){

      loadNextPage();
    }

    Future<bool> createOrUpdateProduct ( Map<String,dynamic> productLike ) async {
      try {
        final product = await productsRepository.createUpdateProduct(productLike);
        final isProductInList = state.products.any((element)=> element.id == product.id);

        if ( !isProductInList ) {
          state = state.copyWith(
            products: [...state.products, product],
          );
          return true;
        }

        state = state.copyWith(
          products: state.products.map(
            (element) => element.id == product.id ? product : element ).toList(),
        );
        return true;
      } catch (e) {
        return false;
      }
    }

    Future loadNextPage () async {
      /*
      ESTA LINEA NOS SERVIRA PARA PODER LLAMAR LA FUNCION COMO DESQUICIADO
      SIN QUE PASE NADA A NUESTRAS PETICIONES
      USANDO LAS PROPIEDADES DE MI ESTADO, POR QUE USAREMOS UN INFINITE SCROLL
      */
      if ( state.isLoading || state.isLastPage ) return;

      state = state.copyWith( isLoading: true );

      final products = await productsRepository.getProductByPAge(
        limit: state.limit,
        offset: state.offset 
        );

      if ( products.isEmpty ) {
        state = state.copyWith(
          isLoading: false,
          isLastPage: true,
        );
        return;
      }

      //BLOQUE DE CODIGO QUE HICE PARA ELIMINAR DUPLICIDAD DESPUES DE HABER 
      //CREADO UN PRODUCTO DESDE EL FRONTEND
      final setFromStateProducts = state.products.map((product) => product.id).toSet();
      final List<Product> productsNoRept = [];

      for(final product in products) {
        final productId = product.id;
        if ( !setFromStateProducts.contains(productId) ) {
          productsNoRept.add(product);
        }
      }
      //HASTA AQUI MI BLOQUE DE CODIGO


      state = state.copyWith(
        // products: [...state.products, ...products],
        products: [...state.products, ...productsNoRept ],
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
      );
    }

}

//ESTADO DEL NOTIFIER
class ProductsState {

  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false, 
    this.limit = 10, 
    this.offset = 0, 
    this.isLoading = false, 
    this.products = const []
    });

    ProductsState copyWith ({
      final bool? isLastPage,
      final int? limit,
      final int? offset,
      final bool? isLoading,
      final List<Product>? products,
    }) => ProductsState (
      isLastPage: isLastPage ?? this.isLastPage,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
       
    );
}