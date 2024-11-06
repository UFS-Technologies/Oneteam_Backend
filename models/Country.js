 var db=require('../dbconnection');
 var fs = require('fs');
 var Country=
 { 
 Save_Country:function(Country_,callback)
 { 
return db.query("CALL Save_Country("+
"@Country_Id_ :=?,"+
"@Country_Name_ :=?"+")"
 ,[Country_.Country_Id,
Country_.Country_Name
],callback);
 }
 ,
 Delete_Country:function(Country_Id_,callback)
 { 
return db.query("CALL Delete_Country(@Country_Id_ :=?)",[Country_Id_],callback);
 }
 ,
 Get_Country:function(Country_Id_,callback)
 { 
return db.query("CALL Get_Country(@Country_Id_ :=?)",[Country_Id_],callback);
 }
 ,



 Search_Country_Typeahead:function(Country_Name,callback)
 { 
    if (Country_Name===undefined || Country_Name==="undefined" )
    Country_Name='';
    return db.query("CALL Search_Country_Typeahead(@Country_Name :=?)",[Country_Name],callback);
 },



 Search_Country:function(Country_Name_,callback)
 { 
 if (Country_Name_===undefined || Country_Name_==="undefined" )
Country_Name_='';
return db.query("CALL Search_Country(@Country_Name_ :=?)",[Country_Name_],callback);
 }
  };
  module.exports=Country;

