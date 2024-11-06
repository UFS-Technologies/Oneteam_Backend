 var db=require('../dbconnection');
 var fs = require('fs');
 var Course_Fees=
 { 
 Save_Course_Fees:function(Course_Fees_,callback)
 { 
return db.query("CALL Save_Course_Fees("+
"@Course_Fees_Id_ :=?,"+
"@Course_Id_ :=?,"+
"@Fees_Type_Id_ :=?,"+
"@Amount_ :=?,"+
"@No_Of_Instalment_ :=?,"+
"@Instalment_Period_ :=?"+")"
 ,[Course_Fees_.Course_Fees_Id,
Course_Fees_.Course_Id,
Course_Fees_.Fees_Type_Id,
Course_Fees_.Amount,
Course_Fees_.No_Of_Instalment,
Course_Fees_.Instalment_Period
],callback);
 }
 ,
 Delete_Course_Fees:function(Course_Fees_Id_,callback)
 { 
return db.query("CALL Delete_Course_Fees(@Course_Fees_Id_ :=?)",[Course_Fees_Id_],callback);
 }
 ,
 Get_Course_Fees:function(Course_Fees_Id_,callback)
 { 
return db.query("CALL Get_Course_Fees(@Course_Fees_Id_ :=?)",[Course_Fees_Id_],callback);
 }
 ,
 Search_Course_Fees:function(Course_Fees_Name_,callback)
 { 
 if (Course_Fees_Name_===undefined || Course_Fees_Name_==="undefined" )
Course_Fees_Name_='';
return db.query("CALL Search_Course_Fees(@Course_Fees_Name_ :=?)",[Course_Fees_Name_],callback);
 }
  };
  module.exports=Course_Fees;

