DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Department`( In Department_Name_ varchar(100))
Begin 
 set Department_Name_ = Concat( '%',Department_Name_ ,'%');
 SELECT Department_Id,
Department_Name,
FollowUp,
Status,Transfer_Method_Id,
Department_Order,Department_Status_Id,
Color From Department where Department_Name like Department_Name_ and Is_Delete=false 
Order by Department_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Department`( )
BEGIN

SELECT 
Department_Id,Department_Name,Transfer_Method_Id
From department
 where Is_Delete=false
ORDER BY Department_Name ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Department`( In Department_Id_ int,
Department_Name_ varchar(50),
FollowUp_ TInyint,
Status_ varchar(50),
Department_Order_ int,
Color_ varchar(50),Department_Status_Id_ int,Transfer_Method_Id_ int,
Status_Selection JSON)
Begin 
 DECLARE Status_Id_ int;
DECLARE i int  DEFAULT 0;
	
 /*   DECLARE exit handler for sqlexception
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 as MESSAGE_TEXT,@p1 as RETURNED_SQLSTATE  ;
ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 as MESSAGE_TEXT,@p1 as RETURNED_SQLSTATE  ;
ROLLBACK;
END;
    START TRANSACTION;*/
    
 if  Department_Id_>0
  THEN 
	delete from Status_Selection where Department_Id=Department_Id_;
	UPDATE Department set Department_Id = Department_Id_ ,
	Department_Name = Department_Name_ ,
	FollowUp = FollowUp_ ,
	Status = Status_ ,
	Department_Order = Department_Order_ ,Department_Status_Id=Department_Status_Id_,Transfer_Method_Id=Transfer_Method_Id_,
	Color = Color_  Where Department_Id=Department_Id_ ;
    update student set Followup_Department_Name = Department_Name_ where Followup_Department_Id = Department_Id_;
	ELSE 
	SET Department_Id_ = (SELECT  COALESCE( MAX(Department_Id ),0)+1 FROM Department); 
	INSERT INTO Department(Department_Id ,Department_Name ,FollowUp ,Status ,Department_Order ,
	Color ,Department_Status_Id,Current_User_Index,Total_User,Transfer_Method_Id,Is_Delete ) 
	values (Department_Id_ ,Department_Name_ ,FollowUp_ ,Status_ ,Department_Order_ ,Color_ ,Department_Status_Id_,1,0,Transfer_Method_Id_,false);
End If ;

WHILE i < JSON_LENGTH(Status_Selection) DO
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Status_Selection,CONCAT('$[',i,'].Department_Status_Id'))) INTO Status_Id_;
	INSERT INTO Status_Selection(Department_Id ,Status_Id,Is_Delete )
	values (Department_Id_ ,Status_Id_,false);  
	SELECT i + 1 INTO i;
END WHILE;     
#COMMIT;

select Department_Id_;
#select Status_Id_;
 End$$
DELIMITER ;
