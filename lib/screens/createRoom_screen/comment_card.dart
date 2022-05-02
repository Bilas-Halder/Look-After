import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatefulWidget {
  //const CommentCard({Key? key}) : super(key: key);

  final snap;
  CommentCard({this.snap});
  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {

    var date = widget.snap['datePublished'].toDate();

    String dateString = DateFormat("MMM d, yyyy").format(date) == DateFormat("MMM d, yyyy").format(DateTime.now()) ? DateFormat("hh:mm a ").format(date) : DateFormat("MMM d ").format(date) + 'at ' + DateFormat("hh:mm a").format(date);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profileImg']),
            radius: 17,
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints( minWidth: 200 ,),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(15.0)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 3,),
                        Text(
                          widget.snap['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 15
                          ),
                        ),
                        SizedBox(height: 3,),
                        Text(
                          dateString,
                          style: TextStyle(
                            fontSize: 12,
                              color: Colors.grey[700]
                          ),
                        ),
                        SizedBox(height: 5,),
                        Text(
                          widget.snap['text'],
                          style: TextStyle(color: Colors.black87),
                        ),
                        SizedBox(height: 5,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Row(
                  children: [

                    SizedBox(width: 16,),
                    Text(
                      "Like",
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),
                    SizedBox(width: 16,),
                    Text(
                      "Reply",
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),

                    SizedBox(width: 70,),


                    Text(
                      "3",
                      style: TextStyle(
                          color: Colors.black,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(width: 2,),
                    Container(
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.blue[700],
                        child: Icon(
                          Icons.thumb_up_outlined,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    )

                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Text(
// DateFormat.yMMMd()
// .format(widget.snap['datePublished'].toDate()),
// style: TextStyle(
// fontSize: 12, fontWeight: FontWeight.w400)),