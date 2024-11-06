var db=require('../dbconnection');
var fs = require('fs');
var Question_Import=
{ 
//  Save_Question_Import_Details:function(Question_Import_Details_,callback)
//  { 
// return db.query("CALL Save_Question_Import_Details("+
// "@Question_Import_Details_Id_ :=?,"+
// "@Question_Import_Master_Id_ :=?,"+
// "@Course_Id_ :=?,"+
// "@Course_Name_ :=?,"+
// "@Part_Id_ :=?,"+
// "@Part_Name_ :=?,"+
// "@Subject_Id_ :=?,"+
// "@Subject_Name_ :=?,"+
// "@Question_Id_ :=?,"+
// "@Question_Name_ :=?"+")"
//  ,[Question_Import_Details_.Question_Import_Details_Id,
// Question_Import_Details_.Question_Import_Master_Id,
// Question_Import_Details_.Course_Id,
// Question_Import_Details_.Course_Name,
// Question_Import_Details_.Part_Id,
// Question_Import_Details_.Part_Name,
// Question_Import_Details_.Subject_Id,
// Question_Import_Details_.Subject_Name,
// Question_Import_Details_.Question_Id,
// Question_Import_Details_.Question_Name
// ],callback);
//  }
//  ,

Save_Question_Import_Master:function(Question_Import_Master_,callback)
{  
      console.log(Question_Import_Master_)
      return db.query("CALL Save_Question_Import_Master(@Questions_Imported_ :=?,@Question_Import_Master_Id_ :=?,@User_Id_ :=?,@Course_Id_ :=?,@Course_Name_ :=?,"+
      "@Semester_Id_ :=?,@Semester_Name_ :=?,@Subject_Id_ :=?,@Subject_Name_ :=?)",
      [JSON.stringify(Question_Import_Master_.Question),Question_Import_Master_.Question_Import_Master_Id,Question_Import_Master_.User_Id,Question_Import_Master_.Course_Id,Question_Import_Master_.Course_Name,
      Question_Import_Master_.Semester_Id,Question_Import_Master_.Semester_Name ,
      Question_Import_Master_.Subject_Id,Question_Import_Master_.Subject_Name],callback);
},
Delete_Question_Import_Master:function(Question_Import_Details_Id_,callback)
{ 
return db.query("CALL Delete_Question_Import_Master(@Question_Import_Details_Id_ :=?)",[Question_Import_Details_Id_],callback);
}
,
Get_Question_Import:function(Question_Import_Details_Id_,callback)
{ 
return db.query("CALL Get_Question_Import_Details(@Question_Import_Details_Id_ :=?)",[Question_Import_Details_Id_],callback);
},
Search_Course_Typeahead:function(Course_Name_,callback)
{ 
if(Course_Name_==='undefined'||Course_Name_===''||Course_Name_===undefined )
Course_Name_='';
return db.query("CALL Search_Course_Typeahead(@Course_Name_ :=?)",[Course_Name_],callback);
},
Search_Course_Part_Typeahead:function(Course_Id_,Part_Name_,callback)
{ 
if(Part_Name_==='undefined'||Part_Name_===''||Part_Name_===undefined )
Department_Name_='';
return db.query("CALL Search_Course_Part_Typeahead(@Course_Id_ :=?,@Part_Name_ :=?)",[Course_Id_,Part_Name_],callback);
},
Search_Part_Subject_Typeahead:function(Course_Id_,Part_Id_,Subject_Name_,callback)
{ 
if(Subject_Name_==='undefined'||Subject_Name_===''||Subject_Name_===undefined )
Subject_Name_='';
return db.query("CALL Search_Part_Subject_Typeahead(@Course_Id_ :=?,@Part_Id_ :=?,@Subject_Name_ :=?)",
[Course_Id_,Part_Id_,Subject_Name_],callback);
},
Search_Question_Import_Master:function(Fromdate_,Todate_,Course_Id_,Subject_Id_,Part_Id_,callback)
{ 
      console.log(Fromdate_,Todate_,Course_Id_,Subject_Id_,Part_Id_)
      if(Course_Id_==='undefined'||Course_Id_===null||Course_Id_===undefined )   
      Course_Id_=0;
      if(Subject_Id_==='undefined'||Subject_Id_===null||Subject_Id_===undefined )   
      Subject_Id_=0;
      if(Part_Id_==='undefined'||Part_Id_===null||Part_Id_===undefined )   
      Part_Id_=0;

      return db.query("CALL Search_Question_Import_Master(@Fromdate_ :=?,@Todate_ :=?,@Course_Id_ :=?,@Subject_Id_ :=?,@Part_Id_ :=?)",[Fromdate_,Todate_,Course_Id_,Subject_Id_,Part_Id_],callback);
},
Get_Question_Import:function(Question_Import_Master_Id_,callback)
{ 
return db.query("CALL Get_Question_Import(@Question_Import_Master_Id_ :=?)",[Question_Import_Master_Id_],callback);
},

};
module.exports=Question_Import;

