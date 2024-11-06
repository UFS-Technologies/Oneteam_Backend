 var express = require('express');
 var router = express.Router();
 var Mark_List=require('../models/Mark_List');
 router.post('/Save_Mark_List/',function(req,res,next)
 { 
 try 
 {
Mark_List.Save_Mark_List(req.body, function (err, rows) 
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
 router.get('/Search_Mark_List/',function(req,res,next)
 { 
 try 
 {
Mark_List.Search_Mark_List(req.query.Mark_List_Name, function (err, rows) 
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
 router.get('/Get_Mark_List/:Mark_List_Id_?',function(req,res,next)
 { 
 try 
 {
Mark_List.Get_Mark_List(req.params.Mark_List_Id_, function (err, rows) 
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
 router.get('/Delete_Mark_List/:Mark_List_Id_?',function(req,res,next)
 { 
 try 
 {
Mark_List.Delete_Mark_List(req.params.Mark_List_Id_, function (err, rows) 
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

