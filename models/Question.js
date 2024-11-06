 var db=require('../dbconnection');
 var fs = require('fs');
 var Question=
 { 
 Save_Question:function(Question_,callback)
 { 
return db.query("CALL Save_Question("+
"@Question_Id_ :=?,"+
"@Question_Name_ :=?,"+
"@Option_1_ :=?,"+
"@Option_2_ :=?,"+
"@Option_3_ :=?,"+
"@Option_4_ :=?,"+
"@Correct_Answer_ :=?,"+
"@Subject_Id_ :=?,"+
"@Subject_Name_ :=?,"+
"@Course_Id_ :=?,"+
"@Course_Name_ :=?,"+
"@Semester_Id_ :=?,"+
"@Semester_Name_ :=?"+")"
 ,[Question_.Question_Id,
Question_.Question_Name,
Question_.Option_1,
Question_.Option_2,
Question_.Option_3,
Question_.Option_4,
Question_.Correct_Answer,
Question_.Subject_Id,
Question_.Subject_Name,
Question_.Course_Id,
Question_.Course_Name,
Question_.Semester_Id,
Question_.Semester_Name
],callback);
 }
 ,
 Delete_Question:function(Question_Id_,callback)
 { 
return db.query("CALL Delete_Question(@Question_Id_ :=?)",[Question_Id_],callback);
 }
 ,
 Get_Question:function(Question_Id_,callback)
 { 
return db.query("CALL Get_Question(@Question_Id_ :=?)",[Question_Id_],callback);
 }
 ,
 Search_Question:function(Question_Name_,callback)
 { 
 if (Question_Name_===undefined || Question_Name_==="undefined" )
Question_Name_='';
return db.query("CALL Search_Question(@Question_Name_ :=?)",[Question_Name_],callback);
 }
  };
  module.exports=Question;

