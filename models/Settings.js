 var db=require('../dbconnection');
 var fs = require('fs');
 var Settings=
 { 
 Save_Settings:function(Settings_,callback)
 { 
return db.query("CALL Save_Settings("+
"@Settings_Id_ :=?,"+
"@Settings_Name_ :=?,"+
"@Settings_Group_ :=?"+")"
 ,[Settings_.Settings_Id,
Settings_.Settings_Name,
Settings_.Settings_Group
],callback);
 }
 ,
 Delete_Settings:function(Settings_Id_,callback)
 { 
return db.query("CALL Delete_Settings(@Settings_Id_ :=?)",[Settings_Id_],callback);
 }
 ,
 Get_Settings:function(Settings_Id_,callback)
 { 
return db.query("CALL Get_Settings(@Settings_Id_ :=?)",[Settings_Id_],callback);
 }
 ,
 Search_Settings:function(Settings_Name_,callback)
 { 
 if (Settings_Name_===undefined || Settings_Name_==="undefined" )
Settings_Name_='';
return db.query("CALL Search_Settings(@Settings_Name_ :=?)",[Settings_Name_],callback);
 }
  };
  module.exports=Settings;

