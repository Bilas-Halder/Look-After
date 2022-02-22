import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:look_after/providers/task_providers.dart';
import 'package:look_after/screens/tasks_screen/add_task.dart';
import 'package:provider/provider.dart';

class LogInButton extends StatelessWidget {
  final Color color,textColor;
  final String title;
  final Function onPressed;
  LogInButton({this.title,this.color,@required this.onPressed,this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: onPressed!=null?onPressed:(){},
        child: Container(
          height: 42.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: Colors.teal,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(1.0, 2.0), // shadow direction: bottom right
              )
            ],
            borderRadius: BorderRadius.circular(30.0),
          ),

          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color:textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color color,textColor;
  final String title;
  final Function onPressed;
  final double width;
  final BorderRadiusGeometry borderRadius;
  final bool reversed;
  CustomButton({this.reversed,this.title,this.color,@required this.onPressed,this.textColor, this.width, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: InkWell(
        onTap: onPressed!=null?onPressed:(){},
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          height: 42.0,
          width: width!=null ? width : double.infinity,
          decoration: BoxDecoration(
            color: color!=null? reversed==true? Colors.white : color : Colors.teal,
            border: Border.all(
              color: color ,
              width: 2,
            ),
            borderRadius: borderRadius?? BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(1.0, 2.0), // shadow direction: bottom right
              )
            ],
          ),

          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color:textColor ?? (reversed==true? color: Colors.white),
                    fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class AddTask extends StatelessWidget {
  final String label;
  final Function onTap;
  const AddTask({this.label, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}


FloatingActionButton floatingAddButton(context){
  return FloatingActionButton(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: Colors.black,
    onPressed: ()async {
      // await Get.to(AddTaskPage()).then((value) {
      //   Provider.of<TaskProvider>(context,listen: false).getTasks();
      // });
      Navigator.pushNamed(context, AddTaskPage.path).then((value) {
        Provider.of<TaskProvider>(context,listen: false).getTasks();
      });
    },
    child: Icon(Icons.add, size: 30,),
  );
}

