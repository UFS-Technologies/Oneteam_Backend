 var db=require('../dbconnection');
 var fs = require('fs');
 var Followup_Type=
 { 
 Save_Followup_Type:function(Followup_Type_,callback)
 { 
return db.query("CALL Save_Followup_Type("+
"@Followup_Type_Id_ :=?,"+
"@Followup_Type_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Followup_Type_.Followup_Type_Id,
Followup_Type_.Followup_Type_Name,
Followup_Type_.User_Id
],callback);
 }
 ,
 Delete_Followup_Type:function(Followup_Type_Id_,callback)
 { 
return db.query("CALL Delete_Followup_Type(@Followup_Type_Id_ :=?)",[Followup_Type_Id_],callback);
 }
 ,
 Get_Followup_Type:function(Followup_Type_Id_,callback)
 { 
return db.query("CALL Get_Followup_Type(@Followup_Type_Id_ :=?)",[Followup_Type_Id_],callback);
 }
 ,
 Search_Followup_Type:function(Followup_Type_Name_,callback)
 { 
 if (Followup_Type_Name_===undefined || Followup_Type_Name_==="undefined" )
Followup_Type_Name_='';
return db.query("CALL Search_Followup_Type(@Followup_Type_Name_ :=?)",[Followup_Type_Name_],callback);
 }
  };
  module.exports=Followup_Type;

