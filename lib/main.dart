import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:summa/core/router/app_router.dart';
import 'package:summa/core/theme/app_theme.dart';
import 'package:summa/data/repository/shopping_item_repository_impl.dart';
import 'package:summa/data/repository/shopping_list_repository_impl.dart';
import 'package:summa/domain/repositories/shopping_item_repository.dart';
import 'package:summa/domain/repositories/shopping_list_repository.dart';
import 'package:summa/features/lists/shopping_list_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await MobileAds.instance.initialize();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };

  runApp(
    MultiProvider(
      providers: [
        Provider<ShoppingListRepository>(
          create: (_) => ShoppingListRepositoryImpl(),
        ),
        Provider<ShoppingItemRepository>(
          create: (_) => ShoppingItemRepositoryImpl(),
        ),

        ChangeNotifierProvider(
          create: (context) => ShoppingListViewmodel(
            itemRepository: context.read<ShoppingItemRepository>(),
            context.read<ShoppingListRepository>(),
          ),
        ),
      ],
      child: const SummaApp(),
    ),
  );
}

class SummaApp extends StatelessWidget {
  const SummaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Summa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: child!,
        );
      },
    );
  }
}
