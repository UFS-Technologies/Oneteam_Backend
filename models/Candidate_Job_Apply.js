 var db=require('../dbconnection');
 var fs = require('fs');
 var Candidate_Job_Apply=
 { 
 Save_Candidate_Job_Apply:function(Candidate_Job_Apply_,callback)
 { 
return db.query("CALL Save_Candidate_Job_Apply("+
"@Candidate_Job_Apply_Id_ :=?,"+
"@Candidate_Id_ :=?,"+
"@Entry_Date_ :=?,"+
"@Skills_ :=?,"+
"@Designation_ :=?,"+
"@Functional_Area_Id_ :=?,"+
"@Functional_Area_Name_ :=?,"+
"@Specialization_Id_ :=?,"+
"@Specialization_Name_ :=?,"+
"@Experience_Id_ :=?,"+
"@Experience_Name_ :=?,"+
"@Qualification_Id_ :=?,"+
"@Qualification_Name_ :=?,"+
"@Remark_ :=?,"+
"@Resume_ :=?,"+
"@Experience_Certificate_ :=?,"+
"@Photo_ :=?,"+
"@Status_Id_ :=?,"+
"@Status_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Candidate_Job_Apply_.Candidate_Job_Apply_Id,
Candidate_Job_Apply_.Candidate_Id,
Candidate_Job_Apply_.Entry_Date,
Candidate_Job_Apply_.Skills,
Candidate_Job_Apply_.Designation,
Candidate_Job_Apply_.Functional_Area_Id,
Candidate_Job_Apply_.Functional_Area_Name,
Candidate_Job_Apply_.Specialization_Id,
Candidate_Job_Apply_.Specialization_Name,
Candidate_Job_Apply_.Experience_Id,
Candidate_Job_Apply_.Experience_Name,
Candidate_Job_Apply_.Qualification_Id,
Candidate_Job_Apply_.Qualification_Name,
Candidate_Job_Apply_.Remark,
Candidate_Job_Apply_.Resume,
Candidate_Job_Apply_.Experience_Certificate,
Candidate_Job_Apply_.Photo,
Candidate_Job_Apply_.Status_Id,
Candidate_Job_Apply_.Status_Name,
Candidate_Job_Apply_.User_Id
],callback);
 }
 ,
 Delete_Candidate_Job_Apply:function(Candidate_Job_Apply_Id_,callback)
 { 
return db.query("CALL Delete_Candidate_Job_Apply(@Candidate_Job_Apply_Id_ :=?)",[Candidate_Job_Apply_Id_],callback);
 }
 ,
 Get_Candidate_Job_Apply:function(Candidate_Job_Apply_Id_,callback)
 { 
return db.query("CALL Get_Candidate_Job_Apply(@Candidate_Job_Apply_Id_ :=?)",[Candidate_Job_Apply_Id_],callback);
 }
 ,
 Search_Candidate_Job_Apply:function(Candidate_Job_Apply_Name_,callback)
 { 
 if (Candidate_Job_Apply_Name_===undefined || Candidate_Job_Apply_Name_==="undefined" )
Candidate_Job_Apply_Name_='';
return db.query("CALL Search_Candidate_Job_Apply(@Candidate_Job_Apply_Name_ :=?)",[Candidate_Job_Apply_Name_],callback);
 }
  };
  module.exports=Candidate_Job_Apply;

