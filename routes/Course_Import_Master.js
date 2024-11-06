 var express = require('express');
 var router = express.Router();
 var Course_Import_Master=require('../models/Course_Import_Master');
 router.post('/Save_Course_Import_Master/',function(req,res,next)
 { 
 try 
 {
Course_Import_Master.Save_Course_Import_Master(req.body, function (err, rows) 
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
 router.get('/Search_Course_Import_Master/',function(req,res,next)
 { 
 try 
 {
Course_Import_Master.Search_Course_Import_Master(req.query.Course_Import_Master_Name, function (err, rows) 
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
 router.get('/Get_Course_Import_Master/:Course_Import_Master_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Import_Master.Get_Course_Import_Master(req.params.Course_Import_Master_Id_, function (err, rows) 
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
 router.get('/Delete_Course_Import_Master/:Course_Import_Master_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Import_Master.Delete_Course_Import_Master(req.params.Course_Import_Master_Id_, function (err, rows) 
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

