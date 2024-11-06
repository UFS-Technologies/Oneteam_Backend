 var express = require('express');
 var router = express.Router();
 var University_Followup=require('../models/University_Followup');
 router.post('/Save_University_Followup/',function(req,res,next)
 { 
 try 
 {
University_Followup.Save_University_Followup(req.body, function (err, rows) 
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
 router.get('/Search_University_Followup/',function(req,res,next)
 { 
 try 
 {
University_Followup.Search_University_Followup(req.query.University_Followup_Name, function (err, rows) 
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
 router.get('/Get_University_Followup/:University_Followup_Id_?',function(req,res,next)
 { 
 try 
 {
University_Followup.Get_University_Followup(req.params.University_Followup_Id_, function (err, rows) 
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
 router.get('/Delete_University_Followup/:University_Followup_Id_?',function(req,res,next)
 { 
 try 
 {
University_Followup.Delete_University_Followup(req.params.University_Followup_Id_, function (err, rows) 
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

