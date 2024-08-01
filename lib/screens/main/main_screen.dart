import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/core/widget/show_snackbar.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/local/shared_preference_helper.dart';
import 'package:insurance_map/data/local/signup_types.dart';
import 'package:insurance_map/data/remote/model/category.dart';
import 'package:insurance_map/data/remote/model/insurance_company.dart';
import 'package:insurance_map/data/remote/model/slider_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/screens/cards_and_vehicles/bloc/c_a_v_bloc.dart';
import 'package:insurance_map/screens/companies/bloc/companies_bloc.dart';
import 'package:insurance_map/screens/main/bloc/main_bloc.dart';
import 'package:insurance_map/utils/di.dart';
import 'package:insurance_map/utils/location_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<SliderModel> sliders = [];
  final List<Category> categories = [];
  final List<InsuranceCompany> companies = [];

  BuildContext? _alertContext;

  final CarouselController _controller = CarouselController();

  int sliderIndex = 0;
  double itemWidth = 0, itemHeight = 80;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<MainBloc>(context).add(MainGetData());

    LocationService.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Size screenSize = MediaQuery.of(context).size;
    itemWidth = (screenSize.width - 72) / 4;
    double navItemsTextSize = screenSize.width < 350 ? 11 : 14;

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is MainLoading) {
          showWaitDialog(context, (p0) => _alertContext = p0);
        } else if (_alertContext != null) {
          Navigator.of(_alertContext!).pop();
          _alertContext = null;
        }

        if (state is MainError) showSnackBar(context, state.message);
      },
      builder: (context, state) {
        if (state is MainDataReceived) {
          sliders.clear();
          sliders.addAll(state.sliders);

          categories.clear();
          categories.addAll(state.categories);

          companies.clear();
          companies.addAll(state.companies);
        }

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.primaryColor,
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            decoration: const BoxDecoration(color: Color(0xFFF3F7FA), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    top: 32,
                    bottom: 120
                  ),
                  child: Column(
                    children: [
                      PreferenceBuilder<String>(
                        preference: locator<SharedPreferenceHelper>().getTopMessage(),
                        builder: (context, value) {
                          if (value.isEmpty) return const SizedBox();

                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                              color: Colors.red.withOpacity(0.4)
                            ),
                            margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              textDirection: TextDirection.rtl,
                              children: [
                                IconButton(onPressed: (){
                                  locator<SharedPreferenceHelper>().saveTopMessage('');
                                }, icon: const Icon(Icons.close)),
                                const SizedBox(width: 8),
                                Expanded(child: Text(value))
                              ],
                            ),
                          );
                        }
                      ),
                      SizedBox(
                        height: 200,
                        child: Stack(
                          children: [
                            CarouselSlider(
                              carouselController: _controller,
                              options: CarouselOptions(
                                height: 200,
                                autoPlay: true,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    sliderIndex = index;
                                  });
                                },
                              ),
                              items: sliders.map<Widget>((e) {
                                return Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                    margin: const EdgeInsets.symmetric(horizontal: 24),
                                    clipBehavior: Clip.antiAlias,
                                    child: Image.network(
                                      e.logo,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                    ));
                              }).toList(),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: AnimatedSmoothIndicator(
                                  activeIndex: sliderIndex,
                                  count: sliders.length,
                                  effect: const ScrollingDotsEffect(activeDotColor: Colors.white, dotColor: Colors.grey, dotHeight: 10, dotWidth: 10),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (categories.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16), color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey[300]!, spreadRadius: 1.3, offset: const Offset(0, 0.8))]),
                          width: double.infinity,
                          margin: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    const Text(
                                      'فروشگاه های طرف قرارداد',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    GestureDetector(
                                      onTap: () {
                                        AppNavigator.push(Routes.categoriesRoute, args: '');
                                      },
                                      child: const Text('نمایش همه'),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey[200],
                                height: 2,
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: SizedBox(
                                  height: categories.length > 4 ? 200 : 100,
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: itemWidth / itemHeight),
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (categories[index].isHaveChild) {
                                            AppNavigator.push(Routes.categoriesRoute, args: categories[index].id);
                                          } else {
                                            AppNavigator.push(Routes.mapRoute, args: {'type': 'vendor', 'id': categories[index].id});
                                          }
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!, width: 1.5), borderRadius: BorderRadius.circular(12)),
                                                padding: const EdgeInsets.all(4),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.network(
                                                  categories[index].logo,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              categories[index].title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      if (companies.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16), color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey[300]!, spreadRadius: 1.3, offset: const Offset(0, 0.8))]),
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    const Text(
                                      'بیمه های طرف قرارداد',
                                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<CompaniesBloc>(context).add(CompaniesGetData());
                                        AppNavigator.push(Routes.companiesRoute);
                                      },
                                      child: const Text('نمایش همه'),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey[200],
                                height: 2,
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: SizedBox(
                                  height: companies.length > 4 ? 200 : 100,
                                  child: GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: itemWidth / itemHeight),
                                    itemCount: companies.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          AppNavigator.push(Routes.mapRoute, args: {'type': 'insurance', 'id': companies[index].id});
                                        },
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!, width: 1.5), borderRadius: BorderRadius.circular(12)),
                                                padding: const EdgeInsets.all(4),
                                                clipBehavior: Clip.antiAlias,
                                                child: Image.network(
                                                  companies[index].logo,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              companies[index].name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white,
                    child: PreferenceBuilder<String>(
                      preference: locator<SharedPreferenceHelper>().getName(),
                      builder: (context, value) {
                        return Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                AppNavigator.push(Routes.SRRoute);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.volunteer_activism,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text('مسئولیت اجتماعی', style: TextStyle(fontSize: navItemsTextSize, fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (locator<SharedPreferenceHelper>().getToken() == ''){
                                  showSnackBar(context, 'لطفا وارد اکانت خود شوید');
                                } else {
                                  AppNavigator.push(Routes.insuranceRequestRoute);
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.yellow[800], borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.credit_card,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text('صدور بیمه', style: TextStyle(fontSize: navItemsTextSize, fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (locator<SharedPreferenceHelper>().getToken() == ''){
                                  showSnackBar(context, 'لطفا وارد اکانت خود شوید');
                                } else {
                                  BlocProvider.of<CAVBloc>(context).add(CAVGetData());
                                  AppNavigator.push(Routes.cardsAndVehiclesRoute);
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.payments_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text('کارت ها و وسایل نقلیه', style: TextStyle(fontSize: navItemsTextSize, fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                            if (value.isEmpty)
                              InkWell(
                                onTap: () {
                                  _showAlertDialog();
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text('ثبت نام', style: TextStyle(fontSize: navItemsTextSize, fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),

                            if (value.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  AppNavigator.push(Routes.categoriesRoute, args: '');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.store,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text('فروشگاه ها', style: TextStyle(fontSize: navItemsTextSize, fontWeight: FontWeight.w600))
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('ثبت نام به عنوان:'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    AppNavigator.push(Routes.signupRoute, args: SignupTypes.representatives);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('نماینده بیمه'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    AppNavigator.push(Routes.signupRoute, args: SignupTypes.businesses);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('کسب و کار'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    AppNavigator.push(Routes.signupRoute, args: SignupTypes.vehicles);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('صاحبان وسیله نقلیه',),
                  ),
                ),
              ],
            )
          ),
        );
      },
    );
  }
}
