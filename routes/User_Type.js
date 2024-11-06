 var express = require('express');
 var router = express.Router();
 var User_Type=require('../models/User_Type');
 router.post('/Save_User_Type/',function(req,res,next)
 { 
 try 
 {
User_Type.Save_User_Type(req.body, function (err, rows) 
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
 router.get('/Search_User_Type/',function(req,res,next)
 { 
 try 
 {
User_Type.Search_User_Type(req.query.User_Type_Name, function (err, rows) 
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
 router.get('/Get_User_Type/:User_Type_Id_?',function(req,res,next)
 { 
 try 
 {
User_Type.Get_User_Type(req.params.User_Type_Id_, function (err, rows) 
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
 router.get('/Delete_User_Type/:User_Type_Id_?',function(req,res,next)
 { 
 try 
 {
User_Type.Delete_User_Type(req.params.User_Type_Id_, function (err, rows) 
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

