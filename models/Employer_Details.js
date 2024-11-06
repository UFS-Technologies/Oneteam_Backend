var db=require('../dbconnection');
var fs = require('fs');
const storedProcedure=require('../helpers/stored-procedure');
var Employer_Details=
{ 
  Save_Employer_Details: async function (Employer_Details_) 
{
return new Promise(async (rs,rej)=>{
const pool = db.promise();
let result1;
var connection = await pool.getConnection();
await connection.beginTransaction();
var Employer_Details_Menu_Selection_ = Employer_Details_.Employer_Details_Menu_Selection_Data;
try
{
  console.log(Employer_Details_)
  const result1 = await(new storedProcedure('Save_Employer_Details',[Employer_Details_.Employer_Details_Id,Employer_Details_.Company_Name,Employer_Details_.Contact_Person,
    Employer_Details_.Contact_Number,Employer_Details_.Email_Id,Employer_Details_.Company_Location,Employer_Details_.Website,
], connection)).result();
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

// Save_Company: async function (Company_) 
// {
// return new Promise(async (rs,rej)=>{
// const pool = db.promise();
// let result1;
// var connection = await pool.getConnection();
// await connection.beginTransaction();

// try
// {
//   console.log(Company_)
//   const result1 = await(new storedProcedure('Save_Company',[Company_.Company_Id,Company_.Company_Name,Company_.Phone,
//     Company_.Address1,Company_.Address2,Company_.Address3,Company_.Email_Id,Company_.Website,
// ], connection)).result();
//   await connection.commit();
  
//   connection.release();
// rs( result1);
// }
// catch (err) {
  
// await connection.rollback();
// rej(err);
// }   
// })
// },

Save_Company:function(Company_,callback)
{ 
 var Company_value_=1;
return db.query("CALL Save_Company("+"@Company_ :=?,"+"@Company_value_ :=?)" ,[JSON.stringify(Company_),Company_value_],callback); 
},


Delete_Employer_Details:function(Employer_Details_Id_,callback)
{ 
return db.query("CALL Delete_Employer_Details(@Employer_Details_Id_ :=?)",[Employer_Details_Id_],callback);
} ,
Search_Employer_Details_Typeahead:function(Company_Name_,callback)
{ 
if (Company_Name_==='undefined'||Company_Name_===''||Company_Name_===undefined )
Company_Name_='';
return db.query("CALL Search_Employer_Details_Typeahead(@Company_Name_ :=?)",[Company_Name_],callback);
},
Get_Employer_Details:function(Employer_Details_Id_,callback)
{ 
return db.query("CALL Get_Employer_Details(@Employer_Details_Id_ :=?)",[Employer_Details_Id_],callback);
} ,
Search_Employer_Details: async function (Company_Name_)
{
  var Leads = [];
  try {
    
  if(Company_Name_=='undefined' || Company_Name_==null || Company_Name_=="")
  Company_Name_="";
   
    Leads = await (new storedProcedure('Search_Employer_Details', [Company_Name_])).result();
     
  }
  catch (e) {
  }

  return {
  returnvalue: {  Leads}
};
},

Get_Menu_Permission:function(Employer_Details_Id_,callback)
{ 
return db.query("CALL Get_Menu_Permission(@Employer_Details_Id_ :=?)",[Employer_Details_Id_],callback);
},
// Get_Menu_Status:function(Menu_Id_,Employer_Details_Id_,callback)
// { 
//   return db.query("CALL Get_Menu_Status(@Menu_Id_ :=?,@Employer_Details_Id_ :=?)", [Menu_Id_,Employer_Details_Id_],callback);
// },
Employer_Details_Employee:function(Employer_Details_Id_,callback)
{ 
return db.query("CALL Employer_Details_Employee(@Employer_Details_Id_ :=?)",[Employer_Details_Id_],callback);
},
Get_Employer_Details_Type:function(callback)
{ 
return db.query("CALL Get_Employer_Details_Type()",[],callback);
},
Get_Employer_Details_Load_Data: async function () 
{
  const Employer_Details_Type=await (new storedProcedure('Get_Employer_Details_Type',  [])).result();
  const Employer_Details_Menu_Selection = await (new storedProcedure('Search_Employer_Details_Menu_Selection', [])).result();
  const Employer_Details_Status = await (new storedProcedure('Get_Employer_Details_Status', [])).result();
  const Agent = await (new storedProcedure('Load_Agent', [])).result();
  // const Branch = await (new storedProcedure('Dropdown_Branch', [])).result();
  // const User_Department = await (new storedProcedure('Get_Department_InEmployer_Detailsr', [])).result();
  return { Employer_Details_Type, Employer_Details_Menu_Selection,Employer_Details_Status,Agent};
},
Get_Employer_Details_Edit: async function (Employer_Details_Id_) 
{
const Menu = await (new storedProcedure('Get_Employer_Details_Edit', [Employer_Details_Id_])).result();
return {[0]:{Menu}};  
},
Search_Employer_Details_Role:function(Employer_Details_Role_Name_,callback)
{ 
if(Employer_Details_Role_Name_==='undefined'||Employer_Details_Role_Name_===''||Employer_Details_Role_Name_===undefined )
Employer_Details_Role_Name_='';
return db.query("CALL Search_Employer_Details_Role(@Employer_Details_Role_Name_ :=?)",[Employer_Details_Role_Name_],callback);
},





Save_Job_Opening:function(Job_Opening_, callback) {
  console.log(Job_Opening_)
  return db.query("CALL Save_Job_Opening(" +
      "@Job_Opening_Id_ :=?," +
      "@Job_Title_ :=?," +
      "@Comapny_Id_ :=?," +
      "@Company_Name_ :=?," +
      "@Contact_No_ :=?," +
      "@No_of_Vacancy_ :=?," +
      "@Salary_ :=?," +
      "@Location_ :=?," +
      "@Next_Followup_Date_ :=?," +
      "@Employee_Status_Id_ :=?," +
      "@Employee_Status_Name_ :=?," +
      "@To_Staff_Id_ :=?," +
      "@To_Staff_Name_ :=?," +
      "@Remark_ :=?," +
      "@Contact_Person_ :=?," +
      "@Email_ :=?," +
      "@Address_ :=?," +
      "@Website_ :=?," +
      "@Gender_Id_ :=?," +
      "@Gender_Name_ :=?," +
      "@By_User_Id_ :=?," +
      "@By_User_Name_ :=?," +
      "@Job_Opening_Description_ :=?," +
      "@Vacancy_Source_Id_ :=?," +
      "@Vacancy_Source_Name_ :=?" + ")",
  [
    Job_Opening_.Job_Opening_Id,
    Job_Opening_.Job_Title,
    Job_Opening_.Comapny_Id,
    Job_Opening_.Company_Name,
    Job_Opening_.Contact_No,
    Job_Opening_.No_of_Vacancy,
    Job_Opening_.Salary,
    Job_Opening_.Location,
    Job_Opening_.Next_Followup_Date,
    Job_Opening_.Employee_Status_Id,
    Job_Opening_.Employee_Status_Name,
    Job_Opening_.To_Staff_Id,
    Job_Opening_.To_Staff_Name,
    Job_Opening_.Remark,
    Job_Opening_.Contact_Person,
    Job_Opening_.Email,
    Job_Opening_.Address,
    Job_Opening_.Website,
    Job_Opening_.Gender_Id,
    Job_Opening_.Gender_Name,
    Job_Opening_.By_User_Id,
    Job_Opening_.By_User_Name,
    Job_Opening_.Job_Opening_Description,
    Job_Opening_.Vacancy_Source_Id,
    Job_Opening_.Vacancy_Source_Name
  ], callback);
}
,





Save_Job_Opening_Followup:function(Job_Opening_Followup_, callback) {
  console.log(Job_Opening_Followup_)
  return db.query("CALL Save_Job_Opening_Followup(" +
      "@Job_Opening_Id_ :=?," +
      "@Job_Opening_Followup_Id_ :=?," +
      "@Next_Followup_Date_ :=?," +
      "@Employee_Status_Id_ :=?," +
      "@Employee_Status_Name_ :=?," +
      "@To_Staff_Id_ :=?," +
      "@To_Staff_Name_ :=?," +
      "@Remark_ :=?," +
      "@By_User_Id_ :=?," +
      "@By_User_Name_  :=?" + ")",
  [
    Job_Opening_Followup_.Job_Opening_Id,
    Job_Opening_Followup_.Job_Opening_Followup_Id,
    Job_Opening_Followup_.Next_Followup_Date,
    Job_Opening_Followup_.Employee_Status_Id,
    Job_Opening_Followup_.Employee_Status_Name,
    Job_Opening_Followup_.To_Staff_Id,
    Job_Opening_Followup_.To_Staff_Name,
    Job_Opening_Followup_.Remark,
    Job_Opening_Followup_.By_User_Id,
    Job_Opening_Followup_.By_User_Name
  ], callback);
}
,



Search_Job_Opening: function (Is_Date_,Fromdate_,Todate_,Job_id_,Company_id_,Employee_Status_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback
  ) {
  
     
              if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
              Pointer_Start_=0;
  
              if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
              Pointer_Stop_=0; 
  
  
              return db.query(
                  "CALL Search_Job_Opening(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Job_id_ :=?,@Company_id_ :=?,@Employee_Status_Id_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?)",
                  [Is_Date_, Fromdate_,Todate_, Job_id_,Company_id_,Employee_Status_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],
                  callback
              );
  },


  Get_Job_Opening_Followup_History:function(Job_Opening_Id_,callback)
{ 
return db.query("CALL Get_Job_Opening_Followup_History(@Job_Opening_Id_ :=?)",[Job_Opening_Id_],callback);
} ,
Job_Post_Exist_Check:function(Job_Opening_Id_,callback)
{ 
return db.query("CALL Job_Post_Exist_Check(@Job_Opening_Id_ :=?)",[Job_Opening_Id_],callback);
} ,


Delete_Job_Opening:function(Job_Opening_Id_,callback)
{ 
    return db.query("CALL Delete_Job_Opening(@Job_Opening_Id_ :=?)",[Job_Opening_Id_],callback);
} ,

Job_Opening_Pending_Followups_Summary: async function (By_User_, Login_User_) {
		
  var Leads = [];

  try {
    Leads = await new storedProcedure("Job_Opening_Pending_Followups_Summary", [
      By_User_,
      Login_User_,
    ]).result();
  } catch (e) {}

  return {
    returnvalue: {
      Leads,
    },
  };
},
// Job_Opening_Pending_Followups_Report: async function (By_User_, Login_User_) {
//   var Leads = [];
//   try {
//     Leads = await new storedProcedure("Job_Opening_Pending_Followups_Report", [
//       By_User_,
//       Login_User_,
//     ]).result();
//   } catch (e) {}

//   return {
//     returnvalue: {
//       Leads,
//     },
//   };
// },


Job_Opening_Pending_Followups_Report: function (Is_Date_,Fromdate_,Todate_,Job_id_,Team_Member_Selection_,Employee_Status_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback
  ) {
  
     
              if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
              Pointer_Start_=0;
  
              if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
              Pointer_Stop_=0; 
  
  
              return db.query(
                  "CALL Job_Opening_Pending_Followups_Report(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Job_id_ :=?,@Team_Member_Selection_ :=?,@Employee_Status_Id_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?)",
                  [Is_Date_, Fromdate_,Todate_, Job_id_,Team_Member_Selection_,Employee_Status_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],
                  callback
              );
  },

};
module.exports=Employer_Details;

