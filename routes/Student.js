var express = require("express");
var router = express.Router();


var Student = require("../models/Student");
const upload = require("../helpers/multer-helper");
router.post("/Save_Student", upload.array("myFile"), (req, res, next) => {
	try {
		const file = req.files;
		var Photo_ = [];
		var tempFile_Nmae = "";
		var tempFile_Nmae_id_proof = "";
		var tempFile_Nmae_Parent_spouse_idcard = "";
		if (!file) {
			// const error = new Error('Please upload a file')
			//error.httpStatusCode = 400
		} else {
			// for (var i = 0; i < file.length; i++) {
			// 	Photo_.push({ File_name: file[i].filename });
			// 	tempFile_Nmae = Photo_[0].File_name;

			// 	// Photo_.push({ File_name: file[i].filename });
			// 	tempFile_Nmae_id_proof = Photo_[0].File_name;
			// }
			console.log(req.body.Document_File_Array1)

			for (var i = 0; i < req.body.Document_File_Array1; i++) 
			{
			  if(i==req.body.ImageFile_Photo)
			  tempFile_Nmae=file[i].filename;      
			  else if(i==req.body.ImageFile_Photo1)
			  tempFile_Nmae_id_proof=file[i].filename;

			  else if(i==req.body.ImageFile_Photo2)
				tempFile_Nmae_Parent_spouse_idcard=file[i].filename;
			 
			}
			
			// console.log(tempFile_Nmae)
			// console.log(tempFile_Nmae_id_proof)
		}


	




		

console.log(Student1)


		// var Photo_json = JSON.stringify(Photo_)
		var Student1;
		if (
			req.body.Student_Name != "" &&
			req.body.Student_Name != undefined &&
			req.body.Student_Name != null
		) {
			Student1 = {
				Student_Id: req.body.Student_Id_Student,
				Student_Name: req.body.Student_Name,
				Address1: req.body.Address1,
				Address2: req.body.Address2,
				Address3: req.body.Address3,
				Address4: req.body.Address4,
				Pincode: req.body.Pincode,
				Phone: req.body.Phone,
				Mobile: req.body.Mobile,
				Whatsapp: req.body.Whatsapp,
				DOB: req.body.DOB,
				Gender: req.body.Gender,
				Email: req.body.Email,
				Alternative_Email: req.body.Alternative_Email,
				Passport_No: req.body.Passport_No,
				Passport_Expiry: req.body.Passport_Expiry,
				User_Name: req.body.User_Name,
				Password: req.body.Password,
				Photo: tempFile_Nmae,
				User_Id: req.body.User_Id,
				Registration_No: req.body.Registration_No,
				Role_No: req.body.Role_No,
				Enquiry_Source: req.body.Enquiry_Source,
				Enquiry_Source_Name: req.body.Enquiry_Source_Name,
				State_Id: req.body.State_Id,
				District_Id: req.body.District_Id,
				Course_Id: req.body.Course_Id,
				Qualification_Id: req.body.Qualification_Id,
				District_Name: req.body.District_Name,
				Course_Name: req.body.Course_Name,
				Qualification_Name: req.body.Qualification_Name,
				College_Name: req.body.College_Name,
				Year_Of_Pass_Id: req.body.Year_Of_Pass_Id,
				Year_Of_Passing: req.body.Year_Of_Passing,
				Id_Proof_Id: req.body.Id_Proof_Id,
				Id_Proof_Name: req.body.Id_Proof_Name,
				Id_Proof_No: req.body.Id_Proof_No,
				Id_Proof_File: tempFile_Nmae_id_proof,
				Id_Proof_FileName: req.body.Id_Proof_FileName,

				Parent_spouse_name: req.body.Parent_spouse_name,
				Parent_spouse_contact_no: req.body.Parent_spouse_contact_no,
				Parent_spouse_idcard: req.body.Parent_spouse_idcard,
				Parent_spouse_idcard_File: tempFile_Nmae_Parent_spouse_idcard,


				// Resume_Status_Id: req.body.Resume_Status_Id,
				// Resume_Status_Name: req.body.Resume_Status_Name,

			};

		}
		var jsondata1 = JSON.stringify(Student1);
		var Followup;
		if (
			req.body.Status != "" &&
			req.body.Status != undefined &&
			req.body.Status != null
		) {
			var Followup = {
				Student_Id: req.body.Student_Id,
				Entry_Date: req.body.Entry_Date,
				Next_FollowUp_Date: req.body.Next_FollowUp_Date,
				FollowUp_Difference: req.body.FollowUp_Difference,
				Status: req.body.Status,
				By_User_Id: req.body.By_User_Id,
				To_User_Id: req.body.To_User_Id,
				Remark: req.body.Remark,
				Remark_Id: req.body.Remark_Id,
				FollowUp_Type: req.body.FollowUp_Type,
				FollowUP_Time: req.body.FollowUP_Time,
				Actual_FollowUp_Date: req.body.Actual_FollowUp_Date,
				Status_Name: req.body.Status_Name,
				To_User_Name: req.body.To_User_Name,
				By_User_Name: req.body.By_User_Name,
				FollowUp: req.body.FollowUp,
			};
		}
		var jsondata2 = JSON.stringify(Followup);

		var Student_Data = {
			Student: jsondata1,
			Followup: jsondata2,
		};
		Student.Save_Student(Student_Data, function (err, rows) {
			if (err) {
				console.log(err);
				return 1;
			} else {
				return res.json(rows);
			}
		});
	} catch (err) {
		console.log(err);
		const error = new Error("Please upload a file");
		error.httpStatusCode = 400;
		return next(error);
	} finally {
	}
});
// router.get('/Search_Student/',function(req,res,next)
//   {
//   try
//   {
//   Student.Search_Student(req.query.Student_Name, function (err, rows)
//   {
//   if (err)
//   {
//   res.json(err);
//   }
//   else
//   {
//   res.json(rows);
//   }
//   });
//   }
//   catch (e)
//   {
//   }
//   finally
//   {
//   }
//   });

router.get("/Search_Student", async function (req, res, next) {
	console.log(req.query.SearchbyName_)
	var result = "";
	try {
		result = await Student.Search_Student(
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.SearchbyName_,
			req.query.By_User_,
			req.query.Status_Id_,
			req.query.Is_Date_Check_,
			req.query.Page_Index1_,
			req.query.Page_Index2_,
			req.query.Login_User_Id_,
			req.query.RowCount,
			req.query.RowCount2,
			req.query.Register_Value,
			req.query.Qualification_Id,
			req.query.Course_Id
		);

		res.json(result);
	} catch (e) {
		console.log(e)
	} finally {
	}
});
router.get("/Get_Student/:Student_Id_?", function (req, res, next) {
	try {
		Student.Get_Student(req.params.Student_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Get_App_Dashboard/:Student_Id_?", function (req, res, next) {
	try {
		console.log(req.params)
		Student.Get_App_Dashboard(req.params.Student_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});


router.get('/Load_Year_of_Pass',function(req,res,next)
  { 
  try 
  {
	Student.Load_Year_of_Pass( function (err, rows)
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
  ;
  }
  finally 
  {
  }
  });



router.get("/Get_Last_FollowUp/:Users_Id_?", function (req, res, next) {
	try {
		Student.Get_Last_FollowUp(req.params.Users_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Delete_Student/:Student_Id_?", function (req, res, next) {
	try {
		Student.Delete_Student(req.params.Student_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Search_Status_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Status_Typeahead(
			req.query.Status_Name,
			req.query.Group_Id,
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
router.get("/Search_Users_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Users_Typeahead(req.query.Users_Name, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get("/Search_Faculty_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Faculty_Typeahead(
			req.query.Users_Name,req.query.Role_Type,
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
router.get("/Search_Typeahead_Loadfaculty/", function (req, res, next) {
	try {
		Student.Search_Typeahead_Loadfaculty(
			req.query.Users_Name,
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

router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Gender/", function (req, res, next) {
	try {
		Student.Load_Gender(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});


router.get("/Load_Id_Proof/", function (req, res, next) {
	try {
		Student.Load_Id_Proof(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});


router.get("/Load_Attendance_Status/", function (req, res, next) {
	try {
		Student.Load_Attendance_Status(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get("/Load_Enquiry_Source/", function (req, res, next) {
	try {
		Student.Load_Enquiry_Source(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get("/Load_Resume_Status/", function (req, res, next) {
	try {
		Student.Load_Resume_Status(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get(
	"/Load_Student_Search_Dropdowns/:Group_Id_?",
	function (req, res, next) {
		try {
			Student.Load_Student_Search_Dropdowns(
				req.params.Group_Id_,
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
	}
);
router.get("/Get_FollowUp_Details/:Student_Id_?", async (req, res, next) => {
	try {
		const result = await Student.Get_FollowUp_Details(req.params.Student_Id_);
		res.json(result);
	} catch (e) {
		res.send(e);
	} finally {
	}
});
router.get("/Get_FollowUp_History/:Student_Id_?", async (req, res, next) => {
	try {
		const result = await Student.Get_FollowUp_History(req.params.Student_Id_);
		res.json(result);
	} catch (e) {
		res.send(e);
	} finally {
	}
});
router.get(
	"/Register_Student1/:Student_Id_?/:User_Id_?",
	function (req, res, next) {
		try {
			Student.Register_Student1(
				req.params.Student_Id_,
				req.params.User_Id_,
				function (err, rows) {
					if (err) {
						console.log(err)
						res.json(err);
					} else {
						console.log(rows)
						res.json(rows);
					}
				}
			);
		} catch (e) {
			console.log(e)
		} finally {
		}
	}
);
router.get(
	"/Register_Student/:Student_Id_?/:User_Id_?/:Student_Name_?/:Course_Name_?",
	async (req, res, next) => {
		 //console.log(req, res);
		try {			
			const result = await Student.Register_Student(
				req.params.Student_Id_,
				req.params.User_Id_,
				req.params.Student_Name_,
				req.params.Course_Name_,
			);
			res.json(result);
		} catch (e) {
			console.log(e);
			res.send(e);
		} finally {
		}
	}
);

router.post('/Upload_Resume', upload.array('myFile'), (req, res, next) =>
{
  try
  {
    const file = req.files
        var Resume_Image;
        var Photo_ = [];    
    if (!file) 
    {
    }
    else
    {		
      //for (var i = 0; i < req.body.Document_File_Array; i++) 
      {
		//if(i==req.body.ResumeImageFilename)
		Resume_Image=file[0].filename
      }
    } 
      var Docs    
      Docs =
      {     
                 "Student_Id": req.body.Student_Id,              
                 "Resume":req.body.Resume,
				 "Image_ResumeFilename":Resume_Image ,   
      };    
    var jsondata1 = JSON.stringify(Docs)
    var Docs_Data=
    {
      "Docs_D": jsondata1,
    };
    Student.Upload_Resume(Docs_Data, function (err, rows)
        {
         
        if (err) 
        {
          console.log(err)
          
          return 1;
        }
        else
        {
          console.log(rows)
          return res.json(rows);
        }
      });
    
  }

  catch (err) 
  {
    console.log(err)
    const error = new Error('Please upload a file')
    error.httpStatusCode = 400
    return next(error)
  }
    finally 
    {
    }
  }
  
);







router.get("/Remove_Registration/:Student_Id_?", function (req, res, next) {
	try {
		Student.Remove_Registration(req.params.Student_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Search_Course_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Course_Typeahead(
			req.query.Course_Name,
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
router.get("/Search_Batch_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Batch_Typeahead(req.query.Batch_Name, function (err, rows) {
			if (err) {
				console.log(err);
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get("/Search_Batch_Typeahead_1/", function (req, res, next) {
	try {
		Student.Search_Batch_Typeahead_1(
			req.query.Batch_Name,
			req.query.Course_Id,
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


router.get("/Search_Batch_Typeahead_Report/", function (req, res, next) {
	try {
		Student.Search_Batch_Typeahead_Report(
			req.query.Batch_Name,
			req.query.Login_User,
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

// router.get("/Search_Batch_Typeahead_Report_New/", function (req, res, next) {
// 	try {
// 		Student.Search_Batch_Typeahead_Report_New(
// 			req.query.Batch_Name,
// 			req.query.Login_User,
// 			req.query.Trainer,
// 			function (err, rows) {
// 				if (err) {
// 					console.log(err);
// 					res.json(err);
// 				} else {
// 					res.json(rows);
// 				}
// 			}
// 		);
// 	} catch (e) {
// 	} finally {
// 	}
// });

router.get("/Search_Batch_Typeahead_Report_New/", function (req, res, next) {
    try {
        Student.Search_Batch_Typeahead_Report_New(
            req.query.Batch_Name,
            req.query.Login_User,
            req.query.Trainer,
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



router.get("/Search_Batch_Typeahead_Attendance/", function (req, res, next) {
	try {
		Student.Search_Batch_Typeahead_Attendance(
			req.query.Batch_Name,
			req.query.Course_Id,
			req.query.Login_User,
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

router.get("/Search_Batch_Typeahead_Attendance1/", function (req, res, next) {
	try {
		Student.Search_Batch_Typeahead_Attendance1(
			req.query.Batch_Name,
			req.query.Course_Id,
			req.query.Login_User,
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


router.get("/Search_Batch_Typeahead_2/", function (req, res, next) {
	try {
		Student.Search_Batch_Typeahead_2(
			req.query.Batch_Name,
			req.query.Course_Id,
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


router.get("/Get_Course_Student/:Course_Id?", function (req, res, next) {
	try {
		Student.Get_Course_Student(req.params.Course_Id, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Get_Student_Course/:Student_Id_?", function (req, res, next) {
	try {
		Student.Get_Student_Course(req.params.Student_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get(
	"/Get_Student_Course_Click/:Student_Id_?/:Course_Id_ ?/:Fees_Type_Id ?",
	function (req, res, next) {
		try {
			Student.Get_Student_Course_Click(
				req.params.Student_Id_,
				req.params.Course_Id_,
				req.params.Fees_Type_Id,
				function (err, rows) {
					if (err) {
						console.log(err);
						res.json(err);
					} else {
						console.log(rows);
						res.json(rows);
					}
				}
			);
		} catch (e) {
		} finally {
		}
	}
);
router.post("/Save_Student_Course/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Student_Course(req.body);
		return res.send(resp);
	} catch (e) {
		console.log(e);
		return res.send(e);
	}
});











router.get("/Get_Installment_Details/", function (req, res, next) {
	try {
		Student.Get_Installment_Details(
			req.query.Installment_Type_Id,
			req.query.Course_Id,
			req.query.Student_Course_Id,
			req.query.Student_Id,
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
router.get("/Search_Subject_Course_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Subject_Course_Typeahead(
			req.query.Subject_Name,
			req.query.Course_Id,
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
router.get("/Load_Exam_Status/", function (req, res, next) {
	try {
		Student.Load_Exam_Status(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.post("/Save_Mark_List_Master/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Mark_List_Master(req.body);
		return res.send(resp);
	} catch (e) {
		return res.send(e);
	}
});
router.get("/Get_Student_Mark_List/:Student_Id_?", function (req, res, next) {
	try {
		Student.Get_Student_Mark_List(req.params.Student_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
// router.post("/Save_Student_Receipt_Voucher/", function (req, res, next) {
// 	try {
// 		Student.Save_Student_Receipt_Voucher(req.body, function (err, rows) {
// 			if (err) {
// 				console.log(err);
// 				res.json(err);
// 			} else {
// 				res.json(rows);
// 			}
// 		});
// 	} catch (e) {
// 		console.log(e);
// 	} finally {
// 	}
// });



router.post('/Save_Student_Receipt_Voucher', upload.array('myFile'), (req, res, next) =>
{ 

try 
{
  const file = req.files
	var tempReceipt_ImageFile ='';
	var Photo_ = [];

	if (!file) 
	{
	}

	else
	{
	  
	  for (var i = 0; i < req.body.Document_File_Array2; i++) 
	  {
		if(i==req.body.ReceiptImageFile_Photo1)
		tempReceipt_ImageFile=file[i].filename;      
	  }
	}

	 var Receipt_Voucher1

	 Receipt_Voucher1 =
	{     
	  "Receipt_Voucher_Id": req.body.Receipt_Voucher_Id,
	  "Date":req.body.Date,
	  "From_Account_Id":req.body.From_Account_Id,
	  "Amount":req.body.Amount,
	  "Payment_Mode":req.body.Payment_Mode,
	  "User_Id":req.body.User_Id,  
	  "Payment_Status":req.body.Payment_Status,   
	  "To_Account_Id":req.body.To_Account_Id,   
	  "To_Account_Name":req.body.To_Account_Name,  
	  "Description":req.body.Description, 
	  "Student_Fees_Installment_Details_Id":req.body.Student_Fees_Installment_Details_Id, 
	  "Student_Course_Id":req.body.Student_Course_Id, 
	  "Fees_Type_Id":req.body.Fees_Type_Id, 
	  "Tax_Percentage":req.body.Tax_Percentage, 
	  "Course_Id":req.body.Course_Id, 
	  "Receipt_Image_File":tempReceipt_ImageFile, 
	  "Receipt_Image_File_Name":req.body.Receipt_Image_File_Name, 
	   

	}

	var jsondata1 = JSON.stringify(Receipt_Voucher1)
	var Receipt_Voucher_Data=
	{
	  "Receipt_Voucher_De": jsondata1,
	
	};

	Student.Save_Student_Receipt_Voucher(Receipt_Voucher_Data, function (err, rows) 
{
 if (err) 
 {
   console.log(err)
   return 1;
 }
 else 
 {
   console.log(rows)
   return res.json(rows);
 }
 });
 }
catch (e) 
{
  console.log(e)
  const error = new Error('Please upload a file')
  error.httpStatusCode = 400
  return next(error)
}
finally 
{
}
 });


router.get('/Send_Receipt_Sms_Email/:Mobile_?/:Email_?/:Sms?/:Student_Name?/:Amount_ ?/:Date_ ?/:Total_Amount_ ?/:Instalment_Date_ ?/:BalanceAmount_ ?',async (req, res, next) =>
{
try
{
const result = await Student.Send_Receipt_Sms_Email(req.params.Mobile_,req.params.Email_,req.params.Sms,
  req.params.Student_Name,req.params.Amount_,req.params.Date_,req.params.Total_Amount_,req.params.Instalment_Date_,req.params.BalanceAmount_);
res.json(result);
} 
catch (e) 
{
  console.log(e)
res.send(e);
} 
finally
{
}
});
// router.get(
// 	"/Send_Receipt_Sms_Email/:Mobile_?/:Email_?/:Sms?/:Student_Name?/:Amount_ ?/:Date_ ?/:Total_Amount_ ?/:Instalment_Date_ ?/:BalanceAmount_ ?",
// 	async (req, res, next) => {
// 		try {
// 			// console.log(req);
// 			const result = await Student.Send_Receipt_Sms_Email(
// 				req.params.Mobile_,
// 				req.params.Email_,
// 				req.params.Sms,
// 				req.params.Student_Name,
// 				req.params.Amount_,
// 				req.params.Date_,
// 				req.params.Total_Amount_,
// 				req.params.Instalment_Date_,
// 				req.params.BalanceAmount_
// 			);
// 			res.json(result);
// 		} catch (e) {
// 			console.log(e);
// 			res.send(e);
// 		} finally {
// 		}
// 	}
// );
router.get(
	"/Get_Student_Receipt_History/:Student_Id_?/:Course_Id_?",
	function (req, res, next) {
		try {
			Student.Get_Student_Receipt_History(
				req.params.Student_Id_,
				req.params.Course_Id_,
				function (err, rows) {
					if (err) {
					//	console.log(err);
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
	}
);

router.get(
	"/Get_Attendance_Details/:Student_Id_?/:Course_Id_?",
	function (req, res, next) {
		try {
			Student.Get_Attendance_Details(
				req.params.Student_Id_,
				req.params.Course_Id_,
				function (err, rows) {
					if (err) {
					//	console.log(err);
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
	}
);

router.get(
	"/Get_Student_Receipt_Image/:Receipt_Voucher_Id?",
	function (req, res, next) {
		try {
			Student.Get_Student_Receipt_Image(
				req.params.Receipt_Voucher_Id,
				
				function (err, rows) {
					if (err) {
					//	console.log(err);
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
	}
);
router.get(
	"/Delete_Student_Receipt_Voucher/:Receipt_Voucher_Id_",
	function (req, res, next) {
		try {
			Student.Delete_Student_Receipt_Voucher(
				req.params.Receipt_Voucher_Id_,
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
	}
);

router.get("/Send_Sms/:Mobile_?/:Sms?", async (req, res, next) => {
	try {
		const result = await Student.Send_Sms(req.params.Mobile_, req.params.Sms);
		res.json(result);
	} catch (e) {
		console.log(e);
		res.send(e);
	} finally {
	}
});
router.get(
	"/Send_Sms_Email/:Mobile_?/:Email_?/:Sms?/:Student_Name?/:Login_User_Name?/:User_Mobile?",
	async (req, res, next) => {
		 //console.log(req, res);
		try {
			console.log(req.params.User_Mobile)
			console.log(req.params.Login_User_Name)
			const result = await Student.Send_Sms_Email(
				req.params.Mobile_,
				req.params.Email_,
				req.params.Sms,				
				req.params.Student_Name,
				req.params.Login_User_Name,
				req.params.User_Mobile,
			);
			res.json(result);
		} catch (e) {
			//console.log(e);
			res.send(e);
		} finally {
		}
	}
);


router.get(
	"/Send_course_Email/:Mobile_?/:Email_?/:Sms?/:Student_Name?/:Course_Name?",
	async (req, res, next) => {
		try {
			console.log(req);
			const result = await Student.Send_course_Email(
				req.params.Mobile_,
				req.params.Email_,
				req.params.Sms,
				req.params.Student_Name,
				req.params.Course_Name
			);
			res.json(result);
		} catch (e) {
			console.log(e);
			res.send(e);
		} finally {
		}
	}
);



 router.post('/Download_Certificate_Data/',function(req,res,next)
 { 
 try 
 {
	 Student.Download_Certificate_Data(req.body, function (err, rows) 
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



router.get("/Search_Attendance/", function (req, res, next) {
	try {
		Student.Search_Attendance(
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
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

router.post("/Save_Attendance/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Attendance(req.body);
		return res.send(resp);
	} catch (e) {
		console.log(e);
		return res.send(e);
	}
});





router.get("/Search_Attendance_Report/", function (req, res, next) {
	try {
		Student.Search_Attendance_Report(
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Faculty_Id_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Attendance_Status_Id,
			req.query.User_Id_,
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
router.get("/Search_Fees_Outstanding_Report/", function (req, res, next) {
	try {
		Student.Search_Fees_Outstanding_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_,
			req.query.SearchbyName_,
			req.query.User_Id_,
			req.query.teammember_,
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
router.get("/Search_Fees_Collection_Report/", function (req, res, next) {
	try {
		Student.Search_Fees_Collection_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.User_Id_,
			req.query.Login_User_,
			req.query.Mode_,
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
router.get("/Search_Admission_Report/", function (req, res, next) {
	try {
		Student.Search_Admission_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.User_Id_,
			req.query.Login_User_Id_,
			req.query.Course_Id_,
			req.query.Enquiry_Source_Id_,
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
router.get("/Search_Lead_Report/", function (req, res, next) {
	try {
		Student.Search_Lead_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Enquiry_Source_,
			req.query.Login_User_,
			req.query.User_Id_,
			req.query.status_,
			req.query.Course_Id_,
			req.query.Register_Value_,
			req.query.Branch_Id_,
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
router.get("/Search_Followup_Report/", function (req, res, next) {
	try {
		Student.Search_Followup_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Enquiry_Source_,
			req.query.Login_User_,
			req.query.User_Id_,
			req.query.status_,
			req.query.Course_Id_,
			req.query.Register_Value_,
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
router.get("/Search_Conversion_Report/", function (req, res, next) {
	try {
		Student.Search_Conversion_Report(
			req.query.Is_Date_,
			req.query.To_Date_,
			req.query.Login_User_,
			req.query.User_Id_,
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



router.get("/Search_Conversion_Report_loginuser/", function (req, res, next) {
	try {
		Student.Search_Conversion_Report_loginuser(
			req.query.Is_Date_,
			req.query.To_Date_,
			req.query.Login_User_,
			
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
router.get("/Search_Transaction/", function (req, res, next) {
	try {
		Student.Search_Transaction(
			req.query.Course_,
			req.query.Portion_Covered_,
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
router.post("/Save_Transaction/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Transaction(req.body);
		return res.send(resp);
	} catch (e) {
		return res.send(e);
	}
});
router.get("/Search_Interview/", function (req, res, next) {
	try {
		Student.Search_Interview(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
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
router.post("/Save_Interview/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Interview(req.body);
		return res.send(resp);
	} catch (e) {
		return res.send(e);
	}
});
router.get("/Search_Placed/", function (req, res, next) {
	try {
		Student.Search_Placed(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
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
router.post("/Save_Placed/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Placed(req.body);
		return res.send(resp);
	} catch (e) {
		return res.send(e);
	}
});
router.get("/Search_Placed_Report/", function (req, res, next) {
	try {
		Student.Search_Placed_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Company_,
			req.query.User_Id_,
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

router.get("/Search_Interview_Report/", function (req, res, next) {
	try {
		Student.Search_Interview_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Company_,
			req.query.User_Id_,
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
router.get("/Search_Transaction_Report/", function (req, res, next) {
	try {
		Student.Search_Transaction_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Company_,
			req.query.User_Id_,
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
router.get("/Get_Dashboard_Count/:By_User_?", async function (req, res, next) {
	var result = "";
	try {
		result = await Student.Get_Dashboard_Count(req.params.By_User_);
		res.json(result);
	} catch (e) {
	} finally {
	}
});

router.get(
	"/Search_Registration_Report/:Fromdate_?/:Todate_?/:Search_By_?/:SearchbyName_?/:Status_Id_?/:By_User_?/:Is_Date_Check_?/:Page_Index1_?/:Page_Index2_?/:Login_User_Id_?/:RowCount?/:RowCount2?/:Course_Id_?/:Enquiry_Source_Id_?",
	async function (req, res, next) {
		var result = "";
		try {
			result = await Student.Search_Registration_Report(
				req.params.Fromdate_,
				req.params.Todate_,
				req.params.Search_By_,
				req.params.SearchbyName_,
				req.params.Status_Id_,
				req.params.By_User_,
				req.params.Is_Date_Check_,
				req.params.Page_Index1_,
				req.params.Page_Index2_,
				req.params.Login_User_Id_,
				req.params.RowCount,
				req.params.RowCount2,
				req.params.Course_Id_,
				req.params.Enquiry_Source_Id_
			);

			res.json(result);
		} catch (e) {
		} finally {
		}
	}
);

router.get("/Search_Attendance_Student/", function (req, res, next) {
	try {
		Student.Search_Attendance_Student(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
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

router.get("/Search_Attendance_Student/", function (req, res, next) {
	try {
		Student.Search_Attendance_Student(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
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

router.get("/Get_Attendance/", function (req, res, next) {
	try {
		Student.Get_Attendance(
			req.query.Attendance_Master_Id_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
			function (err, rows) {
				if (err) {
					res.json(err);
				} else {
					res.json(rows);
					console.log(rows);
				}
			}
		);
	} catch (e) {
	} finally {
	}
});
router.get("/Search_Transaction_Student/", function (req, res, next) {
	try {
		Student.Search_Transaction_Student(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Faculty_,
			req.query.Employer_Details_Id_,
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

router.get("/Get_Transaction/", function (req, res, next) {
	try {
		Student.Get_Transaction(
			req.query.Transaction_Master_Id_,
			req.query.Course_,
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
router.get("/Search_Interview_Student/", function (req, res, next) {
	try {
		Student.Search_Interview_Student(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Faculty_,
			req.query.Employer_Details_Id_,
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

router.get("/Get_Interview/", function (req, res, next) {
	try {
		Student.Get_Interview(
			req.query.Interview_Master_Id_,
			req.query.Course_,
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
router.get("/Search_Placed_Student/", function (req, res, next) {
	try {
		Student.Search_Placed_Student(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Faculty_,
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

router.get("/Get_Placed/", function (req, res, next) {
	try {
		Student.Get_Placed(
			req.query.Placed_Master_Id_,
			req.query.Course_,
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
router.get("/Load_Installment_Type/", function (req, res, next) {
	try {
		Student.Load_Installment_Type(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_State/", function (req, res, next) {
	try {
		Student.Load_State(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Load_Qualification/", function (req, res, next) {
	try {
		Student.Load_Qualification(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Search_State_District_Typeahead/", function (req, res, next) {
	try {
		Student.Search_State_District_Typeahead(
			req.query.District_Name,
			req.query.State_Id,
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
router.get("/Load_Employer_Details/", function (req, res, next) {
	try {
		Student.Load_Employer_Details(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get("/Get_Lead_Load_Data1/", async (req, res, next) => {
	try {
		const result = await Student.Get_Lead_Load_Data();
		res.json(result);
	} catch (e) {
		res.send(e);
	} finally {
	}
});
router.get(
	"/FollowUp_Summary/:By_User_?/:Login_User_?",
	async function (req, res, next) {
		
		var result = "";
		try {
			result = await Student.FollowUp_Summary(
				req.params.By_User_,
				req.params.Login_User_
			);
		

			res.json(result);
		} catch (e) {
		
		} finally {
		}
	}
);
router.get(
	"/Pending_FollowUp/:By_User_?/:Login_User_?",
	async function (req, res, next) {
		var result = "";
		try {
			result = await Student.Pending_FollowUp(
				req.params.By_User_,
				req.params.Login_User_
			);
			res.json(result);
		} catch (e) {
		} finally {
		}
	}
);
router.get(
	"/Get_Lead_Load_Data_ByUser/:Login_User?",
	function (req, res, next) {
		try {
			Student.Get_Lead_Load_Data_ByUser(
				req.params.Login_User,
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
	}
);

router.get(
	"/Get_Course_Details_Student_Check/:Student_Id_?",
	function (req, res, next) {
		try {
			Student.Get_Course_Details_Student_Check(
				req.params.Student_Id_,
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
	}
);
router.get("/Search_Fees_Due_Report/", function (req, res, next) {
	try {
		Student.Search_Fees_Due_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_,
			req.query.SearchbyName_,
			req.query.User_Id_,
			req.query.teammember_,
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



router.get("/Search_DropOut_Report/", function (req, res, next) {
	try {
		Student.Search_DropOut_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.ToStaff_,
			req.query.User_Id_,
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




router.get("/Search_Batch_Report/", function (req, res, next) {
	try {
		Student.Search_Batch_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Batch_,
			req.query.Faculty_,req.query.User_Id_,req.query.Branch_Id_,
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


router.get("/Search_Certificate_Report/", function (req, res, next) {
	try {
		Student.Search_Certificate_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Batch_,
			req.query.Faculty_,
			
			req.query.User_Id_,
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


router.get("/Search_Active_Batch_Report/", function (req, res, next) {
	try {
		Student.Search_Active_Batch_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Batch_,
			req.query.Faculty_,
			req.query.Course_,
			req.query.User_Id_,
			req.query.FollowUp_Branch_Id_,
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



router.get("/Search_Syllabus_Coverage/", function (req, res, next) {
	try {
		Student.Search_Syllabus_Coverage(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Batch_,
			req.query.Faculty_,
			req.query.Course_,
			req.query.User_Id_,
			req.query.FollowUp_Branch_Id,
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


router.get("/Search_Batch_Completion/", function (req, res, next) {
	try {
		Student.Search_Batch_Completion(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Batch_,
			req.query.Faculty_,
			req.query.Course_,
			req.query.User_Id_,
			req.query.FollowUp_Branch_Id,
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



router.get(
	"/Load_Interview_Student/:Transaction_Master_id_?",
	function (req, res, next) {
		try {
			Student.Load_Interview_Student(
				req.params.Transaction_Master_id_,
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
	}
);
router.get(
	"/Load_Placement_Student/:Interview_Master_Id_?",
	function (req, res, next) {
		try {
			Student.Load_Placement_Student(
				req.params.Interview_Master_Id_,
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
	}
);

router.get("/Get_Load_Dropdowns_Data/", function (req, res, next) {
	try {
		Student.Get_Load_Dropdowns_Data(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get("/Search_Company_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Company_Typeahead(
			req.query.Company_Name,
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


router.get("/Search_Team_Member_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Team_Member_Typeahead(
			req.query.Users_Name,
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


router.get("/Search_Job_Typeahead/", function (req, res, next) {
	try {
		Student.Search_Job_Typeahead(
			req.query.Job_Title,
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

router.get("/Search_District_Typeahead/", function (req, res, next) {
	try {
		Student.Search_District_Typeahead(
			req.query.District_Name,
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

router.get("/Search_Transaction_Report_Tab/", function (req, res, next) {
	try {
		Student.Search_Transaction_Report_Tab(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.User_Id_,
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

router.get("/Search_Interview_Report_Tab/", function (req, res, next) {
	try {
		Student.Search_Interview_Report_Tab(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.User_Id_,
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

router.get("/Search_Placed_Report_Tab/", function (req, res, next) {
	try {
		Student.Search_Placed_Report_Tab(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.User_Id_,
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
router.post("/Save_Student_Import/", function (req, res) {
	try {
		Student.Save_Student_Import(req.body, function (err, rows) {
			if (err) {
				console.log(err);
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});

router.get(
	"/Search_Student_Import/:From_Date_?/:To_Date_?/:Is_Date_Check_?/",
	function (req, res, next) {
		try {
			Student.Search_Student_Import(
				req.query.From_Date_,
				req.query.To_Date_,
				req.query.Is_Date_Check_,
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
	}
);

router.post("/Save_Student_Report_FollowUp/", function (req, res) {
	try {
		Student.Save_Student_Report_FollowUp(req.body, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});


router.get('/Load_Laptopdetails',function(req,res,next)
  { 
  try 
  {
	Student.Load_Laptopdetails( function (err, rows)
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
  ;
  }
  finally 
  {
  }
  });

  router.get('/Get_Applied_List_Mobile/',function(req,res,next)
  { 
  try 
  {
	
	Student.Get_Applied_List_Mobile(req.query.Student_Id_,req.query.Pointer_Start_,req.query.Pointer_Stop_,req.query.Page_Length_,req.query.Apply_type_, function (err, rows) 
  {
   if (err)                                                                                                                                                     
   {
	 
   res.json(err);
   }
   else 
   {
   // 
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
  

   router.get('/Get_Applied_List_Admin/',function(req,res,next)
   { 
   try 
   {
	 
	 Student.Get_Applied_List_Admin(req.query.Pointer_Start_,req.query.Pointer_Stop_,
		req.query.Page_Length_,req.query.Apply_type_,req.query.Is_Date_,
		req.query.From_Date_,req.query.To_Date_, function (err, rows) 
   {
	if (err)                                                                                                                                                     
	{
	  
	res.json(err);
	}
	else 
	{
	// 
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


	router.get(
		"/get_Notification_Status/:Student_Id?",
		function (req, res, next) {
			try {
	 //console.log(req.params);
	 Student.get_Notification_Status(
					req.params.Student_Id,
					function (err, rows) {
						if (err) {
							res.json(err);
	 
						} else {
							console.log(rows);
							res.json(rows);
						}
					}
				);
			} catch (e) {
			} finally {
			}
		}
	 );

	 router.get(
		"/set_Notification_Status/:Student_Id?/:Status_Id?",
		function (req, res, next) {
			try {
	// console.log(req.params)
	 Student.set_Notification_Status(
					req.params.Student_Id,req.params.Status_Id,
					function (err, rows) {
						if (err) {
							res.json(err);
	 
						} else {
							console.log(rows);
							res.json(rows);
						}
					}
				);
			} catch (e) {
				console.log(e)
			} finally {
			}
		}
	 );




	 router.get(
		"/Enable_Student_Status/:Student_Id_?",
		function (req, res, next) {
			try {
				Student.Enable_Student_Status(
					req.params.Student_Id_,
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
		}
	);
	


	router.get(
		"/Disable_Student_Status/:Student_Id_?",
		function (req, res, next) {
			try {
				Student.Disable_Student_Status(
					req.params.Student_Id_,
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
		}
	);



	router.get(
		"/Activate_Status/:Student_Id_?",
		function (req, res, next) {
			try {
				Student.Activate_Status(
					req.params.Student_Id_,
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
		}
	);
	


	router.get(
		"/Deactivate_Status/:Student_Id_?",
		function (req, res, next) {
			try {
				Student.Deactivate_Status(
					req.params.Student_Id_,
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
		}
	);




	router.post('/Save_Agreement_Details', upload.array('myFile'), (req, res, next) =>
	{ 
	
	try 
	{
	  const file = req.files
		var tempImageFile_Photo1 ='';
		var Photo_ = [];
	
		if (!file) 
		{
		}
	
		else
		{
		  
		  for (var i = 0; i < req.body.Document_File_Array; i++) 
		  {
			if(i==req.body.ImageFile_Photo1)
			tempImageFile_Photo1=file[i].filename;      
		  }
		}
	
		 var Agreement_Details_Master
	
		 Agreement_Details_Master =
		{     
		  "Student_Id": req.body.Student_Id,
		  "Student_Course_Id":req.body.Student_Course_Id,
		  "Agreement_File":tempImageFile_Photo1, 
		  "Agreement_File_Name":req.body.Agreement_File_Name,
		 
		   
	
		}
	
		var jsondata1 = JSON.stringify(Agreement_Details_Master)
		var Agreement_Details_Master_Data=
		{
		  "Agreement_Details_Master_Data_De": jsondata1,
		
		};
	
		Student.Save_Agreement_Details(Agreement_Details_Master_Data, function (err, rows) 
	{
	 if (err) 
	 {
	   console.log(err)
	   return 1;
	 }
	 else 
	 {
	   console.log(rows)
	   return res.json(rows);
	 }
	 });
	 }
	catch (e) 
	{
	  console.log(e)
	  const error = new Error('Please upload a file')
	  error.httpStatusCode = 400
	  return next(error)
	}
	finally 
	{
	}
	 });
   
   
router.get("/Search_Agreement_Details/", function (req, res, next) {
	try {
		Student.Search_Agreement_Details(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_Id_,
			req.query.student_name_,
			req.query.Faculty_Id_,
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

   

	router.get("/Get_ToStaff_Mobile/:userid?", function (req, res, next) {
		try {
			Student.Get_ToStaff_Mobile(req.params.userid, function (err, rows) {
				if (err) {
					res.json(err);
				} else {
					res.json(rows);
				}
			});
		} catch (e) {
			console.log(e)
		} finally {
		}
	});





	router.get(
		"/Moveto_Blacklist_Status/:Student_Id_?",
		function (req, res, next) {
			try {
				Student.Moveto_Blacklist_Status(
					req.params.Student_Id_,
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
		}
	);
	


	router.get(
		"/Remove_Blacklist_Status/:Student_Id_?",
		function (req, res, next) {
			try {
				Student.Remove_Blacklist_Status(
					req.params.Student_Id_,
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
		}
	);



	// router.get("/Update_Resume_Status/", function (req, res, next) {
	// 	try {
	// 	  Student.Update_Resume_Status(
	// 		req.query.Resume_Status_Id_,
	// 		req.query.Resume_Status_Name_,
	// 		req.query.Student_Id_,
	// 		function (err, rows) {
	// 		  if (err) {
	// 			console.log(err);
	// 			res.json(err);
	// 		  } else {
	// 			res.json(rows);
	// 		  }
	// 		}
	// 	  );
	// 	} catch (e) {
	// 	  console.log(e)
	// 	} finally {
	// 	}
	//   });


	  router.post("/Update_Device_Id/", async function (req, res, next) {
		try {
			const resp = await Student.Update_Device_Id(req.body);
			return res.send(resp);
		} catch (e) {
			return res.send(e);
		}
	});




	router.post("/Register_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Register_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e);
			return res.send(e);
		}
	});



	router.post("/Save_Student_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Save_Student_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			return res.send(e);
		}
	});



	router.post("/Save_Python_Course_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Save_Python_Course_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e)
			return res.send(e);
		}
	});


	router.post("/Save_Dm_Course_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Save_Dm_Course_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e)
			return res.send(e);
		}
	});

	router.post("/Save_Test_Course_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Save_Test_Course_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e)
			return res.send(e);
		}
	});

	router.post("/Python_Fees_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Python_Fees_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e)
			return res.send(e);
		}
	});

	router.post("/Dm_Fees_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Dm_Fees_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e)
			return res.send(e);
		}
	});

	router.post("/Testing_Fees_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Testing_Fees_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e)
			return res.send(e);
		}
	});
	

	router.post("/Fees_Payment_Whatsapp/", async function (req, res, next) {
		try {
			const resp = await Student.Fees_Payment_Whatsapp(req.body);
			return res.send(resp);
		} catch (e) {
			console.log(e)
			return res.send(e);
		}
	});

	router.get(
		"/Send_Resume_Upload_Notification/:Student_Name_?",
		async (req, res, next) => {
			 //console.log(req, res);
			try {
				
				const result = await Student.Send_Resume_Upload_Notification(
					req.params.Student_Name_,
					
				);
				res.json(result);
			} catch (e) {
				//console.log(e);
				res.send(e);
			} finally {
			}
		}
	);
	router.get("/Reset_Notification_Count/:User_Id_?", function (req, res, next) {
		try {
			Student.Reset_Notification_Count(req.params.User_Id_, function (err, rows) {
				if (err) {
					;
					res.json(err);
				} else {
					res.json(rows);
				}
			});
		} catch (e) {
		} finally {
		}
	});
	
	router.get("/Get_All_Notification/", function (req, res, next) {
		try {
			Student.Get_All_Notification(
				req.query.Date_,
				req.query.User_Id_,
				req.query.login_Id_,
				function (err, rows) {
					if (err) {
						;
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


	router.get("/Get_Individual_Notification/", function (req, res, next) {
		try {
			Student.Get_Individual_Notification(
				req.query.Student_Id_,
				req.query.Notification_Id_,
				req.query.Login_user_Id_,
				function (err, rows) {
					if (err) {
						;
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


	router.get("/Notification_Read_Status/:Notification_Count_?/:User_Id_ ?", function (req, res, next) {
		try {
			Student.Notification_Read_Status(req.params.Notification_Count_,req.params.User_Id_, function (err, rows) {
				if (err) {
					res.json(err);
				} else {
					res.json(rows);
				}
			});
		} catch (e) {
		} finally {
		}
	});

	router.get("/update_Read_Status/", function (req, res, next) {
		try {
			Student.update_Read_Status(
				req.query.login_user_,
				req.query.Notification_Id_,
				function (err, rows) {
					if (err) {
						;
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


	router.post('/Save_Complaint/',function(req,res,next)
{ 
try 
{
	Student.Save_Complaint(req.body, function (err, rows) 
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


router.post("/Get_Complaint/", function (req, res, next) {
	try {
 console.log(req.body)
 Student.Get_Complaint(req.body.Student_Id_, function (err, rows)  {
				if (err) {
					console.log(err);
					res.json(err);
				} else {
					res.json(rows);
				}
			}
		);
	} catch (e) {
		console.log(e);
	} finally {
	}
 });


 router.get("/Get_Login_User_Type/:Login_User?", function (req, res, next) {
	try {
		Student.Get_Login_User_Type(req.params.Login_User, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});


 router.get("/Search_Batch_End_Warning/:Login_User?", function (req, res, next) {
	try {
		Student.Search_Batch_End_Warning(req.params.Login_User, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});



 router.get("/Mark_As_Complete/:Login_User?/:Batch_Id_?/:Status_?", function (req, res, next) {
	try {
		Student.Mark_As_Complete(req.params.Login_User,req.params.Batch_Id_,req.params.Status_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});




router.get("/Change_Status/:Login_User?/:Complaint_Id_?/:Status_?", function (req, res, next) {
	try {
		Student.Change_Status(req.params.Login_User,req.params.Complaint_Id_,req.params.Status_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});



router.post('/Save_Self_Placed/',function(req,res,next)
{ 
try 
{
	Student.Save_Self_Placed(req.body, function (err, rows) 
{
if (err) 
{
	console.log(err)
res.json(err);
}
else 
{
res.json(rows);
}
});
}
catch (e) 
{console.log(e)
}
finally 
{
}
});



router.get("/Get_Self_Placement/:Student_Id_?", function (req, res, next) {
	try {
		Student.Get_Self_Placement(req.params.Student_Id_, function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});


router.get('/Delete_Self_Placement/:Self_Placement_Id_',function(req,res,next)
      { 
      try 
      {
		Student.Delete_Self_Placement(req.params.Self_Placement_Id_, function (err, rows)
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
      ;
      }
      finally 
      {
      }
      });
	


	  router.get("/Search_Employer_Status_Typeahead/", function (req, res, next) {
		try {
			Student.Search_Employer_Status_Typeahead(
				req.query.Employer_Status_Name,
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

	
router.get("/Search_ExamResult_Final/", function (req, res, next) {
	try {
		Student.Search_ExamResult_Final(
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
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


router.get("/Search_LevelScore_Details_Student/", function (req, res, next) {
	try {
		Student.Search_LevelScore_Details_Student(
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
			req.query.Name_,
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
	} finally {
	}
});


router.post("/Save_Exam_Result_Internal/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Exam_Result_Internal(req.body);
		return res.send(resp);
	} catch (e) {
		console.log(e);
		return res.send(e);
	}
});

router.get("/Search_Examdetails_Final/", function (req, res, next) {
	try {
		Student.Search_Examdetails_Final(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
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


router.get("/Search_LevelScore_Master_Student/", function (req, res, next) {
	try {
		Student.Search_LevelScore_Master_Student(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
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


router.get("/Get_ExamresultdetailsFinal/", function (req, res, next) {
	try {
		Student.Get_ExamresultdetailsFinal(
			req.query.Final_Exam_Master_Id_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Faculty_,
			function (err, rows) {
				if (err) {
					console.log(err)
					res.json(err);
				} else {
					res.json(rows);
					console.log(rows);
				}
			}
		);
	} catch (e) {
		console.log(e)
	} finally {
	}
});



router.get("/Get_LevelScore_Student_Details", function (req, res, next) {
    try {
        Student.Get_LevelScore_Student_Details(
            req.query.Level_Score_Master_Id_,
            req.query.Course_,
            req.query.Batch_,
            req.query.Faculty_,
            function (err, rows) {
                if (err) {
                    console.log(err);
                    res.json(err);
                } else {
                    res.json(rows);
                    console.log(rows);
                }
            }
        );
    } catch (e) {
        console.log(e);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});


router.get('/Delete_ExamResultFinal/:Final_Exam_Master_Id_?',function(req,res,next)
{ 
try 
{
 Student.Delete_ExamResultFinal(req.params.Final_Exam_Master_Id_, function (err, rows) 
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


 router.get('/Delete_LevelScore_Student/:Level_Score_Master_Id?',function(req,res,next)
{ 
try 
{
 Student.Delete_LevelScore_Student(req.params.Level_Score_Master_Id, function (err, rows) 
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


 

router.get("/Load_Exam/", function (req, res, next) {
	try {
		Student.Load_Exam(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});


router.get("/Load_ExamType/", function (req, res, next) {
	try {
		Student.Load_ExamType(function (err, rows) {
			if (err) {
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});
router.get('/Load_Markstatus',function(req,res,next)
{ 
try 
{
	Student.Load_Markstatus( function (err, rows)
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
;
}
finally 
{
}
});



router.post('/Save_Exam_Creation/',function(req,res,next)
{ 
try 
{
	Student.Save_Exam_Creation(req.body, function (err, rows) 
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
	console.log(e)
}
finally 
{
}
});
router.get('/Search_Exam_Creation/',function(req,res,next)
{ 
try 
{
	Student.Search_Exam_Creation(req.query.Exam_Creation_Name, function (err, rows) 
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
{console.log(e)
}
finally 
{
}
});
router.get('/Get_Exam_Creation/:Exam_Creation_Id_?',function(req,res,next)
{ 
try 
{
	Student.Get_Exam_Creation(req.params.Exam_Creation_Id_, function (err, rows) 
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
router.get('/Delete_Exam_Creation/:Exam_Creation_Id_?',function(req,res,next)
{ 
try 
{
	Student.Delete_Exam_Creation(req.params.Exam_Creation_Id_, function (err, rows) 
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
	

router.get("/Search_Level_Details_Status/", function (req, res, next) {
	try {
		Student.Search_Level_Details_Status(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_Id_,
			req.query.student_name_,
			req.query.Faculty_Id_,
			req.query.Login_User_,
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




router.post('/Save_Entry_Level_Details/',function(req,res,next)
{ 
try 
{
	Student.Save_Entry_Level_Details(req.body, function (err, rows) 
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
	console.log(e)
}
finally 
{
}
});

router.post('/Save_Mid_Level_Details/',function(req,res,next)
{ 
try 
{
	Student.Save_Mid_Level_Details(req.body, function (err, rows) 
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
	console.log(e)
}
finally 
{
}
});

router.post('/Save_Exit_Level_Details/',function(req,res,next)
{ 
try 
{
	Student.Save_Exit_Level_Details(req.body, function (err, rows) 
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
	console.log(e)
}
finally 
{
}
});

router.post('/Save_Project_Details/',function(req,res,next)
{ 
try 
{
	Student.Save_Project_Details(req.body, function (err, rows) 
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
	console.log(e)
}
finally 
{
}
});

router.get("/Search_Score_Card_Report/", function (req, res, next) {
	try {
		Student.Search_Score_Card_Report(
			req.query.Is_Date_,
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Course_,
			req.query.Batch_Id_,
			req.query.student_name_,
			req.query.Faculty_Id_,
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




router.get("/Search_Batch_Attendance/", function (req, res, next) {
	try {
		Student.Search_Batch_Attendance(
			req.query.From_Date_,
			req.query.To_Date_,
			req.query.Faculty_Id_,
			req.query.Course_,
			req.query.Batch_,
			req.query.Attendance_Status_Id,
			req.query.User_Id_,
			req.query.Is_Date_,
			req.query.Branch_Id_,
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

router.get("/Load_Batch_Attendance_Details/", function (req, res, next) {
	try {
		Student.Load_Batch_Attendance_Details(
			req.query.Student_Id_,
			req.query.Batch_Id_,
			req.query.Course_Id_,
			req.query.Attendance_Status_,
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
		console.log(e)
	} finally {
	}
});


router.get("/Update_Batch_Completion_Status/", function (req, res, next) {
	try {
		console.log(req.query.login_user_)
		Student.Update_Batch_Completion_Status(
			req.query.login_user_,
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





router.post("/Save_Exam_Result_Final/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Exam_Result_Final(req.body);
		return res.send(resp);
	} catch (e) {
		console.log(e);
		return res.send(e);
	}
});

router.post("/Save_Level_Score_Student/", async function (req, res, next) {
	try {
		const resp = await Student.Save_Level_Score_Student(req.body);
		return res.send(resp);
	} catch (e) {
		console.log(e);
		return res.send(e);
	}
});




module.exports = router;
