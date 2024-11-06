 var express = require('express');
 var router = express.Router();
 var Course_Subject=require('../models/Course_Subject');
 router.post('/Save_Course_Subject/',function(req,res,next)
 { 
 try 
 {
Course_Subject.Save_Course_Subject(req.body, function (err, rows) 
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
 router.get('/Search_Course_Subject/',function(req,res,next)
 { 
 try 
 {
Course_Subject.Search_Course_Subject(req.query.Course_Subject_Name, function (err, rows) 
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
 router.get('/Get_Course_Subject/:Course_Subject_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Subject.Get_Course_Subject(req.params.Course_Subject_Id_, function (err, rows) 
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
 router.get('/Delete_Course_Subject/:Course_Subject_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Subject.Delete_Course_Subject(req.params.Course_Subject_Id_, function (err, rows) 
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

