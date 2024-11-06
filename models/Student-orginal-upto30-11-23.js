var db = require("../dbconnection");
var fs = require("fs");
var request = require('request');
const axios = require('axios');
const fetch = require("node-fetch");
const storedProcedure = require("../helpers/stored-procedure");
const nodemailer = require("nodemailer");
const sgMail = require("@sendgrid/mail");

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

var base64str = base64_encode("teamone.PNG");

function base64_encode(file) {
	var bitmap = fs.readFileSync(file);
	return new Buffer.from(bitmap).toString("base64");
}
var Student = {
	// Save_Student:function(Student_,callback)
	// {
	//     return db.query("CALL Save_Student("+"@Student_Id_ :=?,"+"@Student_Name_ :=?,"+"@Address1_ :=?,"+"@Address2_ :=?,"+"@Address3_ :=?,"+
	//     "@Address4_ :=?,"+"@Pincode_ :=?,"+"@Phone_ :=?,"+"@Mobile_ :=?,"+"@Whatsapp_ :=?,"+"@DOB_ :=?,"+"@Gender_ :=?,"+"@Email_ :=?,"+
	//     "@Alternative_Email_ :=?,"+"@Passport_No_ :=?,"+"@Passport_Expiry_ :=?,"+"@User_Name_ :=?,"+"@Password_ :=?,"+"@Photo_ :=?,"+
	//     "@User_Id_ :=?"+")"
	//     ,[Student_.Student_Id,Student_.Student_Name,Student_.Address1,Student_.Address2,Student_.Address3,Student_.Address4,
	//     Student_.Pincode,Student_.Phone,Student_.Mobile,Student_.Whatsapp,Student_.DOB,Student_.Gender,Student_.Email,
	//     Student_.Alternative_Email,Student_.Passport_No,Student_.Passport_Expiry,Student_.User_Name,Student_.Password,
	//     Student_.Photo,Student_.User_Id],callback);
	// } ,
	Save_Student: function (Student_Data, callback) {
		console.log(Student_Data);
		var Student_Value_ = 0;
		let Student_ = Student_Data.Student;
		if (Student_ != undefined && Student_ != "" && Student_ != null)
			Student_Value_ = 1;
		var FollowUp_Value_ = 0;
		let FollowUp_ = Student_Data.Followup;
		if (FollowUp_ != undefined && FollowUp_ != "" && FollowUp_ != null)
			FollowUp_Value_ = 1;
		return db.query(
			"CALL Save_Student(" +
				"@Student_:=?," +
				"@FollowUp_ :=?," +
				"@Student_Value_ :=?," +
				"@FollowUp_Value_ :=? )",
			[Student_, FollowUp_, Student_Value_, FollowUp_Value_],
			callback
		);
	},
	Delete_Student: function (Student_Id_, callback) {
		return db.query(
			"CALL Delete_Student(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},
	Get_Student: function (Student_Id_, callback) {
		return db.query(
			"CALL Get_Student(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},

	Load_Year_of_Pass:function(callback)
	{ 
	return db.query("CALL Load_Year_of_Pass()", [],callback);
	},

	Get_App_Dashboard: function (Student_Id_, callback) {
		return db.query(
			"CALL Get_App_Dashboard(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},
	Search_Student: async function (
		Fromdate_,
		Todate_,
		SearchbyName_,
		By_User_,
		Status_Id_,
		Is_Date_Check_,
		Page_Index1_,
		Page_Index2_,
		Login_User_Id_,
		RowCount,
		RowCount2,
		Register_Value,
		Qualification_Id,
		Course_Id
	) {
		var Student = [];
		try {
			console.log(SearchbyName_)

			SearchbyName_= SearchbyName_.replace("#","+");
			
			if (SearchbyName_ === undefined || SearchbyName_ === "undefined")
				SearchbyName_ = "";
			Student = await new storedProcedure("Search_Student", [
				Fromdate_,
				Todate_,
				SearchbyName_,
				By_User_,
				Status_Id_,
				Is_Date_Check_,
				Page_Index1_,
				Page_Index2_,
				Login_User_Id_,
				RowCount,
				RowCount2,
				Register_Value,
				Qualification_Id,
				Course_Id,
			]).result();
		} catch (e) {}

		return {
			returnvalue: {
				Student,
			},
		};
	},

	Search_Status_Typeahead: function (Status_Name, Group_Id, callback) {
		if (Status_Name === undefined || Status_Name === "undefined")
			Status_Name = "";
		return db.query(
			"CALL Search_Status_Typeahead(@Status_Name :=?,@Group_Id :=?)",
			[Status_Name, Group_Id],
			callback
		);
	},
	Search_Users_Typeahead: function (Status_Name, callback) {
		if (Status_Name === undefined || Status_Name === "undefined")
			Status_Name = "";
		return db.query(
			"CALL Search_Users_Typeahead(@Status_Name :=?)",
			[Status_Name],
			callback
		);
	},

	Search_Faculty_Typeahead: function (Users_Name,Role_Type, callback) {
		if (Users_Name === undefined || Users_Name === "undefined")
		Users_Name = "";
		return db.query(
			"CALL Search_Faculty_Typeahead(@Users_Name :=?,@Role_Type :=?)",
			[Users_Name,Role_Type],
			callback
		);
	},

	Search_Typeahead_Loadfaculty: function (Users_Name, callback) {
		if (Users_Name === undefined || Users_Name === "undefined")
		Users_Name = "";
		return db.query(
			"CALL Search_Typeahead_Loadfaculty(@Users_Name :=?)",
			[Users_Name],
			callback
		);
	},

	Load_Gender: function (callback) {
		return db.query("CALL Load_Gender()", [], callback);
	},

	Load_Id_Proof: function (callback) {
		return db.query("CALL Load_Id_Proof()", [], callback);
	},


	Load_Attendance_Status: function (callback) {
		return db.query("CALL Load_Attendance_Status()", [], callback);
	},

	Load_Enquiry_Source: function (callback) {
		return db.query("CALL Load_Enquiry_Source()", [], callback);
	},


	Load_Resume_Status: function (callback) {
		return db.query("CALL Load_Resume_Status()", [], callback);
	},


	Load_Student_Search_Dropdowns: function (Group_Id_, callback) {
		return db.query(
			"CALL Load_Student_Search_Dropdowns(@Group_Id_ :=?)",
			[Group_Id_],
			callback
		);
	},
	Get_FollowUp_Details: async function (Student_Id_) {
		const FollowUp = await new storedProcedure("Get_FollowUp_Details", [
			Student_Id_,
		]).result();
		return { 0: { FollowUp } };
	},
	Get_Last_FollowUp: function (Users_Id_, callback) {
		return db.query(
			"CALL Get_Last_FollowUp(@Users_Id_ :=?)",
			[Users_Id_],
			callback
		);
	},

	Register_Student: async function (Student_Id_, User_Id_,Student_Name,Course_Name, callback) {
		console.log(Student_Name,Course_Name)
		const FollowUp = await new storedProcedure("Register_Student", [
			Student_Id_, User_Id_,
		]).result();
// 		console.log(location_path1);
// //return { 0: { location_path1 } };
// 		request.post(
// 			location_path1,
// 			function (error, response, body) {
				
// 				console.log(error, response, body);
// 				if (!error && response.statusCode == 200) {
// 					console.log(body);
// 					return { 0: { FollowUp } };
// 				}
// 			}
// 		);

		// console.log(location_path1);
		// const response1 = await fetch(location_path1);
		// console.log(response1);
		// return { 0: { location_path1 } };
		return { 0: { FollowUp } };
		
	},




// 	Register_Student: async function (Student_Id_, User_Id_,Student_Name,Course_Name, callback) {
// 		console.log(Student_Name,Course_Name)
// 		const FollowUp = await new storedProcedure("Register_Student", [
// 			Student_Id_, User_Id_,
// 		]).result();
// 		var whatsapp="Hello, " +
// 		Student_Name +
// 		" Thank you for Your Enquiry at One Team Solutions!"+
// 		"Thank You for Joining for "+Course_Name+" at One Team Solutions !."+
// 		"Congrats for making a Career Changing Decision!"+
// 		"We wish you all the very best. Our Full Team is here to support and guide you; work Really hard for next 6 months !"+
// 		"Feel Free to contact us for any further Queries/Feedback !"+
// 		"If you have joined under Instalment Scheme, your Instalment Interval will be like below"+
// 		"• Instalment Intervals:"+
// 		"• Instalment 1(Registration Fee) - On the day of Joining for the Course"+
// 		"• Instalment 2 - On or before the First Day of Class"+
// 		"• Instalment 3 - On or before 25th Day of Class Starting"+
// 		"• Instalment 4 - On or before 45th Day of Class Starting"+
// 		"If you have any options to switch from Instalment Scheme to One Time Payment Scheme, contactyour Academic Counsellor today and save Rs.3000!";
	
// 		// var location_path1 ="curl --location --request POST https://api.telinfy.net/gaca/whatsapp/templates/message'\
// 		// --header 'Api-Key:0ea03cd8-169f-4f50-8254-94f50dbcfdaa'\
// 		// --header'Content-Type: application/json'\
// 		// --data-raw"+"{"+
// 		// "whatsAppBusinessId"+":"+ "95fbd0bb-d339-4088-b1ff-c81b42f16e08",
// 		// "phoneNumberId":"103915675851161",
// 		// "from":"9562813713",
// 		// "to": "9995610336",
// 		// "type": "template",
// 		// "templateName": "test_new",
// 		// "templateId": "1475962839556937",
// 		// "language": "en",
// 		// "header": null,
// 		// "body": {
// 		// 	"parameters": [
// 		// 	{
// 		// 	"type": "text",
// 		// 	"text": whatsapp
// 		// 	}
// 		// 	]
// 		// 	},
// 		// "button": null
// 		// }

// //Whatsapp Api
// 		var location_path1="curl --location --request POST 'https://api.telinfy.net/gaca/whatsapp/templates/message'\\--header 'Api-Key: 0ea03cd8-169f-4f50-8254-94f50dbcfdaa'\\--header 'Content-Type: application/json'\\--data-raw'{"+
// 			"\"whatsAppBusinessId\""+":"+ "95fbd0bb-d339-4088-b1ff-c81b42f16e08,"+
// 			"\"phoneNumberId\""+":"+"103915675851161\","+
// 			"\"from\""+":"+"\"919562813713\","+
// 			"\"to\""+":"+ "\"919995610336\","+
// 			"\"type\""+":"+ "\"template\","+
// 			"\"templateName\""+":"+ "\"test_new\","+
// 			"\"templateId\""+":"+ "\"1475962839556937\","+
// 			"\"language\""+":"+ "\"en\","+
// 		"header"+": {"+
// 		 "parameters"+":"+"["+
// 		 "{"+
// 		 "\"type\""+":"+ "\"image,"+
// 		 "\"image\""+":"+"{"+
// 		 "\"link\""+":"+ "\"https://s4.gifyu.com/images/logo-016219d87db6ef3c43.png\""+
// 		 "}"+
// 		 "}"+
// 		 "]"+
// 		 "},"+
// 		"\"body\""+":{"+
// 		 "\"parameters\""+":"+" ["+
// 		 "{"+
// 		 "\"type\""+":"+ "text,"+
// 		 "\"text\""+":"+ "12345"+
// 		 "}"+
// 		 "]"+
// 		 "},"+
// 		"\"button\""+":"+ "\"null\""+
// 		"}"

// 		console.log(location_path1);
// //return { 0: { location_path1 } };
// 		request.post(
// 			location_path1,
// 			function (error, response, body) {
				
// 				console.log(error, response, body);
// 				if (!error && response.statusCode == 200) {
// 					console.log(body);
// 					return { 0: { FollowUp } };
// 				}
// 			}
// 		);

// 		// console.log(location_path1);
// 		// const response1 = await fetch(location_path1);
// 		// console.log(response1);
// 		// // return { 0: { location_path1 } };
// 		// return { 0: { FollowUp } };
		
// 	},
//end

	Get_FollowUp_History: async function (Student_Id_) {
		const FollowUp = await new storedProcedure("Get_FollowUp_History", [
			Student_Id_,
		]).result();
		return { 0: { FollowUp } };
	},
	Register_Student1: function (Student_Id_, User_Id_, callback) {
		return db.query(
			"CALL Register_Student(@Student_Id_ :=?,@User_Id_ :=?)",
			[Student_Id_, User_Id_],
			callback
		);
	},
	Remove_Registration: function (Student_Id_, callback) {
		return db.query(
			"CALL Remove_Registration(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},
	Search_Course_Typeahead: function (Course_Name, callback) {
		if (Course_Name === undefined || Course_Name === "undefined")
			Course_Name = "";
		return db.query(
			"CALL Search_Course_Typeahead(@Course_Name :=?)",
			[Course_Name],
			callback
		);
	},
	Search_Batch_Typeahead: function (Batch_Name, callback) {
		if (Batch_Name === undefined || Batch_Name === "undefined") Batch_Name = "";
		return db.query(
			"CALL Search_Batch_Typeahead(@Batch_Name :=?)",
			[Batch_Name],
			callback
		);
	},

	Search_Batch_Typeahead_1: function (Batch_Name, Course_Id, callback) {
		if (Batch_Name === undefined || Batch_Name === "undefined") Batch_Name = "";
		return db.query(
			"CALL Search_Batch_Typeahead_1(@Batch_Name :=?,@Course_Id :=?)",
			[Batch_Name, Course_Id],
			callback
		);
	},


	Search_Batch_Typeahead_Report: function (Batch_Name, Login_User, callback) {
		if (Batch_Name === undefined || Batch_Name === "undefined") Batch_Name = "";
		return db.query(
			"CALL Search_Batch_Typeahead_Report(@Batch_Name :=?,@Login_User :=?)",
			[Batch_Name, Login_User],
			callback
		);
	},


	Search_Batch_Typeahead_Report_New: function (Batch_Name, Login_User,Trainer, callback) {
		if (Batch_Name === undefined || Batch_Name === "undefined") Batch_Name = "";
		return db.query(
			"CALL Search_Batch_Typeahead_Report_New(@Batch_Name :=?,@Login_User :=?,@Trainer :=?)",
			[Batch_Name, Login_User,Trainer],
			callback
		);
	},



	Search_Batch_Typeahead_Attendance: function (Batch_Name, Course_Id,Login_User, callback) {
		if (Batch_Name === undefined || Batch_Name === "undefined") Batch_Name = "";
		return db.query(
			"CALL Search_Batch_Typeahead_Attendance(@Batch_Name :=?,@Course_Id :=?,@Login_User :=?)",
			[Batch_Name, Course_Id,Login_User],
			callback
		);
	},

	Search_Batch_Typeahead_Attendance1: function (Batch_Name, Course_Id,Login_User, callback) {
		if (Batch_Name === undefined || Batch_Name === "undefined") Batch_Name = "";
		return db.query(
			"CALL Search_Batch_Typeahead_Attendance1(@Batch_Name :=?,@Course_Id :=?,@Login_User :=?)",
			[Batch_Name, Course_Id,Login_User],
			callback
		);
	},

	Search_Batch_Typeahead_2: function (Batch_Name, Course_Id, callback) {
		if (Batch_Name === undefined || Batch_Name === "undefined") Batch_Name = "";
		return db.query(
			"CALL Search_Batch_Typeahead_2(@Batch_Name :=?,@Course_Id :=?)",
			[Batch_Name, Course_Id],
			callback
		);
	},

	Get_Course_Student: function (Course_Id, callback) {
		return db.query(
			"CALL Get_Course_Student(@Course_Id :=?)",
			[Course_Id],
			callback
		);
	},
	Get_Student_Course: function (Student_Id_, callback) {
		return db.query(
			"CALL Get_Student_Course(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},
	Get_Student_Course_Click: function (
		Student_Id_,
		Course_Id_,
		Fees_Type_Id,
		callback
	) {
		return db.query(
			"CALL Get_Student_Course_Click(@Student_Id_ :=?,@Course_Id_ :=?,@Fees_Type_Id :=?)",
			[Student_Id_, Course_Id_, Fees_Type_Id],
			callback
		);
	},
	Save_Student_Course: async function (Student_Course_) {
		return new Promise(async (rs, rej) => {
			const pool = db.promise();
			let result1;
			var connection = await pool.getConnection();
			try {
				const result1 = await new storedProcedure(
					"Save_Student_Course",
					[
						Student_Course_.Student_Course_Id,
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
						Student_Course_.Course_Type_Id,
						Student_Course_.Course_Type_Name,
						Student_Course_.Agent_Amount,
						Student_Course_.Total_Fees,
						Student_Course_.Batch_Id,
						Student_Course_.Batch_Name,
						Student_Course_.Faculty_Id,
						Student_Course_.Installment_Type_Id,
						Student_Course_.No_Of_Installment,
						Student_Course_.Duration,
						Student_Course_.Laptop_details_Id,
						Student_Course_.Laptop_details_Name,
						Student_Course_.Student_Course_Subject,
						Student_Course_.Student_Fees_Installment_Details,
						Student_Course_.Start_Time,
						Student_Course_.End_Time,
					],
					connection
				).result();

				await connection.commit();
				connection.release();
				rs(result1);
			} catch (err) {
				await connection.rollback();
				rej(err);
				var result2 = [{ Student_Id_: 0 }];
				rs(result2);
			} finally {
				connection.release();
			}
		});
	},



	Search_Subject_Course_Typeahead: function (
		Subject_Name,
		Course_Id,
		callback
	) {
		if (Subject_Name === undefined || Subject_Name === "undefined")
			Subject_Name = "";
		return db.query(
			"CALL Search_Subject_Course_Typeahead(@Subject_Name :=?,@Course_Id :=?)",
			[Subject_Name, Course_Id],
			callback
		);
	},

	Get_Installment_Details: function (Installment_Type_Id, Course_Id,Student_Course_Id, callback) {
		return db.query(
			"CALL Get_Installment_Details(@Installment_Type_Id :=?,@Course_Id :=?,@Student_Course_Id :=?)",
			[Installment_Type_Id, Course_Id,Student_Course_Id],
			callback
		);
	},
	Load_Exam_Status: function (callback) {
		return db.query("CALL Load_Exam_Status()", [], callback);
	},
	Save_Mark_List_Master: async function (Mark_List_Master_) {
		return new Promise(async (rs, rej) => {
			const pool = db.promise();
			let result1;
			var connection = await pool.getConnection();
			try {
				const result1 = await new storedProcedure(
					"Save_Mark_List_Master",
					[
						Mark_List_Master_.Mark_List_Master_Id,
						Mark_List_Master_.Student_Id,
						Mark_List_Master_.Course_Id,
						Mark_List_Master_.Course_Name,
						Mark_List_Master_.User_Id,
						Mark_List_Master_.Mark_List,
					],
					connection
				).result();
				await connection.commit();
				connection.release();
				rs(result1);
			} catch (err) {
				await connection.rollback();
				rej(err);
				var result2 = [{ Mark_List_Master_Id_: 0 }];
				rs(result2);
			} finally {
				connection.release();
			}
		});
	},
	Get_Student_Mark_List: function (Student_Id_, callback) {
		return db.query(
			"CALL Get_Student_Mark_List(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},
	// Save_Student_Receipt_Voucher: function (Receipt_Voucher_, callback) {
	// 	 console.log(Receipt_Voucher_)
	// 	return db.query(
	// 		"CALL Save_Student_Receipt_Voucher(" +
	// 			"@Receipt_Voucher_Id_ :=?," +
	// 			"@Date_ :=?," +
	// 			"@Student_Id_ :=?," +
	// 			"@Amount_ :=?," +
	// 			"@Payment_Mode_ :=?," +
	// 			"@User_Id_ :=?," +
	// 			"@Payment_Status_ :=?," +
	// 			"@To_Account_Id_ :=?," +
	// 			"@To_Account_Name_ :=?," +
	// 			"@Description_ :=?," +
	// 			"@Student_Fees_Installment_Details_Id_ :=?," +
	// 			"@Student_Course_Id_ :=?," +
	// 			"@Fees_Type_Id_ :=?," +
	// 			"@Tax_Percentage_ :=?," +
	// 			"@Course_Id_ :=?" +
	// 			")",
	// 		[
	// 			Receipt_Voucher_.Receipt_Voucher_Id,
	// 			Receipt_Voucher_.Date,
	// 			Receipt_Voucher_.From_Account_Id,
	// 			Receipt_Voucher_.Amount,
	// 			Receipt_Voucher_.Payment_Mode,
	// 			Receipt_Voucher_.User_Id,
	// 			Receipt_Voucher_.Payment_Status,
	// 			Receipt_Voucher_.To_Account_Id,
	// 			Receipt_Voucher_.To_Account_Name,
	// 			Receipt_Voucher_.Description,
	// 			Receipt_Voucher_.Student_Fees_Installment_Details_Id,
	// 			Receipt_Voucher_.Student_Course_Id,
	// 			Receipt_Voucher_.Fees_Type_Id,
	// 			Receipt_Voucher_.Tax_Percentage,
	// 			Receipt_Voucher_.Course_Id,
	// 		],
	// 		callback
	// 	);
	// },



	Save_Student_Receipt_Voucher:function(Receipt_Voucher_Data,callback)
	{ 
	 
	 var Document_value_ = 0; 
	  let Receipt_Voucher_ = Receipt_Voucher_Data.Receipt_Voucher_De;
	  if (Receipt_Voucher_ != undefined && Receipt_Voucher_ != '' && Receipt_Voucher_ != null)
		 Document_value_ = 1;  
		
	return db.query("CALL Save_Student_Receipt_Voucher("+"@Receipt_Voucher_:=?)"
	,[Receipt_Voucher_],callback);
 
	}

,


	Send_Receipt_Sms_Email: async function ( Mobile_,Email_,Sms,Student_Name,Amount_,Date_,Total_Amount_,Instalment_Date_,BalanceAmount_) 
{  
	console.log(Mobile_,Email_,Sms,Student_Name,Amount_,Date_,Total_Amount_,Instalment_Date_,BalanceAmount_)
    var location_path="http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver="
    +Mobile_+"&route=TA&msgtype=1&sms="+Sms+ "";
    // console.log(location_path)
        const response =await fetch(location_path);


		var whatsapp="Hello, " +
		Student_Name +
		
		"We have received a payment of Rs. "+ Amount_+"On"+ Date_ +" at One Team Solutions !."+
		"Thank You for making the Payment. Your Pending fee is"+ BalanceAmount_+
		"For any further Support contact your Academic Counsellor on 9562813713";
		

		var location_path1 ="https://api.telinfy.net/gaca/whatsapp/templates/message/Api-Key:0ea03cd8-169f-4f50-8254-94f50dbcfdaa/Content-Type:application/json/"
		+"data-raw '"+{
		"whatsAppBusinessId": "95fbd0bb-d339-4088-b1ff-c81b42f16e08",
		"phoneNumberId":"103915675851161",
		"from":"9562813713",
		"to": "9995610336",
		"type": "template",
		"templateName": "test_new",
		"templateId": "1475962839556937",
		"language": "en",
		"header": null,
		"body":{
	 	"parameters": [
	 	{
	 	"type": "text",
		 "text": whatsapp
	 	}
	 	]
	 	},
		"button": null
		}

		console.log(location_path1);
		const response1 = await fetch(location_path1);
		console.log(response1);



      //  console.log(12)
    let transporter = nodemailer.createTransport({
      host: 'smtp.gmail.com',
       port: 587,
       secure: false,
       requireTLS: true,
        auth: {
          user: 'training@oneteamsolutions.co.in', 
          pass: 'Onteam@train9070'
        }
      });
     const mailOptions = {
      
      //  from: '<b>One Team Solutions</b> '+ '< ' + 'hr@ufstechnologies.com ' + '>',
      from: 'training@oneteamsolutions.co.in' ,
       to: Email_,
       subject: 'Payment Received - One Team Solutions ! ', 
        
       attachments: [
         {
           filename: 'teamone.PNG',          
           type:  'image/PNG',
           content_id:   'myimagecid',
           content:      base64str ,
           disposition : "inline"
         }], 
       html:   "Dear "+Student_Name +" , <br/>"
       
       +"<br> Thank You for Making the Payment ! <br/>"
       
       +"<br/> We have received a Payment of Rs." + Amount_ +" on "+  Date_+". <br/>"
// if(BalanceAmount_ = 0)
// {

// }
       

    +"<br/> <b>Total Fee Paid Till Now : </b>"+Total_Amount_+"<br/>"
    +" <b>Next Due Date : </b> "+Instalment_Date_+"<br/>"
    +" <b>Next Due Amount : </b> "+BalanceAmount_+"<br/>"
    
    +"<br/> For any Queries regarding Fee Payments contact our Team on any of the below Numbers. <br/>"
    +"<br></br>"
    +" <b style='margin-left: 30px'; >  &#9679;  +91 95674 34151  </b> <br>"
    +" <b style='margin-left: 30px'; >  &#9679;  +91 85907 49146  </b> <br>"
    +" <b style='margin-left: 30px'; >  &#9679;  +91 90749 51347 </b><br/>"
    +" <b style='margin-left: 30px'; >  &#9679;  +91 80751 87029 </b><br/> "
    +" <b style='margin-left: 30px'; >  &#9679;  +91 95674 40597 </b> <br/>"
    +"<br></br>"

    +"<br/> -- <br/>"
    +" Thanks & Regards <br/>"

    +"<br> <b >Training Team </b><br/>"
    +"<b> One Team Solutions </b><br/>"
    +"oneteamsolutions.in <br/>"
    +"<br></br>"  
    +"<img src='cid:myimagecid' alt=''/>  "
     }
   
     sgMail
     var d = await sgMail.send(mailOptions);
     
  return {response};  
},  
	// Send_Receipt_Sms_Email: async function (
	// 	Mobile_,
	// 	Email_,
	// 	Sms,
	// 	Student_Name,
	// 	Amount_,
	// 	Date_,
	// 	Total_Amount_,
	// 	Instalment_Date_,
	// 	BalanceAmount_
	// ) {
	// 	var location_path =
	// 		"http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver=" +
	// 		Mobile_ +
	// 		"&route=TA&msgtype=1&sms=" +
	// 		Sms +
	// 		"";
	// 	//  console.log(location_path)
	// 	const response = await fetch(location_path);
	// 	//  console.log(12)
	// 	let transporter = nodemailer.createTransport({
	// 		host: "smtp.gmail.com",
	// 		port: 587,
	// 		secure: false,
	// 		requireTLS: true,
	// 		auth: {
	// 			user: "training@oneteamsolutions.co.in",
	// 			pass: "Onteam@train9070",
	// 		},
	// 	});
	// 	const mailOptions = {
	// 		//  from: '<b>One Team Solutions</b> '+ '< ' + 'hr@ufstechnologies.com ' + '>',
	// 		from: "training@oneteamsolutions.co.in",
	// 		to: Email_,
	// 		subject: "Payment Received - One Team Solutions ! ",

	// 		attachments: [
	// 			{
	// 				filename: "teamone.PNG",
	// 				type: "image/PNG",
	// 				content_id: "myimagecid",
	// 				content: base64str,
	// 				disposition: "inline",
	// 			},
	// 		],
	// 		html:
	// 			"Dear " +
	// 			Student_Name +
	// 			" , <br/>" +
	// 			"<br> Thank You for Making the Payment ! <br/>" +
	// 			"<br/> We have received a Payment of Rs." +
	// 			Amount_ +
	// 			" on " +
	// 			Date_ +
	// 			". <br/>" +
	// 			// if(BalanceAmount_ = 0)
	// 			// {

	// 			// }

	// 			"<br/> <b>Total Fee Paid Till Now : </b>" +
	// 			Total_Amount_ +
	// 			"<br/>" +
	// 			" <b>Next Due Date : </b> " +
	// 			Instalment_Date_ +
	// 			"<br/>" +
	// 			" <b>Next Due Amount : </b> " +
	// 			BalanceAmount_ +
	// 			"<br/>" +
	// 			"<br/> For any Queries regarding Fee Payments contact our Team on any of the below Numbers. <br/>" +
	// 			"<br></br>" +
	// 			" <b style='margin-left: 30px'; >  &#9679;  +91 95674 34151  </b> <br>" +
	// 			" <b style='margin-left: 30px'; >  &#9679;  +91 85907 49146  </b> <br>" +
	// 			" <b style='margin-left: 30px'; >  &#9679;  +91 90749 51347 </b><br/>" +
	// 			" <b style='margin-left: 30px'; >  &#9679;  +91 80751 87029 </b><br/> " +
	// 			" <b style='margin-left: 30px'; >  &#9679;  +91 95674 40597 </b> <br/>" +
	// 			"<br></br>" +
	// 			"<br/> -- <br/>" +
	// 			" Thanks & Regards <br/>" +
	// 			"<br> <b >Training Team </b><br/>" +
	// 			"<b> One Team Solutions </b><br/>" +
	// 			"oneteamsolutions.in <br/>" +
	// 			"<br></br>" +
	// 			"<img src='cid:myimagecid' alt=''/>  ",
	// 	};

	// 	sgMail;
	// 	var d = await sgMail.send(mailOptions);

	// 	return { response };
	// },
	Get_Student_Receipt_History: function (Student_Id_, Course_Id_, callback) {
		return db.query(
			"CALL Get_Student_Receipt_History(@Student_Id_ :=?,@Course_Id_ :=?)",
			[Student_Id_, Course_Id_],
			callback
		);
	},

	Get_Attendance_Details: function (Student_Id_, Course_Id_, callback) {
		return db.query(
			"CALL Get_Attendance_Details(@Student_Id_ :=?,@Course_Id_ :=?)",
			[Student_Id_, Course_Id_],
			callback
		);
	},

	Get_Student_Receipt_Image: function (Receipt_Voucher_Id, callback) {
		return db.query(
			"CALL Get_Student_Receipt_Image(@Receipt_Voucher_Id :=?)",
			[Receipt_Voucher_Id],
			callback
		);
	},
	Delete_Student_Receipt_Voucher: function (Receipt_Voucher_Id_, callback) {
		return db.query(
			"CALL Delete_Student_Receipt_Voucher(@Receipt_Voucher_Id_ :=?)",
			[Receipt_Voucher_Id_],
			callback
		);
	},
	Send_Sms: async function (Mobile_, Sms) {
		// var location_path="http://sapteleservices.com/SMS_API/sendsms.php?username=mikpsuser&password=mik@pss1050&mobile="
		// +Mobile_+"&sendername=MIKPSS&message="+Sms+" &routetype=1";
		// var location_path="http://adyaconnect.co.in/httpapi/smsapi?uname=Getaboss&password=getaboss2018&sender=ONETEM&receiver="
		// +Mobile_+"&route= PA&msgtype=1&sms="+Sms+ "";
		// var location_path="http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver="
		// +Mobile_+"&route=TA&msgtype=1&sms=Hi,%20sudheesh%20Thank%20you%20for%20Your%20Enquiry%20at%20ONE%20TEAM.%20Our%20Experienced%20trainers%20look%20forward%20to%20Train%20you.%20Visit%20oneteamsolutions.in%20or%20call%209099090ONE%20TEAM%20SOLUTIONS"
		// console.log(location_path)
		var location_path =
			"http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver=" +
			Mobile_ +
			"&route=TA&msgtype=1&sms=" +
			Sms +
			"";

		// console.log(location_path)
		const response = await fetch(location_path);
		console.log(response);
		return { response };
	},
	Send_Sms_Email: async function (Mobile_, Email_, Sms, Student_Name,Login_User_Name,User_Mobile) {
		console.log(Login_User_Name,User_Mobile);
		var location_path =
			"http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver=" +
			Mobile_ +
			"&route=TA&msgtype=1&sms=" +
			Sms +
			"";
			// console.log(Whatsapp);
			
		const response = await fetch(location_path);
		//console.log(response);


		var whatsapp="Hello, " +
		Student_Name +
		" Thank you for Your Enquiry at One Team Solutions!"+
		"Our Experienced trainers are looking forward to Training you."+
		"Feel free to contact your Academic Counsellor  "+Login_User_Name+ "on" +User_Mobile+ "for any further queries."+
		
		"Watch the Below Videos featuring One Team Solutions :"+
		"• Mathrubhumi News Featured One Team Solutions - https://www.youtube.com/watch?v=7mxRTnA64Ds"
		"• Dr.Brijesh George John Featured One Team Solutions - https://youtu.be/o1vYRX74b54"+
		
		"• Ebadu Rahman Famous YouTuber Featured One Team Solutions - https://youtu.be/FU3g63bbqTY"+
		
		"• Our Students Got Featured in a Career Related Program - https://www.youtube.com/watch?v=6Idq42W7wcU&t=2s";

		var location_path ="https://api.telinfy.net/gaca/whatsapp/templates/message/Api-Key:0ea03cd8-169f-4f50-8254-94f50dbcfdaa/Content-Type:application/json/"
		+"data-raw '"+{
		"whatsAppBusinessId": "95fbd0bb-d339-4088-b1ff-c81b42f16e08",
		"phoneNumberId":"103915675851161",
		"from":"9562813713",
		"to": "9995610336",
		"type": "template",
		"templateName": "test_new",
		"templateId": "1475962839556937",
		"language": "en",
		"header": null,
		"body":{
	 	"parameters": [
	 	{
	 	"type": "text",
		 "text": whatsapp
	 	}
	 	]
	 	},
		"button": null
		}

		
		console.log(location_path);
		const response1 = await fetch(location_path);
		console.log(response1);


		let transporter = nodemailer.createTransport({
			host: "smtp.gmail.com",
			port: 587,
			secure: false,
			requireTLS: true,
			auth: {
				user: "training@oneteamsolutions.co.in",
				pass: "Onteam@train9070",
			},
		});
		const mailOptions = {
			from: "training@oneteamsolutions.co.in",
			to: Email_,
			subject: "Thank You for your Enquiry - Course Details - One Team Solutions !",
			attachments: [
				{
					filename: "teamone.PNG",
					type: "image/PNG",
					content_id: "myimagecid",
					content: base64str,
					disposition: "inline",
				},
			],
			html:
				"Hello " + Student_Name +" ,<br/>" +
				"<br/>Thank you for showing interest in Training Programs at One Team Solutions ! <br/>" +
				"<br/> <b>👉 5 Top Reasons to Join One Team Solutions :</b> <br/>" +
				"<br/><b style='margin-left: 30px';>  &#9679;  Fully Hands on </b> Online/Offline Training handled by Experienced Professionals<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> Own <b>Job Portal with 110+ Freshers Jobs</b> Posted Every Month <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b>10 Year old Multinational IT Company with Presence in India<b> (Infopark Phase 2, Kochi)</b>,US and Saudi Arabia<br/>" +
				"<b style='margin-left: 30px'; >  &#9679;  <b>Special HR Training Sessions</b> for students on all Saturdays to Equip a Student for Recruitment Process. <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> One Team will arrange <b>Unlimited Number of Interviews</b> for you till you get placed - <b>YES THAT IS A PROMISE ☺</b> <br/>" +
				"<br/> <b>👉 Placed Students List :</b>https://oneteamsolutions.in/placed-students/<br/>" +
				"<br/> <b>👉 Other Important Links :</b><br/>" +
				"<br/><b style='margin-left: 30px'; >  &#9679;  One Team got Featured in Mathrubhoomi News - </b>  https://www.youtube.com/watch?v=7mxRTnA64Ds <br/>" +
				"<b style='margin-left: 30px'; >  &#9679;  Why Should you Join One Team - </b> https://www.youtube.com/watch?v=wJd0woYR50w <br/>" +
				"<b style='margin-left: 30px'; >  &#9679;  Training Team - </b> https://oneteamsolutions.in/experienced-it-software-training-team-kochi <br/>" +
			
				"<br/>  <b> 👉Bank Accounting Details of One Team Solutions :</b>  <br/>" +
				"Account Name : ONE TEAM SOLUTIONS EDTECH PVT LTD <br/>" +
				"A/c no:-626405021063  <br/>" +
				"IFSC code:-ICIC0006264s <br/>" +
				"BRANCH:- EDAPALLY <br/>" +
				"Account Type : Current <br/>" +
				"<br/> <b style='font-size:18px;'><b>Pay Rs.2000 </b> as seat blocking Amount and block your Seats for the Next Batch !  <br/>" +
				
				"<br/> <b style='font-size:18px;'>Feel Free to Contact us for any Further Queries - 9946870803 </b>  <br/>" +
				"<br/> -- <br/>" +
				"Thanks & Regards <br/>" +
				"<br/><b> Training Team </b><br/>" +
				"<b>One Team Solutions EdTech Pvt Ltd</b><br/>" +
				"oneteamsolutions.in <br/>" +
				"Ph : 9946870803 <br/>" +
				"<br></br>" +
				"<img src='cid:myimagecid' alt=''/>  ",
		};

		sgMail;
		var d = await sgMail.send(mailOptions);
		
		console.log(d);
		return { response };
	},

	Send_course_Email_1: async function (Email_, Student_Name, Course_Name) {
		let transporter = nodemailer.createTransport({
			host: "smtp.gmail.com",
			port: 587,
			secure: false,
			requireTLS: true,
			auth: {
				user: "training@oneteamsolutions.co.in",
				pass: "Onteam@train9070",
			},
		});
		const mailOptions = {
			from: "training@oneteamsolutions.co.in",
			to: Email_,
			subject: "Welcome to One Team Family !",
			attachments: [
				{
					filename: "teamone.PNG",
					type: "image/PNG",
					content_id: "myimagecid",
					content: base64str,
					disposition: "inline",
				},
			],
			html:
				"Dear " + Student_Name + " <br/>" +
				"<br/> We are glad to enroll you at One Team Solutions for the Training and Internship Program ! <br/>" +
				"<br/> Please note and understand that this is not a Job Offer. <br/>" +
				"<br/> <b>What we are offering for you:</b> <br/>" +
				"<br/><b style='margin-left: 30px'; >  &#9679;</b>Training in " +Course_Name +"  <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> HR Training - Interview Preparation, Mock Interviews, CV Preparation & Correction<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> Assured Interviews at our Client Companies after your Course. One Team Solutions will arrange Unlimited Interviews for you till you get Placed. We will support you till you get placed.<br/>" +
				//    +"<b style='margin-left: 30px'; >  &#9679;  Special HR Training Sessions</b> for students on all Saturdays to Equip a Student for Recruitment Process. <br/>"
				//    +"<b style='margin-left: 30px'; >  &#9679; </b> One Team will arrange <b>Unlimited Number of Interviews </b>for you till you get placed - <b> YES THAT IS A PROMISE ☺ </b> <br/>"
				"<br/> <b>Rules and Regulations:</b> <br/>" +
				"<br/><b style='margin-left: 30px'; >  &#9679;</b>You are allowed to take only one leave Per Month (Both Medical and Casual) during the course of the Training and Internship. If you took leaves more than allowed, you will miss the concepts to be taught on that particular day as per the syllabus. <br/>" +
				"<br/> <b style= 'margin-left: 30px''font-size:18px;' 'color:#f14e4e'>&#9679;Students will not be allowed to skip any interviews arranged by One Team Solutions. One Team Solutions has the right to take back all the placement support if this rule is violated </b>  <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> It is also mandatory to attend all Placement Training Sessions organized by One Team Solutions.<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> It is highly advisable to behave like a professional during your Internship Period. Most of the companies will be calling us for reference(To know your attitude and conduct) once when you get placed.<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> One Team Solutions has all rights to take back the Placement Support if the student<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>Skips any of the Interviews/Placement Drives/Job Fairs intimated by One Team Solutions.</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>Fails to provide all documents including but not limited to address proof, identity proof, educational certificates, etc. to complete the</i><br/>" +
				"<br/><b style='margin-left: 50px'; ></b> <i>background verification process.</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i> Discontinues the Training program</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>Fails to pay the Training Fee On Time</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i> Rejects Offers from more than 2 Companies </i><br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> You will be Terminated from the Training Program, with immediate effect, and without notice if:<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b>  <i>Any Declaration given by you or testimonials furnished by you to the company proves to be false</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b>  <i>You are Found to have been convicted for or indulged in criminal, subversive, or immoral activities</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b>  <i>You are found to have Indulged in Financial irregularities.</i><br/>" +
				"<br/><br/>" +
				"<br/>Once Again Welcoming to <strong>One Team Solutions</strong> and we wish you all the very Best ! <br/>" +
				"<br/> -- <br/>" +
				"Thanks & Regards <br/>" +
				"<br/><b> Training Team </b><br/>" +
				"<b>One Team Solutions</b><br/>" +
				"oneteamsolutions.in <br/>" +
				"Ph : 9946870803 <br/>" +
				"<br></br>" +
				"<img src='cid:myimagecid' alt=''/>  ",
		};
		sgMail;
		var d = await sgMail.send(mailOptions);
		//   return {response};
	},
	Send_course_Email_2: async function (Email_, Student_Name, Course_Name) {
		//     var location_path="http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver="
		//     +Mobile_+"&route=TA&msgtype=1&sms="+Sms+ "";

		//         const response =await fetch(location_path);
		// console.log(response)
		console.log(Email_);
		console.log(Student_Name);
		console.log(Course_Name);
		let transporter = nodemailer.createTransport({
			host: "smtp.gmail.com",
			port: 587,
			secure: false,
			requireTLS: true,
			auth: {
				user: "training@oneteamsolutions.co.in",
				pass: "Onteam@train9070",
			},
		});
		const mailOptions = {
			from: "training@oneteamsolutions.co.in",
			to: Email_,
			subject: "Welcome to One Team Family !",
			attachments: [
				{
					filename: "teamone.PNG",
					type: "image/PNG",
					content_id: "myimagecid",
					content: base64str,
					disposition: "inline",
				},
			],
			html:
				"Dear " +
				Student_Name +
				" ,<br/>" +
				"<br/> We are glad to enroll you at One Team Solutions for the Training and Internship Program! <br/>" +
				"<br/> Please note and understand that this is not a Job Offer. <br/>" +
				"<br/> <b>What we are offering for you:</b> <br/>" +
				"<br/><b style='margin-left: 30px'; >  &#9679;</b>Training in " +
				Course_Name +
				"  <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> HR Training - Interview Preparation, Mock Interviews, CV Preparation & Correction<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> Assured Interviews at our Client Companies after your Course. One Team will arrange Unlimited Interviews for you till you get Placed. We will support you till you get placed.<br/>" +
				//    +"<b style='margin-left: 30px'; >  &#9679;  Special HR Training Sessions</b> for students on all Saturdays to Equip a Student for Recruitment Process. <br/>"
				//    +"<b style='margin-left: 30px'; >  &#9679; </b> One Team will arrange <b>Unlimited Number of Interviews </b>for you till you get placed - <b> YES THAT IS A PROMISE ☺ </b> <br/>"
				"<br/> <b>Rules and Regulations:</b> <br/>" +
				"<br/><b style='margin-left: 30px'; >  &#9679;</b>You are allowed to take only one leave Per Month (Both Medical and Casual) during the course of the Training and Internship. If you took<br/>" +
				" <b style='margin-left: 32px'; ></b>leaves more than allowed, you will miss the concepts to be taught on that particular day as per the syllabus. <br/>" +
				"<br/> <b style= 'margin-left: 30px''font-size:18px;'>&#9679;&font-color:#ef071e;Students will not be allowed to skip any interviews arranged by One Team. One Team has the right to take back all the placement support if this rule is violated </b>  <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> It is also mandatory to attend all Placement Training Sessions organized by One Team.<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> It is highly advisable to behave like a professional during your Internship Period. Most of the companies will be calling us for reference(To know your attitude and conduct) once when you get placed.<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> One Team has all rights to take back the Placement Support if the student<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> Skips any of the Interviews/Placement Drives/Job Fairs intimated by One Team.<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> Fails to provide all documents including but not limited to address proof, identity proof, educational certificates, etc. to complete the<br/>" +
				"<b style='margin-left: 52px'; ></b> background verification process.<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> Discontinues the Training program<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> Fails to pay the Training Fee On Time<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> Rejects Offers from more than 2 Companies<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> You will be Terminated from the Training Program, with immediate effect, and without notice if:<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> Any Declaration given by you or testimonials furnished by you to the company proves to be false<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> You are Found to have been convicted for or indulged in criminal, subversive, or immoral activities<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> You are found to have Indulged in Financial irregularities.<br/>" +
				"<br/> -- <br/>" +
				"Thanks & Regards <br/>" +
				"<br/><b> Training Team </b><br/>" +
				"<b>One Team Solutions</b><br/>" +
				"oneteamsolutions.in <br/>" +
				"Ph : 9946870803 <br/>" +
				"<br></br>" +
				"<img src='cid:myimagecid' alt=''/>  ",
		};
		sgMail;
		var d = await sgMail.send(mailOptions);
		//   return {response};
	},

	Send_course_Email: async function (
		Mobile_,
		Email_,
		Sms,
		Student_Name,
		Course_Name
	) {
		// var location_path="http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver="
		//   +Mobile_+"&route=TA&msgtype=1&sms="+Sms+ "";

		// console.log(location_path)

		var location_path =
			"http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver=" +
			Mobile_ +
			"&route=TA&msgtype=1&sms=" +
			Sms +
			"";

		const response = await fetch(location_path);
		console.log(response);


		// var whatsapp="Hello, " +
		// Student_Name +
		// "Please find below the Course Fee and instalment scheme details of"+
		// Course_Name+
		
		// "• One Time Payment Scheme: Rs.32000(Including GST)"+
		// "• Instalment Scheme: Rs.35000(Including GST)"+
		// "• Instalment Intervals:"+
		
		// "o Instalment 1(Registration Fee) - On the day of Joining for the Course - Rs.3000"+
		// "o Instalment 2 - On or before the First Day of Class - Rs.9500"+
		// "o Instalment 2 - On or before the First Day of Class - Rs.9500"+
		// "o Instalment 3 - On or before 25th Day of Class Starting - Rs.12500"+
		// "o Instalment 4 - On or before 45th Day of Class Starting - Rs. 10000";
		




		// console.log(Email_)
		// console.log(Student_Name)
		// console.log(Course_Name)
		// console.log(Mobile_)
		//console.log(Sms)
		let transporter = nodemailer.createTransport({
			host: "smtp.gmail.com",
			port: 587,
			secure: false,
			requireTLS: true,
			auth: {
				user: "training@oneteamsolutions.co.in",
				pass: "Onteam@train9070",
			},
		});
		const mailOptions = {
			from: "training@oneteamsolutions.co.in",
			to: Email_,
			subject: "Welcome to One Team Family !",
			attachments: [
				{
					filename: "teamone.PNG",
					type: "image/PNG",
					content_id: "myimagecid",
					content: base64str,
					disposition: "inline",
				},
			],
			html:
				"Dear " +
				Student_Name +
				" ,<br/>" +
				"<br/> We are glad to enroll you at One Team Solutions for the Training and Internship Program! <br/>" +
				"<br/> Please note and understand that this is not a Job Offer. <br/>" +
				"<br/> <b>What we are offering for you:</b> <br/>" +
				"<br/><b style='margin-left: 30px'; >  &#9679;</b>Training in " +
				Course_Name +
				"  <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> HR Training - Interview Preparation, Mock Interviews, CV Preparation & Correction<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> Assured Interviews at our Client Companies after your Course. One Team Solutions will arrange Unlimited Interviews for you till you get Placed. We will support you till you get placed.<br/>" +
				//    +"<b style='margin-left: 30px'; >  &#9679;  Special HR Training Sessions</b> for students on all Saturdays to Equip a Student for Recruitment Process. <br/>"
				//    +"<b style='margin-left: 30px'; >  &#9679; </b> One Team will arrange <b>Unlimited Number of Interviews </b>for you till you get placed - <b> YES THAT IS A PROMISE ☺ </b> <br/>"
				"<br/> <b>Rules and Regulations:</b> <br/>" +
				"<br/><b style='margin-left: 30px'; >  &#9679;</b>You are allowed to take only one leave Per Month (Both Medical and Casual) during the course of the Training and Internship. If you took<br/>" +
				" <b style='margin-left: 38px'; ></b>leaves more than allowed, you will miss the concepts to be taught on that particular day as per the syllabus. <br/>" +
				" <b style= 'margin-left: 30px;font-size:12px;color:#ef071e;'>&#9679;Students will not be allowed to skip any interviews arranged by One Team Solutions. One Team Solutions has the right to take back all the placement support if this rule is violated </b>  <br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> It is also mandatory to attend all Placement Training Sessions organized by One Team.<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> It is highly advisable to behave like a professional during your Internship Period. Most of the companies will be calling us for reference(To know your attitude and conduct) once when you get placed.<br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> One Team Solutions has all rights to take back the Placement Support if the student<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b><i> Skips any of the Interviews/Placement Drives/Job Fairs intimated by One Team Solutions.</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b><i> Fails to provide all documents including but not limited to address proof, identity proof, educational certificates, etc. to complete the<br/>" +
				"<b style='margin-left: 58px'; ></b> background verification process.</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> Discontinues the Training program<br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>Fails to pay the Training Fee On Time</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>Rejects Offers from more than 2 Companies</i><br/>" +
				"<b style='margin-left: 30px'; >  &#9679; </b> <i>You will be Terminated from the Training Program, with immediate effect, and without notice if:</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>Any Declaration given by you or testimonials furnished by you to the company proves to be false</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>You are Found to have been convicted for or indulged in criminal, subversive, or immoral activities</i><br/>" +
				"<b style='margin-left: 50px'; >  &#9679; </b> <i>You are found to have Indulged in Financial irregularities.</i><br/>" +

				"<br/><br/>" +
				"<br/>Once Again Welcoming to One Team Solutions and we wish you all the very Best ! <br/>" +

				"<br/> -- <br/>" +
				"Thanks & Regards <br/>" +
				"<br/><b> Training Team </b><br/>" +
				"<b>One Team Solutions</b><br/>" +
				"oneteamsolutions.in <br/>" +
				"Ph : 9946870803 <br/>" +
				"<br></br>" +
				"<img src='cid:myimagecid' alt=''/>  ",
		};
		sgMail;
		var d = await sgMail.send(mailOptions);
		return { response };
	},
	Search_Attendance: function (Course_, Batch_, Faculty_, callback) {
		return db.query(
			"CALL Search_Attendance(@Course_ :=?,@Batch_ :=?,@Faculty_ :=?)",
			[Course_, Batch_, Faculty_],
			callback
		);
	},
	Save_Attendance: async function (Attendance_Master_) {
		console.log(Attendance_Master_);
		return new Promise(async (rs, rej) => {
			const pool = db.promise();
			let result1;
			var connection = await pool.getConnection();
			// await connection.beginTransaction();

			// var Absent_Value_ =0;
			// let Absent_Student_ = Attendance_Master_.Absent_Student;
			// if (Absent_Student_ != undefined && Absent_Student_ != '' && Absent_Student_ != null)
			// Absent_Value_ = 1
			// else{
			//   Absent_Student_=['{"name":"John", "age":30, "car":null}']
			// }
			// var Attendance_Student_Value_ =0;
			// let Attendance_Student_ = Attendance_Master_.Attendance_Student;
			// if (Attendance_Student_ != undefined && Attendance_Student_ != '' && Attendance_Student_ != null)
			// Attendance_Student_Value_ = 1
			// else{
			//   Attendance_Student_=['{"name":"John", "age":30, "car":null}']
			// }
			// var Attendance_Subject_Value_ =0;
			// let Attendance_Subject_ = Attendance_Master_.Attendance_Subject;
			// if (Attendance_Subject_ != undefined && Attendance_Subject_ != '' && Attendance_Subject_ != null)
			// Attendance_Subject_Value_ = 1
			// else{
			//   Attendance_Subject_=['{"name":"John", "age":30, "car":null}']
			// }

			try {
				const result1 = await new storedProcedure(
					"Save_Attendance",
					[
						Attendance_Master_.Attendance_Master_Id,
						Attendance_Master_.Course_Id,
						Attendance_Master_.Batch_Id,
						Attendance_Master_.Faculty_Id,
						Attendance_Master_.Duration,
						Attendance_Master_.Percentage,
						Attendance_Master_.Attendance_Student,
						Attendance_Master_.Attendance_Subject,
						Attendance_Master_.Attendance_Student_Value,
						Attendance_Master_.Attendance_Subject_Value,
					],
					connection
				).result();
				// await connection.commit();

				connection.release();
				rs(result1);
			} catch (err) {
				// await connection.rollback();
				rej(err);
			}
		});
	},
	Search_Attendance_Report: function (
		From_Date,
		To_Date,
		Faculty_Id,
		Course_,
		Batch_,
		Attendance_Status_Id,
		User_Id_,
		callback
	) {
		console.log(Attendance_Status_Id);
		console.log(User_Id_);
		return db.query(
			"CALL Search_Attendance_Report(@From_Date :=?,@To_Date :=?,@Faculty_Id :=?,@Course_ :=?,@Batch_ :=?,@Attendance_Status_Id :=?,@User_Id_ :=?)",
			[
				From_Date,
				To_Date,
				Faculty_Id,
				Course_,
				Batch_,
				Attendance_Status_Id,
				User_Id_,
			],
			callback
		);
	},
	Search_Fees_Outstanding_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Batch_,
		SearchbyName_,
		User_Id_,
		teammember_,
		callback
	) {
		if (SearchbyName_ === undefined || SearchbyName_ === "undefined")
			SearchbyName_ = "";
		return db.query(
			"CALL Search_Fees_Outstanding_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Batch_ :=?,@SearchbyName_ :=?,@User_Id_ :=?,@teammember_ :=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Course_,
				Batch_,
				SearchbyName_,
				User_Id_,
				teammember_,
			],
			callback
		);
	},
	Search_Fees_Collection_Report: function (
		Is_Date_,
		From_Date,
		To_Date,
		User_Id_,
		Login_User_,
		Mode_,
		callback
	) {
		return db.query(
			"CALL Search_Fees_Collection_Report(@Is_Date_ :=?,@From_Date :=?,@To_Date :=?,@User_Id_ :=?,@Login_User_ :=?,@Mode_ :=?)",
			[Is_Date_, From_Date, To_Date, User_Id_, Login_User_, Mode_],
			callback
		);
	},
	Search_Admission_Report: function (
		Is_Date_,
		From_Date,
		To_Date,
		User_Id_,
		Login_User_Id_,
		Course_Id_,
		Enquiry_Source_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Admission_Report(@Is_Date_ :=?,@From_Date :=?,@To_Date :=?,@User_Id_ :=?,@Login_User_Id_:=?,@Course_Id_:=?,@Enquiry_Source_Id_:=?)",
			[Is_Date_, From_Date, To_Date, User_Id_, Login_User_Id_,Course_Id_,Enquiry_Source_Id_],
			callback
		);
	},
	Search_Lead_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Enquiry_Source_,
		Login_User_,
		User_Id_,
		status_,
		Course_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Lead_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Enquiry_Source_ :=?,@Login_User_:=?,@User_Id_:=?,@status_:=?,@Course_Id_:=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Enquiry_Source_,
				Login_User_,
				User_Id_,
				status_,
				Course_Id_,
			],
			callback
		);
	},



	Search_Conversion_Report: function (
		Is_Date_,
		To_Date_,
		Login_User_,
		User_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Conversion_Report(@Is_Date_ :=?,@To_Date_ :=?,@Login_User_:=?,@User_Id_:=?)",
			[
				Is_Date_,
				To_Date_,
				Login_User_,
				User_Id_,
			],
			callback
		);
	},






	
	Search_Conversion_Report_loginuser: function (
		Is_Date_,
		To_Date_,
		Login_User_,
	
		callback
	) {
		return db.query(
			"CALL Search_Conversion_Report_loginuser(@Is_Date_ :=?,@To_Date_ :=?,@Login_User_:=?)",
			[
				Is_Date_,
				To_Date_,
				Login_User_,
				
			],
			callback
		);
	},



	Search_Transaction: function (Course_, Portion_Covered_, callback) {
		return db.query(
			"CALL Search_Transaction(@Course_ :=?,@Portion_Covered_ :=?)",
			[Course_, Portion_Covered_],
			callback
		);
	},
	Save_Transaction: async function (Transaction_Master_) {
		return new Promise(async (rs, rej) => {
			const pool = db.promise();
			let result1;
			var connection = await pool.getConnection();
			await connection.beginTransaction();
			try {
				console.log(Transaction_Master_);
				const result1 = await new storedProcedure(
					"Save_Transaction",
					[
						Transaction_Master_.Transaction_Master_Id,
						Transaction_Master_.Course_Id,
						Transaction_Master_.Batch_Id,
						Transaction_Master_.User_Id,
						Transaction_Master_.Employer_Details_Id,
						Transaction_Master_.Portion_Covered,
						Transaction_Master_.Description,
						Transaction_Master_.Transaction_Student,
					],
					connection
				).result();
				await connection.commit();
				connection.release();
				for (var i = 0; i < result1.length; i++) {
					var location_path =
						"http://sapteleservices.com/SMS_API/sendsms.php?username=mikpsuser&password=mik@pss1050&mobile=" +
						result1[i].Phone +
						"&sendername=MIKPSS&message=RESUME SHARING ALERT:Your Resume has been send to " +
						result1[i].Description_ +
						" by " +
						result1[i].Company_Name_ +
						" PLACEMENT TEAM.You can expect a Call/Message/Email from them.Support 6282202033 ";
					const response = await fetch(location_path);
				}
				rs([{ Transaction_Master_Id_: result1[0].Transaction_Master_Id_ }]);
			} catch (err) {
				await connection.rollback();
				rej(err);
			}
		});
	},
	Search_Interview: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		callback
	) {
		return db.query(
			"CALL Search_Interview(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_],
			callback
		);
	},
	Save_Interview: async function (Interview_Master_) {
		return new Promise(async (rs, rej) => {
			const pool = db.promise();
			let result1;
			var connection = await pool.getConnection();
			await connection.beginTransaction();
			try {
				const result1 = await new storedProcedure(
					"Save_Interview",
					[
						Interview_Master_.Interview_Master_Id,
						Interview_Master_.Course_Id,
						Interview_Master_.Batch_Id,
						Interview_Master_.User_Id,
						Interview_Master_.Employer_Details_Id,
						Interview_Master_.Description,
						Interview_Master_.Interview_Date,
						Interview_Master_.Interview_Student,
					],
					connection
				).result();
				await connection.commit();
				connection.release();
				for (var i = 0; i < result1.length; i++) {
					var location_path =
						"http://sapteleservices.com/SMS_API/sendsms.php?username=mikpsuser&password=mik@pss1050&mobile=" +
						result1[i].Phone +
						"&sendername=MIKPSS&message=INTERVIEW ALERT:A New interview has been scheduled for you by " +
						result1[i].Company_Name_ +
						" PLACEMENT TEAM on " +
						result1[i].Interview_Date_ +
						" at " +
						result1[i].Description_ +
						" .Please check your Email more details.Call 6282202033";
					const response = await fetch(location_path);
				}
				rs([{ Interview_Master_Id_: result1[0].Interview_Master_Id_ }]);
			} catch (err) {
				await connection.rollback();
				rej(err);
			}
		});
	},

	Search_Placed: function (Is_Date_, From_Date_, To_Date_, Course_, callback) {
		return db.query(
			"CALL Search_Placed(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_],
			callback
		);
	},
	Save_Placed: async function (Placed_Master_) {
		return new Promise(async (rs, rej) => {
			const pool = db.promise();
			let result1;
			var connection = await pool.getConnection();
			await connection.beginTransaction();
			try {
				const result1 = await new storedProcedure(
					"Save_Placed",
					[
						Placed_Master_.Placed_Master_Id,
						Placed_Master_.Course_Id,
						Placed_Master_.Batch_Id,
						Placed_Master_.User_Id,
						Placed_Master_.Employer_Details_Id,
						Placed_Master_.Description,
						Placed_Master_.Placed_Date,
						Placed_Master_.Placed_Student,
					],
					connection
				).result();

				await connection.commit();
				connection.release();
				rs(result1);
			} catch (err) {
				await connection.rollback();
				rej(err);
			}
		});
	},

	Search_Placed_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Company_,
		User_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Placed_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Company_ :=?,@User_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_, Company_, User_Id_],
			callback
		);
	},
	Search_Interview_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Company_,
		User_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Interview_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Company_ :=?,@User_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_, Company_, User_Id_],
			callback
		);
	},
	Search_Transaction_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Company_,
		User_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Transaction_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Company_ :=?,@User_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_, Company_, User_Id_],
			callback
		);
	},
	Get_Dashboard_Count: async function (By_User_) {
		var Leads = [];
		try {
			Leads = await new storedProcedure("Get_Dashboard_Count", [
				By_User_,
			]).result();
			//console.log(Leads);
		} catch (e) {}
		return { returnvalue: { Leads } };
	},
	Search_Registration_Report: async function (
		Fromdate_,
		Todate_,
		Search_By_,
		SearchbyName_,
		Status_Id_,
		By_User_,
		Is_Date_Check_,
		Page_Index1_,
		Page_Index2_,
		Login_User_Id_,
		RowCount,
		RowCount2,
		Course_Id_,
		Enquiry_Source_Id_
	) {
		var Leads = [];
		try {
			if (
				SearchbyName_ === "0" ||
				SearchbyName_ === undefined ||
				SearchbyName_ === "undefined" ||
				SearchbyName_ === 0
			)
				SearchbyName_ = "";
			console.log(Search_By_, SearchbyName_);
			Leads = await new storedProcedure("Search_Registration_Report", [
				Fromdate_,
				Todate_,
				Search_By_,
				SearchbyName_,
				Status_Id_,
				By_User_,
				Is_Date_Check_,
				Page_Index1_,
				Page_Index2_,
				Login_User_Id_,
				RowCount,
				RowCount2,
				Course_Id_,
		Enquiry_Source_Id_,
			]).result();
			//console.log(Leads);
		} catch (e) {}
		return { returnvalue: { Leads } };
	},

	Search_Attendance_Student: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Batch_,
		Faculty_,
		callback
	) {
		return db.query(
			"CALL Search_Attendance_Student(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Batch_ :=?,@Faculty_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_, Batch_, Faculty_],
			callback
		);
	},
	Get_Attendance: function (
		Attendance_Master_Id_,
		Course_,
		Batch_,
		Faculty_,
		callback
	) {
		return db.query(
			"CALL Get_Attendance(@Attendance_Master_Id_ :=?,@Course_ :=?,@Batch_ :=?,@Faculty_ :=?)",
			[Attendance_Master_Id_, Course_, Batch_, Faculty_],
			callback
		);
	},

	Search_Transaction_Student: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Faculty_,
		Employer_Details_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Transaction_Student(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Faculty_ :=?,@Employer_Details_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_, Faculty_, Employer_Details_Id_],
			callback
		);
	},
	Get_Transaction: function (Transaction_Master_Id_, Course_, callback) {
		return db.query(
			"CALL Get_Transaction(@Transaction_Master_Id_ :=?,@Course_ :=?)",
			[Transaction_Master_Id_, Course_],
			callback
		);
	},
	Search_Interview_Student: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Faculty_,
		Employer_Details_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Interview_Student(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Faculty_ :=?,@Employer_Details_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_, Faculty_, Employer_Details_Id_],
			callback
		);
	},
	Get_Interview: function (Interview_Master_Id_, Course_, callback) {
		return db.query(
			"CALL Get_Interview(@Interview_Master_Id_ :=?,@Course_ :=?)",
			[Interview_Master_Id_, Course_],
			callback
		);
	},
	Search_Placed_Student: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Faculty_,
		callback
	) {
		return db.query(
			"CALL Search_Placed_Student(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Faculty_ :=?)",
			[Is_Date_, From_Date_, To_Date_, Course_, Faculty_],
			callback
		);
	},
	Get_Placed: function (Placed_Master_Id_, Course_, callback) {
		return db.query(
			"CALL Get_Placed(@Placed_Master_Id_ :=?,@Course_ :=?)",
			[Placed_Master_Id_, Course_],
			callback
		);
	},
	Load_Installment_Type: function (callback) {
		return db.query("CALL Load_Installment_Type()", [], callback);
	},
	Load_State: function (callback) {
		return db.query("CALL Load_State()", [], callback);
	},
	Load_Qualification: function (callback) {
		return db.query("CALL Load_Qualification()", [], callback);
	},
	Search_State_District_Typeahead: function (
		District_Name_,
		State_Id_,
		callback
	) {
		if (District_Name_ === undefined || District_Name_ === "undefined")
			District_Name_ = "";
		return db.query(
			"CALL Search_State_District_Typeahead(@District_Name_ :=?,@State_Id_ :=?)",
			[District_Name_, State_Id_],
			callback
		);
	},
	Load_Employer_Details: function (callback) {
		return db.query("CALL Load_Employer_Details()", [], callback);
	},
	Get_Lead_Load_Data: async function () {
		const Users = await new storedProcedure("Dropdown_Users", []).result();
		const Status = await new storedProcedure("Dropdown_Status", []).result();
		return { returnvalue: { Users, Status } };
	},
	FollowUp_Summary: async function (By_User_, Login_User_) {
		
		var Leads = [];

		try {
			Leads = await new storedProcedure("FollowUp_Summary", [
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
	Pending_FollowUp: async function (By_User_, Login_User_) {
		var Leads = [];
		try {
			Leads = await new storedProcedure("Pending_FollowUp", [
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
	Get_Lead_Load_Data_ByUser: function (Login_User, callback) {
		return db.query(
			"CALL Get_Lead_Load_Data_ByUser(@Login_User :=?)",
			[Login_User],
			callback
		);
	},
	Get_Course_Details_Student_Check: function (Student_Id_, callback) {
		return db.query(
			"CALL Get_Course_Details_Student_Check(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},

	Search_Fees_Due_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		Batch_,
		SearchbyName_,
		User_Id_,
		teammember_,
		callback
	) {
		if (SearchbyName_ === undefined || SearchbyName_ === "undefined")
			SearchbyName_ = "";
		return db.query(
			"CALL Search_Fees_Due_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@Batch_ :=?,@SearchbyName_ :=?,@User_Id_ :=?,@teammember_ :=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Course_,
				Batch_,
				SearchbyName_,
				User_Id_,
				teammember_,
			],
			callback
		);
	},



	Search_DropOut_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Course_,
		ToStaff_,
		User_Id_,
		callback
	) {
		
		return db.query(
			"CALL Search_DropOut_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Course_ :=?,@ToStaff_ :=?,@User_Id_ :=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Course_,
				ToStaff_,
				User_Id_,
			],
			callback
		);
	},



	Search_Batch_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Batch_,
		Faculty_,
		
		User_Id_,
		callback
	) {
		
		return db.query(
			"CALL Search_Batch_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Batch_ :=?,@Faculty_ :=?,@User_Id_ :=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Batch_,
				Faculty_,
				
				User_Id_,
			],
			callback
		);
	},


	Search_Active_Batch_Report: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Batch_,
		Faculty_,
		Course_,
		User_Id_,
		FollowUp_Branch_Id_,
		callback
	) {
		
		return db.query(
			"CALL Search_Active_Batch_Report(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Batch_ :=?,@Faculty_ :=?,@Course_ :=?,@User_Id_ :=?,@FollowUp_Branch_Id_ :=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Batch_,
				Faculty_,
				Course_,
				User_Id_,
				FollowUp_Branch_Id_,
			],
			callback
		);
	},



	Search_Syllabus_Coverage: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Batch_,
		Faculty_,
		Course_,
		User_Id_,
		FollowUp_Branch_Id,
		callback
	) {
		
		return db.query(
			"CALL Search_Syllabus_Coverage(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Batch_ :=?,@Faculty_ :=?,@Course_ :=?,@User_Id_ :=?,@FollowUp_Branch_Id :=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Batch_,
				Faculty_,
				Course_,
				User_Id_,
				FollowUp_Branch_Id,
			],
			callback
		);
	},


	Search_Batch_Completion: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		Batch_,
		Faculty_,
		Course_,
		User_Id_,
		FollowUp_Branch_Id,
		callback
	) {
		
		return db.query(
			"CALL Search_Batch_Completion(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@Batch_ :=?,@Faculty_ :=?,@Course_ :=?,@User_Id_ :=?,@FollowUp_Branch_Id :=?)",
			[
				Is_Date_,
				From_Date_,
				To_Date_,
				Batch_,
				Faculty_,
				Course_,
				User_Id_,
				FollowUp_Branch_Id,
			],
			callback
		);
	},



	Load_Interview_Student: function (Transaction_Master_id_, callback) {
		return db.query(
			"CALL Load_Interview_Student(@Transaction_Master_id_ :=?)",
			[Transaction_Master_id_],
			callback
		);
	},
	Load_Placement_Student: function (Interview_Master_Id_, callback) {
		return db.query(
			"CALL Load_Placement_Student(@Interview_Master_Id_ :=?)",
			[Interview_Master_Id_],
			callback
		);
	},

	Get_Load_Dropdowns_Data: function (callback) {
		return db.query("CALL Get_Load_Dropdowns_Data()", [], callback);
	},


	Upload_Resume: function (Docs_Data, callback)
    {
        console.log(Docs_Data);
         var Document_value_ = 0; 
         let Docs_ = Docs_Data.Docs_D;
    
         if (Docs_ != undefined && Docs_ != '' && Docs_ != null)
            Document_value_ = 1;  
            console.log(Docs_);
         return db.query("CALL Upload_Resume(" + "@Docs_:=?," + "@Document_value_ :=? )"
      , [Docs_, Document_value_],callback);
    },

	Save_Student_Import: function (Student_Details, callback) {
		console.log(Student_Details);
		return db.query(
			"CALL Save_Student_Import(@Student_Import_Details_ :=?,@By_User_Id_ :=?,@Status_ :=?,@To_User_ :=?,@Enquiry_Source_ :=?,@Next_FollowUp_Date_ :=?,@Status_Name_ :=?,@Enquiry_Source_Name_ :=?,@To_User_Name_ :=?,@By_User_Name_ :=?,@Status_FollowUp_ :=?,@Remark_ :=?)",
			[
				JSON.stringify(Student_Details.Student_Import_Details),
				Student_Details.By_User_Id,
				Student_Details.Status,
				Student_Details.To_User,
				Student_Details.Enquiry_Source,
				Student_Details.Next_FollowUp_Date,
				Student_Details.Status_Name,
				Student_Details.Enquiry_Source_Name,
				Student_Details.To_User_Name,
				Student_Details.By_User_Name,
				Student_Details.Status_FollowUp,
				Student_Details.Remark,
			],
			callback
		);
	},

	Search_Student_Import: function (
		From_Date_,
		To_Date_,
		Is_Date_Check_,
		callback
	) {
		return db.query(
			"CALL Search_Student_Import(@From_Date_ :=?,@To_Date_ :=?,@Is_Date_Check_ :=?)",
			[From_Date_, To_Date_, Is_Date_Check_],
			callback
		);
	},

	Search_Team_Member_Typeahead: function (Users_Name, callback) {
		if (Users_Name === undefined || Users_Name === "undefined")
		Users_Name = "";
		return db.query(
			"CALL Search_Team_Member_Typeahead(@Users_Name :=?)",
			[Users_Name],
			callback
		);
	},


	Search_Company_Typeahead: function (Company_Name, callback) {
		if (Company_Name === undefined || Company_Name === "undefined")
			Company_Name = "";
		return db.query(
			"CALL Search_Company_Typeahead(@Company_Name :=?)",
			[Company_Name],
			callback
		);
	},

	Search_Job_Typeahead: function (Job_Title, callback) {
		if (Job_Title === undefined || Job_Title === "undefined")
		Job_Title = "";
		return db.query(
			"CALL Search_Job_Typeahead(@Job_Title :=?)",
			[Job_Title],
			callback
		);
	},


	Search_District_Typeahead: function (District_Name, callback) {
		if (District_Name === undefined || District_Name === "undefined")
			District_Name = "";
		return db.query(
			"CALL Search_District_Typeahead(@District_Name :=?)",
			[District_Name],
			callback
		);
	},

	Search_Transaction_Report_Tab: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		User_Id_,
		Student_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Transaction_Report_Tab(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@User_Id_ :=?,@Student_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, User_Id_, Student_Id_],
			callback
		);
	},
	Search_Interview_Report_Tab: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		User_Id_,
		Student_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Interview_Report_Tab(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@User_Id_ :=?,@Student_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, User_Id_, Student_Id_],
			callback
		);
	},
	Search_Placed_Report_Tab: function (
		Is_Date_,
		From_Date_,
		To_Date_,
		User_Id_,
		Student_Id_,
		callback
	) {
		return db.query(
			"CALL Search_Placed_Report_Tab(@Is_Date_ :=?,@From_Date_ :=?,@To_Date_ :=?,@User_Id_ :=?,@Student_Id_ :=?)",
			[Is_Date_, From_Date_, To_Date_, User_Id_, Student_Id_],
			callback
		);
	},

	Save_Student_Report_FollowUp: function (Student_Followup_, callback) {
		console.log(Student_Followup_);
		return db.query(
			"CALL Save_Student_Report_FollowUp(@Student_Id_ :=?,@Status_ :=?,@To_User_Id_ :=?,@Remark_ :=?,@Next_FollowUp_Date_ :=?,@By_User_Id_ :=?,@StatusName_ :=?,@ToUserName_ :=?,@ByUserName_ :=?,@Status_FollowUp_ :=?,@Remark_Id_ :=?)",
			[
				Student_Followup_.Student_Id,
				Student_Followup_.Status,
				Student_Followup_.To_User_Id,
				Student_Followup_.Remark,
				Student_Followup_.Next_FollowUp_Date,
				Student_Followup_.By_User_Id,
				Student_Followup_.Status_Name,
				Student_Followup_.To_User_Name,
				Student_Followup_.By_User_Name,
				Student_Followup_.FollowUp,
				Student_Followup_.Remark_Id,
			],
			callback
		);
	},

	Load_Laptopdetails:function(callback)
	{ 
	  return db.query("CALL Load_Laptopdetails()", [],callback);
	},



	Get_Applied_List_Mobile:function(Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,Apply_type_,callback)
	{ 
   
   if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
   Pointer_Start_=0;
   
   if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
   Pointer_Stop_=0; 
   
   return db.query("CALL Get_Applied_List_Mobile(@Student_Id_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?,@Apply_type_ :=?)",
   [Student_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,Apply_type_],callback);
	},


	Get_Applied_List_Admin:function(Pointer_Start_,Pointer_Stop_,Page_Length_,Apply_type_,
		Is_Date_,From_Date,To_Date,callback)
	{ 
   
   if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
   Pointer_Start_=0;
   
   if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
   Pointer_Stop_=0; 
   
   return db.query("CALL Get_Applied_List_Admin(@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?,@Apply_type_ :=?,@Is_Date_ :=?,@From_Date :=?,@To_Date :=?)",
   [Pointer_Start_,Pointer_Stop_,Page_Length_,Apply_type_,Is_Date_,From_Date,To_Date],callback);
	},


	get_Notification_Status: function (Student_Id_, callback) {
		return db.query(
			"CALL get_Notification_Status(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},

	set_Notification_Status: function (Student_Id_,Status_Id, callback) {
		console.log(Student_Id_,Status_Id);
		return db.query(
			"CALL set_Notification_Status(@Student_Id_ :=?,@Status_Id_ :=?)",
			[Student_Id_,Status_Id],
			callback
		);
	},


	Enable_Student_Status: function (Student_Id_, callback) {
		return db.query(
			"CALL Enable_Student_Status(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},

	Disable_Student_Status: function (Student_Id_, callback) {
		return db.query(
			"CALL Disable_Student_Status(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},




	Activate_Status: function (Student_Id_, callback) {
		return db.query(
			"CALL Activate_Status(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},



	Deactivate_Status: function (Student_Id_, callback) {
		return db.query(
			"CALL Deactivate_Status(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},




	Moveto_Blacklist_Status: function (Student_Id_, callback) {
		return db.query(
			"CALL Moveto_Blacklist_Status(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},



	Remove_Blacklist_Status: function (Student_Id_, callback) {
		return db.query(
			"CALL Remove_Blacklist_Status(@Student_Id_ :=?)",
			[Student_Id_],
			callback
		);
	},

	// Update_Resume_Status: function (Resume_Status_Id_,Resume_Status_Name_,Student_Id_,callback
    //     ) {
          
    //         return db.query(
    //             "CALL Update_Resume_Status(@Resume_Status_Id_ :=?,@Resume_Status_Name_ :=?,@Student_Id_ :=?)",
    //             [Resume_Status_Id_,Resume_Status_Name_,Student_Id_],
    //             callback
    //         );
    //     },

		Get_ToStaff_Mobile: function (userid, callback) {
			return db.query(
				"CALL Get_ToStaff_Mobile(@userid :=?)",
				[userid],
				callback
			);
		},
		



		Update_Device_Id: async function (Student_) {
			return new Promise(async (rs, rej) => {
				const pool = db.promise();
				let result1;
				var connection = await pool.getConnection();
				await connection.beginTransaction();
				try {
					const result1 = await new storedProcedure(
						"Update_Device_Id",
						[
							Student_.Student_Id,
							Student_.Device_Id,
						],
						connection
					).result();
	


					await connection.commit();
					connection.release();
					rs(result1);
					console.log(result1)
				} catch (err) {
					await connection.rollback();
					rej(err);
				}
			});
		},






		// Register_Whatsapp: async function (Register_Whatsapp_) {
			
		// 	var location_path =
		// 		"https://api.telinfy.net/gaca/whatsapp/templates/message" +
		// 		Register_Whatsapp_ ;
	
		// 	 console.log(location_path)
		// 	const response = await fetch(location_path);
		// 	console.log(response);
		// 	return { response };
		// },

		Register_Whatsapp1: async function (Register_Whatsapp_) {

			console.log(Register_Whatsapp_)
			var location_path = "https://api.telinfy.net/gaca/whatsapp/templates/message" + Register_Whatsapp_;
			console.log(location_path);
			const options = {
				headers: {
					'Content-Type': 'application/json',
					'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
				}
			};
			const response = await fetch(location_path, options);
			console.log(response);
			return { response };
		},

		Register_Whatsapp: async function (Register_Whatsapp_,) {

			try {

				Register_Whatsapp_.to=""+Register_Whatsapp_.to+"",

				console.log(Register_Whatsapp_)
				const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", Register_Whatsapp_, { headers: {
					'Content-Type': 'application/json',
					'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
				} });
				console.log(response)
				return response.data;
				
			}
			
			 catch (error) {
				// console.log(response)
				console.log(error)
				throw error;
			}
		},
		
		Save_Student_Whatsapp: async function (Save_Whatsapp_) {

			try {
				// console.log(""+Save_Whatsapp_.to+"")
				console.log(Save_Whatsapp_)

				const data = {
					// "to": ""+Save_Whatsapp_.to+"",
					"to": Save_Whatsapp_.to,
					"type": "template",
					"templateName": "api_enquiry_arjun_19thjan2023",
					"language": "en",
					"header": "Thank You for your Enquiry !",
					"body":{
						"parameters": [
							{
								"type": "text",
								"text": Save_Whatsapp_.student
							},
							{
								"type": "text",
								"text": Save_Whatsapp_.tostaff
							}
						]
					},
					"button": null
					
				};
					// console.log(body)
					const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
						'Content-Type': 'application/json',
						'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
					} });
				// console.log(body)
				console.log(data)
				return response.data;
				
			}
			
			 catch (error) {
				// console.log(response)
				console.log(error)
				throw error;
			}
		}

,


Save_Python_Course_Whatsapp: async function (Python_Whatsapp_) {

	try {
		console.log(Python_Whatsapp_.header)
		console.log(Python_Whatsapp_.to)

		const data = {
			"to": ""+Python_Whatsapp_.to+"",
			"type": "template",
			"templateName": "api_trackbox_registration_python_jan2023",
			"language": "en",
			"header": null,
			"body":{
				"parameters": [
					{
						"type": "text",
						"text": Python_Whatsapp_.trainer_name
					},
					{
						"type": "text",
						"text": Python_Whatsapp_.batch_start_date
					},
					{
						"type": "text",
						"text": Python_Whatsapp_.tostaff
					},
					{
						"type": "text",
						"text": Python_Whatsapp_.student
					}
				]
			},
			"button": null
		};
			// console.log(body)
			const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
				'Content-Type': 'application/json',
				'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
			} });
		// console.log(body)
		//console.log(response)
		return response.data;
		
	}
	
	 catch (error) {
		// console.log(response)
		console.log(error)
		throw error;
	}
}

,


Save_Dm_Course_Whatsapp: async function (Dm_Whatsapp_) {

	try {
		console.log(Dm_Whatsapp_.header)
		console.log(Dm_Whatsapp_.to)

		const data = {
			"to": ""+Dm_Whatsapp_.to+"",
			"type": "template",
			"templateName": "api_trackbox_registration_digitalmarketing_jan2023",
			"language": "en",
			"header": null,
			"body":{
				"parameters": [
					{
						"type": "text",
						"text": Dm_Whatsapp_.trainer_name
					},
					{
						"type": "text",
						"text": Dm_Whatsapp_.batch_start_date
					},
					{
						"type": "text",
						"text": Dm_Whatsapp_.tostaff
					},
					{
						"type": "text",
						"text": Dm_Whatsapp_.student
					}
				]
			},
			"button": null
		};
			// console.log(body)
			const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
				'Content-Type': 'application/json',
				'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
			} });
		// console.log(body)
		//console.log(response)
		return response.data;
		
	}
	
	 catch (error) {
		// console.log(response)
		console.log(error)
		throw error;
	}
}

,

Save_Test_Course_Whatsapp: async function (Testing_Whatsapp_) {

	try {
		console.log(Testing_Whatsapp_.header)
		console.log(Testing_Whatsapp_.to)

		const data = {
			"to": ""+Testing_Whatsapp_.to+"",
			"type": "template",
			"templateName": "api_trackbox_registration_testing_jan_2023",
			"language": "en",
			"header": null,
			"body":{
				"parameters": [
					{
						"type": "text",
						"text": Testing_Whatsapp_.trainer_name
					},
					{
						"type": "text",
						"text": Testing_Whatsapp_.batch_start_date
					},
					{
						"type": "text",
						"text": Testing_Whatsapp_.tostaff
					},
					{
						"type": "text",
						"text": Testing_Whatsapp_.student
					}
				]
			},
			"button": null
		};
			// console.log(body)
			const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
				'Content-Type': 'application/json',
				'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
			} });
		// console.log(body)
		//console.log(response)
		return response.data;
		
	}
	
	 catch (error) {
		// console.log(response)
		console.log(error)
		throw error;
	}
}

,


Python_Fees_Whatsapp: async function (Python_Whatsapp_) {

	try {

		const data = {
			"to": ""+Python_Whatsapp_.to+"",
			"type": "template",
			"templateName": "api_trackbox_fee_installment_python_jan2023",
			"language": "en",
			"header": null,
			"body":{
				"parameters": [
					{
						"type": "text",
						"text": Python_Whatsapp_.student
					},
					{
						"type": "text",
						"text": Python_Whatsapp_.tostaff
					}
				]
			},
			"button": null
		};
			// console.log(body)
			const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
				'Content-Type': 'application/json',
				'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
			} });
		// console.log(body)
		//console.log(response)
		return response.data;
		
	}
	
	 catch (error) {
		// console.log(response)
		console.log(error)
		throw error;
	}
}

,


Dm_Fees_Whatsapp: async function (Dm_Whatsapp_) {

	try {

		const data = {
			"to": ""+Dm_Whatsapp_.to+"",
			"type": "template",
			"templateName": "api_trackbox_fee_installment_dm_jan2023",
			"language": "en",
			"header": null,
			"body":{
				"parameters": [
					{
						"type": "text",
						"text": Dm_Whatsapp_.student
					},
					{
						"type": "text",
						"text": Dm_Whatsapp_.tostaff
					}
				]
			},
			"button": null
		};
			// console.log(body)
			const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
				'Content-Type': 'application/json',
				'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
			} });
		// console.log(body)
		//console.log(response)
		return response.data;
		
	}
	
	 catch (error) {
		// console.log(response)
		console.log(error)
		throw error;
	}
}

,


Testing_Fees_Whatsapp: async function (Testing_Whatsapp_) {

	try {
		const data = {
			"to": ""+Testing_Whatsapp_.to+"",
			"type": "template",
			"templateName": "api_trackbox_fee_installment_testing_jan2023",
			"language": "en",
			"header": null,
			"body":{
				"parameters": [
					{
						"type": "text",
						"text": Testing_Whatsapp_.student
					},
					{
						"type": "text",
						"text": Testing_Whatsapp_.tostaff
					}
				]
			},
			"button": null
		};
			// console.log(body)
			const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
				'Content-Type': 'application/json',
				'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
			} });
		// console.log(body)
		//console.log(response)
		return response.data;
		
	}
	
	 catch (error) {
		// console.log(response)
		console.log(error)
		throw error;
	}
}

,




Fees_Payment_Whatsapp: async function (Fees_Whatsapp_) {

	try {

		const data = {
			"to": ""+Fees_Whatsapp_.to+"",
			"type": "template",
			"templateName": "api_trackbox_fee_jan2023",
			"language": "en",
			"header": null,
			"body":{
				"parameters": [
					{
						"type": "text",
						"text": Fees_Whatsapp_.student
					},
					{
						"type": "text",
						"text": Fees_Whatsapp_.payment_amount
					},
					{
						"type": "text",
						"text": Fees_Whatsapp_.pending_amount
					},
					{
						"type": "text",
						"text": Fees_Whatsapp_.next_payment_date
					}
					,
					{
						"type": "text",
						"text": Fees_Whatsapp_.tostaff
					}
				]
			},
			"button": null
		};
			//  console.log(response)
			const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
				'Content-Type': 'application/json',
				'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
			} });
		// console.log(body)
		console.log(response)
		return response.data;
		
	}
	
	 catch (error) {
		// console.log(response)
		console.log(error)
		throw error;
	}
}

,




					 Send_Resume_Upload_Notification: async function (
						Student_Name_
					) {
						
						let transporter = nodemailer.createTransport({
							host: "smtp.gmail.com",
							port: 587,
							secure: false,
							requireTLS: true,
							auth: {
								user: "training@oneteamsolutions.co.in",
								pass: "Onteam@train9070",
							},
						});
						const mailOptions = {
							from: "training@oneteamsolutions.co.in",
							to: 'hr@oneteamsolutions.in', 
							subject: 'Resume Uploaded ',
					
							html:"Our Student "+Student_Name_+" Uploaded a Resume."
							+"<br/>Please Check and Verify it.<br/>"
							+"<br/><br/>" 
						};
						// console.log(mailOptions)   
						sgMail;
						var d = await sgMail.send(mailOptions);
						return { response };
					},






		Send_Resume_Upload_Notification: async function (Student_Name_) 
		{
		// var Email_=Data.Email;
		// console.log(Email_)
				return new Promise(async (rs,rej)=>{
			const pool = db.promise();
				let result1;
				var connection = await pool.getConnection();
				await connection.beginTransaction();         
				try
				{
				const result1 = await(new storedProcedure('Resume_Upload_Notification_Mail',[], connection)).result(); 

				await connection.commit();
				connection.release(); 
							let transporter = nodemailer.createTransport({
								host: "smtp.gmail.com",
								port: 587,
								secure: false,
								requireTLS: true,
								auth: {
									user: "training@oneteamsolutions.co.in",
									pass: "Onteam@train9070",
								},
							});                     
                          const msg = {
							from: "training@oneteamsolutions.co.in",
							to: result1[0].Email, 
							subject: 'Resume Uploaded ',
					
							html:"Our Student "+Student_Name_+" Uploaded a Resume."
							+"<br/>Please Check and Verify it.<br/>"
							+"<br/><br/>"                              
                           } 
						   console.log(msg)                         
                           transporter.sendMail( msg,function(err,info)
                           {
                             if(err)
                             return false;
                             else 
                               return true;
                             console.log(err)
                           }); 
                           rs(result1);                                                            
                       }   
                       catch (err) {
                         await connection.rollback();
                         rej(err);
                       }
                     })
                     },


					 Reset_Notification_Count: function (User_Id_, callback) {
						return db.query(
							"CALL Reset_Notification_Count(@User_Id_ :=?)",
							[User_Id_],
							callback
						);
					},
					Get_All_Notification: function (Date_, User_Id_, login_Id_, callback) {
						return db.query(
							"CALL Get_All_Notification(@Date_ :=?,@User_Id_ :=?,@login_Id_ :=?)",
							[Date_, User_Id_, login_Id_],
							callback
						);
					},

					Get_Individual_Notification: function (Student_Id_, Notification_Id_,Login_user_Id_, callback) {
						return db.query(
							"CALL Get_Individual_Notification(@Student_Id_ :=?,@Notification_Id_ :=?,@Login_user_Id_ :=?)",
							[Student_Id_, Notification_Id_,Login_user_Id_],
							callback
						);
					},


					Notification_Read_Status: function (Notification_Count_,User_Id_, callback) {
						console.log(Notification_Count_,User_Id_)
						return db.query(
							"CALL Notification_Read_Status(@Notification_Count_ :=?,@User_Id_ :=?)",
							[Notification_Count_,User_Id_],
							callback
						);
					},
				
					update_Read_Status: function (login_user_, Notification_Id_, callback) {
						return db.query(
							"CALL update_Read_Status(@login_user_ :=?,@Notification_Id_ :=?)",
							[login_user_, Notification_Id_],
							callback
						);
					},


					Save_Complaint:function(Complaint_,callback)
					{ 
				return db.query("CALL Save_Complaint("+
				"@Complaint_Id_ :=?,"+
				"@Student_Id_ :=?,"+
				"@Description_ :=?"+")"
					,[Complaint_.Complaint_Id,
					  Complaint_.Student_Id,
					  Complaint_.Description],callback);
					}
					,



					Get_Complaint:function(Student_Id_,callback)
					{ 

				   return db.query("CALL Get_Complaint(@Student_Id_:=?)",
				   [Student_Id_],callback);
					},
				
	Get_Login_User_Type: function (Login_User, callback) {
		return db.query(
			"CALL Get_Login_User_Type(@Login_User :=?)",
			[Login_User],
			callback
		);
	},				


	Search_Batch_End_Warning: function (Login_User, callback) {
		return db.query(
			"CALL Search_Batch_End_Warning(@Login_User :=?)",
			[Login_User],
			callback
		);
	},	

	Mark_As_Complete: function (Login_User,Batch_Id_,Status_, callback) {
		return db.query(
			"CALL Mark_As_Complete(@Login_User :=?,@Batch_Id_ :=?,@Status_ :=?)",
			[Login_User,Batch_Id_,Status_],
			callback
		);
	},				


	Change_Status: function (Login_User,Complaint_Id_,Status_, callback) {
		return db.query(
			"CALL Change_Status(@Login_User :=?,@Complaint_Id_ :=?,@Status_ :=?)",
			[Login_User,Complaint_Id_,Status_],
			callback
		);
	},		



	Save_Self_Placed:function(Self_Placement_,callback)
{ 
    console.log(Self_Placement_)
return db.query("CALL Save_Self_Placed("+"@Self_Placement_Id_ :=?,"+"@Student_Id_ :=?,"+"@Company_Name_ :=?,"+"@Designation_ :=?,"+"@Placed_Date_ :=?,"+"@Student_Course_Id_ :=?"+")"
,[Self_Placement_.Self_Placement_Id,Self_Placement_.Student_Id,Self_Placement_.Company_Name,Self_Placement_.Designation,Self_Placement_.Placed_Date,Self_Placement_.Student_Course_Id ],callback);
},


Get_Self_Placement: function (Student_Id_, callback) {
	return db.query(
		"CALL Get_Self_Placement(@Student_Id_ :=?)",
		[Student_Id_],
		callback
	);
},


Delete_Self_Placement:function(Self_Placement_Id_,callback)
{ 
  return db.query("CALL Delete_Self_Placement(@Self_Placement_Id_ :=?)", [Self_Placement_Id_],callback);
},



Search_Employer_Status_Typeahead: function (Employer_Status_Name, callback) {
	if (Employer_Status_Name === undefined || Employer_Status_Name === "undefined")
	Employer_Status_Name = "";
	return db.query(
		"CALL Search_Employer_Status_Typeahead(@Employer_Status_Name :=?)",
		[Employer_Status_Name],
		callback
	);
},

					
};
module.exports = Student;




