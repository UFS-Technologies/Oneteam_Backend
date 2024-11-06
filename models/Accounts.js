 var db=require('../dbconnection');
 var fs = require('fs');
 var Accounts=
 { 
 Save_Accounts:function(Accounts_,callback)
 { 
return db.query("CALL Save_Accounts("+
"@Accounts_Id_ :=?,"+
"@Date_ :=?,"+
"@Client_Id_ :=?,"+
"@DR_ :=?,"+
"@CR_ :=?,"+
"@X_Client_Id_ :=?,"+
"@Voucher_No_ :=?,"+
"@Voucher_Type_ :=?,"+
"@Description_ :=?,"+
"@Status_ :=?,"+
"@Daybbok_ :=?"+")"
 ,[Accounts_.Accounts_Id,
Accounts_.Date,
Accounts_.Client_Id,
Accounts_.DR,
Accounts_.CR,
Accounts_.X_Client_Id,
Accounts_.Voucher_No,
Accounts_.Voucher_Type,
Accounts_.Description,
Accounts_.Status,
Accounts_.Daybbok
],callback);
 }
 ,
 Delete_Accounts:function(Accounts_Id_,callback)
 { 
return db.query("CALL Delete_Accounts(@Accounts_Id_ :=?)",[Accounts_Id_],callback);
 }
 ,
 Get_Accounts:function(Accounts_Id_,callback)
 { 
return db.query("CALL Get_Accounts(@Accounts_Id_ :=?)",[Accounts_Id_],callback);
 }
 ,
 Search_Accounts:function(Accounts_Name_,callback)
 { 
 if (Accounts_Name_===undefined || Accounts_Name_==="undefined" )
Accounts_Name_='';
return db.query("CALL Search_Accounts(@Accounts_Name_ :=?)",[Accounts_Name_],callback);
 }
  };
  module.exports=Accounts;

