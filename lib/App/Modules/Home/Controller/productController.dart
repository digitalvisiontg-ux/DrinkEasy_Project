import 'package:drink_eazy/App/Modules/Home/View/home.dart';

final List<String> categories = [
  "Tous",
  "Promotion",
  "Bière",
  "Cocktail",
  "Vin",
  "Soft",
  "Spiritueux",
];

final List<Product> products = [
  Product(
    name: 'Heineken',
    category: 'Bière',
    boissonType: 'Bière blonde',
    priceCfa: 1500,
    imagepath: 'assets/images/boisson9.jpg',
  ),
  Product(
    name: 'Castel',
    category: 'Bière',
    boissonType: 'Bière brune',
    priceCfa: 1200,
    imagepath: 'assets/images/boisson2.jpg',
  ),
  Product(
    name: 'Strawberry Daiquiri',
    category: 'Cocktail',
    boissonType: 'Cocktail aux fraises',
    priceCfa: 800,
    imagepath: 'assets/images/cocktail2.jpg',
  ),
  Product(
    name: 'Mojito',
    category: 'Soft',
    boissonType: 'Cocktail sans alcool',
    priceCfa: 2500,
    imagepath: 'assets/images/boisson3.jpg',
  ),
  Product(
    name: 'Piña Colada',
    category: 'Vin',
    boissonType: 'Cocktail à l\'ananas',
    priceCfa: 3000,
    imagepath: 'assets/images/boisson4.jpg',
  ),
  Product(
    name: 'Chardonnay',
    category: 'Vin',
    boissonType: 'Vin blanc',
    priceCfa: 4000,
    imagepath: 'assets/images/boisson5.jpg',
  ),
  Product(
    name: 'Gin Tonic',
    category: 'Spiritueux',
    boissonType: 'Cocktail au gin',
    priceCfa: 2800,
    imagepath: 'assets/images/boisson6.jpg',
  ),

  // ✅ Produits en promotion
  Product(
    name: 'Coca-Cola',
    category: 'Promotion',
    priceCfa: 1500,
    oldPriceCfa: 1800,
    boissonType: 'Soda',
    promotion: 'Achetez 3,\n recevez 1 offert',
    imagepath: 'assets/images/boisson7.jpg',
  ),
  Product(
    name: 'Bordeaux Rouge',
    category: 'Promotion',
    priceCfa: 2800,
    oldPriceCfa: 3500,
    boissonType: 'Vin rouge',
    promotion: '🎉 Prix réduit',
    imagepath: 'assets/images/boisson8.jpg',
  ),
  Product(
    name: 'Sprite',
    category: 'Promotion',
    priceCfa: 1000,
    oldPriceCfa: 1200,
    boissonType: 'Soda',
    promotion: 'Achetez 2,\n recevez 1 offert',
    imagepath: 'assets/images/boisson2.jpg',
  ),
];
