 var db=require('../dbconnection');
 var fs = require('fs');
 var GeneralFunctions=
 { 


    Get_Menu_Status:function(Menu_Id_,Login_User_,callback)
    {
      return db.query("CALL Get_Menu_Status(@Menu_Id_ :=?,@Login_User_:=?)", [Menu_Id_,Login_User_],callback);
    }







  };
  module.exports=GeneralFunctions;

