 var express = require('express');
 var router = express.Router();
 var Accounts=require('../models/Accounts');
 router.post('/Save_Accounts/',function(req,res,next)
 { 
 try 
 {
Accounts.Save_Accounts(req.body, function (err, rows) 
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
 router.get('/Search_Accounts/',function(req,res,next)
 { 
 try 
 {
Accounts.Search_Accounts(req.query.Accounts_Name, function (err, rows) 
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
 router.get('/Get_Accounts/:Accounts_Id_?',function(req,res,next)
 { 
 try 
 {
Accounts.Get_Accounts(req.params.Accounts_Id_, function (err, rows) 
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
 router.get('/Delete_Accounts/:Accounts_Id_?',function(req,res,next)
 { 
 try 
 {
Accounts.Delete_Accounts(req.params.Accounts_Id_, function (err, rows) 
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

