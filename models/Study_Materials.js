 var db=require('../dbconnection');
 var fs = require('fs');
 var Study_Materials=
 { 
 Save_Study_Materials:function(Study_Materials_,callback)
 { 
return db.query("CALL Save_Study_Materials("+
"@Study_Materials_Id_ :=?,"+
"@Course_Id_ :=?,"+
"@Part_Id_ :=?,"+
"@Subject_Id_ :=?,"+
"@Course_Subject_Id_ :=?,"+
"@Study_Materials_Name_ :=?,"+
"@File_Name_ :=?"+")"
 ,[Study_Materials_.Study_Materials_Id,
Study_Materials_.Course_Id,
Study_Materials_.Part_Id,
Study_Materials_.Subject_Id,
Study_Materials_.Course_Subject_Id,
Study_Materials_.Study_Materials_Name,
Study_Materials_.File_Name
],callback);
 }
 ,
 Delete_Study_Materials:function(Study_Materials_Id_,callback)
 { 
return db.query("CALL Delete_Study_Materials(@Study_Materials_Id_ :=?)",[Study_Materials_Id_],callback);
 }
 ,
 Get_Study_Materials:function(Study_Materials_Id_,callback)
 { 
return db.query("CALL Get_Study_Materials(@Study_Materials_Id_ :=?)",[Study_Materials_Id_],callback);
 }
 ,
 Search_Study_Materials:function(Study_Materials_Name_,callback)
 { 
 if (Study_Materials_Name_===undefined || Study_Materials_Name_==="undefined" )
Study_Materials_Name_='';
return db.query("CALL Search_Study_Materials(@Study_Materials_Name_ :=?)",[Study_Materials_Name_],callback);
 }
  };
  module.exports=Study_Materials;

