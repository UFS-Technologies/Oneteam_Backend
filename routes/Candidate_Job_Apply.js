 var express = require('express');
 var router = express.Router();
 var Candidate_Job_Apply=require('../models/Candidate_Job_Apply');
 router.post('/Save_Candidate_Job_Apply/',function(req,res,next)
 { 
 try 
 {
Candidate_Job_Apply.Save_Candidate_Job_Apply(req.body, function (err, rows) 
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
 router.get('/Search_Candidate_Job_Apply/',function(req,res,next)
 { 
 try 
 {
Candidate_Job_Apply.Search_Candidate_Job_Apply(req.query.Candidate_Job_Apply_Name, function (err, rows) 
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
 router.get('/Get_Candidate_Job_Apply/:Candidate_Job_Apply_Id_?',function(req,res,next)
 { 
 try 
 {
Candidate_Job_Apply.Get_Candidate_Job_Apply(req.params.Candidate_Job_Apply_Id_, function (err, rows) 
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
 router.get('/Delete_Candidate_Job_Apply/:Candidate_Job_Apply_Id_?',function(req,res,next)
 { 
 try 
 {
Candidate_Job_Apply.Delete_Candidate_Job_Apply(req.params.Candidate_Job_Apply_Id_, function (err, rows) 
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

