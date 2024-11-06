 var express = require('express');
 var router = express.Router();
 var Category=require('../models/Category');
router.post('/Save_Category/',function(req,res,next)
{ 
try 
{
Category.Save_Category(req.body, function (err, rows) 
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
 router.get('/Search_Category/',function(req,res,next)
 { 
 try 
 {
Category.Search_Category(req.query.Category_Name, function (err, rows) 
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
 router.get('/Get_Category/:Category_Id_?',function(req,res,next)
 { 
 try 
 {
Category.Get_Category(req.params.Category_Id_, function (err, rows) 
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
 router.get('/Delete_Category/:Category_Id_?',function(req,res,next)
 { 
 try 
 {
Category.Delete_Category(req.params.Category_Id_, function (err, rows) 
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

