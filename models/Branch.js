var db=require('../dbconnection');
var fs = require('fs');
const storedProcedure=require('../helpers/stored-procedure');
var Branch=
{ 
Save_Branch: async function (Branch_) 
        {
        return new Promise(async (rs, rej) => {
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        await connection.beginTransaction();
        var Department_ = Branch_.Department_Data;
        try {
//  let lt = await (new storedProcedure('OpenTrans',[], connection)).result();
        const result1 = await (new storedProcedure('Save_Branch', [Branch_.Branch_Id,Branch_.Branch_Name,
          Branch_.Address,Branch_.Location,Branch_.District,Branch_.State,Branch_.Country,Branch_.PinCode,
          Branch_.Phone_Number,Branch_.Email,Branch_.Branch_Code,Branch_.Company,Department_], 
          connection)).result();
        var Branch_Id_ = result1[0].Branch_Id_;
        // var Values_ = '';
        // for (var i = 0; i < Department_.length; i++) {
        // var bit = Department_[i];
        // Values_ += '(' + Branch_Id_ + ',' + bit['Department_Id'] + ')\n,';
        // };
        // Values_ = Values_.substring(0, Values_.length - 2);
        // const result3 = await connection.query("insert into Branch_Department(Branch_Id,Department_Id) values"+ Values_);
        await connection.commit();
// let cltr = await (new storedProcedure('CloseTrans', [], connection)).result();
        connection.release();
        rs(result1);
        }
        catch (err) {
                         
        await connection.rollback();
        rej(err);
        }
        })
        },
Delete_Branch:function(Branch_Id_,callback)
        { 
        return db.query("CALL Delete_Branch(@Branch_Id_ :=?)",[Branch_Id_],callback);
        },
Get_Branch_Department_Edit:function(Branch_Id_,callback)
        { 
        return db.query("CALL Get_Branch_Department_Edit(@Branch_Id_ :=?)",[Branch_Id_],callback);
        },
Get_Branch: async function (Branch_Id_) 
        {
        const Department = await (new storedProcedure('Get_Branch_Department_Edit', [Branch_Id_])).result();
        return {Department};    
        },
Search_Branch:function(Branch_Name_,callback)
        { 
        if(Branch_Name_==='undefined'||Branch_Name_===''||Branch_Name_===undefined )
        Branch_Name_='';
        return db.query("CALL Search_Branch(@Branch_Name_ :=?)",[Branch_Name_],callback);
        },
Search_Branch_Typeahead:function(Branch_Name_,callback)
        { 
        if(Branch_Name_==='undefined'||Branch_Name_===''||Branch_Name_===undefined )
        Branch_Name_='';
        return db.query("CALL Search_Branch_Typeahead(@Branch_Name_ :=?)",[Branch_Name_],callback);
        },
        
Search_Company:function(callback)
{ 
        
return db.query("CALL Search_Company()",[],callback);

}
};
module.exports=Branch;

