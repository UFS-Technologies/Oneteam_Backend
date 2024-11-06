 var express = require('express');
 var router = express.Router();
 var Country=require('../models/Country');
 router.post('/Save_Country/',function(req,res,next)
 { 
 try 
 {
Country.Save_Country(req.body, function (err, rows) 
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



  router.get('/Search_Country_Typeahead/',function(req,res,next)
  { 
  try 
  {
   // 
    Country.Search_Country_Typeahead(req.query.Country_Name,function (err, rows) 
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



 router.get('/Search_Country/',function(req,res,next)
 { 
 try 
 {
Country.Search_Country(req.query.Country_Name, function (err, rows) 
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
 router.get('/Get_Country/:Country_Id_?',function(req,res,next)
 { 
 try 
 {
Country.Get_Country(req.params.Country_Id_, function (err, rows) 
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
 router.get('/Delete_Country/:Country_Id_?',function(req,res,next)
 { 
 try 
 {
Country.Delete_Country(req.params.Country_Id_, function (err, rows) 
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

