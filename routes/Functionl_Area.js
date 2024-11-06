 var express = require('express');
 var router = express.Router();
 var Functionl_Area=require('../models/Functionl_Area');
 router.post('/Save_Functionl_Area/',function(req,res,next)
 { 
 try 
 {
Functionl_Area.Save_Functionl_Area(req.body, function (err, rows) 
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
 router.get('/Search_Functionl_Area/',function(req,res,next)
 { 
 try 
 {
Functionl_Area.Search_Functionl_Area(req.query.Functionl_Area_Name, function (err, rows) 
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
 router.get('/Get_Functionl_Area/:Functionl_Area_Id_?',function(req,res,next)
 { 
 try 
 {
Functionl_Area.Get_Functionl_Area(req.params.Functionl_Area_Id_, function (err, rows) 
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
 router.get('/Delete_Functionl_Area/:Functionl_Area_Id_?',function(req,res,next)
 { 
 try 
 {
Functionl_Area.Delete_Functionl_Area(req.params.Functionl_Area_Id_, function (err, rows) 
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

