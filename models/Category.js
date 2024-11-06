 var db=require('../dbconnection');
 var fs = require('fs');
 var Category=
 { 
 Save_Category:function(Category_,callback)
 { 
return db.query("CALL Save_Category("+
"@Category_Id_ :=?,"+
"@Category_Name_ :=?,"+
"@Commision_Percentage_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Category_.Category_Id,
Category_.Category_Name,
Category_.Commision_Percentage,
Category_.User_Id
],callback);
 }
 ,
 Delete_Category:function(Category_Id_,callback)
 { 
return db.query("CALL Delete_Category(@Category_Id_ :=?)",[Category_Id_],callback);
 }
 ,
 Get_Category:function(Category_Id_,callback)
 { 
return db.query("CALL Get_Category(@Category_Id_ :=?)",[Category_Id_],callback);
 }
 ,
 Search_Category:function(Category_Name_,callback)
 { 
 if (Category_Name_===undefined || Category_Name_==="undefined" )
Category_Name_='';
return db.query("CALL Search_Category(@Category_Name_ :=?)",[Category_Name_],callback);
 }
  };
  module.exports=Category;

