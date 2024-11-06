 var express = require('express');
 var router = express.Router();
 var Employer_Status=require('../models/Employer_Status');
 router.post('/Save_Employer_Status/',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Save_Employer_Status(req.body, function (err, rows) 
 {
  console.log(req);
  if (err) 
  {
  res.json(err);
  console.log(err);
  }
  else 
  {
    res.json(rows);
  }
  });
  }
 catch (e) 
 {
  console.log(e);
 }
 finally 
 {
 }
  });
 router.get('/Search_Employer_Status/',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Search_Employer_Status(req.query.Status_Name, function (err, rows) 
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
 router.get('/Get_Employer_Status/:Employer_Status_Id_?',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Get_Employer_Status(req.params.Status_Id_, function (err, rows) 
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
 router.get('/Delete_Employer_Status/:Employer_Status_Id_?',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Delete_Employer_Status(req.params.Status_Id_, function (err, rows) 
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











  router.post('/Save_Vacancy_Source/',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Save_Vacancy_Source(req.body, function (err, rows) 
 {
  console.log(req);
  if (err) 
  {
  res.json(err);
  console.log(err);
  }
  else 
  {
    res.json(rows);
  }
  });
  }
 catch (e) 
 {
  console.log(e);
 }
 finally 
 {
 }
  });
 router.get('/Search_Vacancy_Source/',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Search_Vacancy_Source(req.query.Vacancy_Source_Name_, function (err, rows) 
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
 router.get('/Get_Vacancy_Source/:Vacancy_Source_Id_?',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Get_Vacancy_Source(req.params.Vacancy_Source_Id_, function (err, rows) 
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
 router.get('/Delete_Vacancy_Source/:Vacancy_Source_Id_?',function(req,res,next)
 { 
 try 
 {
  Employer_Status.Delete_Vacancy_Source(req.params.Vacancy_Source_Id_, function (err, rows) 
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

