 var db=require('../dbconnection');
 var fs = require('fs');
 var Functionl_Area=
 { 
 Save_Functionl_Area:function(Functionl_Area_,callback)
 { 
return db.query("CALL Save_Functionl_Area("+
"@Functionl_Area_Id_ :=?,"+
"@Functionl_Area_Name_ :=?,"+
"@User_Id_ :=?"+")"
 ,[Functionl_Area_.Functionl_Area_Id,
Functionl_Area_.Functionl_Area_Name,
Functionl_Area_.User_Id
],callback);
 }
 ,
 Delete_Functionl_Area:function(Functionl_Area_Id_,callback)
 { 
return db.query("CALL Delete_Functionl_Area(@Functionl_Area_Id_ :=?)",[Functionl_Area_Id_],callback);
 }
 ,
 Get_Functionl_Area:function(Functionl_Area_Id_,callback)
 { 
return db.query("CALL Get_Functionl_Area(@Functionl_Area_Id_ :=?)",[Functionl_Area_Id_],callback);
 }
 ,
 Search_Functionl_Area:function(Functionl_Area_Name_,callback)
 { 
 if (Functionl_Area_Name_===undefined || Functionl_Area_Name_==="undefined" )
Functionl_Area_Name_='';
return db.query("CALL Search_Functionl_Area(@Functionl_Area_Name_ :=?)",[Functionl_Area_Name_],callback);
 }
  };
  module.exports=Functionl_Area;

