import 'package:flutter/material.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/Services/notification_services.dart';
import 'package:look_after/constants.dart';

import 'AddFromEmailCategory.dart';

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
    getMsgList(messages[1], context);
    await addFromEmailCategory();

    mailClient.eventBus.on<MailLoadEvent>().listen((event) async{
      await mailClient.selectInbox();
      final messages = await mailClient.fetchMessages(count: 1);
      getMsgList(messages[1],context);
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
  addMailedTaskToHive(msgList, message.decodeSubject(),message.to[0].toString());

}

void addMailedTaskToHive(List <String> msgList, String sub, String email){
   String time=null;
   String date=null;
   print(sub);

   for(var str in msgList){
     time = findTime(str)??time;
     date = findDate(str)??date;
     if(time!=null && date!=null){
       print('time = $time');
       print('date = $date');
       break;
     }
   }

   if(time!=null && date!=null){
     String s='';
     int flag = 0 ;
     String month, day, year;
     for(int i=0; i<date.length; i++){
       if(date[i]==' ' || date[i]=='/' || date[i]=='-' || date[i]=='.'){
         if(flag==0){
           if(s.length==2){
             day = s;
           }
           else day = '0'+s;
           flag++;
           s='';
         }
         else if(flag==1){
           month = monthInt[s];
           if(month==null){
             if(month.length==1){
               month = '0'+s;
             }
             else{
               month = s;
             }
           }
           flag++;
           s='';
         }
       }
       else{
         s+=date[i];
       }
     }
     if(s.length==2){
       year = '20'+s;
     }
     else year = s;

     print('$year$month$day');
     DateTime dateTime = DateTime.parse('$year$month$day');

     addTaskModelToHiveDB(
         TaskModel(
           email: email,
           title: 'Probable event from email',
           note: sub,
           status: 2,
           category: 'From Email',
           priority: 2,
           color: Colors.teal.value,
           date: dateTime,
           startTime: '8:30 PM',
           endTime: '9:30 PM',
           remind: 5,
           repeat: '',
         )
     );
     print('task added');
   }
   else if(time!=null && date == null){
     NotifyHelper().displayNotification(
         title: "There is a probable event at $time.", body: 'You might add the task for future.');
   }
   else if(time==null && date != null){
     NotifyHelper().displayNotification(
         title: "There is a probable upcoming event.", body: 'Date : $date');
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
