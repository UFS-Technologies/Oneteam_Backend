var db=require('../dbconnection');
 // const storedProcedure=require('../helpers/stored-procedure');
var fs = require('fs');
const StoredProcedure = require('../helpers/stored-procedure');
var Company= 
{ 
  Save_Company:function(Company_,callback)
{ 
 var Company_value_=1;
return db.query("CALL Save_Company("+"@Company_ :=?,"+"@Company_value_ :=?)" ,[JSON.stringify(Company_),Company_value_],callback); 
}
,
Get_Company: async function () 
{
// const Company_Data=await (new storedProcedure('Get_Company',  [])).result();
const Company_Data=await (new StoredProcedure('Get_Company',  [])).result();
return {Company_Data};    

},

// Delete_Company:function(Company_Id_,callback)
// { 
// return db.query("CALL Delete_Company(@Company_Id_ :=?)",[Company_Id_],callback);
// }

Get_Companydetails:function(callback)
{ 
    return db.query("CALL Get_Companydetails()", [],callback);
},

Save_Application_Settings: async function (Application_Settings_) {
  return new Promise(async (rs,rej)=>{
    const pool = db.promise();
    let result1;
    var connection = await pool.getConnection();
    await connection.beginTransaction();
    try {
      console.log(Application_Settings_)
      const result1 = await(new StoredProcedure('Save_Application_Settings', [Application_Settings_.Application_Settings_Id,Application_Settings_.Users_Id,Application_Settings_.Users_Name,
        Application_Settings_.Complaint_Users_Id,Application_Settings_.Complaint_Users_Name], connection)).result();
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
  Get_Application_Settings: async function () 
  {
  const Settings_Data=await (new StoredProcedure('Get_Application_Settings',  [])).result();
  return {Settings_Data};    
  },



 };
 module.exports=Company;









































//  var db=require('../dbconnection');
//  var fs = require('fs');
//  const storedProcedure=require('../helpers/stored-procedure');
//  var Company_Source=
//  { 
//  Save_Company_Source: async function (Company_Source_) 
//  {
//          return new Promise(async (rs,rej)=>{
//         const pool = db.promise();
//         //  let result1;
//           var connection = await pool.getConnection();
//          await connection.beginTransaction();
   
//           try
//            {
            
//             const result1 = await(new storedProcedure('Save_Company_Source',[Company_Source_.Company_Source_Id,Company_Source_.companyname,Company_Source_.Phone1,
//               Company_Source_.Phone2,Company_Source_.Mobile,Company_Source_.Website,Company_Source_.Email,Company_Source_.Address1,Company_Source_.Address2,Company_Source_.Address3], connection)).result();
//             await connection.commit();
//               connection.release();
//               rs( result1);
//             }
//             catch (err) {
//             await connection.rollback();
//             rej(err);
//             }   
// })
// },

// };
  // module.exports=Company_Source;





























































//  var db=require('../dbconnection');
//  // const storedProcedure=require('../helpers/stored-procedure');
// var fs = require('fs');
// const StoredProcedure = require('../helpers/stored-procedure');
// var Company= 
// { 
//   Save_Company:function(Company_,callback)
// { 
//  var Company_value_=1;



// return db.query("CALL Save_Company("+
// "@Company_ :=?,"+
// "@Company_value_ :=?"+



// ")" 
// ,[
//   JSON.stringify(Company_),
//   Company_value_
// ],callback); 
// }
// ,



// Get_Company: async function () 
// {
// // const Company_Data=await (new storedProcedure('Get_Company',  [])).result();
// const Company_Data=await (new StoredProcedure('Get_Company',  [])).result();
// return {Company_Data};    

// }

// // Delete_Company:function(Company_Id_,callback)
// // { 
// // return db.query("CALL Delete_Company(@Company_Id_ :=?)",[Company_Id_],callback);
// // }


// // Get_Menu_Status:function(Menu_Id_,Login_User_,callback)
// // { 
// //   return db.query("CALL Get_Menu_Status(@Menu_Id_ :=?,@Login_User_:=?)", [Menu_Id_,Login_User_],callback);
// // } ,

//  };
//  module.exports=Company;









































// //  var db=require('../dbconnection');
// //  var fs = require('fs');
// //  const storedProcedure=require('../helpers/stored-procedure');
// //  var Company_Source=
// //  { 
// //  Save_Company_Source: async function (Company_Source_) 
// //  {
// //          return new Promise(async (rs,rej)=>{
// //         const pool = db.promise();
// //         //  let result1;
// //           var connection = await pool.getConnection();
// //          await connection.beginTransaction();
   
// //           try
// //            {
            
// //             const result1 = await(new storedProcedure('Save_Company_Source',[Company_Source_.Company_Source_Id,Company_Source_.companyname,Company_Source_.Phone1,
// //               Company_Source_.Phone2,Company_Source_.Mobile,Company_Source_.Website,Company_Source_.Email,Company_Source_.Address1,Company_Source_.Address2,Company_Source_.Address3], connection)).result();
// //             await connection.commit();
// //               connection.release();
// //               rs( result1);
// //             }
// //             catch (err) {
// //             await connection.rollback();
// //             rej(err);
// //             }   
// // })
// // },

// // };
//   // module.exports=Company_Source;

