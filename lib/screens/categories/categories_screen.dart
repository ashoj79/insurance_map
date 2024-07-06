import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insurance_map/data/remote/model/category.dart';
import 'package:insurance_map/screens/categories/bloc/categories_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;
    BlocProvider.of<CategoriesBloc>(context).add(CategoriesFetch(id));
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        List<Category> categories = state is CategoriesShow ? state.categories : [];

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFF3F7FA)
          ),
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (categories[index].isHaveChild){
                    BlocProvider.of<CategoriesBloc>(context).add(CategoriesFetch(categories[index].id));
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      if (categories[index].logo.isNotEmpty) Image.network(categories[index].logo, width: 32, height: 32,),
                      const SizedBox(width: 16,),
                      Text(categories[index].title, style: const TextStyle(color: Colors.black),)
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
