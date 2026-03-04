import 'package:flutter/material.dart';

import '../models/category_model.dart';

final List<CategoryModel> defaultCategories = [
  CategoryModel(
    id: 'food',
    name: 'Yemek',
    colorHex: '#FF6B6B',
    iconCode: Icons.restaurant.codePoint,
  ),
  CategoryModel(
    id: 'transport',
    name: 'Ulaşım',
    colorHex: '#4ECDC4',
    iconCode: Icons.directions_car.codePoint,
  ),
  CategoryModel(
    id: 'entertainment',
    name: 'Eğlence',
    colorHex: '#45B7D1',
    iconCode: Icons.movie.codePoint,
  ),
  CategoryModel(
    id: 'health',
    name: 'Sağlık',
    colorHex: '#96CEB4',
    iconCode: Icons.medical_services.codePoint,
  ),
  CategoryModel(
    id: 'shopping',
    name: 'Alışveriş',
    colorHex: '#FFEAA7',
    iconCode: Icons.shopping_bag.codePoint,
  ),
  CategoryModel(
    id: 'bills',
    name: 'Faturalar',
    colorHex: '#DDA0DD',
    iconCode: Icons.receipt.codePoint,
  ),
  CategoryModel(
    id: 'other',
    name: 'Diğer',
    colorHex: '#98D8C8',
    iconCode: Icons.category.codePoint,
  ),
];

