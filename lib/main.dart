import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/community/chat_page.dart';
import 'package:saver_bbk_main/modules/food_swap/bloc/food_swap_bloc.dart';
import 'package:saver_bbk_main/modules/kitchen_management/bloc/kitchen_manager_bloc.dart';
import 'package:saver_bbk_main/firebase_options.dart';
import 'package:saver_bbk_main/modules/profile/bloc/profile_bloc.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/bloc/smart_shopping_bloc.dart';

import 'package:saver_bbk_main/modules/splash_screen/splash_screen.dart';
import 'package:saver_bbk_main/modules/zero_waste_challenges/bloc/challenge_bloc.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/bloc/zero_waste_cooking_bloc.dart';
import 'package:saver_bbk_main/services/app_services.dart';
import 'package:saver_bbk_main/styles/colors.dart';

const boxName = 'myBox';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print('Background message: ${message.messageId}');

  /// Trigger the `addNotification` function
  await Services.addNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await dotenv.load(fileName: "lib/.env");
  await Hive.initFlutter();
  await Hive.openBox(boxName);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final box = Hive.box(boxName);
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  void initState() {
    super.initState();
    initNotifications();
    handleNotificationClick();
  }

  void initNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Services.addNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message);
    });
  }

  void handleNotificationClick() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationNavigation(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message);
    });
  }

  void _handleNotificationNavigation(RemoteMessage message) {
    if (message.data.containsKey('type')) {
      String type = message.data['type'];
      switch (type) {
        case "message":
          String chatRoomId = message.data['chatRoomId'];
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(
              builder:
                  (context) => ChatPage(
                    isFromFoodSwap: false,
                    isFromNotifications: true,
                    chatRoomId: chatRoomId,
                  ),
            ),
          );
          break;
        default:
          debugPrint("Unknown notification type");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
        BlocProvider<KitchenManagerBloc>(
          create: (context) => KitchenManagerBloc(),
        ),
        BlocProvider<FoodSwapBloc>(create: (context) => FoodSwapBloc()),
        BlocProvider<ZeroWasteCookingBloc>(
          create: (context) => ZeroWasteCookingBloc(),
        ),
        BlocProvider<CommunityBloc>(create: (context) => CommunityBloc()),
        BlocProvider<ChallengeBloc>(create: (context) => ChallengeBloc()),
        BlocProvider<SmartShoppingBloc>(
          create: (context) => SmartShoppingBloc(context),
        ),
      ],
      child: MaterialApp(
        title: 'Saver App',
        theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: SplashScreen(),
      ),
    );
  }
}
