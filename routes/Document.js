 var express = require('express');
 var router = express.Router();
 var Document=require('../models/Document');
 router.post('/Save_Document/',function(req,res,next)
 { 
 try 
 {
Document.Save_Document(req.body, function (err, rows) 
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
 router.get('/Search_Document/',function(req,res,next)
 { 
 try 
 {
Document.Search_Document(req.query.Document_Name, function (err, rows) 
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
 router.get('/Get_Document/:Document_Id_?',function(req,res,next)
 { 
 try 
 {
Document.Get_Document(req.params.Document_Id_, function (err, rows) 
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
 router.get('/Delete_Document/:Document_Id_?',function(req,res,next)
 { 
 try 
 {
Document.Delete_Document(req.params.Document_Id_, function (err, rows) 
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

