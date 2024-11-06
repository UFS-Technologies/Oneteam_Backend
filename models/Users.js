var db=require('../dbconnection');
var fs = require('fs');
const storedProcedure=require('../helpers/stored-procedure');
var Users=
{ 
Save_Users: async function (Users_) 
{
return new Promise(async (rs,rej)=>{
const pool = db.promise();
let result1;
var connection = await pool.getConnection();
await connection.beginTransaction();
var User_Menu_Selection_ = Users_.User_Menu_Selection_Data;
var User_Sub=Users_.User_Sub_Data;
try
{
  console.log(Users_)
  const result1 = await(new storedProcedure('Save_Users',[Users_.Users_Id,Users_.Users_Name,Users_.Password,
  Users_.Working_Status,Users_.User_Type,Users_.Role_Id,Users_.Agent_Id,Users_.Address1,
  Users_.Address2,Users_.Address3,Users_.Address4,Users_.Pincode,
  Users_.Mobile,Users_.Email,0,Users_.Registration_Target,Users_.FollowUp_Target, 
  User_Menu_Selection_,User_Sub], connection)).result();
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
Delete_Users:function(Users_Id_,callback)
{ 
return db.query("CALL Delete_Users(@Users_Id_ :=?)",[Users_Id_],callback);
} ,
Search_User_Typeahead:function(Users_Name_,callback)
{ 
if (Users_Name_==='undefined'||Users_Name_===''||Users_Name_===undefined )
Users_Name_='';
return db.query("CALL Search_User_Typeahead(@Users_Name_ :=?)",[Users_Name_],callback);
},
Get_Users:function(Users_Id_,callback)
{ 
return db.query("CALL Get_Users(@Users_Id_ :=?)",[Users_Id_],callback);
} ,
Search_Users: async function (Users_Name_,Agent_Id_)
{
  var Leads = [];
  try {
    if (Agent_Id_=='undefined')
    Agent_Id_=0;
  if(Users_Name_=='undefined' || Users_Name_==null || Users_Name_=="")
  Users_Name_="";
    Leads = await (new storedProcedure('Search_Users', [Users_Name_, Agent_Id_])).result();
  }
  catch (e) {
  }

  return {
  returnvalue: {  Leads}
};
},

Get_Menu_Permission:function(User_Id_,callback)
{ 
return db.query("CALL Get_Menu_Permission(@User_Id_ :=?)",[User_Id_],callback);
},
Get_Menu_Status:function(Menu_Id_,User_Id_,callback)
{ 
  return db.query("CALL Get_Menu_Status(@Menu_Id_ :=?,@User_Id_ :=?)", [Menu_Id_,User_Id_],callback);
},
User_Employee:function(Users_Id_,callback)
{ 
return db.query("CALL User_Employee(@Users_Id_ :=?)",[Users_Id_],callback);
},
Get_User_Type:function(callback)
{ 
return db.query("CALL Get_User_Type()",[],callback);
},
Get_Users_Load_Data: async function () 
{
  const User_Type=await (new storedProcedure('Get_User_Type',  [])).result();
  const User_Menu_Selection = await (new storedProcedure('Search_User_Menu_Selection', [])).result();
  const User_Status = await (new storedProcedure('Get_User_Status', [])).result();
  const Agent = await (new storedProcedure('Load_Agent', [])).result();
  const Users = await (new storedProcedure('Load_Users', [])).result();
  // const Branch = await (new storedProcedure('Dropdown_Branch', [])).result();
  // const User_Department = await (new storedProcedure('Get_Department_InUser', [])).result();
  return { User_Type, User_Menu_Selection,User_Status,Agent,Users};
},
Get_Users_Edit: async function (User_Id_) 
{
const Menu = await (new storedProcedure('Get_Users_Edit', [User_Id_])).result();
const User_Sub = await (new storedProcedure('Get_User_Sub_Edit', [User_Id_])).result();
return {[0]:{Menu,User_Sub}};  
},
Search_User_Role:function(User_Role_Name_,callback)
{ 
if(User_Role_Name_==='undefined'||User_Role_Name_===''||User_Role_Name_===undefined )
User_Role_Name_='';
return db.query("CALL Search_User_Role(@User_Role_Name_ :=?)",[User_Role_Name_],callback);
}
};
module.exports=Users;

