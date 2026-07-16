

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
  final String imagePath;
  final String englishName; 
  final String vietName;
  final String pronunciation; 
  final String description;

  CoffeeGlossaryItem({
    required this.englishName,
    required this.vietName,
    required this.imagePath,
    required this.description,
    required this.pronunciation,
  });

  factory CoffeeGlossaryItem.fromJson(Map<String, dynamic> json) {
    return CoffeeGlossaryItem(
      englishName: json['englishName'],
      vietName: json['vietName'],
      imagePath: json['imagePath'],
      description: json['description'],
      pronunciation: json['pronunciation'],
    );
  }
}