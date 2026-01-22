/* =========================================================
   JSON PROMOTIONS
   ========================================================= */

final List<Map<String, dynamic>> promotionsJson = [
  {
    'id': 'promo1',
    'productName': 'Bière Blonde',
    'type': 'percentage', // ou 'special_offer'
    'status': 'active',
    'reductionType': 'percentage',
    'reductionValue': 20,
    'description': '20% de réduction',
    'startDate': DateTime(2024, 1, 15),
    'endDate': DateTime(2024, 2, 15),
    'buyQuantity': null,
    'freeQuantity': null,
  },
  {
    'id': 'promo2',
    'productName': 'Pizza Margherita',
    'type': 'special_offer',
    'status': 'active',
    'buyQuantity': 2,
    'freeQuantity': 1,
    'description': 'Achetez 2 pizzas, obtenez 1 gratuite',
    'startDate': DateTime(2024, 1, 1),
    'endDate': DateTime(2024, 1, 31),
    'reductionType': null,
    'reductionValue': null,
  },
  {
    'id': 'promo3',
    'productName': 'Café Expresso',
    'type': 'special_offer',
    'status': 'inactive',
    'buyQuantity': 3,
    'freeQuantity': 1,
    'description': 'Achetez 3 cafés, obtenez 1 gratuit',
    'startDate': DateTime(2024, 1, 1),
    'endDate': DateTime(2024, 1, 10),
    'reductionType': null,
    'reductionValue': null,
  },
];
