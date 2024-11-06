var express = require('express');
var router = express.Router();
var Job_Posting = require('../models/Job_Posting');
const upload = require('../helpers/multer-helper');

// router.post('/Save_Job_Posting', upload.array('myFile'), (req, res, next) =>
// {
//   try
//   {
//     const file = req.files
//     var Photo_ = [];
//     var tempFile_Nmae='';  
//     if (!file) 
//     {
//     }
//     else
//     {
//       for (var i = 0; i < file.length; i++) 
//       {
//         Photo_.push({ File_name: file[i].filename })
//         tempFile_Nmae = Photo_[0].File_name;
//       }
//     }
//     // var Photo_json = JSON.stringify(Photo_)
//       var Job_Posting_ =
//       {
//             "Job_Posting_Id": req.body.Job_Posting_Id,
//             "Job_Code": req.body.Job_Code,
//             "Job_Title": req.body.Job_Title,
//             "Descritpion": req.body.Descritpion,
//             "Skills": req.body.Skills,
//             "No_Of_Vaccancy": req.body.No_Of_Vaccancy,
//             "Experience": req.body.Experience,
//             "Experience_Name": req.body.Experience_Name,
//             "Job_Location": req.body.Job_Location,
//             "Qualification": req.body.Qualification,
//             "Qualification_Name": req.body.Qualification_Name,
//             "Functional_Area": req.body.Functional_Area,
//             "Functional_Area_Name": req.body.Functional_Area_Name,
//             "Specialization": req.body.Specialization,
//             "Specialization_Name": req.body.Specialization_Name,
//             "Salary": req.body.Salary,
//             "Last_Date": req.body.Last_Date,
//             "Company_Id": req.body.Company_Id,
//             "Company_Name": req.body.Company_Name,
//             "Address": req.body.Address,
//             "Contact_Name": req.body.Contact_Name,
//             "Contact_No": req.body.Contact_No,
//             "Email": req.body.Email,
//             "Address1": req.body.Address1,
//             "Address2": req.body.Address2,
//             "Address3": req.body.Address3,
//             "Address4": req.body.Address4,
//             "Pincode": req.body.Pincode,
//             "Status": req.body.Status,
//             "Logo": tempFile_Nmae,
//             "User_Id": req.body.User_Id,
//             "Course_Id": req.body.Course_Id,
//             "Course_Name": req.body.Course_Name,
//             "Gender_Id": req.body.Gender_Id,
//             "Gender_Name": req.body.Gender_Name

            
//       };
//     Job_Posting.Save_Job_Posting(Job_Posting_, function (err, rows)
//         {
//           console.log(err,"2")
//         if (err) 
//         {
//           return 1;
//         }
//         else
//         {
//           return res.json(rows);
//         }
//       });
    
//   }

//   catch (err) 
//   {
//     console.log(err,'1')
//     const error = new Error('Please upload a file')
//     error.httpStatusCode = 400
//     return next(error)
//   }
//     finally 
//     {
//     }
//   }
// );


router.get('/Search_Job_Posting', async function (req, res, next) {
  var result = '';
  try {
    result = await Job_Posting.Search_Job_Posting(req.query.Job_Code_,req.query.Job_id_,req.query.Job_Location_,req.query.Company_id_,
      req.query.Pointer_Start_,req.query.Pointer_Stop_,req.query.Page_Length_);
    res.json(result);
  }
  catch (e) {

  }
  finally {

  }
});
router.get('/Get_Job_Posting/:Job_Posting_Id_?',function(req,res,next)
  { 
  try 
  {
  Job_Posting.Get_Job_Posting(req.params.Job_Posting_Id_, function (err, rows) 
  {
  if (err) 
  {
  res.json(err);
  }
  else 
  {
  res.json(rows);
  }
  });
  }
  catch (e) 
  {
  }
  finally 
  {
  }
  });
router.get('/Delete_Job_Posting/:Job_Posting_Id_?',function(req,res,next)
  { 
  try 
  {
  Job_Posting.Delete_Job_Posting(req.params.Job_Posting_Id_, function (err, rows) 
  {
  if (err) 
  {
  res.json(err);
  }
  else 
  {
  res.json(rows);
  }
  });
  }
  catch (e) 
  {
  }
  finally 
  {
  }
  });
  
  
  router.get("/Search_Jobposting_Summary/", function (req, res, next) {
    try {

    
      Job_Posting.Search_Jobposting_Summary(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
        req.query.Job_id_,
        req.query.Company_id_,
        req.query.Course_Id_,
        req.query.Pointer_Start_,
        req.query.Pointer_Stop_,
        req.query.Page_Length_,
        function (err, rows) {
          if (err) {
            
            res.json(err);
          } else {
             
            res.json(rows);
          }
        }
      );
    } catch (e) {
      
    } finally {
    }
  });

  router.get("/Search_Interview_Scheduled_Summary/", function (req, res, next) {
    try {

    
      Job_Posting.Search_Interview_Scheduled_Summary(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
        req.query.Company_id_,
        req.query.Course_Id_,
        req.query.Pointer_Start_,
        req.query.Pointer_Stop_,
        req.query.Page_Length_,
        function (err, rows) {
          if (err) {
            
            res.json(err);
          } else {
             
            res.json(rows);
          }
        }
      );
    } catch (e) {
      
    } finally {
    }
  });


  router.get("/Search_Placement_Report_New/", function (req, res, next) {
    try {

    
      Job_Posting.Search_Placement_Report_New(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
        req.query.Trainer_Id_,
        req.query.Course_Id_,
        req.query.Pointer_Start_,
        req.query.Pointer_Stop_,
        req.query.Page_Length_,
        function (err, rows) {
          if (err) {
            console.log(err)
            res.json(err);
          } else {
             
            res.json(rows);
          }
        }
      );
    } catch (e) {

      console.log(e)
      
    } finally {
    }
  });



  router.get("/Search_Complaint_Details/", function (req, res, next) {
    try {

    
      Job_Posting.Search_Complaint_Details(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
        req.query.Status_,
        req.query.Login_User_,
        req.query.Pointer_Start_,
        req.query.Pointer_Stop_,
        req.query.Page_Length_,
        function (err, rows) {
          if (err) {
            
            res.json(err);
          } else {
             
            res.json(rows);
          }
        }
      );
    } catch (e) {
      
    } finally {
    }
  });




  router.get("/Search_Interview_Scheduled_Details/", function (req, res, next) {
    try {

    
      Job_Posting.Search_Interview_Scheduled_Details(
        req.query.Job_id_,
        req.query.Company_Id_,
        req.query.Interview_Date_,
        req.query.Interview_Time_,
        req.query.course_id_,
        function (err, rows) {
          if (err) {
            
            res.json(err);
          } else {
             
            res.json(rows);
          }
        }
      );
    } catch (e) {
      
    } finally {
    }
  });


  router.get("/Search_Appliedcount_Details/", function (req, res, next) {
    try {
      Job_Posting.Search_Appliedcount_Details(
        req.query.Job_Posting_Id_,
        req.query.Job_Title_,
        function (err, rows) {
          if (err) {
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });

  
  router.get("/Search_Rejectedcount_Details/", function (req, res, next) {
    try {
      Job_Posting.Search_Rejectedcount_Details(
        req.query.Job_Posting_Id_,
        req.query.Job_Title_,
        function (err, rows) {
          if (err) {
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });


  router.get("/Get_Resumefilefor_Report/", function (req, res, next) {
    try {
      Job_Posting.Get_Resumefilefor_Report(
        req.query.Student_Id_,
        function (err, rows) {
          if (err) {
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });


  router.get("/Search_Student_Job_Report/", function (req, res, next) {
    try {
      Job_Posting.Search_Student_Job_Report(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
        req.query.Student_Status_,
        req.query.Student_Name_,
        req.query.Offeredcount_,
        req.query.Blacklist_Status_,
        req.query.Activate_Status_,
        req.query.Fees_Status_,
        req.query.Search_Resume_Status_,
        
        function (err, rows) {
          if (err) {
            console.log(err);
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });

  // router.get("/Save_Schedule_Interview/", function (req, res, next) {
  //   try {
  //     Job_Posting.Save_Schedule_Interview(
  //       req.query.Interview_Schedule_Date_,
  //       req.query.temp_Applied_jobs_,
  //       req.query.Interview_Schedule_Description_,
  //       req.query.Login_User_,
  //       req.query.temp_Student_d,
  //       function (err, rows) {
  //         if (err) {
  //           console.log(err);
  //           res.json(err);
  //         } else {
  //           res.json(rows);
  //         }
  //       }
  //     );
  //   } catch (e) {
  //     console.log(e)
  //   } finally {
  //   }
  // });

  // router.get("/Save_Mark_Placement/", function (req, res, next) {
  //   try {
  //     Job_Posting.Save_Mark_Placement(
  //       req.query.Placement_Date_,
  //       req.query.temp_Applied_jobs_,
  //       req.query.Placement_Description_,
  //       req.query.Login_User_,
  //       req.query.temp_Student_d,
  //       function (err, rows) {
  //         if (err) {
  //           console.log(err);
  //           res.json(err);
  //         } else {
  //           res.json(rows);
  //         }
  //       }
  //     );
  //   } catch (e) {
  //     console.log(e)
  //   } finally {
  //   }
  // });






  router.get("/Search_Jobposting_Detailed_Report/", function (req, res, next) {
    try {
      Job_Posting.Search_Jobposting_Detailed_Report(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
        req.query.Company_,
        req.query.Job_,
        req.query.Student_Status_,
        req.query.Blacklist_Status_,
        req.query.Activate_Status_,
        req.query.Fees_Status_,
        function (err, rows) {
          if (err) {
            console.log(err);
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });

  router.get("/Search_Job_Rejections/", function (req, res, next) {
    try {
      Job_Posting.Search_Job_Rejections(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
       
        function (err, rows) {
          if (err) {
            console.log(err);
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });

  router.get("/Applied_Reject_Detaild_Report/", function (req, res, next) {
    try {
      Job_Posting.Applied_Reject_Detaild_Report(
        req.query.Student_Id_,
       
       
        function (err, rows) {
          if (err) {
            console.log(err);
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });


  router.get("/History_Of_Interview_Schedule/", function (req, res, next) {
    try {
      Job_Posting.History_Of_Interview_Schedule(
        req.query.Student_Id_,
       
       
        function (err, rows) {
          if (err) {
            console.log(err);
            res.json(err);
          } else {
            res.json(rows);
          }
        }
      );
    } catch (e) {
    } finally {
    }
  });


  // router.post("/Save_Job_Posting/", async function (req, res, next) {
  //   try {
  //     const resp = await Job_Posting.Save_Job_Posting(req.body);
  //     return res.send(resp);
  //   } catch (e) {
  //     console.log(e);
  //     return res.send(e);
  //   }
  // });


  router.post("/Save_Job_Posting/", async function (req, res, next) {
    try {
      const resp = await Job_Posting.Save_Job_Posting(req.body);
      return res.send(resp);
    } catch (e) {
      console.log(e);
      return res.send(e);
    }
  });

  

  router.post("/Save_Schedule_Interview/", async function (req, res, next) {
    try {
      const resp = await Job_Posting.Save_Schedule_Interview(req.body);
      return res.send(resp);
    } catch (e) {
      console.log(e);
      return res.send(e);
    }
  });


  router.post("/Save_ReSchedule_Interview/", async function (req, res, next) {
    try {
      const resp = await Job_Posting.Save_ReSchedule_Interview(req.body);
      return res.send(resp);
    } catch (e) {
      console.log(e);
      return res.send(e);
    }
  });

  router.post("/Save_Mark_Placement/", async function (req, res, next) {
    try {
      const resp = await Job_Posting.Save_Mark_Placement(req.body);
      return res.send(resp);
    } catch (e) {
      console.log(e);
      return res.send(e);
    }
  });


  router.post("/Update_Resume_Status/", async function (req, res, next) {
		try {
		  const resp = await Job_Posting.Update_Resume_Status(req.body);
		  return res.send(resp);
		} catch (e) {
		  console.log(e);
		  return res.send(e);
		}
	  });
	


    router.get("/Search_Company_List_Report/", function (req, res, next) {
      try {
  console.log(req.query.Is_Date_,
    req.query.Fromdate_,
    req.query.Todate_,
    req.query.Company_id_,
    req.query.Pointer_Start_,
    req.query.Pointer_Stop_,
    req.query.Page_Length_)
      
        Job_Posting.Search_Company_List_Report(
          req.query.Is_Date_,
          req.query.Fromdate_,
          req.query.Todate_,
          req.query.Company_id_,
          req.query.Pointer_Start_,
          req.query.Pointer_Stop_,
          req.query.Page_Length_,
          function (err, rows) {
            if (err) {
              
              res.json(err);
            } else {
               
              res.json(rows);
            }
          }
        );
      } catch (e) {
        console.log(e)
        
      } finally {
      }
    });
  
  

module.exports = router;

