// Padding(
// padding: EdgeInsets.symmetric(horizontal: 24.0),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: <Widget>[
// Flexible(
// child: Hero(
// tag: 'logo',
// child: Container(
// height: 200.0,
// child: Image.asset('images/logo.png'),
// ),
// ),
// ),
// SizedBox(
// height: 48.0,
// ),
// InputTextField(
// hintText: 'Enter your email',
// error: error,
// onChanged: (String value){
// email=value;
// },
// type: 'email',
// ),
// SizedBox(
// height: 8.0,
// ),
// InputTextField(
// hintText: 'Enter your password',
// error: error,
// onChanged: (String value){
// password = value;
// },
// type: 'password',
// ),
// ErrorMessage(
// errorMsg: errorMsg,
// error: error,
// ),
// SizedBox(
// height: 24.0,
// ),
// LogInButton(
// title: 'Log In',
// color: Colors.lightBlueAccent,
// onPressed: () async {
// setState(() {
// showSpinner=true;
// });
// if(email==null || email == '' || password==null || password == ''){
// setState(() {
// error= true;
// errorMsg= "Email & Password required.";
// showSpinner=false;
// });
// return;
// }
//
// try{
// final msg = await context.read <AuthenticationService>().signIn(email: email, password: password);
//
// print(msg);
// if(msg == 'Signed In'){
// setState(() {
// error=false;
// });
// Navigator.pushNamed(context, ChatScreen.path);
// }
// else{
// setState(() {
// error=true;
// errorMsg=msg;
// });
// }
// }
// catch (e){
// print(e);
// }
// finally{
// setState(() {
// showSpinner=false;
// });
// }
// },
// ),
// ],
// ),
// ),