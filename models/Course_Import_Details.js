 var db=require('../dbconnection');
 var fs = require('fs');
 var Course_Import_Details=
 { 
 Save_Course_Import_Details:function(Course_Import_Details_,callback)
 { 
return db.query("CALL Save_Course_Import_Details("+
"@Course_Import_Details_Id_ :=?,"+
"@Course_Import_Master_Id_ :=?,"+
"@Course_Id_ :=?"+")"
 ,[Course_Import_Details_.Course_Import_Details_Id,
Course_Import_Details_.Course_Import_Master_Id,
Course_Import_Details_.Course_Id
],callback);
 }
 ,
 Delete_Course_Import_Details:function(Course_Import_Details_Id_,callback)
 { 
return db.query("CALL Delete_Course_Import_Details(@Course_Import_Details_Id_ :=?)",[Course_Import_Details_Id_],callback);
 }
 ,
 Get_Course_Import_Details:function(Course_Import_Details_Id_,callback)
 { 
return db.query("CALL Get_Course_Import_Details(@Course_Import_Details_Id_ :=?)",[Course_Import_Details_Id_],callback);
 }
 ,
 Search_Course_Import_Details:function(Course_Import_Details_Name_,callback)
 { 
 if (Course_Import_Details_Name_===undefined || Course_Import_Details_Name_==="undefined" )
Course_Import_Details_Name_='';
return db.query("CALL Search_Course_Import_Details(@Course_Import_Details_Name_ :=?)",[Course_Import_Details_Name_],callback);
 }
  };
  module.exports=Course_Import_Details;

