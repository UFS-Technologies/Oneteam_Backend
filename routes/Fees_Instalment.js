 var express = require('express');
 var router = express.Router();
 var Fees_Instalment=require('../models/Fees_Instalment');
 router.post('/Save_Fees_Instalment/',function(req,res,next)
 { 
 try 
 {
Fees_Instalment.Save_Fees_Instalment(req.body, function (err, rows) 
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
 router.get('/Search_Fees_Instalment/',function(req,res,next)
 { 
 try 
 {
Fees_Instalment.Search_Fees_Instalment(req.query.Fees_Instalment_Name, function (err, rows) 
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
 router.get('/Get_Fees_Instalment/:Fees_Instalment_Id_?',function(req,res,next)
 { 
 try 
 {
Fees_Instalment.Get_Fees_Instalment(req.params.Fees_Instalment_Id_, function (err, rows) 
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
 router.get('/Delete_Fees_Instalment/:Fees_Instalment_Id_?',function(req,res,next)
 { 
 try 
 {
Fees_Instalment.Delete_Fees_Instalment(req.params.Fees_Instalment_Id_, function (err, rows) 
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

