 var express = require('express');
 var router = express.Router();
 var Question=require('../models/Question');
 router.post('/Save_Question/',function(req,res,next)
 { 
 try 
 {
Question.Save_Question(req.body, function (err, rows) 
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
 router.get('/Search_Question/',function(req,res,next)
 { 
 try 
 {
Question.Search_Question(req.query.Question_Name, function (err, rows) 
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
 router.get('/Get_Question/:Question_Id_?',function(req,res,next)
 { 
 try 
 {
Question.Get_Question(req.params.Question_Id_, function (err, rows) 
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
 router.get('/Delete_Question/:Question_Id_?',function(req,res,next)
 { 
 try 
 {
Question.Delete_Question(req.params.Question_Id_, function (err, rows) 
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

