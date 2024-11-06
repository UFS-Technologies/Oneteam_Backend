var db=require('../dbconnection');
var fs = require('fs');
var State=
{ 
Save_State:function(State_,callback)
{ 
return db.query("CALL Save_State("+"@State_Id_ :=?,"+"@State_Name_ :=?"+")"
,[State_.State_Id,State_.State_Name,],callback);
},
Save_State_District:function(State_District_,callback)
{ 
    console.log(State_District_)
    return db.query("CALL Save_State_District("+"@State_District_Id_ :=?,"+"@District_Name_ :=?,"+"@State_Id_ :=?"+")"
    ,[State_District_.State_District_Id,State_District_.District_Name,State_District_.State_Id,],callback);
},
Delete_State:function(State_Id_,callback)
{ 
return db.query("CALL Delete_State(@State_Id_ :=?)",[State_Id_],callback);
},
Delete_State_District:function(State_District_Id_,callback)
{ 
return db.query("CALL Delete_State_District(@State_District_Id_ :=?)",[State_District_Id_],callback);
},
Get_State_District:function(State_Id_,callback)
{ 
return db.query("CALL Get_State_District(@State_Id_ :=?)",[State_Id_],callback);
},
Search_State:function(State_Name_,callback)
{ 
if (State_Name_===undefined || State_Name_==="undefined" )
State_Name_='';
return db.query("CALL Search_State(@State_Name_ :=?)",[State_Name_],callback);
}
};
module.exports=State;

