abstract class BaseRepository<T> {
  Future<bool> insert(T item);

  Future<bool> update(T item);

  Future<List<T>> getAll();

  Future<bool> delete(int id);
}
