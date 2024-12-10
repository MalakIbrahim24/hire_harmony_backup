// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BestWorkerList {
  final String id;
  final String title;
  final String imgUrl;
  final VoidCallback onTap;

  BestWorkerList({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.onTap,
  });

  static List<BestWorkerList> dummyBestWorker = [
    /*
    BestWorkerList(id: '1', title: 'yahya', imgUrl:'https://i.pinimg.com/736x/0a/6d/fa/0a6dfadd10cd91972a20b6e03e7f6ee6.jpg', onTap:(){}),
    BestWorkerList(id: '2', title: 'Alsenwar', imgUrl:'https://i.pinimg.com/736x/58/53/79/585379576e1c1d3e0685348f5b18b186.jpg', onTap:(){}),
    BestWorkerList(id: '3', title: 'Ahmad', imgUrl:'https://i.pinimg.com/236x/1c/c9/c9/1cc9c96492f62258e0e17b3ac8876d8f.jpg', onTap:(){}),
    */
    BestWorkerList(
        id: '4',
        title: 'yasen',
        imgUrl: 'lib/assets/images/mechanic.png',
        onTap: () {}),
    BestWorkerList(
        id: '5',
        title: 'ismael',
        imgUrl: 'lib/assets/images/chef.png',
        onTap: () {}),
    BestWorkerList(
        id: '6',
        title: 'hanya',
        imgUrl: 'lib/assets/images/growth.png',
        onTap: () {}),
    BestWorkerList(
        id: '4',
        title: 'yasen',
        imgUrl: 'lib/assets/images/mechanic.png',
        onTap: () {}),
    BestWorkerList(
        id: '5',
        title: 'ismael',
        imgUrl: 'lib/assets/images/chef.png',
        onTap: () {}),
    BestWorkerList(
        id: '6',
        title: 'hanya',
        imgUrl: 'lib/assets/images/growth.png',
        onTap: () {}),
  ];
}
