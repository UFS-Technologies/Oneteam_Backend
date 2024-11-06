var express = require('express');
var router = express.Router();
var Recruitment_Drives = require('../models/Recruitment_Drives');
const upload = require('../helpers/multer-helper');

router.post("/Save_Recruitment_Drives/", async function (req, res, next) {
  try {
    const resp = await Recruitment_Drives.Save_Recruitment_Drives(req.body);
    return res.send(resp);
  } catch (e) {
    console.log(e);
    return res.send(e);
  }
});


router.get('/Search_Recruitment_Drives', async function (req, res, next) {
  var result = '';
  try {
    result = await Recruitment_Drives.Search_Recruitment_Drives(req.query.Is_Date_,req.query.FromDate_,req.query.ToDate_,req.query.Branch_Id_,
      req.query.Pointer_Start_,req.query.Pointer_Stop_,req.query.Page_Length_);
    res.json(result);
  }
  catch (e) {

  }
  finally {

  }
});
router.get('/Delete_Recruitment_Drives/:Recruitment_Drives_Id_?',function(req,res,next)
  { 
  try 
  {
  Recruitment_Drives.Delete_Recruitment_Drives(req.params.Recruitment_Drives_Id_, function (err, rows) 
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

