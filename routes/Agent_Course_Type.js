 var express = require('express');
 var router = express.Router();
 var Agent_Course_Type=require('../models/Agent_Course_Type');
 router.post('/Save_Agent_Course_Type/',function(req,res,next)
 { 
 try 
 {
Agent_Course_Type.Save_Agent_Course_Type(req.body, function (err, rows) 
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
 router.get('/Search_Agent_Course_Type/',function(req,res,next)
 { 
 try 
 {
Agent_Course_Type.Search_Agent_Course_Type(req.query.Agent_Course_Type_Name, function (err, rows) 
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
 router.get('/Get_Agent_Course_Type/:Agent_Course_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Agent_Course_Type.Get_Agent_Course_Type(req.params.Agent_Course_Type_Id_, function (err, rows) 
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
 router.get('/Delete_Agent_Course_Type/:Agent_Course_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Agent_Course_Type.Delete_Agent_Course_Type(req.params.Agent_Course_Type_Id_, function (err, rows) 
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

