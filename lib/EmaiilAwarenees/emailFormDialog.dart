import 'package:another_flushbar/flushbar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:look_after/EmaiilAwarenees/loginToEmail.dart';
import 'package:look_after/providers/EmailEnabledProvider.dart';
import 'package:look_after/utilities/buttons.dart';
import 'package:look_after/utilities/errorMessage.dart';
import 'package:look_after/utilities/input_field.dart';
import 'package:provider/src/provider.dart';

class EmailPassWordFormDialog extends StatefulWidget {

  @override
  State<EmailPassWordFormDialog> createState() => _EmailPassWordFormDialogState();
}

class _EmailPassWordFormDialogState extends State<EmailPassWordFormDialog> {
  final TextEditingController _emailController =  TextEditingController();

  final TextEditingController _passwordController =  TextEditingController();

  bool checkedValue = false;
  bool checkBox1 = false;
  bool checkBox2 = false;
  bool error = false;
  bool loading = false;
  String errorMsg = "Failed to Connect, try again";

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            width: width + 100,
            child:SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: loading ?  CircularProgressIndicator(
                      color: Colors.teal,

                    ) :  Text(
                      'Enable Email Awareness',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  MyInputField(
                    title: "Email",
                    hint: "Enter Your Email",
                    controller: _emailController,
                  ),
                  MyInputField(
                    title: "Password",
                    hint: "Enter Your Password",
                    controller: _passwordController,
                    type: 'password',
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ErrorMessage(
                    errorMsg: errorMsg,
                    error: error,
                    fontSize: 14,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: checkBox2,
                          onChanged: (bool value) {
                            setState(() {
                              checkBox2 = value;
                              if(checkBox1 && checkBox2){
                                checkedValue = true;
                              }
                              else checkedValue = false;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Allow the read access of mails.',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                          value: checkBox1,
                          onChanged: (bool value) {
                            setState(() {
                              checkBox1 = value;
                              if(checkBox1 && checkBox2){
                                checkedValue = true;
                              }
                              else checkedValue = false;
                            });
                          },
                          activeColor: Colors.teal,
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Accepting the ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14
                        ),
                      ),
                      Text(
                        'terms and conditions',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 14,
                          decoration: TextDecoration.underline
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AddTaskButton(
                        label: 'Enable',
                        onTap: !checkedValue ? null : ()async{
                          setState(() {
                            loading = true;
                          });

                          if(!EmailValidator.validate(_emailController.text)){
                            setState(() {
                              error = true;
                              errorMsg = "Please Use a valid email.";
                              loading = false;
                            });
                            return;
                          }
                          if(_passwordController.text.length<6){
                            setState(() {
                              error = true;
                              errorMsg = "Wrong Password. Try again.";
                              loading = false;
                            });
                            return;
                          }

                         bool s = await loginToMail(_emailController.text, _passwordController.text,context);
                         setState(() {
                           loading = false;
                           error = !s;
                           errorMsg = "Failed to Connect, try again";
                         });
                         if(s){
                           Navigator.pop(context);
                           context.read<EmailEnabledProvider>().setisEmailAwarenessEnabled(true);

                           await Flushbar(
                             leftBarIndicatorColor: Colors.teal,
                             icon: Icon(
                               Icons.sentiment_very_satisfied_rounded,
                               color: Colors.red[200],
                               size: 30,
                             ),
                             title: 'Email Awareness Enabled.',
                             message:
                             'Enjoy the easiness of task scheduling & never miss the events again.',
                             duration: Duration(seconds: 2),
                           ).show(context);
                         }

                         },
                      ),
                    ],
                  )

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
