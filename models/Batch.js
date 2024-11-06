var db=require('../dbconnection');
var fs = require('fs');
var Batch=
{ 
Save_Batch:function(Batch_,callback)
{ 
    console.log(Batch_)
return db.query("CALL Save_Batch("+"@Batch_Id_ :=?,"+"@Batch_Name_ :=?,"+"@User_Id_ :=?,"+"@Start_Date_ :=?,"+"@End_Date_ :=?,"+"@Course_Id_ :=?,"+"@Course_Name_ :=?,"+"@Trainer_Id_ :=?,"+"@Trainer_Name_ :=?,"+"@Branch_Id_ :=?,"+"@Branch_Name_ :=?,"+"@Batch_Start_Time_ :=?,"+"@Batch_End_Time_ :=?"+")"
,[Batch_.Batch_Id,Batch_.Batch_Name,Batch_.User_Id,Batch_.Start_Date,Batch_.End_Date,Batch_.Course_Id,  Batch_.Course_Name, Batch_.Trainer_Id , Batch_.Trainer_Name ,Batch_.Branch_Id  ,Batch_.Branch_Name ,Batch_.Batch_Start_Time  ,Batch_.Batch_End_Time ],callback);
},
Delete_Batch:function(Batch_Id_,callback)
{ 
return db.query("CALL Delete_Batch(@Batch_Id_ :=?)",[Batch_Id_],callback);
},
Get_Batch:function(Batch_Id_,callback)
{ 
return db.query("CALL Get_Batch(@Batch_Id_ :=?)",[Batch_Id_],callback);
},
Search_Batch:function(Batch_Name_,callback)
{ 
if (Batch_Name_===undefined || Batch_Name_==="undefined" )
Batch_Name_='';
return db.query("CALL Search_Batch(@Batch_Name_ :=?)",[Batch_Name_],callback);
},

Load_BatchPage_Dropdowns:function(callback)
{ 
    return db.query("CALL Load_BatchPage_Dropdowns()",[],callback);
},

};
module.exports=Batch;



