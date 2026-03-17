import 'dart:async';
import 'dart:ui';
import 'package:drink_eazy/App/Component/button_component.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/nouveauMotDePasse.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OtpPage extends StatefulWidget {
  final String login; // email ou téléphone

  const OtpPage({Key? key, required this.login}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _otpController = TextEditingController();
  bool loading = false;
  
  // Timer related variables
  Timer? _timer;
  int _start = 90; // 1m30s = 90 seconds
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _start = 90;
      _isResendEnabled = false;
    });
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _isResendEnabled = true;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _resendOtp() async {
    if (!_isResendEnabled) return;

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.forgotPassword(widget.login);
    setState(() => loading = false);

    if (success == true) {
      showSuccessToast("Un nouveau code OTP a été envoyé.");
      _startTimer();
    } else {
      _showErrorPopup(auth.errorMessage ?? "Erreur lors du renvoi du code.");
    }
  }

  /// ✅ Toast de succès stylé
  void showSuccessToast(String message) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.greenAccent, width: 2),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
    );
  }

  /// ❌ Popup d’erreur avec flou
  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Code invalide",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 🧠 Vérification du code OTP
  Future<void> _verifyOtp() async {
    if (_otpController.text.length != 6) {
      _showErrorPopup("Veuillez entrer un code complet à 6 chiffres.");
      return;
    }

    String actualLogin = widget.login;
    if (actualLogin.isEmpty && Get.arguments != null && Get.arguments is Map) {
      actualLogin = Get.arguments['login']?.toString() ?? '';
    }

    if (actualLogin.isEmpty) {
      _showErrorPopup("Erreur interne : compte introuvable. Veuillez réessayer depuis le début.");
      return;
    }

    setState(() => loading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.verifyOtp(
      actualLogin,
      _otpController.text.trim(),
    );
    setState(() => loading = false);

    if (success == true) {
      showSuccessToast("Code vérifié avec succès.");
      await Future.delayed(const Duration(milliseconds: 1000));
      Get.to(
        () => NouveauMotDePassePage(
          login: actualLogin,
          otp: _otpController.text.trim(),
        ),
      );
    } else {
      _showErrorPopup(
        auth.errorMessage ?? "Le code OTP saisi est invalide. Réessayez.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final defaultPinTheme = PinTheme(
      width: size.width * 0.12,
      height: size.width * 0.14,
      textStyle: TextStyle(
        fontSize: size.width * 0.05,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          /// --- Image de fond
          Positioned.fill(
            child: Image.asset('assets/images/bgimage2.jpg', fit: BoxFit.cover),
          ),

          /// --- Filtre sombre
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.55)),
          ),

          /// --- Contenu principal
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.12),

                          /// --- Titre principal
                          Column(
                            children: [
                              Text(
                                'Vérification OTP',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.1,
                                  fontFamily: 'Agbalumo',
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Code envoyé à ${widget.login}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: size.width * 0.04,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),

                          /// --- Bloc blanc avec formulaire
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.06,
                              vertical: 28,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(32),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Entrez le code à 6 chiffres reçu",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: size.width * 0.04,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: Pinput(
                                    controller: _otpController,
                                    length: 6,
                                    defaultPinTheme: defaultPinTheme,
                                    focusedPinTheme: defaultPinTheme.copyWith(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.red.shade700,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    showCursor: true,
                                  ),
                                ),
                                const SizedBox(height: 28),
                                AbsorbPointer(
                                  absorbing: loading,
                                  child: ButtonComponent(
                                    textButton: "Suivant",
                                    onPressed: loading ? null : _verifyOtp,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                /// --- Minuteur et Renvoyer le code
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _isResendEnabled
                                          ? "Vous n'avez pas reçu de code ? "
                                          : "Renvoyer le code dans ",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: size.width * 0.035,
                                      ),
                                    ),
                                    _isResendEnabled
                                        ? GestureDetector(
                                            onTap: loading ? null : _resendOtp,
                                            child: Text(
                                              "Renvoyer",
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.width * 0.035,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            timerText,
                                            style: TextStyle(
                                              color: Colors.red.shade700,
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.width * 0.035,
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// ✅ Bouton retour placé au-dessus de tout
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (Get.previousRoute == '/motdepasseOublie') {
                      Get.back();
                    } else {
                      Get.offNamed('/motdepasseOublie');
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
