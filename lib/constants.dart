import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);


final List<Map<String, dynamic>> status = [
  {
    'color': Colors.green[800],
    'message': 'Completed',
    'icon': Icons.task_alt_outlined
  },
  {
    'color': Colors.yellow[900],
    'message': 'In Progress',
    'icon': Icons.check_circle_outline
  },
  {
    'color': Colors.grey[600],
    'message': 'Add Progress Status',
    'icon': Icons.add_task_outlined
  },
];
final priorityColors = [Colors.red[800], Colors.yellow[900], Colors.grey[600]];


bool isBrightColor(Color color){
  if ((color.computeLuminance() + 0.05) * (color.computeLuminance() + 0.05) > 0.25) {
    // print('Bright');
    return true;
  }
  else {
    // print('Dark');
    return false;
  }
}


String formatDate(DateTime date) => DateFormat.yMMMd().format(date);


RegExp timeRegEx = RegExp(r"(0?[1-9]|1[012])(:[0-5][0-9]) [APap][mM]");

RegExp dateRegEx =  RegExp(r"(?:(?:31(\/|-| |\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-| |\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})|(?:29(\/|-| |\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))|(?:0?[1-9]|1\d|2[0-8])(\/|-| |\.)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})");
