var express = require('express');
var router = express.Router();
var Employer_Details=require('../models/Employer_Details');
const upload = require('../helpers/multer-helper');

router.post('/Save_Employer_Details/',async function(req,res,next)
{ 
try 
{
const resp=await Employer_Details.Save_Employer_Details(req.body);
return res.send(resp);
}
catch(e){
return res.send(e);
}
});

// router.post('/Save_Company/',async function(req,res,next)
// { 
// try 
// {
// const resp=await Employer_Details.Save_Company(req.body);
// return res.send(resp);
// }
// catch(e){
// return res.send(e);
// }
// });


router.post('/Save_Company/',upload.array('myFile'), (req, res, next) =>
 { 
 try 
 {
  const file = req.files
  var Photo_ = [];
  if (!file)
  {

  }
  else
  {
    for (var i = 0; i < file.length; i++)
    {
      Photo_.push({  File_name: file[i].filename })
    }
  }

  var Logo="";
  if (Photo_.length>0)
  {
    Logo=Photo_[0].File_name;
  }

  var Photo_json = JSON.stringify(Photo_)
  var Company_ = 
  {
    "Company_Id": req.body.Company_Id,
    "companyname": req.body.Company_Name,
    "Phone1": req.body.Phone,
    //"Phone2": req.body.Phone2,
    //"Mobile": req.body.Mobile,
    "Email": req.body.Email_Id,
    "Website": req.body.Website,
    "Address1": req.body.Address1,
    "Address2": req.body.Address2,
    "Address3": req.body.Address3,
    "Logo": Logo
  };
  Employer_Details.Save_Company(Company_, function(err, rows)
  {
    if (err)
    {
        console.log(err)
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
  });



router.get('/Search_Employer_Details', async function (req, res, next) {
var result = '';

try {
result = await Employer_Details.Search_Employer_Details(req.query.Company_Name, function (err, rows) 
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

res.json(result);
}
catch (e) {
    
}
finally {

}
});
router.get('/Search_Employer_Details_Typeahead/:Company_Name?',function(req,res,next)
{ 
try 
{
    Employer_Details.Search_Employer_Details_Typeahead(req.params.Company_Name, function (err, rows) 
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

router.get('/Search_Employer_Details_Role/:Employer_Details_Role_Name_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Search_Employer_Details_Role(req.params.Employer_Details_Role_Name_, function (err, rows) 
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
router.get('/Get_Employer_Details/:Employer_Details_Id_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Get_Employer_Details(req.params.Employer_Details_Id_, function (err, rows) 
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
router.get('/Delete_Employer_Details/:Employer_Details_Id_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Delete_Employer_Details(req.params.Employer_Details_Id_, function (err, rows) 
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
router.get('/Get_Menu_Permission/:Employer_Details_Id_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Get_Menu_Permission(req.params.Employer_Details_Id_, function (err, rows) 
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
router.get('/Get_Menu_Status/:Menu_Id_?/:Employer_Details_Id_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Get_Menu_Status(req.params.Menu_Id_,req.params.Employer_Details_Id_, function (err, rows)
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
router.get('/Employer_Details_Employee/:Employer_Details_Id_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Employer_Details_Employee(req.params.Employer_Details_Id_, function (err, rows) 
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
router.get("/Get_Employer_Detailss_Edit/:Employer_Details_Id_?",async (req, res, next) =>
{
try 
{   
const result = await Employer_Details.Get_Employer_Details_Edit(req.params.Employer_Details_Id_);
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
router.get("/Get_Employer_Details_Load_Data",async (req, res, next) =>
{
try
{
const result = await Employer_Details.Get_Employer_Details_Load_Data();
res.json(result);
} 
catch (e) 
{
//
res.send(e);
} 
finally 
{
}
});



router.post('/Save_Job_Opening/',function(req,res,next)
{ 
try 
{
  Employer_Details.Save_Job_Opening(req.body, function (err, rows) 
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




router.post('/Save_Job_Opening_Followup/',function(req,res,next)
{ 
try 
{
  Employer_Details.Save_Job_Opening_Followup(req.body, function (err, rows) 
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


router.get("/Search_Job_Opening/", function (req, res, next) {
  try {

  
    Employer_Details.Search_Job_Opening(
      req.query.Is_Date_,
      req.query.Fromdate_,
      req.query.Todate_,
      req.query.Job_id_,
      req.query.Company_id_,
      req.query.Employee_Status_Id_,
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


router.get('/Get_Job_Opening_Followup_History/:Job_Opening_Id_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Get_Job_Opening_Followup_History(req.params.Job_Opening_Id_, function (err, rows) 
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

router.get('/Job_Post_Exist_Check/:Job_Opening_Id_?',function(req,res,next)
{ 
try 
{
    Employer_Details.Job_Post_Exist_Check(req.params.Job_Opening_Id_, function (err, rows) 
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

router.get('/Delete_Job_Opening/:Job_Opening_Id_?',function(req,res,next)
  { 
  try 
  {
    Employer_Details.Delete_Job_Opening(req.params.Job_Opening_Id_, function (err, rows) 
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


  router.get(
    "/Job_Opening_Pending_Followups_Summary/:By_User_?/:Login_User_?",
    async function (req, res, next) {
      
      var result = "";
      try {
        result = await Student.Job_Opening_Pending_Followups_Summary(
          req.params.By_User_,
          req.params.Login_User_
        );
      
  
        res.json(result);
      } catch (e) {
      
      } finally {
      }
    }
  );
  // router.get(
  //   "/Job_Opening_Pending_Followups_Report/:By_User_?/:Login_User_?",
  //   async function (req, res, next) {
  //     var result = "";
  //     try {
  //       result = await Student.Job_Opening_Pending_Followups_Report(
  //         req.params.By_User_,
  //         req.params.Login_User_
  //       );
  //       res.json(result);
  //     } catch (e) {
  //     } finally {
  //     }
  //   }
  // );



  router.get("/Job_Opening_Pending_Followups_Report/", function (req, res, next) {
    try {
  
    
      Employer_Details.Job_Opening_Pending_Followups_Report(
        req.query.Is_Date_,
        req.query.Fromdate_,
        req.query.Todate_,
        req.query.Job_id_,
        req.query.Team_Member_Selection_,
        req.query.Employee_Status_Id_,
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

  

module.exports = router;

