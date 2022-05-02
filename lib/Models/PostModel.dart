import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:look_after/DB/db_helper.dart';

class PostModel {
  String description;
  String uid;
  String eventID;
  String postID;
  DateTime datePublished;
  String profImg;
  String userName;
  List<dynamic> jsonDescription = [];
  int totalReacts=0;
  int totalComments = 0;
  Map <String,dynamic> _reacts={
    'like' : 0,
    'love' : 0,
    'celebrate' : 0,
    'idea' : 0,
    'sad' : 0,
    'wow' : 0,
  };
  Map<String,dynamic> reactors ={};


  PostModel({
    this.description,
    this.uid,
    this.postID,
    this.datePublished,
    this.profImg,
    this.userName,
    this.eventID,
    this.jsonDescription
  });

  PostModel.fromJson(Map<String, dynamic> json){
    if(json!=null){
      var date = json['datePublished'];

      datePublished = date.runtimeType == Timestamp? date?.toDate() :date ;

      description = json['description'];
      jsonDescription = json['jsonDescription'];
      uid = json['uid'];
      postID = json['postID'];
      profImg = json['profImg'];
      eventID = json['eventID'];
      userName = json['userName'];
      totalReacts = json['totalReacts'];
      totalComments = json['totalComments'];
      _reacts = json['reacts'];
      reactors = json['reactors'];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['jsonDescription'] = this.jsonDescription;
    data['uid'] = this.uid;
    data['postID'] = this.postID;
    data['datePublished'] = this.datePublished;
    data['profImg'] = this.profImg;
    data['eventID'] = this.eventID;
    data['userName'] = this.userName;
    data['totalReacts'] = this.totalReacts;
    data['totalComments'] = this.totalComments;
    data['reacts'] = this._reacts;
    data['reactors'] = this.reactors;
    return data;
  }


  removeReact(String uid){
    var react = this.reactors[uid];
    this._reacts[react]--;
    this.totalReacts--;
    reactors.remove(uid);
    // dbHelper.updatePostToFirebase(this);

    dbHelper.updatePostDynamicallyToFirebase(this,{
      "reacts":this._reacts,
      "totalReacts":this.totalReacts,
      "reactors":this.reactors
    });
  }
  react(String react,String uid){
    try{
      this.reactors[uid] = react;
      this._reacts[react]++;
      this.totalReacts++;
    }
    catch(e){
      print(e.toString());
    }
    dbHelper.updatePostDynamicallyToFirebase(this,{
      "reacts":this._reacts,
      "totalReacts":this.totalReacts,
      "reactors":this.reactors
    });
  }

  Map <String,int> get Reacts{
    return this._reacts;
  }

}