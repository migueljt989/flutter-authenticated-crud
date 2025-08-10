/*El unico objetivo de (products_repository_impl) 
es utilizar el datasource(que puede tener requerimientos especiales), pero es
el datasource como tal el que los tiene que satisfacer, nuestro repositorio
unicamente va a decir -ey quieres que yo utilice este datasource, a ok yo 
simplemente delego las funcionalidades y las mando a llamar
*/

import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  
  final ProductsDatasource datasource;

  ProductsRepositoryImpl(this.datasource);

  
  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    return datasource.createUpdateProduct(productLike);
  }

  @override
  Future<List<Product>> getProductByPAge({int limit = 10, int offset = 0}) {
    return datasource.getProductByPAge(limit: limit, offset: offset);
  }

  @override
  Future<Product> getProductsById(String id) {
    return datasource.getProductsById(id);
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    return datasource.searchProductByTerm(term);
  }
}