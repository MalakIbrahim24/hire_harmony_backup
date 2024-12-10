import '../models/category.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String price;
  final String imgUrl;
  final Category category;

  Product(
    {
      required this.id,
      required this.name,
      required this.description,
      required this.price,
      required this.imgUrl,
      required this.category
      
    });
      
}
List<Product> favProducts=[];
List<Product> dummyProducts = [
  Product(
      id: '1',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lomre lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lore lomre lomre lorem lorem lorem  lorem lore lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem loemr lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[1]),
      Product(
      id: '2',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[2]),
      Product(
      id: '3',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[1]),
      Product(
      id: '4',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[2]),
      Product(
      id: '5',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[4]),
      Product(
      id: '6',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[3]),
       Product(
      id: '6',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[1]),
       Product(
      id: '6',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[3]),
       Product(
      id: '6',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[2]),
       Product(
      id: '6',
      name: 'Beef Burger',
      description: 'lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lorem lroem',
      price: '30',
      imgUrl: 'https://i.imgur.com/vB1kmiF.png',
      category: Category.dummyCategories[2]),

];
