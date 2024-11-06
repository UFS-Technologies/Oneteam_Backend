 var db=require('../dbconnection');
 var fs = require('fs');
 var Agent_Course_Type=
 { 
 Save_Agent_Course_Type:function(Agent_Course_Type_,callback)
 { 
return db.query("CALL Save_Agent_Course_Type("+
"@Agent_Course_Type_Id_ :=?,"+
"@Agent_Id_ :=?,"+
"@Course_Type_Id_ :=?,"+
"@Cousrse_Type_Name_ :=?"+")"
 ,[Agent_Course_Type_.Agent_Course_Type_Id,
Agent_Course_Type_.Agent_Id,
Agent_Course_Type_.Course_Type_Id,
Agent_Course_Type_.Cousrse_Type_Name
],callback);
 }
 ,
 Delete_Agent_Course_Type:function(Agent_Course_Type_Id_,callback)
 { 
return db.query("CALL Delete_Agent_Course_Type(@Agent_Course_Type_Id_ :=?)",[Agent_Course_Type_Id_],callback);
 }
 ,
 Get_Agent_Course_Type:function(Agent_Course_Type_Id_,callback)
 { 
return db.query("CALL Get_Agent_Course_Type(@Agent_Course_Type_Id_ :=?)",[Agent_Course_Type_Id_],callback);
 }
 ,
 Search_Agent_Course_Type:function(Agent_Course_Type_Name_,callback)
 { 
 if (Agent_Course_Type_Name_===undefined || Agent_Course_Type_Name_==="undefined" )
Agent_Course_Type_Name_='';
return db.query("CALL Search_Agent_Course_Type(@Agent_Course_Type_Name_ :=?)",[Agent_Course_Type_Name_],callback);
 }
  };
  module.exports=Agent_Course_Type;

