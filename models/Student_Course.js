 var db=require('../dbconnection');
 var fs = require('fs');
 var Student_Course=
 { 

    
 Save_Student_Course:function(Student_Course_,callback)
 { 
return db.query("CALL Save_Student_Course("+
"@Student_Course_Id_ :=?,"+
"@Student_Id_ :=?,"+
"@Entry_Date_ :=?,"+
"@Course_Name_Details_ :=?,"+
"@Course_Id_ :=?,"+
"@Course_Name_ :=?,"+
"@Start_Date_ :=?,"+
"@End_Date_ :=?,"+
"@Join_Date_ :=?,"+
"@By_User_Id_ :=?,"+
"@Status_ :=?,"+
"@Start_Time_ :=?,"+
"@End_Time_ :=?"+")"
 ,[Student_Course_.Student_Course_Id,
Student_Course_.Student_Id,
Student_Course_.Entry_Date,
Student_Course_.Course_Name_Details,
Student_Course_.Course_Id,
Student_Course_.Course_Name,
Student_Course_.Start_Date,
Student_Course_.End_Date,
Student_Course_.Join_Date,
Student_Course_.By_User_Id,
Student_Course_.Status,
Student_Course_.Start_Time,
Student_Course_.End_Time
],callback);
 }
 ,

// Save_Student_Course: async function (Student_Course_) {
// 		return new Promise(async (rs, rej) => {
// 			const pool = db.promise();
// 			let result1;
// 			var connection = await pool.getConnection();


// 			var Student_Course_Subject_Value =0;
// 			let Student_Course_Subject = Student_Course_.Student_Course_Subject;
// 			if (Student_Course_Subject != undefined && Student_Course_Subject != '' && Student_Course_Subject != null)
// 			Student_Course_Subject_Value = 1
// 			else{
// 				Student_Course_Subject = [{"Subject_Id":"0", "Subject_Name": null, "Part_Id": "0"}];
// 			}

// 			console.log(Student_Course_Subject);

// 			try {
// 				const result1 = await new storedProcedure(
// 					"Save_Student_Course",
// 					[
// 						Student_Course_.Student_Course_Id,
// 						Student_Course_.Student_Id,
// 						Student_Course_.Entry_Date,
// 						Student_Course_.Course_Name_Details,
// 						Student_Course_.Course_Id,
// 						Student_Course_.Course_Name,
// 						Student_Course_.Start_Date,
// 						Student_Course_.End_Date,
// 						Student_Course_.Join_Date,
// 						Student_Course_.By_User_Id,
// 						Student_Course_.Status,
// 						Student_Course_.Course_Type_Id,
// 						Student_Course_.Course_Type_Name,
// 						Student_Course_.Agent_Amount,
// 						Student_Course_.Total_Fees,
// 						Student_Course_.Batch_Id,
// 						Student_Course_.Batch_Name,
// 						Student_Course_.Faculty_Id,
// 						Student_Course_.Installment_Type_Id,
// 						Student_Course_.No_Of_Installment,
// 						Student_Course_.Duration,
// 						Student_Course_.Laptop_details_Id,
// 						Student_Course_.Laptop_details_Name,
// 						Student_Course_Subject,
// 						Student_Course_.Student_Fees_Installment_Details,
// 						Student_Course_.Start_Time,
// 						Student_Course_.End_Time,
// 						Student_Course_Subject_Value,
// 					],
// 					connection
// 				).result();

// 				await connection.commit();
// 				connection.release();
// 				rs(result1);
// 			} catch (err) {
// 				await connection.rollback();
// 				rej(err);
// 				var result2 = [{ Student_Id_: 0 }];
// 				rs(result2);
// 			} finally {
// 				connection.release();
// 			}
// 		});
// 	},


 Delete_Student_Course:function(Student_Course_Id_,callback)
 { 
return db.query("CALL Delete_Student_Course(@Student_Course_Id_ :=?)",[Student_Course_Id_],callback);
 }
 ,
 Get_Student_Course:function(Student_Course_Id_,callback)
 { 
return db.query("CALL Get_Student_Course(@Student_Course_Id_ :=?)",[Student_Course_Id_],callback);
 }
 ,
 Search_Student_Course:function(Student_Course_Name_,callback)
 { 
 if (Student_Course_Name_===undefined || Student_Course_Name_==="undefined" )
Student_Course_Name_='';
return db.query("CALL Search_Student_Course(@Student_Course_Name_ :=?)",[Student_Course_Name_],callback);
 }
  };
  module.exports=Student_Course;

