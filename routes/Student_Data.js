 var express = require('express');
 var router = express.Router();
 var Student_Data=require('../models/Student_Data');
 
  router.get('/Student_Data_Dropdowns/',function(req,res,next)
  { 
  try 
  {
    Student_Data.Student_Data_Dropdowns(function (err, rows) 
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
    "/Search_Student_Data_Report/:Fromdate_?/:Todate_?/:Search_By_?/:SearchbyName_?/:Enquiry_Source_?/:Branch_?/:By_User_?/:Is_Date_Check_?/:Page_Index1_?/:Page_Index2_?/:Login_User_Id_?/:RowCount?/:RowCount2?/:To_User_?/:Status_Id_?/:Register_Value_?",
    async function (req, res, next) {
      var result = "";
      try {
        result = await Student_Data.Search_Student_Data_Report(
          req.params.Fromdate_,
          req.params.Todate_,
          req.params.Search_By_,
          req.params.SearchbyName_,
          req.params.Enquiry_Source_,
          req.params.Branch_,
          req.params.By_User_,
          req.params.Is_Date_Check_,
          req.params.Page_Index1_,
          req.params.Page_Index2_,
          req.params.Login_User_Id_,
          req.params.RowCount,
          req.params.RowCount2,
          req.params.To_User_,
          req.params.Status_Id_,
          req.params.Register_Value_
        );
  
        res.json(result);
      } catch (e) {
        console.log(e);
      } finally {
      }
    }
  );


  router.post("/Delete_Student_Report/", function (req, res) {
    try {
      Student_Data.Delete_Student_Report(req.body, function (err, rows) {
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

  router.post("/Save_Student_Data_FollowUp/", function (req, res) {
    try {
      Student_Data.Save_Student_Data_FollowUp(req.body, function (err, rows) {
        if (err) {
          res.json(err);
          console.log(err);
        } else {
          res.json(rows);
        }
      });
    } catch (e) {
    } finally {
    }
  });
  
  router.get('/Search_Branch_User_Typeahead/:Branch_Id_?/:User_Details_Name_?',function(req,res,next)
  { 
  try 
  {
    Student_Data.Search_Branch_User_Typeahead(req.params.Branch_Id_,req.params.User_Details_Name_, function (err, rows) 
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


   router.get('/Search_Branch_Typeahead/:Branch_Name_?',function(req,res,next)
   { 
   try 
   {
    Student_Data.Search_Branch_Typeahead(req.params.Branch_Name_, function (err, rows) 
  
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

