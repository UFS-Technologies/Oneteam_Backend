 var db=require('../dbconnection');
 var fs = require('fs');
 var User_Role=
 { 
 Save_User_Role:function(User_Role_,callback)
 { 
return db.query("CALL Save_User_Role("+
"@User_Role_Id_ :=?,"+
"@User_Role_Name_ :=?,"+
"@Role_Under_Id_ :=?"+")"
 ,[User_Role_.User_Role_Id,
User_Role_.User_Role_Name,
User_Role_.Role_Under_Id
],callback);
 }
 ,
 Delete_User_Role:function(User_Role_Id_,callback)
 { 
return db.query("CALL Delete_User_Role(@User_Role_Id_ :=?)",[User_Role_Id_],callback);
 }
 ,
 Get_User_Role:function(User_Role_Id_,callback)
 { 
return db.query("CALL Get_User_Role(@User_Role_Id_ :=?)",[User_Role_Id_],callback);
 }
 ,
 Search_User_Role:function(User_Role_Name_,callback)
 { 
 if (User_Role_Name_===undefined || User_Role_Name_==="undefined" )
User_Role_Name_='';
return db.query("CALL Search_User_Role(@User_Role_Name_ :=?)",[User_Role_Name_],callback);
 }
  };
  module.exports=User_Role;

