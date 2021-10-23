import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Favourites extends Equatable {
  final List<String> favourites;

  Favourites({@required this.favourites});

  @override
  List<Object> get props => [favourites];
}
