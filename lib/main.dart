import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/config/theme.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/local/signup_types.dart';
import 'package:insurance_map/screens/bank_cards/bloc/bank_cards_bloc.dart';
import 'package:insurance_map/screens/cards_and_vehicles/bloc/c_a_v_bloc.dart';
import 'package:insurance_map/screens/categories/bloc/categories_bloc.dart';
import 'package:insurance_map/screens/companies/bloc/companies_bloc.dart';
import 'package:insurance_map/screens/content_view/bloc/content_view_bloc.dart';
import 'package:insurance_map/screens/insurance_request/bloc/insurance_request_bloc.dart';
import 'package:insurance_map/screens/main/bloc/main_bloc.dart';
import 'package:insurance_map/screens/map_screen/bloc/map_bloc.dart';
import 'package:insurance_map/screens/signup/bloc/signup_bloc.dart';
import 'package:insurance_map/screens/social_responsibilities/bloc/s_r_bloc.dart';
import 'package:insurance_map/screens/ticket/bloc/ticket_bloc.dart';
import 'package:insurance_map/screens/vehicles_screen/bloc/vehicles_bloc.dart';
import 'package:insurance_map/utils/di.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setup();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<SignupBloc>(create: (context) => locator()),
      BlocProvider<VehiclesBloc>(create: (context) => locator()),
      BlocProvider<BankCardsBloc>(create: (context) => locator()),
      BlocProvider<MainBloc>(create: (context) => locator()),
      BlocProvider<CategoriesBloc>(create: (context) => locator()),
      BlocProvider<CompaniesBloc>(create: (context) => locator()),
      BlocProvider<MapBloc>(create: (context) => locator()),
      BlocProvider<ContentViewBloc>(create: (context) => locator()),
      BlocProvider<TicketBloc>(create: (context) => locator()),
      BlocProvider<CAVBloc>(create: (context) => locator()),
      BlocProvider<InsuranceRequestBloc>(create: (context) => locator()),
      BlocProvider<SRBloc>(create: (context) => locator()),
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
            return Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: Scaffold(
                  drawer: AppNavigator.getCurrentRoute() != Routes.mainRoute
                      ? null
                      : Drawer(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 32),
                                      child: Image.asset('assets/img/drawer_img.jpg', fit: BoxFit.fill, width: double.infinity),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 8,
                                      left: 0,
                                      child: PreferenceBuilder<String>(
                                          preference: locator<SharedPreferenceHelper>().getName(),
                                          builder: (context, nameValue) {
                                            if (nameValue.isEmpty) {
                                              return const SizedBox();
                                            }

                                            return Row(
                                              textDirection: TextDirection.rtl,
                                              children: [
                                                PreferenceBuilder<String>(
                                                    preference: locator<SharedPreferenceHelper>().getAvatar(),
                                                    builder: (context, avatarValue) {
                                                      if (avatarValue.isEmpty) {
                                                        return Image.asset('assets/img/avatar.png', width: 88, height: 88);
                                                      }

                                                      return ClipOval(child: Image.network(avatarValue, width: 88, height: 88));
                                                    }),
                                                const SizedBox(width: 16),
                                                Column(
                                                  children: [
                                                    Text(
                                                      nameValue,
                                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                    ),
                                                    PreferenceBuilder<String>(
                                                        preference: locator<SharedPreferenceHelper>().getPhone(),
                                                        builder: (context, phoneValue) {
                                                          return Text(
                                                            phoneValue,
                                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                          );
                                                        }),
                                                    const SizedBox(height: 16),
                                                    PreferenceBuilder<int>(
                                                        preference: locator<SharedPreferenceHelper>().getWallet(),
                                                        builder: (context, walletValue) {
                                                          return Text(
                                                            'موجودی $walletValue تومان',
                                                            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                                                          );
                                                        }),
                                                  ],
                                                )
                                              ],
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      PreferenceBuilder<String>(
                                          preference: locator<SharedPreferenceHelper>().getName(),
                                          builder: (context, value) {
                                            if (value.isNotEmpty) return const SizedBox();
                                
                                            return InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                AppNavigator.push(Routes.signupRoute);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                child: Row(
                                                  textDirection: TextDirection.rtl,
                                                  children: [
                                                    Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(width: 8),
                                                    Text('ورود', style: TextStyle(fontWeight: FontWeight.w600))
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                      PreferenceBuilder<String>(
                                        preference: locator<SharedPreferenceHelper>().getName(),
                                        builder: (context, value) {
                                          if (value.isNotEmpty) return const SizedBox();
                                
                                          return ExpansionTile(
                                            title: const Row(
                                              textDirection: TextDirection.rtl,
                                              children: [
                                                Icon(
                                                  Icons.person_2_outlined,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(width: 8),
                                                Text('ثبت نام', style: TextStyle(fontWeight: FontWeight.w600))
                                              ],
                                            ),
                                            children: [
                                              SizedBox(
                                                width: double.infinity,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    AppNavigator.push(Routes.signupRoute, args: SignupTypes.representatives);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'ثبت نام نمایندگان بیمه',
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    AppNavigator.push(Routes.signupRoute, args: SignupTypes.businesses);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'ثبت نام کسب و کار ها',
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    AppNavigator.push(Routes.signupRoute, args: SignupTypes.vehicles);
                                                  },
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      'ثبت نام صاحبان وسایل نقلیه',
                                                      textAlign: TextAlign.start,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          AppNavigator.push(Routes.categoriesRoute, args: '');
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Icon(
                                                Icons.map_outlined,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 8),
                                              Text('دسته بندی ها', style: TextStyle(fontWeight: FontWeight.w600))
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          AppNavigator.push(Routes.vehiclesRoute);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Icon(
                                                Icons.add,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 8),
                                              Text('ثبت خودرو', style: TextStyle(fontWeight: FontWeight.w600))
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          BlocProvider.of<ContentViewBloc>(context).add(ContentViewGet('terms'));
                                          AppNavigator.push(Routes.contentViewRoute);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Icon(
                                                Icons.file_present_outlined,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 8),
                                              Text('قوانین و مقررات', style: TextStyle(fontWeight: FontWeight.w600))
                                            ],
                                          ),
                                        ),
                                      ),
                                      PreferenceBuilder<String>(
                                        preference: locator<SharedPreferenceHelper>().getName(),
                                        builder: (context, value) {
                                          if (value.isEmpty) return const SizedBox();
                                
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              AppNavigator.push(Routes.ticketRoute);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              child: Row(
                                                textDirection: TextDirection.rtl,
                                                children: [
                                                  Icon(
                                                    Icons.support_agent_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('پشتیبانی', style: TextStyle(fontWeight: FontWeight.w600))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          BlocProvider.of<ContentViewBloc>(context).add(ContentViewGet('about-us'));
                                          AppNavigator.push(Routes.contentViewRoute);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Icon(
                                                Icons.info_outline,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 8),
                                              Text('معرفی بی‌مرزان', style: TextStyle(fontWeight: FontWeight.w600))
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          AppNavigator.push(Routes.inviteRoute);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          child: Row(
                                            textDirection: TextDirection.rtl,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color: Colors.grey,
                                              ),
                                              SizedBox(width: 8),
                                              Text('معرفی به دوستان', style: TextStyle(fontWeight: FontWeight.w600))
                                            ],
                                          ),
                                        ),
                                      ),
                                      PreferenceBuilder<String>(
                                        preference: locator<SharedPreferenceHelper>().getName(),
                                        builder: (context, value) {
                                          if (value.isEmpty) return const SizedBox();
                                
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _showAlertDialog(context);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                              child: Row(
                                                textDirection: TextDirection.rtl,
                                                children: [
                                                  Icon(
                                                    Icons.logout,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(width: 8),
                                                  Text('خروج از حساب کاربری', style: TextStyle(fontWeight: FontWeight.w600))
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                  appBar: AppBar(
                    backgroundColor: appTheme.primaryColor,
                    iconTheme: const IconThemeData(color: Colors.white),
                    title: Center(child: _getTitle(AppNavigator.getCurrentRoute())),
                    actions: [
                      // منوی بازگشت به صفحه قبلی
                      Visibility(
                        visible: AppNavigator.hasRoute(),
                        child: IconButton(
                            onPressed: () {
                              if (AppNavigator.getCurrentRoute() == Routes.categoriesRoute) {
                                BlocProvider.of<CategoriesBloc>(context).add(CategoriesBack());
                              } else {
                                AppNavigator.pop();
                              }
                            },
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.white)),
                      ),

                      Visibility(
                        visible: AppNavigator.getCurrentRoute() == Routes.mainRoute,
                        child: IconButton(
                            onPressed: () {
                              BlocProvider.of<CAVBloc>(context).add(CAVGetData());
                              AppNavigator.push(Routes.cardsAndVehiclesRoute);
                            },
                            icon: const Icon(Icons.add, color: Colors.white)),
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: PopScope(
                      canPop: !AppNavigator.hasRoute(),
                      onPopInvoked: (didPop) {
                        if (AppNavigator.getCurrentRoute() == Routes.categoriesRoute) {
                          BlocProvider.of<CategoriesBloc>(context).add(CategoriesBack());
                        } else if (AppNavigator.hasRoute()) {
                          AppNavigator.pop();
                        }
                      },
                      child: Navigator(
                        pages: value,
                        onPopPage: (route, result) {
                          bool isPop = route.didPop(result);
                          if (isPop) AppNavigator.pop();
                          return isPop;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }

  _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text(''),
            content: const Text(
              'آیا می خواهید از حساب کاربری خود خارج شوید؟'
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
                locator<SharedPreferenceHelper>().clean();
              }, child: const Text('بله')),
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: const Text('خیر'))
            ],
          ),
        );
      },
    );
  }

  Widget _getTitle(String currentRoute) {
    switch(currentRoute) {
      case Routes.bankCardsRoute:
        return const Text('کارت های بانکی', style: TextStyle(color: Colors.white));
      case Routes.vehiclesRoute:
        return const Text('وسایل نقلیه', style: TextStyle(color: Colors.white));
      default:
        return Image.asset('assets/img/icon.png', fit: BoxFit.fill, height: 48,);
    }
  }
}
