import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saver_bbk_main/modules/community/bloc/community_bloc.dart';
import 'package:saver_bbk_main/modules/community/chat_page.dart';
import 'package:saver_bbk_main/modules/food_share/bloc/food_share_bloc.dart';
import 'package:saver_bbk_main/modules/food_swap/bloc/food_swap_bloc.dart';
import 'package:saver_bbk_main/modules/kitchen_management/bloc/kitchen_manager_bloc.dart';
import 'package:saver_bbk_main/firebase_options.dart';
import 'package:saver_bbk_main/modules/notifications/bloc/notification_bloc.dart';
import 'package:saver_bbk_main/modules/profile/bloc/profile_bloc.dart';
import 'package:saver_bbk_main/modules/smart_shopping_list/bloc/smart_shopping_bloc.dart';
import 'package:saver_bbk_main/modules/splash_screen/splash_screen.dart';
import 'package:saver_bbk_main/modules/zero_waste_challenges/bloc/challenge_bloc.dart';
import 'package:saver_bbk_main/modules/zero_waste_cooking/bloc/zero_waste_cooking_bloc.dart';
import 'package:saver_bbk_main/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const boxName = 'myBox';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {});

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
        BlocProvider<NotificationBloc>(create: (context) => NotificationBloc()),
        BlocProvider<FoodShareBloc>(create: (context) => FoodShareBloc()),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Saver App',
            theme: ThemeData(scaffoldBackgroundColor: AppColor.white),
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
