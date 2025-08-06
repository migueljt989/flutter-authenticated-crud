

abstract class KeyValueStorageService {

  //EL SIGNIFICA QUE ES UN GENERICO, LE DICE SI ESTO ES UN STRING MANDALO COMO UN STRING, SI ES UN ENTERO MANDALE UN ENTERO...
  //ESTO SE HAC EPARA EVITAR EL DYNAMIC COMO TIPO DE DATO PARA VALUE
  Future<void> setKeyValue<T> ( String key, T value );
  Future<T?> getValue<T> ( String key );
  Future<bool> removeKey ( String key );
}