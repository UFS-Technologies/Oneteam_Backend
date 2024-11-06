 var db=require('../dbconnection');
 var fs = require('fs');
 var Student_Followup=
 { 
 Save_Student_Followup:function(Student_Followup_,callback)
 { 
return db.query("CALL Save_Student_Followup("+
"@Student_Followup_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Entry_Date_ :=?,"+
"@Next_FollowUp_Date_ :=?,"+
"@FollowUp_Difference_ :=?,"+
"@Status_ :=?,"+
"@User_Id_ :=?,"+
"@Remark_ :=?,"+
"@Remark_Id_ :=?,"+
"@FollowUp_Type_ :=?,"+
"@FollowUP_Time_ :=?,"+
"@Actual_FollowUp_Date_ :=?"+")"
 ,[Student_Followup_.Student_Followup_Id,
Student_Followup_.Student_Id,
Student_Followup_.Entry_Date,
Student_Followup_.Next_FollowUp_Date,
Student_Followup_.FollowUp_Difference,
Student_Followup_.Status,
Student_Followup_.User_Id,
Student_Followup_.Remark,
Student_Followup_.Remark_Id,
Student_Followup_.FollowUp_Type,
Student_Followup_.FollowUP_Time,
Student_Followup_.Actual_FollowUp_Date
],callback);
 }
 ,
 Delete_Student_Followup:function(Student_Followup_Id_,callback)
 { 
return db.query("CALL Delete_Student_Followup(@Student_Followup_Id_ :=?)",[Student_Followup_Id_],callback);
 }
 ,
 Get_Student_Followup:function(Student_Followup_Id_,callback)
 { 
return db.query("CALL Get_Student_Followup(@Student_Followup_Id_ :=?)",[Student_Followup_Id_],callback);
 }
 ,
 Search_Student_Followup:function(Student_Followup_Name_,callback)
 { 
 if (Student_Followup_Name_===undefined || Student_Followup_Name_==="undefined" )
Student_Followup_Name_='';
return db.query("CALL Search_Student_Followup(@Student_Followup_Name_ :=?)",[Student_Followup_Name_],callback);
 }
  };
  module.exports=Student_Followup;

