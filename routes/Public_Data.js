 var express = require('express');
 var router = express.Router();
 var Public_Data=require('../models/Public_Data');
 const axios = require('axios');
 const upload = require('../helpers/multer-helper');

 router.post('/Save_Student_Course/',async function(req,res,next)
 { 
 try 
 {
 const resp=await Public_Data.Save_Student_Course(req.body);
 return res.send(resp);
 }
 catch(e){
 return res.send(e);
 }
 });

  router.get('/Get_site_Pageload/',function(req,res,next)
  { 
  try 
  {
  Public_Data.Get_site_Pageload( function (err, rows) 
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


  router.get('/Public_Search_Course/',function(req,res,next)
  { 
  try 
  {
  Public_Data.Public_Search_Course(req.query.Level_Detail_Id,req.query.Country_Id,req.query.Intake_Id, req.query.Course_Name,req.query.Branch_Search,
  req.query.Duration_Search,req.query.Ielts_,req.query.Page_Start,req.query.Page_End,req.query.Page_Length, function (err, rows) 
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

  router.get('/Public_Search_Course_Typeahead/',function(req,res,next)
  { 
  try 
  {
  Public_Data.Public_Search_Course_Typeahead(req.query.Level_Detail_Id,req.query.Country_Id,req.query.Intake_Id, req.query.Course_Name,req.query.Branch_Search,
  req.query.Duration_Search,req.query.Ielts_,req.query.Page_Start,req.query.Page_End,req.query.Page_Length, function (err, rows) 
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

  router.get('/Get_More_Information/:Course_Id_?',function(req,res,next)
  { 
  try 
  {
  Public_Data.Get_More_Information(req.params.Course_Id_, function (err, rows) 
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


  
router.post('/Update_Student_Public/',function(req,res,next)
  { 
  try 
  {
    Public_Data.Update_Student_Public(req.body, function (err, rows) 
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


  // router.get('/Get_Student_Details/:Student_Id_?',function(req,res,next)
  // { 
  // try 
  // {
  // Public_Data.Get_Student_Details(req.params.Student_Id_, function (err, rows) 
  // {
  // if (err) 
  // {
  
  // res.json(err);
  // }
  // else 
  // {
  //
  // res.json(rows);
  // }
  // });
  // }
  // catch (e) 
  // {
  // 
  // }
  // finally 
  // {
  // }
  // });

  // router.get('/Get_Student_Course_Apply/:Student_Id_?',function(req,res,next)
  // { 
  // try 
  // {
  // Public_Data.Get_Student_Course_Apply(req.params.Student_Id_, function (err, rows) 
  // {
  // if (err) 
  // {
  // res.json(err);
  // }
  // else 
  // {
  // res.json(rows);
  // }
  // });
  // }
  // catch (e) 
  // {
  // }
  // finally 
  // {
  // }
  // // });
  // router.get('/Get_Message_Details/:Student_Id_?',function(req,res,next)
  // { 
  // try 
  // {
  // Public_Data.Get_Message_Details(req.params.Student_Id_, function (err, rows) 
  // {
  // if (err) 
  // {
  // res.json(err);
  // }
  // else 
  // {
  // res.json(rows);
  // }
  // });
  // }
  // catch (e) 
  // {
  // }
  // finally 
  // {
  // }
  // });
  // router.get('/Get_Student_Course_Selection/:Student_Course_Apply_Id_?',function(req,res,next)
  // { 
  // try 
  // {
  // Public_Data.Get_Student_Course_Selection(req.params.Student_Course_Apply_Id_, function (err, rows) 
  // {
  // if (err) 
  // {
  // res.json(err);
  // }
  // else 
  // {
  // res.json(rows);
  // }
  // });
  // }
  // catch (e) 
  // {
  // }
  // finally 
  // {
  // }
  // });


  router.post('/Forgot_Password_Student/',async function(req,res,next)
  { 
  try 
  {
  
  const resp=await Public_Data.Forgot_Password_Student(req.body);
  
  return res.send(resp);
  }
  catch(e){
  
  return res.send(e);
  }
  });

  router.post('/Forgot_Password_Candidate/',async function(req,res,next)
  { 
  try 
  {
  
  const resp=await Public_Data.Forgot_Password_Candidate(req.body);
  
  return res.send(resp);
  }
  catch(e){
  
  return res.send(e);
  }
  });


  router.post('/Forgot_Password_Agent/',async function(req,res,next)
  { 
  try 
  {
  
  const resp=await Public_Data.Forgot_Password_Agent(req.body);
  
  return res.send(resp);
  }
  catch(e){
  
  return res.send(e);
  }
  });





  // router.get('/Get_Student_Document/:Student_Id_?',function(req,res,next)
  // { 
  // try 
  // {
  // Public_Data.Get_Student_Document(req.params.Student_Id_, function (err, rows) 
  // {
  // if (err) 
  // {
  
  // res.json(err);
  // }
  // else 
  // {
  //
  // res.json(rows);
  // }
  // });
  // }
  // catch (e) 
  // {
  // 
  // }
  // finally 
  // {
  // }
  // });


  // router.get('/Search_Document/',function(req,res,next)
  // { 
  // try 
  // {
  // Public_Data.Search_Document(req.query.Document_Name, function (err, rows) 
  // {
  // if (err) 
  // {
  // res.json(err);
  // }
  // else 
  // {
  // res.json(rows);
  // }
  // });
  // }
  // catch (e) 
  // {
  // }
  // finally 
  // {
  // }
  // });




  // router.post('/Save_Student_Document', upload.array('myFile'), (req, res, next) => 
  // {
 
  //   try
  //   {
  //     const file = req.files
  //     var Photo_ = [];
  //     if (!file) 
  //     {
  //     }
  //     else
  //     {
  //       for (var i = 0; i < file.length; i++) 
  //       {
  //         Photo_.push({ File_name: file[i].filename })
  //       }
  //       //Photo_ = file[0].filename;
  //     }
    
  //       var Image_Detail="";
  //       if (Photo_.length>0)
  //         {
  //           Image_Detail=Photo_[0].File_name;
  //         }
  //       var Photo_json = JSON.stringify(Photo_)
  
  //       var Post_ =
  //       {
  //         "Student_Id": req.body.Student_Id,
  //         "Document_Id": req.body.Document_Id,
  //         "Image_Detail": Image_Detail

  
  //       };
  //       Public_Data.Save_Student_Document(Post_, function (err, rows) 
  //         {
  
  //         if (err) 
  //         {
  //           return 1;
  //         }
  //         else
  //         {
  //           // cb(null, FileUploaded.toString(10));
  //           return res.json(rows);
  //         }
  //       });
      
  //   }
  
  //   catch (err) 
  //   {
  //     const error = new Error('Please upload a file')
  //     error.httpStatusCode = 400
  //     return next(error)
  //   }
  //     finally 
  //     {
  //     }
  //   }
  // );
  

//   router.get('/ Search_Student_Agent/',function(req,res,next)
//   { 
//   try 
//   {
//     
//   Public_Data. Search_Student_Agent(req.query.From_Date_,req.query.To_Date_,req.query.Is_Date_Check_,req.query.Student_Name_,req.query.Phone_Number_,
//     req.query.Agent_Id_,req.query.Student_Status_Id_,req.query.Pointer_Start_,req.query.Pointer_Stop_,req.query.Page_Length_, function (err, rows) 
//   {
//   if (err) 
//   {
//   res.json(err);
//  
//   }
//   else 
//   {
//    
//     res.json(rows);
//   }
//   });
//   }
//   catch (e) 
//   {
//     
//   }
//   finally 
//   {
//   }
// });


router.get('/Public_Search_Job/',function(req,res,next)
{ 
try 
{
  console.log(1)
  Public_Data.Public_Search_Job(req.query.Job_Title_,req.query.Qualification_,req.query.Experience_,req.query.Functional_Area_,req.query.Specialization_,function (err, rows) 
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

router.post('/Save_Candidate_Public/',function(req,res,next)
{ 
try 
{
  Public_Data.Save_Candidate_Public(req.body, function (err, rows) 
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
    Public_Data.Load_Candidate_Dropdowns( function (err, rows)
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

  // router.get('/Update_Password_Mobile/:Student_Id_?/:Password_?',function(req,res,next)
  // { 
  // try 
  // {
  //   Public_Data.Update_Password_Mobile(req.params.Student_Id_,req.params.Password_, function (err, rows) 
  // {
  //  if (err) 
  //  {
  //  res.json(err);
  //  }
  //  else 
  //  {
	//  res.json(rows);
  //  }
  //  });
  //  }
  // catch (e) 
  // {
  // }
  // finally 
  // {
  // }
  //  });

  
  router.get("/Update_Password_Mobile/:Student_Id_?/:Password_?",async (req, res, next) =>
    {
          try
          {
           
          const result = await Public_Data.Update_Password_Mobile(req.params.Student_Id_,req.params.Password_);
           console.log('result', result);
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


//    router.get("/Get_OTP/:Phone_?",async (req, res, next) =>
// {
//       try
//       {
//         var OTP=Math.floor(Math.random()*Math.floor(10000))
//       const result = await Public_Data.Get_OTP(req.params.Phone_,OTP);
//        console.log('result', result);
//       res.json(result);
//       } 
//       catch (e) 
//       {
//        console.log(e)
//       res.send(e);
//       } 
//       finally 
//       {
//       }
//       });


router.get("/Get_OTP/:Phone_?", async (req, res, next) => {
  try {
    var OTP = Math.floor(Math.random() * Math.floor(10000));
    const result = await Public_Data.Get_OTP(req.params.Phone_, OTP);
    console.log('result', result);
    res.json(result);
  } catch (e) {
    console.log(e);
    res.status(500).send(e);
  }
});

      router.get("/Check_OTP/", function (req, res, next) {
        try {
          Public_Data.Check_OTP(
            req.query.OTP,
            req.query.Student_Id_,
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
          console.log(e);
        } finally {
        }
      });

      // router.post("/Save_Job_Posting/", async function (req, res, next) {
      //   try {
      //     const resp = await Public_Data.Save_Job_Posting(req.body);
      //     return res.send(resp);
      //   } catch (e) {
      //     console.log(e);
      //     return res.send(e);
      //   }
      // });
    
      



  module.exports = router;

