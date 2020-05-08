import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './l10n/messages_all.dart';

const List<String> MyLanguages = ['zh']; //'en'

class MemofLocalizations {
  static Future<MemofLocalizations> load(Locale locale) async {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    await initializeMessages(localeName);
    Intl.defaultLocale = localeName;
    return MemofLocalizations();
  }

  static MemofLocalizations of(BuildContext context) {
    return Localizations.of<MemofLocalizations>(context, MemofLocalizations);
  }

  String get title => Intl.message('单词本', name: 'title', desc: 'App title');

  String get start =>
      Intl.message('Start', name: 'start', desc: 'Start review');

  String get reviewTask =>
      Intl.message('Review Task', name: 'reviewTask', desc: '');

  String memberDay(count) =>
      Intl.message("the $count day", name: 'memberDay', args: [count]);

  String reviewedXwords(count) => Intl.message("Reviewd $count words",
      name: 'reviewedXwords', args: [count]);

  String get add => Intl.message('add', name: 'add');

  String get dictionary => Intl.message('dictionary', name: 'dictionary');

  String get guest => Intl.message('guest', name: 'guest');

  String get review => Intl.message('review', name: 'review');

  String get myWordList => Intl.message('myWordList', name: 'myWordList');

  String get word => Intl.message('Word', name: 'word');
  String get phrase => Intl.message('Phrase', name: 'phrase');
  String get article => Intl.message('Article', name: 'article');

  String get todayLearn => Intl.message('todayLearn', name: 'todayLearn');

  String get totalLearn => Intl.message('totalLearn', name: 'totalLearn');

  String get chineseDefinition =>
      Intl.message('Chinese Definition', name: 'chineseDefinition');

  String get englishDefinition =>
      Intl.message('English Definition', name: 'englishDefinition');

  String get tense => Intl.message('Tense', name: 'tense');

  String get exampleSentences =>
      Intl.message('Example Sentences', name: 'exampleSentences');

  String get addToNotes => Intl.message('Add to Notes', name: 'addToNotes');

  String get learnRank0 => Intl.message('Unlearn', name: 'learnRank0');

  String get learnRank1 => Intl.message('Learning', name: 'learnRank1');

  String get learnRank2 => Intl.message('Learning', name: 'learnRank2');

  String get learnRank3 => Intl.message('Almost', name: 'learnRank3');

  String get learnRank4 => Intl.message('Finished', name: 'learnRank4');

  String get learnRank5 => Intl.message('Known', name: 'learnRank5');

  String get learnRankAll => Intl.message('All', name: 'learnRankAll');

  String get learnRankIgnore => Intl.message('Ignore', name: 'learnRankIgnore');

  String get learnRankEmphasis =>
      Intl.message('Emphasis', name: 'learnRankEmphasis');

  String get learnRankUnknown =>
      Intl.message('Unknown', name: 'learnRankUnknown');

  String get prepareDictionary =>
      Intl.message('Preparing dictionary', name: 'prepareDictionary');

  String get signup => Intl.message('Sign up', name: 'signup');

  String get login => Intl.message('Login', name: 'login');

  String get visitor => Intl.message('Visitor', name: 'visitor');

  String get emailAddress =>
      Intl.message('Email Address', name: 'emailAddress');

  String get username => Intl.message('Username', name: 'username');

  String get captcha => Intl.message('Captcha', name: 'captcha');

  String get password => Intl.message('Password', name: 'password');

  String get confirmPassword =>
      Intl.message('Confirm Password', name: 'confirmPassword');

  String get newPassword => Intl.message('New Password', name: 'newPassword');

  String get ticket => Intl.message('Ticket', name: 'ticket');

  String get refresh => Intl.message('Refresh', name: 'refresh');

  String get agreement => Intl.message('Agreement', name: 'agreement');

  String get submit => Intl.message('Submit', name: 'submit');

  String switchTo(title) =>
      Intl.message("Switch to $title", name: 'switchTo', args: [title]);

  String get emailInvalid =>
      Intl.message("Please enter a valid email", name: 'emailInvalid');

  String get passwordInvalid =>
      Intl.message("Please enter a password whithin 6-16 characters",
          name: 'passwordInvalid');

  String get confirmPasswordInvalid =>
      Intl.message("Confirm Password Invalid", name: 'confirmPasswordInvalid');

  String get captchaInvalid =>
      Intl.message('Captcha can not be empty.', name: 'captchaInvalid');

  String get ticketInvalid =>
      Intl.message('Ticket can not be empty.', name: 'ticketInvalid');

  String get usernameInvalid =>
      Intl.message("User name invalid", name: 'usernameInvalid');

  String secondCount(int howMany) => Intl.plural(howMany,
      zero: "",
      one: "1 Second",
      other: "$howMany Seconds",
      args: [howMany],
      name: 'secondCount');

  String hourCount(int howMany) => Intl.plural(howMany,
      zero: "",
      one: "1 Hour",
      other: "$howMany Hours",
      args: [howMany],
      name: 'hourCount');

  String minuteCount(int howMany) => Intl.plural(howMany,
      zero: "",
      one: "1 Minute",
      other: "$howMany Minutes",
      args: [howMany],
      name: 'minuteCount');

  String dayCount(int howMany) => Intl.plural(howMany,
      zero: "",
      one: "1 Day",
      other: "$howMany Days",
      args: [howMany],
      name: 'dayCount');

  String get minute => Intl.message("Minute", name: 'minute');

  String get hour => Intl.message("Hour", name: 'hour');

  String get unauthenticatedTitle =>
      Intl.message('Using as guest', name: 'unauthenticatedTitle');

  String get unauthenticatedDesc => Intl.message(
      'Become a registered user, the learning records will automatically sync to the cloud, truly learn anytime, anywhere, even if the replacement of equipment need not worry about data loss',
      name: 'unauthenticatedDesc');

  String get justLearned => Intl.message("Just learned", name: 'justLearned');

  String get ago => Intl.message("ago", name: "ago");

  String get finishReview =>
      Intl.message("You finished all the contents you selected for this turn.",
          name: 'finishReview');

  String get showAnswer => Intl.message("Show answer", name: 'showAnswer');

  String get next => Intl.message('Next', name: 'next');

  String get settings => Intl.message('Settings', name: 'settings');

  String get haveRest => Intl.message('Have a rest', name: 'haveRest');

  String get noReviewTask =>
      Intl.message('There is no review task.', name: 'noReviewTask');

  String get searchDictAddToVocab =>
      Intl.message('Search Word', name: 'searchDictAddToVocab');

  String get list => Intl.message('List', name: 'list');

  String get statistics => Intl.message('Statistic', name: 'statistics');

  String get cloudBackup => Intl.message('Cloud Backup', name: 'cloudBackup');

  String get feedback => Intl.message('Feedback', name: 'feedback');

  String feedbackBody(String appName) =>
      Intl.message('请告诉我们您的意见和想法。<br>您的参与会让『$appName』越来越好！<br><br>',
          name: 'feedbackBody', args: [appName]);

  String get version => Intl.message('Version', name: 'version');

  String get logout => Intl.message('Logout', name: 'logout');

  String get login_signup => Intl.message('Sign in/up', name: 'login_signup');

  String get takePhoto => Intl.message('Take Photo', name: 'takePhoto');

  String get album => Intl.message('album', name: 'album');

  String get rating => Intl.message('rating', name: 'rating');

  String get edit => Intl.message('edit', name: 'edit');

  String get changePassword =>
      Intl.message('Change Password', name: 'changePassword');

  String get forgotPassword =>
      Intl.message('Forgot Password', name: 'forgotPassword');

  String get achievements => Intl.message('Achievements', name: 'achievements');

  String get lastest30Days =>
      Intl.message('Lastest 30 Days', name: 'lastest30Days');

  String get oneYear => Intl.message('One Year', name: 'oneYear');

  String get noResult =>
      Intl.message('No result, tapping here to add to word book',
          name: 'noResult');

  String get clearHistory =>
      Intl.message('Clear History', name: 'clearHistory'); // 清除历史

  String get inputWordHere =>
      Intl.message('Input word here', name: 'inputWordHere'); // 请输入单词、短语

  String get saveSucceeded =>
      Intl.message('Save succeeded.', name: 'saveSucceeded'); // 保存成功。

  String get cannotEmpty =>
      Intl.message(' can not be empty.', name: 'cannotEmpty'); // 不能为空。

  String get noNeedSave =>
      Intl.message('There is no change, and does not need save.',
          name: 'noNeedSave'); // 没有更改，不需要保存。

  String get saveOrNot =>
      Intl.message('Save or not?', name: 'saveOrNot'); //是否保存？

  String get category => Intl.message('Category', name: 'category'); //分类

  String get resetPassword =>
      Intl.message('Reset Password', name: 'resetPassword'); // 重置密码

  String get resetPasswordSucceed =>
      Intl.message('Reset password succeed. Please login.',
          name: 'resetPasswordSucceed'); // 重制密码成功，请重新登录。

  String get know => Intl.message('Know', name: 'know'); // 记得

  String get forgot => Intl.message('Forgot', name: 'forgot'); //

  String get rememberAnswer => Intl.message('Please remember the answer.',
      name: 'rememberAnswer'); // 问答题，请回忆答案

  String get tapBlankToShowAnswer =>
      Intl.message('Tap on the blank to display the answer.',
          name: 'tapBlankToShowAnswer'); //点击空白处，显示答案

  String get removeOrNot => Intl.message('Remove this entry from the wordbook?',
      name: 'removeOrNot'); // 从单词本删除这个条目？

  String get taskCompleted =>
      Intl.message('The review tasks are all completed.',
          name: 'taskCompleted'); //复习任务都完成了。

  String get backspace => Intl.message('Backspace', name: 'backspace'); //退 格

  String get right => Intl.message('Right', name: 'right'); //正确

  String get wrong => Intl.message('Wrong', name: 'wrong'); //错误

  String get familarity =>
      Intl.message('Familarity', name: 'familarity'); // 熟悉度

  String get lastTime => Intl.message('Last', name: 'lastTime'); // 上次学习

  String get close => Intl.message('关闭', name: 'close');

  String get showMore => Intl.message('详细', name: 'showMore');

  String get kk => Intl.message('kk', name: 'kk');
}

class MyLocalizationsDelegate
    extends LocalizationsDelegate<MemofLocalizations> {
  const MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return MyLanguages.contains(locale.languageCode);
  }

  @override
  Future<MemofLocalizations> load(Locale locale) {
    return MemofLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<MemofLocalizations> old) {
    return false;
  }
}
