 var db=require('../dbconnection');
 var fs = require('fs');
 var Status=
 { 
 Save_Status:function(Status_,callback)
 { 
return db.query("CALL Save_Status("+"@Status_Id_ :=?,"+"@Status_Name_ :=?,"+"@FollowUp_ :=?,"+"@User_Id_ :=?"+")"
 ,[Status_.Status_Id, Status_.Status_Name,Status_.FollowUp,Status_.User_Id],callback);
 }
 ,
 Delete_Status:function(Status_Id_,callback)
 { 
return db.query("CALL Delete_Status(@Status_Id_ :=?)",[Status_Id_],callback);
 }
 ,
 Get_Status:function(Status_Id_,callback)
 { 
return db.query("CALL Get_Status(@Status_Id_ :=?)",[Status_Id_],callback);
 }
 ,
 Search_Status:function(Status_Name_,callback)
 { 
 if (Status_Name_===undefined || Status_Name_==="undefined" )
Status_Name_='';
return db.query("CALL Search_Status(@Status_Name_ :=?)",[Status_Name_],callback);
 }
  };
  module.exports=Status;

