 var express = require('express');
 var router = express.Router();
 var Course_Fees=require('../models/Course_Fees');
 router.post('/Save_Course_Fees/',function(req,res,next)
 { 
 try 
 {
Course_Fees.Save_Course_Fees(req.body, function (err, rows) 
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
 router.get('/Search_Course_Fees/',function(req,res,next)
 { 
 try 
 {
Course_Fees.Search_Course_Fees(req.query.Course_Fees_Name, function (err, rows) 
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
 router.get('/Get_Course_Fees/:Course_Fees_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Fees.Get_Course_Fees(req.params.Course_Fees_Id_, function (err, rows) 
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
 router.get('/Delete_Course_Fees/:Course_Fees_Id_?',function(req,res,next)
 { 
 try 
 {
Course_Fees.Delete_Course_Fees(req.params.Course_Fees_Id_, function (err, rows) 
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

