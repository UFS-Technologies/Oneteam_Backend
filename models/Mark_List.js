 var db=require('../dbconnection');
 var fs = require('fs');
 var Mark_List=
 { 
 Save_Mark_List:function(Mark_List_,callback)
 { 
return db.query("CALL Save_Mark_List("+
"@Mark_List_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Course_Id_ :=?,"+
"@Course_Name_ :=?,"+
"@Subject_Id_ :=?,"+
"@Subject_Name_ :=?,"+
"@Minimum_Mark_ :=?,"+
"@Maximum_Mark_ :=?,"+
"@Mark_Obtained_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Mark_List_.Mark_List_Id,
Mark_List_.Student_Id,
Mark_List_.Course_Id,
Mark_List_.Course_Name,
Mark_List_.Subject_Id,
Mark_List_.Subject_Name,
Mark_List_.Minimum_Mark,
Mark_List_.Maximum_Mark,
Mark_List_.Mark_Obtained,
Mark_List_.User_Id
],callback);
 }
 ,
 Delete_Mark_List:function(Mark_List_Id_,callback)
 { 
return db.query("CALL Delete_Mark_List(@Mark_List_Id_ :=?)",[Mark_List_Id_],callback);
 }
 ,
 Get_Mark_List:function(Mark_List_Id_,callback)
 { 
return db.query("CALL Get_Mark_List(@Mark_List_Id_ :=?)",[Mark_List_Id_],callback);
 }
 ,
 Search_Mark_List:function(Mark_List_Name_,callback)
 { 
 if (Mark_List_Name_===undefined || Mark_List_Name_==="undefined" )
Mark_List_Name_='';
return db.query("CALL Search_Mark_List(@Mark_List_Name_ :=?)",[Mark_List_Name_],callback);
 }
  };
  module.exports=Mark_List;

