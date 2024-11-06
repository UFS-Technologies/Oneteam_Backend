 var db=require('../dbconnection');
 var fs = require('fs');
 var Syllabus_Import=
 { 


    Save_Syllabus_Import: function (Syllabus_Import_, callback) {
    console.log(Syllabus_Import_)
    return db.query(
        "CALL Save_Syllabus_Import(@Syllabus_Import_Details_ :=?,@User_Id_ :=?,@Course_Id_ :=?,@Course_Name_ :=?)",
        [
            JSON.stringify(Syllabus_Import_.Syllabus_Import_Details),
            Syllabus_Import_.User_Id,
            Syllabus_Import_.Course_Id,
            Syllabus_Import_.Course_Name,
        ],
        callback
    );
},



 Delete_Syllabus_Import:function(Syllabus_Import_Id_,callback)
 { 
return db.query("CALL Delete_Syllabus_Import(@Syllabus_Import_Id_ :=?)",[Syllabus_Import_Id_],callback);
 }
 ,
 Get_Syllabus_Import:function(Syllabus_Import_Id_,callback)
 { 
return db.query("CALL Get_Syllabus_Import(@Syllabus_Import_Id_ :=?)",[Syllabus_Import_Id_],callback);
 }
 ,
//  Search_Syllabus_Import:function(Syllabus_Import_Name_,callback)
//  { 
//  if (Syllabus_Import_Name_===undefined || Syllabus_Import_Name_==="undefined" )
// Syllabus_Import_Name_='';
// return db.query("CALL Search_Syllabus_Import(@Syllabus_Import_Name_ :=?)",[Syllabus_Import_Name_],callback);
//  }


Search_Syllabus_Import:function(From_Date_,To_Date_,Is_Date_Check_,callback)
{ 

return db.query("CALL Search_Syllabus_Import(@From_Date_ :=?,@To_Date_ :=?,@Is_Date_Check_ :=?)",[From_Date_,To_Date_,Is_Date_Check_],callback);
},


  };
  module.exports=Syllabus_Import;

