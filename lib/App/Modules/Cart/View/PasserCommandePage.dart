import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:drink_eazy/Api/provider/table_provider.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/Api/provider/OrderProvider.dart';

import 'package:drink_eazy/App/Modules/Home/View/QrScanner.dart';
import 'package:drink_eazy/App/Modules/Cart/View/CommandeValideePage.dart';

class PasserCommandePage extends StatefulWidget {
  const PasserCommandePage({super.key, required List<Map<String, dynamic>> cartItems});

  @override
  State<PasserCommandePage> createState() => _PasserCommandePageState();
}

class _PasserCommandePageState extends State<PasserCommandePage> {
  final TextEditingController _tableController = TextEditingController();

  int _currentStep = 1;
  bool _isScanning = false;

  @override
  void dispose() {
    _tableController.dispose();
    super.dispose();
  }

  /// ===============================
  /// QR SCAN
  /// ===============================
  Future<void> _startQrScan() async {
    if (_isScanning) return;

    setState(() => _isScanning = true);

    final scannedToken = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerPage()),
    );

    if (!mounted) return;
    setState(() => _isScanning = false);

    if (scannedToken == null) return;

    final tableProvider = context.read<TableProvider>();

    _showLoading();
    final success = await tableProvider.verifyByQr(scannedToken);
    if (!mounted) return;
    Navigator.pop(context);

    if (!success || tableProvider.table == null) {
      _showError(tableProvider.error ?? "QR Code invalide");
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
      _showError("Code table invalide");
      return;
    }

    final tableProvider = context.read<TableProvider>();

    _showLoading();
    final success = await tableProvider.verifyByManual(value);
    if (!mounted) return;
    Navigator.pop(context);

    if (!success || tableProvider.table == null) {
      _showError(tableProvider.error ?? "Table introuvable");
      return;
    }

    _finalizeStep1();
  }

  /// ===============================
  /// FINALISER ÉTAPE 1
  /// ===============================
  void _finalizeStep1() {
    final table = context.read<TableProvider>().table!;
    final orderProvider = context.read<OrderProvider>();
    final cartProvider = context.read<CartProvider>();

    orderProvider.setTableRaw(table.numeroTable);
    orderProvider.setItems(cartProvider.itemsList);

    setState(() => _currentStep = 2);
  }

  /// ===============================
  /// CONFIRM ORDER
  /// ===============================
  Future<void> _confirmOrder() async {
    final orderProvider = context.read<OrderProvider>();

    if (!orderProvider.hasTable) {
      _showError("Table non définie");
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommandeValideePage(
          cartItems: orderProvider.items
              .map((item) => {
                    'product': item.produit,
                    'quantity': item.quantite,
                  })
              .toList(),
          totalPrice: orderProvider.totalPrice.toInt(),
          tableNumber: orderProvider.tableLabel,
        ),
      ),
    );

    if (result != null) {
      orderProvider.clearOrder();
      Navigator.pop(context, result);
    }
  }

  /// ===============================
  /// UI HELPERS
  /// ===============================
  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.amber),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  String _formatCFA(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if ((s.length - i) % 3 == 0 && i != 0) buffer.write(' ');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  /// ===============================
  /// BUILD
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .4,
        centerTitle: true,
        title: const Text(
          "Passer la commande",
          style: TextStyle(fontWeight: FontWeight.w700),
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
          if (_currentStep == 2) _buildBottomCTA(),
        ],
      ),
    );
  }

  /// ===============================
  /// STEP 1
  /// ===============================
  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 140),
      child: Column(
        children: [
          _buildHeader(step2: false),
          const SizedBox(height: 24),
          _buildQrCard(),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildManualCard(),
        ],
      ),
    );
  }

  Widget _buildQrCard() {
    return _card(
      Column(
        children: [
          const Icon(Icons.qr_code_scanner, size: 80, color: Colors.amber),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isScanning ? null : _startQrScan,
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text("Scanner le QR"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualCard() {
    return _card(
      Column(
        children: [
          const Text(
            "Saisie manuelle",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _tableController,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            maxLength: 4,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
            ],
            decoration: const InputDecoration(
              hintText: "Ex : A9K7",
              counterText: "",
              filled: true,
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _confirmManual,
            icon: const Icon(Icons.check),
            label: const Text("Confirmer"),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// STEP 2
  /// ===============================
  Widget _buildStep2() {
    final order = context.watch<OrderProvider>();
    final items = order.items;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
      child: Column(
        children: [
          _buildHeader(step2: true),
          const SizedBox(height: 22),
          _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Table : ${order.tableLabel}",
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 14),
                ...items.map(
                  (item) => ListTile(
                    title: Text(item.produit.nomProd),
                    subtitle: Text("x${item.quantite}"),
                    trailing: Text(
                      "${_formatCFA(item.subtotal.toInt())} CFA",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Divider(),
                Text(
                  "Total : ${_formatCFA(order.totalPrice.toInt())} CFA",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Positioned(
      bottom: 20,
      left: 18,
      right: 18,
      child: ElevatedButton.icon(
        onPressed: _confirmOrder,
        icon: const Icon(Icons.check_circle_outline, color: Colors.black),
        label: const Text(
          "Confirmer la commande",
          style: TextStyle(color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// COMMON
  /// ===============================
  Widget _buildHeader({required bool step2}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _stepCircle(1, completed: step2),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 3,
          color: step2 ? Colors.green : Colors.grey.shade300,
        ),
        const SizedBox(width: 8),
        _stepCircle(2, active: step2),
      ],
    );
  }

  Widget _stepCircle(int n, {bool completed = false, bool active = false}) {
    return CircleAvatar(
      radius: 15,
      backgroundColor:
          completed || active ? Colors.amber : Colors.grey.shade300,
      child: completed
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : Text(
              "$n",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text("ou", style: TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }
}
