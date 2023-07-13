import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models.dart';

enum TableStatus { idle, loading, ready, error }

enum ItemType {
  beer,
  coffee,
  nation,
  dessert,
  none;

  String get asString => name;

  List<String> get columns => this == coffee
      ? ["Nome", "Origem", "Tipo"]
      : this == beer
          ? ["Nome", "Estilo", "IBU"]
          : this == nation
              ? ["Nome", "Capital", "Idioma", "Esporte"]
              : this == dessert
                  ? ["Nome", "Cobertura", "Aroma"]
                  : [];

  List<String> get properties => this == coffee
      ? ["blend_name", "origin", "variety"]
      : this == beer
          ? ["name", "style", "ibu"]
          : this == nation
              ? ["nationality", "capital", "language", "national_sport"]
              : this == dessert
                  ? ["variety", "topping", "flavor"]
                  : [];
}

class DataService {
  static const maxNItems = 15;
  static const minNItems = 3;
  static const defaultNItems = 7;

  int _numberOfItems = defaultNItems;

  int get numberOfItems => _numberOfItems;

  set numberOfItems(int value) {
    _numberOfItems = value < 0
        ? minNItems
        : value > maxNItems
            ? maxNItems
            : value;
    carregar(tableStateNotifier.value['itemType'].index);
  }

  final ValueNotifier<Map<String, dynamic>> tableStateNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'dataObjects': [],
    'itemType': ItemType.none
  });

  void carregar(index) {
    final params = [
      ItemType.coffee,
      ItemType.beer,
      ItemType.nation,
      ItemType.dessert
    ];

    loadByType(params[index]);
  }

  void sortCurrentState(String property) {
    var state = Map<String, dynamic>.from(tableStateNotifier.value);
    var objects = List<dynamic>.from(state['dataObjects']);
    var ascending = state['sortCriteria'] != property || !state['ascending'];

    objects.sort((a, b) {
      var aValue = a.getPropertyValue(property);
      var bValue = b.getPropertyValue(property);

      if (aValue is String && bValue is String) {
        return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
      } else if (aValue is int && bValue is int) {
        return ascending ? aValue - bValue : bValue - aValue;
      } else {
        return 0;
      }
    });

    sendSortedState(objects, property, ascending);
  }

  Uri buildUri(ItemType type) {
    return Uri(
      scheme: 'https',
      host: 'random-data-api.com',
      path: 'api/${type.asString}/random_${type.asString}',
      queryParameters: {'size': '$_numberOfItems'},
    );
  }

  Future<List<dynamic>> apiAccess(Uri uri) async {
    var jsonString = await http.read(uri);
    var json = jsonDecode(jsonString);

    return json;
  }

  List<dynamic> convertToObjects(ItemType type, List<dynamic> json) {
    switch (type) {
      case ItemType.beer:
        return json.map((beerJson) => Beer.fromJson(beerJson)).toList();
      case ItemType.coffee:
        return json.map((coffeeJson) => Coffee.fromJson(coffeeJson)).toList();
      case ItemType.nation:
        return json.map((nationJson) => Nation.fromJson(nationJson)).toList();
      case ItemType.dessert:
        return json
            .map((dessertJson) => Dessert.fromJson(dessertJson))
            .toList();
      default:
        return [];
    }
  }

  void sendSortedState(List sortedObjects, String property, bool ascending) {
    var state = Map<String, dynamic>.from(tableStateNotifier.value);

    state['dataObjects'] = sortedObjects;
    state['sortCriteria'] = property;
    state['ascending'] = ascending;

    tableStateNotifier.value = state;
  }

  void sendLoadingState(ItemType type) {
    tableStateNotifier.value = {
      'status': TableStatus.loading,
      'dataObjects': [],
      'itemType': type
    };
  }

  void sendReadyState(ItemType type, List<dynamic> objects) {
    tableStateNotifier.value = {
      'status': TableStatus.ready,
      'dataObjects': objects,
      'itemType': type,
      'propertyNames': type.properties,
      'columnNames': type.columns,
    };
  }

  bool onGoingRequest() =>
      tableStateNotifier.value['status'] == TableStatus.loading;

  bool changeRequiredItemType(ItemType type) =>
      tableStateNotifier.value['itemType'] != type;

  void loadByType(ItemType type) async {
    if (onGoingRequest()) return;

    if (changeRequiredItemType(type)) {
      sendLoadingState(type);
    }

    var uri = buildUri(type);
    var json = await apiAccess(uri);
    var objects = convertToObjects(type, json);

    sendReadyState(type, objects);
  }
}

final dataService = DataService();
