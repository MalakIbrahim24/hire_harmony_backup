import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hire_harmony/models/announcement_model.dart';
import 'package:hire_harmony/utils/app_colors.dart';

class CustomCarouselIndicator extends StatefulWidget {
  const CustomCarouselIndicator({super.key});

  @override
  State<CustomCarouselIndicator> createState() =>
      _CustomCarouselIndicatorState();
}

class _CustomCarouselIndicatorState extends State<CustomCarouselIndicator> {
  late CarouselSliderController _controller;
  int _current = 0;
  @override
  void initState() {
    super.initState();
    _controller = CarouselSliderController();
  }

  final List<Widget> imageSliders = dummyAnnouncements
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: CachedNetworkImage(
                  imageUrl: item.imgUrl, fit: BoxFit.cover, width: 1000.0),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dummyAnnouncements.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 30.0,
                height: 3.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? AppColors().orange
                            : AppColors().navy)
                        .withOpacity(_current == entry.key ? 0.9 : 0.3)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
