import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hire_harmony/models/product.dart';
import 'package:hire_harmony/utils/app_colors.dart';
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    if (favProducts.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors().white,
        body: Center(
          child: Text('No Favorite Products!',
              style: GoogleFonts.montserratAlternates(
                color: AppColors().navy,
              )),
        ),
      );
    }
    return ListView.builder(
      itemCount: favProducts.length,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(
                        '/product-details',
                        arguments: favProducts[index],
                      )
                      .then((value) => setState(() {}));
                },
                leading: Image.network(
                  favProducts[index].imgUrl,
                  height: 100,
                  width: 70,
                  fit: BoxFit.fill,
                ),
                title: Text(favProducts[index].name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        )),
                subtitle: Text(
                  '${favProducts[index].category.title} - \$${favProducts[index].price}',
                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      favProducts.remove(favProducts[index]);
                    });
                  },
                  icon: const Icon(Icons.favorite),
                  color: Theme.of(context).primaryColor,
                )),
          ),
        );
      },
    );
  }
}
