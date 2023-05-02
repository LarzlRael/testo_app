import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/config/router/app_router.dart';
import 'package:teslo_shop/contants/enviroment.dart';

void main() async {
  await Enviroment.initEnviroment();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouterProvider = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: appRouterProvider,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
