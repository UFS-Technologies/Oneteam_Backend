 var express = require('express');
 var router = express.Router();
 var GeneralFunctions=require('../models/GeneralFunctions');






 router.get('/Get_Menu_Status/:Menu_Id_?/:Login_User_?',function(req,res,next)
    { 
    try 
    {
      GeneralFunctions.Get_Menu_Status(req.params.Menu_Id_,req.params.Login_User_, function (err, rows)
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
      ;
    }
    finally 
    {
    }
    });














  module.exports = router;

