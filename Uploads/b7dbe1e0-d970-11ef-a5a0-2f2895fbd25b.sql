DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Student_Status_Report`( Fromdate_ date, Todate_ date,Login_User_Id_ int,Is_Date_Check_ tinyint,Department_Status_ int,User_Id_ int,Dept_Id_ int,Branch_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);DECLARE Search_by_type_ VARCHAR(200);
set Search_Date_=''; set SearchbyName_Value='';set Search_by_type_ ='';
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
if User_Id_ >0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_List like '%*",User_Id_,"*%'");
end if;
    if Dept_Id_ >0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Dept_Id_);
end if;
if Branch_Id_ >0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_Id_);
end if;
if Department_Status_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status_Id =",Department_Status_);
end if;

if User_Type_ =2 then
    SET Search_by_type_ =concat(Search_by_type_," or student.User_List like '%*",Login_User_Id_,"*%'");	
    #set Department_String_='';
end if;


/*if User_Type_=2 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/

SET @query = Concat( " select (Date_Format(student.Entry_Date,'%d-%m-%Y')) As Created_On,user_details.User_Details_Name As Created_By,
student.Student_Name Student,student.Phone_Number Mobile,Branch.Branch_Name Branch,
Department_Status.Department_Status_Name Status,T.User_Details_Name To_Staff,B.User_Details_Name Registered_By,Status_Id,
(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Follow_Up_On,Department.Department_Name Department,
(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On,student.Remark,student.Student_Id,student.Status_Id
from student
 inner join Department on Department.Department_Id= student.Followup_Department_Id  
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
left join user_details as B on B.User_Details_Id=student.Registered_By
where student.DeleteStatus=0   ", Search_Date_ ," ",SearchbyName_Value," ",Department_String_,"
and (student.Role_Id in(",RoleId_,")  ",Search_by_type_,")
order by Status_Id  ");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
#select @query;

EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Dashboard_Count`(In RoleId_ varchar(100),Department_String_ varchar(4000),Login_User_Id_ int,Fromdate_ date,Todate_ date,
Date_Value_ int,User_Id_ int,Dept_Id_ int,Branch_Id_ int,Department_Status_Id_ int)
BEGIN
#declare Fromdate_ date;declare Todate_ date;
declare Department_String_To_User_ varchar(4000);declare Department_String_Registered_By varchar(4000);
declare Search_Date_ varchar(200);declare User_Type_ int;declare curday int;declare Department_String_Reg_ varchar(4000);declare SearchbyName_Value varchar(2000);declare SearchbyName_Value_Register varchar(2000);declare SearchbyName_Value_Followup_ varchar(2000);
declare SearchbyName_Value_Application varchar(2000);
declare SearchbyName_Value_FollowUp varchar(2000);declare SearchbyName_Value_Task varchar(2000); DECLARE Search_Date_Registered_ VARCHAR(200);
DECLARE Search_Date_FollowUp VARCHAR(200);DECLARE Search_Date_Fees_ VARCHAR(200);DECLARE Search_Date_Application_ VARCHAR(200);DECLARE Search_Date_Task_ VARCHAR(200);DECLARE Search_by_type_ VARCHAR(200);
if Date_Value_=0 then
set Fromdate_=now();
set Todate_=now();
set curday=(SELECT DAY(Fromdate_)-1);
#set Fromdate_=(SELECT DATE_SUB(Fromdate_, INTERVAL curday DAY));
end if;

set SearchbyName_Value ='';set SearchbyName_Value_FollowUp ='';set SearchbyName_Value_Task ='';set Search_by_type_ ='';set SearchbyName_Value_Register ='';set SearchbyName_Value_Application='';
set Search_Date_Registered_ ='';set Search_Date_FollowUp ='';set Search_Date_Fees_ ='';set Search_Date_Application_ = '';set Search_Date_Task_ ='';
set Search_Date_='';set Department_String_Reg_ ='';set Department_String_='';set SearchbyName_Value_Followup_ ='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
set Department_String_Reg_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
if User_Id_ >0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",User_Id_);
    SET SearchbyName_Value_FollowUp =concat(SearchbyName_Value_FollowUp," and student_followup.User_Id =",User_Id_);
    SET SearchbyName_Value_Task =concat(SearchbyName_Value_Task," and Student_Task.To_User =",User_Id_);
    SET SearchbyName_Value_Register =concat(SearchbyName_Value_Register," and student.Registered_By =",User_Id_);
    SET SearchbyName_Value_Application =concat(SearchbyName_Value_Application," and application_details.To_User_Id =",User_Id_);
end if;
if Dept_Id_ >0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Dept_Id_);
    SET SearchbyName_Value_FollowUp =concat(SearchbyName_Value_FollowUp," and student_followup.Department =",Dept_Id_);
    SET SearchbyName_Value_Task =concat(SearchbyName_Value_Task," and Student_Task.Department_Id =",Dept_Id_);
    SET SearchbyName_Value_Register =concat(SearchbyName_Value_Register," and student.Followup_Department_Id =",Dept_Id_);
    SET SearchbyName_Value_Application =concat(SearchbyName_Value_Application," and student.Followup_Department_Id =",Dept_Id_);
end if;
if Branch_Id_ >0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_Id_);
    SET SearchbyName_Value_FollowUp =concat(SearchbyName_Value_FollowUp," and student_followup.Branch =",Branch_Id_);
    SET SearchbyName_Value_Task =concat(SearchbyName_Value_Task," and Student_Task.Branch_Id =",Branch_Id_);
    SET SearchbyName_Value_Register =concat(SearchbyName_Value_Register," and student.Followup_Branch_Id =",Branch_Id_);
    SET SearchbyName_Value_Application =concat(SearchbyName_Value_Application," and student.Followup_Branch_Id =",Branch_Id_);
end if;
if Department_Status_Id_ >0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status_Id =",Department_Status_Id_);
    SET SearchbyName_Value_FollowUp =concat(SearchbyName_Value_FollowUp," and student_followup.Status =",Department_Status_Id_);

end if;




/*if Is_Date_Check_=true then
if Date_value_=2 then
set Search_Date_=concat( SearchbyName_Value," and date(student.Entry_date) >= '", Fromdate_ ,"' and  date(student.Entry_date) <= '", Todate_,"'");
elseif Date_value_=1 then
set Search_Date_=concat( SearchbyName_Value," and date(student.Next_FollowUp_date) >= '", Fromdate_ ,"' and  date(student.Next_FollowUp_date) <= '", Todate_,"'");
end if;
ELSE
set Search_Date_= "and 1 =1 ";
end if;*/
#set Search_Date_=concat( " and date(student.Entry_Date) >=  '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
   if Date_Value_>0 then
SET Search_Date_ = CONCAT(" AND DATE(student.Entry_Date) >= '", Fromdate_, "' AND DATE(student.Entry_Date) <= '", Todate_, "'");
set Search_Date_Registered_=concat( " and date(student.Registered_On) >=  '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'");
SET Search_Date_FollowUp = concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
set Search_Date_Fees_=concat( " and date(Fees_Receipt.Entry_Date) >=  '", Fromdate_ ,"' and  date(Fees_Receipt.Entry_Date) <= '", Todate_,"'");
set Search_Date_Application_=concat( " and date(application_details.Date_Of_Applying) >=  '", Fromdate_ ,"' and  date(application_details.Date_Of_Applying) <= '", Todate_,"'");
set Search_Date_Task_=concat( " and date(Student_Task.Followup_Date) >=  '", Fromdate_ ,"' and date(Student_Task.Followup_Date) <= '", Todate_,"'");




     ELSE
set Search_Date_= "and 1 =1 ";
    set Search_Date_Registered_ = "and 1 =1 ";
    set Search_Date_FollowUp = concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
    set Search_Date_Fees_ = "and 1 =1 ";
    set Search_Date_Application_=  "and 1 =1 ";
    set Search_Date_Task_ = "and 1 =1 ";
end if;


if User_Type_=2 then
SET Department_String_ =concat(Department_String_Reg_," and student.To_User_Id =",Login_User_Id_);
        SET Department_String_Registered_By =concat(" and student.Registered_By =",Login_User_Id_);
else
SET Department_String_ =concat(Department_String_Reg_," and student.To_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
SET Department_String_Registered_By =concat(" and student.Registered_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;
    delete from data_log_;
set Department_String_To_User_ =REPLACE(Department_String_Reg_,'By_User_Id','To_User_Id');
    insert into data_log_ values (0,Department_String_To_User_,'dept string to user');



if User_Type_ =2 then

    SET Search_by_type_ =concat(Search_by_type_," or student.User_List like '%*",Login_User_Id_,"*%'");    
    SET SearchbyName_Value_Register =concat(SearchbyName_Value_Register," and student.Registered_By =",Login_User_Id_);
   
    SET SearchbyName_Value_Followup_ =concat(SearchbyName_Value_Followup_," and student.To_User_Id =",Login_User_Id_);
   
    #set Department_String_To_User_='';
end if;

#set Department_String_Registered_By =REPLACE(Department_String,'By_User_Id','Registered_By');
#insert into data_log_ values(0,Department_String_Reg_,'');
SET @query = Concat( "  
select 1 as tp,'',count(student.Student_Id) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_," ",SearchbyName_Value,"
#inner join user_details on user_details.User_Details_Id=student.To_User_Id
where student.DeleteStatus=0     ", Search_Date_ ,"
and (student.Role_Id in(",RoleId_,")  ",Search_by_type_,")
   union
select 2 as tp,'',count(student.Student_Id) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id   ",SearchbyName_Value_Register,"
inner join user_details on user_details.User_Details_Id=student.Registered_By
where student.DeleteStatus=0 and  student.Is_Registered=1   ",Search_Date_Registered_,"
and (student.Role_Id in(",RoleId_,")  ",Search_by_type_,")  
union

    select 3 as tp,'',count(student.Student_Id) as Data_Count from student
#inner join Department on Department.Department_Id= student.Followup_Department_Id  
#inner join user_details on user_details.User_Details_Id=student.To_User_Id
where student.DeleteStatus=0 and student.FollowUp=1  ",Department_String_To_User_,Search_Date_FollowUp," ",SearchbyName_Value," ",SearchbyName_Value_Followup_,"
and student.Role_Id in(",RoleId_,")
union
 select 4 as tp,'',COALESCE(sum(Fees_Receipt.Amount),0) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_," ",SearchbyName_Value,"
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join user_details on user_details.User_Details_Id=Fees_Receipt.User_Id
inner join Branch on Branch.Branch_Id= fees_receipt.Fee_Receipt_Branch
where student.DeleteStatus=0   and fees_receipt.Delete_Status=0 ", Search_Date_Fees_ ,"
and (student.Role_Id in(",RoleId_,")  ",Search_by_type_,")
union
select 5 as tp,'',COALESCE(count(student.Student_Id)) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,"
inner join application_details on application_details.Student_Id=student.Student_Id
inner join user_details on user_details.User_Details_Id=application_details.User_Id ",SearchbyName_Value_Application,"
where student.DeleteStatus=0  and application_details.DeleteStatus=0  
", Search_Date_Application_ ,"
and (student.Role_Id in(",RoleId_,")  ",Search_by_type_,")
union
select 6 as tp,'',COALESCE(count(Student_Task.Student_Task_Id)) as Data_Count from Student_Task
where Student_Task.DeleteStatus=0 and Task_Status=1 and (To_User =",Login_User_Id_," or By_User_Id =",Login_User_Id_," )  ", Search_Date_Task_,"
 ",SearchbyName_Value_Task,"


 union
select 7 as tp,'',COALESCE(count(student_followup.Status_Type_Id)) as Data_Count from student_followup
where student_followup.DeleteStatus=0 and  Department=372 and Status_Type_Id=1 ",SearchbyName_Value_FollowUp,"

 union
select 8 as tp,'',COALESCE(count(student_followup.Status_Type_Id)) as Data_Count from student_followup
where student_followup.DeleteStatus=0  and Department=372 and Status_Type_Id=2  ",SearchbyName_Value_FollowUp,"

 union
select 9 as tp,'',COALESCE(count(student.Student_Id)) as Data_Count from student
where student.DeleteStatus=0  ",Search_Date_FollowUp,"  and student.Role_Id in(",RoleId_,")


 union
select 10 as tp,'',COALESCE(count(student.Student_Id)) as Data_Count from student
where student.DeleteStatus=0  and student.Role_Id in(",RoleId_,")

#",Search_Date_,"

 order by tp
 ");
PREPARE QUERY FROM @query;
#select @query;

#insert into data_log_ value(0,@query,'query');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Comments`( In Student_Id_ Int)
Begin
SELECT Chat_Id,Chats,User_List,From_User_Name,DATE_FORMAT(comments.Entry_Date, '%d-%m-%Y %h:%i:%s %p') AS Entry_Date_Time
 From comments 
 where Student_Id =Student_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Comments`(In Chats_ json,Data_value_ int,tagged_users json,user_value_ int,taggedId_ json)
BEGIN

	declare messages_ longtext;declare Login_User_ int;declare Login_User_Name_ varchar(100);declare File_ varchar(1000);declare File_Name_ varchar(1000);
	declare Users_Id_ text;declare User_Details_Name_ text;declare Chat_Id_ int;declare Channel_Id_ int;declare Msg_Count_ int;declare TaggedUserId_Temp_ int;
    declare j int default 0;declare Notification_Id_ int;declare Notification_Type_Name_ varchar(20); declare To_User_Name_ varchar(200); declare Student_Id_ int;declare Application_Details_Id_ int;
	set Users_Id_ = '';set User_Details_Name_ = '';
	#insert into data_log_ values(0,taggedId_,'1');
	if( Data_value_>0) then
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Chats_,'$.message')) INTO messages_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Chats_,'$.From_User')) INTO Login_User_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Chats_,'$.From_User_Name')) INTO Login_User_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Chats_,'$.Display_File')) INTO File_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Chats_,'$.File_Name')) INTO File_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Chats_,'$.Channel_Id')) INTO Channel_Id_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Chats_,'$.Student_Id')) INTO Student_Id_;
    
			
		if(user_value_>0) then
			SELECT JSON_UNQUOTE (JSON_EXTRACT(tagged_users,'$.User_Id')) INTO Users_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(tagged_users,'$.User_Details_Name')) INTO User_Details_Name_;
            WHILE j < JSON_LENGTH(taggedId_) DO
				SELECT JSON_UNQUOTE (JSON_EXTRACT(taggedId_,CONCAT('$[',j,']'))) INTO TaggedUserId_Temp_;
                set To_User_Name_ = (select User_Details_Name from user_details where User_Details_Id = TaggedUserId_Temp_);
                SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
                set Notification_Type_Name_ = 'Tagged Comment';
				insert into notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,
                View_Status,Remark,Entry_Date,Student_Id,Student_Name,Read_Status,Entry_Type,Description,DeleteStatus)
				values(Notification_Id_,Login_User_,Login_User_Name_,TaggedUserId_Temp_,To_User_Name_,0,'',0,messages_,now(),0,'',0,17,Notification_Type_Name_,0);
			SELECT j + 1 INTO j;      
			END WHILE;
		end if;
		if (File_='' or File_='undefined' or File_Name_='undefined') then set File_ = '';set File_Name_= ''; end if;
		insert into comments (Chats,From_User,From_User_Name,Entry_Date,File_Name,Display_File,User_List,User_Ids,Channel_Id,DeleteStatus,Student_Id)
		values (messages_,Login_User_,Login_User_Name_,now(),File_,File_Name_,User_Details_Name_,Users_Id_,Channel_Id_,0,Student_Id_);
	end if;
		
	   set Chat_Id_ = (select last_insert_id());      
	   update channel_sub set Msg_Count = Msg_Count + 1,ReadStatus = 0 where Channel_Id = Channel_Id_ and User_Id != Login_User_;
     
	select Chat_Id_,messages_,Login_User_ as From_user_,Login_User_Name_ as From_User_Name_,File_ , (Date_Format(now(),'%d-%m-%Y   %h:%i')) As Date_,User_Details_Name_,File_Name_,Channel_Id_,Users_Id_;
    select taggedId_ as TaggedIn_;
	END$$
DELIMITER ;
