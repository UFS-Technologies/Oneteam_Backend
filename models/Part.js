 var db=require('../dbconnection');
 var fs = require('fs');
 var Part=
 { 
 Save_Part:function(Part_,callback)
 { 
return db.query("CALL Save_Part("+
"@Part_Id_ :=?,"+
"@Part_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Part_.Part_Id,
Part_.Part_Name,
Part_.User_Id
],callback);
 }
 ,
 Delete_Part:function(Part_Id_,callback)
 { 
return db.query("CALL Delete_Part(@Part_Id_ :=?)",[Part_Id_],callback);
 }
 ,
 Get_Part:function(Part_Id_,callback)
 { 
return db.query("CALL Get_Part(@Part_Id_ :=?)",[Part_Id_],callback);
 }
 ,
 Search_Part:function(Part_Name_,callback)
 { 
 if (Part_Name_===undefined || Part_Name_==="undefined" )
Part_Name_='';
return db.query("CALL Search_Part(@Part_Name_ :=?)",[Part_Name_],callback);
 }
  };
  module.exports=Part;

