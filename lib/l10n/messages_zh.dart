// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'zh';

  static m0(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1天', other: '${howMany}天')}";

  static m1(appName) => "请告诉我们您的意见和想法。<br>您的参与会让『${appName}』越来越好！<br><br>";

  static m2(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1小时', other: '${howMany}小时')}";

  static m3(count) => "第${count}天";

  static m4(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1分', other: '${howMany}分')}";

  static m5(count) => "本次复习列表 (${count})";

  static m6(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1秒', other: '${howMany}秒')}";

  static m7(title) => "切换到${title}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "achievements": MessageLookupByLibrary.simpleMessage("成绩汇总"),
        "add": MessageLookupByLibrary.simpleMessage("添加"),
        "addToNotes": MessageLookupByLibrary.simpleMessage("加入单词本"),
        "ago": MessageLookupByLibrary.simpleMessage("前"),
        "agreement": MessageLookupByLibrary.simpleMessage("服务条款"),
        "album": MessageLookupByLibrary.simpleMessage("从相册选择"),
        "article": MessageLookupByLibrary.simpleMessage("文章"),
        "backspace": MessageLookupByLibrary.simpleMessage("退 格"),
        "cannotEmpty": MessageLookupByLibrary.simpleMessage("不能为空。"),
        "captcha": MessageLookupByLibrary.simpleMessage("验证码"),
        "captchaInvalid": MessageLookupByLibrary.simpleMessage("请输入验证码"),
        "category": MessageLookupByLibrary.simpleMessage("分类"),
        "changePassword": MessageLookupByLibrary.simpleMessage("更改密码"),
        "chineseDefinition": MessageLookupByLibrary.simpleMessage("中文解释"),
        "clearHistory": MessageLookupByLibrary.simpleMessage("清除历史"),
        "cloudBackup": MessageLookupByLibrary.simpleMessage("云备份"),
        "confirmPassword": MessageLookupByLibrary.simpleMessage("确认密码"),
        "confirmPasswordInvalid":
            MessageLookupByLibrary.simpleMessage("两次输入的密码不一致。"),
        "dayCount": m0,
        "dictionary": MessageLookupByLibrary.simpleMessage("词典"),
        "edit": MessageLookupByLibrary.simpleMessage("编辑"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("邮件地址"),
        "emailInvalid": MessageLookupByLibrary.simpleMessage("请输入合法的邮件地址"),
        "englishDefinition": MessageLookupByLibrary.simpleMessage("英文解释"),
        "exampleSentences": MessageLookupByLibrary.simpleMessage("例句"),
        "familarity": MessageLookupByLibrary.simpleMessage("熟悉度"),
        "feedback": MessageLookupByLibrary.simpleMessage("问题反馈"),
        "feedbackBody": m1,
        "finishReview": MessageLookupByLibrary.simpleMessage("恭喜，恭喜，复习完啦！"),
        "forgot": MessageLookupByLibrary.simpleMessage("忘了"),
        "forgotPassword": MessageLookupByLibrary.simpleMessage("忘记密码"),
        "guest": MessageLookupByLibrary.simpleMessage("访客"),
        "haveRest": MessageLookupByLibrary.simpleMessage("为达到最佳学习效果，请休息一下。"),
        "hour": MessageLookupByLibrary.simpleMessage("小时"),
        "hourCount": m2,
        "inputWordHere": MessageLookupByLibrary.simpleMessage("请输入单词、短语"),
        "justLearned": MessageLookupByLibrary.simpleMessage("刚学过"),
        "kk": MessageLookupByLibrary.simpleMessage("kk"),
        "know": MessageLookupByLibrary.simpleMessage("记得"),
        "lastTime": MessageLookupByLibrary.simpleMessage("上次学习"),
        "lastest30Days": MessageLookupByLibrary.simpleMessage("最近30天"),
        "learnRank0": MessageLookupByLibrary.simpleMessage("初学乍练"),
        "learnRank1": MessageLookupByLibrary.simpleMessage("略知一二"),
        "learnRank2": MessageLookupByLibrary.simpleMessage("半生不熟"),
        "learnRank3": MessageLookupByLibrary.simpleMessage("渐入佳境"),
        "learnRank4": MessageLookupByLibrary.simpleMessage("驾轻就熟"),
        "learnRank5": MessageLookupByLibrary.simpleMessage("心领神会"),
        "learnRankAll": MessageLookupByLibrary.simpleMessage("全部"),
        "learnRankEmphasis": MessageLookupByLibrary.simpleMessage("难点"),
        "learnRankIgnore": MessageLookupByLibrary.simpleMessage("忽略"),
        "learnRankUnknown": MessageLookupByLibrary.simpleMessage("未知"),
        "list": MessageLookupByLibrary.simpleMessage("列表"),
        "login": MessageLookupByLibrary.simpleMessage("登录"),
        "login_signup": MessageLookupByLibrary.simpleMessage("登录/注册"),
        "logout": MessageLookupByLibrary.simpleMessage("登出"),
        "memberDay": m3,
        "minute": MessageLookupByLibrary.simpleMessage("分"),
        "minuteCount": m4,
        "myWordList": MessageLookupByLibrary.simpleMessage("单词本"),
        "newPassword": MessageLookupByLibrary.simpleMessage("新密码"),
        "next": MessageLookupByLibrary.simpleMessage("下一个"),
        "noNeedSave": MessageLookupByLibrary.simpleMessage("没有更改，不需要保存。"),
        "noResult": MessageLookupByLibrary.simpleMessage("没有查到，可点击此处加入单词本"),
        "noReviewTask": MessageLookupByLibrary.simpleMessage("没有复习任务"),
        "oneYear": MessageLookupByLibrary.simpleMessage("最近12个月"),
        "password": MessageLookupByLibrary.simpleMessage("密码"),
        "passwordInvalid":
            MessageLookupByLibrary.simpleMessage("请输入6位以上,16位以下的密码。"),
        "phrase": MessageLookupByLibrary.simpleMessage("句子"),
        "prepareDictionary": MessageLookupByLibrary.simpleMessage("准备词典"),
        "rating": MessageLookupByLibrary.simpleMessage("评价"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "rememberAnswer": MessageLookupByLibrary.simpleMessage("问答题，请回忆答案"),
        "removeOrNot": MessageLookupByLibrary.simpleMessage("从单词本删除这个条目？"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("重置密码"),
        "resetPasswordSucceed":
            MessageLookupByLibrary.simpleMessage("重制密码成功，请重新登录。"),
        "review": MessageLookupByLibrary.simpleMessage("复习"),
        "reviewTask": MessageLookupByLibrary.simpleMessage("复习任务"),
        "reviewedXwords": m5,
        "right": MessageLookupByLibrary.simpleMessage("正确"),
        "saveOrNot": MessageLookupByLibrary.simpleMessage("是否保存？"),
        "saveSucceeded": MessageLookupByLibrary.simpleMessage("保存成功。"),
        "searchDictAddToVocab":
            MessageLookupByLibrary.simpleMessage("查询单词 - 加入单词本"),
        "secondCount": m6,
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "showAnswer": MessageLookupByLibrary.simpleMessage("显示答案"),
        "signup": MessageLookupByLibrary.simpleMessage("注册"),
        "start": MessageLookupByLibrary.simpleMessage("开始"),
        "statistics": MessageLookupByLibrary.simpleMessage("统计"),
        "submit": MessageLookupByLibrary.simpleMessage("发送"),
        "switchTo": m7,
        "takePhoto": MessageLookupByLibrary.simpleMessage("拍照"),
        "tapBlankToShowAnswer":
            MessageLookupByLibrary.simpleMessage("点击空白处，显示答案"),
        "taskCompleted": MessageLookupByLibrary.simpleMessage("复习任务都完成了。"),
        "tense": MessageLookupByLibrary.simpleMessage("时态"),
        "ticket": MessageLookupByLibrary.simpleMessage("邮件验证码"),
        "ticketInvalid": MessageLookupByLibrary.simpleMessage("请输入验证码"),
        "title": MessageLookupByLibrary.simpleMessage("单词本"),
        "todayLearn": MessageLookupByLibrary.simpleMessage("今日"),
        "totalLearn": MessageLookupByLibrary.simpleMessage("累计"),
        "unauthenticatedDesc": MessageLookupByLibrary.simpleMessage(
            "成为注册用户，学习记录将自动同步到云端，真正做到随时随地学习，即使更换设备也无需担心数据丢失。"),
        "unauthenticatedTitle":
            MessageLookupByLibrary.simpleMessage("正在以访客身份使用"),
        "username": MessageLookupByLibrary.simpleMessage("用户名"),
        "usernameInvalid": MessageLookupByLibrary.simpleMessage("用户名不合法"),
        "version": MessageLookupByLibrary.simpleMessage("版本"),
        "visitor": MessageLookupByLibrary.simpleMessage("访客"),
        "word": MessageLookupByLibrary.simpleMessage("单词"),
        "wrong": MessageLookupByLibrary.simpleMessage("错误")
      };
}
