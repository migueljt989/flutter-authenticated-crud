


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';


/*
EL PROVIDER TIENE QUE SER UN --AUTODISPOSABLE-- POR QUE UNA VEZ QUE 
SALES DE LA PANTALLA Y REGERESAS SE BUSCCA QUE EL ESTADO VUELVA A SU ESTADO POR DEFECTO
EL PROVIDER TAMBEIN TIENE QUE SER FAMILY POR QUE SE QUIERE RECIBIR EL PRODUCTO
*/


final productFormProvider = StateNotifierProvider.autoDispose
  .family<ProductFormNotifier, ProductFormState, Product>(( ref, product ) {
    
    //CREATEUPDATECALLBACK, TOMARLA DE ALGUN LUGAR
    // final createUpdateCallback = ref.watch(productsRepositoryProvider).createUpdateProduct;
    final createUpdateCallback = ref.watch(productsProvider.notifier).createOrUpdateProduct;

    return ProductFormNotifier(product: product, onSubmitCallback: createUpdateCallback ); 
});


class ProductFormNotifier extends StateNotifier<ProductFormState> {

  final Future<bool> Function( Map<String,dynamic> productLike)? onSubmitCallback;

  ProductFormNotifier({ 
    this.onSubmitCallback,
    //QUEREMOS RECIBIR UN PRODUCTO PERO NO QUEREMOS DECLARARLO COMO PROPIEDAD, OSE FINAL ETC...
    //ENTONCES HACEMOS LO SIGUIENTE EN EL CONSTRUCTOR
    required Product product,
    }): super( ProductFormState (
      id:product.id,
      title: Title.dirty( product.title ),
      slug: Slug.dirty (product.slug ),
      price: Price.dirty( product.price ),
      inStock: Stock.dirty( product.stock ),
      sizes: product.sizes,
      gender: product.gender,
      description: product.description,
      tags: product.tags.join(', '),
      images: product.images,
    ) );

  Future<bool> onFormSubmit () async {
    _touchedEverything();
    if ( !state.isFormValid ) return false;
    if ( onSubmitCallback == null ) return false;
    
    final productLike = {
      'id' : ( state.id == 'new' ) ? null : state.id,
      'title' : state.title.value,
      'slug' : state.slug.value,
      'price' : state.price.value,
      'stock' : state.inStock.value,
      'sizes' : state.sizes,
      'gender' : state.gender,
      'description' : state.description,
      'tags' : state.tags.split(','),
      'images' : state.images.map(
        (image) => image.replaceAll('${ Environment.apiURL}/files/product/', '')).toList(),
    };
    
    //LLAMAR ON SUBMIT CALLBACK
    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }


  void _touchedEverything () {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
    );
  }

  void updateProductImage ( String path ) {
    state = state.copyWith(
      images: [ ...state.images, path]
    );
  }

  void deleteImage ( String path ) {
    state = state.copyWith(
      images: state.images
    );
  }

  void onTitleChanged ( String value ) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value)
      ]) //SE PODRIA CONCATENAR OTRA VALIDACION PERSONALIZADA (&&), YA QUE TODA ESTA LINEA REGRESA UN BOOLEANO
    );
  }

  void onSlugChanged ( String value ) {
   state = state.copyWith(
     slug: Slug.dirty(value),
     isFormValid: Formz.validate([
       Title.dirty(state.title.value),
       Slug.dirty(value),
       Price.dirty(state.price.value),
       Stock.dirty(state.inStock.value)
     ])
   );
  }

  void onPriceChanged ( double value ) {
   state = state.copyWith(
     price: Price.dirty( value ),
     isFormValid: Formz.validate([
       Title.dirty(state.title.value),
       Slug.dirty(state.slug.value),
       Price.dirty(value),
       Stock.dirty(state.inStock.value)
     ])
   );
  }

  void onStockChanged ( int value ) {
   state = state.copyWith(
     inStock: Stock.dirty( value ),
     isFormValid: Formz.validate([
       Title.dirty(state.title.value),
       Slug.dirty(state.slug.value),
       Price.dirty(state.price.value),
       Stock.dirty(value)
     ])
   );
  }

  void onSizeCahnged ( List<String> sizes ) {
    state = state.copyWith(
      sizes: sizes
    );
  }

  void onGenderCahnged ( String gender ) {
    state = state.copyWith(
      gender: gender
    );
  }

  void onDescriptionCahnged ( String description ) {
    state = state.copyWith(
      description: description
    );
  }

  void onTagsCahnged ( String tags ) {
    state = state.copyWith(
      tags: tags
    );
  }
  
}


class ProductFormState {

  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false, 
    this.id, 
    this.title = const Title.dirty(''), 
    this.slug = const Slug.dirty(''), 
    this.price = const Price.dirty(0), 
    this.sizes = const [], 
    this.gender = '', 
    this.inStock = const Stock.dirty(0), 
    this.description = '', 
    this.tags = '', 
    this.images = const [],
    });

  ProductFormState copyWith ({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    inStock: inStock ?? this.inStock,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );



}