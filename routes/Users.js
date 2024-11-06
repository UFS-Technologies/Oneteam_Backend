var express = require('express');
var router = express.Router();
var Users=require('../models/Users');

router.post('/Save_Users/',async function(req,res,next)
{ 
try 
{
const resp=await Users.Save_Users(req.body);
return res.send(resp);
}
catch(e){
return res.send(e);
}
});
router.get('/Search_Users', async function (req, res, next) {
var result = '';
try {
result = await Users.Search_Users(req.query.Users_Name_,req.query.Branch_Id_, function (err, rows) 
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

res.json(result);
}
catch (e) {

}
finally {

}
});
router.get('/Search_User_Typeahead/:Users_Name_?',function(req,res,next)
{ 
try 
{
Users.Search_User_Typeahead(req.params.Users_Name_, function (err, rows) 
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

router.get('/Search_User_Role/:User_Role_Name_?',function(req,res,next)
{ 
try 
{
Users.Search_User_Role(req.params.User_Role_Name_, function (err, rows) 
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
router.get('/Get_Users/:Users_Id_?',function(req,res,next)
{ 
try 
{
Users.Get_Users(req.params.Users_Id_, function (err, rows) 
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
router.get('/Delete_Users/:Users_Id_?',function(req,res,next)
{ 
try 
{
Users.Delete_Users(req.params.Users_Id_, function (err, rows) 
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
router.get('/Get_Menu_Permission/:User_Id_?',function(req,res,next)
{ 
try 
{
Users.Get_Menu_Permission(req.params.User_Id_, function (err, rows) 
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
router.get('/Get_Menu_Status/:Menu_Id_?/:Users_Id_?',function(req,res,next)
{ 
try 
{
    Users.Get_Menu_Status(req.params.Menu_Id_,req.params.Users_Id_, function (err, rows)
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
router.get('/User_Employee/:Users_Id_?',function(req,res,next)
{ 
try 
{
Users.User_Employee(req.params.Users_Id_, function (err, rows) 
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
router.get("/Get_Users_Edit/:Users_Id_?",async (req, res, next) =>
{
try 
{   
const result = await Users.Get_Users_Edit(req.params.Users_Id_);
res.json(result);  
} 
catch (e) 
{
res.send(e);
} 
finally 
{
}
});
router.get("/Get_Users_Load_Data",async (req, res, next) =>
{
try
{
const result = await Users.Get_Users_Load_Data();
res.json(result);
} 
catch (e) 
{
//
res.send(e);
} 
finally 
{
}
});
module.exports = router;

