 var express = require('express');
 var router = express.Router();
 var Part=require('../models/Part');
 router.post('/Save_Part/',function(req,res,next)
 { 
 try 
 {
Part.Save_Part(req.body, function (err, rows) 
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
 router.get('/Search_Part/',function(req,res,next)
 { 
 try 
 {
Part.Search_Part(req.query.Part_Name, function (err, rows) 
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
 router.get('/Get_Part/:Part_Id_?',function(req,res,next)
 { 
 try 
 {
Part.Get_Part(req.params.Part_Id_, function (err, rows) 
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
 router.get('/Delete_Part/:Part_Id_?',function(req,res,next)
 { 
 try 
 {
Part.Delete_Part(req.params.Part_Id_, function (err, rows) 
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

