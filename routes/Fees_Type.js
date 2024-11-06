 var express = require('express');
 var router = express.Router();
 var Fees_Type=require('../models/Fees_Type');
 router.post('/Save_Fees_Type/',function(req,res,next)
 { 
 try 
 {
Fees_Type.Save_Fees_Type(req.body, function (err, rows) 
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
 router.get('/Search_Fees_Type/',function(req,res,next)
 { 
 try 
 {
Fees_Type.Search_Fees_Type(req.query.Fees_Type_Name, function (err, rows) 
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
 router.get('/Get_Fees_Type/:Fees_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Fees_Type.Get_Fees_Type(req.params.Fees_Type_Id_, function (err, rows) 
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
 router.get('/Delete_Fees_Type/:Fees_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Fees_Type.Delete_Fees_Type(req.params.Fees_Type_Id_, function (err, rows) 
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

