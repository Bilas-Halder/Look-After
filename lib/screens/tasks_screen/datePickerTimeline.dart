import 'package:flutter/material.dart';

class DatePickerTimeline extends StatefulWidget {

  @override
  State<DatePickerTimeline> createState() => _DatePickerTimelineState();
}

class _DatePickerTimelineState extends State<DatePickerTimeline> {
  final weekList = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  final dayList = ['6','7','8','9','10','11','12'];
  var selected = 4;
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
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index)=> GestureDetector(
          onTap: () => setState(()=>selected=index),
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selected==index?Colors.grey.withOpacity(0.1):null
            ),
            child: Column(
              children: [
                Text(
                  weekList[index],
                  style: TextStyle(
                    color: selected==index?Colors.black:Colors.grey,
                  ),
                ),
                SizedBox(height: 5,),
                Text(
                  dayList[index],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: selected==index?Colors.black:Colors.grey,
                  ),
                )

              ],
            ),
          ),
        ),
        separatorBuilder: (_,index)=>SizedBox(width: 5,),
        itemCount: weekList.length,
      ),
    );
  }
}
