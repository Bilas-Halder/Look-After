import 'package:flutter/material.dart';
import 'package:look_after/DB/chatDB_helper.dart';
import 'package:look_after/Models/hive_task_model.dart';
import 'package:look_after/constants.dart';


class ShowSharedTaskChat extends StatefulWidget {

  final String messageId;
  ShowSharedTaskChat({this.messageId});


  @override
  State<ShowSharedTaskChat> createState() => _ShowSharedTaskChatState();
}

class _ShowSharedTaskChatState extends State<ShowSharedTaskChat> {

  final borderRadius = BorderRadius.only(
    topLeft: Radius.circular(20),
    topRight: Radius.circular(20),
    bottomRight: Radius.circular(20),
    bottomLeft: Radius.circular(20),
  );
  TaskModel task= TaskModel.DummyChatTask();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTaskFromMsgId(widget.messageId);
  }
  getTaskFromMsgId(String msgId) async{
    var t = await ChatHelper.getSharedTask(msgId);
    setState(() {
      task=t;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.65),
            offset: const Offset(0.0, 0.0),
            blurRadius: 3.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color:task?.color != null ? Color(task?.color).withOpacity(0.4) : Colors.teal.withOpacity(0.4),
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: task?.priority != null ? priorityColors[task?.priority] : priorityColors[2],
                      shape: BoxShape.circle),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            task?.title ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ),
                        SizedBox(height: 2),
                        Container(
                          child: Text(
                            task?.note ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Icon(
                    task?.status!=null ? status[task?.status]['icon'] : status[0]['icon'],
                    color: task?.status!=null ? status[task?.status]['color'] : status[0]['color'],
                    size: 24,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}