 var express = require('express');
 var router = express.Router();
 var Student_Course_Subject=require('../models/Student_Course_Subject');
 router.post('/Save_Student_Course_Subject/',function(req,res,next)
 { 
 try 
 {
Student_Course_Subject.Save_Student_Course_Subject(req.body, function (err, rows) 
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
 router.get('/Search_Student_Course_Subject/',function(req,res,next)
 { 
 try 
 {
Student_Course_Subject.Search_Student_Course_Subject(req.query.Student_Course_Subject_Name, function (err, rows) 
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
 router.get('/Get_Student_Course_Subject/:Student_Course_Subject_Id_?',function(req,res,next)
 { 
 try 
 {
Student_Course_Subject.Get_Student_Course_Subject(req.params.Student_Course_Subject_Id_, function (err, rows) 
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
 router.get('/Delete_Student_Course_Subject/:Student_Course_Subject_Id_?',function(req,res,next)
 { 
 try 
 {
Student_Course_Subject.Delete_Student_Course_Subject(req.params.Student_Course_Subject_Id_, function (err, rows) 
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

