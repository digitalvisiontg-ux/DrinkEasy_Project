/* =========================================================
   JSON NOTIFICATIONS
   ========================================================= */

final List<Map<String, dynamic>> notificationsJson = [
  {
    'id': 'notif1',
    'type': 'order', // order, stock, promotion, system
    'title': 'Nouvelle commande',
    'message': 'Commande #045 de Marie Dupont (Table 5)',
    'time': DateTime.now().subtract(const Duration(minutes: 5)),
    'isRead': false,
    'priority': 'high', // high, medium, low
  },
  {
    'id': 'notif2',
    'type': 'stock',
    'title': 'Alerte stock',
    'message': 'Le stock de "Heineken" est faible (3 restants)',
    'time': DateTime.now().subtract(const Duration(minutes: 15)),
    'isRead': false,
    'priority': 'high',
  },
  {
    'id': 'notif3',
    'type': 'order',
    'title': 'Commande confirmée',
    'message': 'La commande #044 a été confirmée avec succès',
    'time': DateTime.now().subtract(const Duration(hours: 1)),
    'isRead': false,
    'priority': 'medium',
  },
  {
    'id': 'notif4',
    'type': 'promotion',
    'title': 'Promotion expirée',
    'message': 'La promotion "20% Bière Blonde" a expiré',
    'time': DateTime.now().subtract(const Duration(hours: 2)),
    'isRead': true,
    'priority': 'low',
  },
  {
    'id': 'notif5',
    'type': 'order',
    'title': 'Nouvelle commande',
    'message': 'Commande #043 de Jean Martin (Table 2)',
    'time': DateTime.now().subtract(const Duration(hours: 3)),
    'isRead': true,
    'priority': 'medium',
  },
  {
    'id': 'notif6',
    'type': 'system',
    'title': 'Mise à jour disponible',
    'message': 'Une nouvelle version de l\'application est disponible',
    'time': DateTime.now().subtract(const Duration(days: 1)),
    'isRead': true,
    'priority': 'low',
  },
  {
    'id': 'notif7',
    'type': 'stock',
    'title': 'Rupture de stock',
    'message': 'Le produit "Mojito" est en rupture de stock',
    'time': DateTime.now().subtract(const Duration(days: 1)),
    'isRead': true,
    'priority': 'high',
  },
];
