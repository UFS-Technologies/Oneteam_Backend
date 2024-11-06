 var express = require('express');
 var router = express.Router();
 var Fees_Receipt=require('../models/Fees_Receipt');
 router.post('/Save_Fees_Receipt/',function(req,res,next)
 { 
 try 
 {
Fees_Receipt.Save_Fees_Receipt(req.body, function (err, rows) 
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
 router.get('/Search_Fees_Receipt/',function(req,res,next)
 { 
 try 
 {
Fees_Receipt.Search_Fees_Receipt(req.query.Fees_Receipt_Name, function (err, rows) 
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
 router.get('/Get_Fees_Receipt/:Fees_Receipt_Id_?',function(req,res,next)
 { 
 try 
 {
Fees_Receipt.Get_Fees_Receipt(req.params.Fees_Receipt_Id_, function (err, rows) 
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
 router.get('/Delete_Fees_Receipt/:Fees_Receipt_Id_?',function(req,res,next)
 { 
 try 
 {
Fees_Receipt.Delete_Fees_Receipt(req.params.Fees_Receipt_Id_, function (err, rows) 
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

