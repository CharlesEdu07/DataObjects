class Beer {
  String name, style, ibu;

  Beer({this.name = '', this.style = '', this.ibu = ''});

  getPropertyValue(String propName) {
    switch (propName) {
      case 'name':
        return name;
      case 'style':
        return style;
      case 'ibu':
        return ibu;
      default:
        return '';
    }
  }

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      name: json['name'] ?? '',
      style: json['style'] ?? '',
      ibu: json['ibu'] ?? '',
    );
  }
}

class Coffee {
  String blendName, origin, variety;

  Coffee({this.blendName = '', this.origin = '', this.variety = ''});

  getPropertyValue(String propName) {
    switch (propName) {
      case 'blend_name':
        return blendName;
      case 'origin':
        return origin;
      case 'variety':
        return variety;
      default:
        return '';
    }
  }

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      blendName: json['blend_name'] ?? '',
      origin: json['origin'] ?? '',
      variety: json['variety'] ?? '',
    );
  }
}

class Nation {
  String nationality, capital, language, nationalSport;

  Nation({
    this.nationality = '',
    this.capital = '',
    this.language = '',
    this.nationalSport = '',
  });

  getPropertyValue(String propName) {
    switch (propName) {
      case 'nationality':
        return nationality;
      case 'capital':
        return capital;
      case 'language':
        return language;
      case 'national_sport':
        return nationalSport;
      default:
        return '';
    }
  }

  factory Nation.fromJson(Map<String, dynamic> json) {
    return Nation(
      nationality: json['nationality'] ?? '',
      capital: json['capital'] ?? '',
      language: json['language'] ?? '',
      nationalSport: json['national_sport'] ?? '',
    );
  }
}

class Dessert {
  String variety, topping, flavor;

  Dessert({this.variety = '', this.topping = '', this.flavor = ''});

  getPropertyValue(String propName) {
    switch (propName) {
      case 'variety':
        return variety;
      case 'topping':
        return topping;
      case 'flavor':
        return flavor;
      default:
        return '';
    }
  }

  factory Dessert.fromJson(Map<String, dynamic> json) {
    return Dessert(
      variety: json['variety'] ?? '',
      topping: json['topping'] ?? '',
      flavor: json['flavor'] ?? '',
    );
  }
}
