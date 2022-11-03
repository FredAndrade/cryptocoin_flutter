import 'package:crypto_flutter/configs/hive_config.dart';
import 'package:crypto_flutter/myApp.dart';
import 'package:crypto_flutter/repositories/conta_repository.dart';
import 'package:crypto_flutter/repositories/favoritas_repository.dart';
import 'package:crypto_flutter/repositories/moeda_repository.dart';
import 'package:crypto_flutter/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'configs/app_settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: '430790474531',
      appId: 'com.example.cripto_moedas',
      messagingSenderId: 'teste',
      projectId: 'crypto-app',
    ),
  );
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => MoedaRepository(),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (context) => ContaRepository(
              moedas: context.read<MoedaRepository>(),
            )),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(
          create: (context) => FavoritasRepository(
            auth: context.read<AuthService>(),
            moedas: context.read<MoedaRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
