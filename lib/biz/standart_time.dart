class StandardTime {
  StandardTime._();
  static final StandardTime instance = StandardTime._();

  int get now {
    var v = DateTime.now().millisecondsSinceEpoch;
    return v;
  }
}
