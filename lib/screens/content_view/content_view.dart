import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:insurance_map/screens/content_view/bloc/content_view_bloc.dart';

class ContentViewScreen extends StatelessWidget {
  const ContentViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentViewBloc, ContentViewState>(
      builder: (context, state) {
        if (state is! ContentViewShow) {
          return SizedBox();
        }

        return SingleChildScrollView(child: Html(data: state.html));
      },
    );
  }
}