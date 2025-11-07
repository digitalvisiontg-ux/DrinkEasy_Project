// import 'package:drink_eazy/Api/debug/auth/home_page.dart';
// import 'package:drink_eazy/Api/debug/test_api.dart';
// import 'package:drink_eazy/Api/debug/auth/login_test_page.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';
import 'package:drink_eazy/App/Modules/Account/View/accountPage.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/connexion.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_choice_page.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_email.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_phone.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/motDePasseOublier.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/otp.dart';
import 'package:drink_eazy/App/Modules/Cart/View/cart_page.dart';
import 'package:drink_eazy/App/Modules/Historique_commandes/View/historique_commandes.dart';
import 'package:drink_eazy/App/Modules/Offres_speciales/View/offres_speciales.dart';
import 'package:drink_eazy/App/Modules/Splash/View/splash.dart';
import 'package:drink_eazy/App/Modules/Support_Client/View/support_client_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Make app draw edge-to-edge so the splash image can extend under
  // the status/navigation bars. Also set transparent bars so the image
  // shows through (helps avoid visible bars with a different background).
  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  } catch (_) {}

  // Créer le provider et attendre la restauration de session AVANT runApp
  final auth = AuthProvider();
  await auth.restoreSession();
  // Précharger les produits pour les rendre disponibles immédiatement
  // (évite que Home reçoive une liste vide au démarrage)
  final produitProvider = ProduitProvider();
  await produitProvider.fetchProduits();
  // Debug: print how many produits were fetched (voir console)
  try {
    print('Produits préchargés: ${produitProvider.produits.length}');
  } catch (_) {}

  runApp(
    MultiProvider(
      providers: [
        // Fournir l'instance déjà initialisée
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: produitProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: '/inscription_choice',
          page: () => const InscriptionChoicePage(),
        ),
        GetPage(
          name: '/inscription_email',
          page: () => const InscriptionEmailPage(),
        ),
        GetPage(
          name: '/inscription_phone',
          page: () => const InscriptionPhonePage(),
        ),
        GetPage(
          name: '/mot_de_passe_oublie',
          page: () => const MotDePasseOubliePage(),
        ),
        GetPage(name: '/account', page: () => const AccountPage()),
        GetPage(
          name: '/cart',
          page: () => const CartPage(cartItems: []),
        ),
        GetPage(
          name: '/historique_commandes',
          page: () => const HistoriqueCommandesPage(),
        ),
        GetPage(
          name: '/offres_speciales',
          page: () => const OffresSpecialesPage(),
        ),
        GetPage(name: '/support_client', page: () => const SupportClientPage()),
        GetPage(name: '/connexion', page: () => const ConnexionPage()),
        GetPage(
          name: '/mot_de_passe_oublie',
          page: () => const MotDePasseOubliePage(),
        ),
        GetPage(
          name: '/otp',
          page: () => const OtpPage(login: ''),
        ),

        // Provide an empty list or appropriate cart items
      ],
      // Toujours démarrer sur la Splash. La Splash va rediriger vers Home
      // si l'utilisateur est déjà connecté (comportement souhaité).
      home: const SplashPage(),
      // home: BarTestPage(),
      // home: HomePage(),
    );
  }
}
