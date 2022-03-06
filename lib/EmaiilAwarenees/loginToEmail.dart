import 'package:flutter/material.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/constants.dart';
import 'package:look_after/providers/NewMailProvider.dart';
import 'package:provider/provider.dart';

Future <bool> loginToMail(String email, String password, BuildContext context) async{
  print('discovering settings for  $email...');
  final config = await Discover.discover(email);

  if (config == null) {
    return false;
  }
  final account =
  MailAccount.fromDiscoveredSettings('my account', email, password, config);
  final mailClient = MailClient(account, isLogEnabled: true);
  try {
    await mailClient.connect();
    final mailboxes =
    await mailClient.listMailboxesAsTree(createIntermediate: false);
    print(mailboxes);
    await mailClient.selectInbox();
    final messages = await mailClient.fetchMessages(count: 1);
    getMsgList(messages[0], context);

    mailClient.eventBus.on<MailLoadEvent>().listen((event) async{
      await mailClient.selectInbox();
      final messages = await mailClient.fetchMessages(count: 1);
      getMsgList(messages[0],context);
    });

    await mailClient.startPolling();
  } on MailException catch (e) {
    return false;
  }
  return true;

}


void getMsgList(MimeMessage message, BuildContext context) {
  List <String> msgList=[] ;


  final plainText = message.decodeTextPlainPart();
  if (plainText != null) {
    final lines = plainText.split('\r\n');
    for (final line in lines) {

      print('line from getMsgList $line');
      msgList.add(line);
    }
  }
  addMailedTaskToHive(msgList, message.decodeSubject());

}

void addMailedTaskToHive(List <String> msgList, String sub){
   String time=null;
   String date=null;

   for(var str in msgList){
     time = findTime(str)??time;
     print('time = $time');
     if(time!=null){
       date = findDate(str)??date;
       print('date = $date');
       if(date!=null){
         addTaskModelToHiveDB(
             TaskModel(
               email: 'lookafter110@gmail.com',
               title: 'Probable event from email',
               note: sub,
               status: 2,
               category: 'From Email',
               priority: 2,
               color: Colors.teal.value,
               date: DateTime.now(),
               startTime: '8:30 PM',
               endTime: '9:30 PM',
               remind: 5,
               repeat: '',
             )
         );
         print('task added');
         break;
       }
     }
   }
}


String findTime(String s){
  final time = timeRegEx.firstMatch(s);
  if(time != null){
    return s.substring(time.start, time.end);
  }
  return null;
}

String findDate(String s){
  final date = dateRegEx.firstMatch(s);
  if(date != null){
    return s.substring(date.start, date.end);
  }
  return null;
}
