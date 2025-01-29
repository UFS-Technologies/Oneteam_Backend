var http = require('http');
var server = http.Server(app);
var socketIO = require('socket.io');
var io = socketIO(server);
var CronJob = require('cron').CronJob;
const axios = require('axios');
const nodemailer = require("nodemailer");
const fetch = require("node-fetch");
var storedProcedure=require('./helpers/stored-procedure');
var FCM = require('fcm-node');
    var serverKey = 'AAAAP1i3MJ0:APA91bHASQ7S7EkOPtLtVG7y3VxVsXWAi2LXsSFXwZWeTXIT5iG9usMyXXkckY_frLJ2JwOy4-aYQs7_BKaMjopHfdqQp94jvICyn1j-9kd5hP_SwM-3svy7Fq6xMf6Ml_O9YhIf7L1B';
    var fcm = new FCM(serverKey);

var db=require('./dbconnection');
var apppath = '/';
//var apppath = '/';
 const port = process.env.PORT || 3514;
 process.env.SENDGRID_API_KEY = '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';
// sendgrid.env.SENDGRID_API_KEY='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';
var cron = require('node-cron');
var express = require("express");
var path = require("path");
var favicon = require("serve-favicon");
var multer = require('multer');
var multerupload = multer({ dest: 'fileprint/' })
var logger = require("morgan");
var cookieParser = require("cookie-parser");
var bodyParser = require("body-parser");
var cors = require("cors");
const jwt = require('./helpers//jwt');
var routes = require("./routes/index");
const errorHandler = require('./helpers/error-handler');

var Login = require("./routes/Login");
var Public_Data = require('./routes/Public_Data');

var Accounts = require('./routes/Accounts');
var Agent = require('./routes/Agent');
var Agent_Commision = require('./routes/Agent_Commision');
var Agent_Course_Type = require('./routes/Agent_Course_Type');
var Batch = require('./routes/Batch');
var Candidate = require('./routes/Candidate');
var Candidate_Followup = require('./routes/Candidate_Followup');
var Candidate_Job_Apply = require('./routes/Candidate_Job_Apply');
var Category = require('./routes/Category');
var Certificate_Request = require('./routes/Certificate_Request');
var Certificates = require('./routes/Certificates');
var Course = require('./routes/Course');
var Course_Fees = require('./routes/Course_Fees');
var Course_Import_Details = require('./routes/Course_Import_Details');
var Course_Import_Master = require('./routes/Course_Import_Master');
var Course_Subject = require('./routes/Course_Subject');
var Course_Type = require('./routes/Course_Type');
var Document = require('./routes/Document');
var Exam_Details = require('./routes/Exam_Details');
var Exam_Master = require('./routes/Exam_Master');
var Experience = require('./routes/Experience');
var Fees_Instalment = require('./routes/Fees_Instalment');
var Fees_Receipt = require('./routes/Fees_Receipt');
var Fees_Type = require('./routes//Fees_Type');
var Followup_Type = require('./routes/Followup_Type');
var Functionl_Area = require('./routes/Functionl_Area');
var Enquiry_Source = require('./routes/Enquiry_Source');
var Job_Posting = require('./routes/Job_Posting');
var Mark_List = require('./routes/Mark_List');
var Part = require('./routes/Part');
var Qualification = require('./routes/Qualification');
var Question = require('./routes//Question');
var Question_Import = require('./routes/Question_Import');
var Settings = require('./routes/Settings');
var Specialization = require('./routes/Specialization');
var Status = require('./routes/Status');
var Student = require('./routes/Student');
var Student_Course = require('./routes/Student_Course');
var Student_Course_Subject = require('./routes/Student_Course_Subject');
var Student_Followup = require('./routes/Student_Followup');
var Study_Materials = require('./routes/Study_Materials');
var State = require('./routes/State');
var Subject = require('./routes/Subject');
var University = require('./routes/University');
var University_Followup = require('./routes/University_Followup');
var User_Role = require('./routes/User_Role');
var User_Type = require('./routes/User_Type');
var Users = require('./routes/Users');
var Employer_Details = require('./routes/Employer_Details');
var GeneralFunctions = require('./routes/GeneralFunctions');
var Student_Data=require('./routes//Student_Data');
var ApplyJobs = require('./routes/Apply_Jobs');
var Company = require('./routes/Company');
var Employer_Status = require('./routes/Employer_Status');
var Syllabus_Import = require('./routes/Syllabus_Import');
var Period = require('./routes/Period');
var Recruitment_Drives = require('./routes/Recruitment_Drives');

var app = express();

app.set("views", path.join(__dirname, "views"));
app.set("view engine", "jade");
app.use(cors());
app.use(logger("dev"));
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));
app.use("/", routes);
app.use("/Login", Login);
app.use('/Public_Data',Public_Data);







app.post("/Post_GoogleSheet_Lead/", async function (req, res, next) {
  try {
    const pool = db.promise();
    var connection = await pool.getConnection();
    var Lead_ = req.body.data;

    try {

      console.dir(req.body);

      if (Lead_['What is your Full Name?'] == undefined || Lead_['What is your Full Name?'] == 'What is your Full Name?') {
        console.log("invalid")
        return res.send({
          "success": "false"
        })

      } else {
        // if (typeof Lead_['Age '] !== "number" || isNaN(Lead_['Age '])) {
        //   Lead_['Age '] = 0;
        // }
        // if (typeof Lead_['Percentage (%) ?'] !== "number" || isNaN(Lead_['Percentage (%) ?'])) {
        //   Lead_['Percentage (%) ?'] = 0;
        // }
        // if (typeof Lead_['pass out Year '] !== "number" || isNaN(Lead_['pass out Year '])) {
        //   Lead_['pass out Year '] = 0;
        // }
        // Lead_['Passport '] = Lead_['Passport '].toLowerCase().includes('yes') ? 1 : 0;
        let t = await (new storedProcedure('Post_GoogleSheet_Lead', [

          Lead_['What is your Full Name?'],
          Lead_['Phone number'],
          Lead_['Email'],
          Lead_['City'], 
          Lead_['What is your Qualification'],
          Lead_['Do you prefer Offline classes?'], 
        ], connection)).result();
        console.log('t: ', t);

        var result = {
          Student_Name: t[0].Student_Name_,
          Student_Id: t[0].Student_Id_,
        }
        // io.emit("new-message", result);
        connection.release();

        return res.send(result);
      }

    }
    catch (err) {
      console.log("err",err);
      await connection.rollback();
      return res.send(err);
    }
  } catch (e) {
    console.log("e",e);
    return res.send(e);
  } finally {
  }
});






app.use(jwt());

app.use('/Accounts', Accounts);
app.use('/Agent', Agent);
app.use('/Agent_Commision', Agent_Commision);
app.use('/Agent_Course_Type', Agent_Course_Type);
app.use('/Batch', Batch);
app.use('/Candidate', Candidate);
app.use('/Candidate_Followup', Candidate_Followup);
app.use('/Candidate_Job_Apply', Candidate_Job_Apply);
app.use('/Category', Category);
app.use('/Certificate_Request', Certificate_Request);
app.use('/Certificates', Certificates);
app.use('/Course', Course);
app.use('/Course_Fees', Course_Fees);
app.use('/Course_Import_Details', Course_Import_Details);
app.use('/Course_Import_Master', Course_Import_Master);
app.use('/Course_Subject', Course_Subject);
app.use('/Course_Type', Course_Type);
app.use('/Document', Document);
app.use('/Exam_Details', Exam_Details);
app.use('/Exam_Master', Exam_Master);
app.use('/Experience', Experience);
app.use('/Fees_Instalment', Fees_Instalment);
app.use('/Fees_Receipt', Fees_Receipt);
app.use('/Fees_Type', Fees_Type);
app.use('/Followup_Type', Followup_Type);
app.use('/Functionl_Area', Functionl_Area);
app.use('/Enquiry_Source', Enquiry_Source);
app.use('/Job_Posting', Job_Posting);
app.use('/Mark_List', Mark_List);
app.use('/Part', Part);
app.use('/Qualification', Qualification);
app.use('/Question', Question);
app.use('/Question_Import', Question_Import);
app.use('/Settings', Settings);
app.use('/Specialization', Specialization);
app.use('/Status', Status);
app.use('/Student', Student);
app.use('/Student_Course', Student_Course);
app.use('/Student_Course_Subject', Student_Course_Subject);
app.use('/Student_Followup', Student_Followup);
app.use('/Study_Materials', Study_Materials);
app.use('/Subject', Subject);
app.use('/University', University);
app.use('/University_Followup', University_Followup);
app.use('/User_Role', User_Role);
app.use('/User_Type', User_Type);
app.use('/Users', Users);
app.use('/State', State);
app.use('/Employer_Details', Employer_Details);
app.use('/GeneralFunctions', GeneralFunctions);
app.use('/Student_Data',Student_Data);
app.use('/Apply_Jobs', ApplyJobs);
app.use('/Company', Company);
app.use('/Syllabus_Import', Syllabus_Import);
app.use(apppath+'Employer_Status', Employer_Status);
app.use('/Period', Period);
app.use('/Recruitment_Drives', Recruitment_Drives);

app.use(function(req, res, next) {
  var err = new Error("Not Found");
  err.status = 404;
  next(err);
 
});
async function getUserAsync(name) 
{
  let response = await fetch(name);
  let data = await response.json()
  return data;
}
var Get_Data = function(callback)
 {   
    return db.query("CALL Get_Outstanding_Fees()",[],callback);
};

// var job = cron.schedule('00 45 23 * * *',function()  {
  
var job = cron.schedule('00 00 00  * * *',function()  {
//   console.log(1)
// });
// var job = new CronJob('1,2,4,5 * * * *', function() 
// {
  try 
   {
    Get_Data(function (err, rows)
    {
    if (err) 
      {
      console.log(err)
      }
    else
      {
        console.log(rows)
        var values = [];
        var t = [];
         values = rows;
       console.log(rows)
        t= values[0]
    for(var i = 0; i < t.length; i++)
        {
         //console.log(t)
         var mob='9562813713';
          var Sms='Fee Reminder from One Team Solutions.Your Fee of '+t[i].Amount+' is due on '+t[i].DueDate+'.Please pay the Fee on or before '+t[i].DueDate+'.Ignore if already paid.Contact '+t[i].Mobile+' ONETEAM';
          var location_path="http://adyaconnect.co.in/httpapi/smsapi?uname=GETABOSS&password=getaboss2018&sender=ONETEM&receiver="+t[i].Phone+"&route=TA&msgtype=1&sms="+Sms+ "";
          getUserAsync(location_path);

          // var whatsapp="Hello, " +
          // t[i].Student +
          // " Fee Reminder from One Team Solutions !."+
          // "Your Fee of Rs. "+t[i].Amount+"is due on"+t[i].DueDate+"Please pay the Fee on or before"+t[i].DueDate+
          // "Ignore if already paid."+     
          // "For any further Support contact your Academic Counsellor on 9562813713";
           
          // var location_path1 ="https://api.telinfy.net/gaca/whatsapp/templates/message/Api-Key:0ea03cd8-169f-4f50-8254-94f50dbcfdaa/Content-Type:application/json/"
          // +"data-raw '"+{
          // "whatsAppBusinessId": "95fbd0bb-d339-4088-b1ff-c81b42f16e08",
          // "phoneNumberId":"103915675851161",
          // "from":"9562813713",
          // "to": "9995610336",
          // "type": "template",
          // "templateName": "test_new",
          // "templateId": "1475962839556937",
          // "language": "en",
          // "header": null,
          // "body":{
          //  "parameters": [
          //  {
          //  "type": "text",
          //  "text": whatsapp
          //  }
          //  ]
          //  },
          // "button": null
          // }

          getUserAsync(location_path1);

          //console.log(location_path);
        }
      }   
    }
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
job.start();








var Get_Data_Fees = function(callback)
 {   
   return db.query("CALL Get_Outstanding_Fees()",[],callback);
};


var job123 = cron.schedule('00 00 00 * * *',function()  {
  try 
   {
    Get_Data_Fees(function (err, rows)
    {
   
      console.log(rows);
      var values = [];
      var t = [];
      values = rows;
      console.log(rows);
      t = values[0];
  
      for (var i = 0; i < t.length; i++) {
        const sms = {
          username: 'oneteamsolutions1',
          password: 'f9dde2',
          mobile: t[i].Phone,
          message: `Fee Reminder from One Team Solutions. Your Fee of ${t[i].Amount} is due on ${t[i].DueDate}. Please pay the Fee on or before ${t[i].DueDate}. Ignore if already paid. Contact ${t[i].Mobile} ONETEAM`,
          sendername: 'ONETEM',
          routetype: 1,
          tid: '1607100000000204642'
        };
  
        // Construct URLSearchParams for the query string
        const params = new URLSearchParams({
          username: sms.username,
          password: sms.password,
          mobile: sms.mobile,
          message: sms.message,
          sendername: sms.sendername,
          routetype: sms.routetype.toString(),
          tid: sms.tid
        });
  
        if (sms.UC) {
          params.append('UC', sms.UC);
        }
  
        try {
          // Make the GET request using axios
          const response =  axios.get('https://sapteleservices.com/SMS_API/sendsms.php', { params });
          console.log('SMS response:', response);
        } catch (smsError) {
          console.log('Error sending SMS:', smsError);
        }
      }
    }
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
job123.start();










var Get_Automatic_Mails = function(callback)
 {   
   return db.query("CALL Get_Automatic_Mails()",[],callback);       
};











// var jobx = cron.schedule('00 00 23 * * *',function()  {
  var jobx = cron.schedule('00 00 00 * * *',function()  {
  try 
   {
    Get_Automatic_Mails(function (err, rows)
    {
    if (err) 
      {
      console.log(err)
      }
    else
      {       
        var values = [];
        var t = [];
         values = rows;       
        t= values[0];  // userdetails
        u= values[1];
        q= values[10];   // studentdetails
        console.log(q)  
        var a =
          "<table style='border-collapse: collapse;  border-spacing: 0; vertical-align: top;  width:100%; ' >";
        var b = "",c="",d="";
        var tempuser_name=''
        debugger
    for(var i = 0; i < t.length; i++)
        {
          // if(tempuser_name!=t[i].Users_Name){
            b = "",c="",d="";
              b = b +
          
              "<tr><td style='padding:5px'> Hello " + t[i].Users_Name + "</td></tr><br>" +
              "<tr><td style='padding:5px'> Your Today’s Follow Ups: " + q[0].Next_FollowUp_Date + "</td></tr><br>"
              

            // }
              for (var j = 0; j < u.length; j++) {
                if (
                  Number(t[i].To_User_Id) == Number(u[j].To_User_Id)
                ) {             
                  c=c+
              "<tr style ='background:#1d5ea0;color:#eef0f0; font-weight:bold; width:100%;><td style='padding:5px'></td>"+
              "<td style='padding:5px'><b>" + u[j].Student_Name + '</b>    '+ u[j].CourseName +'    '+ u[j].Phone +'    '+ u[j].StatusName +'    '+ u[j].Remark + "</td></tr><br>"
            }
          }  
            d=d+
              "<tr><td style='padding:5px'> Please follow up these cases now itself and add remarks in Trackbox. </td></tr><br>" +
              "<tr><td style='padding:5px'> Go To Trackbox. - <a href='https://oneteam1267.trackbox.in/#/Student'>https://oneteam1267.trackbox.in/#/Student</a> </td></tr><br>" +
              "<tr><td style='padding:5px'> Don’t Reply to this Email. </td></tr><br>" 
            // tempuser_name=t[i].Users_Name;      
        a = a + b +c+d+ "</table>";
        let transporter = nodemailer.createTransport({
          host: "smtp.gmail.com",
          port: 587,
          secure: false,
          requireTLS: true,
          auth: {
            user: "sreelakshmim@ufstechnologies.com",
            pass: "sreeufs@8091",
          },
        });
        const msg = {
          to:t[i].Email,
          from: "sreelakshmim@ufstechnologies.com", 
          subject: "Todays Followup",
          html:b+c+d
        };
        console.log(msg)        
        transporter.sendMail( msg,function(err,info)
        {
          if(err)
           return false;
           else 
            return true;
          console.log(err)    
        });
        // break
      }        
    }
  } 
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
jobx.start();



// var joby = cron.schedule('00 00 23 * * *',function()  {
  
var joby = cron.schedule('00 00 00 * * *',function()  {
  try 
   {
    Get_Automatic_Mails(function (err, rows)
    {
    if (err) 
      {
      console.log(err)
      }
    else
      {
       // pendingfollowup
        var values = [];
        var t = [];
         values = rows;       
        t= values[2];  // userdetails
        u= values[3];  // studentdetails
        console.log(t)  
        var a =
          "<table style='border-collapse: collapse;  border-spacing: 0; vertical-align: top;  width:100%; ' >";
        var b = "",c="",d="";
        var tempuser_name=''
        debugger
    for(var i = 0; i < t.length; i++)
        {        
            b = "",c="",d="";
              b = b +
              "<tr><td style='padding:5px'> Hello " + t[i].Users_Name + "</td></tr><br>" +
              "<tr><td style='padding:5px'> You have Pending Follow Ups to Do. Clear this immediately </td></tr><br>"
            // }
              for (var j = 0; j < u.length; j++) {
                if (
                  Number(t[i].To_User_Id) == Number(u[j].To_User_Id)
                ) {             
                  c=c+
              "<tr style ='background:#1d5ea0;color:#eef0f0; font-weight:bold; width:100%;><td style='padding:5px'></td><br>"+
              "<td style='padding:5px'><b>" + u[j].Student_Name +'</b>    '+ u[j].CourseName +'    '+ u[j].Phone +'    '+ u[j].StatusName +'    '+ u[j].Remark + "</td></tr><br>"               
            }
          }  
            d=d+             
              "<tr><td style='padding:5px'> Click here to see your Pending Follow Up List. - <a href='https://oneteam1267.trackbox.in/#/Pending_FollowUp'>https://oneteam1267.trackbox.in/#/Pending_FollowUp</a> </td></tr><br>" +
              "<tr><td style='padding:5px'> Don’t Reply to this Email. </td></tr><br>"       
        a = a + b +c+d+ "</table>";
        let transporter = nodemailer.createTransport({
          host: "smtp.gmail.com",
          port: 587,
          secure: false,
          requireTLS: true,
          auth: {
            user: "sreelakshmim@ufstechnologies.com",
            pass: "sreeufs@8091",
          },
        });
        const msg = {
          to:t[i].Email,
          from: "sreelakshmim@ufstechnologies.com", 
          subject: "Pending Follow Ups",
          html:b+c+d
        };
        console.log(msg)        
        transporter.sendMail( msg,function(err,info)
        {
          if(err)
           return false;
           else 
            return true;
          console.log(err)    
        });
        // break
      }        
    }
  } 
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
joby.start();


// var jobz = cron.schedule('00 00 23 * * *',function()  {
var jobz = cron.schedule('00 00 00 * * *',function()  {
  try 
   {
    Get_Automatic_Mails(function (err, rows)
    {
    if (err) 
      {
      console.log(err)
      }
    else
      {
       // pendingfollowup
        var values = [];
        var t = [];
         values = rows;       
        t= values[4];  // userdetails
        u= values[5];  // studentdetails
        console.log(t)  
        var a =
          "<table style='border-collapse: collapse;  border-spacing: 0; vertical-align: top;  width:100%; ' >";
        var b = "",c="",d="";
        var tempuser_name=''
        debugger
    for(var i = 0; i < t.length; i++)
        {        
            b = "",c="",d="";
              b = b +
              "<tr><td style='padding:5px'> Hello " + t[i].Users_Name + "</td></tr><br>" +
              "<tr><td style='padding:5px'>Do Collect the below mentioned Fee today itself : </td></tr><br>"
            // }
              for (var j = 0; j < u.length; j++) {
                if (
                  Number(t[i].To_User_Id) == Number(u[j].To_User_Id)
                ) {             
                  c=c+
              "<tr style ='background:#1d5ea0;color:#eef0f0; font-weight:bold; width:100%;><td style='padding:5px'></td><br>"+
              "<td style='padding:5px'><b>" + u[j].Student +'</b>    '+ u[j].Phone +'    '+ u[j].Amount +'   '+ u[j].Batch +'    '+ u[j].DueDate + "</td></tr><br>"               
            }
          }  
            d=d+
              "<tr><td style='padding:5px'> Collect this Fee Immediately and Add in Trackbox  </td></tr><br>"+
              "<tr><td style='padding:5px'>  Click Here to See your Outstanding List - <a href='https://oneteam1267.trackbox.in/#/Fees_Outstanding_Report'>https://oneteam1267.trackbox.in/#/Fees_Outstanding_Report</a> </td></tr><br>" +
              "<tr><td style='padding:5px'> Don’t Reply to this Email. </td></tr><br>" 
        a = a + b +c+d+ "</table>";
        let transporter = nodemailer.createTransport({
          host: "smtp.gmail.com",
          port: 587,
          secure: false,
          requireTLS: true,
          auth: {
            user: "sreelakshmim@ufstechnologies.com",
            pass: "sreeufs@8091",
          },
        });
        const msg = {
          to:t[i].Email,
          from: "sreelakshmim@ufstechnologies.com", 
          subject: "Today’s Collection Plan",
          html:b+c+d
        };
        console.log(msg)        
        transporter.sendMail( msg,function(err,info)
        {
          if(err)
           return false;
           else 
            return true;
          console.log(err)    
        });
        // break
      }        
    }
  } 
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
jobz.start();


// var jobq = cron.schedule('00 00 23 * * *',function()  {
  var jobq = cron.schedule('00 00 00 * * *',function()  {
  try 
   {
    Get_Automatic_Mails(function (err, rows)
    {
    if (err) 
      {
      console.log(err)
      }
    else
      {
       // pendingfollowup
        var values = [];
        var t = [];
         values = rows;       
        t= values[6];  // userdetails
        u= values[7];  // studentdetails
        console.log(t)  
        var a =
          "<table style='border-collapse: collapse;  border-spacing: 0; vertical-align: top;  width:100%; ' >";
        var b = "",c="",d="";
        var tempuser_name=''
        debugger
    for(var i = 0; i < t.length; i++)
        {        
            b = "",c="",d="";
              b = b +
              "<tr><td style='padding:5px'> Hello " + t[i].teammember + "</td></tr><br>" +
              "<tr><td style='padding:5px'> The following Fee are getting Due tomorrow – " + t[i].DueDate + "  . Call the students now and remind them about the Payment </td></tr><br>" 
            // }
              for (var j = 0; j < u.length; j++) {
                if (
                  Number(t[i].To_User_Id) == Number(u[j].To_User_Id)
                ) {             
                  c=c+
              "<tr style ='background:#1d5ea0;color:#eef0f0; font-weight:bold; width:100%;><td style='padding:5px'></td><br>"+
              "<td style='padding:5px'><b>" + u[j].Student +'</b>    '+ u[j].Phone +'    '+ u[j].Amount +'   '+ u[j].Batch +'    '+ u[j].DueDate + "</td></tr><br>"               
            }
          }  
            d=d+
              "<tr><td style='padding:5px'> Collect this Fee Immediately and Add in Trackbox  </td></tr><br>"+
              "<tr><td style='padding:5px'>  Click Here to See your Outstanding List - <a href='https://oneteam1267.trackbox.in/#/Fees_Due_Report'>https://oneteam1267.trackbox.in/#/Fees_Due_Report</a> </td></tr><br>" +
              "<tr><td style='padding:5px'> Don’t Reply to this Email. </td></tr><br>"       
        a = a + b +c+d+ "</table>";
        let transporter = nodemailer.createTransport({
          host: "smtp.gmail.com",
          port: 587,
          secure: false,
          requireTLS: true,
          auth: {
            user: "sreelakshmim@ufstechnologies.com",
            pass: "sreeufs@8091",
          },
        });
        const msg = {
          to:t[i].Email,
          from: "sreelakshmim@ufstechnologies.com", 
          subject: "Tomorrow’s Fee Dues",
          html:b+c+d
        };
        console.log(msg)        
        transporter.sendMail( msg,function(err,info)
        {
          if(err)
           return false;
           else 
            return true;
          console.log(err)    
        });
        // break
      }  
    }
  } 
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
jobq.start();



// var jobq = cron.schedule('00 29 23 * * *',function()  {
  var jobq = cron.schedule('00 00 00 * * *',function()  {
  try 
   {
    Get_Automatic_Mails(function (err, rows)
    {
    if (err) 
      {
      console.log(err)
      }
    else
      {
       // pendingfollowup
        var values = [];
        var t = [];
         values = rows;       
        t= values[8];  // userdetails
        u= values[9];  // studentdetails
        console.log(t)  
        var a =
          "<table style='border-collapse: collapse;  border-spacing: 0; vertical-align: top;  width:100%; ' >";
        var b = "",c="",d="";
        var tempuser_name=''
        debugger
    for(var i = 0; i < t.length; i++)
        {        
            b = "",c="",d="";
              b = b +
              "<tr><td style='padding:5px'> Hello " + t[i].teammember + "</td></tr><br>" +
              "<tr><td style='padding:5px'> The below mentioned Students of yours are starting their batches tomorrow – " + t[i].before_onedays + "  . Give them a reminder call now and ask them to report on time and pay fee before Classes. </td></tr><br>" 
            // }
              for (var j = 0; j < u.length; j++) {
                if (
                  Number(t[i].To_User_Id) == Number(u[j].To_User_Id)
                ) {             
                  c=c+
              "<tr style ='background:#1d5ea0;color:#eef0f0; font-weight:bold; width:100%;><td style='padding:5px'></td><br>"+
              "<td style='padding:5px'><b>" + u[j].Student +'</b>    '+ u[j].Phone +'  '+ u[j].Batch +'    '+ u[j].Batch_Start_Date + "</td></tr><br>"              
            }
          }  
            d=d+
              "<tr><td style='padding:5px'>  Click Here to See the batch report - <a href='https://oneteam1267.trackbox.in/#/Batch_Report'>https://oneteam1267.trackbox.in/#/Batch_Report</a> </td></tr><br>" +
              "<tr><td style='padding:5px'> Don’t Reply to this Email. </td></tr><br>"       
        a = a + b +c+d+ "</table>";
        let transporter = nodemailer.createTransport({
          host: "smtp.gmail.com",
          port: 587,
          secure: false,
          requireTLS: true,
          auth: {
            user: "sreelakshmim@ufstechnologies.com",
            pass: "sreeufs@8091",
          },
        });
        const msg = {
          to:t[i].Email,
          from: "sreelakshmim@ufstechnologies.com", 
          subject: "Batch Reminder",
          html:b+c+d
        };
        console.log(msg)        
        transporter.sendMail( msg,function(err,info)
        {
          if(err)
           return false;
           else 
            return true;
          console.log(err)    
        });
        // break
      }        
    }
  } 
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
jobq.start();





















async function getUserAsync(name) 
{
  let response1 = await fetch(name);
  let data1 = await response1.json()
  return data1;
}

var Automatic_App_Notification = function(callback)
 {   
   return db.query("CALL Automatic_App_Notification()",[],callback);
};

// var job1 = cron.schedule('00 18 11 * * *',function()  {
  var job1 = cron.schedule('00 00 00 * * *',function()  {
  try 
   {
    Automatic_App_Notification(function (err, rows)
    {
    if (err) 
      {
      console.log(err)
      }
    else
      {
        // console.log(rows)
        var values = [];
        var t1 = [];
         values = rows;
      //  console.log(rows)
        t1= values[0]
        t2= values[1]
        t3= values[2]
        var tempId=''
        var job_Id=''
        for(var i=0;i<t1.length;i++)
        {
            if(t1[i].Device_Id !=null)
        tempId = (t1[i].Device_Id) ;
            job_Id=t1[i].Job_Id
        var message = {
        registration_ids:[tempId ],
        notification: {
                title: 'Offered Jobs',
                body:	"You have "+t1[i].Job_Count+ " Pending Jobs " 
            },
            data: { title:1,
            Id:job_Id,
            click_action: "1",
        }       
        };      
        fcm.send(message, function(err, response) {
            if (err) {
                console.log("Something has gone wrong!"+err);
                console.log("Respponse:! "+response);
            } else {
                // showToast("Successfully sent with response");
                console.log("Successfully sent with response: ", response);
            }
            // console.log(response)
        });
        }

        function sanitizeString(str) {
          // Remove newlines, tabs, and more than 4 consecutive spaces
          return str.replace(/[\n\t]/g, '').replace(/ {5,}/g, '    ');
        }




        for (var i = 0; i < t2.length; i++) {
          // Sanitizing each data field
          const phone = sanitizeString(t2[i].Phone.toString()); // Ensure it's a string
          const student = sanitizeString(t2[i].Student);
          const amount = sanitizeString(t2[i].Amount.toString()); // Convert to string if it's a number
          const dueDate = sanitizeString(t2[i].DueDate.toString()); // Convert to string if needed
          const userMobile = sanitizeString(t2[i].UserMobile.toString()); // Ensure it's a string
      
          const data = {
              "to": phone,
              "type": "template",
              "templateName": "api_trackbox_due_fee_reminder_jan2023",
              "language": "en",
              "header": {
                  "parameters": [
                      {
                          "type": "image",
                          "image": {
                              "link": "https://oneteam1267.trackbox.in/qrcode.png"
                          }
                      }
                  ]
              },
              "body": {
                  "parameters": [
                      {
                          "type": "text",
                          "text": student // Use sanitized student data
                      },
                      {
                          "type": "text",
                          "text": amount // Use sanitized amount data
                      },
                      {
                          "type": "text",
                          "text": dueDate // Use sanitized due date data
                      },
                      {
                          "type": "text",
                          "text": userMobile // Use sanitized user mobile data
                      }
                  ]
              },
              "button": null
          };
      
          console.log(data);
          console.log('Phone:', phone);
          console.log('Student:', student);
          console.log('Amount:', amount);
          console.log('DueDate:', dueDate);
          console.log('UserMobile:', userMobile);
      
          try {
              const response = axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, {
                  headers: {
                      'Content-Type': 'application/json',
                      'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
                  }
              });
              console.log('Response:', response.data); // Check the response
          } catch (error) {
              console.error("Error sending message:", error); // Log the error
          }
      }

      
        // for(var i = 0; i < t2.length; i++)
        // {
        //    data = {
        //     "to": ""+t2[i].Phone+"",
        //     "type": "template",
        //     "templateName": "api_trackbox_due_fee_reminder_jan2023 rweqr",
        //     "language": "en",
        //     "header": {
        //       "parameters": [
        //       {
        //       "type": "image",
        //       "image": {
        //       "link": "https://oneteam1267.trackbox.in/qeeeercode.png" }
        //       }
        //       ]
        //       },
        //     "body":{
        //       "parameters": [
        //         {
        //           "type": "text",
        //           "text": t2[i].Student
        //         },
        //         {
        //           "type": "text",
        //           "text": t2[i].Amount
        //         },
        //         {
        //           "type": "text",
        //           "text": t2[i].DueDate
        //         },
        //         {
        //           "type": "text",
        //           "text": t2[i].UserMobile
        //         }
        //       ]
        //     },
        //     "button": null
        //   };
        //   // console.log(data)
        //      response =  axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
        //       'Content-Type': 'application/json',
        //       'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'              
        //     } });
        //     // console.log(response.data) 
        // }
        // return response.data;

        // Sanitize function to remove unwanted characters


        // for(var i = 0; i < t3.length; i++)
        // {
        //    data = {
        //     "to": ""+t3[i].Phone+"",
        //     "type": "template",
        //     "templateName": "api_trackbox_over_due_fee_reminder_jan2023",
        //     "language": "en",
        //     "header": {
        //       "parameters": [
        //       {
        //       "type": "image",
        //       "image": {
        //       "link": "http://oneteam1267.trackbox.in/qrcode.png" }
        //       }
        //       ]
        //       },
        //     "body":{
        //       "parameters": [
        //         {
        //           "type": "text",
        //           "text":t3[i].Student
                 
        //         },
        //         {
        //           "type": "text",
        //           "text":t3[i].Amount
        //         },                
        //         {
        //           "type": "text",
        //           "text":t3[i].UserMobile
        //         }
        //       ]
        //     },
        //     "button": null
        //   };
        //   console.log(data)
        //   console.log('t3[i].Student: ',t3[i].Student);
        //   console.log('t3[i].Amount: ',t3[i].Amount);
        //   console.log('t3[i].UserMobile: ',t3[i].UserMobile);
        //      response =  axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
        //       'Content-Type': 'application/json',
        //       'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
        //     } });
        //     console.log(response)
        // }


        for (var i = 0; i < t3.length; i++) {
          // Sanitizing each data field
          const student = sanitizeString(t3[i].Student);
          const amount = sanitizeString(t3[i].Amount.toString());  // Convert to string if it's a number
          const userMobile = sanitizeString(t3[i].UserMobile.toString());  // Convert to string if it's a number
          
          const data = {
              "to": "" + t3[i].Phone + "",
              "type": "template",
              "templateName": "api_trackbox_over_due_fee_reminder_jan2023",
              "language": "en",
              "header": {
                  "parameters": [
                      {
                          "type": "image",
                          "image": {
                              "link": "http://oneteam1267.trackbox.in/qrcode.png"
                          }
                      }
                  ]
              },
              "body": {
                  "parameters": [
                      {
                          "type": "text",
                          "text": student  // Use sanitized student data
                      },
                      {
                          "type": "text",
                          "text": amount  // Use sanitized amount data
                      },
                      {
                          "type": "text",
                          "text": userMobile  // Use sanitized user mobile data
                      }
                  ]
              },
              "button": null
          };
          
          console.log(data);
          console.log('t3[i].Student: ', student);
          console.log('t3[i].Amount: ', amount);
          console.log('t3[i].UserMobile: ', userMobile);
      
          try {
              const response =  axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, {
                  headers: {
                      'Content-Type': 'application/json',
                      'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
                  }
              });
              console.log(response.data);  // Check the response
          } catch (error) {
              console.error("Error sending message: ", error);  // Log the error
          }
      }



        // return response.data;
      }   
    }
  );
}
catch(e){console.log(e)}
} , null, true, 'America/Los_Angeles'); 
job1.start();







//  feedback start




var feedback_whatsapp_data = function (callback) {
  return db.query("CALL feedback_whatsapp_data()", [], callback);
};

function sanitizeString(str) {
  // Remove newlines, tabs, and more than 4 consecutive spaces
  return str.replace(/[\n\t]/g, '').replace(/ {5,}/g, '    ');
}

// Schedule the cron job for every Saturday at 7:00 PM
// var fdbck = cron.schedule('00 19 00 * 6', async function () {
  var fdbck = cron.schedule('00 00 00 * * *',function()  {
  // var fdbck = cron.schedule('20 14 * * 3', async function () {
  try {
    feedback_whatsapp_data(async function (err, rows) {
      if (err) {
        console.error('Database error:', err);
      } else {
        const dataRows = rows[0]; // Stored procedure result
        console.log('Retrieved rows:', dataRows);

        for (let i = 0; i < dataRows.length; i++) {
          const d1 = dataRows[i];

          const Whatsapp = sanitizeString(d1.Whatsapp.toString()); // Ensure it's a string
          const Student_Name = sanitizeString(d1.Student_Name);
          const Faculty_Name = sanitizeString(d1.Faculty_Name.toString()); // Convert to string if it's a number
          

          const data = {
            to: `91${Whatsapp}`, // Ensure this is a valid phone number
            type: "template",
            templateName: "api_learner_feedback_arjun_jan2025",
            language: "en",
            header: null,
            body: {
              parameters: [
                {
                  type: "text",
                  text: Student_Name,
                },
                {
                  type: "text",
                  text: Faculty_Name,
                },
              ],
            },
            button: null,
          };

          try {
            const response = await axios.post(
              "https://api.telinfy.net/gaca/whatsapp/templates/message",
              data,
              {
                headers: {
                  'Content-Type': 'application/json',
                  'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa',
                },
              }
            );
            console.log('WhatsApp API response:', response.data);
          } catch (apiError) {
            console.error('Error sending WhatsApp message:', apiError.response?.data || apiError.message);
          }
        }
      }
    });
  } catch (e) {
    console.error('Error in cron job:', e.message);
  }
}, null, true, 'America/Los_Angeles');

fdbck.start();




// feedback end


























io.on('connection', (socket) => {
  socket.on('new-message', (message) => {
    //sio.emit(message);
    io.emit('new-message', message);
  });
});
server.listen(port, () => {
  console.log(`started on port: ${port}`);
});

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});
module.exports = app;
