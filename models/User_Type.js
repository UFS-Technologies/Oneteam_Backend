 var db=require('../dbconnection');
 var fs = require('fs');
 var User_Type=
 { 
 Save_User_Type:function(User_Type_,callback)
 { 
return db.query("CALL Save_User_Type("+
"@User_Type_Id_ :=?,"+
"@User_Type_Name_ :=?"+")"
 ,[User_Type_.User_Type_Id,
User_Type_.User_Type_Name
],callback);
 }
 ,
 Delete_User_Type:function(User_Type_Id_,callback)
 { 
return db.query("CALL Delete_User_Type(@User_Type_Id_ :=?)",[User_Type_Id_],callback);
 }
 ,
 Get_User_Type:function(User_Type_Id_,callback)
 { 
return db.query("CALL Get_User_Type(@User_Type_Id_ :=?)",[User_Type_Id_],callback);
 }
 ,
 Search_User_Type:function(User_Type_Name_,callback)
 { 
 if (User_Type_Name_===undefined || User_Type_Name_==="undefined" )
User_Type_Name_='';
return db.query("CALL Search_User_Type(@User_Type_Name_ :=?)",[User_Type_Name_],callback);
 }
  };
  module.exports=User_Type;

