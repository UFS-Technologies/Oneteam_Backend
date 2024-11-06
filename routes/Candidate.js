var express = require('express');
var router = express.Router();
var Candidate = require('../models/Candidate');
const upload = require('../helpers/multer-helper');
// router.post('/Save_Candidate', upload.array('myFile'), (req, res, next) =>
// {
//   try
//   {
//     const file = req.files
//     var Photo_ = [];
//     var tempFile_Nmae='';  
//     var ImageFile_Photo;  
//     var ImageFile_Resume;
//     if (!file) 
//     {
//     }
//     else
//     {
//       for (var i = 0; i < req.body.Document_File_Array; i++) 
//       {
//         if(i==req.body.ImageFile_Photo)
//         ImageFile_Photo=file[i].filename
//         else if(i==req.body.ImageFile_Resume)
//         ImageFile_Resume=file[i].filename        
//       }
//     }
//     // var Photo_json = JSON.stringify(Photo_)
//       var Candidate1
//     if (req.body.Candidate_Name != "" && req.body.Candidate_Name != undefined && req.body.Candidate_Name!=null)
//     {
//        Candidate1 =
//       {
//         "Candidate_Id": req.body.Candidate_Id_Candidate,
//         "Candidate_Name":req.body.Candidate_Name,
//         "Address1":req.body.Address1,
//         "Address2":req.body.Address2,
//         "Address3":req.body.Address3,
//         "Address4": req.body.Address4,
//         "Pincode":req.body.Pincode,
//         "Phone":req.body.Phone,
//         "Mobile": req.body.Mobile,
//         "Whatsapp":req.body.Whatsapp,
//         "DOB": req.body.DOB,
//         "Gender": req.body.Gender,
//         "Email": req.body.Email,
//         "Alternative_Email":req.body.Alternative_Email,
//         "Passport_No": req.body.Passport_No,
//         "Passport_Expiry": req.body.Passport_Expiry,
//         "User_Name": req.body.User_Name,
//         "Password": req.body.Password,
//         "Photo": ImageFile_Photo,
//         "User_Id": req.body.User_Id,
//         "Functional_Area_Id": req.body.Functional_Area_Id,
//         "Functional_Area_Name": req.body.Functional_Area_Name,
//         "Specialization_Id":  req.body.Specialization_Id,
//         "Specialization_Name": req.body.Specialization_Name,
//         "Experience_Id": req.body.Experience_Id,
//         "Experience_Name": req.body.Experience_Name,
//         "Qualification_Id": req.body.Qualification_Id,
//         "Qualification_Name": req.body.Qualification_Name,
//         "Resume": ImageFile_Resume,
//         "Postlookingfor": req.body.Postlookingfor
//       };
     
//     }
//     var jsondata1 = JSON.stringify(Candidate1)
//     var Followup ;
//     if (req.body.Status != "" && req.body.Status != undefined && req.body.Status != null) {
//     var Followup=
//     {
//       "Candidate_Id": req.body.Candidate_Id,
//       "Entry_Date": req.body.Entry_Date,
//       "Next_FollowUp_Date": req.body.Next_FollowUp_Date,
//       "FollowUp_Difference": req.body.FollowUp_Difference,
//       "Status": req.body.Status,
//       "By_User_Id": req.body.By_User_Id,
//       "Remark": req.body.Remark,
//       "Remark_Id": req.body.Remark_Id,
//       "FollowUp_Type": req.body.FollowUp_Type,
//       "FollowUP_Time": req.body.FollowUP_Time,
//       "Actual_FollowUp_Date": req.body.Actual_FollowUp_Date,
//       "Entry_Type": req.body.Entry_Type,
//       "To_User_Id": req.body.To_User_Id,
//     }
//    }
//     var jsondata2 = JSON.stringify(Followup)

//     var Candidate_Data=
//     {
//       "Candidate": jsondata1,
//       "Followup": jsondata2,

//     };
//     Candidate.Save_Candidate(Candidate_Data, function (err, rows)
//         {
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

router.post('/Public_Save_Candidate_Front', upload.array('myFile'), (req, res, next) =>
{
  try
  {
     const file = req.files
    var Photo_ = [];
    var ImageFile_Photo;  
   var ImageFile_Resume;
    if (!file) {

     // const error = new Error('Please upload a file')
      //error.httpStatusCode = 400
    }
    // else {
    //   for (var i = 0; i < file.length; i++) 
    //   {
    //     Photo_.push({ File_name: file[i].filename })
    //     ImageFile_Photo = Photo_[0].File_name;
    //   }
     
    // }
    else
        {
          for (var i = 0; i <file.length; i++) 
          {
            if(i==req.body.Photo)
            ImageFile_Photo=file[i].filename
            else if(i==req.body.Resume)
            ImageFile_Resume=file[i].filename        
          }
        }
    var Photo_json = JSON.stringify(Photo_)
       var Candidate_1;
    // if (req.body.Student_Name != "" && req.body.Student_Name != undefined && req.body.Student_Name!=null)
    // {
      Candidate_1 =
      {
        "Candidate_Id": req.body.Candidate_Id,
        "Candidate_Name":req.body.Candidate_Name,
        "Address1":req.body.Address1,
        "Address2":req.body.Address2,
        "Address3":req.body.Address3,
        "Address4": req.body.Address4,
        "Pincode":req.body.Pincode,
        "Phone":req.body.Phone,
        "Mobile": req.body.Mobile,
        "Whatsapp":req.body.Whatsapp,
        "DOB": req.body.DOB,
        "Gender": req.body.Gender,
       "Email": req.body.Email,
        "Alternative_Email":req.body.Alternative_Email,
         "Passport_No": req.body.Passport_No,
         "Passport_Expiry": req.body.Passport_Expiry,
         "User_Name": req.body.User_Name,
         "Password": req.body.Password,
         "Photo": ImageFile_Photo,
         "User_Id": req.body.User_Id,
        "Functional_Area_Id": req.body.Functional_Area_Id,
        "Functional_Area_Name": req.body.Functional_Area_Name,
        "Specialization_Id":  req.body.Specialization_Id,
        "Specialization_Name": req.body.Specialization_Name,
        "Experience_Id": req.body.Experience_Id,
        "Experience_Name": req.body.Experience_Name,
        "Qualification_Id": req.body.Qualification_Id,
        "Qualification_Name": req.body.Qualification_Name,
         "Resume": ImageFile_Resume,
        "Postlookingfor": req.body.Postlookingfor,
      };
     
    // }
    // console.log(Candidate_1);
   var Candidate_=JSON.stringify(Candidate_1);
    
   Candidate.Public_Save_Candidate_Front(Candidate_, function (err, rows)
        {

        if (err) 
        {
          return 1;
          
        }
        else
        {
          return res.json(rows);
        
        }
      });
    
  }

  catch (err) 
  {
    const error = new Error('Please upload a file')
    error.httpStatusCode = 400
    return next(error)
  }
    finally 
    {
    }
  }
);
router.get('/Search_Candidate', async function (req, res, next) {
  var result = '';
  try {
    result = await Candidate.Search_Candidate(req.query.From_Date_,req.query.To_Date_,req.query.SearchbyName_,req.query.By_User_,
      req.query.Status_Id_, req.query.Is_Date_Check_,req.query.Page_Index1_, req.query.Page_Index2_, req.query.Login_User_Id_, 
      req.query.RowCount, req.query.RowCount2, req.query.Register_Value);

    res.json(result);
  }
  catch (e) {

  }
  finally {

  }
});
router.get('/Get_Candidate/:Candidate_Id_?',function(req,res,next)
  { 
  try 
  {
  Candidate.Get_Candidate(req.params.Candidate_Id_, function (err, rows) 
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
  router.get('/Get_Last_Candidate_FollowUp/:Users_Id_?',function(req,res,next)
    { 
    try 
    {
    Candidate.Get_Last_Candidate_FollowUp(req.params.Users_Id_, function (err, rows) 
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
router.get('/Delete_Candidate/:Candidate_Id_?',function(req,res,next)
  { 
  try 
  {
  Candidate.Delete_Candidate(req.params.Candidate_Id_, function (err, rows) 
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
router.get('/Load_Candidate_Dropdowns/',function(req,res,next)
  { 
  try 
  {
    Candidate.Load_Candidate_Dropdowns( function (err, rows)
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
router.get("/Get_Candidate_FollowUp_Details/:Candidate_Id_?",async (req, res, next) =>{
    try
    {
    const result = await Candidate.Get_Candidate_FollowUp_Details(req.params.Candidate_Id_);
    res.json(result);
    }
    catch (e)
    {
    res.send(e);
    } 
    finally 
    {
    }
    });
router.get("/Get_Candidate_FollowUp_History/:Candidate_Id_?",async (req, res, next) =>{
    try
    {
    const result = await Candidate.Get_Candidate_FollowUp_History(req.params.Candidate_Id_);
    res.json(result);
    }
    catch (e)
    {
    res.send(e);
    } 
    finally 
    {
    }
    });
router.get('/Register_Candidate/:Candidate_Id_?/:User_Id_?',function(req,res,next)
  { 
  try 
  {
    Candidate.Register_Candidate(req.params.Candidate_Id_, req.params.User_Id_, function (err, rows)
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
router.get('/Remove_Registration_Candidate/:Candidate_Id_?',function(req,res,next)
  { 
  try 
  {
    Candidate.Remove_Registration_Candidate(req.params.Candidate_Id_, function (err, rows)
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
router.get('/Search_Applied_Candidate', async function (req, res, next) {
  var result = '';
  try {
    result = await Candidate.Search_Applied_Candidate(req.query.From_Date,req.query.To_Date,req.query.Candidate_Search);
    res.json(result);
  }
  catch (e) {

  }
  finally {
  }
});
router.post('/Save_Applied_Candidate/',function(req,res,next)
{ 
try 
{
  Candidate.Save_Applied_Candidate(req.body, function (err, rows) 
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

router.get('/Get_Candidate_Details/:Candidate_Id_?',function(req,res,next)
{ 
try 
{
  Candidate.Get_Candidate_Details(req.params.Candidate_Id_, function (err, rows) 
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
router.post('/Save_Candidate_JobApply_Public/',function(req,res,next)
{ 
try 
{
  Candidate.Save_Candidate_JobApply_Public(req.body, function (err, rows) 
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
router.get('/Get_Candidate_Job_Apply/:Candidate_Id_?',function(req,res,next)
{ 
try 
{
  Candidate.Get_Candidate_Job_Apply(req.params.Candidate_Id_, function (err, rows) 
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

router.post('/Candidate_JobApply_Public_Check/',function(req,res,next)
{ 
try 
{
  Candidate.Candidate_JobApply_Public_Check(req.body, function (err, rows) 
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
module.exports = router;

