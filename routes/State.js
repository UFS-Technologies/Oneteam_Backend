var express = require('express');
var router = express.Router();
var State=require('../models/State');
router.post('/Save_State/',function(req,res,next)
{ 
try 
{
State.Save_State(req.body, function (err, rows) 
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
router.post('/Save_State_District/',function(req,res,next)
{ 
try 
{
State.Save_State_District(req.body, function (err, rows) 
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
router.get('/Search_State/',function(req,res,next)
{ 
try 
{
State.Search_State(req.query.State_Name, function (err, rows) 
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
router.get('/Get_State_District/:State_Id_?',function(req,res,next)
{ 
try 
{
State.Get_State_District(req.params.State_Id_, function (err, rows) 
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
router.get('/Delete_State/:State_Id_?',function(req,res,next)
{ 
try 
{
State.Delete_State(req.params.State_Id_, function (err, rows) 
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
router.get('/Delete_State_District/:State_District_Id_?',function(req,res,next)
{ 
try 
{
State.Delete_State_District(req.params.State_District_Id_, function (err, rows) 
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

