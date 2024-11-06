var db = require("../dbconnection");

var Login = {
  Login_Check: function(User_Name_, Password_, callback) {
    return db.query(
      "CALL Login_Check (@User_Name_ :=?,@Password_ :=?)",
      [User_Name_, Password_],
      callback
    );
  },

  Agent_Login: function(User_Name_, Password_, callback) {
    return db.query(
      "CALL Agent_Login (@User_Name_ :=?,@Password_ :=?)",
      [User_Name_, Password_],
      callback
    );
  },


 Student_Login: function(User_Name_, Password_, callback) {
    return db.query(
      "CALL Student_Login (@User_Name_ :=?,@Password_ :=?)",
      [User_Name_, Password_],
      callback
    );
  },


  Student_Login_Check: function(Email_, Password_, callback) {
    return db.query("CALL Student_Login_Check (@Email_ :=?,@Password_ :=?)",
      [Email_, Password_],
      callback
    );
  },

  Candidate_Login: function(Email_, Password_, callback) {
    return db.query("CALL Candidate_Login (@Email_ :=?,@Password_ :=?)",
      [Email_, Password_],
      callback
    );
  },
  
  
};
module.exports = Login;
