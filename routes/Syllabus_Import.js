var express = require('express');
var router = express.Router();
var Syllabus_Import=require('../models/Syllabus_Import');







router.post("/Save_Syllabus_Import/", function (req, res) {
	try {
		Syllabus_Import.Save_Syllabus_Import(req.body, function (err, rows) {
			if (err) {
				console.log(err);
				res.json(err);
			} else {
				res.json(rows);
			}
		});
	} catch (e) {
	} finally {
	}
});









router.get('/Search_Syllabus_Import/:From_Date_?/:To_Date_?/:Is_Date_Check_?/',function(req,res,next)
{ 
try 
{
Course.Search_Syllabus_Import(req.query.From_Date_,req.query.To_Date_,req.query.Is_Date_Check_, function (err, rows) 
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


router.get('/Get_Syllabus_Import/:Syllabus_Import_Id_?',function(req,res,next)
{ 
try 
{
Syllabus_Import.Get_Syllabus_Import(req.params.Syllabus_Import_Id_, function (err, rows) 
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
router.get('/Delete_Syllabus_Import/:Syllabus_Import_Id_?',function(req,res,next)
{ 
try 
{
Syllabus_Import.Delete_Syllabus_Import(req.params.Syllabus_Import_Id_, function (err, rows) 
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

