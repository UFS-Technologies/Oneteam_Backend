 var db=require('../dbconnection');
 var fs = require('fs');
 var Student_Course=
 { 
 Save_Student_Course:function(Student_Course_,callback)
 { 
return db.query("CALL Save_Student_Course("+
"@Student_Course_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Entry_Date_ :=?,"+
"@Course_Name_Details_ :=?,"+
"@Course_Id_ :=?,"+
"@Course_Name_ :=?,"+
"@Start_Date_ :=?,"+
"@End_Date_ :=?,"+
"@Join_Date_ :=?,"+
"@By_User_Id_ :=?,"+
"@Status_ :=?,"+
"@Start_Time_ :=?,"+
"@End_Time_ :=?"+")"
 ,[Student_Course_.Student_Course_Id,
Student_Course_.Student_Id,
Student_Course_.Entry_Date,
Student_Course_.Course_Name_Details,
Student_Course_.Course_Id,
Student_Course_.Course_Name,
Student_Course_.Start_Date,
Student_Course_.End_Date,
Student_Course_.Join_Date,
Student_Course_.By_User_Id,
Student_Course_.Status,
Student_Course_.Start_Time,
Student_Course_.End_Time
],callback);
 }
 ,
 Delete_Student_Course:function(Student_Course_Id_,callback)
 { 
return db.query("CALL Delete_Student_Course(@Student_Course_Id_ :=?)",[Student_Course_Id_],callback);
 }
 ,
 Get_Student_Course:function(Student_Course_Id_,callback)
 { 
return db.query("CALL Get_Student_Course(@Student_Course_Id_ :=?)",[Student_Course_Id_],callback);
 }
 ,
 Search_Student_Course:function(Student_Course_Name_,callback)
 { 
 if (Student_Course_Name_===undefined || Student_Course_Name_==="undefined" )
Student_Course_Name_='';
return db.query("CALL Search_Student_Course(@Student_Course_Name_ :=?)",[Student_Course_Name_],callback);
 }
  };
  module.exports=Student_Course;

