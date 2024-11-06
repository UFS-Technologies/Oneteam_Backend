 var express = require('express');
 var router = express.Router();
 var Specialization=require('../models/Specialization');
 router.post('/Save_Specialization/',function(req,res,next)
 { 
 try 
 {
Specialization.Save_Specialization(req.body, function (err, rows) 
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
 router.get('/Search_Specialization/',function(req,res,next)
 { 
 try 
 {
Specialization.Search_Specialization(req.query.Specialization_Name, function (err, rows) 
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
 router.get('/Get_Specialization/:Specialization_Id_?',function(req,res,next)
 { 
 try 
 {
Specialization.Get_Specialization(req.params.Specialization_Id_, function (err, rows) 
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
 router.get('/Delete_Specialization/:Specialization_Id_?',function(req,res,next)
 { 
 try 
 {
Specialization.Delete_Specialization(req.params.Specialization_Id_, function (err, rows) 
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

