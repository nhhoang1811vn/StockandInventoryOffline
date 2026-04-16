
class ColumnInfo{
  final String name;
  bool isPickValues = false;
  bool showTotal = false;
  ColumnInfo(this.name, {
    this.isPickValues = false,
    this.showTotal = false
  });
}