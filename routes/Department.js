 var express = require('express');
 var router = express.Router();
 var Department=require('../models/Department');
 router.post('/Save_Department/',async function(req,res,next)
 { 
 try 
 {
 const resp=await Department.Save_Department(req.body);
 return res.send(resp);
 }
 catch(e){
   return res.send(e);
 }
  });

 router.get('/Search_Department/:Department_Name_?',function(req,res,next)
 { 
 try 
 {
Department.Search_Department(req.params.Department_Name_, function (err, rows) 
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
 
 router.get('/Get_Department/:Department_Id_?',function(req,res,next)
 { 
 try 
 {
Department.Get_Department(req.params.Department_Id_, function (err, rows) 
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
  router.get('/Get_Department_InUser/',function(req,res,next)
  { 
  try 
  {
 Department.Get_Department_InUser( function (err, rows) 
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
   router.get('/Search_Department_Status/:Department_Status_Name_?',function(req,res,next)
   { 
     
   try 
   {
    Department.Search_Department_Status(req.params.Department_Status_Name_, function (err, rows) 
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
 router.get('/Delete_Department/:Department_Id_?',function(req,res,next)
 { 
 try 
 {
Department.Delete_Department(req.params.Department_Id_, function (err, rows) 
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






  router.get('/Search_Branch_Department_Typeahead/:Branch_Id_?/:Department_Name_?',function(req,res,next)
 { 
 try 
 {
Department.Search_Branch_Department_Typeahead(req.params.Branch_Id_,req.params.Department_Name_, function (err, rows) 
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
  // router.get("/Load_User_Status_By_Department/:Department_Id_?/:Branch_Id_?",async (req, res, next) =>{
  //   try {
     
  //     const result = await Department.Load_User_Status_By_Department(req.params.Department_Id_,req.params.Branch_Id_);
      
  //   //console.log('result', result);
  //     res.json(result);
  
  //   } catch (e) {
  //     res.send(e);
  //   } finally {
  //   }
  // });
  router.get('/Search_Department_User_Typeahead/:Branch_Id_?/:Department_Id_?/:Users_Name_?',function(req,res,next)
 { 
 try 
 {
Department.Search_Department_User_Typeahead(req.params.Branch_Id_,req.params.Department_Id_,req.params.Users_Name_, function (err, rows) 
 {
  if (err) 
  {
  res.json(err);
  }
  else 
  {
    //console.log
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



  router.get('/Search_Department_Status_Typeahead/:Department_Id_?/:Department_Status_Name_?',function(req,res,next)
  { 
  try 
  {
 Department.Search_Department_Status_Typeahead(req.params.Department_Id_,req.params.Department_Status_Name_, function (err, rows) 
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

   router.get('/Get_Status_Selection_Edit/:Department_Id_?',function(req,res,next)
   { 
   try 
   {
    Department.Get_Status_Selection_Edit(req.params.Department_Id_, function (err, rows) 
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

