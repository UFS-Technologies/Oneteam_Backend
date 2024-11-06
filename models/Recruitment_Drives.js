var db=require('../dbconnection');
var fs = require('fs');
const storedProcedure = require('../helpers/stored-procedure');
const axios = require('axios');
var FCM = require('fcm-node');
const { Console } = require('console');
    var serverKey = 'AAAAP1i3MJ0:APA91bHASQ7S7EkOPtLtVG7y3VxVsXWAi2LXsSFXwZWeTXIT5iG9usMyXXkckY_frLJ2JwOy4-aYQs7_BKaMjopHfdqQp94jvICyn1j-9kd5hP_SwM-3svy7Fq6xMf6Ml_O9YhIf7L1B';
    var fcm = new FCM(serverKey);
var Recruitment_Drives=
{ 
    Search_Recruitment_Drives: async function ( Is_Date_ ,FromDate_ ,ToDate_ ,Branch_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_) {
        var Recruitment_Drives = [];
         try {
           
    
                if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
                Pointer_Start_=0;
    
                if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
                Pointer_Stop_=0; 
           
             Recruitment_Drives = await (new storedProcedure('Search_Recruitment_Drives', [Is_Date_ ,FromDate_ ,ToDate_ ,Branch_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_])).result();
         }
         catch (e) 
         {
         }
         return { returnvalue: {Recruitment_Drives}
         };
       },

Delete_Recruitment_Drives:function(Recruitment_Drives_Id_,callback)
{ 
    return db.query("CALL Delete_Recruitment_Drives(@Recruitment_Drives_Id_ :=?)",[Recruitment_Drives_Id_],callback);
} ,




Save_Recruitment_Drives: async function (Recruitment_Drives_) {
    // console.log(Recruitment_Drives_)
    return new Promise(async (rs, rej) => {
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        console.log(Recruitment_Drives_)
        try {
            const result1 = await new storedProcedure(
                "Save_Recruitment_Drives",
                [
                    Recruitment_Drives_.Recruitment_Drives_Id,
                    Recruitment_Drives_.Event_Name,
                    Recruitment_Drives_.Date,
                    Recruitment_Drives_.Reporting_Time,
                    Recruitment_Drives_.Venue,
                    Recruitment_Drives_.Organized_Branch_Id,
                    Recruitment_Drives_.Organized_Branch_Name,
                    Recruitment_Drives_.Eligibility_Criteria,
                    Recruitment_Drives_.Additional_Information,
                    Recruitment_Drives_.Number_of_Registrations,
                    Recruitment_Drives_.Unique_Link,
                    Recruitment_Drives_.User_Id,
                    Recruitment_Drives_.Event_Status_Id,
                    Recruitment_Drives_.Event_Status_Name,
                ],
                connection
            ).result();

 console.log(result1)
// var tempId=''
// var job_Id=''
// for(var i=0;i<result1.length;i++)
// {
//     try{
//     if(result1[i].Device_Id !=null )
//     {

// tempId = (result1[i].Device_Id) ;
//  console.log(message)

//     job_Id=result1[i].Recruitment_Drives_Id_
// var message = {
// registration_ids:[tempId ],

// notification: {
//         title: 'New Job Alert - One Team Solutions',
//         body: "Dear " + result1[i].Student_Name + ",\n"+
//         "A new job has been posted on our Placement Mobile App. Apply Now.\n" +
//         "Job Title: " + Recruitment_Drives_.Job_Title + "\n" +
//         "Last Date: " + result1[i].Last_Date + "\n" +
//         "The job description and other details are on our Placement App.\n" +
//         "Apply Now.\n" +
//         "Regards,\n" +
//         "Placement Team\n" +
//         "6282202033\n" +
//         "One Team Solutions."

       
//     },
    
//     data: { title:1,
//     Id:job_Id,
//     click_action: "1",
// }

// };

// fcm.send(message, function(err, response) {
//     if (err) {
//         console.log("Something has gone wrong!"+err);
//         console.log("Respponse:! "+response);
//     } else {
//         console.log("Successfully sent with response: ", response);
//     }


// });




// for(var i=0;i<result1.length;i++)
// {
// if(result1[i].Whatsapp!=null  && result1[i].Whatsapp != ''){
// const data = {
//    template_name: "apinew_arjun_jobalert6thfeb2024",
//    broadcast_name: "apinew_arjun_jobalert6thfeb2024",
//    parameters: [
//      {
//        name: "1",
//        value: result1[i].Student_Name
//      },
//      {
//        name: "2",
//        value: Recruitment_Drives_.Job_Title
//      },
//      {
//        name: "3",
//        value: result1[i].Last_Date
//      }
//    ]
//  };
 
//  axios.post('https://live-server-115767.wati.io/api/v1/sendTemplateMessage?whatsappNumber=%2B91'+ result1[i].Whatsapp, data, {
//    headers: {
//      'accept': '*/*',
//      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZjI0OTYzOC00MzhkLTRlMmMtYWQ2Yi0xOGY2NWIwYTk0MTYiLCJ1bmlxdWVfbmFtZSI6ImFyanVuQG9uZXRlYW1zb2x1dGlvbnMuY28uaW4iLCJuYW1laWQiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiZW1haWwiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiYXV0aF90aW1lIjoiMDEvMzEvMjAyNCAwNzoxNzo0MyIsImRiX25hbWUiOiIxMTU3NjciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBRE1JTklTVFJBVE9SIiwiZXhwIjoyNTM0MDIzMDA4MDAsImlzcyI6IkNsYXJlX0FJIiwiYXVkIjoiQ2xhcmVfQUkifQ.nqihj10ep-rq2ODhP9tuNbdyG8r8IpYrlM-0Q_36LeM',
//      'Content-Type': 'application/json-patch+json'
//    }
//  })
//    .then(response => {
//     //  console.log(response.data);
//    })
//    .catch(error => {
//      console.error(error);
//    });
// }

// }

  



//     }
//     }catch(ed)
//     {
//         console.log(ed)
//     }
// }
            await connection.commit();
            connection.release();
            rs(result1);
        } catch (err) {

             console.log(err)
            await connection.rollback();
            rej(err);
            var result2 = [{ Student_Id_: 0 }];
            rs(result2);
           
        } finally {
            connection.release();
        }
    });
},





};
module.exports=Recruitment_Drives;

