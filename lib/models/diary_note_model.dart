

class DiaryNoteModel {
  final String title;
  final String body;
  bool expanded;

  final String itemId;
  final String itemName;
  final String itemImageUrl;
  final String itemDescription;
  final String itemPronunciation;

  DiaryNoteModel({
    required this.title,
    required this.body,
    this.expanded = false,
    this.itemId = '',
    this.itemName = '',
    this.itemImageUrl = '',
    this.itemDescription = '',
    this.itemPronunciation = '',
  });

  factory DiaryNoteModel.fromFirestore(Map<String, dynamic> data) {
    return DiaryNoteModel (
      title: data['notesTitle'] ?? '',
      body: data['notesDescription'] ?? '',
      itemId: data['item_id'] ?? '',
      itemName: data['item_name'] ?? '',
      itemImageUrl: data['item_image_url'] ?? '',
      itemDescription: data['item_description'] ?? '',
      itemPronunciation: data['item_pronunciation'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'notesTitle': title,
      'notesDescription': body,
      'item_id': itemId,
      'item_name': itemName,
      'item_image_url': itemImageUrl,
      'item_description': itemDescription,
      'item_pronunciation': itemPronunciation,
    };
  }
}