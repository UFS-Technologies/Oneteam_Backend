 var db=require('../dbconnection');
 var fs = require('fs');
 var Specialization=
 { 
 Save_Specialization:function(Specialization_,callback)
 { 
return db.query("CALL Save_Specialization("+
"@Specialization_Id_ :=?,"+
"@Specialization_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Specialization_.Specialization_Id,
Specialization_.Specialization_Name,
Specialization_.User_Id
],callback);
 }
 ,
 Delete_Specialization:function(Specialization_Id_,callback)
 { 
return db.query("CALL Delete_Specialization(@Specialization_Id_ :=?)",[Specialization_Id_],callback);
 }
 ,
 Get_Specialization:function(Specialization_Id_,callback)
 { 
return db.query("CALL Get_Specialization(@Specialization_Id_ :=?)",[Specialization_Id_],callback);
 }
 ,
 Search_Specialization:function(Specialization_Name_,callback)
 { 
 if (Specialization_Name_===undefined || Specialization_Name_==="undefined" )
Specialization_Name_='';
return db.query("CALL Search_Specialization(@Specialization_Name_ :=?)",[Specialization_Name_],callback);
 }
  };
  module.exports=Specialization;

