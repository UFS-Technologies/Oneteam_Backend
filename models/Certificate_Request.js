 var db=require('../dbconnection');
 var fs = require('fs');
 var Certificate_Request=
 { 
 Save_Certificate_Request:function(Certificate_Request_,callback)
 { 
return db.query("CALL Save_Certificate_Request("+
"@Certificate_Request_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Date_ :=?,"+
"@Certificates_Id_ :=?,"+
"@Status_ :=?"+")"
 ,[Certificate_Request_.Certificate_Request_Id,
Certificate_Request_.Student_Id,
Certificate_Request_.Date,
Certificate_Request_.Certificates_Id,
Certificate_Request_.Status
],callback);
 }
 ,
 Delete_Certificate_Request:function(Certificate_Request_Id_,callback)
 { 
return db.query("CALL Delete_Certificate_Request(@Certificate_Request_Id_ :=?)",[Certificate_Request_Id_],callback);
 }
 ,
 Get_Certificate_Request:function(Certificate_Request_Id_,callback)
 { 
return db.query("CALL Get_Certificate_Request(@Certificate_Request_Id_ :=?)",[Certificate_Request_Id_],callback);
 }
 ,
 Search_Certificate_Request:function(Certificate_Request_Name_,callback)
 { 
 if (Certificate_Request_Name_===undefined || Certificate_Request_Name_==="undefined" )
Certificate_Request_Name_='';
return db.query("CALL Search_Certificate_Request(@Certificate_Request_Name_ :=?)",[Certificate_Request_Name_],callback);
 }
  };
  module.exports=Certificate_Request;

