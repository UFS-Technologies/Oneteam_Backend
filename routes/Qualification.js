 var express = require('express');
 var router = express.Router();
 var Qualification=require('../models/Qualification');
 router.post('/Save_Qualification/',function(req,res,next)
 { 
 try 
 {
Qualification.Save_Qualification(req.body, function (err, rows) 
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
 router.get('/Search_Qualification/',function(req,res,next)
 { 
 try 
 {
Qualification.Search_Qualification(req.query.Qualification_Name, function (err, rows) 
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
 router.get('/Get_Qualification/:Qualification_Id_?',function(req,res,next)
 { 
 try 
 {
Qualification.Get_Qualification(req.params.Qualification_Id_, function (err, rows) 
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
 router.get('/Delete_Qualification/:Qualification_Id_?',function(req,res,next)
 { 
 try 
 {
Qualification.Delete_Qualification(req.params.Qualification_Id_, function (err, rows) 
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

