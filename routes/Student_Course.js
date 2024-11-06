 var express = require('express');
 var router = express.Router();
 var Student_Course=require('../models/Student_Course');
 router.post('/Save_Student_Course/',function(req,res,next)
 { 
 try 
 {
Student_Course.Save_Student_Course(req.body, function (err, rows) 
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
 router.get('/Search_Student_Course/',function(req,res,next)
 { 
 try 
 {
Student_Course.Search_Student_Course(req.query.Student_Course_Name, function (err, rows) 
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
 router.get('/Get_Student_Course/:Student_Course_Id_?',function(req,res,next)
 { 
 try 
 {
Student_Course.Get_Student_Course(req.params.Student_Course_Id_, function (err, rows) 
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
 router.get('/Delete_Student_Course/:Student_Course_Id_?',function(req,res,next)
 { 
 try 
 {
Student_Course.Delete_Student_Course(req.params.Student_Course_Id_, function (err, rows) 
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

