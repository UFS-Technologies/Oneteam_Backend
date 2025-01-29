CREATE TABLE `comments` (
  `Chat_Id` int NOT NULL AUTO_INCREMENT,
  `Chats` longtext,
  `From_User` int DEFAULT NULL,
  `From_User_Name` varchar(45) DEFAULT NULL,
  `Entry_Date` datetime DEFAULT NULL,
  `File_Name` varchar(1000) DEFAULT NULL,
  `Display_File` varchar(1000) DEFAULT NULL,
  `User_List` longtext,
  `User_Ids` longtext,
  `Channel_Id` int DEFAULT NULL,
  `DeleteStatus` tinyint DEFAULT NULL,
  `Student_Id` int DEFAULT NULL,
  PRIMARY KEY (`Chat_Id`)
) ENGINE=InnoDB AUTO_INCREMENT=202 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




Menu_table:

# Menu_Id	Menu_Name	Menu_Order	Menu_Order_Sub	IsEdit	IsSave	IsDelete	IsView	Menu_Status	DeleteStatus	Menu_Type
132	Student Status Wise Report	132	1	1	1	1	1	1	0	1
