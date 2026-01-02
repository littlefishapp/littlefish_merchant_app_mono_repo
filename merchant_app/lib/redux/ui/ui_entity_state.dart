class UIEntityState<T> {
  UIEntityState(this.item, {this.isNew = false});

  bool isNew;

  T item;
}
