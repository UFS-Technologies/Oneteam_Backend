 var db=require('../dbconnection');
 var fs = require('fs');
 var Qualification=
 { 
 Save_Qualification:function(Qualification_,callback)
 { 
return db.query("CALL Save_Qualification("+
"@Qualification_Id_ :=?,"+
"@Qualification_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Qualification_.Qualification_Id,
Qualification_.Qualification_Name,
Qualification_.User_Id
],callback);
 }
 ,
 Delete_Qualification:function(Qualification_Id_,callback)
 { 
return db.query("CALL Delete_Qualification(@Qualification_Id_ :=?)",[Qualification_Id_],callback);
 }
 ,
 Get_Qualification:function(Qualification_Id_,callback)
 { 
return db.query("CALL Get_Qualification(@Qualification_Id_ :=?)",[Qualification_Id_],callback);
 }
 ,
 Search_Qualification:function(Qualification_Name_,callback)
 { 
 if (Qualification_Name_===undefined || Qualification_Name_==="undefined" )
Qualification_Name_='';
return db.query("CALL Search_Qualification(@Qualification_Name_ :=?)",[Qualification_Name_],callback);
 }
  };
  module.exports=Qualification;

