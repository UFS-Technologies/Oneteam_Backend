 var express = require('express');
 var router = express.Router();
 var Exam_Master=require('../models/Exam_Master');
 router.post('/Save_Exam_Master/',function(req,res,next)
 { 
 try 
 {
Exam_Master.Save_Exam_Master(req.body, function (err, rows) 
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
 router.get('/Search_Exam_Master/',function(req,res,next)
 { 
 try 
 {
Exam_Master.Search_Exam_Master(req.query.Exam_Master_Name, function (err, rows) 
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
 router.get('/Get_Exam_Master/:Exam_Master_Id_?',function(req,res,next)
 { 
 try 
 {
Exam_Master.Get_Exam_Master(req.params.Exam_Master_Id_, function (err, rows) 
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
 router.get('/Delete_Exam_Master/:Exam_Master_Id_?',function(req,res,next)
 { 
 try 
 {
Exam_Master.Delete_Exam_Master(req.params.Exam_Master_Id_, function (err, rows) 
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

