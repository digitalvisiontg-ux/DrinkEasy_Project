import 'package:drink_eazy/Admin_App/Admin_Modules/Admin_Products/AdminProductsPage.dart';
import 'package:drink_eazy/Api/provider/OrderProvider.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/Api/provider/cartProvider.dart';
import 'package:drink_eazy/Api/provider/produit_provider.dart';
import 'package:drink_eazy/Api/provider/running_order_provider.dart';
import 'package:drink_eazy/Api/provider/table_provider.dart';
import 'package:drink_eazy/App/Modules/Account/View/accountPage.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/connexion.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_choice_page.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_email.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_phone.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/motDePasseOublier.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/otp.dart';
import 'package:drink_eazy/App/Modules/Cart/View/cart_page.dart';
import 'package:drink_eazy/App/Modules/Cart/View/mes_commandes_page.dart';
import 'package:drink_eazy/App/Modules/Gerer_Compte/View/gerer_Compte.dart';
import 'package:drink_eazy/App/Modules/Historique_commandes/View/historique_commandes.dart';
import 'package:drink_eazy/App/Modules/Home/View/OrderDetailsPag.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/App/Modules/Offres_speciales/View/offres_speciales.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/AboutPage.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/Confidentiality.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/Help_center.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/Information_compte.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/changer_mot_de_passe_page.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/contacter_personnel_page.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/nous_contacter_page.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/parametres_page.dart';
import 'package:drink_eazy/App/Modules/Param%C3%A8tre/View/signaler_probleme_page.dart';
import 'package:drink_eazy/App/Modules/Splash/View/splash.dart';
import 'package:drink_eazy/App/Modules/Support_Client/View/support_client_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

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
  // Créer le provider et attendre la restauration de session AVANT runApp
  final auth = AuthProvider();
  await auth.restoreSession();

  final produitProvider = ProduitProvider();
  await produitProvider.fetchProduits();

  final runningOrderProvider = RunningOrderProvider();
  await runningOrderProvider.restoreFromLocal();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
        ChangeNotifierProvider.value(value: produitProvider),
        ChangeNotifierProvider.value(value: runningOrderProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => TableProvider()),
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
      initialRoute: '/splash',
      // initialRoute: '/admin_products',
      getPages: [
        GetPage(
          name: '/inscription_choice',
          page: () => const InscriptionChoicePage(),
        ),
        GetPage(name: '/home', page: () => const Home()),
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
        GetPage(name: '/parametres', page: () => const ParametresPage()),
        GetPage(name: '/account', page: () => const AccountPage()),
        GetPage(name: '/cart', page: () => CartPage()),
        GetPage(name: '/Gerer_compte', page: () => const GererComptePage()),
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
          page: () {
            String logId = '';
            if (Get.arguments != null && Get.arguments is Map) {
              logId = Get.arguments['login']?.toString() ?? '';
            }
            return OtpPage(login: logId);
          },
        ),
        GetPage(name: '/account', page: () => const AccountPage()),
        GetPage(name: "/orderDetails", page: () => const OrderDetailsPage()),
        GetPage(name: "/help_center", page: () => const HelpCenterPage()),
        GetPage(name: "/mesCommandes", page: () => const MesCommandesPage()),
        GetPage(
          name: "/confidentiality",
          page: () => const ConfidentialityPage(),
        ),
        GetPage(
          name: "/information_compte",
          page: () => const InformationComptePage(),
        ),
        GetPage(name: "/about", page: () => const AboutPage()),
        GetPage(
          name: "/contacter_personnel",
          page: () => const ContacterPersonnelPage(),
        ),
        GetPage(
          name: "/signaler_probleme",
          page: () => const SignalerProblemePage(),
        ),
        GetPage(name: "/contact", page: () => const NousContacterPage()),
        GetPage(
          name: "/changer_mot_de_passe",
          page: () => const ChangerMotDePassePage(),
        ),
        GetPage(
          name: "/MesCommandesPage",
          page: () => const MesCommandesPage(),
        ),
        GetPage(name: '/splash', page: () => const SplashPage()),
        GetPage(name: '/admin_products', page: () => AdminProductsPage()),

        // Provide an empty list or appropriate cart items
      ],
    );
  }
}
