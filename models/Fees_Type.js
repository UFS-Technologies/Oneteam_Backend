 var db=require('../dbconnection');
 var fs = require('fs');
 var Fees_Type=
 { 
 Save_Fees_Type:function(Fees_Type_,callback)
 { 
return db.query("CALL Save_Fees_Type("+
"@Fees_Type_Id_ :=?,"+
"@Fees_Type_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Fees_Type_.Fees_Type_Id,
Fees_Type_.Fees_Type_Name,
Fees_Type_.User_Id
],callback);
 }
 ,
 Delete_Fees_Type:function(Fees_Type_Id_,callback)
 { 
return db.query("CALL Delete_Fees_Type(@Fees_Type_Id_ :=?)",[Fees_Type_Id_],callback);
 }
 ,
 Get_Fees_Type:function(Fees_Type_Id_,callback)
 { 
return db.query("CALL Get_Fees_Type(@Fees_Type_Id_ :=?)",[Fees_Type_Id_],callback);
 }
 ,
 Search_Fees_Type:function(Fees_Type_Name_,callback)
 { 
 if (Fees_Type_Name_===undefined || Fees_Type_Name_==="undefined" )
Fees_Type_Name_='';
return db.query("CALL Search_Fees_Type(@Fees_Type_Name_ :=?)",[Fees_Type_Name_],callback);
 }
  };
  module.exports=Fees_Type;

