class Candidate {
  String question;
  String answer;

  Candidate(this.question, this.answer);

  @override
  String toString() {
    return '''
    question: $question
    answer: $answer
    ''';
  }
}
