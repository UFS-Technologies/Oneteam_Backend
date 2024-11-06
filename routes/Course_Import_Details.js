 var express = require('express');
 var router = express.Router();
 var Course_Import_Details=require('../models/Course_Import_Details');
 router.post('/Save_Course_Import_Details/',function(req,res,next)
 { 
 try 
 {
Course_Import_Details.Save_Course_Import_Details(req.body, function (err, rows) 
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
 router.get('/Search_Course_Import_Details/',function(req,res,next)
 { 
 try 
 {
Course_Import_Details.Search_Course_Import_Details(req.query.Course_Import_Details_Name, function (err, rows) 
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
 router.get('/Get_Course_Import_Details/:Course_Import_Details_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Import_Details.Get_Course_Import_Details(req.params.Course_Import_Details_Id_, function (err, rows) 
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
 router.get('/Delete_Course_Import_Details/:Course_Import_Details_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Import_Details.Delete_Course_Import_Details(req.params.Course_Import_Details_Id_, function (err, rows) 
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

