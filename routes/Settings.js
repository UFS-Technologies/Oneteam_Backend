 var express = require('express');
 var router = express.Router();
 var Settings=require('../models/Settings');
 router.post('/Save_Settings/',function(req,res,next)
 { 
 try 
 {
Settings.Save_Settings(req.body, function (err, rows) 
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
 router.get('/Search_Settings/',function(req,res,next)
 { 
 try 
 {
Settings.Search_Settings(req.query.Settings_Name, function (err, rows) 
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
 router.get('/Get_Settings/:Settings_Id_?',function(req,res,next)
 { 
 try 
 {
Settings.Get_Settings(req.params.Settings_Id_, function (err, rows) 
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
 router.get('/Delete_Settings/:Settings_Id_?',function(req,res,next)
 { 
 try 
 {
Settings.Delete_Settings(req.params.Settings_Id_, function (err, rows) 
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

