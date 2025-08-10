

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';


final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  /*
  EN RIVERPOD REF TRAER EL ARBOL DE PROVIDERS POR LO CUAL PODEMOS TENER ACCESO
  AL TOKEN DE LA SIGUIENTE MANERA
  */
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productsRepository = ProductsRepositoryImpl(
    ProductsDatasourceImpl(accessToken: accessToken)
  );
  
  return productsRepository;
});