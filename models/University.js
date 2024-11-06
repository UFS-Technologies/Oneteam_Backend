 var db=require('../dbconnection');
 var fs = require('fs');
 var University=
 { 
 Save_University:function(University_,callback)
 { 
return db.query("CALL Save_University("+
"@University_Id_ :=?,"+
"@University_Name_ :=?,"+
"@Address1_ :=?,"+
"@Address2_ :=?,"+
"@Address3_ :=?,"+
"@Address4_ :=?,"+
"@Pincode_ :=?,"+
"@Phone_ :=?,"+
"@Mobile_ :=?,"+
"@Email_ :=?,"+
"@User_Id_ :=?"+")"
 ,[University_.University_Id,
University_.University_Name,
University_.Address1,
University_.Address2,
University_.Address3,
University_.Address4,
University_.Pincode,
University_.Phone,
University_.Mobile,
University_.Email,
University_.User_Id
],callback);
 }
 ,
 Delete_University:function(University_Id_,callback)
 { 
return db.query("CALL Delete_University(@University_Id_ :=?)",[University_Id_],callback);
 }
 ,
 Get_University:function(University_Id_,callback)
 { 
return db.query("CALL Get_University(@University_Id_ :=?)",[University_Id_],callback);
 }
 ,
 Search_University:function(University_Name_,callback)
 { 
 if (University_Name_===undefined || University_Name_==="undefined" )
University_Name_='';
return db.query("CALL Search_University(@University_Name_ :=?)",[University_Name_],callback);
 }
  };
  module.exports=University;

