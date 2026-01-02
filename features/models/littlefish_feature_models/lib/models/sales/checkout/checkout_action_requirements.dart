abstract class CheckoutActionRequirements {
  num? minAmount;
  num? maxAmount;
  bool isRequired;

  CheckoutActionRequirements({
    this.minAmount,
    this.maxAmount,
    this.isRequired = false,
  });
}
