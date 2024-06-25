import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/config/theme.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/screens/signup/bloc/signup_bloc.dart';
import 'package:insurance_map/screens/vehicles_screen/bloc/vehicles_bloc.dart';
import 'package:insurance_map/utils/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SignupBloc>(create: (context) => locator()),
      BlocProvider<VehiclesBloc>(create: (context) => locator()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: ValueListenableBuilder(
          valueListenable: AppNavigator.pages,
          builder: (context, value, child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: appTheme.primaryColor,
                actions: [
                  if (AppNavigator.getCurrentRoute() == Routes.vehiclesRoute)
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<VehiclesBloc>(context).add(VehiclesSubmit());
                        },
                        icon: const Icon(Icons.done, color: Colors.white)),
                  if (AppNavigator.getCurrentRoute() == Routes.vehiclesRoute)
                    IconButton(
                        onPressed: () {
                          BlocProvider.of<VehiclesBloc>(context).add(VehiclesAddNew());
                        },
                        icon: const Icon(Icons.add, color: Colors.white)),

                  const Spacer(flex: 200),

                  Visibility(
                    visible: AppNavigator.hasRoute(),
                    child: IconButton(
                        onPressed: () {
                          AppNavigator.pop();
                        },
                        icon: const Icon(Icons.arrow_forward_ios,
                            color: Colors.white)),
                  ),
                ],
              ),
              body: SafeArea(
                child: Navigator(
                  pages: value,
                  onPopPage: (route, result) {
                    bool isPop = route.didPop(result);
                    if (isPop) AppNavigator.pop();
                    return isPop;
                  },
                ),
              ),
            );
          },
        ));
  }
}
