class Mem {
  int id = 0;
  String mid = '';
  String krid = '';
  int level = -1;
  int ts = 0;
  int df = 0;
  int kbase = 1;
  int nrt = 0;
  int sync = 0;
  int failed = 0;
  int offset_failed = 0;

  Mem();

  Mem.fromMap(Map<String, dynamic> v) {
    id = v['id'];
    mid = v['_id'];
    krid = v['krid'];
    level = v['level'];
    ts = v['ts'];
    df = v['df'];
    kbase = v['kbase'];
    nrt = v['nrt'];
    sync = v['sync'];
    failed = v['failed'];
    offset_failed = v['offset_failed'];
  }

  static List<String> numberFields() {
    return [
      "id",
      "level",
      "df",
      "ts",
      "nrt",
      'sync',
      'failed',
      'kbase',
      'offset_failed'
    ];
  }
}
