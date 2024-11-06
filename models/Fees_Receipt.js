 var db=require('../dbconnection');
 var fs = require('fs');
 var Fees_Receipt=
 { 
 Save_Fees_Receipt:function(Fees_Receipt_,callback)
 { 
return db.query("CALL Save_Fees_Receipt("+
"@Fees_Receipt_Id_ :=?,"+
"@Fees_Installment_Id_ :=?,"+
"@Course_Id_ :=?,"+
"@Course_Name_ :=?,"+
"@Student_Id_ :=?,"+
"@Fees_Type_Id_ :=?,"+
"@Fees_Type_Name_ :=?,"+
"@Amount_ :=?,"+
"@Date_ :=?"+")"
 ,[Fees_Receipt_.Fees_Receipt_Id,
Fees_Receipt_.Fees_Installment_Id,
Fees_Receipt_.Course_Id,
Fees_Receipt_.Course_Name,
Fees_Receipt_.Student_Id,
Fees_Receipt_.Fees_Type_Id,
Fees_Receipt_.Fees_Type_Name,
Fees_Receipt_.Amount,
Fees_Receipt_.Date
],callback);
 }
 ,
 Delete_Fees_Receipt:function(Fees_Receipt_Id_,callback)
 { 
return db.query("CALL Delete_Fees_Receipt(@Fees_Receipt_Id_ :=?)",[Fees_Receipt_Id_],callback);
 }
 ,
 Get_Fees_Receipt:function(Fees_Receipt_Id_,callback)
 { 
return db.query("CALL Get_Fees_Receipt(@Fees_Receipt_Id_ :=?)",[Fees_Receipt_Id_],callback);
 }
 ,
 Search_Fees_Receipt:function(Fees_Receipt_Name_,callback)
 { 
 if (Fees_Receipt_Name_===undefined || Fees_Receipt_Name_==="undefined" )
Fees_Receipt_Name_='';
return db.query("CALL Search_Fees_Receipt(@Fees_Receipt_Name_ :=?)",[Fees_Receipt_Name_],callback);
 }
  };
  module.exports=Fees_Receipt;

