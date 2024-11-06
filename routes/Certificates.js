 var express = require('express');
 var router = express.Router();
 var Certificates=require('../models/Certificates');
 router.post('/Save_Certificates/',function(req,res,next)
 { 
 try 
 {
Certificates.Save_Certificates(req.body, function (err, rows) 
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
 router.get('/Search_Certificates/',function(req,res,next)
 { 
 try 
 {
Certificates.Search_Certificates(req.query.Certificates_Name, function (err, rows) 
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
 router.get('/Get_Certificates/:Certificates_Id_?',function(req,res,next)
 { 
 try 
 {
Certificates.Get_Certificates(req.params.Certificates_Id_, function (err, rows) 
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
 router.get('/Delete_Certificates/:Certificates_Id_?',function(req,res,next)
 { 
 try 
 {
Certificates.Delete_Certificates(req.params.Certificates_Id_, function (err, rows) 
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

