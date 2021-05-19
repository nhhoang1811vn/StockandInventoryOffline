abstract class BaseRepository<T> {
  Future<bool> insert(T item);
  Future<bool> update(T item);
}
