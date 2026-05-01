enum Flavor { dev, product, stable }

class FlavorConfig {
  static Flavor _current = Flavor.dev;

  static Flavor get current => _current;

  static void setFlavor(Flavor flavor) {
    _current = flavor;
  }

  static String get name {
    switch (_current) {
      case Flavor.dev:
        return 'dev';
      case Flavor.product:
        return 'product';
      case Flavor.stable:
        return 'stable';
    }
  }
}
