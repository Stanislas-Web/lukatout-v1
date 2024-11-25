class Answer {
  String context;
  String id;
  String type;
  int answerId;
  String answer;
  bool itTrue;
  String question;
  List<dynamic> games; // Si games est une liste d'objets dynamiques
  int status;
  DateTime createdAt;
  String createdBy;

  Answer({
    required this.context,
    required this.id,
    required this.type,
    required this.answerId,
    required this.answer,
    required this.itTrue,
    required this.question,
    required this.games, // Mettez le type correct ici
    required this.status,
    required this.createdAt,
    required this.createdBy,
  });
}
