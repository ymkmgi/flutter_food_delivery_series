import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/basket/basket_bloc.dart';
import '../../models/models.dart';
import '../../widgets/widgets.dart';


class RestaurantDetailsScreen extends StatelessWidget {
  static const String routeName = '/restaurant-details';

  static Route route({required Restaurant restaurant}) {
    return MaterialPageRoute(
      builder: (_) => RestaurantDetailsScreen(restaurant: restaurant),
      settings: RouteSettings(name: routeName),
    );
  }

  final Restaurant restaurant;

  const RestaurantDetailsScreen({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50), backgroundColor: Theme.of(context).colorScheme.secondary,
                shape: RoundedRectangleBorder(),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/basket');
              },
              child: Text('Basket'),
            ),
          ],
        )),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom:
                      Radius.elliptical(MediaQuery.of(context).size.width, 50),
                ),
                image: DecorationImage(
                    image: NetworkImage(
                      restaurant.imageUrl,
                    ),
                    fit: BoxFit.cover),
              ),
            ),
            RestaurantInformation(restaurant: restaurant),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: restaurant.categories.length,
              itemBuilder: (context, index) {
                return _buildproducts(restaurant, context, index);
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildproducts(
    Restaurant restaurant,
    BuildContext context,
    int index,
  ) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(
            restaurant.categories[index].name,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
        Column(
          children: restaurant.products
              .where((product) =>
                  product.category == restaurant.categories[index].name)
              .map(
                (product) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          product.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        subtitle: Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        trailing: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${product.price}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            BlocBuilder<BasketBloc, BasketState>(
                              builder: (context, state) {
                                return IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () {
                                    context.read<BasketBloc>()
                                      ..add(AddProduct(product));
                                  },
                                );
                              },
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
