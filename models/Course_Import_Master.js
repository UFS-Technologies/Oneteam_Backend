 var db=require('../dbconnection');
 var fs = require('fs');
 var Course_Import_Master=
 { 
 Save_Course_Import_Master:function(Course_Import_Master_,callback)
 { 
return db.query("CALL Save_Course_Import_Master("+
"@Course_Import_Master_Id_ :=?,"+
"@Date_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Course_Import_Master_.Course_Import_Master_Id,
Course_Import_Master_.Date,
Course_Import_Master_.User_Id
],callback);
 }
 ,
 Delete_Course_Import_Master:function(Course_Import_Master_Id_,callback)
 { 
return db.query("CALL Delete_Course_Import_Master(@Course_Import_Master_Id_ :=?)",[Course_Import_Master_Id_],callback);
 }
 ,
 Get_Course_Import_Master:function(Course_Import_Master_Id_,callback)
 { 
return db.query("CALL Get_Course_Import_Master(@Course_Import_Master_Id_ :=?)",[Course_Import_Master_Id_],callback);
 }
 ,
 Search_Course_Import_Master:function(Course_Import_Master_Name_,callback)
 { 
 if (Course_Import_Master_Name_===undefined || Course_Import_Master_Name_==="undefined" )
Course_Import_Master_Name_='';
return db.query("CALL Search_Course_Import_Master(@Course_Import_Master_Name_ :=?)",[Course_Import_Master_Name_],callback);
 }
  };
  module.exports=Course_Import_Master;

