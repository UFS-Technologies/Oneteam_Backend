 var express = require('express');
 var router = express.Router();
 var Experience=require('../models/Experience');
 router.post('/Save_Experience/',function(req,res,next)
 { 
 try 
 {
Experience.Save_Experience(req.body, function (err, rows) 
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
 router.get('/Search_Experience/',function(req,res,next)
 { 
 try 
 {
Experience.Search_Experience(req.query.Experience_Name, function (err, rows) 
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
 router.get('/Get_Experience/:Experience_Id_?',function(req,res,next)
 { 
 try 
 {
Experience.Get_Experience(req.params.Experience_Id_, function (err, rows) 
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
 router.get('/Delete_Experience/:Experience_Id_?',function(req,res,next)
 { 
 try 
 {
Experience.Delete_Experience(req.params.Experience_Id_, function (err, rows) 
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

