 var express = require('express');
 var router = express.Router();
 var Student_Followup=require('../models/Student_Followup');
 router.post('/Save_Student_Followup/',function(req,res,next)
 { 
 try 
 {
Student_Followup.Save_Student_Followup(req.body, function (err, rows) 
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
 router.get('/Search_Student_Followup/',function(req,res,next)
 { 
 try 
 {
Student_Followup.Search_Student_Followup(req.query.Student_Followup_Name, function (err, rows) 
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
 router.get('/Get_Student_Followup/:Student_Followup_Id_?',function(req,res,next)
 { 
 try 
 {
Student_Followup.Get_Student_Followup(req.params.Student_Followup_Id_, function (err, rows) 
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
 router.get('/Delete_Student_Followup/:Student_Followup_Id_?',function(req,res,next)
 { 
 try 
 {
Student_Followup.Delete_Student_Followup(req.params.Student_Followup_Id_, function (err, rows) 
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

