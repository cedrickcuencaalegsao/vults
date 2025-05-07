abstract class Repository<T> {
  Future<T?> get(String id);
  Future<List<T>> getAll();
  Future<void> save(T item);
  Future<void> update(T item);
  Future<void> delete(String id);
}
