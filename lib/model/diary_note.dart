class DiaryNote {
  String title;
  String body;
  bool expanded;

  DiaryNote({
    required this.title,
    required this.body,
    this.expanded = false,
  });
}