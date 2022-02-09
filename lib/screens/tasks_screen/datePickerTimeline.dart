import 'package:flutter/material.dart';

class DatePickerTimeline extends StatefulWidget {

  @override
  State<DatePickerTimeline> createState() => _DatePickerTimelineState();
}

class _DatePickerTimelineState extends State<DatePickerTimeline> {
  final weekList = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final dayList = ['6','7','8','9','10','11','12'];
  var selected = 5;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final i = index % weekList.length;
          return GestureDetector(
            onTap: () => setState(()=>selected=i),
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: selected==i?Colors.grey.withOpacity(0.1):null
              ),
              child: Column(
                children: [
                  Text(
                    weekList[i],
                    style: TextStyle(
                      color: selected==i?Colors.black:Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    dayList[i],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selected==i?Colors.black:Colors.grey,
                    ),
                  )

                ],
              ),
            ),
          );
        },

        // itemCount: weekList.length,
      ),
    );
  }
}
