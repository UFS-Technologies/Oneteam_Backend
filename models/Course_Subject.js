 var db=require('../dbconnection');
 var fs = require('fs');
 var Course_Subject=
 { 
 Save_Course_Subject:function(Course_Subject_,callback)
 { 
return db.query("CALL Save_Course_Subject("+
"@Course_Subject_Id_ :=?,"+
"@Course_Id_ :=?,"+
"@Part_Id_ :=?,"+
"@Subject_Id_ :=?,"+
"@Subject_Name_ :=?,"+
"@Minimum_Mark_ :=?,"+
"@Maximum_Mark_ :=?,"+
"@Online_Exam_Status_ :=?,"+
"@No_of_Question_ :=?,"+
"@Exam_Duration_ :=?"+")"
 ,[Course_Subject_.Course_Subject_Id,
Course_Subject_.Course_Id,
Course_Subject_.Part_Id,
Course_Subject_.Subject_Id,
Course_Subject_.Subject_Name,
Course_Subject_.Minimum_Mark,
Course_Subject_.Maximum_Mark,
Course_Subject_.Online_Exam_Status,
Course_Subject_.No_of_Question,
Course_Subject_.Exam_Duration
],callback);
 }
 ,
 Delete_Course_Subject:function(Course_Subject_Id_,callback)
 { 
return db.query("CALL Delete_Course_Subject(@Course_Subject_Id_ :=?)",[Course_Subject_Id_],callback);
 }
 ,
 Get_Course_Subject:function(Course_Subject_Id_,callback)
 { 
return db.query("CALL Get_Course_Subject(@Course_Subject_Id_ :=?)",[Course_Subject_Id_],callback);
 }
 ,
 Search_Course_Subject:function(Course_Subject_Name_,callback)
 { 
 if (Course_Subject_Name_===undefined || Course_Subject_Name_==="undefined" )
Course_Subject_Name_='';
return db.query("CALL Search_Course_Subject(@Course_Subject_Name_ :=?)",[Course_Subject_Name_],callback);
 }
  };
  module.exports=Course_Subject;

