var express = require('express');
var router = express.Router();
var Agent=require('../models/Agent');
router.post('/Save_Agent/',function(req,res,next)
  { 
  try 
  {
  Agent.Save_Agent(req.body, function (err, rows) 
  {
  if (err) 
  {
  res.json(err);
  
  }
  else 
  {
  res.json(rows);
  console.log(rows);
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


// router.post('/Save_Agent/',upload.array('myFile'), (req, res, next) =>
//  { 
//  try 
//  {
//   const file = req.files
//   console.log(file.length)
//   var Photo_ = [];
//   if (!file)
//   {

//   }
//   else
//   {
//     for (var i = 0; i < file.length; i++)
//     {
//       Photo_.push({  File_name: file[i].filename })
//     }
//   }

//   var Logo="";
//   if (Photo_.length>0)
//   {
//     Logo=Photo_[0].File_name;
//   }

//   var Photo_json = JSON.stringify(Photo_)
//   var Agent_ = 
//   {
//     "Agent_Id": req.body.Agent_Id,
//     "Agent_Name": req.body.Agent_Name,
//     "Center_Code": req.body.Center_Code,
//     "Center_Name": req.body.Center_Name,
//     "Comm_Address1": req.body.Comm_Address1,
//     "Address1": req.body.Address1,
//     "Comm_Address2": req.body.Comm_Address2,
//     "Address2": req.body.Address2,
//     "Comm_Address3": req.body.Comm_Address3,
//     "Address3": req.body.Address3,
//     "Comm_Address4": req.body.Comm_Address4,
//     "Address4": req.body.Address4,
//     "Comm_Pincode": req.body.Comm_Pincode,
//     "Comm_Address1": req.body.Comm_Address1,
//     "Approval_Status": req.body.Approval_Status,
//     "Mobile": req.body.Mobile,
//     "Reg_No": req.body.Reg_No,
//     "Email": req.body.Email,
//     "Approval_date": req.body.Approval_date,
//     "Category_Id": req.body.Category_Id,
//     "Agent_Fees": req.body.Agent_Fees,
//     "Commission": req.body.Commission,
//     "Photo": Photo
//   };
//   //console.log(Company_)
//   Agent.Save_Company(Agent_, function(err, rows)
//   {
//     if (err)
//     {
//       return 1;
//     }
//     else
//     {
//       return res.json(rows);
//     }
//   });

// }
//  catch (err) 
//  {
//    const error = new Error('Please upload a file')
//    error.httpStatusCode = 400
//    return next(error)
//  }
//  finally 
//  {

//  }
//   });


router.get('/Search_Agent/',function(req,res,next)
  { 
  try 
  {
  Agent.Search_Agent(req.query.Agent_Name, function (err, rows) 
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
  router.get('/Get_Agent/:Agent_Id_?',function(req,res,next)
  { 
  try 
  {
  Agent.Get_Agent(req.params.Agent_Id_, function (err, rows) 
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
router.get('/Delete_Agent/:Agent_Id_?',function(req,res,next)
  { 
  try 
  {
  Agent.Delete_Agent(req.params.Agent_Id_, function (err, rows) 
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
router.get("/Load_Agent_Dropdowns",async (req, res, next) =>
  {
  try
  {
  const result = await Agent.Load_Agent_Dropdowns();
  res.json(result);
  console.log(result);
  } 
  catch (e) 
  {
  
  res.send(e);
  } 
  finally 
  {
  }
  });
router.get('/Load_Category_Commission/:Category_Id_?',function(req,res,next)
  { 
  try 
  {
  Agent.Load_Category_Commission(req.params.Category_Id_, function (err, rows) 
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
router.get('/Save_Agent_Registration/:Agent_Id_?',function(req,res,next)
  { 
  try 
  {
  Agent.Save_Agent_Registration(req.params.Agent_Id_, function (err, rows) 
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
router.get('/Delete_Agent/:Agent_Id_?',function(req,res,next)
  { 
  try 
  {
  Agent.Delete_Agent(req.params.Agent_Id_, function (err, rows) 
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
router.get('/Remove_Registration/:Agent_Id_?',function(req,res,next)
  { 
  try 
  {
  Agent.Remove_Registration(req.params.Agent_Id_, function (err, rows) 
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
router.get('/Get_Menu_Status/:Menu_Id_?/:Login_User_?',function(req,res,next)
  { 
  try 
  {
  Agent.Get_Menu_Status(req.params.Menu_Id_,req.params.Login_User_, function (err, rows)
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
router.get('/Load_Mode',function(req,res,next)
  { 
  try 
  {
  Agent.Load_Mode( function (err, rows)
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
router.get('/Accounts_Typeahead',function(req,res,next)
  { 
  try 
  {
  Agent.Accounts_Typeahead(req.query.Account_Group_Id_,req.query.Client_Accounts_Name_, function (err, rows)
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
router.post('/Save_Receipt_Voucher/',function(req,res,next)
  { 
  try 
  {
    Agent.Save_Receipt_Voucher(req.body, function (err, rows) 
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
  router.get('/Get_Receipt_History/:Agent_Id_',function(req,res,next)
    { 
    try 
    {
    Agent.Get_Receipt_History(req.params.Agent_Id_, function (err, rows)
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
    router.get('/Delete_Receipt_Voucher/:Receipt_Voucher_Id_',function(req,res,next)
      { 
      try 
      {
      Agent.Delete_Receipt_Voucher(req.params.Receipt_Voucher_Id_, function (err, rows)
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

      router.get('/Get_Agentdetails_print/:User_Id_?',function(req,res,next)
      { 
      try 
      {
      Agent.Get_Agentdetails_print(req.params.User_Id_, function (err, rows) 
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
module.exports = router;

