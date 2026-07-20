

/*



lib/
│
├── models/
│   └── coffee_item.dart             <-- 1. Data Models (The Blueprints)
│
├── pages/
│   └── diary_pages/
│       └── diary_glossary_page.dart <-- 2. Screens (The Canvas)
│
└── widgets/
    └── coffee_glossary_card.dart    <-- 3. UI Components (The Paintbrushes)



*/

class CoffeeGlossaryItem {
  final String englishName;
  final String vietName;
  final String pronunciation;
  final String description;
  final String imagePath;

  CoffeeGlossaryItem({
    required this.englishName,
    required this.vietName,
    required this.pronunciation,
    required this.description,
    required this.imagePath,
  });

  factory CoffeeGlossaryItem.fromJson(Map<String, dynamic> json) {
    return CoffeeGlossaryItem(
      englishName: json["englishName"] ?? "",
      vietName: json["vietName"] ?? "",
      pronunciation: json["pronunciation"] ?? "",
      description: json["description"] ?? "",
      imagePath: json["imagePath"] ?? "",
    );
  }

  factory CoffeeGlossaryItem.fromFirestore(
      Map<String, dynamic> data) {
    return CoffeeGlossaryItem(
      englishName: data["english_name"] ?? "",
      vietName: data["item_name"] ?? "",
      pronunciation: data["item_pronunciation"] ?? "",
      description: data["item_description"] ?? "",
      imagePath: data["item_image_url"] ?? "",
    );
  }
}