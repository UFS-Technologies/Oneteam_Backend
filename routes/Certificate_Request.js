 var express = require('express');
 var router = express.Router();
 var Certificate_Request=require('../models/Certificate_Request');
 router.post('/Save_Certificate_Request/',function(req,res,next)
 { 
 try 
 {
Certificate_Request.Save_Certificate_Request(req.body, function (err, rows) 
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
 router.get('/Search_Certificate_Request/',function(req,res,next)
 { 
 try 
 {
Certificate_Request.Search_Certificate_Request(req.query.Certificate_Request_Name, function (err, rows) 
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
 router.get('/Get_Certificate_Request/:Certificate_Request_Id_?',function(req,res,next)
 { 
 try 
 {
Certificate_Request.Get_Certificate_Request(req.params.Certificate_Request_Id_, function (err, rows) 
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
 router.get('/Delete_Certificate_Request/:Certificate_Request_Id_?',function(req,res,next)
 { 
 try 
 {
Certificate_Request.Delete_Certificate_Request(req.params.Certificate_Request_Id_, function (err, rows) 
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

