
var mysql = require("mysql2");
var connection = mysql.createPool({
   // host: "UFSTECH6",
   // host:"UFSTECH6",
   // user: "ufstechnologies",
   // password: "UFStech@123",
   // database: "Avis",


   host: "localhost",
	user: "root",
	password: "root",
	// database: "oneteam_12_12",   
    // database: "1tm_live_04_04",
    // database: "oneteam_31_08_2024",
    // database: "oneteam_12_02",   

    
    
    // database: "oneteam_09_09_2024",
    // --->latest- below<---
    // database: "oneteam_03_05_2024",
    // database: "oneteam_08_05_2024",
    // 1--->latest<---
    database: "oneteam_live_17_01_2025",
    
   
   
});
module.exports = connection;

 