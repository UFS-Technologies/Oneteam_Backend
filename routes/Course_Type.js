 var express = require('express');
 var router = express.Router();
 var Course_Type=require('../models/Course_Type');
 router.post('/Save_Course_Type/',function(req,res,next)
 { 
 try 
 {
Course_Type.Save_Course_Type(req.body, function (err, rows) 
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
 router.get('/Search_Course_Type/',function(req,res,next)
 { 
 try 
 {
Course_Type.Search_Course_Type(req.query.Course_Type_Name, function (err, rows) 
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
 router.get('/Get_Course_Type/:Course_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Type.Get_Course_Type(req.params.Course_Type_Id_, function (err, rows) 
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
 router.get('/Delete_Course_Type/:Course_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Type.Delete_Course_Type(req.params.Course_Type_Id_, function (err, rows) 
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

