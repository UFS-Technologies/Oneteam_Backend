 var db=require('../dbconnection');
 var fs = require('fs');
 var Agent_Commision=
 { 
 Save_Agent_Commision:function(Agent_Commision_,callback)
 { 
return db.query("CALL Save_Agent_Commision("+
"@Agent_Commision_Id_ :=?,"+
"@Agent_Id_ :=?,"+
"@Category_Id_ :=?,"+
"@Category_Name_ :=?,"+
"@Commision_Per_ :=?,"+
"@Commision_Amount_ :=?"+")"
 ,[Agent_Commision_.Agent_Commision_Id,
Agent_Commision_.Agent_Id,
Agent_Commision_.Category_Id,
Agent_Commision_.Category_Name,
Agent_Commision_.Commision_Per,
Agent_Commision_.Commision_Amount
],callback);
 }
 ,
 Delete_Agent_Commision:function(Agent_Commision_Id_,callback)
 { 
return db.query("CALL Delete_Agent_Commision(@Agent_Commision_Id_ :=?)",[Agent_Commision_Id_],callback);
 }
 ,
 Get_Agent_Commision:function(Agent_Commision_Id_,callback)
 { 
return db.query("CALL Get_Agent_Commision(@Agent_Commision_Id_ :=?)",[Agent_Commision_Id_],callback);
 }
 ,
 Search_Agent_Commision:function(Agent_Commision_Name_,callback)
 { 
 if (Agent_Commision_Name_===undefined || Agent_Commision_Name_==="undefined" )
Agent_Commision_Name_='';
return db.query("CALL Search_Agent_Commision(@Agent_Commision_Name_ :=?)",[Agent_Commision_Name_],callback);
 }
  };
  module.exports=Agent_Commision;

