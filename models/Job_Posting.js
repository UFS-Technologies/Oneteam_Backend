var db=require('../dbconnection');
var fs = require('fs');
const storedProcedure = require('../helpers/stored-procedure');
const axios = require('axios');
var FCM = require('fcm-node');
const { Console } = require('console');
    var serverKey = 'AAAAP1i3MJ0:APA91bHASQ7S7EkOPtLtVG7y3VxVsXWAi2LXsSFXwZWeTXIT5iG9usMyXXkckY_frLJ2JwOy4-aYQs7_BKaMjopHfdqQp94jvICyn1j-9kd5hP_SwM-3svy7Fq6xMf6Ml_O9YhIf7L1B';
    var fcm = new FCM(serverKey);
var Job_Posting=
{ 
// Save_Job_Posting: function (Job_Posting_Data, callback)
// {
//     console.log(Job_Posting_Data,'1')
//     var Job_Posting_Value_ = 0;
//     let Job_Posting_ = Job_Posting_Data.Job_Posting;
//     if (Job_Posting_ != undefined && Job_Posting_ != '' && Job_Posting_ != null)
//     Job_Posting_Value_ = 1
//     var FollowUp_Value_ = 0;
//     let FollowUp_ = Job_Posting_Data.Followup;
//     if (FollowUp_ != undefined && FollowUp_ != '' && FollowUp_ != null)
//     FollowUp_Value_ = 1;
//     return db.query("CALL Save_Job_Posting(" + "@Job_Posting_:=?," + "@FollowUp_ :=?," + "@Job_Posting_Value_ :=?," +"@FollowUp_Value_ :=? )"
//     , [Job_Posting_, FollowUp_, Job_Posting_Value_, FollowUp_Value_ ],callback);
// },
// Save_Job_Posting:function(Job_Posting_,callback)
//  { 
//      console.log(Job_Posting_)
//     return db.query("CALL Save_Job_Posting("+"@Job_Posting_Id_ :=?,"+"@Job_Code_ :=?,"+"@Job_Title_ :=?,"+
//     "@Descritpion_ :=?,"+"@Skills_ :=?,"+"@No_Of_Vaccancy_ :=?,"+"@Experience_ :=?,"+"@Experience_Name_ :=?,"+
//     "@Job_Location_ :=?,"+ "@Qualification_ :=?,"+"@Qualification_Name_ :=?,"+"@Functional_Area_ :=?,"+
//     "@Functional_Area_Name_ :=?,"+ "@Specialization_ :=?,"+"@Specialization_Name_ :=?,"+"@Salary_ :=?,"+
//     "@Last_Date_ :=?,"+ "@Company_Id_ :=?,"+ "@Company_Name_ :=?,"+"@Address_ :=?,"+"@Contact_Name_ :=?,"+"@Contact_No_ :=?,"+
//     "@Email_ :=?,"+ "@Address1_ :=?,"+"@Address2_ :=?,"+"@Address3_ :=?,"+"@Address4_ :=?,"+"@Pincode_ :=?,"+
//     "@Status_ :=?,"+"@Logo_ :=?,"+"@User_Id_ :=?,"+"@Course_Id_ :=?,"+"@Course_Name_ :=?,"+"@Gender_Id_ :=?,"+"@Gender_Name_ :=?"+")"
//  ,[Job_Posting_.Job_Posting_Id,Job_Posting_.Job_Code,Job_Posting_.Job_Title,Job_Posting_.Descritpion,
//     Job_Posting_.Skills,Job_Posting_.No_Of_Vaccancy,Job_Posting_.Experience,Job_Posting_.Experience_Name,
//     Job_Posting_.Job_Location,Job_Posting_.Qualification,Job_Posting_.Qualification_Name,Job_Posting_.Functional_Area,
//     Job_Posting_.Functional_Area_Name,Job_Posting_.Specialization,Job_Posting_.Specialization_Name,Job_Posting_.Salary,
//     Job_Posting_.Last_Date,Job_Posting_.Company_Id,Job_Posting_.Company_Name,Job_Posting_.Address,Job_Posting_.Contact_Name,
//     Job_Posting_.Contact_No,Job_Posting_.Email,Job_Posting_.Address1,Job_Posting_.Address2,Job_Posting_.Address3,
//     Job_Posting_.Address4,Job_Posting_.Pincode,Job_Posting_.Status,Job_Posting_.Logo,Job_Posting_.User_Id,Job_Posting_.Course_Id,Job_Posting_.Course_Name,
//     Job_Posting_.Gender_Id,Job_Posting_.Gender_Name
// ],callback);
//  } ,
Delete_Job_Posting:function(Job_Posting_Id_,callback)
{ 
    return db.query("CALL Delete_Job_Posting(@Job_Posting_Id_ :=?)",[Job_Posting_Id_],callback);
} ,
Get_Job_Posting:function(Job_Posting_Id_,callback)
{ 
    return db.query("CALL Get_Job_Posting(@Job_Posting_Id_ :=?)",[Job_Posting_Id_],callback);
} ,
Search_Job_Posting: async function ( Job_Code_ ,Job_id_ ,Job_Location_ ,Company_id_,Pointer_Start_,Pointer_Stop_,Page_Length_) {
    var Job_Posting = [];
     try {
        if (Job_Code_ === undefined || Job_Code_ === "undefined")
            Job_Code_ = '';

            if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
            Pointer_Start_=0;

            if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
            Pointer_Stop_=0; 
        // if (Job_Title_ === undefined || Job_Title_ === "undefined")
        //     Job_Title_ = '';
         if (Job_Location_ === undefined || Job_Location_ === "undefined")
             Job_Location_ = '';
         Job_Posting = await (new storedProcedure('Search_Job_Posting', [Job_Code_ ,Job_id_ ,Job_Location_ ,Company_id_,Pointer_Start_,Pointer_Stop_,Page_Length_])).result();
     }
     catch (e) 
     {
     }
     return { returnvalue: {Job_Posting}
     };
   },



   Search_Jobposting_Summary: function (Is_Date_,Fromdate_,Todate_,Job_id_,Company_id_,Course_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback
) {

   
            if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
            Pointer_Start_=0;

            if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
            Pointer_Stop_=0; 


            return db.query(
                "CALL Search_Jobposting_Summary(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Job_id_ :=?,@Company_id_ :=?,@Course_Id_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?)",
                [Is_Date_, Fromdate_,Todate_, Job_id_,Company_id_,Course_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],
                callback
            );
},

Search_Interview_Scheduled_Summary: function ( Is_Date_,Fromdate_,Todate_,Trainer_Id_,Course_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback
    ) {
    
       
                if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
                Pointer_Start_=0;
    
                if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
                Pointer_Stop_=0; 
    
    
        return db.query(
            "CALL Search_Interview_Scheduled_Summary(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Trainer_Id_ :=?,@Course_Id_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?)",
            [Is_Date_, Fromdate_,Todate_,Trainer_Id_,Course_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],
            callback
        );
    },




    
    Search_Placement_Report_New: function ( Is_Date_,Fromdate_,Todate_,Company_id_,Course_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback
    ) {
    
       
                if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
                Pointer_Start_=0;
    
                if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
                Pointer_Stop_=0; 
    
    
        return db.query(
            "CALL Search_Placement_Report_New(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Company_id_ :=?,@Course_Id_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?)",
            [Is_Date_, Fromdate_,Todate_,Company_id_,Course_Id_,Pointer_Start_,Pointer_Stop_,Page_Length_],
            callback
        );
    },


    Search_Complaint_Details: function ( Is_Date_,Fromdate_,Todate_,Status_,Login_User_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback
        ) {
        
           
                    if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
                    Pointer_Start_=0;
        
                    if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
                    Pointer_Stop_=0; 
        
        
            return db.query(
                "CALL Search_Complaint_Details(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Status_ :=?,@Login_User_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?)",
                [Is_Date_, Fromdate_,Todate_,Status_,Login_User_,Pointer_Start_,Pointer_Stop_,Page_Length_],
                callback
            );
        },
    
    
   



    Search_Interview_Scheduled_Details: function ( Job_id_,Company_Id_,Interview_Date_,Interview_Time_,course_id_,callback
        ) {
        
           
                    // if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
                    // Pointer_Start_=0;
        
                    // if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
                    // Pointer_Stop_=0; 
        
        
            return db.query(
                "CALL Search_Interview_Scheduled_Details(@Job_id_ :=?,@Company_Id_ :=?,@Interview_Date_ :=?,@Interview_Time_ :=?,@course_id_ :=?)",
                [Job_id_, Company_Id_,Interview_Date_,Interview_Time_,course_id_,],
                callback
            );
        },


Search_Appliedcount_Details: function (Job_Posting_Id_,Job_Title_, callback) {
    return db.query(
        "CALL Search_Appliedcount_Details(@Job_Posting_Id_ :=?,@Job_Title_ :=?)",
        [Job_Posting_Id_,Job_Title_],
        callback
    );
},


Search_Rejectedcount_Details: function (Job_Posting_Id_,Job_Title_, callback) {
    return db.query(
        "CALL Search_Rejectedcount_Details(@Job_Posting_Id_ :=?,@Job_Title_ :=?)",
        [Job_Posting_Id_,Job_Title_],
        callback
    );
},


Get_Resumefilefor_Report: function (Student_Id_, callback) {
    return db.query(
        "CALL Get_Resumefilefor_Report(@Student_Id_ :=?)",
        [Student_Id_],
        callback
    );
},

Search_Student_Job_Report: function ( Is_Date_,Fromdate_,Todate_,Student_Status_,Student_Name_,Offeredcount_,Blacklist_Status_,Activate_Status_,Fees_Status_,Search_Resume_Status_,callback
    ) {
        
        return db.query(
            "CALL Search_Student_Job_Report(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Student_Status_ :=?,@Student_Name_ :=?,@Offeredcount_ :=?,@Blacklist_Status_ :=?,@Activate_Status_ :=?,@Fees_Status_ :=?,@Search_Resume_Status_ :=?)",
            [Is_Date_, Fromdate_,Todate_, Student_Status_,Student_Name_,Offeredcount_, Blacklist_Status_,Activate_Status_,Fees_Status_,Search_Resume_Status_],
            callback
        );
    },


    // Save_Schedule_Interview: function ( Interview_Schedule_Date_ ,temp_Applied_jobs_ ,Interview_Schedule_Description_ ,Login_User_,temp_Student_d,callback
    //     ) {
    //         // console.log(Interview_Schedule_Date_ ,temp_Applied_jobs_ ,Interview_Schedule_Description_ ,Login_User_,temp_Student_d)
    //         return db.query(
    //             "CALL Save_Schedule_Interview(@Interview_Schedule_Date_ :=?,@temp_Applied_jobs_ :=?,@Interview_Schedule_Description_ :=?,@Login_User_ :=?,@temp_Student_d :=?)",
    //             [Interview_Schedule_Date_ ,temp_Applied_jobs_ ,Interview_Schedule_Description_ ,Login_User_,temp_Student_d],
    //             callback
    //         );
    //     },
    //     Save_Mark_Placement: function ( Placement_Date_ ,temp_Applied_jobs_ ,Placement_Description_ ,Login_User_,temp_Student_d,callback
    //         ) {
    //             // console.log(Placement_Date_ ,temp_Applied_jobs_ ,Placement_Description_ ,Login_User_,temp_Student_d)
    //             return db.query(
    //                 "CALL Save_Mark_Placement(@Placement_Date_ :=?,@temp_Applied_jobs_ :=?,@Placement_Description_ :=?,@Login_User_ :=?,@temp_Student_d :=?)",
    //                 [Placement_Date_ ,temp_Applied_jobs_ ,Placement_Description_ ,Login_User_,temp_Student_d],
    //                 callback
    //             );
    //         },
    

            Search_Jobposting_Detailed_Report: function ( Is_Date_,Fromdate_,Todate_,Company_,Job_,Student_Status_,Blacklist_Status_,Activate_Status_,Fees_Status_,callback
                ) {
                    
                    return db.query(
                        "CALL Search_Jobposting_Detailed_Report(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Company_ :=?,@Job_ :=?,@Student_Status_ :=?,@Blacklist_Status_ :=?,@Activate_Status_ :=?,@Fees_Status_ :=?)",
                        [Is_Date_,Fromdate_,Todate_,Company_,Job_,Student_Status_,Blacklist_Status_,Activate_Status_,Fees_Status_],
                        callback
                    );
                },




                Search_Job_Rejections: function ( Is_Date_,Fromdate_,Todate_,callback
                    ) {
                        
                        return db.query(
                            "CALL Search_Job_Rejections(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?)",
                            [Is_Date_,Fromdate_,Todate_],
                            callback
                        );
                    },
    
                    Applied_Reject_Detaild_Report: function (Student_Id_,callback
                        ) {
                            
                            return db.query(
                                "CALL Applied_Reject_Detaild_Report(@Student_Id_ :=?)",
                                [Student_Id_],
                                callback
                            );
                        },
        
    
                        History_Of_Interview_Schedule: function (Student_Id_,callback
                            ) {
                                
                                return db.query(
                                    "CALL History_Of_Interview_Schedule(@Student_Id_ :=?)",
                                    [Student_Id_],
                                    callback
                                );
                            },
            



// Save_Job_Posting: async function (Job_Posting_) {
//     // console.log(Job_Posting_)
//     return new Promise(async (rs, rej) => {
//         const pool = db.promise();
//         let result1;
//         var connection = await pool.getConnection();
//         try {
//             const result1 = await new storedProcedure(
//                 "Save_Job_Posting",
//                 [
//                     Job_Posting_.Job_Posting_Id,
//                     // Job_Posting_.Job_Code,
//                     Job_Posting_.Job_Title,
//                     Job_Posting_.Descritpion,
//                     Job_Posting_.Skills,
//                     Job_Posting_.No_Of_Vaccancy,
//                     Job_Posting_.Experience,
//                     Job_Posting_.Experience_Name,
//                     Job_Posting_.Job_Location,
//                     Job_Posting_.Qualification,
//                     Job_Posting_.Qualification_Name,
//                     Job_Posting_.Functional_Area,
//                     Job_Posting_.Functional_Area_Name,
//                     Job_Posting_.Specialization,
//                     Job_Posting_.Specialization_Name,
//                     Job_Posting_.Salary,
//                     Job_Posting_.Last_Date,
//                     Job_Posting_.Company_Id,
//                     Job_Posting_.Company_Name,
//                     Job_Posting_.Address,
//                     Job_Posting_.Contact_Name,
//                     Job_Posting_.Contact_No,
//                     Job_Posting_.Email,
//                     Job_Posting_.Address1,
//                     Job_Posting_.Address2,
//                     Job_Posting_.Address3,

//                     Job_Posting_.Address4,
//                     Job_Posting_.Pincode,
//                     Job_Posting_.Status,
//                     Job_Posting_.tempFile_Nmae,
//                     Job_Posting_.User_Id,
//                     Job_Posting_.Course_Id,
//                     Job_Posting_.Course_Name,
//                     Job_Posting_.Gender_Id,
//                     Job_Posting_.Gender_Name,
//                     Job_Posting_.Last_Time,

//                 ],
//                 connection
//             ).result();

//  console.log(result1)
// var tempId=''
// var job_Id=''
// for(var i=0;i<result1.length;i++)
// {
//     try{
//     // console.log()
//     if(result1[i].Device_Id !=null )
//     {
// //    tempId =tempId + (result1[i].Device_Id) +',';
// tempId = (result1[i].Device_Id) ;
//  console.log(message)

//     job_Id=result1[i].Job_Posting_Id_
// var message = {
// registration_ids:[tempId ],

// notification: {
//         title: 'New Job Alert - One Team Solutions',
//         // body:  Job_Posting_.Job_Title ,
        
//         body: "Dear " + result1[i].Student_Name + ",\n"+
//         "A new job has been posted on our Placement Mobile App. Apply Now.\n" +
//         "Job Title: " + Job_Posting_.Job_Title + "\n" +
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
//         // showToast("Successfully sent with response");
//         console.log("Successfully sent with response: ", response);
//     }


// });
//     }
//     }catch(ed)
//     {
//         console.log(ed)
//     }
// }
//             await connection.commit();
//             connection.release();
//             // console.log(result1)
//             rs(result1);
//         } catch (err) {

//              console.log(err)
//             await connection.rollback();
//             rej(err);
//             var result2 = [{ Student_Id_: 0 }];
//         //    console.log(result1, result2)
//             rs(result2);
//             // rs([result1, result2]);
//         } finally {
//             connection.release();
//         }
//     });
// },





















// Save_Job_Posting: async function (Job_Posting_) {
//     // console.log(Job_Posting_)
//     return new Promise(async (rs, rej) => {
//         const pool = db.promise();
//         let result1;
//         var connection = await pool.getConnection();
//         try {
//             const result1 = await new storedProcedure(
//                 "Save_Job_Posting",
//                 [
//                     Job_Posting_.Job_Posting_Id,
//                     Job_Posting_.Job_Title,
//                     Job_Posting_.Descritpion,
//                     Job_Posting_.Skills,
//                     Job_Posting_.No_Of_Vaccancy,
//                     Job_Posting_.Experience,
//                     Job_Posting_.Experience_Name,
//                     Job_Posting_.Job_Location,
//                     Job_Posting_.Qualification,
//                     Job_Posting_.Qualification_Name,
//                     Job_Posting_.Functional_Area,
//                     Job_Posting_.Functional_Area_Name,
//                     Job_Posting_.Specialization,
//                     Job_Posting_.Specialization_Name,
//                     Job_Posting_.Salary,
//                     Job_Posting_.Last_Date,
//                     Job_Posting_.Company_Id,
//                     Job_Posting_.Company_Name,
//                     Job_Posting_.Address,
//                     Job_Posting_.Contact_Name,
//                     Job_Posting_.Contact_No,
//                     Job_Posting_.Email,
//                     Job_Posting_.Address1,
//                     Job_Posting_.Address2,
//                     Job_Posting_.Address3,

//                     Job_Posting_.Address4,
//                     Job_Posting_.Pincode,
//                     Job_Posting_.Status,
//                     Job_Posting_.tempFile_Nmae,
//                     Job_Posting_.User_Id,
//                     Job_Posting_.Course_Id,
//                     Job_Posting_.Course_Name,
//                     Job_Posting_.Gender_Id,
//                     Job_Posting_.Gender_Name,
//                     Job_Posting_.Last_Time,

//                 ],
//                 connection
//             ).result();

//  console.log(result1)
// var tempId=''
// var job_Id=''
// for(var i=0;i<result1.length;i++)
// {
//     try{
//     if(result1[i].Device_Id !=null )
//     {

// tempId = (result1[i].Device_Id) ;
//  console.log(message)

//     job_Id=result1[i].Job_Posting_Id_
// var message = {
// registration_ids:[tempId ],

// notification: {
//         title: 'New Job Alert - One Team Solutions',
//         body: "Dear " + result1[i].Student_Name + ",\n"+
//         "A new job has been posted on our Placement Mobile App. Apply Now.\n" +
//         "Job Title: " + Job_Posting_.Job_Title + "\n" +
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






//         // {
//         //    data = {
//         //     "to": ""+result1[i].Phone+"",
//         //     "type": "template",
//         //     "templateName": "new_job_alert_12_june",
//         //     "language": "en",
//         //     "header": {
//         //       "parameters": [
//         //       {
//         //         "type": "text",
//         //         "text": "New Job Alert - One Team Solutions"
//         //       }
//         //       ]
//         //       },

//         //     "body":{
//         //       "parameters": [
//         //         {
//         //           "type": "text",
//         //           "text": result1[i].Student_Name
//         //         },
//         //         {
//         //           "type": "text",
//         //           "text": result1[i].Job_Title
//         //         },
                
//         //         {
//         //           "type": "text",
//         //           "text": result1[i].Last_Date
//         //         },

//         //         {
//         //             "type": "text",
//         //             "text": result1[i].Last_Time
//         //           }

//         //       ]
//         //     },
//         //     "button": null
//         //   };
//         //   console.log(data)
//         //   const response = await axios.post("https://api.telinfy.net/gaca/whatsapp/templates/message", data, { headers: {
//         //     'Content-Type': 'application/json',
//         //     'Api-Key': '0ea03cd8-169f-4f50-8254-94f50dbcfdaa'
//         // } });
//         //      console.log(response)
//         //     return response.data;
//         // }
        

  
















//     }
//     }catch(ed)
//     {
//         console.log(ed)
//     }
// }
//             await connection.commit();
//             connection.release();
//             rs(result1);
//         } catch (err) {

//              console.log(err)
//             await connection.rollback();
//             rej(err);
//             var result2 = [{ Student_Id_: 0 }];
//             rs(result2);
           
//         } finally {
//             connection.release();
//         }
//     });
// },







Save_Job_Posting: async function (Job_Posting_) {
    // console.log(Job_Posting_)
    return new Promise(async (rs, rej) => {
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        console.log(Job_Posting_)
        try {
            const result1 = await new storedProcedure(
                "Save_Job_Posting",
                [
                    Job_Posting_.Job_Posting_Id,
                    Job_Posting_.Job_Title,
                    Job_Posting_.Descritpion,
                    Job_Posting_.Skills,
                    Job_Posting_.No_Of_Vaccancy,
                    Job_Posting_.Experience,
                    Job_Posting_.Experience_Name,
                    Job_Posting_.Job_Location,
                    Job_Posting_.Qualification,
                    Job_Posting_.Qualification_Name,
                    Job_Posting_.Functional_Area,
                    Job_Posting_.Functional_Area_Name,
                    Job_Posting_.Specialization,
                    Job_Posting_.Specialization_Name,
                    Job_Posting_.Salary,
                    Job_Posting_.Last_Date,
                    Job_Posting_.Company_Id,
                    Job_Posting_.Company_Name,
                    Job_Posting_.Address,
                    Job_Posting_.Contact_Name,
                    Job_Posting_.Contact_No,
                    Job_Posting_.Email,
                    Job_Posting_.Address1,
                    Job_Posting_.Address2,
                    Job_Posting_.Address3,

                    Job_Posting_.Address4,
                    Job_Posting_.Pincode,
                    Job_Posting_.Status,
                    Job_Posting_.tempFile_Nmae,
                    Job_Posting_.User_Id,
                    Job_Posting_.Course_Id,
                    Job_Posting_.Course_Name,
                    Job_Posting_.Gender_Id,
                    Job_Posting_.Gender_Name,
                    Job_Posting_.Last_Time,
                    Job_Posting_.Job_Opening_Id,


                ],
                connection
            ).result();

 console.log(result1)
var tempId=''
var job_Id=''
for(var i=0;i<result1.length;i++)
{
    try{
    if(result1[i].Device_Id !=null )
    {

tempId = (result1[i].Device_Id) ;
 console.log(message)

    job_Id=result1[i].Job_Posting_Id_
var message = {
registration_ids:[tempId ],

notification: {
        title: 'New Job Alert - One Team Solutions',
        body: "Dear " + result1[i].Student_Name + ",\n"+
        "A new job has been posted on our Placement Mobile App. Apply Now.\n" +
        "Job Title: " + Job_Posting_.Job_Title + "\n" +
        "Last Date: " + result1[i].Last_Date + "\n" +
        "The job description and other details are on our Placement App.\n" +
        "Apply Now.\n" +
        "Regards,\n" +
        "Placement Team\n" +
        "6282202033\n" +
        "One Team Solutions."

       
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
        console.log("Successfully sent with response: ", response);
    }


});




for(var i=0;i<result1.length;i++)
{
if(result1[i].Whatsapp!=null  && result1[i].Whatsapp != ''){
const data = {
   template_name: "apinew_arjun_jobalert6thfeb2024",
   broadcast_name: "apinew_arjun_jobalert6thfeb2024",
   parameters: [
     {
       name: "1",
       value: result1[i].Student_Name
     },
     {
       name: "2",
       value: Job_Posting_.Job_Title
     },
     {
       name: "3",
       value: result1[i].Last_Date
     }
   ]
 };
 
 axios.post('https://live-server-115767.wati.io/api/v1/sendTemplateMessage?whatsappNumber=%2B91'+ result1[i].Whatsapp, data, {
   headers: {
     'accept': '*/*',
     'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZjI0OTYzOC00MzhkLTRlMmMtYWQ2Yi0xOGY2NWIwYTk0MTYiLCJ1bmlxdWVfbmFtZSI6ImFyanVuQG9uZXRlYW1zb2x1dGlvbnMuY28uaW4iLCJuYW1laWQiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiZW1haWwiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiYXV0aF90aW1lIjoiMDEvMzEvMjAyNCAwNzoxNzo0MyIsImRiX25hbWUiOiIxMTU3NjciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBRE1JTklTVFJBVE9SIiwiZXhwIjoyNTM0MDIzMDA4MDAsImlzcyI6IkNsYXJlX0FJIiwiYXVkIjoiQ2xhcmVfQUkifQ.nqihj10ep-rq2ODhP9tuNbdyG8r8IpYrlM-0Q_36LeM',
     'Content-Type': 'application/json-patch+json'
   }
 })
   .then(response => {
    //  console.log(response.data);
   })
   .catch(error => {
     console.error(error);
   });
}

}

  



    }
    }catch(ed)
    {
        console.log(ed)
    }
}
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




































  

 Save_Schedule_Interview: async function (Interview_Schedule_) {
    return new Promise(async (rs, rej) => {
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        try {
           const result1 = await new storedProcedure(
                "Save_Schedule_Interview",
                [
                    Interview_Schedule_.Interview_Schedule_Date,
                    Interview_Schedule_.Applied_jobs,
                    Interview_Schedule_.Interview_Schedule_Description,
                    Interview_Schedule_.Login_User,
                    Interview_Schedule_.Student_Id,
                    Interview_Schedule_.Job_Id,
                    Interview_Schedule_.Interview_Location,
                    Interview_Schedule_.Interview_Time,
                ],
                connection
            ).result();

 console.log(result1)


 var tempId=''
 var job_Id=''
 for(var i=0;i<result1.length;i++)
 {
     try {
    
     if(result1[i].Device_Id !=null && result1[i].Device_Id != '' )
{

    console.log(message)
 tempId = (result1[i].Device_Id) ;
     job_Id=result1[i].Job_Id
    
 var message = {
 registration_ids:[tempId ],
notification: {
    
        //  title: 'Interview Scheduled',
        //  body:	"at "+result1[i].Company_Name+ " on " +result1[i].Interview_Date+" . Description :"+result1[i].Interview_Description

        title: 'Your Interview has been scheduled.',
        body: "Dear " + result1[i].Student_Name + ",\n"
        +"You are shortlisted for the interview of " + result1[i].Job_Title +" at " +result1[i].Company_Name+ ".\n"
        +"Interview date: "+ result1[i].Interview_Date + "\n"
        +"Last Date: "+result1[i].Last_Date+ "\n"
        +"Interview Details: "+result1[i].Interview_Description+ "\n"
        +"Please confirm your attendance by marking the same on Placement App. \n" 
        +"Wish you all the very best. \n" 
        +"Regards,\n"
        +"Placement Team\n"
        +"6282202033\n"
        +"One Team Solutions." 

    
                
     },
     data: { title:2,
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
 
 
 });
}
} catch (err) {
    console.log(err)
    // await connection.rollback();
    // rej(err);
    // var result2 = [{ Student_Id_: 0 }];
   
    // rs(result2);
} finally {
    // connection.release();
}


 }



 for(var i=0;i<result1.length;i++)
 {

    if(result1[i].Whatsapp!=null && result1[i].Whatsapp != '' )
    {

const data = {
    template_name: "new_api_interview_scheduled_6thfeb_arjun",
    broadcast_name: "new_api_interview_scheduled_6thfeb_arjun",
    parameters: [
      {
        name: "1",
        value: result1[i].Student_Name
      },
      {
        name: "2",
        value: result1[i].Job_Title
      },
      {
        name: "3",
        value: result1[i].Company_Name
      },
      {
        name: "4",
        value: result1[i].Interview_Date
      },
      {
        name: "5",
        value: result1[i].Interview_Time
      }
    ]
  };
  
  axios.post('https://live-server-115767.wati.io/api/v1/sendTemplateMessage?whatsappNumber=%2B91'+ result1[i].Whatsapp, data, {
    headers: {
      'accept': '*/*',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZjI0OTYzOC00MzhkLTRlMmMtYWQ2Yi0xOGY2NWIwYTk0MTYiLCJ1bmlxdWVfbmFtZSI6ImFyanVuQG9uZXRlYW1zb2x1dGlvbnMuY28uaW4iLCJuYW1laWQiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiZW1haWwiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiYXV0aF90aW1lIjoiMDEvMzEvMjAyNCAwNzoxNzo0MyIsImRiX25hbWUiOiIxMTU3NjciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBRE1JTklTVFJBVE9SIiwiZXhwIjoyNTM0MDIzMDA4MDAsImlzcyI6IkNsYXJlX0FJIiwiYXVkIjoiQ2xhcmVfQUkifQ.nqihj10ep-rq2ODhP9tuNbdyG8r8IpYrlM-0Q_36LeM',
      'Content-Type': 'application/json-patch+json'
    }
  })
    .then(response => {
    //   console.log(response.data);
    })
    .catch(error => {
      console.error(error);
    });

 }
 }





             await connection.commit();
             connection.release();
             console.log(result1)
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
























 Save_ReSchedule_Interview: async function (Interview_Schedule_) {
    return new Promise(async (rs, rej) => {
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        try {
           const result1 = await new storedProcedure(
                "Save_ReSchedule_Interview",
                [
                    Interview_Schedule_.Interview_Schedule_Date,
                    Interview_Schedule_.Applied_jobs,
                    Interview_Schedule_.Interview_Schedule_Description,
                    Interview_Schedule_.Login_User,
                    Interview_Schedule_.Student_Id,
                    Interview_Schedule_.Job_Id,
                    Interview_Schedule_.Interview_Location,
                    Interview_Schedule_.Interview_Time,
                ],
                connection
            ).result();

 console.log(result1)


 var tempId=''
 var job_Id=''
 for(var i=0;i<result1.length;i++)
 {
     try {
    
     if(result1[i].Device_Id !=null && result1[i].Device_Id != '' )
{

    console.log(message)
 tempId = (result1[i].Device_Id) ;
     job_Id=result1[i].Job_Id
    
 var message = {
 registration_ids:[tempId ],
notification: {
    
        //  title: 'Interview Scheduled',
        //  body:	"at "+result1[i].Company_Name+ " on " +result1[i].Interview_Date+" . Description :"+result1[i].Interview_Description

        title: 'Your Interview has been Rescheduled.',
        body: "Dear " + result1[i].Student_Name + ",\n"
        +"You are shortlisted for the interview of " + result1[i].Job_Title +" at " +result1[i].Company_Name+ ".\n"
        +"Interview date: "+ result1[i].Interview_Date + "\n"
        +"Last Date: "+result1[i].Last_Date+ "\n"
        +"Interview Details: "+result1[i].Interview_Description+ "\n"
        +"Please confirm your attendance by marking the same on Placement App. \n" 
        +"Wish you all the very best. \n" 
        +"Regards,\n"
        +"Placement Team\n"
        +"6282202033\n"
        +"One Team Solutions." 

    
                
     },
     data: { title:2,
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
 
 
 });
}
} catch (err) {
    console.log(err)
    // await connection.rollback();
    // rej(err);
    // var result2 = [{ Student_Id_: 0 }];
   
    // rs(result2);
} finally {
    // connection.release();
}


 }
             await connection.commit();
             connection.release();
             console.log(result1)
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












// Save_Mark_Placement: async function (Placement_Schedule_) {
//     return new Promise(async (rs, rej) => {
//         const pool = db.promise();
//         let result1;
//         var connection = await pool.getConnection();
//         try {
//             const result1 = await new storedProcedure(
//                 "Save_Mark_Placement",
//                 [
//                     Placement_Schedule_.Placement_Schedule_Date,
//                     Placement_Schedule_.Applied_jobs,
//                     Placement_Schedule_.Placement_Schedule_Description,
//                     Placement_Schedule_.Login_User,
//                     Placement_Schedule_.Student_Id,
//                     Placement_Schedule_.Job_Id,
                   
//                 ],
//                 connection
//             ).result();

//  console.log(result1)


//  var tempId=''
//  var job_Id=''
//  for(var i=0;i<result1.length;i++)
//  {
//      if(result1[i].Device_Id !=null)
//  //    tempId =tempId + (result1[i].Device_Id) +',';
//  tempId = (result1[i].Device_Id) ;
//      job_Id=result1[i].Job_Id
//  var message = {
//  registration_ids:[tempId ],
//  notification: {
//          title: 'Placed',
//          body:	"at "+result1[i].Company_Name+ " on " +result1[i].Placement_Date
//      },
//      data: { title:3,
//      Id:job_Id,
//      click_action: "1",
//  }
//  };
  
//  fcm.send(message, function(err, response) {
//      if (err) {
//          console.log("Something has gone wrong!"+err);
//          console.log("Respponse:! "+response);
//      } else {
//          // showToast("Successfully sent with response");
//          console.log("Successfully sent with response: ", response);
//      }
 
 
//  });
//  }
//              await connection.commit();
//              connection.release();
//              console.log(result1)
//              rs(result1);
//          } catch (err) {
//              await connection.rollback();
//              rej(err);
//              var result2 = [{ Student_Id_: 0 }];
            
//              rs(result2);
//          } finally {
//              connection.release();
//          }
//      });
//  },


Save_Mark_Placement: async function (Placement_Schedule_) {
    return new Promise(async (rs, rej) => {
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        try {
            const result1 = await new storedProcedure(
                "Save_Mark_Placement",
                [
                    Placement_Schedule_.Placement_Schedule_Date,
                    Placement_Schedule_.Applied_jobs,
                    Placement_Schedule_.Placement_Schedule_Description,
                    Placement_Schedule_.Login_User,
                    Placement_Schedule_.Student_Id,
                    Placement_Schedule_.Job_Id,
                   
                ],
                connection
            ).result();

 console.log(result1)


 var tempId=''
 var job_Id=''
 for(var i=0;i<result1.length;i++)
 {
     try {
    
     if(result1[i].Device_Id !=null && result1[i].Device_Id != '' )
{
 tempId = (result1[i].Device_Id) ;
     job_Id=result1[i].Job_Id
     //console.log(message)
 var message = {
 registration_ids:[tempId ],
 notification: {
         title: 'Placed',
         body:	"at "+result1[i].Company_Name+ " on " +result1[i].Placement_Date
     },
     data: { title:3,
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
 
 
 });
}
} catch (err) {
    console.log(err)
    // await connection.rollback();
    // rej(err);
    // var result2 = [{ Student_Id_: 0 }];
   
    // rs(result2);
} finally {
    // connection.release();
}


 }
             await connection.commit();
             connection.release();
             console.log(result1)
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








//  Update_Resume_Status: async function (Resume_Status_Change_) {
//     return new Promise(async (rs, rej) => {
//         const pool = db.promise();
//         let result1;
//         var connection = await pool.getConnection();
//         try {
//             const result1 = await new storedProcedure(
//                 "Update_Resume_Status",
//                 [
//                     Resume_Status_Change_.Resume_Status_Id,
//                     Resume_Status_Change_.Resume_Status_Name,
//                     Resume_Status_Change_.Student_Id,
                  
                   
//                 ],
//                 connection
//             ).result();

//  console.log(result1)


//  var tempId=''
//  var job_Id=''
//  for(var i=0;i<result1.length;i++)
//  {
//      if(result1[i].Change_status_ ==1)

//  tempId = (result1[i].Device_Id) ;
//     //  job_Id=result1[i].Job_Id
//  var message = {
//  registration_ids:[tempId ],
//  notification: {
//          title: 'Resume Status Changed',
//          body: "Your Resume " +result1[i].Resume_Status_Name_  ,
//      },
//      data: { title:4,
//      Id:job_Id,
//      click_action: "1",
//  }
//  };
  
//  fcm.send(message, function(err, response) {
//      if (err) {
//          console.log("Something has gone wrong!"+err);
//          console.log("Respponse:! "+response);
//      } else {
//          // showToast("Successfully sent with response");
//          console.log("Successfully sent with response: ", response);
//      }
 
 
//  });
//  }
//              await connection.commit();
//              connection.release();
//              console.log(result1)
//              rs(result1);
//          } catch (err) {
//              await connection.rollback();
//              rej(err);
//              var result2 = [{ Student_Id_: 0 }];
            
//              rs(result2);
//          } finally {
//              connection.release();
//          }
//      });
//  },





        

 Update_Resume_Status: async function (Resume_Status_Change_) {
    return new Promise(async (rs, rej) => {
        const pool = db.promise();
        let result1;
        var connection = await pool.getConnection();
        try {
            const result1 = await new storedProcedure(
                "Update_Resume_Status",
                [
                    Resume_Status_Change_.Resume_Status_Id,
                    Resume_Status_Change_.Resume_Status_Name,
                    Resume_Status_Change_.Student_Id,
                  
                   
                ],
                connection
            ).result();

 console.log(result1)


 var tempId=''
 var job_Id=''
 for(var i=0;i<result1.length;i++)
 {
     try {
    
     if(result1[i].Device_Id !=null && result1[i].Device_Id != ''&&result1[i].Change_status_ ==1 )
{
 tempId = (result1[i].Device_Id) ;
    //  job_Id=result1[i].Job_Id
if(result1[i].Resume_Status_Id_==3)
 {
    // console.log(message)
    var message = {
        
        registration_ids:[tempId ],
        notification: {
           title: 'Resume Approved on Placement App',
           body: "Dear " + result1[i].Student_Name + ",\n" +
           "Your resume has been approved by the Placement Team.\n" +
           "Start applying for all eligible vacancies.\n" +
           "Regards,\n" +
           "Placement Team\n" +
           "6282202033\n" +
           "One Team Solutions." 

            },
            data: { title:4,
            Id:job_Id,
            click_action: "1",
        }
        };
 }

 if(result1[i].Resume_Status_Id_==2)
 {
    var message = {
        registration_ids:[tempId ],
        notification: {
            title: 'Resume Rejected on Placement App',
            body: "Dear " + result1[i].Student_Name + ",\n" +
            "Your resume has been rejected by the Placement team. Please modify it and upload it again.\n" +
            "Regards,\n" +
            "Placement Team\n" +
            "6282202033\n" +
            "One Team Solutions."

            },
            data: { title:4,
            Id:job_Id,
            click_action: "1",
        }
        };
 }
 
  
 fcm.send(message, function(err, response) {
     if (err) {
         console.log("Something has gone wrong!"+err);
         console.log("Respponse:! "+response);
     } else {
         // showToast("Successfully sent with response");
         console.log("Successfully sent with response: ", response);
     }
 
 
 });
}
} catch (err) {
    console.log(err)
    // await connection.rollback();
    // rej(err);
    // var result2 = [{ Student_Id_: 0 }];
   
    // rs(result2);
} finally {
    // connection.release();
}


 }




 for(var i=0;i<result1.length;i++)
 {
    if(result1[i].Whatsapp!=null){
     try {
    
     if(result1[i].Whatsapp !=null && result1[i].Whatsapp != ''&&result1[i].Change_status_ ==1 )
{
 tempId = (result1[i].Whatsapp) ;
 
if(result1[i].Resume_Status_Id_==3)   // approved
{
    
    const data = {
      template_name: "new_resume_approved_arjun_6thfeb2024",
      broadcast_name: "new_resume_approved_arjun_6thfeb2024",
      parameters: [
        {
          name: "1",
          value: result1[i].Student_Name
        }
      ]
    };
    
    axios.post('https://live-server-115767.wati.io/api/v1/sendTemplateMessage?whatsappNumber=%2B91'+ result1[i].Whatsapp, data, {
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZjI0OTYzOC00MzhkLTRlMmMtYWQ2Yi0xOGY2NWIwYTk0MTYiLCJ1bmlxdWVfbmFtZSI6ImFyanVuQG9uZXRlYW1zb2x1dGlvbnMuY28uaW4iLCJuYW1laWQiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiZW1haWwiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiYXV0aF90aW1lIjoiMDEvMzEvMjAyNCAwNzoxNzo0MyIsImRiX25hbWUiOiIxMTU3NjciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBRE1JTklTVFJBVE9SIiwiZXhwIjoyNTM0MDIzMDA4MDAsImlzcyI6IkNsYXJlX0FJIiwiYXVkIjoiQ2xhcmVfQUkifQ.nqihj10ep-rq2ODhP9tuNbdyG8r8IpYrlM-0Q_36LeM',
        'Content-Type': 'application/json-patch+json'
      }
    })
      .then(response => {
        // console.log(response.data);
      })
      .catch(error => {
        console.error(error);
      });
    

 }

 if(result1[i].Resume_Status_Id_==2)  // rejected
 {
    
    const data = {
      template_name: "new_api_resume_rejected_arjun_6thfeb",
      broadcast_name: "new_api_resume_rejected_arjun_6thfeb",
      parameters: [
        {
          name: "1",
          value: result1[i].Student_Name
        }
      ]
    };
    
    axios.post('https://live-server-115767.wati.io/api/v1/sendTemplateMessage?whatsappNumber=%2B91'+ result1[i].Whatsapp, data, {
      headers: {
        'accept': '*/*',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJkZjI0OTYzOC00MzhkLTRlMmMtYWQ2Yi0xOGY2NWIwYTk0MTYiLCJ1bmlxdWVfbmFtZSI6ImFyanVuQG9uZXRlYW1zb2x1dGlvbnMuY28uaW4iLCJuYW1laWQiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiZW1haWwiOiJhcmp1bkBvbmV0ZWFtc29sdXRpb25zLmNvLmluIiwiYXV0aF90aW1lIjoiMDEvMzEvMjAyNCAwNzoxNzo0MyIsImRiX25hbWUiOiIxMTU3NjciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJBRE1JTklTVFJBVE9SIiwiZXhwIjoyNTM0MDIzMDA4MDAsImlzcyI6IkNsYXJlX0FJIiwiYXVkIjoiQ2xhcmVfQUkifQ.nqihj10ep-rq2ODhP9tuNbdyG8r8IpYrlM-0Q_36LeM',
        'Content-Type': 'application/json-patch+json'
      }
    })
      .then(response => {
        // console.log(response.data);
      })
      .catch(error => {
        console.error(error);
      });
    

 }
 
  
}
} catch (err) {
    console.log(err)
   
} finally {
 
}


 }  }









             await connection.commit();
             connection.release();
             console.log(result1)
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

















//   Update_Resume_Status: async function (Resume_Status_Change_) {
//     return new Promise(async (rs, rej) => {
//         const pool = db.promise();
//         let result1;
//         var connection = await pool.getConnection();
//         try {
//             const result1 = await new storedProcedure(
//                 "Update_Resume_Status",
//                 [
//                     Resume_Status_Change_.Resume_Status_Id,
//                     Resume_Status_Change_.Resume_Status_Name,
//                     Resume_Status_Change_.Student_Id,
                  
                   
//                 ],
//                 connection
//             ).result();

//  console.log(result1)


//  var tempId=''
//  var Resume_Status_Id=''
// //  for(var i=0;i<result1.length;i++)
// if(result1.Change_status_ ==1)
//  {
//  tempId = (result1.Device_Id) ;
//       Resume_Status_Id= Resume_Status_Change_.Resume_Status_Id
//  var message = {
//  registration_ids:[tempId ],
//  notification: {
//          title: 'Resume Status Change',
//          body:  result1.Resume_Status_Name_  ,
//      },
//      data: { title:1,
//      Id:Resume_Status_Id,
//      click_action: "1",
//  }
//  };
  
//  fcm.send(message, function(err, response) {
//      if (err) {
//          console.log("Something has gone wrong!"+err);
//          console.log("Respponse:! "+response);
//      } else {
//          // showToast("Successfully sent with response");
//          console.log("Successfully sent with response: ", response);
//      }
 
 
//  });
//  }
//              await connection.commit();
//              connection.release();
//              console.log(result1)
//              rs(result1);
//          } catch (err) {
//              await connection.rollback();
//              rej(err);
//              var result2 = [{ Student_Id_: 0 }];
            
//              rs(result2);
//          } finally {
//              connection.release();
//          }
//      });
//  },

      

Search_Company_List_Report: function ( Is_Date_,Fromdate_,Todate_,Company_id_,Pointer_Start_,Pointer_Stop_,Page_Length_,callback
    ) {
                if (Pointer_Start_===undefined || Pointer_Start_==="undefined" )
                Pointer_Start_=0;
    
                if (Pointer_Stop_===undefined || Pointer_Stop_==="undefined" )
                Pointer_Stop_=0; 
    
    
        return db.query(
            "CALL Search_Company_List_Report(@Is_Date_ :=?,@Fromdate_ :=?,@Todate_ :=?,@Company_id_ :=?,@Pointer_Start_ :=?,@Pointer_Stop_ :=?,@Page_Length_ :=?)",
            
            [Is_Date_, Fromdate_,Todate_,Company_id_,Pointer_Start_,Pointer_Stop_,Page_Length_],
            
            callback
        );
        
    },
    



};
module.exports=Job_Posting;

