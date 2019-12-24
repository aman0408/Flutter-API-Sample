class Dish {
  final String dishName,
      dishCalories,
      dishCurrency,
      dishPrice,
      dishDesc,
      dishID;
  final bool isCustomizationAvailable;
  final String dishType, dishImage;

  Dish({this.dishID,
    this.dishName = "",
    this.dishCalories = "",
    this.dishCurrency = "",
    this.dishPrice = "",
    this.dishDesc = "",
    this.isCustomizationAvailable,
    this.dishType = "",
    this.dishImage = ""});

  @override
  String toString() {
    return 'Dish{dishName: $dishName, dishCalories: $dishCalories, dishCurrency: $dishCurrency, dishPrice: $dishPrice, dishDesc: $dishDesc, isCustomizationAvailable: $isCustomizationAvailable, dishType: $dishType, dishImage: $dishImage}';
  }
}
