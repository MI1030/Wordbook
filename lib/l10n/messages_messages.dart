// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a messages locale. All the
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
  get localeName => 'messages';

  static m0(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1 Day', other: '${howMany} Days')}";

  static m1(appName) => "请告诉我们您的意见和想法。<br>您的参与会让『${appName}』越来越好！<br><br>";

  static m2(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1 Hour', other: '${howMany} Hours')}";

  static m3(count) => "the ${count} day";

  static m4(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1 Minute', other: '${howMany} Minutes')}";

  static m5(count) => "Reviewd ${count} words";

  static m6(howMany) =>
      "${Intl.plural(howMany, zero: '', one: '1 Second', other: '${howMany} Seconds')}";

  static m7(title) => "Switch to ${title}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{
        "achievements": MessageLookupByLibrary.simpleMessage("Achievements"),
        "add": MessageLookupByLibrary.simpleMessage("add"),
        "addToNotes": MessageLookupByLibrary.simpleMessage("Add to Notes"),
        "ago": MessageLookupByLibrary.simpleMessage("ago"),
        "agreement": MessageLookupByLibrary.simpleMessage("Agreement"),
        "album": MessageLookupByLibrary.simpleMessage("album"),
        "article": MessageLookupByLibrary.simpleMessage("Article"),
        "backspace": MessageLookupByLibrary.simpleMessage("Backspace"),
        "cannotEmpty":
            MessageLookupByLibrary.simpleMessage(" can not be empty."),
        "captcha": MessageLookupByLibrary.simpleMessage("Captcha"),
        "captchaInvalid":
            MessageLookupByLibrary.simpleMessage("Captcha can not be empty."),
        "category": MessageLookupByLibrary.simpleMessage("Category"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Change Password"),
        "chineseDefinition":
            MessageLookupByLibrary.simpleMessage("Chinese Definition"),
        "clearHistory": MessageLookupByLibrary.simpleMessage("Clear History"),
        "cloudBackup": MessageLookupByLibrary.simpleMessage("Cloud Backup"),
        "confirmPassword":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "confirmPasswordInvalid":
            MessageLookupByLibrary.simpleMessage("Confirm Password Invalid"),
        "dayCount": m0,
        "dictionary": MessageLookupByLibrary.simpleMessage("dictionary"),
        "edit": MessageLookupByLibrary.simpleMessage("edit"),
        "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
        "emailInvalid":
            MessageLookupByLibrary.simpleMessage("Please enter a valid email"),
        "englishDefinition":
            MessageLookupByLibrary.simpleMessage("English Definition"),
        "exampleSentences":
            MessageLookupByLibrary.simpleMessage("Example Sentences"),
        "familarity": MessageLookupByLibrary.simpleMessage("Familarity"),
        "feedback": MessageLookupByLibrary.simpleMessage("Feedback"),
        "feedbackBody": m1,
        "finishReview": MessageLookupByLibrary.simpleMessage(
            "You finished all the contents you selected for this turn."),
        "forgot": MessageLookupByLibrary.simpleMessage("Forgot"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "guest": MessageLookupByLibrary.simpleMessage("guest"),
        "haveRest": MessageLookupByLibrary.simpleMessage("Have a rest"),
        "hour": MessageLookupByLibrary.simpleMessage("Hour"),
        "hourCount": m2,
        "inputWordHere":
            MessageLookupByLibrary.simpleMessage("Input word here"),
        "justLearned": MessageLookupByLibrary.simpleMessage("Just learned"),
        "kk": MessageLookupByLibrary.simpleMessage("kk"),
        "know": MessageLookupByLibrary.simpleMessage("Know"),
        "lastTime": MessageLookupByLibrary.simpleMessage("Last"),
        "lastest30Days":
            MessageLookupByLibrary.simpleMessage("Lastest 30 Days"),
        "learnRank0": MessageLookupByLibrary.simpleMessage("Unlearn"),
        "learnRank1": MessageLookupByLibrary.simpleMessage("Learning"),
        "learnRank2": MessageLookupByLibrary.simpleMessage("Learning"),
        "learnRank3": MessageLookupByLibrary.simpleMessage("Almost"),
        "learnRank4": MessageLookupByLibrary.simpleMessage("Finished"),
        "learnRank5": MessageLookupByLibrary.simpleMessage("Known"),
        "learnRankAll": MessageLookupByLibrary.simpleMessage("All"),
        "learnRankEmphasis": MessageLookupByLibrary.simpleMessage("Emphasis"),
        "learnRankIgnore": MessageLookupByLibrary.simpleMessage("Ignore"),
        "learnRankUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
        "list": MessageLookupByLibrary.simpleMessage("List"),
        "login": MessageLookupByLibrary.simpleMessage("Login"),
        "login_signup": MessageLookupByLibrary.simpleMessage("Sign in/up"),
        "logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "memberDay": m3,
        "minute": MessageLookupByLibrary.simpleMessage("Minute"),
        "minuteCount": m4,
        "myWordList": MessageLookupByLibrary.simpleMessage("myWordList"),
        "newPassword": MessageLookupByLibrary.simpleMessage("New Password"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "noNeedSave": MessageLookupByLibrary.simpleMessage(
            "There is no change, and does not need save."),
        "noResult": MessageLookupByLibrary.simpleMessage(
            "No result, tapping here to add to word book"),
        "noReviewTask":
            MessageLookupByLibrary.simpleMessage("There is no review task."),
        "oneYear": MessageLookupByLibrary.simpleMessage("One Year"),
        "password": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordInvalid": MessageLookupByLibrary.simpleMessage(
            "Please enter a password whithin 6-16 characters"),
        "phrase": MessageLookupByLibrary.simpleMessage("Phrase"),
        "prepareDictionary":
            MessageLookupByLibrary.simpleMessage("Preparing dictionary"),
        "rating": MessageLookupByLibrary.simpleMessage("rating"),
        "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
        "rememberAnswer":
            MessageLookupByLibrary.simpleMessage("Please remember the answer."),
        "removeOrNot": MessageLookupByLibrary.simpleMessage(
            "Remove this entry from the wordbook?"),
        "resetPassword": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "resetPasswordSucceed": MessageLookupByLibrary.simpleMessage(
            "Reset password succeed. Please login."),
        "review": MessageLookupByLibrary.simpleMessage("review"),
        "reviewTask": MessageLookupByLibrary.simpleMessage("Review Task"),
        "reviewedXwords": m5,
        "right": MessageLookupByLibrary.simpleMessage("Right"),
        "saveOrNot": MessageLookupByLibrary.simpleMessage("Save or not?"),
        "saveSucceeded":
            MessageLookupByLibrary.simpleMessage("Save succeeded."),
        "searchDictAddToVocab":
            MessageLookupByLibrary.simpleMessage("Search Word"),
        "secondCount": m6,
        "settings": MessageLookupByLibrary.simpleMessage("Settings"),
        "showAnswer": MessageLookupByLibrary.simpleMessage("Show answer"),
        "signup": MessageLookupByLibrary.simpleMessage("Sign up"),
        "start": MessageLookupByLibrary.simpleMessage("Start"),
        "statistics": MessageLookupByLibrary.simpleMessage("Statistic"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "switchTo": m7,
        "takePhoto": MessageLookupByLibrary.simpleMessage("Take Photo"),
        "tapBlankToShowAnswer": MessageLookupByLibrary.simpleMessage(
            "Tap on the blank to display the answer."),
        "taskCompleted": MessageLookupByLibrary.simpleMessage(
            "The review tasks are all completed."),
        "tense": MessageLookupByLibrary.simpleMessage("Tense"),
        "ticket": MessageLookupByLibrary.simpleMessage("Ticket"),
        "ticketInvalid":
            MessageLookupByLibrary.simpleMessage("Ticket can not be empty."),
        "title": MessageLookupByLibrary.simpleMessage("单词本"),
        "todayLearn": MessageLookupByLibrary.simpleMessage("todayLearn"),
        "totalLearn": MessageLookupByLibrary.simpleMessage("totalLearn"),
        "unauthenticatedDesc": MessageLookupByLibrary.simpleMessage(
            "Become a registered user, the learning records will automatically sync to the cloud, truly learn anytime, anywhere, even if the replacement of equipment need not worry about data loss"),
        "unauthenticatedTitle":
            MessageLookupByLibrary.simpleMessage("Using as guest"),
        "username": MessageLookupByLibrary.simpleMessage("Username"),
        "usernameInvalid":
            MessageLookupByLibrary.simpleMessage("User name invalid"),
        "version": MessageLookupByLibrary.simpleMessage("Version"),
        "visitor": MessageLookupByLibrary.simpleMessage("Visitor"),
        "word": MessageLookupByLibrary.simpleMessage("Word"),
        "wrong": MessageLookupByLibrary.simpleMessage("Wrong")
      };
}
