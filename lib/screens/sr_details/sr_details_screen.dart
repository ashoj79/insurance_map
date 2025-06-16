import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insurance_map/core/app_navigator.dart';
import 'package:insurance_map/core/routes.dart';
import 'package:insurance_map/core/widget/wait_alert_dialog.dart';
import 'package:insurance_map/data/remote/model/project.dart';
import 'package:insurance_map/data/remote/model/social_responsibility.dart';

import 'bloc/sr_details_bloc.dart';

class SrDetailsScreen extends StatelessWidget {
  const SrDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SocialResponsibility sr = ModalRoute.of(context)!.settings.arguments as SocialResponsibility;

    BuildContext? alertContext;

    return BlocConsumer<SrDetailsBloc, SrDetailsState>(
      listener: (context, state) {
        if (state is SrDetailsLoading) {
          showWaitDialog(context, (p0) => alertContext = p0);
        } else if (alertContext != null) {
          Navigator.of(alertContext!).pop();
          alertContext = null;
        }
      },
      builder: (context, state) {
        List<Project> projects = state is SrDetailsShowProjects ? state.projects : [];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'توضیحات',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                  ),
                ),
                Html(data: sr.description),
                if (projects.isNotEmpty) const SizedBox(height: 16),
                if (projects.isNotEmpty)
                  const Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'پروژه ها',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
                    ),
                  ),
                if (projects.isNotEmpty) const SizedBox(height: 16),
                for (Project p in projects)
                  GestureDetector(
                    onTap: () {
                      AppNavigator.push(Routes.ProjectsDetailsRoute, args: p);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          if (p.image.isNotEmpty)
                            Image.network(
                              p.image,
                              width: 32,
                              height: 32,
                            ),
                          const SizedBox(
                            width: 16,
                          ),
                          Text(
                            p.title,
                            style: const TextStyle(color: Colors.black),
                          )
                        ],
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
}
