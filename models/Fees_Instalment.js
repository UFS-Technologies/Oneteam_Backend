 var db=require('../dbconnection');
 var fs = require('fs');
 var Fees_Instalment=
 { 
 Save_Fees_Instalment:function(Fees_Instalment_,callback)
 { 
return db.query("CALL Save_Fees_Instalment("+
"@Fees_Instalment_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Course_Id_ :=?,"+
"@Fees_Type_Id_ :=?,"+
"@Instalment_Date_ :=?,"+
"@Amount_ :=?,"+
"@Status_ :=?"+")"
 ,[Fees_Instalment_.Fees_Instalment_Id,
Fees_Instalment_.Student_Id,
Fees_Instalment_.Course_Id,
Fees_Instalment_.Fees_Type_Id,
Fees_Instalment_.Instalment_Date,
Fees_Instalment_.Amount,
Fees_Instalment_.Status
],callback);
 }
 ,
 Delete_Fees_Instalment:function(Fees_Instalment_Id_,callback)
 { 
return db.query("CALL Delete_Fees_Instalment(@Fees_Instalment_Id_ :=?)",[Fees_Instalment_Id_],callback);
 }
 ,
 Get_Fees_Instalment:function(Fees_Instalment_Id_,callback)
 { 
return db.query("CALL Get_Fees_Instalment(@Fees_Instalment_Id_ :=?)",[Fees_Instalment_Id_],callback);
 }
 ,
 Search_Fees_Instalment:function(Fees_Instalment_Name_,callback)
 { 
 if (Fees_Instalment_Name_===undefined || Fees_Instalment_Name_==="undefined" )
Fees_Instalment_Name_='';
return db.query("CALL Search_Fees_Instalment(@Fees_Instalment_Name_ :=?)",[Fees_Instalment_Name_],callback);
 }
  };
  module.exports=Fees_Instalment;

