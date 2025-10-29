// import 'package:drink_eazy/Api/debug/auth/home_page.dart';
// import 'package:drink_eazy/Api/debug/test_api.dart';
// import 'package:drink_eazy/Api/debug/auth/login_test_page.dart';
import 'package:drink_eazy/Api/provider/auth_provider.dart';
import 'package:drink_eazy/App/Modules/Home/View/home.dart';
import 'package:drink_eazy/App/Modules/Account/View/accountPage.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_choice_page.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_email.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/inscription_phone.dart';
import 'package:drink_eazy/App/Modules/Authentification/View/motDePasseOublier.dart';
import 'package:drink_eazy/App/Modules/Splash/View/splash.dart';
import 'package:flutter/material.dart';
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

  // Créer le provider et attendre la restauration de session AVANT runApp
  final auth = AuthProvider();
  await auth.restoreSession();

  runApp(
    MultiProvider(
      providers: [
        // Fournir l'instance déjà initialisée
        ChangeNotifierProvider.value(value: auth),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final Widget initial = (auth.user != null) ? const Home() : const SplashPage();

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
      ],
  home: initial,
      // home: BarTestPage(),
      // home: HomePage(),
    );
  }
}
