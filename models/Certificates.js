 var db=require('../dbconnection');
 var fs = require('fs');
 var Certificates=
 { 
 Save_Certificates:function(Certificates_,callback)
 { 
return db.query("CALL Save_Certificates("+
"@Certificates_Id_ :=?,"+
"@Certificates_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Certificates_.Certificates_Id,
Certificates_.Certificates_Name,
Certificates_.User_Id
],callback);
 }
 ,
 Delete_Certificates:function(Certificates_Id_,callback)
 { 
return db.query("CALL Delete_Certificates(@Certificates_Id_ :=?)",[Certificates_Id_],callback);
 }
 ,
 Get_Certificates:function(Certificates_Id_,callback)
 { 
return db.query("CALL Get_Certificates(@Certificates_Id_ :=?)",[Certificates_Id_],callback);
 }
 ,
 Search_Certificates:function(Certificates_Name_,callback)
 { 
 if (Certificates_Name_===undefined || Certificates_Name_==="undefined" )
Certificates_Name_='';
return db.query("CALL Search_Certificates(@Certificates_Name_ :=?)",[Certificates_Name_],callback);
 }
  };
  module.exports=Certificates;

