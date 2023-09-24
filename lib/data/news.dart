import 'package:flutter/material.dart';

class News {
  final String title;
  final String link;

  const News({required this.title, required this.link});
}

List<News> choices = const <News>[
  News(
      title: "Sport",
      link:
          "https://images.pexels.com/photos/2996261/pexels-photo-2996261.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  News(
      title: "Politik",
      link:
          "https://images.pexels.com/photos/1586034/pexels-photo-1586034.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  News(
      title: "Kriminal",
      link:
          "https://images.pexels.com/photos/7299483/pexels-photo-7299483.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  News(
      title: "Business",
      link:
          "https://images.pexels.com/photos/1737957/pexels-photo-1737957.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  News(
      title: "Entertaiment",
      link:
          "https://images.pexels.com/photos/1190297/pexels-photo-1190297.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  News(
      title: "Travel",
      link:
          "https://images.pexels.com/photos/17636489/pexels-photo-17636489/free-photo-of-pemandangan-pria-hutan-hiking.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  News(
      title: "Health",
      link:
          "https://images.pexels.com/photos/4099235/pexels-photo-4099235.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
  News(
      title: "Style",
      link:
          "https://images.pexels.com/photos/1043473/pexels-photo-1043473.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
];
