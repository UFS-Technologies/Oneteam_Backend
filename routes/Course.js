var express = require('express');
var router = express.Router();
var Course=require('../models/Course');
router.post('/Save_Course/',async function(req,res,next)
      { 
      try 
      {
        const resp = await Course.Save_Course(req.body);
         
         return res.send(resp);     
      }
      catch(e){
        console.log(e)
        
      return res.send(e);
      }
      });      

router.get('/Search_Course/',function(req,res,next)
{ 
try 
{
Course.Search_Course(req.query.Course_Name,req.query.Course_Type_Id, function (err, rows) 
{
if (err) 
{
  console.log(err)
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
router.get('/Search_Subject_Typeahead/',function(req,res,next)
{ 
try 
{
  Course.Search_Subject_Typeahead(req.query.Subject_Name_, function (err, rows)
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
router.get('/Search_Part_Typeahead/',function(req,res,next)
{ 
try 
{
  Course.Search_Part_Typeahead(req.query.Part_Name_, function (err, rows)
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
router.get('/Get_Course/:Course_Id_?',function(req,res,next)
{ 
try 
{
Course.Get_Course(req.params.Course_Id_, function (err, rows) 
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
router.get('/Delete_Course/:Course_Id_?',function(req,res,next)
{ 
try 
{
Course.Delete_Course(req.params.Course_Id_, function (err, rows) 
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
router.get('/Load_Course_DropDowns',function(req,res,next)
{ 
try 
{
  Course.Load_Course_DropDowns( function (err, rows)
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

router.get('/Load_Fees_Type/',function(req,res,next)
  { 
  try 
  {
    Course.Load_Fees_Type( function (err, rows)
  {
  if (err) 
  {
    console.log(err)
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

