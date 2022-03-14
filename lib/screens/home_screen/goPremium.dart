import 'package:flutter/material.dart';
import 'package:look_after/EmaiilAwarenees/emailFormDialog.dart';
import 'package:look_after/providers/EmailEnabledProvider.dart';
import 'package:provider/provider.dart';

class GoPremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool emailEnabled = context.watch<EmailEnabledProvider>().isEmailAwarenessEnabled;

    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: emailEnabled? Colors.black.withOpacity(0.9) :Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: emailEnabled ?  CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Container(
                  child: Icon(
                    Icons.star_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: emailEnabled ? Colors.red[900] : Colors.grey[800],
                      shape: BoxShape.circle),
                ),
                SizedBox(
                  width: 30,
                ),
                Column(
                  mainAxisAlignment: emailEnabled ?  MainAxisAlignment.center : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emailEnabled ? 'Email Awareness Enabled!' : 'Enable Email Awareness!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height:emailEnabled ? 0: 10,
                    ),
                    emailEnabled ? SizedBox() : Text(
                      'Let us read your emails\nto make your life easier!',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                )
              ],
            ),
          ),
          emailEnabled ? SizedBox() : Positioned(
            bottom: 15,
            right: 15,
            child: GestureDetector(
              onTap: () {
                showDialog(context: context, useRootNavigator: false, builder: (_) => EmailPassWordFormDialog());
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal[700],
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
