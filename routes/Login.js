var express = require("express");
var router = express.Router();
var Login = require("../models/Login");
const jwt = require('jsonwebtoken');

const config=require('../config.json');

router.get("/Login_Check/:userName?/:password?", function(req, res, next) {
  try {
    Login.Login_Check(req.params.userName, req.params.password, function(
      err,
      rows

    ) 
    {
     
      if (err) {
       
        res.json(err);
      } else {
        const token = jwt.sign({ sub: rows[0][0] }, config.secret);

      // 
        res.json({...rows,token});


      }
    });
  } catch (e) {
  } finally {
  }
});




router.get("/Agent_Login/:userName?/:password?", function(req, res, next) {
  try {
   
    Login.Agent_Login(req.params.userName, req.params.password, function(
      err,
      rows

    ) 
    {
     
      if (err) {
       
        res.json(err);
      } else {
        const token = jwt.sign({ sub: rows[0][0] }, config.secret);

      // 
        res.json({...rows,token});


      }
    });
  } catch (e) {
  } finally {
  }
});


router.get("/Student_Login/:userName?/:password?", function(req, res, next) {
  try {
   
    Login.Student_Login(req.params.userName, req.params.password, function(
      err,
      rows

    ) 
    {
     
      if (err) {
       
        res.json(err);
      } else {
        const token = jwt.sign({ sub: rows[0][0] }, config.secret);

      // 
        res.json({...rows,token});


      }
    });
  } catch (e) {
  } finally {
  }
});


router.get("/Student_Login_Check/:Email?/:Password?", function(req, res, next) {
  try {
    Login.Student_Login_Check(req.params.Email, req.params.Password, function(err,rows) 
    {
      if (err) {
        res.json(err);
      }
       else {
        const token = jwt.sign({ sub: rows[0][0] }, config.secret);
        res.json({...rows,token}); }
    });
  } 
  catch (e) {
  } 
  finally {
  }
});

router.get("/Candidate_Login/:Email?/:Password?", function(req, res, next) {
  try {
    Login.Candidate_Login(req.params.Email, req.params.Password, function(err,rows) 
    {
      if (err) {
        res.json(err);
      }
       else {
        const token = jwt.sign({ sub: rows[0][0] }, config.secret);
        res.json({...rows,token}); }
    });
  } 
  catch (e) {
  } 
  finally {
  }
});

module.exports = router;
