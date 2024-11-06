 var express = require('express');
 var router = express.Router();
 var Exam_Details=require('../models/Exam_Details');
 router.post('/Save_Exam_Details/',function(req,res,next)
 { 
 try 
 {
Exam_Details.Save_Exam_Details(req.body, function (err, rows) 
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
 router.get('/Search_Exam_Details/',function(req,res,next)
 { 
 try 
 {
Exam_Details.Search_Exam_Details(req.query.Exam_Details_Name, function (err, rows) 
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
 router.get('/Get_Exam_Details/:Exam_Details_Id_?',function(req,res,next)
 { 
 try 
 {
Exam_Details.Get_Exam_Details(req.params.Exam_Details_Id_, function (err, rows) 
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
 router.get('/Delete_Exam_Details/:Exam_Details_Id_?',function(req,res,next)
 { 
 try 
 {
Exam_Details.Delete_Exam_Details(req.params.Exam_Details_Id_, function (err, rows) 
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

