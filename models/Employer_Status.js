 var db=require('../dbconnection');
 var fs = require('fs');
 var Status=
 { 
 Save_Employer_Status:function(Status_,callback)
 { 
    console.log(Status_);
return db.query("CALL Save_Employer_Status("+"@Employer_Status_Id_ :=?,"+"@Employer_Status_Name_ :=?,"+"@FollowUp_ :=?,"+"@User_Id_ :=?"+")"
 ,[Status_.Employer_Status_Id, Status_.Employer_Status_Name,Status_.FollowUp,Status_.User_Id],callback);
 }
 ,
 Delete_Employer_Status:function(Status_Id_,callback)
 { 
return db.query("CALL Delete_Employer_Status(@Employer_Status_Id_ :=?)",[Status_Id_],callback);
 }
 ,
 Get_Employer_Status:function(Status_Id_,callback)
 { 
return db.query("CALL Get_Employer_Status(@Employer_Status_Id_ :=?)",[Status_Id_],callback);
 }
 ,
 Search_Employer_Status:function(Status_Name_,callback)
 { 
 if (Status_Name_===undefined || Status_Name_==="undefined" )
Status_Name_='';
return db.query("CALL Search_Employer_Status(@Employer_Status_Name_ :=?)",[Status_Name_],callback);
 }



,


 Save_Vacancy_Source:function(Vacancy_Source_,callback)
 { 
    console.log(Vacancy_Source_);
return db.query("CALL Save_Vacancy_Source("+"@Vacancy_Source_Id_ :=?,"+"@Vacancy_Source_Name_ :=?"+")"
 ,[Vacancy_Source_.Vacancy_Source_Id, Vacancy_Source_.Vacancy_Source_Name],callback);
 }
 ,
 Delete_Vacancy_Source:function(Vacancy_Source_Id_,callback)
 { 
return db.query("CALL Delete_Vacancy_Source(@Vacancy_Source_Id_ :=?)",[Vacancy_Source_Id_],callback);
 }
 ,
 Get_Vacancy_Source:function(Vacancy_Source_Id_,callback)
 { 
return db.query("CALL Get_Vacancy_Source(@Vacancy_Source_Id_ :=?)",[Vacancy_Source_Id_],callback);
 }
 ,
 Search_Vacancy_Source:function(Vacancy_Source_Name_,callback)
 { 
 if (Vacancy_Source_Name_===undefined || Vacancy_Source_Name_==="undefined" )
Vacancy_Source_Name_='';
return db.query("CALL Search_Vacancy_Source(@Vacancy_Source_Name_ :=?)",[Vacancy_Source_Name_],callback);
 }






  };
  module.exports=Status;

