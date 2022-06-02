class StreamNotification {
  final String title;
  final String description;

  StreamNotification(this.title, this.description);

  factory StreamNotification.fromData(dynamic data) {
    final title = data['title'];
    final description = data['description'];
    return StreamNotification(title, description);
  }
}
