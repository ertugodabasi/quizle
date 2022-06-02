class StreamError {
  static const errorCodes = {
    1: 'Kullanıcı adı veya oda ismi doğru değil',
    2: 'Aynı odada aynı isimli kullanıcı bulunamaz',
    3: 'Oda kapasitesi aşıldı',
    4: 'Böyle bi oda yoh',
    5: 'Bu isimle bir oda daha önce oluşturuldu'
  };
  final int code;
  final String title;

  StreamError(this.code, this.title);

  factory StreamError.fromData(dynamic data) {
    final code = data['code'];
    final title = data['title'];
    return StreamError(code, title);
  }
}
