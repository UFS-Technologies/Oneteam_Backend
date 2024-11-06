var express = require('express');
var router = express.Router();
var Question_Import=require('../models/Question_Import');
router.get('/Search_Course_Typeahead/:Course_Name_?',function(req,res,next)
{ 
try 
{
Question_Import.Search_Course_Typeahead(req.params.Course_Name_, function (err, rows) 

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
router.get('/Search_Course_Part_Typeahead/:Course_Id_?/:Part_Name_?',function(req,res,next)
{ 
try 
{
Question_Import.Search_Course_Part_Typeahead(req.params.Course_Id_,req.params.Part_Name_, function (err, rows) 
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
//res.json('rows');
}
});
router.post('/Save_Question_Import_Master/',function(req,res)
  { 
  try 
  {
  Question_Import.Save_Question_Import_Master(req.body, function (err, rows) 
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
router.get('/Search_Part_Subject_Typeahead/:Course_Id_?/:Part_Id_?/:Subject_Name_?',function(req,res,next)
{ 
try 
{
Question_Import.Search_Part_Subject_Typeahead(req.params.Course_Id_,req.params.Part_Id_,req.params.Subject_Name_, function (err, rows) 
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
//res.json('rows');
}
});
router.get('/Delete_Question_Import_Master/:Question_Import_Details_Id_?',function(req,res,next)
{ 
try 
{
Question_Import.Delete_Question_Import_Master(req.params.Question_Import_Details_Id_, function (err, rows) 
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
router.get('/Search_Question_Import_Master/',function(req,res,next)
{ 
try 
{
Question_Import.Search_Question_Import_Master(req.query.Fromdate_,req.query.Todate_,req.query.Course_Id_,req.query.Subject_Id_,req.query.Part_Id_, function (err, rows) 
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
router.get('/Get_Question_Import/:Question_Import_Master_Id_?',function(req,res,next)
{ 
try 
{
Question_Import.Get_Question_Import(req.params.Question_Import_Master_Id_, function (err, rows) 
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

