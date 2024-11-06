
var db=require('../dbconnection');
var fs = require('fs');
var Period=
{ 
Save_Period:function(Period_,callback)
{ 
    console.log(Period_)
return db.query("CALL Save_Period("+"@Period_Id_ :=?,"+"@Period_Name_ :=?, "+"@Period_From_ :=?,"+"@Period_To_ :=? "+","+"@Duration_ :=? "+")"
,[Period_.Period_Id,Period_.Period_Name, Period_.Period_From,Period_.Period_To,Period_.Duration ],callback);
},
Delete_Period:function(Period_Id_,callback)
{ 
return db.query("CALL Delete_Period(@Period_Id_ :=?)",[Period_Id_],callback);
},
Get_Period:function(Period_Id_,callback)
{ 
return db.query("CALL Get_Period(@Period_Id_ :=?)",[Period_Id_],callback);
},
Search_Period:function(Period_Name_,callback)
{ 
if (Period_Name_===undefined || Period_Name_==="undefined" )
Period_Name_='';
return db.query("CALL Search_Period(@Period_Name_ :=?)",[Period_Name_],callback);
},

Load_PeriodPage_Dropdowns:function(callback)
{ 
    return db.query("CALL Load_PeriodPage_Dropdowns()",[],callback);
},

};
module.exports=Period;



