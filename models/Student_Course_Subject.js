 var db=require('../dbconnection');
 var fs = require('fs');
 var Student_Course_Subject=
 { 
 Save_Student_Course_Subject:function(Student_Course_Subject_,callback)
 { 
return db.query("CALL Save_Student_Course_Subject("+
"@Student_Course_Subject_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Course_Id_ :=?,"+
"@Course_Name_ :=?,"+
"@Subject_Id_ :=?,"+
"@Subject_Name_ :=?,"+
"@Minimum_Mark_ :=?,"+
"@Maximum_Mark_ :=?,"+
"@Online_Exam_Statusuu7ytrefsertytrewertrfs_ :=?,"+
"@No_of_Question_ :=?,"+
"@Exam_Duration_ :=?,"+
"@Exam_Attended_Status_ :=?"+")"
 ,[Student_Course_Subject_.Student_Course_Subject_Id,
Student_Course_Subject_.Student_Id,
Student_Course_Subject_.Course_Id,
Student_Course_Subject_.Course_Name,
Student_Course_Subject_.Subject_Id,
Student_Course_Subject_.Subject_Name,
Student_Course_Subject_.Minimum_Mark,
Student_Course_Subject_.Maximum_Mark,
Student_Course_Subject_.Online_Exam_Statusuu7ytrefsertytrewertrfs,
Student_Course_Subject_.No_of_Question,
Student_Course_Subject_.Exam_Duration,
Student_Course_Subject_.Exam_Attended_Status
],callback);
 }
 ,
 Delete_Student_Course_Subject:function(Student_Course_Subject_Id_,callback)
 { 
return db.query("CALL Delete_Student_Course_Subject(@Student_Course_Subject_Id_ :=?)",[Student_Course_Subject_Id_],callback);
 }
 ,
 Get_Student_Course_Subject:function(Student_Course_Subject_Id_,callback)
 { 
return db.query("CALL Get_Student_Course_Subject(@Student_Course_Subject_Id_ :=?)",[Student_Course_Subject_Id_],callback);
 }
 ,
 Search_Student_Course_Subject:function(Student_Course_Subject_Name_,callback)
 { 
 if (Student_Course_Subject_Name_===undefined || Student_Course_Subject_Name_==="undefined" )
Student_Course_Subject_Name_='';
return db.query("CALL Search_Student_Course_Subject(@Student_Course_Subject_Name_ :=?)",[Student_Course_Subject_Name_],callback);
 }
  };
  module.exports=Student_Course_Subject;

