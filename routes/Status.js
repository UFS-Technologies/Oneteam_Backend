 var express = require('express');
 var router = express.Router();
 var Status=require('../models/Status');
 router.post('/Save_Status/',function(req,res,next)
 { 
 try 
 {
Status.Save_Status(req.body, function (err, rows) 
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
 router.get('/Search_Status/',function(req,res,next)
 { 
 try 
 {
Status.Search_Status(req.query.Status_Name, function (err, rows) 
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
 router.get('/Get_Status/:Status_Id_?',function(req,res,next)
 { 
 try 
 {
Status.Get_Status(req.params.Status_Id_, function (err, rows) 
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
 router.get('/Delete_Status/:Status_Id_?',function(req,res,next)
 { 
 try 
 {
Status.Delete_Status(req.params.Status_Id_, function (err, rows) 
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

