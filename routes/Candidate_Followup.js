 var express = require('express');
 var router = express.Router();
 var Candidate_Followup=require('../models/Candidate_Followup');
 router.post('/Save_Candidate_Followup/',function(req,res,next)
 { 
 try 
 {
Candidate_Followup.Save_Candidate_Followup(req.body, function (err, rows) 
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
 router.get('/Search_Candidate_Followup/',function(req,res,next)
 { 
 try 
 {
Candidate_Followup.Search_Candidate_Followup(req.query.Candidate_Followup_Name, function (err, rows) 
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
 router.get('/Get_Candidate_Followup/:Candidate_Followup_Id_?',function(req,res,next)
 { 
 try 
 {
Candidate_Followup.Get_Candidate_Followup(req.params.Candidate_Followup_Id_, function (err, rows) 
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
 router.get('/Delete_Candidate_Followup/:Candidate_Followup_Id_?',function(req,res,next)
 { 
 try 
 {
Candidate_Followup.Delete_Candidate_Followup(req.params.Candidate_Followup_Id_, function (err, rows) 
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

