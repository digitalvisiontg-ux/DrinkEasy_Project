import 'package:dio/dio.dart';
import 'package:drink_eazy/Api/models/commande_model.dart';
import 'package:drink_eazy/Api/provider/OrderProvider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/Api/provider/table_provider.dart';
import 'package:drink_eazy/Api/services/commande_service.dart';
import 'package:drink_eazy/App/Modules/Cart/View/CommandeValideePage.dart';
import 'package:drink_eazy/App/Modules/Home/View/QrScanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PasserCommandePage extends StatefulWidget {
  const PasserCommandePage({
    super.key,
    required List<Map<String, dynamic>> cartItems,
  });

  @override
  State<PasserCommandePage> createState() => _PasserCommandePageState();
}

class _PasserCommandePageState extends State<PasserCommandePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _tableController = TextEditingController();

  int _currentStep = 1;
  bool _isScanning = false;
  bool _showExampleText =
      true; // Variable pour contrôler l'affichage du texte d'exemple

  late AnimationController _scanController;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scanAnim = CurvedAnimation(
      parent: _scanController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    _tableController.dispose();
    super.dispose();
  }

  /// ===============================
  /// QR SCAN
  /// ===============================
  Future<void> _startQrScan() async {
    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _scanController.repeat(reverse: true);
    });

    final token = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );

    if (!mounted) return;

    _scanController.stop();
    setState(() => _isScanning = false);

    if (token == null) return;

    final tableProvider = context.read<TableProvider>();

    _showLoading();
    final success = await tableProvider.verifyByQr(token);
    Navigator.pop(context);

    if (!success || tableProvider.table == null) {
      _showBusinessError(
        "QR code invalide. Veuillez réessayer ou saisir la table manuellement.",
      );
      return;
    }

    _finalizeStep1();
  }

  /// ===============================
  /// MANUAL CONFIRM
  /// ===============================
  Future<void> _confirmManual() async {
    final value = _tableController.text.trim().toUpperCase();

    if (value.length != 4) {
      _showBusinessError("Code table invalide");
      return;
    }

    final tableProvider = context.read<TableProvider>();

    _showLoading();
    final success = await tableProvider.verifyByManual(value);
    Navigator.pop(context);

    if (!success || tableProvider.table == null) {
      _showBusinessError("Numéro de table invalide. Vérifiez et réessayez.");
      return;
    }
    _finalizeStep1();
  }

  /// ===============================
  /// FINALISER ÉTAPE 1
  /// ===============================
  void _finalizeStep1() {
    final table = context.read<TableProvider>().table;
    if (table == null) {
      _showBusinessError("Table non trouvée. Veuillez réessayer.");
      return;
    }

    final orderProvider = context.read<OrderProvider>();
    final cartProvider = context.read<CartProvider>();

    orderProvider.setTable(
      tableId: table.id,
      numeroTable: table.numeroTable,
      libelle: table.libelle,
    );
    orderProvider.setItems(cartProvider.itemsList);

    setState(() => _currentStep = 2);
  }

  void _showBusinessError(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// CONFIRM ORDER
  /// ===============================
  Future<void> _confirmOrder() async {
    final order = context.read<OrderProvider>();
    final table = context.read<TableProvider>().table;
    final cart = context.read<CartProvider>();
    print("1");
    if (table == null || order.items.isEmpty) {
      _showBusinessError("Commande invalide");
      return;
    }
    print("2");
    final commandeService = CommandeService();

    // Payload attendu par Laravel
    final itemsPayload = order.items
        .map((e) => {'produit_id': e.produit.id, 'quantite': e.quantite})
        .toList();

    _showLoading();
    print("3");
    try {
      print("4");
      final auth = context.read<AuthProvider>();
      String? guestToken;
      if (!auth.isAuthenticated) {
        guestToken = await _getGuestToken();
      }

      final response = await commandeService.createCommande(
        tableId: table.id,
        items: itemsPayload,
        commentaire: null,
        guestToken: guestToken,
      );
      print("5");
      Navigator.pop(context); // close loader
      print("6");
      if (response['success'] == true) {
        print("7");
        final itemsSnapshot = order.items
            .map((e) => {'product': e.produit, 'quantity': e.quantite})
            .toList();

        final totalSnapshot = order.totalPrice.toInt();
        final tableLabelSnapshot = order.tableLabel;

        final commande = CommandeModel.fromJson(response['commande']);

        // Nettoyage état
        cart.clearCart();
        order.clearOrder();
        print("8");
        // Navigation succès
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommandeValideePage(
              cartItems: itemsSnapshot,
              totalPrice: totalSnapshot,
              tableNumber: tableLabelSnapshot,
              commande: commande,
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        _showBusinessError(response['message'] ?? "Échec de la commande");
      }
    } catch (e) {
      print("9");
      if (e is DioException) {
        print("STATUS: ${e.response?.statusCode}");
        print("DATA: ${e.response?.data}");
      } else {
        print(e.toString());
      }
      Navigator.pop(context);
      _showBusinessError("Erreur serveur. Réessayez.");
    }
  }

  /// ===============================
  /// UI HELPERS
  /// ===============================
  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          const Center(child: CircularProgressIndicator(color: Colors.amber)),
    );
  }

  /// ===============================
  /// BUILD
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB), // Couleur du Front
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        centerTitle: true,
        title: const Text(
          "Passer la commande",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
          ),
          // Affichage du bouton uniquement à l'étape 2
          if (_currentStep == 2) _buildBottomCTA(),
        ],
      ),
    );
  }

  /// ===============================
  /// HEADER (Step Indicator du Front)
  /// ===============================
  Widget _buildHeader({required bool step2}) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: step2 ? Colors.green : const Color(0xFFFFD73C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: step2
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : const Text(
                          "1",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 6),
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Numéro de table",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 30,
          height: 3,
          color: step2 ? Colors.green : Colors.grey.shade300,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: step2 ? const Color(0xFFFFD73C) : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    "2",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Confirmation",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: step2 ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ===============================
  /// STEP 1 – DESIGN FRONT (Logique Back)
  /// ===============================
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(step2: false),
          const SizedBox(height: 22),

          // Carte Scanner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 120, // Taille ajustée proche du back mais style front
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4C0),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 70,
                        color: Color(0xFFE0A900),
                      ),
                      if (_isScanning)
                        AnimatedBuilder(
                          animation: _scanAnim,
                          builder: (_, __) => Positioned(
                            top: 20 + _scanAnim.value * 80,
                            left: 25,
                            right: 25,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                color: Colors.amber, // ou Yellow.shade800
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: _startQrScan, // Logique du Back
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(34),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD73C),
                        borderRadius: BorderRadius.circular(34),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.black,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _isScanning
                                  ? "Scan en cours..."
                                  : "Scanner le QR code",
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Divider "ou"
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "ou",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),

          const SizedBox(height: 22),

          // Carte Saisie Manuelle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "Saisie manuelle",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tableController, // Variable Back
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.characters,
                          maxLength:
                              4, // Back : 4 chars, Front : 2 (Back prioritaire)
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[A-Z0-9]'),
                            ),
                          ],
                          style: const TextStyle(
                            fontSize: 25,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: "", // Supprimé pour le style épuré
                          ),
                          onChanged: (value) {
                            // Cacher le texte d'exemple lorsque l'utilisateur entre un numéro de table
                            setState(() {
                              _showExampleText = value.isEmpty;
                            });
                          },
                        ),
                      ),
                      // Afficher le texte d'exemple uniquement si le champ est vide
                      if (_showExampleText)
                        Text(
                          "Ex. A12B",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Bouton Confirmer Manuelle
                GestureDetector(
                  onTap: _confirmManual, // Logique du Back
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Confirmer",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// STEP 2 – DESIGN FRONT (Données Back)
  /// ===============================
  Widget _buildStep2() {
    // Récupération des données Back
    final order = context.watch<OrderProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(step2: true),
          const SizedBox(height: 22),

          // Carte Info Table (Gradient)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color.fromARGB(255, 255, 161, 54), Color(0xFFFFC107)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Votre table",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Table : ${order.tableLabel}", // Donnée Back
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // Liste des articles
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Votre commande",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8FFF3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        "${order.items.length} articles", // Donnée Back
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2AA55B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Génération de la liste basée sur les items du Back
                Column(
                  children: List.generate(order.items.length, (i) {
                    final item = order.items[i]; // Item du Back
                    return Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4E0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  "${i + 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFB76D00),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.produit.nomProd, // Donnée Back
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "×${item.quantite}", // Donnée Back
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${item.subtotal.toInt()} CFA", // Donnée Back
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        if (i < order.items.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Divider(color: Colors.grey.shade200),
                          ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 12),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 12),

                // Total
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Total",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      "${order.totalPrice.toInt()} CFA", // Donnée Back
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFB00020),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }

  /// ===============================
  /// CTA BOTTOM (Step 2 Only)
  /// ===============================
  Widget _buildBottomCTA() {
    return Positioned(
      // Ajout du viewInsets du Front pour éviter le clavier si besoin, bien que rare à l'étape 2
      bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      left: 18,
      right: 18,
      child: ElevatedButton.icon(
        onPressed: _confirmOrder, // Logique du Back
        icon: const Icon(
          Icons.check_circle_outline,
          size: 20,
          color: Colors.black,
        ),
        label: const Text(
          "Confirmer la commande",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

Future<String> _getGuestToken() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('guest_token');
  if (token == null) {
    token = const Uuid().v4();
    await prefs.setString('guest_token', token);
  }
  return token;
}
