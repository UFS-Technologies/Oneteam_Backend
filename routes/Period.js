var express = require('express');
var router = express.Router();
var Period=require('../models/Period');
router.post('/Save_Period/',function(req,res,next)
{ 
try 
{
Period.Save_Period(req.body, function (err, rows) 
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
router.get('/Search_Period/',function(req,res,next)
{ 
try 
{
Period.Search_Period(req.query.Period_Name, function (err, rows) 
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
router.get('/Get_Period/:Period_Id_?',function(req,res,next)
{ 
try 
{
Period.Get_Period(req.params.Period_Id_, function (err, rows) 
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
router.get('/Delete_Period/:Period_Id_?',function(req,res,next)
{ 
try 
{
Period.Delete_Period(req.params.Period_Id_, function (err, rows) 
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

router.get('/Load_PeriodPage_Dropdowns',function(req,res,next)
{ 
try 
{
    Period.Load_PeriodPage_Dropdowns( function (err, rows)
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

