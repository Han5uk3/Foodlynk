import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saver_bbk_main/firebase_options.dart';
import 'package:saver_bbk_main/modules/profile/bloc/profile_bloc.dart';

import 'package:saver_bbk_main/modules/splash_screen/splash_screen.dart';
import 'package:saver_bbk_main/styles/colors.dart';

const boxName = 'myBox';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox(boxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final box = Hive.box(boxName);
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      ],
      child: MaterialApp(
        title: 'Saver App',
        theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
