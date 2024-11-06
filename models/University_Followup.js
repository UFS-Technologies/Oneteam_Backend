 var db=require('../dbconnection');
 var fs = require('fs');
 var University_Followup=
 { 
 Save_University_Followup:function(University_Followup_,callback)
 { 
return db.query("CALL Save_University_Followup("+
"@University_Followup_Id_ :=?,"+
"@University_Id_ :=?,"+
"@Entry_Date_ :=?,"+
"@Next_FollowUp_Date_ :=?,"+
"@FollowUp_Difference_ :=?,"+
"@Status_ :=?,"+
"@User_Id_ :=?,"+
"@Remark_ :=?,"+
"@Remark_Id_ :=?,"+
"@FollowUp_Type_ :=?,"+
"@FollowUP_Time_ :=?,"+
"@Actual_FollowUp_Date_ :=?,"+
"@Entry_Type_ :=?"+")"
 ,[University_Followup_.University_Followup_Id,
University_Followup_.University_Id,
University_Followup_.Entry_Date,
University_Followup_.Next_FollowUp_Date,
University_Followup_.FollowUp_Difference,
University_Followup_.Status,
University_Followup_.User_Id,
University_Followup_.Remark,
University_Followup_.Remark_Id,
University_Followup_.FollowUp_Type,
University_Followup_.FollowUP_Time,
University_Followup_.Actual_FollowUp_Date,
University_Followup_.Entry_Type
],callback);
 }
 ,
 Delete_University_Followup:function(University_Followup_Id_,callback)
 { 
return db.query("CALL Delete_University_Followup(@University_Followup_Id_ :=?)",[University_Followup_Id_],callback);
 }
 ,
 Get_University_Followup:function(University_Followup_Id_,callback)
 { 
return db.query("CALL Get_University_Followup(@University_Followup_Id_ :=?)",[University_Followup_Id_],callback);
 }
 ,
 Search_University_Followup:function(University_Followup_Name_,callback)
 { 
 if (University_Followup_Name_===undefined || University_Followup_Name_==="undefined" )
University_Followup_Name_='';
return db.query("CALL Search_University_Followup(@University_Followup_Name_ :=?)",[University_Followup_Name_],callback);
 }
  };
  module.exports=University_Followup;

