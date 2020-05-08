class LevelPair {
  int start;
  int end;
}

enum ReviewOrder { EasyFirst, HardFirst, Random }

class MemConst {
  static const int MAX_STUDY_LEVEL = 15;
  static const int IGNORE_LEVEL = -1;
  static const int DIFFICULTY_THRESHOLD_VALUE = 3;

  static const int LEARN_RANK_ALL = 255;
  static const int LEARN_RANK_0 = 0;
  static const int LEARN_RANK_1 = 1;
  static const int LEARN_RANK_2 = 2;
  static const int LEARN_RANK_3 = 3;
  static const int LEARN_RANK_4 = 4;

  static const int LEARN_RANK_IGNORE = -1;
  static const int LEARN_RANK_EMPHASIS = -2;
  static const int LEARN_RANK_UNKNOWN = 30;

  static int rankOfLevel(int level) {
    var ret = LEARN_RANK_UNKNOWN;
    switch (level) {
      case 0:
        ret = LEARN_RANK_0;
        break;
      case 1:
      case 2:
      case 3:
      case 4:
        ret = LEARN_RANK_1;
        break;
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        ret = LEARN_RANK_2;
        break;
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
        ret = LEARN_RANK_3;
        break;
      case 15:
        ret = LEARN_RANK_4;
        break;
    }
    return ret;
  }

  static LevelPair levelOfRank(int rank) {
    var ret = LevelPair();
    switch (rank) {
      case LEARN_RANK_0:
        ret.start = 0;
        ret.end = 0;
        break;
      case LEARN_RANK_1:
        ret.start = 1;
        ret.end = 4;
        break;
      case LEARN_RANK_2:
        ret.start = 5;
        ret.end = 9;
        break;
      case LEARN_RANK_3:
        ret.start = 10;
        ret.end = 14;
        break;
      case LEARN_RANK_4:
        ret.start = 15;
        ret.end = 15;
        break;
      case LEARN_RANK_IGNORE:
        ret.start = -1;
        ret.end = -1;
        break;
    }
    return ret;
  }

  static String rankName(int rank) {
    var ret = '';
    switch (rank) {
      case LEARN_RANK_0:
        ret = '初学乍练';
        break;
      case LEARN_RANK_1:
        ret = '略知一二';
        break;
      case LEARN_RANK_2:
        ret = '半生不熟';
        break;
      case LEARN_RANK_3:
        ret = '渐入佳境';
        break;
      case LEARN_RANK_4:
        ret = '心领神会';
        break;
      case LEARN_RANK_ALL:
        ret = '全部';
        break;
      case LEARN_RANK_EMPHASIS:
        ret = '难点';
        break;
      case IGNORE_LEVEL:
        ret = '忽略';
        break;
      default:
        ret = '' + rank.toString();
        break;
    }
    return ret;
  }

  static final rankAllColor = 0xffdedede;
  static final rankKnownColor = 0xff8dda42;
  static final rankFinishedColor = 0xffc2db4c;
  static final rankAlmostColor = 0xffefc55e;
  static final rankLearningColor = 0xff80a0f1;
  static final rankRememberColor = 0xffC8C8C8;
  static final rankEmphasisColor = 0xfff18080;
  static final rankIgnoreColor = 0xffcccccc;
  static final rankUnlearnColor = 0xffC8C8C8;

  static int color(int rank) {
    var ret;
    switch (rank) {
      case LEARN_RANK_ALL:
        ret = rankAllColor;
        break;
      case LEARN_RANK_EMPHASIS:
        ret = rankEmphasisColor;
        break;
      case LEARN_RANK_IGNORE:
        ret = rankIgnoreColor;
        break;
      case LEARN_RANK_4:
        ret = rankKnownColor;
        break;
      case LEARN_RANK_3:
        ret = rankAlmostColor;
        break;
      case LEARN_RANK_2:
        ret = rankLearningColor;
        break;
      case LEARN_RANK_1:
        ret = rankRememberColor;
        break;
      case LEARN_RANK_0:
        ret = rankUnlearnColor;
        break;
      default:
        ret = rankAllColor;
        break;
    }
    return ret;
  }
}
