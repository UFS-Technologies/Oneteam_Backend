 var express = require('express');
 var router = express.Router();
 var Agent_Commision=require('../models/Agent_Commision');
 router.post('/Save_Agent_Commision/',function(req,res,next)
 { 
 try 
 {
Agent_Commision.Save_Agent_Commision(req.body, function (err, rows) 
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
 router.get('/Search_Agent_Commision/',function(req,res,next)
 { 
 try 
 {
Agent_Commision.Search_Agent_Commision(req.query.Agent_Commision_Name, function (err, rows) 
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
 router.get('/Get_Agent_Commision/:Agent_Commision_Id_?',function(req,res,next)
 { 
 try 
 {
Agent_Commision.Get_Agent_Commision(req.params.Agent_Commision_Id_, function (err, rows) 
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
 router.get('/Delete_Agent_Commision/:Agent_Commision_Id_?',function(req,res,next)
 { 
 try 
 {
Agent_Commision.Delete_Agent_Commision(req.params.Agent_Commision_Id_, function (err, rows) 
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

