class Faq {
  final int id;
  final int order;
  final String question;
  final String answer;

  const Faq({this.id, this.order, this.question, this.answer});

  static Faq fromJson(dynamic json) {
    return Faq(
      id: json['id'] as int,
      order: json['order'] as int,
      answer: json['content'] as String,
      question: json['title'] as String,
    );
  }
}
