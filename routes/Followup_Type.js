 var express = require('express');
 var router = express.Router();
 var Followup_Type=require('../models/Followup_Type');
 router.post('/Save_Followup_Type/',function(req,res,next)
 { 
 try 
 {
Followup_Type.Save_Followup_Type(req.body, function (err, rows) 
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
 router.get('/Search_Followup_Type/',function(req,res,next)
 { 
 try 
 {
Followup_Type.Search_Followup_Type(req.query.Followup_Type_Name, function (err, rows) 
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
 router.get('/Get_Followup_Type/:Followup_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Followup_Type.Get_Followup_Type(req.params.Followup_Type_Id_, function (err, rows) 
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
 router.get('/Delete_Followup_Type/:Followup_Type_Id_?',function(req,res,next)
 { 
 try 
 {
Followup_Type.Delete_Followup_Type(req.params.Followup_Type_Id_, function (err, rows) 
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

