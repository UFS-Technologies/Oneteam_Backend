var db=require('../dbconnection');
var fs = require('fs');
const storedProcedure = require('../helpers/stored-procedure');
var Course=
{ 
// Save_Course:function(Course_,callback)
// { 
//     return db.query("CALL Save_Course("+"@Course_Id_ :=?,"+"@Course_Name_ :=?,"+"@Course_Type_Id_ :=?,"+"@Course_Type_Name_ :=?,"+
//     "@Duration_ :=?,"+"@Agent_Amount_ :=?,"+"@User_Id_ :=?"+")"
//     ,[Course_.Course_Id,Course_.Course_Name,Course_.Course_Type_Id,Course_.Course_Type_Name,Course_.Duration,
//     Course_.Agent_Amount,Course_.User_Id],callback);
// },

    Save_Course: async function (Course_) {
     
        return new Promise(async (rs,rej)=>{
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        try 
        {
            console.log(Course_)
            const result1 = await (new storedProcedure('Save_Course', [Course_.Course_Id, Course_.Course_Name,
                Course_.Course_Type_Id, Course_.Course_Type_Name, Course_.Duration, Course_.Agent_Amount, Course_.User_Id, Course_.Total_Fees,
                Course_.Fees_Type_Id,
                 Course_.Course_Subject,Course_.Course_Fees,Course_.Is_Check], connection)).result();
            
            await connection.commit();
            connection.release();
            rs( result1);
            }
        catch (err) {
            
        await connection.rollback();
        rej(err);
            var result2 = [{'Course_Id_':0}]
        rs(result2);
        }
        finally 
        {
        connection.release();
        }
        })
        },
Delete_Course:function(Course_Id_,callback)
{ 
    return db.query("CALL Delete_Course(@Course_Id_ :=?)",[Course_Id_],callback);
},
Get_Course:function(Course_Id_,callback)
{ 
    return db.query("CALL Get_Course(@Course_Id_ :=?)",[Course_Id_],callback);
},
Search_Course:function(Course_Name_,Course_Type_Id,callback)
{ 
    if (Course_Name_===undefined || Course_Name_==="undefined" )
    Course_Name_='';
    return db.query("CALL Search_Course(@Course_Name_ :=?,@Course_Type_Id :=?)", [Course_Name_, Course_Type_Id],callback);
},
Search_Subject_Typeahead: function (Subject_Name_,callback)
{ 
    if (Subject_Name_ === undefined || Subject_Name_==="undefined" )
        Subject_Name_='';
    return db.query("CALL Search_Subject_Typeahead(@Subject_Name_ :=?)", [Subject_Name_],callback);
},
Search_Part_Typeahead: function (Part_Name_,callback)
{ 
    if (Part_Name_ === undefined || Part_Name_==="undefined" )
        Part_Name_='';
    return db.query("CALL Search_Part_Typeahead(@Part_Name_ :=?)", [Part_Name_],callback);
},
Load_Course_DropDowns:function(callback)
{ 
    return db.query("CALL Load_Course_DropDowns()",[],callback);
},

Load_Fees_Type:function(callback)
{ 
    return db.query("CALL Load_Fees_Type()", [],callback);
},

};
module.exports=Course;

