 var db=require('../dbconnection');
 const Querycaller = require('../helpers/Querycaller');
 const storedProcedure=require('../helpers/stored-procedure');
 var fs = require('fs');
 var Department=
 { 
 
  Save_Department: async function (Department_) {
      // console.log(Department_);
    return new Promise(async (rs,rej)=>{
      const pool = db.promise();
      let result1;
      var connection = await pool.getConnection();
      await connection.beginTransaction();
      var Department_Status_ = Department_.Department_Status_Data;
      try {
        const result1 = await(new storedProcedure('Save_Department', [Department_.Department_Id,
        Department_.Department_Name,
        Department_.FollowUp,
        Department_.Status,
        Department_.Department_Order,
        Department_.Color,Department_Status_], connection)).result();
     await connection.commit();
        connection.release();
        rs( result1);
      }
      catch (err) {
                
        await connection.rollback();
        rej(err);
      }
    
    })
    
      
    },
  Delete_Department:function(Department_Id_,callback)
 { 
return db.query("CALL Delete_Department(@Department_Id_ :=?)",[Department_Id_],callback);
 },




 Get_Department:function(Department_Id_,callback)
 { 
return db.query("CALL Get_Department(@Department_Id_ :=?)",[Department_Id_],callback);
 }
 ,
 Get_Department_InUser:function(callback)
 { 
return db.query("CALL Get_Department_InUser()",[],callback);
 }
 ,
 Search_Department:function(Department_Name_,callback)
 { 
    if(Department_Name_==='undefined'||Department_Name_===''||Department_Name_===undefined )
    Department_Name_='';
return db.query("CALL Search_Department(@Department_Name_ :=?)",[Department_Name_],callback);
 }
,
Search_Branch_Department_Typeahead:function(Branch_Id_,Department_Name_,callback)
{ 
  if(Department_Name_==='undefined'||Department_Name_===''||Department_Name_===undefined )
  Department_Name_='';
return db.query("CALL Search_Branch_Department_Typeahead(@Branch_Id_ :=?,@Department_Name_ :=?)",[Branch_Id_,Department_Name_],callback);
}
,
Search_Department_User_Typeahead:function(Branch_Id_,Department_Id_,Users_Name_,callback)
{ 
      // console.log(Branch_Id_,Department_Id_,Users_Name_)
  if(Users_Name_==='undefined'||Users_Name_===''||Users_Name_===undefined )
  Users_Name_='';
return db.query("CALL Search_Department_User_Typeahead(@Branch_Id_ :=?,@Department_Id_ :=?,@Users_Name_ :=?)",
[Branch_Id_,Department_Id_,Users_Name_],callback);
}
,

Search_Department_Status_Typeahead:function(Department_Id_,Department_Status_Name_,callback)
{ 
  if(Department_Status_Name_==='undefined'||Department_Status_Name_===''||Department_Status_Name_===undefined )
  Department_Status_Name_='';
return db.query("CALL Search_Department_Status_Typeahead(@Department_Id_ :=?,@Department_Status_Name_ :=?)",
[Department_Id_,Department_Status_Name_],callback);
}
,

Get_Status_Selection_Edit:function(Department_Id_,callback)
{ 
return db.query("CALL Get_Status_Selection_Edit(@Department_Id_ :=?)",[Department_Id_],callback);
},
Search_Department_Status:function(Department_Status_Name_,callback)
 { 
    if(Department_Status_Name_==='undefined'||Department_Status_Name_===''||Department_Status_Name_===undefined )
    Department_Status_Name_='';
return db.query("CALL Search_Department_Status(@Department_Status_Name_ :=?)",[Department_Status_Name_],callback);
 }
  };
  module.exports=Department;

