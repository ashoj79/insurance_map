import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insurance_map/data/remote/model/project.dart';

class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Project project = ModalRoute.of(context)!.settings.arguments as Project;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: [
          Image.network(project.image, height: 200,),
          const SizedBox(height: 16),
          Text(
            project.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          const SizedBox(height: 16),
          Html(data: project.section)
        ],
      ),
    );
  }
}
