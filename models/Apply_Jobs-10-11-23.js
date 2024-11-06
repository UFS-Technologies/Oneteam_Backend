

var db=require('../dbconnection');
var fs = require('fs');
var ApplyJobs=
{
   Apply_Jobs:function(Apply_Jobs_,callback)
   {
  return db.query("CALL Apply_Jobs("+
  "@Applied_Jobs_Id_ :=?,"+
  "@Student_Id_ :=?,"+
  "@Job_Id_ :=?,"+
  "@Entry_Date_ :=?,"+
  "@Apply_Type_ :=?"+")"
   ,[Apply_Jobs_.Applied_Jobs_Id,
   Apply_Jobs_.Student_Id,Apply_Jobs_.Job_Id,Apply_Jobs_.Entry_Date,
   Apply_Jobs_.Apply_Type,],callback);
   }
   ,


   Search_Job_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
   {
  
  if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
  Pointer_Start_=0;
  
  if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
  Pointer_Stop_=0;
  
  return db.query("CALL Search_Job_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
  [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
   },


   Search_Applied_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
   {
  
  if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
  Pointer_Start_=0;
  
  if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
  Pointer_Stop_=0;
  
  return db.query("CALL Search_Applied_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
  [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
   },

 Search_Offered_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
   {
  
  if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
  Pointer_Start_=0;
  
  if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
  Pointer_Stop_=0;
  
  return db.query("CALL Search_Offered_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
  [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
   },

       Search_Rejected_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
   {
  
  if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
  Pointer_Start_=0;
  
  if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
  Pointer_Stop_=0;
  
  return db.query("CALL Search_Rejected_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
  [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
   },



   Search_Interview_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
   {
  
  if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
  Pointer_Start_=0;
  
  if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
  Pointer_Stop_=0;
  
  return db.query("CALL Search_Interview_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
  [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
   },



   Search_Placed_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
   {
  
  if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
  Pointer_Start_=0;
  
  if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
  Pointer_Stop_=0;
  
  return db.query("CALL Search_Placed_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
  [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
   },

Change_Student_Status: function (
Student_Status_,
Student_Id_,
callback
) {
return db.query(
"CALL Change_Student_Status(@Student_Status_ :=?,@Student_Id_ :=?)",
[Student_Status_, Student_Id_],
callback
);
},
View_Job: function (Job_Posting_Id_, callback) {
return db.query(
"CALL View_Job(@Job_Posting_Id_ :=?)",
[Job_Posting_Id_],
callback
);
},

View_Job_Interview: function (Job_Posting_Id_ ,Student_Id_, callback) {
return db.query(
"CALL View_Job_Interview(@Job_Posting_Id_ :=?,@Student_Id_ :=?)",
[Job_Posting_Id_,Student_Id_],
callback
);
},
Job_Apply_Reject: function (Type_, Job_Id, User_Id_,Remark, callback) {
return db.query(
"CALL Job_Apply_Reject(@Student_Id_ :=?,@Job_Id_ :=?,@Apply_Type_ :=?,@Remark_ :=?)",
[User_Id_,Job_Id,Type_, Remark],
callback
);
},

 Job_Apply_Reject_Interview: function (Student_Id_, Applied_Jobs_Id_, Interview_Type_,Remark_, callback) {
 console.log( Applied_Jobs_Id_,Student_Id_, Interview_Type_,Remark_,"TEst");
return db.query(
"CALL Job_Apply_Reject_Interview(@Student_Id_ :=?, @Applied_Jobs_Id_ :=?,@Interview_Type_ :=?,@Remark_ :=?)",
[Student_Id_, Applied_Jobs_Id_, Interview_Type_,Remark_],
callback
);
},

 };

 module.exports=ApplyJobs;














//  var db=require('../dbconnection');
//  var fs = require('fs');
//  var ApplyJobs=
//  { 
//     Apply_Jobs:function(Apply_Jobs_,callback)
//     { 
//    return db.query("CALL Apply_Jobs("+
//    "@Applied_Jobs_Id_ :=?,"+
//    "@Student_Id_ :=?,"+
//    "@Job_Id_ :=?,"+
//    "@Entry_Date_ :=?,"+
//    "@Apply_Type_ :=?"+")"
//     ,[Apply_Jobs_.Applied_Jobs_Id,
//     Apply_Jobs_.Student_Id,Apply_Jobs_.Job_Id,Apply_Jobs_.Entry_Date,
//     Apply_Jobs_.Apply_Type,],callback);
//     }
//     ,


//     Search_Job_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
//     { 
   
//    if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
//    Pointer_Start_=0;
   
//    if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
//    Pointer_Stop_=0; 
   
//    return db.query("CALL Search_Job_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
//    [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
//     },


//     Search_Applied_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
//     { 
   
//    if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
//    Pointer_Start_=0;
   
//    if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
//    Pointer_Stop_=0; 
   
//    return db.query("CALL Search_Applied_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
//    [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
//     },

//   Search_Offered_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
//     { 
   
//    if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
//    Pointer_Start_=0;
   
//    if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
//    Pointer_Stop_=0; 
   
//    return db.query("CALL Search_Offered_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
//    [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
//     },

//         Search_Rejected_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
//     { 
   
//    if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
//    Pointer_Start_=0;
   
//    if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
//    Pointer_Stop_=0; 
   
//    return db.query("CALL Search_Rejected_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
//    [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
//     },



//     Search_Interview_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
//     { 
   
//    if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
//    Pointer_Start_=0;
   
//    if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
//    Pointer_Stop_=0; 
   
//    return db.query("CALL Search_Interview_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
//    [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
//     },



//     Search_Placed_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback)
//     { 
   
//    if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
//    Pointer_Start_=0;
   
//    if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
//    Pointer_Stop_=0; 
   
//    return db.query("CALL Search_Placed_Mobile(@Student_Id_:=?,@Pointer_Start_:=?,@Pointer_Stop_:=?,@Page_Length_:=?)",
//    [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],callback);
//     },

// 	Change_Student_Status: function (
// 		Student_Status_,
// 		Student_Id_,
// 		callback
// 	) {
// 		return db.query(
// 			"CALL Change_Student_Status(@Student_Status_ :=?,@Student_Id_ :=?)",
// 			[Student_Status_, Student_Id_],
// 			callback
// 		);
// 	},
// 	View_Job: function (Job_Posting_Id_, callback) {
// 		return db.query(
// 			"CALL View_Job(@Job_Posting_Id_ :=?)",
// 			[Job_Posting_Id_],
// 			callback
// 		);
// 	},
  

// 	Job_Apply_Reject: function (Type_, Job_Id, User_Id_,Remark, callback) {
// 		return db.query(
// 			"CALL Job_Apply_Reject(@Student_Id_ :=?, @Job_Id_ :=?,@Apply_Type_ :=?,@Remark_ :=?)",
// 			[User_Id_,Job_Id,Type_, Remark],
// 			callback
// 		);
// 	},


//   Job_Apply_Reject_Interview: function (Student_Id_, Applied_Jobs_Id_, Interview_Type_,Remark_, callback) {
// 		return db.query(
// 			"CALL Job_Apply_Reject_Interview(@Student_Id_ :=?, @Applied_Jobs_Id_ :=?,@Interview_Type_ :=?,@Remark_ :=?)",
// 			[Student_Id_, Applied_Jobs_Id_, Interview_Type_,Remark_],
// 			callback
// 		);
// 	},

//   };

//   module.exports=ApplyJobs;






