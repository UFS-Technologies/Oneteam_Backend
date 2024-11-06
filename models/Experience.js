 var db=require('../dbconnection');
 var fs = require('fs');
 var Experience=
 { 
 Save_Experience:function(Experience_,callback)
 { 
return db.query("CALL Save_Experience("+
"@Experience_Id_ :=?,"+
"@Experience_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Experience_.Experience_Id,
Experience_.Experience_Name,
Experience_.User_Id
],callback);
 }
 ,
 Delete_Experience:function(Experience_Id_,callback)
 { 
return db.query("CALL Delete_Experience(@Experience_Id_ :=?)",[Experience_Id_],callback);
 }
 ,
 Get_Experience:function(Experience_Id_,callback)
 { 
return db.query("CALL Get_Experience(@Experience_Id_ :=?)",[Experience_Id_],callback);
 }
 ,
 Search_Experience:function(Experience_Name_,callback)
 { 
 if (Experience_Name_===undefined || Experience_Name_==="undefined" )
Experience_Name_='';
return db.query("CALL Search_Experience(@Experience_Name_ :=?)",[Experience_Name_],callback);
 }
  };
  module.exports=Experience;

