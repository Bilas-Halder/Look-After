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