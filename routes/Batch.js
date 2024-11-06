var express = require('express');
var router = express.Router();
var Batch=require('../models/Batch');
router.post('/Save_Batch/',function(req,res,next)
{ 
try 
{
Batch.Save_Batch(req.body, function (err, rows) 
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
router.get('/Search_Batch/',function(req,res,next)
{ 
try 
{
Batch.Search_Batch(req.query.Batch_Name, function (err, rows) 
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
router.get('/Get_Batch/:Batch_Id_?',function(req,res,next)
{ 
try 
{
Batch.Get_Batch(req.params.Batch_Id_, function (err, rows) 
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
router.get('/Delete_Batch/:Batch_Id_?',function(req,res,next)
{ 
try 
{
Batch.Delete_Batch(req.params.Batch_Id_, function (err, rows) 
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

router.get('/Load_BatchPage_Dropdowns',function(req,res,next)
{ 
try 
{
    Batch.Load_BatchPage_Dropdowns( function (err, rows)
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

