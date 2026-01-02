import 'dart:math';

/// An extension on List to add additional functionality.
extension ListExtension<T> on List<T> {
  /// ***[Created by Littlefish]***
  /// Adds [value] to the list if it is not already present.
  ///
  /// If the list already contains [value], this method does nothing.
  /// When objects do not extend Equatable, then two objects are considered equal
  /// if they are the exact same instance in memory.
  /// If objects extend equatable then equality is based on the values of thier fields.
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// numbers.addIfNotPresent(4); // [1, 2, 3, 4]
  /// numbers.addIfNotPresent(2); // [1, 2, 3, 4]
  /// ```
  void addIfNotPresent(T value) {
    if (!contains(value)) {
      add(value);
    }
  }

  /// ***[Created by Littlefish]***
  /// Adds [value] to the list if no element in the list satisfies the [predicate].
  ///
  /// This allows more flexible comparison than just equality,
  /// for example comparing based on a property of the object.
  ///
  /// Example:
  /// ```dart
  /// paymentTypeList.addIfNotPresentWhere(
  ///   paymentType,
  ///   (type) => type.name == paymentType.name,
  /// );
  /// ```
  void addIfNotPresentWhere(T value, bool Function(T element) predicate) {
    if (!any(predicate)) {
      add(value);
    }
  }

  /// ***[Created by Littlefish]***
  /// Updates an element in the list if the [predicate] matches, otherwise inserts [value].
  ///
  /// If an element in the list satisfies the [predicate], it is replaced with [value].
  /// If no such element exists, [value] is added to the list.
  ///
  /// Example:
  /// ```dart
  /// paymentTypeList.upsertWhere(
  ///   paymentType,
  ///   (type) => type.name == paymentType.name,
  /// );
  /// ```
  void upsertWhere(T value, bool Function(T element) predicate) {
    final index = indexWhere(predicate);
    if (index != -1) {
      this[index] = value;
    } else {
      add(value);
    }
  }

  /// ***[Created by Littlefish]***
  /// Removes [value] from the list if it is present.
  /// If the list does not contain [value], this method does nothing.
  ///
  /// When objects do not extend Equatable, then two objects are considered equal
  /// if they are the exact same instance in memory.
  /// If objects extend equatable then equality is based on the values of thier fields.
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4];
  /// numbers.removeIfPresent(4); // [1, 2, 3]
  /// numbers.removeIfPresent(5); // [1, 2, 3]
  /// ```
  void removeIfPresent(T value) {
    if (contains(value)) {
      remove(value);
    }
  }

  /// ***[Created by Littlefish]***
  /// Adds all elements from [itemsList] to the list if they are not already present.
  /// This method iterates over each element in [itemsList] and adds it to the list
  /// if the element is not already present in the list.
  ///
  /// When objects do not extend Equatable, then two objects are considered equal
  /// if they are the exact same instance in memory.
  /// If objects extend equatable then equality is based on the values of thier fields.
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3];
  /// List<int> newNumbers = [2, 3, 4, 5];
  /// numbers.addAllNotPresent(newNumbers); // [1, 2, 3, 4, 5]
  /// ```
  void addAllNotPresent(List<T> itemsList) {
    for (T element in itemsList) {
      addIfNotPresent(element);
    }
  }

  /// ***[Created by Littlefish]***
  /// Removes all elements from [itemsList] from the list if they are present.
  /// This method iterates over each element in [itemsList] and removes it from the list
  /// if the element is present in the list.
  ///
  /// When objects do not extend Equatable, then two objects are considered equal
  /// if they are the exact same instance in memory.
  /// If objects extend equatable then equality is based on the values of thier fields.
  /// Example:
  /// ```dart
  /// List<int> numbers = [1, 2, 3, 4, 5];
  /// List<int> removeNumbers = [2, 4, 6];
  /// numbers.removeAllPresent(removeNumbers); // [1, 3, 5]
  /// ```
  void removeAllPresent(List<T> itemsList) {
    for (T element in itemsList) {
      removeIfPresent(element);
    }
  }
}

/// An extension on double to add additional functionality.
extension TruncateDoubles on double {
  /// ***[Created by Littlefish]***
  /// Truncates the double value to the specified number of decimal places.
  ///
  /// This method truncates the double value without rounding. It takes the
  /// current double value, scales it by a factor of 10 raised to the power
  /// of [fractionalDigits], truncates the scaled value to remove the
  /// fractional part, and then rescales it back.
  ///
  /// [fractionalDigits] is the number of decimal places to truncate to.
  ///
  /// Example:
  /// ```dart
  /// double value = 12.34567;
  /// double truncatedValue = value.truncateToDecimalPlaces(2);
  /// print(truncatedValue); // 12.34
  /// ```
  double truncateToDecimalPlaces(int fractionalDigits) {
    var power = pow(10, fractionalDigits);
    var num1 = (this * power).round();

    double result = (num1 / power);

    return result;
  }
}
