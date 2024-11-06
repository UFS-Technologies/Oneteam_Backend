 var db=require('../dbconnection');
 const storedProcedure = require('../helpers/stored-procedure');
 var fs = require('fs');
 var Student_Data=
 { 


Student_Data_Dropdowns:function(callback)
{ 
    return db.query("CALL Student_Data_Dropdowns()", [],callback);
},

Search_Student_Data_Report: async function (
    Fromdate_,
    Todate_,
    Search_By_,
    SearchbyName_,
    Enquiry_Source_,
    Branch_,
    By_User_,
    Is_Date_Check_,
    Page_Index1_,
    Page_Index2_,
    Login_User_Id_,
    RowCount,
    RowCount2,
    To_User_,
    Status_Id_,
    Register_Value_
) {
    var Leads = [];
    try {
        
        Leads = await new storedProcedure("Search_Student_Data_Report", [
            Fromdate_,
            Todate_,
            Search_By_,
            SearchbyName_,
            Enquiry_Source_,
            Branch_,
            By_User_,
            Is_Date_Check_,
            Page_Index1_,
            Page_Index2_,
            Login_User_Id_,
            RowCount,
            RowCount2,
            To_User_,
            Status_Id_,
            Register_Value_,
        ]).result();
    } catch (e) {
        console.log(e);
    }

    return {
        returnvalue: {
            Leads,
        },
    };
},

Delete_Student_Report: function (Student_, callback) {
    return db.query(
        "CALL Delete_Student_Report(@Student_ :=?)",
        [JSON.stringify(Student_.Delete_Data_Details)],
        callback
    );
},


Save_Student_Data_FollowUp: function (Student_Details, callback) {
    console.log(Student_Details);
    return db.query(
        "CALL Save_Student_Data_FollowUp(@Student_Selected_Details_ :=?,@By_User_Id_ :=?,@Branch_ :=?,@User_Id_ :=?,@Branch_Name_ :=?,@User_Name_ :=?,@By_User_Name_ :=?,@Full_Transfer_Value_ :=?)",
        [
            JSON.stringify(Student_Details.Student_Selected_Details),
            Student_Details.By_User_Id,
            Student_Details.Branch,
            Student_Details.User_Id,
            Student_Details.Branch_Name,
            Student_Details.User_Name,
            Student_Details.By_User_Name,
            Student_Details.Full_Transfer_Value,
            
        ],
        callback
    );
},

Search_Branch_User_Typeahead:function(Branch_Id_,User_Details_Name_,callback)
{ 
  if(User_Details_Name_==='undefined'||User_Details_Name_===''||User_Details_Name_===undefined )
  User_Details_Name_='';
return db.query("CALL Search_Branch_User_Typeahead(@Branch_Id_ :=?,@User_Details_Name_ :=?)",[Branch_Id_,User_Details_Name_],callback);
},

Search_Branch_Typeahead:function(Branch_Name_,callback)
        { 
        if(Branch_Name_==='undefined'||Branch_Name_===''||Branch_Name_===undefined )
        Branch_Name_='';
        return db.query("CALL Search_Branch_Typeahead(@Branch_Name_ :=?)",[Branch_Name_],callback);
        },
        

  };
  module.exports=Student_Data;

