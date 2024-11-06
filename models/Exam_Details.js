 var db=require('../dbconnection');
 var fs = require('fs');
 var Exam_Details=
 { 
 Save_Exam_Details:function(Exam_Details_,callback)
 { 
return db.query("CALL Save_Exam_Details("+
"@Exam_Details_Id_ :=?,"+
"@Exam_Master_Id_ :=?,"+
"@Question_Id_ :=?,"+
"@Question_Name_ :=?,"+
"@Option_1_ :=?,"+
"@Option_2_ :=?,"+
"@Option_3_ :=?,"+
"@Option_4_ :=?,"+
"@Question_Answer_ :=?"+")"
 ,[Exam_Details_.Exam_Details_Id,
Exam_Details_.Exam_Master_Id,
Exam_Details_.Question_Id,
Exam_Details_.Question_Name,
Exam_Details_.Option_1,
Exam_Details_.Option_2,
Exam_Details_.Option_3,
Exam_Details_.Option_4,
Exam_Details_.Question_Answer
],callback);
 }
 ,
 Delete_Exam_Details:function(Exam_Details_Id_,callback)
 { 
return db.query("CALL Delete_Exam_Details(@Exam_Details_Id_ :=?)",[Exam_Details_Id_],callback);
 }
 ,
 Get_Exam_Details:function(Exam_Details_Id_,callback)
 { 
return db.query("CALL Get_Exam_Details(@Exam_Details_Id_ :=?)",[Exam_Details_Id_],callback);
 }
 ,
 Search_Exam_Details:function(Exam_Details_Name_,callback)
 { 
 if (Exam_Details_Name_===undefined || Exam_Details_Name_==="undefined" )
Exam_Details_Name_='';
return db.query("CALL Search_Exam_Details(@Exam_Details_Name_ :=?)",[Exam_Details_Name_],callback);
 }
  };
  module.exports=Exam_Details;

