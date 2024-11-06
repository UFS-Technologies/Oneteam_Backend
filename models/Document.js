 var db=require('../dbconnection');
 var fs = require('fs');
 var Document=
 { 
 Save_Document:function(Document_,callback)
 { 
return db.query("CALL Save_Document("+
"@Document_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Document_Name_ :=?,"+
"@Files_ :=?"+")"
 ,[Document_.Document_Id,
Document_.Student_Id,
Document_.Document_Name,
Document_.Files
],callback);
 }
 ,
 Delete_Document:function(Document_Id_,callback)
 { 
return db.query("CALL Delete_Document(@Document_Id_ :=?)",[Document_Id_],callback);
 }
 ,
 Get_Document:function(Document_Id_,callback)
 { 
return db.query("CALL Get_Document(@Document_Id_ :=?)",[Document_Id_],callback);
 }
 ,
 Search_Document:function(Document_Name_,callback)
 { 
 if (Document_Name_===undefined || Document_Name_==="undefined" )
Document_Name_='';
return db.query("CALL Search_Document(@Document_Name_ :=?)",[Document_Name_],callback);
 }
  };
  module.exports=Document;

