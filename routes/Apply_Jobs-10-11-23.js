var express = require('express');
var router = express.Router();
var ApplyJobs=require('../models/Apply_Jobs');
router.post('/Apply_Jobs/',function(req,res,next)
{
try
{
 ApplyJobs.Apply_Jobs(req.body, function (err, rows)
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


router.post("/Search_Job_Mobile/", function (req, res, next) {
   try {
console.log(req.body)
  ApplyJobs.Search_Job_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
  if (err) {
  console.log(err);
  res.json(err);
  } else {
  res.json(rows);
  }
  }
  );
   } catch (e) {
  console.log(e);
   } finally {
   }
});


router.post("/Search_Applied_Mobile/", function (req, res, next) {
   try {
console.log(req.body)
  ApplyJobs.Search_Applied_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
  if (err) {
  console.log(err);
  res.json(err);
  } else {
  res.json(rows);
  }
  }
  );
   } catch (e) {
  console.log(e);
   } finally {
   }
});



router.post("/Search_Rejected_Mobile/", function (req, res, next) {
   try {
console.log(req.body)
  ApplyJobs.Search_Rejected_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
  if (err) {
  console.log(err);
  res.json(err);
  } else {
  res.json(rows);
  }
  }
  );
   } catch (e) {
  console.log(e);
   } finally {
   }
});



router.post("/Search_Interview_Mobile/", function (req, res, next) {
try {
 console.log(req.body)
ApplyJobs.Search_Interview_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
if (err) {
console.log(err);
res.json(err);
} else {
res.json(rows);
}
}
);
} catch (e) {
console.log(e);
} finally {
}
 });

 

 router.post("/Search_Placed_Mobile/", function (req, res, next) {
try {
 console.log(req.body)
ApplyJobs.Search_Placed_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
if (err) {
console.log(err);
res.json(err);
} else {
res.json(rows);
}
}
);
} catch (e) {
console.log(e);
} finally {
}
 });
 

router.post("/Search_Offered_Mobile/", function (req, res, next) {
   try {
console.log(req.body)
  ApplyJobs.Search_Offered_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
  if (err) {
  console.log(err);
  res.json(err);
  } else {
  res.json(rows);
  }
  }
  );
   } catch (e) {
  console.log(e);
   } finally {
   }
});


router.post('/Search_Job_Mobile1/',function(req,res,next)
{
try
{
 
 ApplyJobs.Search_Job_Mobile(req.query.Student_Id_,req.query.Pointer_Start_,req.query.Pointer_Stop_,req.query.Page_Length_, function (err, rows)
{
if (err)                                                                                                                                                    
{
 
res.json(err);
}
else
{
//
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


router.get("/Change_Student_Status/", function (req, res, next) {
   try {
  ApplyJobs.Change_Student_Status(
  req.query.Student_Status_,
  req.query.Student_Id_,
  function (err, rows) {
  if (err) {
  console.log(err);

  res.json(err);
  } else {
  console.log(rows);
  res.json(rows);
  }
  }
  );
   } catch (e) {
  console.log(e);
   } finally {
   }
});
router.get(
   "/View_Job_Interview/:Job_Posting_Id?/:Student_Id?",
   function (req, res, next) {
  try {
//console.log(req.params);
  ApplyJobs.View_Job_Interview(
  req.params.Job_Posting_Id,req.params.Student_Id,
  function (err, rows) {
  if (err) {
  res.json(err);

  } else {
  console.log(rows);
  res.json(rows);
  }
  }
  );
  } catch (e) {
  } finally {
  }
   }
);

router.get(
   "/View_Job/:Job_Posting_Id?",
   function (req, res, next) {
  try {
//console.log(req.params);
  ApplyJobs.View_Job(
  req.params.Job_Posting_Id,
  function (err, rows) {
  if (err) {
  res.json(err);

  } else {
  console.log(rows);
  res.json(rows);
  }
  }
  );
  } catch (e) {
  } finally {
  }
   }
);


router.get(
   "/Job_Apply_Reject/:Type_?/:Job_Id ?/:User_Id_ ?/:Remark_ ?",
   function (req, res, next) {
  try {
  ApplyJobs.Job_Apply_Reject(
  req.params.Type_,
  req.params.Job_Id,
  req.params.User_Id_,
  req.params.Remark_,
  function (err, rows) {
  if (err) {
  console.log(err);
  res.json(err);
  } else {
  res.json(rows);
  }
  }
  );
  } catch (e) {
  console.log(e);
  } finally {
  }
   }
);



router.get(
"/Job_Apply_Reject_Interview/:Student_Id_?/:Applied_Jobs_Id_ ?/:Interview_Type_ ?/:Remark_ ?",
function (req, res, next) {
try {
ApplyJobs.Job_Apply_Reject_Interview(
req.params.Student_Id_,
req.params.Applied_Jobs_Id_,
req.params.Interview_Type_,
req.params.Remark_,
function (err, rows) {
if (err) {
console.log(err);
res.json(err);
} else {
res.json(rows);
}
}
);
} catch (e) {
console.log(e);
} finally {
}
}
 );




router.get("/View_Job1/", function (req, res, next) {
   try {
  ApplyJobs.View_Job(
  req.query.Job_Posting_Id,

  function (err, rows) {
  if (err) {
  console.log(err);

  res.json(err);
  } else {
  console.log(rows);
  res.json(rows);
  }
  }
  );
   } catch (e) {
  console.log(e);
   } finally {
   }
});

 module.exports = router;









// var express = require('express');
// var router = express.Router();
// var ApplyJobs=require('../models/Apply_Jobs');
// router.post('/Apply_Jobs/',function(req,res,next)
// { 
// try 
// {
//  ApplyJobs.Apply_Jobs(req.body, function (err, rows) 
// {
// if (err) 
// {
// res.json(err);
// }
// else 
// {
// res.json(rows);
// }
// });
// }
// catch (e) 
// {
// }
// finally 
// {
// }
// });


// router.post("/Search_Job_Mobile/", function (req, res, next) {
//    try {
// console.log(req.body)
// 	   ApplyJobs.Search_Job_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
// 			   if (err) {
// 				   console.log(err);
// 				   res.json(err);
// 			   } else {
// 				   res.json(rows);
// 			   }
// 		   }
// 	   );
//    } catch (e) {
// 	   console.log(e);
//    } finally {
//    }
// });


// router.post("/Search_Applied_Mobile/", function (req, res, next) {
//    try {
// console.log(req.body)
// 	   ApplyJobs.Search_Applied_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
// 			   if (err) {
// 				   console.log(err);
// 				   res.json(err);
// 			   } else {
// 				   res.json(rows);
// 			   }
// 		   }
// 	   );
//    } catch (e) {
// 	   console.log(e);
//    } finally {
//    }
// });



// router.post("/Search_Rejected_Mobile/", function (req, res, next) {
//    try {
// console.log(req.body)
// 	   ApplyJobs.Search_Rejected_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
// 			   if (err) {
// 				   console.log(err);
// 				   res.json(err);
// 			   } else {
// 				   res.json(rows);
// 			   }
// 		   }
// 	   );
//    } catch (e) {
// 	   console.log(e);
//    } finally {
//    }
// });



// router.post("/Search_Interview_Mobile/", function (req, res, next) {
// 	try {
//  console.log(req.body)
// 		ApplyJobs.Search_Interview_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
// 				if (err) {
// 					console.log(err);
// 					res.json(err);
// 				} else {
// 					res.json(rows);
// 				}
// 			}
// 		);
// 	} catch (e) {
// 		console.log(e);
// 	} finally {
// 	}
//  });

 

//  router.post("/Search_Placed_Mobile/", function (req, res, next) {
// 	try {
//  console.log(req.body)
// 		ApplyJobs.Search_Placed_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
// 				if (err) {
// 					console.log(err);
// 					res.json(err);
// 				} else {
// 					res.json(rows);
// 				}
// 			}
// 		);
// 	} catch (e) {
// 		console.log(e);
// 	} finally {
// 	}
//  });
 

// router.post("/Search_Offered_Mobile/", function (req, res, next) {
//    try {
// console.log(req.body)
// 	   ApplyJobs.Search_Offered_Mobile(req.body.Student_Id_,req.body.Pointer_Start_,req.body.Pointer_Stop_,req.body.Page_Length_, function (err, rows)  {
// 			   if (err) {
// 				   console.log(err);
// 				   res.json(err);
// 			   } else {
// 				   res.json(rows);
// 			   }
// 		   }
// 	   );
//    } catch (e) {
// 	   console.log(e);
//    } finally {
//    }
// });


// router.post('/Search_Job_Mobile1/',function(req,res,next)
// { 
// try 
// {
 
//  ApplyJobs.Search_Job_Mobile(req.query.Student_Id_,req.query.Pointer_Start_,req.query.Pointer_Stop_,req.query.Page_Length_, function (err, rows) 
// {
// if (err)                                                                                                                                                     
// {
  
// res.json(err);
// }
// else 
// {
// // 
//   res.json(rows);
// }
// });
// }
// catch (e) 
// {

// }
// finally 
// {
// }
// });


// router.get("/Change_Student_Status/", function (req, res, next) {
//    try {
// 	   ApplyJobs.Change_Student_Status(
// 		   req.query.Student_Status_,
// 		   req.query.Student_Id_,
// 		   function (err, rows) {
// 			   if (err) {
// 				   console.log(err);

// 				   res.json(err);
// 			   } else {
// 				   console.log(rows);
// 				   res.json(rows);
// 			   }
// 		   }
// 	   );
//    } catch (e) {
// 	   console.log(e);
//    } finally {
//    }
// });


// router.get(
//    "/View_Job/:Job_Posting_Id?",
//    function (req, res, next) {
// 	   try {
// //console.log(req.params);
// 		   ApplyJobs.View_Job(
// 			   req.params.Job_Posting_Id,
// 			   function (err, rows) {
// 				   if (err) {
// 					   res.json(err);

// 				   } else {
// 					   console.log(rows);
// 					   res.json(rows);
// 				   }
// 			   }
// 		   );
// 	   } catch (e) {
// 	   } finally {
// 	   }
//    }
// );


// router.get(
//    "/Job_Apply_Reject/:Type_?/:Job_Id ?/:User_Id_ ?/:Remark_ ?",
//    function (req, res, next) {
// 	   try {
// 		   ApplyJobs.Job_Apply_Reject(
// 			   req.params.Type_,
// 			   req.params.Job_Id,
// 			   req.params.User_Id_,
// 			   req.params.Remark_,
// 			   function (err, rows) {
// 				   if (err) {
// 					   console.log(err);
// 					   res.json(err);
// 				   } else {
// 					   res.json(rows);
// 				   }
// 			   }
// 		   );
// 	   } catch (e) {
// 		   console.log(e);
// 	   } finally {
// 	   }
//    }
// );



// router.get(
// 	"/Job_Apply_Reject_Interview/:Student_Id_?/:Applied_Jobs_Id_ ?/:Interview_Type_ ?/:Remark_ ?",
// 	function (req, res, next) {
// 		try {
// 			ApplyJobs.Job_Apply_Reject(
// 				req.params.Student_Id_,
// 				req.params.Applied_Jobs_Id_,
// 				req.params.Interview_Type_,
// 				req.params.Remark_,
// 				function (err, rows) {
// 					if (err) {
// 						console.log(err);
// 						res.json(err);
// 					} else {
// 						res.json(rows);
// 					}
// 				}
// 			);
// 		} catch (e) {
// 			console.log(e);
// 		} finally {
// 		}
// 	}
//  );




// router.get("/View_Job1/", function (req, res, next) {
//    try {
// 	   ApplyJobs.View_Job(
// 		   req.query.Job_Posting_Id,
			
// 		   function (err, rows) {
// 			   if (err) {
// 				   console.log(err);

// 				   res.json(err);
// 			   } else {
// 				   console.log(rows);
// 				   res.json(rows);
// 			   }
// 		   }
// 	   );
//    } catch (e) {
// 	   console.log(e);
//    } finally {
//    }
// });

//  module.exports = router;

