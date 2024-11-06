 var db=require('../dbconnection');
 var fs = require('fs');
 var Course_Type=
 { 
 Save_Course_Type:function(Course_Type_,callback)
 { 
return db.query("CALL Save_Course_Type("+
"@Course_Type_Id_ :=?,"+
"@Course_Type_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Course_Type_.Course_Type_Id,
Course_Type_.Course_Type_Name,
Course_Type_.User_Id
],callback);
 }
 ,
 Delete_Course_Type:function(Course_Type_Id_,callback)
 { 
return db.query("CALL Delete_Course_Type(@Course_Type_Id_ :=?)",[Course_Type_Id_],callback);
 }
 ,
 Get_Course_Type:function(Course_Type_Id_,callback)
 { 
return db.query("CALL Get_Course_Type(@Course_Type_Id_ :=?)",[Course_Type_Id_],callback);
 }
 ,
 Search_Course_Type:function(Course_Type_Name_,callback)
 { 
 if (Course_Type_Name_===undefined || Course_Type_Name_==="undefined" )
Course_Type_Name_='';
return db.query("CALL Search_Course_Type(@Course_Type_Name_ :=?)",[Course_Type_Name_],callback);
 }
  };
  module.exports=Course_Type;

