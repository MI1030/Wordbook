class Kr {
  int id = 0;
  String mid = '';
  int kbase = 1;
  int sync = 0;
  String question = '';
  String samples = '';
  String answer = '';
  String image = '';

  Kr({this.question, this.kbase});

  Kr.fromMap(Map<String, dynamic> v) {
    id = v['id'];
    mid = v['_id'];
    kbase = v['kbase'];
    sync = v['sync'];
    question = v['question'];
    samples = v['samples'];
    answer = v['answer'];
    image = v['image'];
  }

  static List<String> numberFields() {
    return [
      "id",
      "ts",
      'sync',
      'kbase',
    ];
  }
}
