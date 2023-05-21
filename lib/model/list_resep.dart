class Instruction {
  final String displayText;

  Instruction({
    required this.displayText,
  });

  factory Instruction.fromJson(Map<String, dynamic> json) => Instruction(
        displayText: json["display_text"] != null ? json['display_text'] : '',
      );

  Map<String, dynamic> toJson() => {
        "display_text": displayText,
      };
}

class Section {
  Section({
    required this.components,
  });

  List<Component> components;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        components: json["components"] != null
            ? List<Component>.from(
                json["components"].map((x) => Component.fromJson(x)))
            : [],
      );
}

class Component {
  Component({
    required this.rawText,
  });

  String rawText;

  factory Component.fromJson(Map<String, dynamic> json) => Component(
        rawText: json["raw_text"] != null ? json["raw_text"] : '',
      );
}

class Price {
  double harga;

  Price({required this.harga});
}

class ListResep {
  final String name;
  final String thumbnail;
  final String totalTime;
  final String description;
  final String videoUrl;
  final List<Instruction> instructions;
  final List<Section> sections;

  ListResep({
    required this.name,
    required this.thumbnail,
    required this.totalTime,
    required this.description,
    required this.videoUrl,
    required this.instructions,
    required this.sections,
  });

  factory ListResep.fromJson(dynamic json) {
    return ListResep(
      name: json['name'] as String,
      thumbnail: json['thumbnail_url'] as String,
      totalTime: json['cook_time_minutes'] != null
          ? json['total_time_minutes'].toString() + " minutes"
          : "30 minutes",
      description: json['description'] != null ? json['description'] : " ",
      videoUrl: json['original_video_url'] != null
          ? json['original_video_url']
          : 'noVideo',
      instructions: json['instructions'] != null
          ? List<Instruction>.from(
              json['instructions'].map((x) => Instruction.fromJson(x)))
          : [],
      sections: json["sections"] != null
          ? List<Section>.from(json["sections"].map((x) => Section.fromJson(x)))
          : [],
    );
  }

  static List<ListResep> resepFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ListResep.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Resep {name: $name, thumbnail: $thumbnail, totalTime: $totalTime}';
  }
}

var PriceList = [
  Price(harga: 45000),
  Price(harga: 150000),
  Price(harga: 80000),
  Price(harga: 90000),
  Price(harga: 115000),
  Price(harga: 125000),
  Price(harga: 95000),
  Price(harga: 75000),
  Price(harga: 55000),
  Price(harga: 105000),
  Price(harga: 75000),
  Price(harga: 85000),
  Price(harga: 123000),
  Price(harga: 85600),
  Price(harga: 95000),
  Price(harga: 113000),
  Price(harga: 145000),
  Price(harga: 78000),
  Price(harga: 70000),
  Price(harga: 59000),
  Price(harga: 123000),
  Price(harga: 75400),
  Price(harga: 167000),
  Price(harga: 98000),
  Price(harga: 75400),
];
