 var db=require('../dbconnection');
 var fs = require('fs');
 var Candidate_Followup=
 { 
 Save_Candidate_Followup:function(Candidate_Followup_,callback)
 { 
return db.query("CALL Save_Candidate_Followup("+
"@Candidate_Followup_Id_ :=?,"+
"@Candidate_Id_ :=?,"+
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
 ,[Candidate_Followup_.Candidate_Followup_Id,
Candidate_Followup_.Candidate_Id,
Candidate_Followup_.Entry_Date,
Candidate_Followup_.Next_FollowUp_Date,
Candidate_Followup_.FollowUp_Difference,
Candidate_Followup_.Status,
Candidate_Followup_.User_Id,
Candidate_Followup_.Remark,
Candidate_Followup_.Remark_Id,
Candidate_Followup_.FollowUp_Type,
Candidate_Followup_.FollowUP_Time,
Candidate_Followup_.Actual_FollowUp_Date,
Candidate_Followup_.Entry_Type
],callback);
 }
 ,
 Delete_Candidate_Followup:function(Candidate_Followup_Id_,callback)
 { 
return db.query("CALL Delete_Candidate_Followup(@Candidate_Followup_Id_ :=?)",[Candidate_Followup_Id_],callback);
 }
 ,
 Get_Candidate_Followup:function(Candidate_Followup_Id_,callback)
 { 
return db.query("CALL Get_Candidate_Followup(@Candidate_Followup_Id_ :=?)",[Candidate_Followup_Id_],callback);
 }
 ,
 Search_Candidate_Followup:function(Candidate_Followup_Name_,callback)
 { 
 if (Candidate_Followup_Name_===undefined || Candidate_Followup_Name_==="undefined" )
Candidate_Followup_Name_='';
return db.query("CALL Search_Candidate_Followup(@Candidate_Followup_Name_ :=?)",[Candidate_Followup_Name_],callback);
 }
  };
  module.exports=Candidate_Followup;

