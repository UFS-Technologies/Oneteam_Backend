 var express = require('express');
 var router = express.Router();
 var Study_Materials=require('../models/Study_Materials');
 router.post('/Save_Study_Materials/',function(req,res,next)
 { 
 try 
 {
Study_Materials.Save_Study_Materials(req.body, function (err, rows) 
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
 router.get('/Search_Study_Materials/',function(req,res,next)
 { 
 try 
 {
Study_Materials.Search_Study_Materials(req.query.Study_Materials_Name, function (err, rows) 
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
 router.get('/Get_Study_Materials/:Study_Materials_Id_?',function(req,res,next)
 { 
 try 
 {
Study_Materials.Get_Study_Materials(req.params.Study_Materials_Id_, function (err, rows) 
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
 router.get('/Delete_Study_Materials/:Study_Materials_Id_?',function(req,res,next)
 { 
 try 
 {
Study_Materials.Delete_Study_Materials(req.params.Study_Materials_Id_, function (err, rows) 
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

