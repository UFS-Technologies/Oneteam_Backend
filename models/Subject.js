 var db=require('../dbconnection');
 var fs = require('fs');
 var Subject=
 { 
 Save_Subject:function(Subject_,callback)
 { 
return db.query("CALL Save_Subject("+
"@Subject_Id_ :=?,"+
"@Subject_Name_ :=?,"+
"@Exam_status_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Subject_.Subject_Id,
Subject_.Subject_Name,
Subject_.Exam_status,
Subject_.User_Id
],callback);
 }
 ,
 Delete_Subject:function(Subject_Id_,callback)
 { 
return db.query("CALL Delete_Subject(@Subject_Id_ :=?)",[Subject_Id_],callback);
 }
 ,
 Get_Subject:function(Subject_Id_,callback)
 { 
return db.query("CALL Get_Subject(@Subject_Id_ :=?)",[Subject_Id_],callback);
 }
 ,
 Search_Subject:function(Subject_Name_,callback)
 { 
 if (Subject_Name_===undefined || Subject_Name_==="undefined" )
Subject_Name_='';
return db.query("CALL Search_Subject(@Subject_Name_ :=?)",[Subject_Name_],callback);
 }
  };
  module.exports=Subject;

