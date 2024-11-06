DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `AccountGroup_Typeahead`( In Group_Name_ varchar(100))
Begin 
 set Group_Name_ = Concat( '%',Group_Name_ ,'%');
 SELECT  Account_Group_Id,
Group_Name From Account_Group 
where Group_Name like Group_Name_ and DeleteStatus=false 
 ORDER BY Group_Name Asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Activate_Application`(In Application_details_Id_ int,Student_Id_ int,Intake_Id_ int,Intake_Name_ varchar(100),
Year_Id_ int,Year_Name_ varchar(100),Agent_Id_ int,Agent_Name_ varchar(100),Login_User_ int  )
BEGIN
declare To_User_ int;declare Student_Name_ varchar(45);declare  Status_Id_ int;declare Status_Name_ varchar(45);declare Remark_ varchar(500);declare Notification_Id_ int;
declare From_User_Name_ varchar(45);declare ToUser_Name_ varchar(45);
declare Notification_Count_ int;declare Notification_Type_Name_ varchar(45);declare  Entry_Type_ int;
Update application_details set Activation_Status = false where Student_Id = Student_Id_;
Update application_details_history set Activation_Status = false where Student_Id = Student_Id_;
Update application_details set Activation_Status = true where Application_details_Id = Application_details_Id_;
Update application_details_history set Activation_Status = true where Application_details_Id = Application_details_Id_;
Update student set Proceeding_Intake_Id = Intake_Id_,Proceeding_Intake_Name=Intake_Name_,Proceeding_Year_Id=Year_Id_,Proceeding_Year_Name=Year_Name_,
Proceeding_Partner_Id=Agent_Id_,Proceeding_Partner_Name=Agent_Name_ where Student_Id = Student_Id_;
set To_User_ =(select Admission_User from Student where Student_Id = Student_Id_ and DeleteStatus=false);
if Login_User_ !=To_User_ and To_User_>0 then 
	set Student_Name_ =(select Student_Name from Student where Student_Id = Student_Id_ and DeleteStatus=false);
	set Status_Id_ =(select Application_status_Id from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
	set Status_Name_ =(select Application_Status_Name from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
	set Remark_ =(select Remark from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
	set Entry_Type_ = 3;
	set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_ and DeleteStatus=false); 
	set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false); 
	set Notification_Type_Name_ = 'Activation/Deactivation';
	SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
	values(Notification_Id_,Login_User_,From_User_Name_,To_User_,ToUser_Name_,Status_Id_,Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);
	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_; 
end if;
select Application_details_Id_,Student_Name_,From_User_Name_,Notification_Type_Name_,Entry_Type_,To_User_,Notification_Id_,Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Agent_Login`( In User_Name_ VARCHAR(50),in Password_ VARCHAR(50))
BEGIN
SELECT 
Client_Accounts_Name,Client_Accounts_Id
From client_accounts 
 where 
 Client_Accounts_Name =User_Name_ and State=Password_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Agent_Typeahead`( In Client_Accounts_Name_ varchar(100))
Begin
 set Client_Accounts_Name_ = Concat( '%',Client_Accounts_Name_ ,'%');
select  client_accounts.Client_Accounts_Id,Client_Accounts_Name
From client_accounts
where Client_Accounts_Name like Client_Accounts_Name_  and client_accounts.DeleteStatus=false and Account_Group_Id=13
order by Client_Accounts_Name asc  limit 5  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Check_Agent_Mail`( In Email_ varchar(25))
Begin 
 SELECT Client_Accounts_Id, Client_Accounts_Name,State Password 
 From client_accounts where Email =Email_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Check_Duplicate_Student`(In Phone_Number_ varchar(25),Branch_Id_ int)
BEGIN
declare Student_Id_ int;declare Duplicate_Department_Name varchar(50);declare Duplicate_Remark_Name varchar(2000);
declare Duplicate_Department_Id_ int;declare Duplicate_Remark_Id_ int;declare Duplicate_FollowUp_Date datetime;
declare Duplicate_Registration int;declare Duplicate_Welcome_Status int;
declare Department_Status int;declare Duplicate_Student_Name varchar(25); declare Duplicate_User_Name varchar(25); declare Duplicate_User_Id int;
Set Student_Id_ = (select Student_Id from Student where  DeleteStatus=false and Student.Branch=Branch_Id_ and (Phone_Number like concat('%',Phone_Number_,'%')
        or Alternative_Phone_Number like concat('%',Phone_Number_,'%') or Whatsapp  like concat('%',Phone_Number_,'%') )  limit 1);
if(Student_Id_>0) then
		set Duplicate_User_Id = (select User_Id from Student where Student_Id = Student_Id_ and DeleteStatus=false );
		set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Student_Id_ and DeleteStatus=false);
		set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Student_Id_ and DeleteStatus=false);
		set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Student_Id_ and DeleteStatus=false );
		set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
		set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
		set Duplicate_Remark_Name=(select Remark from student where Student_Id = Student_Id_ and DeleteStatus=false);
		set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
end if;

select Student_Id_,Duplicate_Student_Name,Duplicate_User_Name,(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y ')) as Duplicate_FollowUp_Date
,Duplicate_Department_Name,Duplicate_Remark_Name,Duplicate_Registration,Duplicate_Welcome_Status,Department_Status;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Check_Student_Mail`( In Email_ varchar(25))
Begin 
 SELECT Student_Id, Student_Name,Password 
 From student where Email =Email_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Account_Group`( In Account_Group_Id_ Int)
Begin 
	declare DeleteStatus_ bit;
	if exists(select Client_Accounts.Account_Group_Id  from Client_Accounts where DeleteStatus=False and Account_Group_Id =Account_Group_Id_ )
	then
		set DeleteStatus_=0;
	else
		update Account_Group set DeleteStatus=true where Account_Group_Id =Account_Group_Id_ ;
		set DeleteStatus_=1;
	end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Agent`( In Client_Accounts_Id_ Int)
Begin 

  declare DeleteStatus_ bit;

update Client_Accounts set DeleteStatus=True where Client_Accounts.Client_Accounts_Id=Client_Accounts_Id_;
update Employee_Details set DeleteStatus=true where Client_Accounts_Id =Client_Accounts_Id_ ;
#update Employee_Location set DeleteStatus=true where Client_Accounts_Id =Client_Accounts_Id_ ;
set DeleteStatus_=True;

select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Agent_Details`( In Agent_Id_ Int)
Begin 
 update agent set DeleteStatus=true where Agent_Id = Agent_Id_ ;
 select Agent_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Application_Details`( In Application_details_Id_ Int)
Begin 
 Declare DeleteStatus_ tinyint; 
	update application_details set DeleteStatus=true where Application_details_Id =Application_details_Id_ ;
	update application_details_history set DeleteStatus=true where Application_details_Id =Application_details_Id_ ;
	update application_document set DeleteStatus=true where Application_details_Id =Application_details_Id_ ;
 set DeleteStatus_=1; 
 select DeleteStatus_; 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Application_Document`( In Application_Document_Id_ Int)
Begin 
 update application_document set DeleteStatus=true where Application_Document_Id =Application_Document_Id_ ;
 select Application_Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Application_History`( In Application_details_history_Id_ Int)
Begin 
 Declare DeleteStatus_ tinyint; 
	 update application_details_history set DeleteStatus=true where Application_details_history_Id =Application_details_history_Id_ ;
 set DeleteStatus_=1; 
 select DeleteStatus_; 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Application_Status`( In Application_status_Id_ Int)
Begin 
 update application_status set DeleteStatus=true where Application_status_Id =Application_status_Id_ ;
 select Application_status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Branch`( In Branch_Id_ Int)
Begin 
 update Branch set Is_Delete=true where Branch_Id =Branch_Id_ ;
 SELECT Branch_Id  From Branch where Branch_Id =Branch_Id_  ;
 
 delete from Branch_Department where Branch_id=Branch_Id_;
 select Branch_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Checklist`( In Checklist_Id_ Int)
Begin 
  declare DeleteStatus_ tinyint;
/*if exists 
	(select student.Sub_Status_Id  from student where Sub_Status_Id =Sub_Status_Id_ and  DeleteStatus=False)
    then

	set DeleteStatus_=0;
else*/
update Checklist set DeleteStatus=true where Checklist_Id =Checklist_Id_ ;

 set DeleteStatus_=1;
#end if;
 
 select DeleteStatus_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Check_List`( In Check_List_Id_ Int)
Begin 
 update check_list set DeleteStatus=true where Check_List_Id =Check_List_Id_ ;
 select Check_List_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Client_Accounts`( In Client_Accounts_Id_ Int)
Begin 

  declare DeleteStatus_ bit;

update Client_Accounts set DeleteStatus=True where Client_Accounts.Client_Accounts_Id=Client_Accounts_Id_;
update Employee_Details set DeleteStatus=true where Client_Accounts_Id =Client_Accounts_Id_ ;
#update Employee_Location set DeleteStatus=true where Client_Accounts_Id =Client_Accounts_Id_ ;
set DeleteStatus_=True;

select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Company`( In Company_Id_ Int)
Begin 
 update Company set Is_Delete=true where Company_Id =Company_Id_ ;
 SELECT Company_Id  From Company where Company_Id =Company_Id_  ;
 select Company_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Country`( In Country_Id_ Int)
Begin 
 update Country set DeleteStatus=true where Country_Id =Country_Id_ ;
 select Country_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course`( In Course_Id_ Int)
Begin 
 update Course set DeleteStatus=true where Course_Id =Course_Id_ ;
 select Course_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course_Intake`( In Course_Intake_Id_ Int)
Begin 
 update Course_Intake set DeleteStatus=true where Course_Intake_Id =Course_Intake_Id_ ;
 select Course_Intake_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Data`()
BEGIN
declare DeleteStatus_ bit;
		delete from student ;
        delete from student_followup ;
		delete from student_course_selection;
        delete from fees_receipt;
		delete from feesreceipt_document;
        delete from application_details;
		delete from application_details_history;
        delete from visa;
        delete from visa_document;
		delete from qualification;
        delete from work_experience;
		delete from pre_visa;
		delete from review;
		delete from ielts_details;
        delete from student_task;
        delete from notification;
          
          
        set DeleteStatus_=1;
	select DeleteStatus_ as Deletefiles;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Department`( In Department_Id_ Int)
Begin 
 update Department set Is_Delete=true where Department_Id =Department_Id_ ;
 SELECT Department_Id  From Department where Department_Id =Department_Id_  ;
delete from Status_Selection where department_id=Department_Id_;
 select Department_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Department_Status`( In Department_Status_Id_ Int)
Begin 
 update Department_Status set Is_Delete=true where Department_Status_Id =Department_Status_Id_ ;
 SELECT Department_Status_Id  From Department_Status where Department_Status_Id =Department_Status_Id_  ;
 select Department_Status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Document`( In Document_Id_ Int)
Begin 
 update Document set DeleteStatus=true where Document_Id =Document_Id_ ;
 select Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_DocumentName`( In Document_Id_ Int)
Begin 
 update document set DeleteStatus=true where Document_Id =Document_Id_ ;
 select Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Duration`( In Duration_Id_ Int)
Begin 
 update Duration set DeleteStatus=true where Duration_Id =Duration_Id_ ;
 select Duration_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Enquiry_Source`( In Enquiry_Source_Id_ Int)
Begin 
 update Enquiry_Source set DeleteStatus=true where Enquiry_Source_Id =Enquiry_Source_Id_ ;
 select Enquiry_Source_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Fees`( In Fees_Id_ Int)
Begin 
 update fees set DeleteStatus=true where Fees_Id =Fees_Id_ ;
 select Fees_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_FeesRecepit_Document`( In Feesreceipt_document_Id_ Int)
Begin 
 update feesreceipt_document set DeleteStatus=true where Feesreceipt_document_Id =Feesreceipt_document_Id_ ;
 select Feesreceipt_document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Ielts_Details`( In Ielts_Details_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
 update Ielts_Details set DeleteStatus=true where Ielts_Details_Id =Ielts_Details_Id_ ;
  set DeleteStatus_=1;
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Intake`( In Intake_Id_ Int)
Begin 
 update Intake set DeleteStatus=true where Intake_Id =Intake_Id_ ;
 select Intake_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Internship`( In Internship_Id_ Int)
Begin 
 update Internship set DeleteStatus=true where Internship_Id =Internship_Id_ ;
 select Internship_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Invoice`( In Invoice_Id_ Int)
Begin
 update Invoice set DeleteStatus=true where Invoice_Id =Invoice_Id_ ;
 update Invoice_document set DeleteStatus=true where Invoice_Id =Invoice_Id_ ;
 select Invoice_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Invoice_Document`( In Invoice_Document_Id_ Int)
Begin
 update Invoice_document set DeleteStatus=true where Invoice_Document_Id =Invoice_Document_Id_ ;
 select Invoice_Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Level_Detail`( In Level_Detail_Id_ Int)
Begin 
 update Level_Detail set DeleteStatus=true where Level_Detail_Id =Level_Detail_Id_ ;
 select Level_Detail_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_News_Document`( In News_Document_Id_ Int)
Begin 
 update news_document set DeleteStatus=true where News_Document_Id =News_Document_Id_ ;
 select News_Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Pre_Admission`( In Student_Preadmission_Checklist_Master_Id_ Int)
Begin 
  update student_preadmission_checklist_master set DeleteStatus=true where Student_Preadmission_Checklist_Master_Id =Student_Preadmission_Checklist_Master_Id_ ;
delete from student_preadmission_checklist_details where Student_Preadmission_Checklist_Master_Id=Student_Preadmission_Checklist_Master_Id_;
 select Student_Preadmission_Checklist_Master_Id_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Pre_Visa`( In Student_Checklist_Master_Id_ Int)
Begin 
  update Student_Checklist_Master set DeleteStatus=true where Student_Checklist_Master_Id =Student_Checklist_Master_Id_ ;
delete from Student_Checklist_Details where Student_Checklist_Master_Id=Student_Checklist_Master_Id_;
 select Student_Checklist_Master_Id_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Qualificationdetails`( In Qualification_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
 update qualification set DeleteStatus=true where Qualification_Id =Qualification_Id_ ;
   set DeleteStatus_=1;
 select DeleteStatus_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Receipt`( In Fees_Receipt_Id_ Int,Application_details_Id_ int)
Begin 
declare Application_Fees_Paid_ int;declare Fees_Name_ varchar(200);declare Fees_Id_ int;declare Old_Application_details_Id_ int;declare Old_Amount_ varchar(200);

 update fees_receipt set Delete_Status=true where Fees_Receipt_Id =Fees_Receipt_Id_ ;
 
 
 set  Application_Fees_Paid_ = (select Application_Fees_Paid from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus = 0 );

#set Fees_Name_ = (select Fees_Name from fees where Fees_Id = Fees_Id_ and DeleteStatus = 0 );
if(Fees_Receipt_Id_>0) then
	select amount,Application_details_Id into Old_Amount_,Old_Application_details_Id_ from fees_receipt Where Fees_Receipt_Id=Fees_Receipt_Id_;
    
    if(Old_Application_details_Id_>0) then
	update application_details set Application_Fees_Paid=Application_Fees_Paid-Old_Amount_ where Application_details_Id=Old_Application_details_Id_;
     end if;
 	 end if;
 
 
 select Fees_Receipt_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Refund_Request`( In Refund_Request_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
 update refund_request set Delete_Status=true where Refund_Request_Id =Refund_Request_Id_ ;
   set DeleteStatus_=1;
 select DeleteStatus_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Remarks`( In Remarks_Id_ Int)
Begin 
 update Remarks set DeleteStatus=true where Remarks_Id =Remarks_Id_ ;
 select Remarks_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Review`( In Review_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
 update review set DeleteStatus=true where Review_Id =Review_Id_ ;
   set DeleteStatus_=1;
 select DeleteStatus_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student`( In Student_Id_ Int)
Begin 
update Student set DeleteStatus=true where Student_Id =Student_Id_ ;
update student_followup set DeleteStatus=true where Student_Id =Student_Id_ ;
if exists(select Student_Id from application_details where  DeleteStatus=0 ) then 
	update application_details set DeleteStatus = true where Student_Id = Student_Id_;
    update application_details_history set DeleteStatus = true where Student_Id = Student_Id_;
end if;
if exists(select Student_Id from fees_receipt where  Delete_Status=0 ) then 
	update fees_receipt set Delete_Status = true where Student_Id = Student_Id_;
end if;
if exists(select Student_Id from visa where  DeleteStatus=0 ) then 
	update visa set DeleteStatus = true where Student_Id = Student_Id_;
end if;

if exists(select Student_Id from Student_Task where  DeleteStatus=0 ) then 
	update Student_Task set DeleteStatus = true where Student_Id = Student_Id_;
end if;
if exists(select Student_Id from student_task_followup where  DeleteStatus=0 ) then 
	update student_task_followup set DeleteStatus = true where Student_Id = Student_Id_;
end if;

if exists(select Student_Id from notification where  DeleteStatus=0 ) then 
	update notification set DeleteStatus = true where Student_Id = Student_Id_;
end if;

select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Document`( In Student_Document_Id_ Int)
Begin 
 update Student_Document set DeleteStatus=true where Student_Document_Id =Student_Document_Id_ ;
 select Student_Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_File`( In Student_Id_ Int, File_Name_ varchar(100) )
Begin 
if File_Name_='Passport_Copy'
then
 update Student set Passport_Copy='', Passport_Copy_File_Name='' where Student_Id =Student_Id_ ;
 elseif File_Name_='IELTS' then
 update Student set IELTS='' , IELTS_File_Name='' where Student_Id =Student_Id_ ;
 elseif File_Name_='Passport_Photo' then
 update Student set Passport_Photo='',Passport_Photo_File_Name=''  where Student_Id =Student_Id_ ;
 elseif File_Name_='Tenth_Certificate' then
 update Student set Tenth_Certificate='' ,Tenth_Certificate_File_Name=''  where Student_Id =Student_Id_ ;
 elseif File_Name_='Work_Experience' then
 update Student set Work_Experience='' ,Work_Experience_File_Name='' where Student_Id =Student_Id_ ;
 elseif File_Name_='Resume' then
 update Student set Resume='', Resume_File_Name=''  where Student_Id =Student_Id_ ;
 end if;
 
 select Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Message`( In Student_Message_Id_ Int)
Begin 
 update Student_Message set DeleteStatus=true where Student_Message_Id =Student_Message_Id_ ;
 select Student_Message_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Report`( In Student_ JSON)
Begin 
declare Student_Id_J int;declare i int;
set i=0;
WHILE i < JSON_LENGTH(Student_) DO
	#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Id')) INTO Student_Id_J; 
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,CONCAT('$[',i,'].Student_Id'))) INTO Student_Id_J;
  
		if( Student_Id_J>0 ) then
			update student_followup set DeleteStatus=1 where Student_Id= Student_Id_J ; 
			
            Update student set DeleteStatus=1 where Student_Id=Student_Id_J;
	    end if;
	SELECT i + 1 INTO i;  
end while;    
 select Student_Id_J;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Status`( In Student_Status_Id_ Int)
Begin 
 update Student_Status set DeleteStatus=true where Student_Status_Id =Student_Status_Id_ ;
 select Student_Status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Subject`( In Subject_Id_ Int)
Begin 
 update Subject set DeleteStatus=true where Subject_Id =Subject_Id_ ;
 select Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Sub_Section`( In Sub_Section_Id_ Int)
Begin 
 update Sub_Section set DeleteStatus=true where Sub_Section_Id = Sub_Section_Id_ ;
 select Sub_Section_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Sub_Status`( In Sub_Status_Id_ Int)
Begin 
  declare DeleteStatus_ tinyint;
/*if exists 
	(select student.Sub_Status_Id  from student where Sub_Status_Id =Sub_Status_Id_ and  DeleteStatus=False)
    then

	set DeleteStatus_=0;
else*/
update sub_status set DeleteStatus=true where Sub_Status_Id =Sub_Status_Id_ ;

 set DeleteStatus_=1;
#end if;
 
 select DeleteStatus_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Task`( In Task_Id_ Int)
Begin 
 update task set DeleteStatus=true where Task_Id =Task_Id_ ;
 SELECT Task_Id  From task where Task_Id =Task_Id_  ;
 select Task_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Tasknew`( In Student_Task_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
 update student_task set DeleteStatus=true where Student_Task_Id =Student_Task_Id_ ;
  set DeleteStatus_=1;
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Task_Item`( In Task_Item_Id_ Int)
Begin 
 update task_item set Delete_Status=true where Task_Item_Id =Task_Item_Id_ ;
 select Task_Item_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_University`( In University_Id_ Int)
Begin 
 update University set DeleteStatus=true where University_Id =University_Id_ ;
 update University_Photos set DeleteStatus=true where University_Id =University_Id_ ;
 select University_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_User_Details`( In User_Details_Id_ Int)
Begin 
declare Old_Department_ int;declare Current_Slno_ int;
declare By_User_count int;declare To_User_count int;
declare Total_User_count_ int;declare Current_User_Index_ int;
set By_User_count = (SELECT  COALESCE( count(By_User_Id ),0) FROM student_followup where DeleteStatus=false and By_User_Id=User_Details_Id_);
set To_User_count = (SELECT  COALESCE( count(User_Id ),0) FROM student_followup where DeleteStatus=false and User_Id=User_Details_Id_ );
if(By_User_count = 0 && To_User_count = 0) then





set  Old_Department_=(select Department_Id from user_details where User_Details_Id = User_Details_Id_);
set  Total_User_count_=(select Total_User from department where  Department_Id=Old_Department_);
set Current_User_Index_ =(select Current_User_Index from department where  Department_Id=Old_Department_);
set Current_Slno_=(select Sub_Slno from user_details where User_Details_Id = User_Details_Id_);




	if Current_Slno_= Current_User_Index_ then
		if Current_Slno_= Total_User_count_ then
			UPDATE user_details set Sub_Slno=Sub_Slno-1 where Sub_Slno>Current_Slno_ and
			user_details.Department_Id=Old_Department_;
			update department set Current_User_Index=1 where Department_Id=Old_Department_;
		else
			UPDATE user_details set Sub_Slno=Sub_Slno-1 where Sub_Slno>Current_Slno_ and
			user_details.Department_Id=Old_Department_;
		end if;
	elseif Current_Slno_< Current_User_Index_ then
		#update department set Current_User_Index=Current_User_Index+1;
        update department set Current_User_Index=Current_User_Index-1 where Department_Id=Old_Department_;
        UPDATE user_details set Sub_Slno=Sub_Slno-1 where Sub_Slno>Current_Slno_ and
		user_details.Department_Id=Old_Department_;
	else
		UPDATE user_details set Sub_Slno=Sub_Slno-1 where Sub_Slno>Current_Slno_ and
		user_details.Department_Id=Old_Department_;
	end if;

	update User_Menu_Selection set DeleteStatus=true where User_Id =User_Details_Id_ ;
	update user_department set Is_Delete=true where User_Id =User_Details_Id_ ;
	update User_Details set DeleteStatus=true where User_Details_Id =User_Details_Id_ ;
    
    
    
        update department set Total_User=Total_User-1 where Department_Id=Old_Department_;
        update user_details set Sub_Slno=0 where User_Details_Id=User_Details_Id_;
        

        
        
	set User_Details_Id_ =1;
 else
	 set User_Details_Id_ =-2;
end if;
	select User_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_User_Role`( In User_Role_Id_ Int)
Begin 
	declare DeleteStatus_ bit;
	if exists(select user_details.Role_Id  from user_details where DeleteStatus=False and Role_Id =User_Role_Id_ )
	then
		set DeleteStatus_=0;
	else
		update user_role set Is_Delete=true where User_Role_Id =User_Role_Id_ ;
		set DeleteStatus_=1;
	end if;
select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Visa`( In Visa_Id_ Int)
Begin
 update visa set DeleteStatus=true where Visa_Id =Visa_Id_ ;
 update visa_document set DeleteStatus=true where Visa_Id =Visa_Id_ ;
 select Visa_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Visa_Document`( In Visa_Document_Id_ Int)
Begin
 update visa_document set DeleteStatus=true where Visa_Document_Id =Visa_Document_Id_ ;
 select Visa_Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Visa_Task`( In Student_Task_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
 update student_task set DeleteStatus=true where Student_Task_Id =Student_Task_Id_ ;
  set DeleteStatus_=1;
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Workexperiencedetails`( In Work_Experience_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
 update work_experience set DeleteStatus=true where Work_Experience_Id =Work_Experience_Id_ ;
  set DeleteStatus_=1;
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Dropdown_Branch`( )
BEGIN

SELECT 
Branch_Id,Branch_Name
From Branch
 where Is_Delete=false
ORDER BY Branch_Name ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Dropdown_Department`()
BEGIN
SELECT 
Department_Id,Department_Name
From Department where Is_Delete=0
 
ORDER BY Department_Name ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Dropdown_Users`()
BEGIN
SELECT 
User_Details_Id,User_Details_Name
From user_details
 where DeleteStatus=false
ORDER BY User_Details_Name ASC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Fees_Typeahead`( In Fees_Name_ varchar(100))
Begin
 set Fees_Name_ = Concat( '%',Fees_Name_ ,'%');
select  fees.Fees_Id,Fees_Name
From fees
where Fees_Name like Fees_Name_  and fees.DeleteStatus=false
order by Fees_Name asc  limit 5  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `FollowUp_Summary`(In  By_User_ int,Login_User_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare User_Type_ int;declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
declare SearchbyName_Value varchar(2000);declare Department_String_To_User_ varchar(4000);
set SearchbyName_Value='';
set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;
if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;
set Department_String_To_User_ =REPLACE(Department_String_,'By_User_Id','To_User_Id');
#insert into data_log_ values(0,Department_String_To_User_,'');",Department_String_To_User_," and student.Role_Id in(",RoleId_,")
SET @query = Concat( "select  To_User_Name To_Staff,count(student.Student_Id) as Pending,To_User_Id User_Details_Id
from student 
where student.DeleteStatus=0 and FollowUp=1  ",SearchbyName_Value," ",Search_Date_, "  
group by student.To_User_Id,To_User_Name
order by Next_FollowUp_Date asc ");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
#select @query;
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Account_Group`( In Account_Group_Id_ Int)
Begin 
 SELECT Account_Group_Id,
Primary_Id,
Group_Code,
Group_Name,
Link_Left,
Link_Right,
Under_Group,
IsPrimary,
CanDelete,
UserId From Account_Group where Account_Group_Id =Account_Group_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Agent`( In Client_Accounts_Id_ Int)
Begin 
 SELECT 
Address1,Address2,
 Address3,Address4,Mobile
From Client_Accounts 
where Client_Accounts_Id =Client_Accounts_Id_ and Client_Accounts.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_AllTime_Dept`(In User_Id_ int)
BEGIN
	select Department_Id from All_Time_Departments where User_Id = User_Id_ and DeleteStatus = 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_All_Notification`(In Date_ date,User_Id_ int,login_Id_ int)
BEGIN
declare To_Date_ date;
set To_Date_=CURDATE() ;
select Description as Notification_Type_Name,From_User_Name,Student_Name ,Entry_Type,Notification_Id,Student_Id from
notification where ifnull(Read_Status,0) != 1 and DeleteStatus =0 and To_User = login_Id_  
order by Notification_Id limit 10;
select count(Notification_Id) as Counts from notification where ifnull(Read_Status,0) != 1 and DeleteStatus =0 and To_User = login_Id_  
order by Notification_Id;
select count(Student_Task_Id) as Student_Task_Count from Student_Task  where DeleteStatus=0
and Student_Task.Task_Status =1 and To_User =login_Id_ and
 date(Student_Task.Followup_Date) <= To_Date_ ;
 select Updated_Serial_Id from user_details where User_Details_Id = login_Id_ and DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_All_Time_department_Edit`( In User_Details_Id_ Int)
Begin 
SELECT department.Department_Id ,department.Department_Name,
case when all_time_departments.View>0 then 1 else 0 end as checkbox_view
From department 
left join all_time_departments on  department.Department_Id=all_time_departments.Department_Id
and User_Id =User_Details_Id_ where department.Is_Delete=false order by department.Department_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_ApplicationDetails`( In Student_Id_ Int)
Begin
SELECT Application_details_Id ,Student_Id,Country_Id,Application_Source,
 Country_Name,University_Id,University_Name,Course_Id,Course_Name,intake_Id,
 intake_Name,Intake_Year_Id,Intake_Year_Name,Student_Reference_Id,Application_No,
 Date_Of_Applying, (Date_Format(Date_Of_Applying,'%d-%m-%y')) as Grid_Date ,Remark,Application_status_Id,
 Application_Status_Name,Agent_Id,Agent_Name,Reference_No,Activation_Status,Course_Fee,Living_Expense,Preference,Student_Approved_Status,
 Student_Approve_Status.Status_Name as Status_Name_Approval,Bph_Approved_Status,
 bph_status.Bph_Status_Name as Bph_Status_Name,Paid_Status,Application_Fees_Paid,Portal_User_Name,Password,Offer_Student_Id,Fees_Payment_Last_Date,
 IFNULL(Feespaymentcheck, 0) as Feespaymentcheck, IFNULL(Offer_Received, 0) as Offer_Received,Duration_Id,url
 From application_details 
 inner join Student_Approve_Status on Student_Approve_Status.Student_Approve_Status_Id = application_details.Student_Approved_Status
  inner join bph_status on bph_status.Bph_Status_Id = application_details.Bph_Approved_Status
 where Student_Id =Student_Id_ and application_details.DeleteStatus=false ;
 /*select Application_Document_Id,File_Name,Document_Name,0 New_Entry, 
 Document_File_Name,application_document.Application_details_Id from application_document
 inner join application_details on application_details.Student_Id = application_document.Student_Id
 where application_document.Student_Id =Student_Id_ and application_document.DeleteStatus=false order by Document_Id;*/
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_ApplicationDetailswise_History`( In Application_details_Id_ Int,Feesdetails_Id_ int)
Begin
 SELECT  Application_details_history_Id,Application_details_Id,Student_Id,Country_Id,
 Country_Name,University_Id,University_Name,Course_Id,Course_Name,intake_Id,
 intake_Name,Intake_Year_Id,Intake_Year_Name,
 Date_Of_Applying, (Date_Format(Date_Of_Applying,'%d-%m-%Y')) as Grid_Date ,Remark,Application_status_Id,Application_Fees_Paid,Bph_Approved_Status,
 Application_Status_Name,Agent_Id,Agent_Name,Activation_Status,Course_Fee,Living_Expense,Student_Approved_Status,Student_Approve_Status.Status_Name as Status_Name_Approval,bph_status.Bph_Status_Name as Bph_Status_Name
 From application_details_history 
 inner join Student_Approve_Status on Student_Approve_Status.Student_Approve_Status_Id = application_details_history.Student_Approved_Status
  inner join bph_status on bph_status.Bph_Status_Id = application_details_history.Bph_Approved_Status
 where Application_details_Id =Application_details_Id_ and application_details_history.DeleteStatus=false
   

 Order by Application_details_history_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_ApplicationDetails_History`( In Student_Id_ Int)
Begin
 SELECT  Application_details_history_Id,Application_details_Id,Student_Id,Country_Id,
 Country_Name,University_Id,University_Name,Course_Id,Course_Name,intake_Id,
 intake_Name,Intake_Year_Id,Intake_Year_Name,
 Date_Of_Applying, (Date_Format(Date_Of_Applying,'%d-%m-%Y')) as Grid_Date ,Remark,Application_status_Id,
 Application_Status_Name,Agent_Id,Agent_Name,Activation_Status,Course_Fee,Living_Expense
 From application_details_history where Student_Id =Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_Dashboard_Count`(In RoleId_ varchar(100),Department_String_ varchar(4000),Login_User_Id_ int)
BEGIN
declare Fromdate_ date;declare Todate_ date;declare Department_String_To_User_ varchar(4000);declare Department_String_Registered_By varchar(4000);
declare Search_Date_ varchar(200);declare User_Type_ int;declare curday int;declare Department_String_Reg_ varchar(4000);
set Fromdate_=now();
set Todate_=now();
set curday=(SELECT DAY(Fromdate_)-1);
set Fromdate_=(SELECT DATE_SUB(Fromdate_, INTERVAL curday DAY));
set Search_Date_='';set Department_String_Reg_ ='';set Department_String_='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);

set Department_String_Reg_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);

set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
	if User_Type_=2 then
		SET Department_String_ =concat(Department_String_Reg_," and student.To_User_Id =",Login_User_Id_);
        SET Department_String_Registered_By =concat(" and student.Registered_By =",Login_User_Id_);
	else
		SET Department_String_ =concat(Department_String_Reg_," and student.To_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
		distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
		SET Department_String_Registered_By =concat(" and student.Registered_By in (select User_Details_Id from user_details where Branch_Id in (select
		distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
	end if;
set Department_String_To_User_ =REPLACE(Department_String_Reg_,'By_User_Id','To_User_Id');
#set Department_String_Registered_By =REPLACE(Department_String,'By_User_Id','Registered_By');
#insert into data_log_ values(0,Department_String_Reg_,'');
SET @query = Concat( "  
select 1 as tp,count(application_details.Application_details_Id) as Data_Count from application_details
where application_details.DeleteStatus=0  and application_details.Application_status_Id=38    and date(application_details.Date_Of_Applying) >= '", Fromdate_ ,"' 
and  date(application_details.Date_Of_Applying) <= '", Todate_,"'

   union
select 2 as tp,count(application_details.Application_details_Id) as Data_Count from application_details
where application_details.DeleteStatus=0 and  application_details.Application_status_Id=21   
   and date(application_details.Date_Of_Applying) >= '", Fromdate_ ,"'
 and  date(application_details.Date_Of_Applying) <= '", Todate_,"'

union
    select 3 as tp,count(student.Student_Id) as Data_Count from student
#inner join Department on Department.Department_Id= student.Followup_Department_Id  
#inner join user_details on user_details.User_Details_Id=student.To_User_Id
where student.DeleteStatus=0 and student.FollowUp=1  ",Department_String_To_User_," and date(student.Next_FollowUp_Date) <'",  Todate_,"'
and student.Role_Id in(",RoleId_,")
union

 select 4 as tp,COALESCE(sum(Fees_Receipt.Amount),0) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,"
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join user_details on user_details.User_Details_Id=Fees_Receipt.User_Id
where student.DeleteStatus=0   and fees_receipt.Delete_Status=0 and date(Fees_Receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(Fees_Receipt.Entry_Date) <= '", Todate_,"'
and user_details.Role_Id in(",RoleId_,")

union
select 5 as tp,COALESCE(count(student.Student_Id)) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,"
inner join application_details_history on application_details_history.Student_Id=student.Student_Id
inner join user_details on user_details.User_Details_Id=application_details_history.User_Id
where student.DeleteStatus=0  and application_details_history.DeleteStatus=0  and application_details_history.Application_status_Id=9  and date(application_details_history.Date_Of_Applying) >= '", Fromdate_ ,"' and  date(application_details_history.Date_Of_Applying) <= '", Todate_,"'
and user_details.Role_Id in(",RoleId_,")

union
select 6 as tp,COALESCE(count(Student_Task.Student_Task_Id)) as Data_Count from Student_Task
where Student_Task.DeleteStatus=0 and Task_Status=1


order by tp
    ");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_DocumentList`( In Application_details_Id_ Int)
Begin
select Application_Document_Id,ApplicationFile_Name,ApplicationDocument_Name,0 New_Entry, 
 ApplicationDocument_File_Name,application_document.Application_details_Id from application_document
 where Application_details_Id =Application_details_Id_ and DeleteStatus=false order by ApplicationDocument_Id;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_Group`()
BEGIN
select Application_Group_Id,Application_Group_Name,0 as View from application_group where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_Group_Edit`( In User_Details_Id_ Int)
Begin 
SELECT application_group.Application_Group_Id ,application_group.Application_Group_Name,
case when user_application_group.View>0 then 1 else 0 end as View
From application_group 
left join user_application_group on  application_group.Application_Group_Id=user_application_group.Application_Group_Id
and User_Id =User_Details_Id_ where application_group.DeleteStatus=false order by application_group.Application_Group_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_Settings`()
BEGIN
select * from application_settings where DeleteStatus=0 and  Editable=1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_Status`()
BEGIN
select * from application_status where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_Status_Edit`( In User_Details_Id_ Int)
Begin 
SELECT application_status.Application_status_Id ,application_status.Application_Status_Name,
case when user_application_status.View>0 then 1 else 0 end as View
From application_status 
left join user_application_status on  application_status.Application_status_Id=user_application_status.Application_Status_Id
and User_Id =User_Details_Id_ where application_status.DeleteStatus=false order by application_status.Application_status_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Branch_Department_Edit`( In Branch_Id_ Int)
Begin 
 SELECT distinct( Department.Department_Id) ,
 Department.Department_Name,
#Default_Department_Id,Default_Department_Name,
 #Default_User_Id,Default_User_Name,
 case when Branch_Department.Department_Id>0 then 1 else 0 end as Check_Box
  From Department 
  #left join branch on branch.Default_Department_Id=Department.Department_Id
  left join user_details on user_details.Department_Id=Department.Department_Id
   left join Branch_Department on
  Department.Department_Id=Branch_Department.Department_Id
  and Branch_Department.Branch_Id =Branch_Id_ where 
  Department.Is_Delete=false order by Department_Order ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Checklist`()
Begin
 SELECT Check_List_Id,Check_List_Name,Applicable,Checklist_Status
 From check_list
 where DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Checklist_Country`(in Country_Id_ int)
BEGIN
select * from Checklist
where DeleteStatus=0 and Country_Id=Country_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Check_List`( In Check_List_Id_ Int)
Begin 
 SELECT Check_List_Id,
Check_List_Name From check_list where Check_List_Id =Check_List_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Client_Accounts`( In Client_Accounts_Id_ Int)
Begin 
 SELECT 
Address1,Address2,
 Address3,Address4,Mobile
From Client_Accounts 
where Client_Accounts_Id =Client_Accounts_Id_ and Client_Accounts.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Company`()
Begin 
 SELECT Company_Id ,
companyname ,
Phone1 ,
Phone2 ,
Mobile ,
Website,
Email,
Address1,
Address2,
Address3,
Logo
 From Company where  Is_Delete=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Country`( In Country_Id_ Int)
Begin 
 SELECT Country_Id,
Country_Name From Country where Country_Id =Country_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course`( In Course_Id_ Int)
Begin 
 SELECT Course_Id,
Course_Name,
Subject_Id,
Sub_Section_Id ,
Duration_Id,
Level_Id,
Ielts_Minimum_Score,
Internship_Id,
Notes,
Details,
Application_Fees,
Tution_Fees ,
Entry_Requirement,
Living_Expense,
Work_Experience,
IELTS_Name,
Intake_Name,
University_Id,
Country_Id,
Tag,
Course_Status,
Intake_Name,
Tution_Fees,
Entry_Requirement,
IELTS_Name,
Duration,
Living_Expense,
Work_Experience,
Registration_Fees,
Date_Charges,
Bank_Statements,
Insurance,
VFS_Charges,
Apostille,
Other_Charges
 From Course where Course_Id =Course_Id_ and DeleteStatus=false ;

  SELECT  case when  Intake_Status=1 then true else false end as Intake_Status , case when  Course_intake_id>0 then true else false end as Intake_Selection
  ,Intake_Name,intake.Intake_Id from Intake left join  course_intake on course_intake.Intake_Id=intake.Intake_Id
  and course_intake.course_id =course_id_
  order by Intake_Name ;
  
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Import`( In Import_Master_Id_ Int)
Begin 
 SELECT 
Course_Name Course,
Subject_Name Subject,
Duration_Name Duration ,
Level_Id Level,
Ielts_Minimum_Score Ielts,
Internship_Name Internship,
Notes,
Details,
Application_Fees Fees,
University_Name University,
Country_Name Country,
Tag ,
Tution_Fees,
Entry_Requirement,
Duration,
Living_Expense,
Work_Experience
From Course
inner join import_detail on course.Course_Id=import_detail.Course_Id and import_detail.Import_Master_Id=Import_Master_Id_ 
inner join subject on  course.Subject_Id=subject.Subject_Id
inner join duration on course.Duration_Id=duration.Duration_Id
inner join level_detail on course.Level_Id=level_detail.Level_Detail_Id
inner join ielts on course.Ielts_Minimum_Score=ielts.Minimum_Score
inner join internship on course.Internship_Id=internship.Internship_Id
inner join university on course.University_Id=university.University_Id
inner join country on course.Country_Id=country.Country_Id ;


 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Intake`( In Course_Intake_Id_ Int)
Begin 
 SELECT Course_Id,
Intake_Id From Course_Intake where Course_Intake_Id =Course_Intake_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Load_Data`()
BEGIN
SELECT Internship_Id,Internship_Name From internship where  DeleteStatus=false  order by Internship_Name asc ;
SELECT Ielts_Id,Ielts_Name From ielts  where  DeleteStatus=false order by  Ielts_Name asc ;
SELECT Duration_Id,Duration_Name From duration where  DeleteStatus=false  order by Duration_Name asc ;
SELECT Level_Detail_Id,Level_Detail_Name From level_detail where  DeleteStatus=false  order by Level_Detail_Name asc ;
SELECT Student_Status_Id,Student_Status_Name From student_status where  DeleteStatus=false  order by Student_Status_Name asc; 
SELECT Enquiry_Source_Id,Enquiry_Source_Name From enquiry_source where  DeleteStatus=false  order by Enquiry_Source_Name asc; 
SELECT Notification_Type_Id,Notification_Type_Name From notification_type where  DeleteStatus=false  order by Notification_Type_Name asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Dashboard_Count`(In RoleId_ varchar(100),Department_String_ varchar(4000),Login_User_Id_ int)
BEGIN
declare Fromdate_ date;declare Todate_ date;declare Department_String_To_User_ varchar(4000);declare Department_String_Registered_By varchar(4000);
declare Search_Date_ varchar(200);declare User_Type_ int;declare curday int;declare Department_String_Reg_ varchar(4000);
set Fromdate_=now();
set Todate_=now();
set curday=(SELECT DAY(Fromdate_)-1);
set Fromdate_=(SELECT DATE_SUB(Fromdate_, INTERVAL curday DAY));
set Search_Date_='';set Department_String_Reg_ ='';set Department_String_='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
set Department_String_Reg_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set Search_Date_=concat( " and date(student.Entry_Date) >=  '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
	if User_Type_=2 then
		SET Department_String_ =concat(Department_String_Reg_," and student.To_User_Id =",Login_User_Id_);
        SET Department_String_Registered_By =concat(" and student.Registered_By =",Login_User_Id_);
	else
		SET Department_String_ =concat(Department_String_Reg_," and student.To_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
		distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
		SET Department_String_Registered_By =concat(" and student.Registered_By in (select User_Details_Id from user_details where Branch_Id in (select
		distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
	end if;
set Department_String_To_User_ =REPLACE(Department_String_Reg_,'By_User_Id','To_User_Id');
#set Department_String_Registered_By =REPLACE(Department_String,'By_User_Id','Registered_By');
#insert into data_log_ values(0,Department_String_Reg_,'');
SET @query = Concat( "  
select 1 as tp,count(student.Student_Id) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,"
#inner join user_details on user_details.User_Details_Id=student.To_User_Id
where student.DeleteStatus=0     and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'
and student.Role_Id in(",RoleId_,")  
   union
select 2 as tp,count(student.Student_Id) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,"
inner join user_details on user_details.User_Details_Id=student.Registered_By
where student.DeleteStatus=0 and  student.Is_Registered=1    and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'
and student.Role_Id in(",RoleId_,")    
union
    select 3 as tp,count(student.Student_Id) as Data_Count from student
#inner join Department on Department.Department_Id= student.Followup_Department_Id  
#inner join user_details on user_details.User_Details_Id=student.To_User_Id
where student.DeleteStatus=0 and student.FollowUp=1  ",Department_String_To_User_," and date(student.Next_FollowUp_Date) <'",  Todate_,"'
and student.Role_Id in(",RoleId_,")
union
 select 4 as tp,COALESCE(sum(Fees_Receipt.Amount),0) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,"
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join user_details on user_details.User_Details_Id=Fees_Receipt.User_Id
inner join Branch on Branch.Branch_Id= fees_receipt.Fee_Receipt_Branch
where student.DeleteStatus=0   and fees_receipt.Delete_Status=0 and date(Fees_Receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(Fees_Receipt.Entry_Date) <= '", Todate_,"'
and user_details.Role_Id in(",RoleId_,")
union
select 5 as tp,COALESCE(count(student.Student_Id)) as Data_Count from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,"
inner join application_details_history on application_details_history.Student_Id=student.Student_Id
inner join user_details on user_details.User_Details_Id=application_details_history.User_Id
where student.DeleteStatus=0  and application_details_history.DeleteStatus=0  and application_details_history.Application_status_Id=9  
and date(application_details_history.Date_Of_Applying) >= '", Fromdate_ ,"' and  date(application_details_history.Date_Of_Applying) <= '", Todate_,"'
and user_details.Role_Id in(",RoleId_,")
union
select 6 as tp,COALESCE(count(Student_Task.Student_Task_Id)) as Data_Count from Student_Task
where Student_Task.DeleteStatus=0 and Task_Status=1  and  date(Student_Task.Entry_date) <= '", Todate_,"' and Student_Task.To_User=",Login_User_Id_,"


 union
select 7 as tp,COALESCE(count(student_followup.Status_Type_Id)) as Data_Count from student_followup
where student_followup.DeleteStatus=0 and  Department=343 and Status_Type_Id=1

 union
select 8 as tp,COALESCE(count(student_followup.Status_Type_Id)) as Data_Count from student_followup
where student_followup.DeleteStatus=0  and Department=343 and Status_Type_Id=2
 order by tp  ");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Department`( )
BEGIN

SELECT 
Department_Id,Department_Name,Transfer_Method_Id,Color_Type_Name
From department
 where Is_Delete=false
ORDER BY Department_Name ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Department_InUser`()
BEGIN
select
Department.Department_Id,
Department_Name,
Branch.Branch_Id,
Branch_Name,'0' VIew_All,'0' View_Entry

from Department inner join Branch_Department on Branch_Department.Department_Id=Department.Department_Id
inner join Branch on Branch.Branch_Id=Branch_Department.Branch_Id
order by Branch_Name,Department_Name asc;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Department_Permission_Byuser`( In User_Id_ Int,Branch_ int)
Begin
SELECT Department_Id,Branch_Id,View_Entry ,VIew_All From User_Department where
User_Id =User_Id_   ;#and Is_Delete=false ;and Branch_Id=Branch_
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Department_Permission_Byuser_current_Branch`( In User_Id_ Int,Branch_ int)
Begin 
SELECT Department_Id,Branch_Id,View_Entry ,VIew_All From User_Department where 
User_Id =User_Id_  and VIew_All=1 ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Department_Status`( In Department_Status_Id_ Int)
Begin 
 SELECT Department_Status_Id,
Department_Status_Name,
Status_Order,
Editable,
Color From Department_Status where Department_Status_Id =Department_Status_Id_ and Is_Delete=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Document`( In Document_Id_ Int)
Begin 
 SELECT Document_Id,
Document_Name From Document where Document_Id =Document_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Duration`( In Duration_Id_ Int)
Begin 
 SELECT Duration_Id,
Duration_Name From Duration where Duration_Id =Duration_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Enquiry_Source`( In Enquiry_Source_Id_ Int)
Begin 
 SELECT Enquiry_Source_Id,
Enquiry_Source_Name From Enquiry_Source where Enquiry_Source_Id =Enquiry_Source_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Enquiry_Source_data_Count`(In RoleId_ varchar(100),Department_String varchar(1000))
BEGIN
declare Fromdate_ date;declare Todate_ date;
declare curday int;
set Fromdate_=now();
set Todate_=now();
set curday=(SELECT DAY(Fromdate_)-1);
set Fromdate_=(SELECT DATE_SUB(Fromdate_, INTERVAL curday DAY));

SET @query = Concat( "select enquiry_source.Enquiry_Source_Name,count(student.Student_Id) as Data_Count from
enquiry_source left join student on enquiry_source.Enquiry_Source_Id=student.Enquiry_Source_Id and student.DeleteStatus=0  
and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'
and student.Role_Id in(",RoleId_,") where enquiry_source.DeleteStatus=0 ",Department_String,"
group by enquiry_source.Enquiry_Source_Id
order by Enquiry_Source_Name");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Enquiry_Status`( In Enquiry_Source_Id_ Int)
Begin 
 SELECT Enquiry_Source_Id,
Enquiry_Source_Name From Enquiry_Source where Enquiry_Source_Id =Enquiry_Source_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Fees`( In Fees_Id_ Int)
Begin 
 SELECT Fees_Id,
Fees_Name From fees where Fees_Id =Fees_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Feesrecepitdetails`( In Student_Id_ Int)
Begin
SELECT Fees_Receipt_Id ,Student_Id,  Entry_date,
 User_Id,Description,Fees_Id,Amount,Fee_Receipt_Branch,
 Voucher_No, (Date_Format(Actual_Entry_date,'%d-%m-%Y')) as Actual_Entry_date 

 From fees_receipt 
 where Student_Id =Student_Id_ and Delete_Status=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Feesrecepit_DocumentList`( In Fees_Receipt_Id_ Int)
Begin
select Feesreceipt_document_Id,FeesreceiptFile_Name,FeesreceiptDocument_Name,0 New_Entry, 
 FeesreceiptDocument_File_Name,feesreceipt_document.Fees_Receipt_Id,
 Entry_date
 from feesreceipt_document
 where Fees_Receipt_Id =Fees_Receipt_Id_ and DeleteStatus=false order by FeesreceiptDocument_Id;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Fees_Receipt`( In Fees_Receipt_Id_ Int)
Begin 
 SELECT Entry_Date,
 Description,
 Amount,
 Fees_Name,
 Voucher_No
 From fees_receipt 
 inner join fees on fees_receipt.Fees_Id= fees.Fees_Id  
 where Fees_Receipt_Id =Fees_Receipt_Id_ and Delete_Status=false ;
 
/* select Feesreceipt_document_Id,FeesreceiptFile_Name,FeesreceiptDocument_Name,0 New_Entry, 
 FeesreceiptDocument_File_Name from feesreceipt_document
 where Fees_Receipt_Id =Fees_Receipt_Id_ and DeleteStatus=false order by FeesreceiptDocument_Id;*/
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_FollowUp_Details`( In Student_Id_ Int)
Begin 
 SELECT
         student.Student_FollowUp_Id,Followup_Department_Id  Department,Followup_Department_Name Department_Name,
    Status_Id,Department_Status_Name,To_User_Id ,To_User_Name ,
        (Date_Format(Next_FollowUp_Date,'%Y-%m-%d')) As Next_FollowUp_Date,Remark,
        Followup_Branch_Id Branch,Followup_Branch_Name Branch_Name, FollowUp  Department_FollowUp,By_User_Id,
        Class_Id,Class_Name,Is_Registered,Sub_Status_Id,Sub_Status_Name,Status_Type_Id,Status_Type_Name
From student
 where student.Student_Id =Student_Id_  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_FollowUp_History`( In Student_Id_ Int)
Begin 
 SET @query = Concat( " SELECT '1'  Entry_Type ,'FollowUp' as Entry_Caption,Branch_Name,Dept_Name Department_Name,FollowUp Followup_value ,
 Dept_StatusName Status_Name,
(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,(Date_Format(Entry_Date,'%d-%m-%Y-%h:%i')) As Entry_Date,
UserName User_Name,ByUserName By_User_Name,
Remark,unix_timestamp(Entry_Date) as Sort_Coloumn,FollowUp_Difference,(Date_Format(Actual_FollowUp_Date,'%d-%m-%Y')) As Actual_FollowUp_Date,Sub_Status_Name
From student_followup
where student_followup.Student_Id = ",Student_Id_,"   and student_followup.DeleteStatus=false
union
select  '2'  Entry_Type ,'Fees Receipt' as Entry_Caption,Branch_Name,'' Department_Name,'' Followup_value,Fees_Name as Status_Name, (Date_Format(fees_receipt.Actual_Entry_Date,'%d-%m-%Y-%h:%i')) As Next_FollowUp_Date  ,
(Date_Format(fees_receipt.Actual_Entry_Date,'%d-%m-%Y-%h:%i')) as Entry_Date,
'' as User_Name,user_details.User_Details_Name By_User_Name,
Description,unix_timestamp(Entry_Date) as Sort_Coloumn,'' FollowUp_Difference,Amount As Actual_FollowUp_Date,'' Sub_Status_Name
from fees_receipt
inner join fees on fees.Fees_Id=fees_receipt.Fees_Id
inner join  user_details on fees_receipt.User_Id=user_details.User_Details_Id 
inner join Branch  on fees_receipt.Fee_Receipt_Branch=Branch.Branch_Id
where fees_receipt.Student_Id = ",Student_Id_," and  Delete_Status=false
union
SELECT '3'  Entry_Type ,'Course Sent' as Entry_Caption,'' Branch_Name,''Department_Name,'' Followup_value ,'' Status_Name,
'' Next_FollowUp_Date,(Date_Format(Entry_Date,'%d-%m-%Y-%h:%i')) As Entry_Date,
user_details.User_Details_Name User_Name,'' By_User_Name,
'' Remark,unix_timestamp(Entry_Date),'' FollowUp_Difference,'' As Actual_FollowUp_Date,'' Sub_Status_Name
From student_course_apply
inner join user_details  on user_details.User_Details_Id =student_course_apply.User_Id
where student_course_apply.Student_Id = ",Student_Id_,"
union
SELECT '4'  Entry_Type ,'Registered' as Entry_Caption,Branch.Branch_Name,'' Department_Name,'' Followup_value ,
'' Status_Name,
'' Next_FollowUp_Date,(Date_Format(Registered_On,'%d-%m-%Y-%h:%i')) As Entry_Date,
'' User_Name,user_details.User_Details_Name By_User_Name,
'' Remark,unix_timestamp(Registered_On) as Sort_Coloumn,'' FollowUp_Difference,'' As Actual_FollowUp_Date,'' Sub_Status_Name
From student
inner join  user_details on student.Registered_By=user_details.User_Details_Id 
inner join Branch  on Branch.Branch_Id =student.Followup_Branch_Id
where student.Student_Id = ",Student_Id_,"
union
SELECT '5'  Entry_Type ,'Welocome mail Sent' as Entry_Caption,'' as Branch_Name,'' Department_Name,'' Followup_value ,
'' Status_Name,
'' Next_FollowUp_Date,(Date_Format(Entry_date,'%d-%m-%Y-%h:%i')) As Entry_Date,
'' User_Name,user_details.User_Details_Name By_User_Name,
'' Remark,unix_timestamp(Entry_Date) as Sort_Coloumn,'' FollowUp_Difference,'' As Actual_FollowUp_Date,'' Sub_Status_Name
From transaction_history
inner join  user_details on transaction_history.User_Id=user_details.User_Details_Id 
where Transaction_type=1 and transaction_history.Student_Id = ",Student_Id_,"
order by Sort_Coloumn desc;");
PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Fornt_Student_Dropdowns`()
BEGIN
SELECT intake_Id  as Intake_Id,intake_Name as Intake_Name  from intake  where  DeleteStatus=false  order by intake_Id asc ;
SELECT Intake_Year_Id,Intake_Year_Name from intake_year where  DeleteStatus=false  order by Intake_Year_Name asc; 
SELECT Country_Id,Country_Name from country where  DeleteStatus=false  order by Country_Name asc; 
SELECT  Ielts_Type  as Ielts_Type,Ielts_Type_Name as Ielts_Type_Name  from IELTS_TYPE where  DeleteStatus=false  order by Ielts_Type_Name asc;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Ielts_Details`( In Student_Id_ Int)
Begin
SELECT Ielts_Details_Id,Slno,Student_Id,Ielts_Type,
Ielts_Type_Name,Exam_Check,(Date_Format(Exam_Date,'%Y-%m-%d')) AS Exam_Date,
(Date_Format(Exam_Date,'%d-%m-%Y')) AS Actual_Exam_Date,
Description,Listening,Reading,Writing,Speaking,Overall,DeleteStatus
 From Ielts_Details 
 where Student_Id =Student_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_IELTS_Photo`( In Student_Id_ Int)
Begin
SELECT IELTS
 From student

 where Student_Id =Student_Id_
 and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Intake`( In Intake_Id_ Int)
Begin 
 SELECT Intake_Id,
Intake_Name From Intake where Intake_Id =Intake_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Intakes_InCourse`()
Begin 

 SELECT false Intake_Status,false Intake_Selection,Intake_Name,Intake_Id from Intake  order by intake_Id asc;
   

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Intakes_InCourse_Edit`( In Course_Id_ int)
Begin 

  SELECT false Intake_Status,false Intake_Selection,Intake_Name from Intake 
  left join  course_intake on course_intake.Intake_Id=intake.Intake_Id
  order by Intake_Name ;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_intake_year`( In Intake_Year_Id_ Int)
Begin 
 SELECT Intake_Year_Id,
Intake_Year_Name From intake_year where Intake_Year_Id =Intake_Year_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Internship`( In Internship_Id_ Int)
Begin 
 SELECT Internship_Id,
Internship_Name From Internship where Internship_Id =Internship_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Invoice_Details`( In Student_Id_ Int)
Begin
SELECT Invoice_Id ,Student_Id, (Date_Format(Entry_Date,'%Y-%m-%d'))   as Entry_Date, (Date_Format(Entry_Date,'%d-%m-%Y'))   as Edit_Entry_Date,Description,Amount
from invoice
 where Student_Id =Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Invoice_Documents`(In Invoice_Id_ int)
BEGIN
 select  Invoice_Document_Id,Invoice_Id,(Date_Format(Entry_Date,'%d-%m-%Y')) as Entry_Date,Description,Invoice_Document_Name,Invoice_Document_File_Name,Invoice_File_Name,0 as New_Entry
 from Invoice_document where Invoice_Id = Invoice_Id_ and DeleteStatus= 0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Last_FollowUp`( In User_Id_ Int)
Begin 
Declare Followup_Id_ numeric;
#set Followup_Id_=(select Max(Student_FollowUp_Id) from student_followup where By_User_Id =User_Id_ and DeleteStatus=false);
select Branch.Branch_Id as Branch , Branch.Branch_Name,Department.Department_Status_Id as Status_Id,
Department.Department_Status_Id as Status,
User_Details_Id User_Id ,Department.Department_Name ,
FollowUp  Department_FollowUp , Department_Status_Name,User_Details_Name,department.Department_Id Department
 from user_details inner join Branch on Branch.Branch_id =User_Details.Branch_Id
inner join Department on user_details.Department_Id=department.Department_Id 
inner join department_status on department_status.Department_Status_Id=Department.Department_Status_Id

 where 
 user_details.User_Details_Id=User_Id_;
 #SELECT Department,student_followup.Status,student_followup.User_Id,
#student_followup.Branch,Branch_Name,Dept_Name Department_Name,Dept_StatusName Department_Status_Name ,
#UserName User_Details_Name ,FollowUp  Department_FollowUp,By_User_Id
#From student_followup
 #where student_followup.Student_FollowUp_Id =Followup_Id_  and student_followup.DeleteStatus=false and student_followup.Student_FollowUp_Id=student_followup.Student_FollowUp_Id;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Lead_Load_Data_ByUser`(In Login_User Int )
BEGIN
declare User_Type_ int;declare View_all_ int; declare department_ varchar(1000); declare branch_ varchar(1000);
set User_Type_=(select  User_Type from user_details where User_Details_Id=Login_User);
set View_all_=(select distinct VIew_All from user_department where User_Id=Login_User limit 1);

if User_Type_=2 then
	if View_all_ =1 then
		SELECT User_Details_Id,User_Details_Name From user_details  where  DeleteStatus=false and Department_Id in (select
		distinct Department_Id from user_department where User_Id =Login_User ) and Branch_Id in (select
		distinct Branch_Id from user_department where User_Id =Login_User ) order by  User_Details_Name asc ;

		#SET SearchbyName_Value =concat(SearchbyName_Value," and User_Details_Id =",Login_Id_);
	else
 
		SELECT User_Details_Id,User_Details_Name From user_details  where  DeleteStatus=false and User_Details_Id =Login_User order by  User_Details_Name asc ;
	end if;
else
	SELECT User_Details_Id,User_Details_Name From user_details  where  DeleteStatus=false and User_Details_Id in (select User_Details_Id from user_details where Branch_Id in (select
	distinct Branch_Id from user_department where User_Id =Login_User )) order by  User_Details_Name asc ;
   
end if;


#SELECT Department_Id,Department_Name From department where  and VIew_All=1 DeleteStatus=false  order by Department_Name asc ;

#SELECT User_Details_Id,User_Details_Name From user_details  where  DeleteStatus=false order by  User_Details_Name asc ;

SELECT Department_Id,Department_Name From department where  Is_Delete=false and
Department_Id in (select distinct Department_Id from user_department where User_Id =Login_User and View_Entry=1) order by Department_Name asc ;

SELECT Branch_Id,Branch_Name From branch where  Is_Delete=false and Branch_Id in (select
	distinct Branch_Id from user_department where User_Id =Login_User and VIew_Entry=1) order by Branch_Name asc ;

SELECT Fees_Id,Fees_Name From fees where  DeleteStatus=false  order by Fees_Name asc; 

SELECT Remarks_Id,Remarks_Name From remarks where  DeleteStatus=false  order by Remarks_Name asc; 

SELECT Department_Status_Id,Department_Status_Name From department_status where  Is_Delete=false  order by Department_Status_Name asc ;

SELECT Enquiry_Source_Id,Enquiry_Source_Name From enquiry_source where  DeleteStatus=false  order by Enquiry_Source_Name asc ;

SELECT Client_Accounts_Id,Client_Accounts_Name  from client_accounts where  DeleteStatus=false and Account_Group_Id in(4,5,11)  order by Client_Accounts_Name asc;
    
SELECT Fees_Receipt_Status_Id,Fees_Receipt_Status_Name From Fees_Receipt_Status where  DeleteStatus=false  order by Fees_Receipt_Status_Name asc;

SELECT Branch_Id,Branch_Name From branch where  Is_Delete=false and Branch_Id in (SELECT Branch_Id From user_details where  DeleteStatus=false and User_Details_Id=Login_User) ;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Level_Detail`( In Level_Detail_Id_ Int)
Begin 
 SELECT Level_Detail_Id,
Level_Detail_Name From Level_Detail where Level_Detail_Id =Level_Detail_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Menu_Permission`(In User_Id_ int)
BEGIN
select
User_Menu_Selection.Menu_Id,
User_Menu_Selection.IsEdit Menu_Edit,
User_Menu_Selection.IsDelete Menu_Delete ,
User_Menu_Selection.IsSave Menu_Save,
User_Menu_Selection.IsView VIew_All ,
User_Menu_Selection.Menu_Status,
Menu_Type
from User_Menu_Selection
inner join Menu on User_Menu_Selection.Menu_Id=Menu.Menu_Id
Where
User_Id=User_Id_ 
and User_Menu_Selection.IsView=1 and Menu.Menu_Status=1
order by Menu_Order Asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Menu_Status`(In Menu_Id_ int,Login_User_ int)
BEGIN
select IsView ,Menu_Status,IsEdit Edit,IsSave Save,IsDelete,Menu_Id,IsDelete as 'Delete' ,IsView as'View' ,menu_id
from user_menu_selection where User_Id=Login_User_ and DeleteStatus=0 and menu_id=Menu_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Menu_Status_Multiple`(In Menu_Id_ varchar(500),Login_User_ int)
BEGIN
SET @query = Concat("
select IsView ,Menu_Status,IsEdit Edit,IsSave Save,IsDelete,Menu_Id,IsDelete as 'Delete' ,IsView as'View' ,menu_id
from user_menu_selection where User_Id=",Login_User_," and DeleteStatus=0 and menu_id in (",Menu_Id_,")"
);
PREPARE QUERY FROM @query;
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Message_Details`(in Student_Id_ int)
BEGIN
select Student_Message_Id,Message_Detail,
(Date_Format(Entry_Date,'%Y-%m-%d')) As Entry_Date 
from student_message where Student_Id=Student_Id_ and DeleteStatus=false
order by Entry_Date desc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_MOI_Photo`( In Student_Id_ Int)
Begin
SELECT Passport_Photo
 From student

 where Student_Id =Student_Id_
 and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_More_Information`(in Course_Id_ int)
BEGIN
select Application_Fees,Tution_Fees,Level_Detail_Name,Details,Duration_Name,Subject_Name,
ielts.Ielts_Name Ielts_Minimum_Score
 From Course 
 inner join duration on  course.Duration_Id= duration.Duration_Id
 inner join  level_detail on course.Level_Id=level_detail.Level_Detail_Id
 inner join subject on course.Subject_Id=subject.Subject_Id
 inner join ielts on course.Ielts_Minimum_Score=ielts.Ielts_Id
where Course.DeleteStatus = false and Course.Course_Id=Course_Id_;
select Intake_Name
from intake
 inner join course_intake on  course_intake.Intake_Id= intake.Intake_Id
 where course_intake.Course_Id=Course_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_News_Document`()
Begin  
 SELECT  News_Document_Id,(Date_Format(Entry_date,'%d-%m-%Y')) As  Entry_date,File_Name,Image,Description
 from news_document
where DeleteStatus=false
order by News_Document_Id desc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Other_Attributes`( In Student_Id_ Int)
Begin
SELECT Work_Experience_Id,Slno,Student_Id,Ex_From,
Ex_To,Years,Company,Designation,Salary,Salary_Mode,DeleteStatus
 From work_experience 
 where Student_Id =Student_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Preadmission_Details`( In Student_Id_ Int)
Begin

declare Country_Id_ int;
set Country_Id_ =(SELECT Country_Id from application_details  where Student_Id =Student_Id_ and Activation_Status=1);

SELECT Student_Preadmission_Checklist_Master_Id ,(Date_Format(Entry_Date,'%d-%m-%Y')) AS Entry_Date
 From Student_Preadmission_Checklist_Master  
 where Student_Id =Student_Id_ and Country_Id=Country_Id_  and Student_Preadmission_Checklist_Master.DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Preadmission_Details_Edit`( In Student_Preadmission_Checklist_Master_Id_ Int)
Begin
declare Student_Checklist_Country_Id_ int;
set Student_Checklist_Country_Id_ =0;
set Student_Checklist_Country_Id_ =(SELECT Country_Id from student_preadmission_checklist_master where Student_Preadmission_Checklist_Master_Id =Student_Preadmission_Checklist_Master_Id_);


SELECT Checklist.Checklist_Id,Checklist_Name,Checklist.Country_Id,Student_Preadmission_Checklist_Master_Id
,case when student_preadmission_checklist_details.Checklist_Id>0 then 1 else 0 end as Check_Box
FROM Checklist  
left join student_preadmission_checklist_details on Checklist.Checklist_Id=student_preadmission_checklist_details.Checklist_Id
and student_preadmission_checklist_details.Student_Preadmission_Checklist_Master_Id = Student_Preadmission_Checklist_Master_Id_  where Checklist.Country_Id=Student_Checklist_Country_Id_ 
and Checklist.Checklist_Type=2  and Checklist.DeleteStatus=false
 order by Checklist_Id;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Preadmission_Task`( In Student_Id_ Int,Task_Group_Id_ int)
Begin
SELECT Student_Task_Id,Task_Group_Id,Task_Status,Student_Id,Student_Name,(Date_Format(Followup_Date,'%Y-%m-%d'))  as Followup_Date,Status_Name,Remark,student_task.Task_Item_Id,To_User,To_User_Name,(Date_Format(Followup_Date,'%d-%m-%Y'))  as Grid_Followup_Date,Task_Item_Name
 From student_task 
 inner join task_item on student_task.Task_Item_Id = task_item.Task_Item_Id
 where Student_Id =Student_Id_ and student_task.Task_Group_Id=Task_Group_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Previsa_Details`( In Student_Id_ Int)
Begin

declare Country_Id_ int;
set Country_Id_ =(SELECT Country_Id from application_details  where Student_Id =Student_Id_ and Activation_Status=1);

SELECT Student_Checklist_Master_Id ,(Date_Format(Entry_Date,'%d-%m-%Y')) AS Entry_Date
 From Student_Checklist_Master  
 where Student_Id =Student_Id_ and Country_Id=Country_Id_  and Student_Checklist_Master.DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Previsa_Details_Edit`( In Student_Checklist_Master_Id_ Int)
Begin
declare Student_Checklist_Country_Id_ int;
set Student_Checklist_Country_Id_ =0;
set Student_Checklist_Country_Id_ =(SELECT Country_Id from Student_Checklist_Master where Student_Checklist_Master_Id =Student_Checklist_Master_Id_);

SELECT Checklist.Checklist_Id,Checklist_Name,Checklist.Country_Id,Student_Checklist_Master_Id
,case when Student_Checklist_Details.Checklist_Id>0 then 1 else 0 end as Check_Box
FROM Checklist  
left join Student_Checklist_Details on Checklist.Checklist_Id=Student_Checklist_Details.Checklist_Id
and Student_Checklist_Details.Student_Checklist_Master_Id = Student_Checklist_Master_Id_  where Checklist.Country_Id=Student_Checklist_Country_Id_ and Checklist.Checklist_Type=1 and Checklist.DeleteStatus=false
 order by Checklist_Id;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Previsa_Task`( In Student_Id_ Int,Task_Group_Id_ int)
Begin
SELECT Student_Task_Id,Task_Group_Id,Task_Status,Student_Id,Student_Name,(Date_Format(Followup_Date,'%Y-%m-%d'))  as Followup_Date,Status_Name,Remark,student_task.Task_Item_Id,To_User,To_User_Name,(Date_Format(Followup_Date,'%d-%m-%Y'))  as Grid_Followup_Date,Task_Item_Name
 From student_task 
 inner join task_item on student_task.Task_Item_Id = task_item.Task_Item_Id
 where Student_Id =Student_Id_ and student_task.Task_Group_Id=Task_Group_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Proceeding_Details`( In Student_Id_ Int)
Begin
SELECT Application_Master_Id,Student_Id,Proceeding_University_Id,Year_Name,Year_Id,
University_Name,Country_Id,Country_Name,Course_Id,Course_Name,Intake_Id,Intake_Name,Partner_Id,Partner_Name,DeleteStatus
 From Application_Master 
 where Student_Id =Student_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_QualificationDetails`( In Student_Id_ Int)
Begin
SELECT Qualification_Id ,slno,Student_id,Credential,school,MarkPer,Fromyear,
Toyear,result,Field,Backlog_History,Year_of_passing
 From qualification 
 where Student_id =Student_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Receipt_Sum`( In Student_Id_ Int)
Begin 
 SELECT COALESCE(sum(Amount),0) as paid_fees From fees_receipt where Student_Id =Student_Id_ and Fees_Id !=5 and Delete_Status=false ;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Refundrequestdetails`( In Student_Id_ Int,Fees_Receipt_Id_ int)
Begin
SELECT Refund_Request_Id ,Student_Id,  User_Id,Fees_Receipt_Id,
 Reason,Remark, (Date_Format(Entry_Date,'%d-%m-%Y')) AS Entry_Date
 From refund_request 
 where Student_Id =Student_Id_ and Fees_Receipt_Id=Fees_Receipt_Id_ and Delete_Status=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Registration_data_Count`(In RoleId_ varchar(100),Department_String varchar(1000))
BEGIN
declare Fromdate_ date;declare Todate_ date;
declare curday int;
set Fromdate_=now();
set Todate_=now();
set curday=(SELECT DAY(Fromdate_)-1);
set Fromdate_=(SELECT DATE_SUB(Fromdate_, INTERVAL curday DAY));
SET @query = Concat( "  
select User_Details_Name User,count(student.Student_Id) as No_of_Registration from
student
inner join user_details on user_details.User_Details_Id=student.Registered_By
inner join Branch  on Branch.Branch_Id= student.Registration_Branch
where student.DeleteStatus=0 and student.Is_Registered=1  and  and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'
 user_details.Role_Id in(",RoleId_,")
group by student.Registered_By order by Branch,User_Id
    ");
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Resume_Photo`( In Student_Id_ Int)
Begin
SELECT Resume
 From student

 where Student_Id =Student_Id_
 and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_ReviewDetails`( In Student_Id_ Int)
Begin
SELECT Review_Id ,Facebook,Instagram,Gmail,User_Id,Student_Id,(Date_Format(Entry_Date,'%d-%m-%Y')) AS Entry_Date,user_details.User_Details_Name,
(Date_Format(Facebook_Date,'%Y-%m-%d'))   as Facebook_Date,
(Date_Format(Instagram_Date,'%Y-%m-%d'))   as Instagram_Date,
(Date_Format(Google_Date,'%Y-%m-%d'))   as Google_Date,

(Date_Format(Checklist_Date,'%Y-%m-%d'))   as Checklist_Date,
(Date_Format(Kit_Date,'%Y-%m-%d'))   as Kit_Date,
(Date_Format(Ticket_Date,'%Y-%m-%d'))   as Ticket_Date,
(Date_Format(Accomodation_Date,'%Y-%m-%d'))   as Accomodation_Date,
(Date_Format(Airport_Pickup_Date,'%Y-%m-%d'))   as Airport_Pickup_Date,

case when Facebook>0 then 1 else 0 end as Facebook,
case when Instagram>0 then 1 else 0 end as Instagram,
case when Gmail>0 then 1 else 0 end as Gmail,

case when Checklist>0 then 1 else 0 end as Checklist,
case when Kit>0 then 1 else 0 end as Kit,
case when Ticket>0 then 1 else 0 end as Ticket,
case when Accomodation>0 then 1 else 0 end as Accomodation,
case when Airport_Pickup>0 then 1 else 0 end as Airport_Pickup
 From review 
inner join user_details on user_details.User_Details_Id=review.User_Id
 where Student_Id =Student_Id_ and review.DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_site_Pageload`()
BEGIN
SELECT Country_Id,Country_Name From Country where  DeleteStatus=false  order by Country_Name asc ;
SELECT Ielts_Id,Ielts_Name From ielts  where  DeleteStatus=false order by  Ielts_Name asc ;
SELECT Subject_Id,Subject_Name,Selection From subject where  DeleteStatus=false  order by Subject_Name asc ;
SELECT Duration_Id,Duration_Name,Selection From duration where  DeleteStatus=false  order by Duration_Name asc ;
SELECT Level_Detail_Id,Level_Detail_Name From level_detail where  DeleteStatus=false  order by Level_Detail_Name asc ;
SELECT Intake_Id,Intake_Name From intake where  DeleteStatus=false  order by Intake_Name asc ;
SELECT Intake_Year_Id,Intake_Year_Name From intake_year where  DeleteStatus=false  order by Intake_Year_Name asc ;
SELECT Internship_Id,Internship_Name From internship where  DeleteStatus=false  order by Internship_Name asc ;
SELECT University_Id,University_Name From university where  DeleteStatus=false  order by University_Name asc ;
SELECT Sub_Section_Id,Sub_Section_Name From sub_section where DeleteStatus=false  order by Sub_Section_Name asc ;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_SOP_Photo`( In Student_Id_ Int)
Begin
SELECT Passport_Copy
 From student

 where Student_Id =Student_Id_
 and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Status_Selection_Edit`( In Department_Id_ Int)
Begin 
SELECT Department_Status_Id,
Department_Status_Name,
case when Status_Selection.Status_Id>0 then 1 else 0 end as Check_Box
From Department_Status  left join Status_Selection on
Department_Status.Department_Status_Id=Status_Selection.status_Id
and Department_Id=Department_Id_ where
Department_Status.Is_Delete=false order by Status_Order ; 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student`( In Student_Id_ Int)
Begin
 SELECT Student_Id,
# Agent_Id,
Student_Name,
#Last_Name,
 #IFNULL(Gender, 0) as Gender,
 IFNULL(Address1, '') as Address1,
Address2,
#Pincode,
IFNULL(Email, '') as Email,
Alternative_Email,
Phone_Number,
Guardian_telephone,
Counsilor_Note,
BPH_Note,
Pre_Visa_Note,
Alternative_Phone_Number,
(Date_Format(Dob,'%Y-%m-%d')) As Dob ,
Country_Name,
#Promotional_Code,
Student_Status_Id,
Enquiry_Source_Id,
Enquiry_Mode_Id,
Shore_Id,
Sub_Status_Name,
Whatsapp,
#Passport_Copy_File_Name,IELTS_File_Name,Passport_Photo_File_Name,
#Tenth_Certificate_File_Name,Work_Experience_File_Name,Resume_File_Name,

#Facebook,IFNULL(Passport_Copy,'') Passport_Copy,
#IFNULL(IELTS,'') IELTS,IFNULL(Passport_Photo,'') Passport_Photo,
#IFNULL(Tenth_Certificate,'') Tenth_Certificate ,
#IFNULL(Work_Experience,'') Work_Experience ,
#IFNULL(Resume,'') Resume ,
Is_Registered,
#Password,
#College_University,
Programme_Course Program_Course_Name,
#Intake,
#Year,
Reference,
#Visa_Submission_Date,
#Activity,
#Visa_Outcome,
#IFNULL(Course_Link, '') as Course_Link,
IFNULL(Agent, '') as Agent,
#Status_Details,
#Student_Remark,
Send_Welcome_Mail_Status,
Program_Course_Id,
Unique_Id,
Sub_Status_Id,
Previous_Visa_Rejection,
No_of_Kids_and_Age,
Dropbox_Link,
Spouse_Occupation,
Spouse_Qualification,
Date_of_Marriage,
Spouse_Name,
Enquiryfor_Id,
Marital_Status_Id,

  IFNULL(Passport_No, '') as Passport_No,
(Date_Format(Passport_fromdate,'%Y-%m-%d')) As Passport_fromdate,
(Date_Format(Passport_Todate,'%Y-%m-%d')) As Passport_Todate,


 IFNULL(Passport_Id, 0) as Passport_Id,

IFNULL(Registered_On, '') as Registered_On,
IFNULL(Registration_Target, 0) as Registration_Target,
IFNULL(FollowUp_Count, 0) as FollowUp_Count,
IFNULL(FollowUp_Entrydate, '') as FollowUp_Entrydate,
IFNULL(Registration_Branch, '') as Registration_Branch,
IFNULL(Entry_Type, '') as Entry_Type,
IFNULL(First_Followup_Status, '') as First_Followup_Status,
IFNULL(First_Followup_Date, '') as First_Followup_Date,
 IFNULL(Student_Registration_Id, 0) as Student_Registration_Id, 
 IFNULL(Followup_Department_Name, '') as Department_Name, 
 IFNULL(FollowUp, '') as FollowUp, 
 IFNULL(Followup_Branch_Name, '') as Branch_Name, 
 IFNULL(Client_Accounts_Name, '') as Client_Accounts_Name, 
 IFNULL(Agent_Name, '') as Agent_Name, 
 IFNULL(Department_Status_Name, '') as Department_Status_Name, 
 IFNULL(To_User_Name, '') as User_Details_Name, 
 IFNULL(Role_Id, 0) as Role_Id, 
 IFNULL(Enquiry_Source_Name, '') as Enquiry_Source_Name, 
 #IFNULL(Visa_Outcome, '') as Visa_Outcome, 
 IFNULL(Created_User, '') as Created_User, 
 IFNULL(Registered_User, '') as Registered_User, 
  IFNULL(Registered_Branch, '') as Registered_Branch,
  IFNULL(Marital_Status_Id,'') as Marital_Status_Id ,
  IFNULL(Marital_Status_Name,'') as Marital_Status_Name ,  
   IFNULL(Program_Course_Id,0) as Program_Course_Id ,
    IFNULL(Profile_University_Id,0) as Profile_University_Id ,
     IFNULL(Profile_Country_Id,0) as Country_Id ,
      #IFNULL(Created_On,'') as Created_On,
      (Date_Format(Created_On,'%Y-%m-%d')) as Created_On,
       #IFNULL(Intake_Id,0) as Intake_Id,
       Next_FollowUp_date as date


 From Student where Student_Id =Student_Id_ and DeleteStatus=false ;

select * from Student_Document where Student_Id =Student_Id_ and DeleteStatus=false order by Document_Id;
select Student_Agent_Country_Id,Student_Id,Agent_Id,student_agent_country.Agent_Country_Id,student_agent_country.Agent_Country_Name,
 case when student_agent_country.Agent_Country_Id>0 then 1 else 0 end as Check_Box
 from student_agent_country 
   left join agent_country on  agent_country.Agent_Country_Id=student_agent_country.Agent_Country_Id
 where Student_Id =Student_Id_ and student_agent_country.DeleteStatus=false order by Student_Agent_Country_Id;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Agent`( In Student_Id_ Int)
Begin 
 SELECT Student_Id,
 Agent_Id,
Student_Name,
Last_Name,
Gender,
Address1,
Address2,
Pincode,
Email,
Phone_Number,
Dob,
Country,
Promotional_Code,
Student_Status_Id,
Password From Student where Student_Id =Student_Id_ and DeleteStatus=false ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `get_student_checklist`( In Student_Id_ Int,Checklist_Type_ int)
Begin
SELECT Application_details_Id,Country_Name,Checklist_Name,Checklist_Id,application_details.Country_Id
 From application_details
inner join Checklist on Checklist.Country_Id =application_details.Country_Id
 where Student_Id =Student_Id_ and Activation_Status=1 and application_details.DeleteStatus=false and Checklist.Checklist_Type=Checklist_Type_ and Checklist.DeleteStatus=false  ;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Course_Apply`(in Student_Id_ int )
BEGIN
select Student_Course_Apply_Id,
(Date_Format(Entry_Date,'%d-%m-%Y')) As Entry_Date ,
(Date_Format(Paid_On,'%Y-%m-%d')) As Paid_On ,Status_Id,Total_Course
from student_course_apply
where Student_Id=Student_Id_;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Course_Selection`(in Student_Course_Apply_Id_ int)
BEGIN
select Course_Name,Application_Fees,Country_Name,University_Name,Student_Course_Apply_Id
from student_course_selection
inner join Course on Course.Course_Id=student_course_selection.Course_Id
inner join Country on Course.Country_Id=Country.Country_Id
inner join University on Course.University_Id=University.University_Id
where Student_Course_Apply_Id=Student_Course_Apply_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Details`(in Student_Id_ int)
BEGIN
select Student_Id,Student_Name,Gender,Address1,Address2,Email,Phone_Number,Pincode,
Last_Name,Dob,Country,Promotional_Code,Password
from student where Student_Id=Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Document`( In Student_Id_ Int)
Begin  
 SELECT * From Student_Document
where Student_Id =Student_Id_ and student_document.DeleteStatus=false
order by Student_Document_Id desc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Edit`( In Student_Id_ Int)
Begin 
 SELECT check_list.Check_List_Id ,Check_List_Name,
 case when student_checklist.Applicable>0 then 1 else 0 end as Applicable,
 case when student_checklist.Checklist_Status>0 then 1 else 0 end as Checklist_Status,
  check_list.Applicable Applicable_Check,
	check_list.Checklist_Status Checklist_Status_Check
  From check_list 
  left join student_checklist on  check_list.Check_List_Id = student_checklist.Check_List_Id
  and Student_Id = Student_Id_ where check_list.DeleteStatus=false and student_checklist.DeleteStatus=false  order by check_list.Check_List_Id ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Fill_Check`( In rstring_ varchar(200))
Begin
SELECT Student_Id,Status_Student_Fill

 From student 
 where Unique_Id =rstring_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Message`( In Student_Message_Id_ Int)
Begin 
 SELECT Student_Message_Id,
Student_Id,
Message_Detail From Student_Message where Student_Message_Id =Student_Message_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_PageLoadData_Dropdowns`()
BEGIN
SELECT Passport_Id,Passport_Name From passport_mode where  DeleteStatus=false  order by Passport_Name asc ;
SELECT Ielts_Id,Ielts_Name From ielts_mode  where  DeleteStatus=false order by  Ielts_Name asc ;
SELECT intake_Id  as Intake_Id,intake_Name as Intake_Name  from intake  where  DeleteStatus=false  order by intake_Id asc ;
SELECT Enquiryfor_Id,Enquirfor_Name  from Enquiry_For where  DeleteStatus=false  order by Enquirfor_Name asc ;
SELECT Shore_Id,Shore_Name  from shore where  DeleteStatus=false  order by Shore_Name asc;
SELECT Intake_Year_Id,Intake_Year_Name from intake_year where  DeleteStatus=false  order by Intake_Year_Name asc;
SELECT Agent_Id,Agent_Name  from agent where  DeleteStatus=false  order by Agent_Name asc;
SELECT Application_status_Id,Application_Status_Name  from application_status where  DeleteStatus=false  order by Application_Status_Name asc;
SELECT Marital_Status_Id  as Marital_Status_Id,Marital_Status_Name as Marital_Status_Name  from marital_status where  DeleteStatus=false  order by Marital_Status_Name asc;
SELECT  Visa_Type_Id  as Visa_Type_Id,Visa_Type_Name as Visa_Type_Name  from visa_type where  DeleteStatus=false  order by Visa_Type_Name asc;
SELECT  Ielts_Type  as Ielts_Type,Ielts_Type_Name as Ielts_Type_Name  from IELTS_TYPE where  DeleteStatus=false  order by Ielts_Type_Name asc;
SELECT Enquiry_Mode_Id,Enquiry_Mode_Name  from enquiry_mode where  DeleteStatus=false  order by Enquiry_Mode_Name asc;
SELECT Client_Accounts_Id,Client_Accounts_Name  from client_accounts where  DeleteStatus=false and Account_Group_Id in(4,5,11)  order by Client_Accounts_Name asc;
SELECT Bph_Status_Id,Bph_Status_Name  from bph_status where  DeleteStatus=false  order by Bph_Status_Name asc;
SELECT Class_Id,Class_Name  from Class where  DeleteStatus=false  order by Class_Name asc;
SELECT Sort_By_Id,Sort_By_Name  from Sort_By where  DeleteStatus=false  order by Sort_By_Id asc;
SELECT Task_Status_Id,Status_Name  from Task_Status where  Delete_Status=false  order by Task_Status_Id asc;
SELECT Task_Group_Id,Task_Group_Name  from Task_Group where  Delete_Status=false  order by Task_Group_Id asc;
SELECT Agent_Country_Id,Agent_Country_Name from agent_country where  DeleteStatus=false  order by Agent_Country_Id asc;
SELECT Ielts_Status_Id,Ielts_Status_Name from ielts_status where  DeleteStatus=false  order by Ielts_Status_Id asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Status`( In Student_Status_Id_ Int)
Begin 
 SELECT Student_Status_Id,
Student_Status_Name From Student_Status where Student_Status_Id =Student_Status_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Subject`( In Subject_Id_ Int)
Begin 
 SELECT Subject_Id,
Subject_Name From Subject where Subject_Id =Subject_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Sub_Section_From_Course`( In Subject_Id_ Int)
Begin 
SELECT distinct course.Sub_Section_Id,Sub_Section_Name From course
inner join sub_section on course.Sub_Section_Id = sub_section.Sub_Section_Id where subject_id=Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Sub_Status`(in Status_Id_ int)
BEGIN
select Sub_Status_Id,Sub_Status_Name,Status_Id,FollowUp,Duration from sub_status
where DeleteStatus=0 and Status_Id=Status_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Tasknew_Task`( In Student_Id_ Int,Task_Group_Id_ int)
Begin
SELECT DISTINCT(student_task.Student_Task_Id),Task_Group_Id,student_task.Student_Id,Student_Name,
To_User,To_User_Name,Department_Name,Task_Details,
 (Date_Format(student_task.Followup_Date,'%d-%m-%Y')) AS Grid_Followup_Date, (Date_Format(student_task.Followup_Date,'%Y-%m-%d')) AS Followup_Date,
Task_Status,Status_Name,student_task.Remark,task_item.Task_Item_Id,task_item.Task_Item_Name,Department_Id
#,student_followup.Department,student_followup.Dept_Name,student_followup.User_Id,student_followup.UserName
 From student_task 
 inner join task_item on task_item.Task_Item_Id=student_task.Task_Item_Id
  #inner join student_followup on student_followup.Student_Id=student_task.Student_Id
 where student_task.Student_Id =Student_Id_ and student_task.Task_Group_Id=Task_Group_Id_ and student_task.DeleteStatus=false
 ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Task_History`( In Student_Task_Id_ Int)
Begin
SELECT Student_Name, (Date_Format(Followup_Date,'%d-%m-%Y'))as Followup_Date,To_User_Name,Status_Name,Remark,
(Date_Format(Entry_Date,'%d-%m-%Y-%h:%i')) As Entry_Date
 From student_task_followup 
 where Student_Task_Id =Student_Task_Id_ and DeleteStatus=false order by Student_Task_Followup_Id desc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_ToStaff_Student_DataCount`(IN Branch_ INT, IN Followup_Date_ DATE)
BEGIN
SELECT User_Details_Id,User_Details_Name,count(student.Student_Id) as Data_Count From user_details
left join student on user_details.User_Details_Id = student.To_User_Id
and Next_FollowUp_date=Followup_Date_ and student.DeleteStatus=false where user_details.Branch_Id =Branch_ and user_details.DeleteStatus=false
group by User_Details_Id order by  User_Details_Name;

 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_University`( In University_Id_ Int)
Begin 
 SELECT University_Id,
University_Name From University where University_Id =University_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_University_Photos`(in University_Id_ int)
BEGIN
select University_Image from University_Photos
where DeleteStatus=false and University_Id=University_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Branch`( In User_Id_ Int)
Begin
 SELECT Branch_Id From User_Details  
 where User_Details_Id =User_Id_ ;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Branches`( In User_Id_ Int,Branch_ int)
Begin 
SELECT distinct Branch_Id From User_Department where 
User_Id =User_Id_   ;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Department_Edit`( In User_Id_ Int)
Begin 
 SELECT Department.Department_Id ,Department_Name,Branch.Branch_Id,Branch_Name,
 case when User_Department.View_Entry>0 then 1 else 0 end as Check_Box_View,
 case when  User_Department.VIew_All>0 then 1 else 0 end as Check_Box_VIew_All
  From Department inner join Branch_Department 
  on Department.Department_Id=Branch_Department.Department_Id inner join Branch
  on Branch.Branch_Id=Branch_Department.Branch_Id  left join User_Department 
  on Department.Department_Id=User_Department.Department_Id and  Branch.Branch_Id=User_Department.Branch_Id 
   and User_Id=user_Id_
  where Department.Is_Delete=false
  order by Branch_Name,Department_Name asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Details`( In User_Details_Id_ Int)
Begin 
 SELECT User_Details_Id,
User_Details_Name,
Password,
Working_Status,
User_Type,
Role_Id,
Address1,
Address2,
Address3,
Address4,
Pincode,
Mobile,
Email,Employee_Id,
Registration_Target,
FollowUp_Target
 From User_Details where User_Details_Id =User_Details_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Details_Edit`( In User_Details_Id_ Int)
Begin 
 SELECT Menu.Menu_Id ,Menu_Name,
 case when User_Menu_Selection.IsView>0 then 1 else 0 end as IsView,
 case when User_Menu_Selection.IsSave>0 then 1 else 0 end as IsSave,
 case when User_Menu_Selection.IsEdit>0 then 1 else 0 end as IsEdit,
 case when User_Menu_Selection.IsDelete>0 then 1 else 0 end as IsDelete,
 Menu.IsEdit Edit_Check,
	Menu.IsSave Save_Check,
	Menu.IsDelete  Delete_Check
  From Menu 
  left join User_Menu_Selection on  Menu.Menu_Id=User_Menu_Selection.Menu_Id
  and User_Id =User_Details_Id_ where Menu.Menu_Status=1 and
  Menu.DeleteStatus=false order by Menu.Menu_Order,Menu_Order_Sub asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Role`( In User_Role_Id_ Int)
Begin 
 SELECT User_Role_Id,
User_Role_Name,
Role_Under_Id
 From user_role where User_Role_Id =User_Role_Id_ and Is_Delete=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Role_Id`( In User_Id_ Int)
Begin
 SELECT Role_Id From User_Details  
 where User_Details_Id =User_Id_ ;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Status`()
BEGIN

 SELECT User_Status_Id,
User_Status_Name From User_Status
order by User_Status_Name asc  ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Type`()
BEGIN
SELECT User_Type_Id,
User_Type_Name From User_Type 
order by User_Type_Name asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Visa_Details`( In Student_Id_ Int)
Begin
SELECT Visa_Id ,Student_Id, (Date_Format(Approved_Date,'%Y-%m-%d'))   as Approved_Date,(Date_Format(Approved_Date,'%d-%m-%Y'))   as Edit_Approved_Date,
(Date_Format(Approved_Date_L,'%Y-%m-%d'))   as Approved_Date_L,
(Date_Format(Approved_Date_L,'%d-%m-%Y'))   as Edit_Approved_Date_L,
(Date_Format(Approved_Date_F,'%Y-%m-%d'))   as Approved_Date_F,
(Date_Format(Approved_Date_F,'%d-%m-%Y'))   as Edit_Approved_Date_F,

(Date_Format(Visa_Rejected_Date,'%Y-%m-%d'))   as Visa_Rejected_Date,
(Date_Format(ATIP_Submitted_Date,'%Y-%m-%d'))   as ATIP_Submitted_Date,
(Date_Format(ATIP_Received_Date,'%Y-%m-%d'))   as ATIP_Received_Date,
(Date_Format(Visa_Re_Submitted_Date,'%Y-%m-%d'))   as Visa_Re_Submitted_Date,

Total_Fees,Scholarship_Fees,Balance_Fees,Paid_Fees,Visa_Type_Id , Visa_Type_Name , Description,Username,Password,Security_Question,
case when Visa_Granted>0 then 1 else 0 end as Visa_GrantedCheck_Box,
case when Visa_Letter>0 then 1 else 0 end as Visa_Letter,
case when Visa_File>0 then 1 else 0 end as Visa_File,

case when Visa_Rejected>0 then 1 else 0 end as Visa_Rejected,
case when ATIP_Submitted>0 then 1 else 0 end as ATIP_Submitted,
case when ATIP_Received>0 then 1 else 0 end as ATIP_Received,
case when Visa_Re_Submitted>0 then 1 else 0 end as Visa_Re_Submitted

,Application_No
 From visa
 where Student_Id =Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Visa_Documents`(In Visa_Id_ int)
BEGIN
 select  Visa_Document_Id,Visa_Id,(Date_Format(Entry_Date,'%d-%m-%Y')) as Entry_Date,Description,Visa_Document_Name,Visa_Document_File_Name,Visa_File_Name,0 as New_Entry
 from visa_document where Visa_Id = Visa_Id_ and DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Visa_Task`( In Student_Id_ Int,Task_Group_Id_ int)
Begin
SELECT Student_Task_Id,Task_Group_Id,Task_Status,Student_Id,Student_Name,(Date_Format(Followup_Date,'%Y-%m-%d'))  as Followup_Date,Status_Name,Remark,student_task.Task_Item_Id,To_User,To_User_Name,(Date_Format(Followup_Date,'%d-%m-%Y'))  as Grid_Followup_Date,Task_Item_Name
 From student_task 
 inner join task_item on student_task.Task_Item_Id = task_item.Task_Item_Id
 where Student_Id =Student_Id_ and student_task.Task_Group_Id=Task_Group_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_WorkexperienceDetails`( In Student_Id_ Int)
Begin
SELECT Work_Experience_Id,Slno,Student_Id,Ex_From,
Ex_To,Years,Company,Designation,Salary,Salary_Mode,DeleteStatus
 From work_experience 
 where Student_Id =Student_Id_ and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `IELTS_Mode_Dropdown`()
BEGIN
select * from ielts_mode;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Lead_Refund_Approve_Reject`(In Fees_Receipt_Id_ int,Status_ int,Comment_ varchar(1000),Login_User_ int  )
BEGIN
declare Student_Name_ varchar(200);declare Receipt_Status_Name_ varchar(50);declare Notification_Id_ int;declare Notification_Count_ int;
declare User_Name_ varchar(200);declare Student_Id_ int;declare Notification_Type_Name_ varchar(20);declare Entry_Type_ int;
declare To_User_Name_ varchar(200);declare To_User_Id_ int;
Update fees_receipt set Fees_Receipt_Status=Status_,fees_receipt.Comment= Comment_
Where Fees_Receipt_Id = Fees_Receipt_Id_ ;

set Student_Id_ = (select Student_Id from fees_receipt where Fees_Receipt_Id = Fees_Receipt_Id_ );
set Student_Name_ = (select Student_Name from student where Student_Id = Student_Id_);
SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
set User_Name_ =(select User_Details_Name from user_details where User_Details_Id=Login_User_ );
set  To_User_Id_ = (select Counsilor_User from student where Student_Id = Student_Id_);
set To_User_Name_  = (select User_Details_Name from user_details where User_Details_Id=To_User_Id_ );
if Login_User_ !=To_User_Id_  then 
	if Status_ = 7 then 
		set Notification_Type_Name_ = 'Refund Confirmation Removal';
		set Entry_Type_ = 10;		
		set Receipt_Status_Name_ = (select Fees_Receipt_Status_Name from fees_receipt_status where Fees_Receipt_Status_Id = Status_);
		insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
		values(Notification_Id_,Login_User_,User_Name_,To_User_Id_,To_User_Name_,2,Receipt_Status_Name_,1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);
		set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_Id_);    
		update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_Id_;
		
	else
		set Notification_Type_Name_ = 'Refund Confirmation';
		set Entry_Type_ = 7;
		set Receipt_Status_Name_ = (select Fees_Receipt_Status_Name from fees_receipt_status where Fees_Receipt_Status_Id = Status_);
		insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
		values(Notification_Id_,Login_User_,User_Name_,To_User_Id_,To_User_Name_,2,Receipt_Status_Name_,1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

		set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_Id_);    
		update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_Id_;
	end if;
end if;
select Fees_Receipt_Id_,Student_Name_,User_Name_,Notification_Type_Name_,Entry_Type_,To_User_Id_,Notification_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Lead_Refund_Reject`(In Fees_Receipt_Id_ int )
BEGIN

Update fees_receipt set Fees_Receipt_Status =7
where Fees_Receipt_Id = Fees_Receipt_Id_;

select Fees_Receipt_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Account_Group`(In Group_Name_ varchar(100))
Begin 
 set Group_Name_ = Concat( '%',Group_Name_ ,'%');
 SELECT Account_Group_Id,Group_Name
 From Account_Group where  
 Group_Name like Group_Name_ and DeleteStatus=false 
  ORDER BY Group_Name Asc Limit 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Agents`()
BEGIN
select Agent_Id,Agent_Name  from agent where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Application_Fees_Dropdown`(In Student_Id_ int)
BEGIN

#select distinct Course_Id , Course_Name from application_details where DeleteStatus=false;

select application_details.Course_Name,Application_details_Id from application_details
inner join course where application_details.Course_Id=course.Course_Id and application_details.Student_Id= Student_Id_;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_application_status`()
BEGIN
select Application_status_Id,Application_Status_Name  from application_status;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Application_status_forchangestatus`(In Login_Id_ int)
BEGIN
	select Application_status_Id,Application_Status_Name
	from application_status where DeleteStatus=0 and Application_Group_Id in(select Application_Group_Id from
	user_application_group where User_Id = Login_Id_);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Application_status_forchangestatus_restriction`(In Group_Restriction_ int)
BEGIN

select Application_status_Id,Application_Status_Name
from application_status where DeleteStatus=0 and Application_Group_Id=Group_Restriction_ ;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Application_status_for_user`(In Login_User_Id_ int)
BEGIN
select Application_status_Id,Application_Status_Name 
from application_status where Application_Group_Id in (select Application_Group_Id from user_application_group where User_Id = Login_User_Id_);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Automatic_Departments`()
BEGIN
	SELECT Department.Department_Id,Department_Name
	from Department 	
	where Department.Is_Delete=false and Department.Transfer_Method_Id=1
	ORDER BY Department.Department_Id  ;
    select Settings_Value,Settings_Name from application_settings where Editable=1 and DeleteStatus =0;
    select Document_Id,Document_Name from document where DeleteStatus =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Color`()
BEGIN
select *  from colors where Delete_Status =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Company`()
BEGIN
select * from Company;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Country`()
BEGIN
select Country_Id,Country_Name from Country
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_DefaultDepartment`()
BEGIN
select Department_Id,Department_Name  from department where Is_Delete =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Enquiryfor`()
BEGIN
select Enquiryfor_Id,Enquirfor_Name  from Enquiry_For where DeleteStatus =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Intake`()
BEGIN
select intake_Id  as Intake_Id,intake_Name as Intake_Name  from intake where DeleteStatus =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Intake_year`()
BEGIN
select Intake_Year_Id,Intake_Year_Name from intake_year;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_MailAddress_for_Registration`(In Login_Id int,Student_Id_ int)
BEGIN
select User_Details_Id as Tp,Email from user_details where User_Details_Id=Login_Id union
select Student_Id as Tp,Email from student where  Student_Id=Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_MailAddress_for_Report`(In Login_Id int)
BEGIN
select User_Details_Id as Tp, Email,FollowUp_Target from user_details where User_Details_Id=Login_Id union 
select 1 as Tp,Email from company ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Marital_Status`()
BEGIN
select Marital_Status_Id  as Marital_Status_Id,Marital_Status_Name as Marital_Status_Name  from marital_status where DeleteStatus =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_OfferLetter_Type`()
BEGIN
select Offerletter_Type_Id,Offerletter_Type_Name  from offerletter_type where Delete_Status =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Receipt_Data_For_Mail`(In Login_Id_ int)
BEGIN
select Email,FollowUp_Target from user_details where User_Details_Id=Login_Id_ ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Restriction_Status`()
BEGIN
SELECT Application_Group_Id,Application_Group_Name
from application_group;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Shore`()
BEGIN
select Shore_Id,Shore_Name  from shore where DeleteStatus =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Status`()
BEGIN
select Status_Id,Status_Name from Status
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_StatusType`()
BEGIN
select Status_Type_Id ,Status_Type_Name  from status_type where Delete_Status =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Status_Dropdown`()
BEGIN
select Department_Status_Id,Department_Status_Name from department_status where Is_Delete=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_User`(in Login_Id int)
BEGIN
select User_Details_Name,Email,Mobile,FollowUp_Target from user_details where User_Details_Id=Login_Id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_User_Details`()
BEGIN
select User_Details_Id,User_Details_Name from user_details where DeleteStatus=0
;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_User_Role`(In User_Role_Name_ varchar(100))
Begin 
 set User_Role_Name_ = Concat( '%',User_Role_Name_ ,'%');
 SELECT User_Role_Id,User_Role_Name,Role_Under_Id
 From user_role where  
 User_Role_Name like User_Role_Name_ and Is_Delete=false 
  ORDER BY User_Role_Name Asc Limit 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Visa_Type`()
BEGIN
select Visa_Type_Id  as Visa_Type_Id,Visa_Type_Name as Visa_Type_Name  from visa_type
 where DeleteStatus =0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Login_Check`( In User_Details_Name_ VARCHAR(50),
in Password_ VARCHAR(50))
BEGIN
SELECT
User_Details_Id,User_Details_Name,User_Type,Role_Id,Branch_Id,Department_Id,IFNULL(Notification_Count, 0) as Notification_Count,
FollowUp_Target as Extension,Department_Name,Updated_Serial_Id
From User_Details
 where
 User_Details_Name =User_Details_Name_ and Password=Password_ and Working_Status !=2 and DeleteStatus=0 and Agent_Status!=1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Login_Check_Agent`( In User_Details_Name_ VARCHAR(50),
in Password_ VARCHAR(50))
BEGIN
SELECT User_Details_Id,User_Details_Name,User_Type,Role_Id,Branch_Id,Department_Id,IFNULL(Notification_Count, 0) as Notification_Count,
FollowUp_Target as Extension,Department_Name,Updated_Serial_Id From User_Details
where User_Details_Name =User_Details_Name_ and Password=Password_ and Working_Status !=2 and DeleteStatus=0 and Agent_Status=1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `LOR1_Mode_Dropdown`()
BEGIN
select * from lor_1_mode;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `LOR2_Mode_Dropdown`()
BEGIN
select * from lor_2_mode;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `MOI_Mode_Dropdown`()
BEGIN
select * from moi_mode;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Notification_Read_Status`( In Notification_Count_ Int,User_Id_ int)
Begin 
#insert into data_log_ values(0,Notification_Count_,User_Id_);
update user_details set Notification_Count = Notification_Count - Notification_Count_ where User_Details_Id = User_Id_ and DeleteStatus=0;
update notification set Read_Status = true where To_User = User_Id_ and DeleteStatus = 0;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Passport_Mode_Dropdown`()
BEGIN
select * from passport_mode;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Pending_FollowUp`(In Department_ int,Branch_ int,By_User_ int,Login_User_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare Department_String_To_User_ varchar(4000);
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
declare SearchbyName_Value varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Department_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;
if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;
set Department_String_To_User_ =REPLACE(Department_String_,'By_User_Id','To_User_Id');
SET @query = Concat( "select (Date_Format(student.Entry_Date,'%d-%m-%Y')) As Created_On,user_details.User_Details_Name As Created_By,
 student.Student_Name Student,student.Phone_Number Mobile,Branch.Branch_Name Branch,
(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Follow_Up_On,Department.Department_Name Department,
Department_Status.Department_Status_Name Status,T.User_Details_Name To_Staff,B.User_Details_Name Registered_By,
(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On,student.Remark,student.Student_Id
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_To_User_,Search_Date_,"
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
left join user_details as B on B.User_Details_Id=student.Registered_By
where student.DeleteStatus=0 and student.FollowUp=1  ",SearchbyName_Value,"
and T.Role_Id in(",RoleId_,")
order by Next_FollowUp_Date asc ");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Post_FB_Lead`( In Student_Name_ varchar(200),Phone_Number_ varchar(20))
Begin
declare User_Id_ int;
declare User_Status_ int;
declare Backup_User_ int;
declare Working_Status_ int;
declare Sub_User_ int;
declare Status_Id_ int;
declare Department_Status_Id_ int;
declare Department_Status_Name_ varchar(50);
declare Branch_ int;
declare Branch_Name_ varchar(50);
declare By_User_Name_ varchar(250);
declare Department_Name_ varchar(100);
declare Department_FollowUp_ tinyint;
declare To_User_Name_ varchar(250);
declare Student_FollowUp_Id_ int;
declare Department_Id_ int;
declare Remark_Id_ int;
declare Role_Id_ int;
declare Total_User_ int;
declare Student_Id_ int;declare x int;declare Application_details_Id_ int;declare Application_status_Id_ int;declare Old_Id_ int;
declare Application_Status_Name_ varchar(45);declare To_User_ int;declare Notification_Id_ int;declare Remark_ varchar(500);
declare From_User_Name_ varchar(45);declare ToUser_Name_ varchar(45);declare Notification_Count_ int;
declare i int  DEFAULT 0;
set x=0;
#insert into data_log_ values(0,Student_Name_,Phone_Number_);
    set User_Id_ = 0;
    set Department_Id_=336;  
select Department_Status_Id,Total_User,Current_User_Index,Department_Name,FollowUp into
Department_Status_Id_,Total_User_,Sub_User_ ,Department_Name_,Department_FollowUp_
from department where Department_Id=Department_Id_ ;  
if (User_Id_>0) then
if Working_Status_=3 or Working_Status_=2  then
set User_Id_ = Backup_User_;
end if;
else
set User_Id_= (select COALESCE(User_Details_Id ,0)  from user_details where Sub_Slno=Sub_User_ and Department_Id=Department_Id_ );
   
if  ISNULL(User_Id_) then
SET Student_Id_ = -1;            
else    
if Total_User_=Sub_User_ then
set Sub_User_=1;
else
set Sub_User_=Sub_User_+1;
end if;
update department set Current_User_Index =Sub_User_  where Department_Id=Department_Id_;
end if;
end if;  
     
set Department_Status_Name_=(select Department_Status_Name from department_status where Department_Status_Id=Department_Status_Id_);
select Working_Status,Backup_User_Id
into Working_Status_,Backup_User_
from user_details  where User_Details_Id = User_Id_ ;
   
select Working_Status,Backup_User_Id ,Role_Id,Branch_Id,User_Details_Name
into Working_Status_,Backup_User_,Role_Id_ ,Branch_ ,To_User_Name_ from User_Details where User_Details_Id=User_Id_ ;
   
Set Old_Id_ = (select COALESCE(Student_Id ,0) from Student where DeleteStatus=false and (Phone_Number like concat('%',Phone_Number_,'%'))  limit 1);  
#insert into data_log_ values(0,User_Id_,Old_Id_);
if Old_Id_=0 or  IFNULL(User_Id_,0)  then
SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student);
    set Branch_Name_=(select Branch_Name from branch where Branch_Id=Branch_);
set By_User_Name_=(select User_Details_Name from user_details where User_Details_Id=User_Id_);

INSERT INTO Student(Student_Id , Agent_Id, Entry_Date,Student_Name ,Address1 ,Address2 ,Email ,Alternative_Email,Phone_Number,Alternative_Phone_Number ,Dob ,Country_Name ,
Student_Status_Id,
    Enquiry_Source_Id ,Created_By,Whatsapp,DeleteStatus,Is_Registered,FollowUp_Count,FollowUp_EntryDate,
Entry_Type,First_Followup_Status,First_Followup_Date,Programme_Course,Reference,Passport_No,Passport_fromdate,Passport_Todate,Passport_Id,Enquiry_Source_Name,Created_User
,Marital_Status_Id,Marital_Status_Name,Program_Course_Id,Profile_Country_Id,Created_On,
Enquiryfor_Id,Enquirfor_Name,Shore_Id,Shore_Name,Spouse_Name,Date_of_Marriage,Spouse_Occupation,Spouse_Qualification,Dropbox_Link,
No_of_Kids_and_Age,Previous_Visa_Rejection,Enquiry_Mode_Id,Enquiry_Mode_Name,Branch_Id,Department_Id,
Visa_User,Pre_Visa_User,Pre_Admission_User,Admission_User,Applicaton_User,Counsilor_User,Refund_user,Cas_User,Visa_Rejection_User,
Pre_Application_User,Bph_User,Closed_User,Unique_Id,Class_Id,Class_Name,Guardian_telephone,Link_Send_By,Status_Student_Fill,Counsilor_Note,BPH_Note,Pre_Visa_Note)
values (Student_Id_ ,1,now(),Student_Name_ ,'' ,'' ,'' ,'',Phone_Number_ ,
'','' ,'' ,0,
    40 ,User_Id_,'',false,0,0,now(),1,1,now(),'','','',now(),now(),0,'FB, Insta, Twitter',User_Id_,0,'',0,0,now(),
2,'Study Abroad',1,'OffShore','','','','','','','',0,'',Branch_,Department_Id_, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,'','',0,0,'','','');
   

INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id ,Branch,Remark,Remark_Id,By_User_Id,
Class_Id ,DeleteStatus,FollowUP_Time,Actual_FollowUp_Date,Entry_Type,Branch_Name,UserName,ByUserName,Dept_StatusName,Dept_Name,Student,FollowUp)
values (Student_Id_ ,Now(),Now(),0,Department_Id_ ,Department_Status_Id_ ,User_Id_ ,Branch_,'',0,User_Id_,1,false,
Now(),Now(),1,Branch_Name_,To_User_Name_,By_User_Name_,Department_Status_Name_,Department_Name_,Student_Name_,Department_FollowUp_);
    set Student_Followup_Id_ =(SELECT LAST_INSERT_ID());
   
    update Student set Student_Followup_Id=Student_Followup_Id_,Next_FollowUp_Date=now(),
Status_Id=Department_Status_Id_,By_User_Id=User_Id_,To_User_Id=User_Id_,Remark='',Remark_Id=0,Followup_Department_Name = Department_Name_,
Department_Status_Name = Department_Status_Name_,To_User_Name = By_User_Name_,By_UserName = By_User_Name_,FollowUp = Department_FollowUp_,
    Followup_Department_Id=Department_Id_,Followup_Branch_Id = Branch_,Role_Id = Role_Id_
where Student_Id=Student_Id_;
   
end if;
select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Public_Search_Course`(In Level_Detail_Id_ int,Country_Id_ int,
Intake_Id_ varchar(100),Sub_Section_Id_ varchar(100),Course_Name_ varchar(100),Branch_Search_ varchar(100),Duration_Search_ varchar(100),Ielts_ int,
Page_Start_ int,Page_End_ int,Page_Length_ int,University_ int,Subject_1 int)
Begin 
declare SearchbyName_Value varchar(2000);
declare SearchQuery_sub varchar(2000);
declare SearchQuery_sub_section varchar(2000);
set SearchQuery_sub=' ';
set SearchQuery_sub_section=' ';
set SearchbyName_Value='';
if Intake_Id_!='' &&  Intake_Id_!='0'  then
	#SET SearchbyName_Value =concat(SearchbyName_Value," );
    set SearchbyName_Value =concat(SearchbyName_Value,"  and course_id in (select course_id from  course_intake where
    Intake_Id in(",Intake_Id_,"))");
end if;

if Sub_Section_Id_!=''  &&  Sub_Section_Id_!='0'  then
	#SET SearchbyName_Value =concat(SearchbyName_Value," );
    set SearchQuery_sub_section=concat(" and Sub_Section_Id in(",Sub_Section_Id_,")");
end if;
if Level_Detail_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Level_Id =",Level_Detail_Id_);
end if;
if Country_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Country_Id =",Country_Id_);
end if;
if Ielts_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Ielts_Minimum_Score  <=",Ielts_);
end if;
if Course_Name_!='' then
SET SearchbyName_Value =   Concat(SearchbyName_Value, " and( course.Course_Name like '%",Course_Name_ ,"%'") ;
SET SearchbyName_Value =   Concat(SearchbyName_Value, " or course.Tag like '%",Course_Name_ ,"%')") ;
end if;
/*if Duration_Search_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.Duration_Id in (",Duration_Search_ ,")") ;
end if;*/
/*if Branch_Search_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.Subject_Id in (",Branch_Search_ ,")") ;
end if;*/
if University_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.University_Id in (",University_ ,")") ;
end if;
if Subject_1!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.Subject_Id in (",Subject_1,")") ;
end if;
SET @query = Concat("select * from(select * from (SELECT 1 tp,course.Course_Id,Course_Name,Country_Name,University_Name,false More_Information,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Course.Course_Name DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from Course 
inner join country on course.Country_Id = country.Country_Id
inner join university  on course.University_Id = university.University_Id ",SearchQuery_sub,SearchQuery_sub_section, " 
where Course.DeleteStatus = false  " ,SearchbyName_Value," order by Course.Course_Name desc )
 as lds WHERE RowNo >=",Page_Start_," AND RowNo<= ",Page_End_,"
 order by  RowNo LIMIT ",Page_Length_," ) as t union 
 SELECT 0 tp ,count(Course_Id) as Course_Id,'' Course_Name,'' Country_Name,'' University_Name,1  More_Information,
0 RowNo
from Course 
inner join country on course.Country_Id = country.Country_Id
inner join university  on course.University_Id = university.University_Id ",SearchQuery_sub,SearchQuery_sub_section, " 
where Course.DeleteStatus = false " ,SearchbyName_Value, " order by tp desc");
 
#insert into db_logs values(Duration_Search_,@query,1,0);
PREPARE QUERY FROM @query;
EXECUTE QUERY;


#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Public_Search_Course_Typeahead`(In Level_Detail_Id_ int,Country_Id_ int,
Intake_Id_ varchar(100),Sub_Section_Id_ varchar(100),Course_Name_ varchar(100),Branch_Search_ varchar(100),Duration_Search_ varchar(100),Ielts_ int,
Page_Start_ int,Page_End_ int,Page_Length_ int,University_ int,Subject_1 int)
Begin 
declare SearchbyName_Value varchar(2000);
declare SearchQuery_sub varchar(2000);
declare SearchQuery_sub_section varchar(2000);
set SearchQuery_sub=' ';
set SearchbyName_Value='';
set SearchQuery_sub_section=' ';


if Intake_Id_!='' &&  Intake_Id_!='0'  then
	#SET SearchbyName_Value =concat(SearchbyName_Value," );
    set SearchbyName_Value =concat(SearchbyName_Value,"  and course_id in (select course_id from  course_intake where
    Intake_Id in(",Intake_Id_,"))");
end if;

/*if Intake_Year_Id_!='' &&  Intake_Year_Id_!='0'  then
	#SET SearchbyName_Value =concat(SearchbyName_Value," );
    set SearchbyName_Value =concat(SearchbyName_Value,"  and course_id in (select course_id from  course_intake where
    Intake_Year_Id in(",Intake_Year_Id_,"))");
end if;*/


if Sub_Section_Id_!='' &&  Sub_Section_Id_!='0' then
	#SET SearchbyName_Value =concat(SearchbyName_Value," );
    set SearchQuery_sub_section=concat(" and Sub_Section_Id in(",Sub_Section_Id_,")");
end if;
if Level_Detail_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Level_Id =",Level_Detail_Id_);
end if;
if Country_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Country_Id =",Country_Id_);
end if;
if Ielts_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Ielts_Minimum_Score  <=",Ielts_);
end if;
if Course_Name_!='' then
SET SearchbyName_Value =   Concat(SearchbyName_Value, " and( course.Course_Name like '%",Course_Name_ ,"%'") ;
SET SearchbyName_Value =   Concat(SearchbyName_Value, " or course.Tag like '%",Course_Name_ ,"%')") ;
end if;
/*if Duration_Search_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.Duration_Id in (",Duration_Search_ ,")") ;
end if;
if Branch_Search_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.Subject_Id in (",Branch_Search_ ,")") ;
end if;*/
if University_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.University_Id in (",University_ ,")") ;
end if;
if Subject_1!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and Course.Subject_Id in (",Subject_1 ,")") ;
end if;
SET @query = Concat("SELECT course.Course_Id,Course_Name,Country_Name,University_Name,false More_Information
from Course 
inner join country on course.Country_Id = country.Country_Id
inner join university  on course.University_Id = university.University_Id ",SearchQuery_sub,SearchQuery_sub_section," 
where Course.DeleteStatus = false  " ,SearchbyName_Value," order by Course.Course_Name desc Limit 5");

#insert into db_logs values(Duration_Search_,@query,1,0);
PREPARE QUERY FROM @query;
EXECUTE QUERY;

#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Receipt_Approve`(In Fees_Receipt_Id_ int,Login_User_ int,applicationdetails_Id_ int,Receiptamount_ varchar(100) )
BEGIN
declare Amt_ varchar(45);declare Fee_Receipt_Branch_ int;declare first_Receipt int;
Declare Target_ int;declare Registration_Branch_ int;declare Student_Registration_Id_ int;
declare Registered_User_ varchar(100);declare Registered_Branch_Name_ varchar(100);
declare bph_approved_status_ int default 0; declare Student_Id_ int;
declare Student_Name_ varchar(200);declare Receipt_Status_Name_ varchar(50);declare Notification_Id_ int;declare Notification_Count_ int;
declare User_Name_ varchar(200);declare Notification_Type_Name_ varchar(45);
declare counsellor_id_ int;declare Entry_Type_ int;
declare To_User_Name_ varchar(45);declare To_User_Id_ int;
SET Fee_Receipt_Branch_=(select Branch_Id from user_details where User_Details_Id=Login_User_);
#SET first_Receipt=(select Fees_Receipt_Status  from fees_receipt where Fees_Receipt_Id=Fees_Receipt_Id_);
if applicationdetails_Id_>0 then
	SET bph_approved_status_=(select Bph_Approved_Status  from application_details where Application_details_Id=applicationdetails_Id_);
	set Student_Id_=(select Student_Id  from application_details where Application_details_Id=applicationdetails_Id_);
else
	set Student_Id_=(select Student_Id  from fees_receipt where Fees_Receipt_Id=Fees_Receipt_Id_);
end if;
 #insert into  data_logs values (0,bph_approved_status) ;; 
Update fees_receipt set Fees_Receipt_Status = 2 where Fees_Receipt_Id = Fees_Receipt_Id_;

set counsellor_id_=(select Counsilor_User  from student where Student_Id=Student_Id_);
if (counsellor_id_>0) then 
 if(applicationdetails_Id_>0) then
       set Amt_ = (select Application_Fees_Paid from application_details where Application_details_Id=applicationdetails_Id_);
	if(Amt_=-1) then
        set Amt_=0;
	end if;
		update application_details set Application_Fees_Paid=Amt_+Receiptamount_ where Application_details_Id=applicationdetails_Id_;
end if;
#Registration
if (bph_approved_status_=2) then
		set Registration_Branch_=Fee_Receipt_Branch_;
		set Target_=(select Registration_Target from user_details where User_Details_Id=Login_User_ );
		set Registered_User_=(select User_Details_Name from user_details where User_Details_Id=counsellor_id_ );
		set Registered_Branch_Name_=(select Branch_Name from branch where Branch_Id=Registration_Branch_);        
		set Student_Registration_Id_ = (SELECT  COALESCE( MAX(Student_Registration_Id ),0)+1 FROM Student);
		Update Student set Is_Registered = true , Registered_By = counsellor_id_ , Registered_On = now(),Registration_Target=Target_,Registration_Branch=Registration_Branch_,
		Student_Registration_Id = Student_Registration_Id_,Registered_User=Registered_User_,Registered_Branch=Registered_Branch_Name_ where Student_Id = Student_Id_;
	 end if;
end if;
set Student_Name_ = (select Student_Name from student where Student_Id = Student_Id_);
SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
set Entry_Type_ = 5;
set User_Name_ =(select User_Details_Name from user_details where User_Details_Id=Login_User_ );
set Notification_Type_Name_ = 'Receipt Confirmation';
set To_User_Id_ = (select Counsilor_User from student where  Student_Id = Student_Id_);
if Login_User_ != To_User_Id_ and To_User_Id_>0 then
	set To_User_Name_ = (select User_Details_Name from user_details where User_Details_Id=To_User_Id_ );
	set Receipt_Status_Name_ = (select Fees_Receipt_Status_Name from fees_receipt_status where Fees_Receipt_Status_Id = 2);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
	values(Notification_Id_,Login_User_,User_Name_,To_User_Id_,To_User_Name_,2,Receipt_Status_Name_,1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);
	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_Id_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_Id_;
end if;
select Fees_Receipt_Id_,Student_Name_,User_Name_,Notification_Type_Name_,Entry_Type_,To_User_Id_,Notification_Id_,Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Refund_Approve`(In Fees_Receipt_Id_ int,Student_Id_ int,Login_User_ int  )
BEGIN
declare Student_Name_ varchar(45);declare Notification_Id_ int;
declare From_User_Name_ varchar(45);
declare Notification_Count_ int;declare Notification_Type_Name_ varchar(20);declare Entry_Type_ int;
declare To_User_Name_ varchar(45);declare To_User_Id_ int;
set To_User_Id_ = (select Counsilor_User from student where  Student_Id = Student_Id_);
set Student_Name_ =(select Student_Name from Student where Student_Id = Student_Id_ and DeleteStatus=false);
set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_ and DeleteStatus=false); 
set To_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_Id_ and DeleteStatus=false); 
set Notification_Type_Name_ = 'Refund Approval';
set Entry_Type_ = 11;
if Login_User_!=To_User_Id_ then
	SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
	values(Notification_Id_,Login_User_,From_User_Name_,To_User_Id_,To_User_Name_,0,'',1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_Id_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_Id_;
end if; 
Update fees_receipt set Fees_Receipt_Status=6
Where Fees_Receipt_Id = Fees_Receipt_Id_ ;


select Fees_Receipt_Id_,Student_Name_,From_User_Name_,Notification_Type_Name_,Entry_Type_,To_User_Id_,Notification_Id_,Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Register_Candidate`(In Student_Id_ int , User_Id_ int )
BEGIN
Declare Target_ int;declare Registration_Branch_ int;declare Student_Registration_Id_ int;
declare Registered_User_ varchar(100);declare Registered_Branch_Name_ varchar(100);
Declare Department_Id_Reg_ int;
declare Register_Transfer_Status_Tik_ tinyint;
declare Status_Id_ int;declare Status_Name_ varchar(500);

set Registration_Branch_=(select Branch_Id from user_details where User_Details_Id= User_Id_);
set Target_=(select Registration_Target from user_details where User_Details_Id=User_Id_ );
set Registered_User_=(select User_Details_Name from user_details where User_Details_Id=User_Id_ );
set Registered_Branch_Name_=(select Branch_Name from branch where Branch_Id=Registration_Branch_);
set Student_Registration_Id_ = (SELECT  COALESCE( MAX(Student_Registration_Id ),0)+1 FROM Student);
set Department_Id_Reg_ =(select Department_Id from application_settings);
set Register_Transfer_Status_Tik_ =(select Register_Transfer_Status from application_settings);

set Status_Id_=(select Department_Status_Id from department where Department_Id=Department_Id_Reg_);
set Status_Name_=(select Department_Status_Name from department_status where Department_Status_Id=Status_Id_);

Update Student set Is_Registered = true , Registered_By = User_Id_ , Registered_On = now(),
Registration_Target=Target_,Registration_Branch=Registration_Branch_,
Student_Registration_Id = Student_Registration_Id_,
Registered_User=Registered_User_,Registered_Branch=Registered_Branch_Name_
where Student_Id = Student_Id_;
update application_details set Is_Entrolled=1 where Student_Id=Student_Id_;
select Student_Id_,Department_Id_Reg_,Register_Transfer_Status_Tik_,Status_Id_,Status_Name_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remarks_Typeahead`( In Remarks_Name_ varchar(100))
Begin
 set Remarks_Name_ = Concat( '%',Remarks_Name_ ,'%');
select  Remarks.Remarks_Id,Remarks_Name
From Remarks
where  Remarks.DeleteStatus=false
order by Remarks_Name asc   ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Activity`(In Application_details_Id_ int )
BEGIN
declare From_User_Name_ varchar(100);declare ToUser_Name_ varchar(100);declare Notification_Id_ int;
declare Notification_Count_ int;declare Notification_Type_Name_ varchar(45);declare  Entry_Type_ int;
declare Status_Id_ int;declare To_User_ int;declare Login_User_ int;declare Student_Id_ int;
declare Student_Name_ varchar(100);declare Status_Name_ varchar(100);declare Remark_ varchar(1000);
Update application_details set Activation_Status = false
where Application_details_Id = Application_details_Id_;
Update application_details_history set Activation_Status = false
where Application_details_Id = Application_details_Id_;

set Student_Id_ = (select Student_Id from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
set To_User_ =(select Admission_User from Student where Student_Id = Student_Id_ and DeleteStatus=false);
set Login_User_ =(select User_Id from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
if Login_User_ !=To_User_ then 	
	set Student_Name_ =(select Student_Name from Student where Student_Id = Student_Id_ and DeleteStatus=false);
	set Status_Id_ =(select Application_status_Id from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
	set Status_Name_ =(select Application_Status_Name from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
	set Remark_ =(select Remark from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);
	set Entry_Type_ = 3;
	set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_ and DeleteStatus=false); 
	set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false); 
	set Notification_Type_Name_ = 'Activation/Deactivation';
	SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
							values(Notification_Id_,Login_User_,From_User_Name_,To_User_,ToUser_Name_,Status_Id_,Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_; 
end if;

select Application_details_Id_,Student_Name_,From_User_Name_,Notification_Type_Name_,Entry_Type_,To_User_,Notification_Id_,Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Receipt_Approval`(In Fees_Receipt_Id_ int )
BEGIN

Update fees_receipt set Fees_Receipt_Status = 1
where Fees_Receipt_Id = Fees_Receipt_Id_;

select Fees_Receipt_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Refund_Approval`(In Fees_Receipt_Id_ int,Login_User_ int)
BEGIN
declare Student_Name_ varchar(200);declare Receipt_Status_Name_ varchar(50);declare Notification_Id_ int;declare Notification_Count_ int;
declare User_Name_ varchar(200);declare Student_Id_ int;declare Notification_Type_Name_ varchar(20);declare Entry_Type_ int;
declare To_User_Name_ varchar(200);declare To_User_Id_ int;declare From_User_Name_ varchar(100);

Update fees_receipt set Fees_Receipt_Status = 5
where Fees_Receipt_Id = Fees_Receipt_Id_;

set Student_Id_ = (select Student_Id from fees_receipt where Fees_Receipt_Id = Fees_Receipt_Id_ );
set Student_Name_ = (select Student_Name from student where Student_Id = Student_Id_);
SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
set User_Name_ =(select User_Details_Name from user_details where User_Details_Id=Login_User_ );
set Notification_Type_Name_ = 'Refund Approval Removal';
set To_User_Id_ = 83;
set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_ and DeleteStatus=false); 
set To_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_Id_ and DeleteStatus=false);
set Entry_Type_ = 9;
if Login_User_ !=To_User_Id_  then 
	set Receipt_Status_Name_ = (select Fees_Receipt_Status_Name from fees_receipt_status where Fees_Receipt_Status_Id = Status_);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
	values(Notification_Id_,Login_User_,User_Name_,To_User_Id_,To_User_Name_,2,Receipt_Status_Name_,1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_Id_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_Id_;
end if;

select Fees_Receipt_Id_,Student_Name_,User_Name_,Notification_Type_Name_,Entry_Type_,To_User_Id_,Notification_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Registration`(In Student_Id_ int )
BEGIN
Update Student set Is_Registered = false,Student_Registration_Id=0
where Student_Id = Student_Id_;
update application_details set Is_Entrolled=0 where Student_Id=Student_Id_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Student_Approval`(In Application_details_Id_ int )
BEGIN
 declare Application_details_History_Id_ int;
Update application_details set Student_Approved_Status = false
where Application_details_Id = Application_details_Id_;

set Application_details_History_Id_=(select max(Application_details_History_Id) from Application_details_History where Application_details_Id=Application_details_Id_);

Update application_details_history set Student_Approved_Status =false
where  Application_details_History_Id = Application_details_History_Id_;


#update application_details_history set Student_Approved_Status = false
#where Application_details_Id = Application_details_Id_;
select Application_details_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Reset_Notification_Count`(In User_Id_ int)
BEGIN
declare Notification_Count_ int;
update user_details set Notification_Count = 0 where User_Details_Id = User_Id_;
update notification set Read_Status = 1 where To_User = User_Id_;
set  Notification_Count_ = (select Notification_Count from user_details where User_Details_Id = User_Id_) ;
select Notification_Count_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Resume_Mode_Dropdown`()
BEGIN
select * from resume_mode;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Account_Group`( In Account_Group_Id_ decimal,
Primary_Id_ decimal,
Group_Code_ varchar(50),
Group_Name_ varchar(200),
Link_Left_ decimal,
Link_Right_ decimal,
Under_Group_ decimal,
IsPrimary_ varchar(1),
CanDelete_ varchar(1),
UserId_ decimal)
Begin 
 if  Account_Group_Id_>0
 THEN 
 UPDATE Account_Group set Account_Group_Id = Account_Group_Id_ ,
Primary_Id = Primary_Id_ ,
Group_Code = Group_Code_ ,
Group_Name = Group_Name_ ,
Link_Left = Link_Left_ ,
Link_Right = Link_Right_ ,
Under_Group = Under_Group_ ,
IsPrimary = IsPrimary_ ,
CanDelete = CanDelete_ ,
UserId = UserId_  Where Account_Group_Id=Account_Group_Id_ ;
 ELSE 
 SET Account_Group_Id_ = (SELECT  COALESCE( MAX(Account_Group_Id ),0)+1 FROM Account_Group); 
 INSERT INTO Account_Group(Account_Group_Id ,
Primary_Id ,
Group_Code ,
Group_Name ,
Link_Left ,
Link_Right ,
Under_Group ,
IsPrimary ,
CanDelete ,
UserId ,
DeleteStatus ) values (Account_Group_Id_ ,
Primary_Id_ ,
Group_Code_ ,
Group_Name_ ,
Link_Left_ ,
Link_Right_ ,
Under_Group_ ,
IsPrimary_ ,
CanDelete_ ,
UserId_ ,
false);
 End If ;
 select Account_Group_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Agent`( In Client_Accounts_Id_ decimal,
Account_Group_Id_ decimal,Client_Accounts_Code_ varchar(50),Client_Accounts_Name_ varchar(500),
Client_Accounts_No_ varchar(50),Address1_ varchar(250),Address2_ varchar(250),
Address3_ varchar(250),Address4_ varchar(250),PinCode_ varchar(50),StateCode_ varchar(50),
GSTNo_ varchar(50) ,PanNo_ varchar(50),State_ varchar(1000),Country_ varchar(1000),
Phone_ varchar(50),Mobile_ varchar(50),Email_ varchar(200),Opening_Balance_ decimal,
Description1_ varchar(1000),UserId_ decimal,LedgerInclude_ varchar(50),CanDelete_ varchar(2),
Commision_ decimal,Opening_Type_ int,Employee_Id_ decimal(18,0))
Begin 
declare Entry_Date_ datetime;
set Entry_Date_=(SELECT CURRENT_DATE());
 if  Client_Accounts_Id_>0
 THEN 
 UPDATE Client_Accounts set 
Account_Group_Id = Account_Group_Id_ ,Client_Accounts_Code = Client_Accounts_Code_ ,
Client_Accounts_Name = Client_Accounts_Name_ ,Client_Accounts_No = Client_Accounts_No_ ,
Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_ ,Address4 = Address4_ ,
PinCode = PinCode_ ,StateCode=StateCode_,GSTNo =GSTNo_,PanNo =PanNo_,
State = State_ ,Country = Country_ ,Phone = Phone_ ,Mobile = Mobile_ ,Email = Email_ ,
Opening_Balance = Opening_Balance_ ,Description1 = Description1_ ,Entry_Date = Entry_Date_ ,
UserId = UserId_ ,LedgerInclude = LedgerInclude_ ,CanDelete = CanDelete_ ,
Commision = Commision_ ,Opening_Type=Opening_Type_ ,Employee_Id=Employee_Id_ 
Where Client_Accounts_Id=Client_Accounts_Id_ ;
 ELSE 
 SET Client_Accounts_Id_ = (SELECT  COALESCE( MAX(Client_Accounts_Id ),0)+1 FROM Client_Accounts); 
 INSERT INTO Client_Accounts(Client_Accounts_Id ,Account_Group_Id ,Client_Accounts_Code ,
Client_Accounts_Name ,Client_Accounts_No ,Address1 ,Address2 ,Address3 ,Address4 ,PinCode ,
StateCode,GSTNo,PanNo, State ,Country ,Phone ,Mobile ,Email ,Opening_Balance ,Description1 ,
Entry_Date ,UserId ,LedgerInclude ,CanDelete ,Commision ,Opening_Type,Employee_Id,DeleteStatus ) 
values (Client_Accounts_Id_ ,Account_Group_Id_ ,Client_Accounts_Code_ ,Client_Accounts_Name_ ,
Client_Accounts_No_ ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,PinCode_ ,
StateCode_,GSTNo_,PanNo_, State_ ,Country_ ,Phone_ ,Mobile_ ,Email_ ,Opening_Balance_ ,Description1_ ,
Entry_Date_ ,UserId_ ,LedgerInclude_ ,CanDelete_ ,Commision_ ,Opening_Type_,Employee_Id_,false);
	#set Client_Accounts_Id_=(SELECT LAST_INSERT_ID());
 End If ;
 select Client_Accounts_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Agent_Details`( In Agent_Id_ int,Agent_Name_ varchar(500) ,
Phone_ varchar(45), Email_ varchar(100) ,
Address_ varchar(500), Description_ varchar(500),
User_Name_ varchar(150),Password_ varchar(45),Enquiry_Source_Id_ int)
Begin
declare User_Details_Id_ int;
 SET Enquiry_Source_Id_ = (SELECT  COALESCE( MAX(Enquiry_Source_Id ),0)+1 FROM Enquiry_Source); 
if  Agent_Id_>0
 THEN 
UPDATE agent set Agent_Id = Agent_Id_ ,
Agent_Name = Agent_Name_,Phone =Phone_,Email=Email_,Address=Address_,Description =Description_ ,
User_Name=User_Name_,Password=Password_,Enquiry_Source_Id=Enquiry_Source_Id_
Where Agent_Id=Agent_Id_ ;
 ELSE 
 SET Agent_Id_ = (SELECT  COALESCE( MAX(Agent_Id ),0)+1 FROM agent); 
 INSERT INTO agent(Agent_Id,Agent_Name,Phone,Email,Address,Description,DeleteStatus,User_Name,Password,Enquiry_Source_Id,Agent_Status) 
 values ( Agent_Id_,Agent_Name_,Phone_,Email_,Address_,Description_,false,User_Name_,Password_,Enquiry_Source_Id_,1);
 End If ;
 
  INSERT INTO Enquiry_Source(Enquiry_Source_Id ,
Enquiry_Source_Name,DeleteStatus,Agent_Status) values (Enquiry_Source_Id_ ,
Agent_Name_,false,1 );

 SET User_Details_Id_ = (SELECT  COALESCE( MAX(User_Details_Id ),0)+1 FROM User_Details); 
INSERT INTO User_Details(User_Details_Id ,User_Details_Name ,Password ,Working_Status ,User_Type ,Role_Id ,Branch_Id,
		Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,Mobile ,Email ,Employee_Id,Registration_Target,FollowUp_Target,
		Department_Id,Department_Name,Sub_Slno,Backup_User_Id,Backup_User_Name,Application_View,All_Time_Department,Default_Application_Status_Id,Default_Application_Status_Name,
        Updated_Serial_Id,DeleteStatus,Agent_Status )
		values (User_Details_Id_ ,User_Name_ ,Password_ ,1 ,1 ,
		0 ,41,Address_ ,'' ,'' ,'' ,'' ,Phone_ ,Email_ ,0,0,'',
		0,'',0,0,'',0,0,0,'',0,false,1);
 
 select Agent_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Agent_Student`( IN Student_Id_ int,Student_Name_ varchar(500),Phone_Number_ varchar(25),Email_ varchar(100),
Enquiry_Source_Id_ int,Enquiry_Source_Name_ varchar(100),Address1_ varchar(200),Exam_Date_Status_ tinyint ,Exam_Date_ varchar(100),Ielts_Status_Id_ INT,
Ielts_Status_Name_ varchar(200),Agent_Country_ JSON)
BEGIN
declare Agent_Country_Id_ int;declare Agent_Country_Name_ varchar(100);
declare Department_Id_Created_ int; declare Created_Transfer_Status_Tik_ int;
DECLARE i int  DEFAULT 0;


if  Student_Id_>0
  THEN 
	UPDATE student set Student_Id = Student_Id_ ,
    Student_Name=Student_Name_,
    Phone_Number=Phone_Number_,
    Email=Email_,
    Enquiry_Source_Id =Enquiry_Source_Id_,
	Enquiry_Source_Name = Enquiry_Source_Name_ ,
    Address1=Address1_,
    Exam_Date_Status=Exam_Date_Status_,
    Exam_Date=Exam_Date_,
    Ielts_Status_Id=Ielts_Status_Id_,
    Ielts_Status_Name=Ielts_Status_Name_
	where Student_Id = Student_Id_;
   
ELSE 
	SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM student); 
	INSERT INTO student(Student_Id ,Student_Name ,Phone_Number ,Email ,Enquiry_Source_Id,Enquiry_Source_Name,Address1,Exam_Date_Status,Exam_Date,Ielts_Status_Id,Ielts_Status_Name,Entry_date,Created_By,Created_User,DeleteStatus ) 
	values (Student_Id_ ,Student_Name_ ,Phone_Number_ ,Email_ ,Enquiry_Source_Id_,Enquiry_Source_Name_,Address1_,Exam_Date_Status_,Exam_Date_,Ielts_Status_Id_,Ielts_Status_Name_,now(),Enquiry_Source_Id_,Enquiry_Source_Name,false);
End If ;
  

WHILE i < JSON_LENGTH(Agent_Country_) DO
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Agent_Country_,CONCAT('$[',i,'].Agent_Country_Id'))) INTO Agent_Country_Id_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Agent_Country_,CONCAT('$[',i,'].Agent_Country_Name'))) INTO Agent_Country_Name_;
	INSERT INTO student_agent_country(Student_Id,Agent_Id,Agent_Country_Id,Agent_Country_Name,DeleteStatus)
	values (Student_Id_,Enquiry_Source_Id_,Agent_Country_Id_,Agent_Country_Name_,false);
	SELECT i + 1 INTO i;
END WHILE; 

set Department_Id_Created_ =(select Department_Id_Created from application_settings);
set Created_Transfer_Status_Tik_ =(select Created_Transfer_Status from application_settings);


 select Student_Id_,Department_Id_Created_,Created_Transfer_Status_Tik_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_ApplicationDetails`( In Application_details_Id_ int,
Student_Id_ int,Country_Id_ int,Country_Name_ varchar(50),University_Id_ int,
University_Name_ varchar(150),Course_Id_ int,Course_Name_ varchar(500),
intake_Id_ int,intake_Name_ varchar(150),Intake_Year_Id_ int,Intake_Year_Name_ varchar(45),
Date_Of_Applying_ datetime,Remark_ varchar(450),Application_status_Id_ int,
Application_Status_Name_ varchar(45),Agent_Id_ int,Agent_Name_ varchar(150))
Begin 
declare old_Country_Id_ int;declare old_University_Id_ int;declare old_Course_Id_ int;
declare old_intake_Id_ int;declare old_Intake_Year_Id_ int;declare old_Application_status_Id_ int;
declare old_Agent_Id_ int;declare old_Country_Name_ varchar(1000);declare old_University_Name_  varchar(1000);declare old_Course_Name_  varchar(1000);
declare old_intake_Name_  varchar(1000);declare old_Intake_Year_Name_  varchar(1000);declare old_Application_status_Name_  varchar(1000);
declare old_Agent_Name_  varchar(1000);declare old_Remark_  varchar(1000);


 if  Application_details_Id_>0
 THEN 
 set old_Country_Id_=(select Country_Id from application_details where Application_details_Id =Application_details_Id_);
 set old_Country_Name_=(select Country_Name from application_details where Application_details_Id =Application_details_Id_);
set old_University_Id_=(select University_Id from application_details where   Application_details_Id =Application_details_Id_);
set old_University_Name_=(select University_Name from application_details where   Application_details_Id =Application_details_Id_);
set old_Course_Id_=(select Course_Id from application_details where   Application_details_Id =Application_details_Id_);
set old_Course_Name_=(select Course_Name from application_details where   Application_details_Id =Application_details_Id_);
set old_intake_Id_=(select intake_Id from application_details where   Application_details_Id =Application_details_Id_);
set old_intake_Name_=(select intake_Name from application_details where   Application_details_Id =Application_details_Id_);
set old_Intake_Year_Id_=(select Intake_Year_Id from application_details where  Application_details_Id =Application_details_Id_);
set old_Intake_Year_Name_=(select Intake_Year_Name from application_details where  Application_details_Id =Application_details_Id_);
set old_Application_status_Id_=(select Application_status_Id from application_details where  Application_details_Id =Application_details_Id_);
set old_Application_status_Name_=(select Application_Status_Name from application_details where  Application_details_Id =Application_details_Id_);
set old_Agent_Id_=(select Agent_Id from application_details where   Application_details_Id =Application_details_Id_);
set old_Agent_Name_=(select Agent_Name from application_details where   Application_details_Id =Application_details_Id_);
set old_Remark_=(select Remark from application_details where   Application_details_Id =Application_details_Id_);

 if old_Country_Id_ != Country_Id_ or old_University_Id_ != University_Id_ or
 old_Course_Id_ != Course_Id_ or  old_intake_Id_ != intake_Id_ or
old_Intake_Year_Id_ != Intake_Year_Id_ or old_Application_status_Id_ != Application_status_Id_ or
old_Agent_Id_ != Agent_Id_ 
then
 #SET Application_details_Id_ = (SELECT  COALESCE( MAX(Application_details_Id ),0)+1 FROM application_details_history); 
 insert into application_details_history (Application_details_Id,Student_Id,Country_Id,Country_Name,
 University_Id,University_Name,Course_Id,Course_Name,
 intake_Id,intake_Name,Intake_Year_Id,Intake_Year_Name,Date_Of_Applying,Remark,
 Application_status_Id,Application_Status_Name,Agent_Id,Agent_Name,DeleteStatus)
values (Application_details_Id_,Student_Id_,old_Country_Id_,old_Country_Name_,old_University_Id_,
old_University_Name_,old_Course_Id_,old_Course_Name_,
 old_intake_Id_,old_intake_Name_,Intake_Year_Id_,old_Intake_Year_Name_,Date_Of_Applying_,old_Remark_,
 old_Application_status_Id_,old_Application_status_Name_,old_Agent_Id_,old_Agent_Name_,false );
 End If ;
 UPDATE application_details set
Student_Id = Student_Id_,Country_Id = Country_Id_,Country_Name=Country_Name_,
University_Id=University_Id_,University_Name=University_Name_,Course_Id=Course_Id_,
Course_Name=Course_Name_,intake_Id=intake_Id_,intake_Name=intake_Name_,
Intake_Year_Id=Intake_Year_Id_,Intake_Year_Name=Intake_Year_Name_,
Date_Of_Applying=Date_Of_Applying_,Remark=Remark_,Application_status_Id=Application_status_Id_,
Application_Status_Name=Application_Status_Name_,Agent_Id=Agent_Id_,Agent_Name=Agent_Name_
  Where Application_details_Id=Application_details_Id_;
 ELSE 
 SET Application_details_Id_ = (SELECT  COALESCE( MAX(Application_details_Id ),0)+1 FROM application_details); 
 INSERT INTO application_details(Application_details_Id ,Student_Id,Country_Id,
 Country_Name,University_Id,University_Name,Course_Id,Course_Name,intake_Id,
 intake_Name,Intake_Year_Id,Intake_Year_Name,Date_Of_Applying,Remark,Application_status_Id,
 Application_Status_Name,Agent_Id,Agent_Name,Activation_Status,Student_Approved_Status,Bph_Approved_Status,
DeleteStatus) 
values (Application_details_Id_ ,Student_Id_,Country_Id_,
 Country_Name_,University_Id_,University_Name_,Course_Id_,Course_Name_,intake_Id_,
 intake_Name_,Intake_Year_Id_,Intake_Year_Name_,Date_Of_Applying_,Remark_,Application_status_Id_,
 Application_Status_Name_,Agent_Id_,Agent_Name_,0,0,0,false );
 End If ;

 select Application_details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_ApplicationDetails_Datas`(In Applicationdetails_ Json,Applicationdetails_Value_ int,application_document_ Json,application_document_Value_ int )
Begin
declare Application_details_Id_ int;declare Student_Id_ int;declare Country_Id_ int;declare Country_Name_ varchar(1000);declare SlNo_ int;declare University_Id_ int;
declare University_Name_ varchar(1000);declare Course_Id_ int;declare Course_Name_ varchar(1000);declare intake_Id_ int;declare intake_Name_ varchar(150);declare Intake_Year_Id_ int;
declare Intake_Year_Name_ varchar(45);declare Date_Of_Applying_ datetime;declare Remark_ varchar(450);declare Application_status_Id_ int;declare Application_Status_Name_ varchar(45);
declare Agent_Id_ int;declare Agent_Name_ varchar(150);declare Application_No_ varchar(45);declare Student_Reference_Id_ varchar(45);declare Course_Fee_ varchar(45);declare Living_Expense_ varchar(45);
#declare Reference_No_ int;#declare Activation_Status_ tinyint;
declare old_Country_Id_ int;declare old_University_Id_ int;declare old_Course_Id_ int;declare old_intake_Id_ int;declare old_Intake_Year_Id_ int;declare old_Application_status_Id_ int;
declare old_Agent_Id_ int;declare old_Country_Name_ varchar(1000);declare old_University_Name_ varchar(1000);declare old_Course_Name_ varchar(1000);
declare old_intake_Name_ varchar(1000);declare old_Intake_Year_Name_ varchar(1000);declare old_Application_status_Name_ varchar(1000);
declare old_Agent_Name_ varchar(1000);declare old_Remark_ varchar(1000); declare old_Course_Fee_ varchar(1000);declare old_Living_Expense_ varchar(1000);declare Preference_ varchar(100);
declare ApplicationFile_Name_ varchar(500);declare ApplicationDocument_Name_ varchar(500);Declare i int default 0;Declare j int default 0;declare ApplicationDocument_File_Name_  varchar(500);declare User_Id_ int;
Declare Subject_Id_ int ;Declare Duration_Id_ int ;Declare Level_Id_ int;Declare Ielts_Minimum_Score_ varchar(500) ;Declare internship_Id_ int;declare Student_Approved_Status_ tinyint;
declare Bph_Approved_Status_ tinyint;declare Portal_User_Name_ varchar(45);declare Password_ varchar(45);declare Offer_Student_Id_ varchar(45);declare Fees_Payment_Last_Date_ datetime;
declare Feespaymentcheck_ varchar(10);declare Offer_Received_ varchar(10);declare Course_Name_Old_ varchar(1000);declare Country_Name_Old_ varchar(1000);declare University_Name_Old_ varchar(1000);
declare From_User_Name_ varchar(100);declare To_User_Name_ varchar(100);declare To_User_ int;declare Student_Name_ varchar(100);
declare Notification_Type_Name_ varchar(100);declare Entry_Type_ int;declare Notification_Id_ int;
declare Notification_Count_ int;declare Is_Entrolled_ tinyint;declare Is_Registered_ tinyint;
DECLARE url_ LONGTEXT;

/*DECLARE exit handler for sqlexception
BEGIN
#set innodb_lock_wait_timeout=500;
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    START TRANSACTION;*/
if( Applicationdetails_Value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Application_details_Id')) INTO Application_details_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Student_Id')) INTO Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Country_Id')) INTO Country_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Country_Name')) INTO Country_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.University_Id')) INTO University_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.University_Name')) INTO University_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Course_Id')) INTO Course_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Course_Name')) INTO Course_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.intake_Id')) INTO intake_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.intake_Name')) INTO intake_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Intake_Year_Id')) INTO Intake_Year_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Intake_Year_Name')) INTO Intake_Year_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Date_Of_Applying')) INTO Date_Of_Applying_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Remark')) INTO Remark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Application_status_Id')) INTO Application_status_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Application_Status_Name')) INTO Application_Status_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Agent_Id')) INTO Agent_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Agent_Name')) INTO Agent_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.User_Id')) INTO User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Application_No')) INTO Application_No_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Student_Reference_Id')) INTO Student_Reference_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Course_Fee')) INTO Course_Fee_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Living_Expense')) INTO Living_Expense_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Preference')) INTO Preference_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Student_Approved_Status')) INTO Student_Approved_Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Bph_Approved_Status')) INTO Bph_Approved_Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Portal_User_Name')) INTO Portal_User_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Password')) INTO Password_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Offer_Student_Id')) INTO Offer_Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Fees_Payment_Last_Date')) INTO Fees_Payment_Last_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Feespaymentcheck')) INTO Feespaymentcheck_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Offer_Received')) INTO Offer_Received_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.Duration_Id')) INTO Duration_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Applicationdetails_,'$.url')) INTO url_;


if (Feespaymentcheck_ = 'true' )
then
set Feespaymentcheck_= 1;
else
set Feespaymentcheck_= 0;
end if;
if (Offer_Received_ = 'true' )
then
set Offer_Received_= 1;
else
set Offer_Received_= 0;
end if;
set Student_Name_ = (select Student_Name from student where Student_Id = Student_Id_ and DeleteStatus=0);
set Is_Registered_ = (select COALESCE((Is_Registered ),0) from student where Student_Id = Student_Id_ and DeleteStatus=0);

if(Is_Registered_>0) then
set Is_Entrolled_=1;
else
set Is_Entrolled_=0;
end if;

if(Country_Id_ =0)then
SET Country_Id_ = (select COALESCE( MAX(Country_Id ),0) from country where Country_Name=Country_Name_);
    SET Country_Name_Old_ = (select ifnull(Country_Name,'') Country_Name from country where Country_Name=Country_Name_);
    if(Country_Id_=0) then
SET Country_Id_ = (SELECT  COALESCE( MAX(Country_Id ),0)+1 FROM country);  
        insert into country values(Country_Id_,Country_Name_,0);
    end if;        
end if;  
if(University_Id_ =0) then
SET University_Id_ = (select COALESCE( MAX(University_Id ),0) from university where University_Name=University_Name_);
    SET University_Name_Old_ = (select ifnull(University_Name,'') University_Name from university where University_Name=University_Name_);
if(University_Id_=0) then
SET University_Id_ = (SELECT  COALESCE( MAX(University_Id ),0)+1 FROM university);    
insert into university(University_Id,University_Name,DeleteStatus) values(University_Id_,University_Name_,0);
  end if;
end if;  
if(Course_Id_ =0)then
SET Course_Id_ = (select COALESCE( MAX(Course_Id ),0) from course where Course_Name=Course_Name_);
    SET Course_Name_Old_ = (select ifnull(Course_Name,'') Course_Name from course where Course_Name=Course_Name_);
if(Course_Id_=0) then
set intake_Id_ =(select COALESCE( MAX(intake_Id ),0)  from intake where intake_Name=intake_Name_);
SET Course_Id_ = (SELECT  COALESCE( MAX(Course_Id ),0)+1 FROM course);    
insert into course(Course_Id,Country_Id,University_Id,Course_Name,intake_Name, Subject_Id,Duration_Id,Level_Id,Ielts_Minimum_Score,internship_Id,IELTS_Name,Sub_Section_Id,DeleteStatus)
values(Course_Id_,Country_Id_,University_Id_,Course_Name_,intake_Name_,0,0,0,0,0,0,0,0);  
#insert into course_intake(Course_Id,intake_Id,intake_Status) values(Course_Id_,intake_Id_,1) ;  
end if;
end if;
if(Application_details_Id_>0) then
#SET Application_details_Id_ = (SELECT  COALESCE( MAX(Application_details_Id ),0)+1 FROM application_details_history);
#set SlNo_ = (SELECT  COALESCE( MAX(SlNo ),0)+1 FROM application_details_history where Application_details_Id = Application_details_Id_);
insert into application_details_history (Application_details_Id,Student_Id,Country_Id,Country_Name,
    University_Id,University_Name,Course_Id,Course_Name, intake_Id,intake_Name,
    Intake_Year_Id,Intake_Year_Name,Date_Of_Applying,Remark,
Application_status_Id,Application_Status_Name,Agent_Id,Agent_Name,
    Activation_Status, SlNo,User_Id,Course_Fee,Living_Expense,Student_Approved_Status,
    Bph_Approved_Status,DeleteStatus,url,Student_Name,Is_Entrolled)
values (Application_details_Id_,Student_Id_,Country_Id_,Country_Name_,
    University_Id_,University_Name_,Course_Id_,Course_Name_, intake_Id_,intake_Name_,Intake_Year_Id_,Intake_Year_Name_,Date_Of_Applying_,Remark_,
1,"Application Created",Agent_Id_,Agent_Name_,0,0, User_Id_,
    Course_Fee_,Living_Expense_,Student_Approved_Status_,Bph_Approved_Status_,false,url_,Student_Name_,Is_Entrolled_ );
# End If ;
UPDATE application_details set
Student_Id = Student_Id_,Country_Id = Country_Id_,Country_Name=Country_Name_,University_Id=University_Id_,
    University_Name=University_Name_,Course_Id=Course_Id_,Course_Name=Course_Name_,intake_Id=intake_Id_,
    intake_Name=intake_Name_,
User_Id=User_Id_,Duration_Id=Duration_Id_,Intake_Year_Id=Intake_Year_Id_,Intake_Year_Name=Intake_Year_Name_,
    Date_Of_Applying=Date_Of_Applying_,Remark=Remark_,
   # Application_status_Id=Application_status_Id_, Application_Status_Name=Application_Status_Name_,
    Agent_Id=Agent_Id_,Agent_Name=Agent_Name_,Application_No=Application_No_,Student_Reference_Id=Student_Reference_Id_,Course_Fee=Course_Fee_,Living_Expense=Living_Expense_,
Preference=Preference_,Portal_User_Name=Portal_User_Name_,Password=Password_,Offer_Student_Id=Offer_Student_Id_,Fees_Payment_Last_Date=Fees_Payment_Last_Date_,Feespaymentcheck=Feespaymentcheck_,Offer_Received=Offer_Received_
,url=url_,Student_Name=Student_Name_,Is_Entrolled=Is_Entrolled_
    Where Application_details_Id=Application_details_Id_;
#Subject_Id=Subject_Id_,Duration_Id=Duration_Id_,Level_Id=Level_Id_,Ielts_Minimum_Score=Ielts_Minimum_Score_,internship_Id=internship_Id_,IELTS_Name=IELTS_Name_,Sub_Section_Id=Sub_Section_Id_,
 ELSE
SET Application_details_Id_ = (SELECT  COALESCE( MAX(Application_details_Id ),0)+1 FROM application_details);
set SlNo_ = (SELECT  COALESCE( MAX(SlNo ),0)+1 FROM application_details where Student_Id = Student_Id_);
INSERT INTO application_details(Application_details_Id ,Student_Id,Country_Id,Country_Name,University_Id,University_Name,Course_Id,Course_Name,intake_Id,intake_Name,Intake_Year_Id,Intake_Year_Name,Date_Of_Applying,Remark,
Application_status_Id,Application_Status_Name,Agent_Id,Agent_Name,Activation_Status,SlNo,User_Id,Application_No,Student_Reference_Id,Course_Fee,Living_Expense,Student_Approved_Status,Bph_Approved_Status,Application_Fees_Paid,
Preference,Application_Source,Portal_User_Name,Password,Offer_Student_Id,
    Fees_Payment_Last_Date,Feespaymentcheck,Offer_Received,Duration_Id,DeleteStatus,url,Student_Name,Is_Entrolled)
values (Application_details_Id_ ,Student_Id_,Country_Id_,Country_Name_,University_Id_,University_Name_,Course_Id_,Course_Name_,intake_Id_,intake_Name_,Intake_Year_Id_,Intake_Year_Name_,Date_Of_Applying_,Remark_,
   1,"Application Created",Agent_Id_,Agent_Name_,0,SlNo_,User_Id_,Application_No_,Student_Reference_Id_,Course_Fee_,Living_Expense_,0,1,-1,Preference_,1,Portal_User_Name_,Password_,Offer_Student_Id_,Fees_Payment_Last_Date_,
Feespaymentcheck_,Offer_Received_,Duration_Id_,false,url_,Student_Name_,Is_Entrolled_);
insert into application_details_history (Application_details_Id,Student_Id,Country_Id,Country_Name,University_Id,University_Name,Course_Id,Course_Name, intake_Id,intake_Name, Intake_Year_Id,Intake_Year_Name,Date_Of_Applying,Remark,
Application_status_Id,Application_Status_Name,Agent_Id,Agent_Name,SlNo,User_Id,Activation_Status,Course_Fee,Living_Expense,Preference,
    Student_Approved_Status,Bph_Approved_Status,DeleteStatus,url,Student_Name,Is_Entrolled)
values (Application_details_Id_,Student_Id_,Country_Id_,Country_Name_,University_Id_,University_Name_,Course_Id_,Course_Name_, intake_Id_,intake_Name_,Intake_Year_Id_,Intake_Year_Name_,Date_Of_Applying_,Remark_,
1,"Application Created",Agent_Id_,Agent_Name_,SlNo_,User_Id_,0, Course_Fee_,
    Living_Expense_,Preference_,0,1,false,url_,Student_Name_,Is_Entrolled_ );
  #Subject_Id,Duration_Id,Level_Id,Ielts_Minimum_Score,internship_Id,IELTS_Name,Sub_Section_Id, #0,0,0,0,0,0,0,  #Subject_Id,Duration_Id,Level_Id,Ielts_Minimum_Score,internship_Id,IELTS_Name,Sub_Section_Id_,  #0,0,0,0,0,0,0,
 End If ;
 end if;
 if( application_document_Value_>0) then
WHILE j < JSON_LENGTH(application_document_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(application_document_,CONCAT('$[',j,'].ApplicationFile_Name'))) INTO ApplicationFile_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(application_document_,CONCAT('$[',j,'].ApplicationDocument_Name'))) INTO ApplicationDocument_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(application_document_,CONCAT('$[',j,'].ApplicationDocument_File_Name'))) INTO ApplicationDocument_File_Name_;
insert into application_document (Student_Id,ApplicationFile_Name,ApplicationDocument_Name,ApplicationDocument_File_Name,Application_details_Id,DeleteStatus)
values(Student_Id_,ApplicationFile_Name_,ApplicationDocument_Name_,ApplicationDocument_File_Name_,Application_details_Id_,0);
SELECT j + 1 INTO j;      
END WHILE;
 end if;
set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = User_Id_ and DeleteStatus=false);  
set To_User_ =(select Admission_User from Student where Student_Id = Student_Id_ and DeleteStatus=false);  
if User_Id_ != To_User_  and To_User_>0 then
set To_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false);  

set Notification_Type_Name_= 'Application';
set Entry_Type_ = 2;
SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
values(Notification_Id_,User_Id_,From_User_Name_,To_User_,To_User_Name_,Application_status_Id_,Application_Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);
set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_;  
end if;
#commit;
 select Application_details_Id_,Country_Id_,University_Id_,Course_Id_,Country_Name_Old_,Course_Name_Old_,University_Name_Old_,From_User_Name_,Student_Name_,Notification_Type_Name_,Entry_Type_,To_User_,Notification_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_ApplicationStatusforstatuschange`( In Application_status_Id_ int,
Application_Status_Name_ varchar(45),
Transfer_Status_ tinyint,Notification_Status_ tinyint,Notification_Department_Id_ int,Notification_Department_Name_ varchar(45),
Transfer_Department_Id_ int,Transfer_Department_Name_ varchar(45),Remark_ varchar(4000))
Begin
 if  Application_status_Id_>0
 THEN
UPDATE application_status set Application_status_Id = Application_status_Id_ ,
Application_Status_Name = Application_Status_Name_,
Transfer_Status=Transfer_Status_,Notification_Status=Notification_Status_,
Notification_Department_Id=Notification_Department_Id_,
Notification_Department_Name=Notification_Department_Name_,
Transfer_Department_Id=Transfer_Department_Id_,Transfer_Department_Name=Transfer_Department_Name_,
Remark=Remark_
Where Application_status_Id=Application_status_Id_ ;
#update student set Enquiry_Source_Name = Enquiry_Source_Name_ where Enquiry_Source_Id = Enquiry_Source_Id_;
 ELSE
 SET Application_status_Id_ = (SELECT  COALESCE( MAX(Application_status_Id ),0)+1 FROM application_status);
 INSERT INTO application_status(Application_status_Id ,
 Application_Status_Name,DeleteStatus,Notification_Department_Id,Notification_Department_Name,Transfer_Department_Id,Transfer_Department_Name,Transfer_Status,Notification_Status,Remark) 
values (Application_status_Id_ ,Application_Status_Name_,false,Notification_Department_Id_,Notification_Department_Name_,Transfer_Department_Id_,Transfer_Department_Name_,Transfer_Status_,Notification_Status_,Remark_ );
 End If ;
 select Application_status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Application_Settings`( In Application_Settings_Id_ int,
Settings_Value_ tinyint,Department_Id_ int,Register_Transfer_Status_ tinyint,Department_Id_Created_ int,Created_Transfer_Status_ tinyint)
Begin

 if  Application_Settings_Id_>0
  THEN
UPDATE application_settings set
Settings_Group_Id = 1,
Settings_Value = Settings_Value_,
Department_Id=Department_Id_,
Register_Transfer_Status=Register_Transfer_Status_,
Department_Id_Created=Department_Id_Created_,
Created_Transfer_Status=Created_Transfer_Status_
  Where Application_Settings_Id = Application_Settings_Id_ ;  
/*ELSE  
INSERT INTO application_settings(Settings_Group_Id ,Settings_Value ,Editable ,DeleteStatus,Department_Id  )
values (Application_Settings_Id_ ,Settings_Value_ ,true ,false,Department_Id_ );*/
End If ;
select Application_Settings_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Application_Status`( In Application_status_Id_ int,
Application_Status_Name_ varchar(45),Application_Group_Id_ int,Application_Group_Name_ varchar(45),
Transfer_Status_ tinyint,Notification_Status_ tinyint,Notification_Department_Id_ int,Notification_Department_Name_ varchar(45),
Transfer_Department_Id_ int,Transfer_Department_Name_ varchar(45),Group_Restriction_ int)
Begin
 if  Application_status_Id_>0
 THEN
 UPDATE application_status set Application_status_Id = Application_status_Id_ ,
Application_Status_Name = Application_Status_Name_,Application_Group_Id=Application_Group_Id_,
Application_Group_Name=Application_Group_Name_ ,Transfer_Status=Transfer_Status_,Notification_Status=Notification_Status_,
Notification_Department_Id=Notification_Department_Id_,Notification_Department_Name=Notification_Department_Name_,Transfer_Department_Id=Transfer_Department_Id_,Transfer_Department_Name=Transfer_Department_Name_,Group_Restriction=Group_Restriction_
Where Application_status_Id=Application_status_Id_ ;
#update student set Enquiry_Source_Name = Enquiry_Source_Name_ where Enquiry_Source_Id = Enquiry_Source_Id_;
 ELSE
 SET Application_status_Id_ = (SELECT  COALESCE( MAX(Application_status_Id ),0)+1 FROM application_status);
 INSERT INTO application_status(Application_status_Id ,
Application_Status_Name,Application_Group_Id,Application_Group_Name,DeleteStatus,Notification_Department_Id,Notification_Department_Name,Transfer_Department_Id,Transfer_Department_Name,Transfer_Status,Notification_Status,Group_Restriction) values (Application_status_Id_ ,
Application_Status_Name_,Application_Group_Id_,Application_Group_Name_,false,Notification_Department_Id_,Notification_Department_Name_,Transfer_Department_Id_,Transfer_Department_Name_,Transfer_Status_,Notification_Status_,Group_Restriction_ );
 End If ;
 select Application_status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Bph_Status`(In Application_details_Id_ int,Login_User_ int,Bph_Status_ int,Bph_Remark_ varchar(1000) )
BEGIN
declare Application_details_History_Id_ int;declare Fees_Receipt_Id_ int;declare Fee_Receipt_Branch_ int;declare first_Receipt int;
Declare Target_ int;declare Registration_Branch_ int;declare Student_Registration_Id_ int;declare Registered_User_ varchar(100);
declare Registered_Branch_Name_ varchar(100);declare bph_approved_status_ int; declare Student_Id_ int;declare counsellor_id_ int;
declare From_User_Name_ varchar(200);declare Bph_Status_Name_ varchar(200);declare Notification_Id_ int;declare Notification_Count_ int;
declare Student_Name_ varchar(200);declare Notification_Type_Name_ varchar(20);declare To_User_ int;declare To_User_Name_ varchar(45);declare Entry_Type_ int;
SET Student_Id_=(select Student_Id  from application_details where Application_details_Id=Application_details_Id_ and DeleteStatus=false);
set counsellor_id_=(select Counsilor_User  from student where Student_Id=Student_Id_ and DeleteStatus=false);
 if (counsellor_id_>0) then
Update application_details set Bph_Approved_Status = Bph_Status_,Bph_Approved_By=Login_User_,Bph_Approved_Date=now(),Bph_Remark=Bph_Remark_
where Application_details_Id = Application_details_Id_;
set Application_details_History_Id_=(select max(Application_details_History_Id) from Application_details_History
where Application_details_Id=Application_details_Id_ and Deletestatus=0);
Update application_details_history set Bph_Approved_Status = Bph_Status_,Bph_Approved_By=Login_User_,Bph_Approved_Date=now(),Bph_Remark=Bph_Remark_
where User_Id = Login_User_ and Application_details_History_Id = Application_details_History_Id_;
#Registration
set Fees_Receipt_Id_ =(select min(Fees_Receipt_Id) from fees_receipt where Application_details_Id=Application_details_Id_
and Fees_Receipt_Status=2 and Delete_Status=false);
SET Fee_Receipt_Branch_=(select Branch_Id from user_details where User_Details_Id=Login_User_ and Deletestatus=0);
SET first_Receipt=(select Fees_Receipt_Status  from fees_receipt where Fees_Receipt_Id=Fees_Receipt_Id_ and Delete_Status=false);
if (first_Receipt=2 and Bph_Status_=2) then
set Registration_Branch_=Fee_Receipt_Branch_;
set Target_=(select Registration_Target from user_details where User_Details_Id=Login_User_ and Deletestatus=false );
set Registered_User_=(select User_Details_Name from user_details where User_Details_Id=counsellor_id_ and Deletestatus=false );
set Registered_Branch_Name_=(select Branch_Name from branch where Branch_Id=Registration_Branch_ and Is_Delete=false);
set Student_Registration_Id_ = (SELECT  COALESCE( MAX(Student_Registration_Id ),0)+1 FROM Student);
Update Student set Is_Registered = true , Registered_By = counsellor_id_ , Registered_On = now(),
Registration_Target=Target_,Registration_Branch=Registration_Branch_,
Student_Registration_Id = Student_Registration_Id_,
Registered_User=Registered_User_,Registered_Branch=Registered_Branch_Name_
where Student_Id = Student_Id_;
set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_ and DeleteStatus=false);  
set To_User_ =(select Counsilor_User from Student where Student_Id = Student_Id_ and DeleteStatus=false);
if  Login_User_ != To_User_ and To_User_>0 then
set To_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false);  
set Student_Name_ = (select Student_Name from student where Student_Id = Student_Id_);
set Bph_Status_Name_ = (select Bph_Status_Name from bph_status where Bph_Status_Id = Bph_Status_);
set Notification_Type_Name_= 'Auditor Approval';
set Entry_Type_ = 12;
 SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
values(Notification_Id_,Login_User_,From_User_Name_,To_User_,To_User_Name_,Bph_Status_,Bph_Status_Name_,1,Bph_Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);
set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_;  
end if;
end if;
else
set Application_details_Id_=-2;
end if;
select Application_details_Id_,Student_Name_,From_User_Name_,Notification_Type_Name_,Entry_Type_,To_User_,Notification_Id_,Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Branch`( In Branch_Id_ int,Branch_Name_ varchar(50),
Address_ varchar(50),Location_ varchar(50),District_ varchar(50),State_ varchar(50),
Country_ varchar(50),PinCode_ varchar(50),Phone_Number_ varchar(50),Email_ varchar(50),
Branch_Code_ varchar(10),Company_ int,
Default_Department_Id_ int,Default_Department_Name_ varchar(250),
Default_User_Id_ int,Default_User_Name_ varchar(250),
Branch_Department JSON)
Begin 

DECLARE Department_Id_ int;
DECLARE Default_Status_Id_ int;DECLARE Default_Status_Name_ varchar(250);
DECLARE Is_FollowUp_ tinyint DEFAULT 0;
DECLARE i int  DEFAULT 0;

#select Department_Status_Id,department.Status from department where Department_Id=Default_Department_Id_
 #into Default_Status_Id_,Default_Status_Name_;

 
set Default_Status_Id_=(select Department_Status_Id from department where Department_Id=Default_Department_Id_);
set Default_Status_Name_=(select Department_Status_Name from department_status where Department_Status_Id=Default_Status_Id_);
set Is_FollowUp_=(select FollowUp from department where  Department_Id=Default_Department_Id_ );

 #insert into data_log_ values(0,Default_Status_Name_,'');
if  Branch_Id_>0
	THEN 
	delete from Branch_Department where Branch_id=Branch_Id_;
	UPDATE Branch 
	SET 
	Branch_Id = Branch_Id_,Branch_Name = Branch_Name_,Address = Address_,Location = Location_,
	District = District_,State = State_,Country = Country_,PinCode = PinCode_,
	Phone_Number = Phone_Number_,Email = Email_,Branch_Code = Branch_Code_,Company=Company_,
    Default_Department_Id=Default_Department_Id_,Default_Department_Name=Default_Department_Name_,
    Default_User_Id=Default_User_Id_,Default_User_Name=Default_User_Name_,
    Default_Status_Id=Default_Status_Id_,Default_Status_Name=Default_Status_Name_,
    Is_FollowUp=Is_FollowUp_
	WHERE
	Branch_Id = Branch_Id_;
     update student set Followup_Branch_Name = Branch_Name_ where Followup_Branch_Id = Branch_Id_;
     update student set Registered_Branch = Branch_Name_ where Registration_Branch = Branch_Id_;
	ELSE 
	SET Branch_Id_ = (SELECT  COALESCE( MAX(Branch_Id ),0)+1 FROM Branch); 
	INSERT INTO Branch(Branch_Id ,Branch_Name ,Address ,Location ,District ,State ,Country ,PinCode ,
	Phone_Number ,Email ,Branch_Code ,Company,Is_Delete,
    Default_Department_Id,Default_Department_Name,Default_User_Id,Default_User_Name,
    Default_Status_Id,Default_Status_Name,Is_FollowUp )
	values (Branch_Id_ ,Branch_Name_ ,Address_ ,Location_ ,District_ ,State_ ,Country_ ,PinCode_ ,
	Phone_Number_ ,Email_ ,Branch_Code_ ,Company_,false,
        Default_Department_Id_,Default_Department_Name_,Default_User_Id_,Default_User_Name_,
        Default_Status_Id_,Default_Status_Name_,Is_FollowUp_ );
End If ;

WHILE i < JSON_LENGTH(Branch_Department) DO
	SELECT JSON_UNQUOTE(JSON_EXTRACT(Branch_Department,CONCAT('$[',i,'].Department_Id'))) INTO Department_Id_;
	INSERT INTO Branch_Department(Branch_Id,Department_Id,Is_Delete )
	values (Branch_Id_ ,Department_Id_,false);  
	SELECT i + 1 INTO i;
END WHILE;     
#COMMIT;

SELECT Branch_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Cas_Followup`( In Student_Task_Id_ int,Task_Status_ int,Student_Id_ int,Status_Name_ varchar(25),Remark_ varchar(25),Followup_Date_ date,To_User_ int,To_User_Name_ varchar(200),Task_Item_Id_ int,Task_Group_Id_ int)
Begin
declare Student_Task_Followup_Id_ int;declare Department_Id_ int;declare Student_Name_ varchar(100); declare Notification_Id_ int;declare Notification_Count_ int;
declare Notification_Type_Name_ varchar(20);declare Entry_Type_ int;declare Task_Count_ int;
declare By_User_Id_ int;declare By_User_Name_ varchar(100);declare Cur_Date_ date;
set Cur_Date_=CURDATE() ;
set Department_Id_ = (select Department_Id from user_details where User_Details_Id = To_User_);
set Student_Name_ = (select Student_Name from Student where Student_Id = Student_Id_);
if Student_Task_Id_>0 then
  update Student_Task set Student_Task_Id=Student_Task_Id_,Student_Id=Student_Id_,Student_Name=Student_Name_,Followup_Date=Followup_Date_,
To_User_Name=To_User_Name_,Task_Status=Task_Status_,Status_Name=Status_Name_,Remark=Remark_,To_User=To_User_,Task_Item_Id=Task_Item_Id_,Task_Group_Id=Task_Group_Id_ where
Student_Task_Id=Student_Task_Id_ ;
 else
 SET Student_Task_Id_ = (SELECT  COALESCE( MAX(Student_Task_Id ),0)+1 FROM Student_Task);
INSERT INTO Student_Task(Student_Task_Id,Student_Id,Student_Name,Followup_Date,To_User_Name,Task_Status,Status_Name,Remark,To_User,Task_Item_Id,Department_Id,DeleteStatus,Task_Group_Id,Entry_date )
values (Student_Task_Id_,Student_Id_,Student_Name_,Followup_Date_,To_User_Name_,Task_Status_,Status_Name_,Remark_,To_User_,Task_Item_Id_,Department_Id_,false,Task_Group_Id_,now());
end if;
SET Student_Task_Followup_Id_ = (SELECT  COALESCE( MAX(Student_Task_Followup_Id ),0)+1 FROM Student_Task_Followup);
INSERT INTO Student_Task_Followup(Student_Task_Followup_Id,Student_Task_Id,Student_Id,Student_Name,Followup_Date,To_User_Name,Task_Status,Status_Name,Remark,To_User,Task_Item_Id,DeleteStatus, Entry_date)
values (Student_Task_Followup_Id_,Student_Task_Id_,Student_Id_,Student_Name_,Followup_Date_,To_User_Name_,Task_Status_,Status_Name_,Remark_,To_User_,Task_Item_Id_,false,now());
set Task_Count_ = (select count(Student_Task_Id) as Student_Task_Count from Student_Task  where DeleteStatus=0
and Student_Task.Task_Status =1 and To_User =To_User_ and
 date(Student_Task.Followup_Date) <= Cur_Date_ );
if Task_Status_ =2 then
set By_User_Id_= (select By_User_Id from Student_Task where Student_Task_Id = Student_Task_Id_ and DeleteStatus=false);
set By_User_Name_ =(select By_User_Name from Student_Task where Student_Task_Id = Student_Task_Id_ and DeleteStatus=false);
set Notification_Type_Name_ = 'Task Completed';
set Entry_Type_ = 12;
 SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
values(Notification_Id_,To_User_,To_User_Name_,By_User_Id_,By_User_Name_,Task_Status_,Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,8);

set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_;
end if;
 select Student_Task_Id_,Student_Name_,To_User_Name_,Notification_Type_Name_,Entry_Type_,By_User_Id_,Notification_Id_,Student_Id_,Task_Status_,Task_Count_,To_User_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_CAS_NewTask_Followup`( In Student_Task_Id_ int,Student_Id_ int, Department_Id_ int,
Department_Name_ varchar(250),To_User_ int,To_User_Name_ varchar(200),Task_Group_Id_ int,Task_Details_ varchar(500),Followup_Date_ date,
Remark_ varchar(2000),Task_Status_ int,Status_Name_ varchar(20),Task_Item_Id_ int,By_User_Id_ int,By_User_Name_ varchar(100))
Begin
declare Student_Task_Followup_Id_ int;declare Student_Name_ varchar(100);declare Notification_Type_Name_ varchar(20);
declare From_User_Name_ varchar(45);declare ToUser_Name_ varchar(45);declare Entry_Type_ int;
declare Notification_Id_ int;declare Notification_Count_ int;declare Task_Count_ int;declare Cur_Date_ date;
set Cur_Date_=CURDATE() ;
set Department_Id_ = (select Department_Id from user_details where User_Details_Id = To_User_);
set Student_Name_ = (select Student_Name from Student where Student_Id = Student_Id_);
if Student_Task_Id_>0 then
update Student_Task set Student_Task_Id=Student_Task_Id_,Student_Id=Student_Id_,
Student_Name=Student_Name_,
Followup_Date=Followup_Date_,
To_User_Name=To_User_Name_,
To_User=To_User_,Task_Group_Id=Task_Group_Id_,
Department_Name=Department_Name_,Department_Id=Department_Id_,
Task_Details=Task_Details_,Remark=Remark_,Task_Status=Task_Status_,
Status_Name=Status_Name_,Task_Item_Id=Task_Item_Id_,
By_User_Id=By_User_Id_,By_User_Name=By_User_Name_
 where Student_Task_Id=Student_Task_Id_ ;
 else
 SET Student_Task_Id_ = (SELECT  COALESCE( MAX(Student_Task_Id ),0)+1 FROM Student_Task);
INSERT INTO Student_Task(Student_Task_Id,Student_Id,Student_Name,To_User_Name,To_User,Department_Id,DeleteStatus,Task_Group_Id,Entry_date,Department_Name,Task_Details,Followup_Date,Remark,Task_Status,Status_Name,Task_Item_Id,By_User_Id,By_User_Name )
values (Student_Task_Id_,Student_Id_,Student_Name_,To_User_Name_,To_User_,Department_Id_,false,Task_Group_Id_,now(),Department_Name_,Task_Details_,Followup_Date_,Remark_,Task_Status_,Status_Name_,Task_Item_Id_,By_User_Id_,By_User_Name_);
end if;
SET Student_Task_Followup_Id_ = (SELECT  COALESCE( MAX(Student_Task_Followup_Id ),0)+1 FROM Student_Task_Followup);
INSERT INTO Student_Task_Followup(Student_Task_Followup_Id,Student_Task_Id,Student_Id,
Student_Name,To_User_Name,To_User,DeleteStatus,
 Entry_date,Department_Id,Department_Name,Followup_Date,Status_Name,Remark,Task_Item_Id,By_User_Id,By_User_Name)
values (Student_Task_Followup_Id_,Student_Task_Id_,Student_Id_,Student_Name_,To_User_Name_,
To_User_,false,now(),Department_Id_,Department_Name_,Followup_Date_,Status_Name_,Remark_,Task_Item_Id_,By_User_Id_,By_User_Name_);

set Task_Count_ = (select count(Student_Task_Id) as Student_Task_Count from Student_Task  where DeleteStatus=0
and Student_Task.Task_Status =1 and To_User =To_User_ and
 date(Student_Task.Followup_Date) <= Cur_Date_ );
if Task_Status_ =2 then
	#if By_User_Id_ != To_User_ then
	set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = By_User_Id_ and DeleteStatus=false);
	set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false);  
	set Notification_Type_Name_  = 'Task';
	set Entry_Type_ = 8;
	SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
	values(Notification_Id_,By_User_Id_,From_User_Name_,To_User_,ToUser_Name_,Task_Status_,Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_;              
	#end if;  
end if;


 select Student_Task_Id_,Student_Name_,From_User_Name_,Entry_Type_,To_User_,Student_Id_,Task_Count_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Checklist`( In Checklist_Id_ int,
Checklist_Name_ varchar(100),Country_Id_ int,Checklist_Type_ int,Checklist_Type_Name_ varchar(45))
Begin 
 if  Checklist_Id_>0
 THEN 
 UPDATE Checklist set Checklist_Id = Checklist_Id_ ,Country_Id=Country_Id_,
Checklist_Name = Checklist_Name_,Checklist_Type=Checklist_Type_,Checklist_Type_Name=Checklist_Type_Name_  Where Checklist_Id=Checklist_Id_ ;
 ELSE 
 SET Checklist_Id_ = (SELECT  COALESCE( MAX(Checklist_Id ),0)+1 FROM Checklist); 
 INSERT INTO Checklist(Checklist_Id ,Checklist_Name ,Country_Id,Checklist_Type,Checklist_Type_Name,DeleteStatus ) 
 values (Checklist_Id_ ,Checklist_Name_ ,Country_Id_,Checklist_Type_,Checklist_Type_Name_,false);
 End If ;
 select Checklist_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Check_List`( In Check_List_Id_ int,
Check_List_Name_ varchar(100))
Begin 
 if  Check_List_Id_>0
 THEN 
 UPDATE check_list set Check_List_Id = Check_List_Id_ ,
Check_List_Name = Check_List_Name_   Where Check_List_Id=Check_List_Id_ ;
 ELSE 
 SET Check_List_Id_ = (SELECT  COALESCE( MAX(Check_List_Id ),0)+1 FROM check_list); 
 INSERT INTO check_list(Check_List_Id ,
Check_List_Name ,
DeleteStatus ) values (Check_List_Id_ ,
Check_List_Name_ ,
false);
 End If ;
 select Check_List_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Client_Accounts`( In Client_Accounts_Id_ decimal,
Account_Group_Id_ decimal,Client_Accounts_Code_ varchar(50),Client_Accounts_Name_ varchar(500),
Client_Accounts_No_ varchar(50),Address1_ varchar(250),Address2_ varchar(250),
Address3_ varchar(250),Address4_ varchar(250),PinCode_ varchar(50),StateCode_ varchar(50),
GSTNo_ varchar(50) ,PanNo_ varchar(50),State_ varchar(1000),Country_ varchar(1000),
Phone_ varchar(50),Mobile_ varchar(50),Email_ varchar(200),Opening_Balance_ decimal,
Description1_ varchar(1000),UserId_ decimal,LedgerInclude_ varchar(50),CanDelete_ varchar(2),
Commision_ decimal,Opening_Type_ int,Employee_Id_ decimal(18,0))
Begin 
declare Entry_Date_ datetime;
set Entry_Date_=(SELECT CURRENT_DATE());
 if  Client_Accounts_Id_>0
 THEN 
 UPDATE Client_Accounts set 
Account_Group_Id = Account_Group_Id_ ,Client_Accounts_Code = Client_Accounts_Code_ ,
Client_Accounts_Name = Client_Accounts_Name_ ,Client_Accounts_No = Client_Accounts_No_ ,
Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_ ,Address4 = Address4_ ,
PinCode = PinCode_ ,StateCode=StateCode_,GSTNo =GSTNo_,PanNo =PanNo_,
State = State_ ,Country = Country_ ,Phone = Phone_ ,Mobile = Mobile_ ,Email = Email_ ,
Opening_Balance = Opening_Balance_ ,Description1 = Description1_ ,Entry_Date = Entry_Date_ ,
UserId = UserId_ ,LedgerInclude = LedgerInclude_ ,CanDelete = CanDelete_ ,
Commision = Commision_ ,Opening_Type=Opening_Type_ ,Employee_Id=Employee_Id_ 
Where Client_Accounts_Id=Client_Accounts_Id_ ;
 ELSE 
 SET Client_Accounts_Id_ = (SELECT  COALESCE( MAX(Client_Accounts_Id ),0)+1 FROM Client_Accounts); 
 INSERT INTO Client_Accounts(Client_Accounts_Id ,Account_Group_Id ,Client_Accounts_Code ,
Client_Accounts_Name ,Client_Accounts_No ,Address1 ,Address2 ,Address3 ,Address4 ,PinCode ,
StateCode,GSTNo,PanNo, State ,Country ,Phone ,Mobile ,Email ,Opening_Balance ,Description1 ,
Entry_Date ,UserId ,LedgerInclude ,CanDelete ,Commision ,Opening_Type,Employee_Id,DeleteStatus ) 
values (Client_Accounts_Id_ ,Account_Group_Id_ ,Client_Accounts_Code_ ,Client_Accounts_Name_ ,
Client_Accounts_No_ ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,PinCode_ ,
StateCode_,GSTNo_,PanNo_, State_ ,Country_ ,Phone_ ,Mobile_ ,Email_ ,Opening_Balance_ ,Description1_ ,
Entry_Date_ ,UserId_ ,LedgerInclude_ ,CanDelete_ ,Commision_ ,Opening_Type_,Employee_Id_,false);
	#set Client_Accounts_Id_=(SELECT LAST_INSERT_ID());
 End If ;
 select Client_Accounts_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Company`( In Company_ JSON, Company_value_ int)
Begin 
DECLARE Company_Id_ int;DECLARE companyname_ varchar(45);DECLARE Phone1_ varchar(45);
DECLARE Phone2_ varchar(45);DECLARE Mobile_ varchar(45);DECLARE Website_ varchar(500);
DECLARE Email_ varchar(500);DECLARE Address1_ varchar(1000);
DECLARE Address2_ varchar(1000);DECLARE Address3_ varchar(45);DECLARE Logo_ varchar(45);
#DECLARE i int  DEFAULT 0;
/*DECLARE exit handler for sqlexception
BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
	ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
	GET DIAGNOSTICS CONDITION 1
	@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
	SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
	ROLLBACK;
END;
    START TRANSACTION;*/
   # delete from Company where Company_Id =1;
if(Company_value_>0) then
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Company_Id'))) INTO Company_Id_;   
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.companyname'))) INTO companyname_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Phone1'))) INTO Phone1_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Phone2'))) INTO Phone2_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Mobile'))) INTO Mobile_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Website'))) INTO Website_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Email'))) INTO Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Address1'))) INTO Address1_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Address2'))) INTO Address2_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Address3'))) INTO Address3_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Logo'))) INTO  Logo_;
	if( Company_Id_>0 )
	then
		if Logo_<>'' && Logo_<>'undefined' then
			UPDATE Company set Logo = Logo_ Where Company_Id=Company_Id_ ;
		end if;
		UPDATE Company set Company_Id = Company_Id_ ,companyname = companyname_ ,Phone1 = Phone1_ ,Phone2 = Phone2_ ,
		Mobile = Mobile_ ,Website = Website_ ,Email = Email_,Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_
		Where Company_Id = Company_Id_ ;
	 ELSE 
		SET Company_Id_ = (SELECT  COALESCE( MAX(Company_Id ),0)+1 FROM Company); 
		INSERT INTO Company(Company_Id ,companyname ,Phone1 ,Phone2 ,Mobile ,Website,Email,
		Address1,
		Address2,
		Address3,
		Logo,
		Is_Delete ) values (1 ,
		companyname_ ,
		Phone1_ ,
		Phone2_ ,
		Mobile_ ,
		Website_ ,
		Email_ ,
		Address1_ ,
		Address2_ ,
		Address3_ ,
		Logo_,
		false);
	end if;
end if;
#commit;
 select Company_Id_;
  End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Country`( In Country_Id_ int,
Country_Name_ varchar(50))
Begin 
 if  Country_Id_>0
 THEN 
 UPDATE Country set Country_Id = Country_Id_ ,
Country_Name = Country_Name_  Where Country_Id=Country_Id_ ;
 ELSE 
 SET Country_Id_ = (SELECT  COALESCE( MAX(Country_Id ),0)+1 FROM Country); 
 INSERT INTO Country(Country_Id ,
Country_Name,DeleteStatus ) values (Country_Id_ ,
Country_Name_,false );
 End If ;
 select Country_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course`( In Course_Id_ int,
Course_Name_ varchar(500),
Subject_Id_ int,
Sub_Section_Id_ int,
Duration_Id_ int,
Level_Id_ int,
Ielts_Minimum_Score_ varchar(500),
Internship_Id_ int,
Notes_ varchar(500),
Details_ varchar(500),
Application_Fees_ varchar(500),
Tution_Fees_ varchar(200) ,
Entry_Requirement_ varchar(500),
Living_Expense_ varchar(100),
Work_Experience_ varchar(500),
Registration_Fees_ varchar(45) ,
Date_Charges_ varchar(45) ,
Bank_Statements_ varchar(45) ,
Insurance_ varchar(45) ,
VFS_Charges_ varchar(45) ,
Apostille_ varchar(45) ,
Other_Charges_ varchar(45),
IELTS_Name_ varchar(500),
Intake_Name_ varchar(200),
University_Id_ int,
Country_Id_ int,Tag_ varchar(2000), Intake_Data_ json
)
Begin 

Declare Intake_Id_ int; Declare Intake_Status_ varchar(10);Declare Intake_Selection_ varchar(10);Declare i int default 0;
Declare Ielts_Id_ int;
Declare Duration_Name_ varchar(50);Declare IELTS_ varchar(50);
declare SubjectName_ varchar(1000); declare DurationName_ varchar(500);declare LevelName_ varchar(100);declare InternshipName_ varchar(45);
declare UniversityName_ varchar(2000); declare CountryName_ varchar(2000);declare Sub_SectionName_ varchar(2000);
set DurationName_ = (select Duration_Name from duration where Duration_Id = Duration_Id_ and DeleteStatus=0);
set SubjectName_ = (select Subject_Name from subject where Subject_Id = Subject_Id_ and DeleteStatus=0);
set LevelName_ = (select Level_Detail_Name from level_detail where Level_Detail_Id = Level_Id_ and DeleteStatus=0);
set InternshipName_ = (select internship_Name from internship where internship_Id = Internship_Id_ and DeleteStatus=0);
set UniversityName_ = (select University_Name from university where University_Id = University_Id_ and DeleteStatus=0);
set CountryName_ = (select Country_Name from country where Country_Id = Country_Id_ and DeleteStatus=0);
set Sub_SectionName_ = (select Sub_Section_Name from sub_section where Sub_Section_Id = Sub_Section_Id_ and DeleteStatus=0);
if  Course_Id_>0
 THEN 
 UPDATE Course set Course_Id = Course_Id_ ,
Course_Name = Course_Name_ ,
Subject_Id = Subject_Id_ ,
Sub_Section_Id = Sub_Section_Id_,
Duration_Id = Duration_Id_ ,
Level_Id = Level_Id_ ,
Ielts_Minimum_Score = Ielts_Minimum_Score_ ,
Internship_Id = Internship_Id_ ,
Notes = Notes_ ,
Details = Details_ ,
Application_Fees = Application_Fees_ ,
Tution_Fees=Tution_Fees_,
Entry_Requirement=Entry_Requirement_,
Living_Expense=Living_Expense_,
Work_Experience=Work_Experience_ ,
Registration_Fees =Registration_Fees_,
Date_Charges=Date_Charges_ ,
Bank_Statements =Bank_Statements_ ,
Insurance=Insurance_  ,
VFS_Charges=VFS_Charges_  ,
Apostille=Apostille_ ,
Other_Charges=Other_Charges_ ,
IELTS_Name=IELTS_Name_,
Intake_Name=Intake_Name_,
University_Id = University_Id_ ,
Country_Id = Country_Id_,
Tag=Tag_  ,
SubjectName = SubjectName_,DurationName = DurationName_,Level_DetailName = LevelName_,internshipName = InternshipName_,UniversityName = UniversityName_,
CountryName = CountryName_,Sub_SectionName = Sub_SectionName_
Where Course_Id=Course_Id_ ;
Delete from course_intake where Course_Id=Course_Id_;
 
 ELSE 
 SET Course_Id_ = (SELECT  COALESCE( MAX(Course_Id ),0)+1 FROM Course); 
 SET Duration_Name_=(Select Duration_Name from duration where Duration_Id = Duration_Id_ );
 #SET IELTS_=(Select Ielts_Name from ielts where Minimum_Score = Ielts_Minimum_Score_ );
 INSERT INTO Course(Course_Id ,
Course_Name ,
Subject_Id ,
Sub_Section_Id ,
Duration_Id ,
Level_Id ,
Ielts_Minimum_Score ,
Internship_Id ,
Notes ,
Details ,
Application_Fees ,
Tution_Fees,
Entry_Requirement,
Living_Expense,
Work_Experience,
Registration_Fees, 
Date_Charges ,
Bank_Statements , 
Insurance,
VFS_Charges , 
Apostille ,
Other_Charges,
IELTS_Name,
Intake_Name,
Duration,
University_Id ,
Country_Id,Tag,
SubjectName,DurationName,Level_DetailName,internshipName,UniversityName,CountryName,Sub_SectionName,Course_Status,DeleteStatus ) 
values (Course_Id_ ,
Course_Name_ ,
Subject_Id_ ,
Sub_Section_Id_ ,
Duration_Id_ ,
Level_Id_ ,
Ielts_Minimum_Score_ ,
Internship_Id_ ,
Notes_ ,
Details_ ,
Application_Fees_ ,
Tution_Fees_  ,
Entry_Requirement_ ,
Living_Expense_ ,
Work_Experience_ ,
Registration_Fees_, 
Date_Charges_ ,
Bank_Statements_ , 
Insurance_,
VFS_Charges_ , 
Apostille_ ,
Other_Charges_,
IELTS_Name_,
Intake_Name_,
Duration_Name_,
University_Id_ ,
Country_Id_,Tag_,SubjectName_,DurationName_,LevelName_,InternshipName_,UniversityName_,CountryName_,Sub_SectionName_,1,false );
 End If ;
 

	#delete from temptable; 

	WHILE i < JSON_LENGTH(Intake_Data_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Intake_Data_,CONCAT('$[',i,'].Intake_Id'))) INTO Intake_Id_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Intake_Data_,CONCAT('$[',i,'].Intake_Status'))) INTO Intake_Status_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Intake_Data_,CONCAT('$[',i,'].Intake_Selection'))) INTO Intake_Selection_;	
		#insert into temptable values(i,Intake_Selection_);
		if Intake_Selection_='true'
		then
			if Intake_Status_='true'
			then
				set Intake_Status_=1;
			else
				set Intake_Status_=0;
			end if;
			INSERT INTO course_intake(Course_Id,Intake_Id,Intake_Status) values(Course_Id_,Intake_Id_,Intake_Status_);
		end if;
	set i=i+1;
	End While;

 select  Course_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course_Import`( In Course_Details json)
Begin
Declare  Course_Details_Id_ int; Declare i int;
Declare Course_Id_ int;Declare Course_Name_ varchar(2000) ;Declare Course_Code_ varchar(10);Declare Subject_Id_ int ;Declare Duration_Id_ int ;Declare Level_Id_ int ;
Declare Ielts_Minimum_Score_ varchar(500) ;Declare Internship_Id_ int ;Declare Notes_ varchar(500) ;Declare Details_ varchar(500) ;Declare Application_Fees_ varchar(500) ;Declare University_Id_ int ;
Declare Country_Id_ int ;Declare DeleteStatus_ tinyint;Declare Subject_Name_ varchar(150);Declare Duration_Name_ varchar(50); Declare Level_Detail_Name_ varchar(500);
Declare Minimum_Score_ varchar(500); Declare Internship_Name_ varchar(50); Declare University_Name_ varchar(50); Declare Country_Name_ varchar(50); Declare Intake_Name_ varchar(500);
Declare Level_Detail_Id_ int; Declare Ielts_Id_ int; Declare Import_Master_Id_ int;Declare Entry_Date_  tinyint; Declare Intake_Id_ int;Declare Tag_ varchar(2000);
Declare intake_temp1_ varchar(100);Declare intake_temp2_ varchar(100);Declare intake_length_ int; declare Intake_main_length int;
Declare j int default 1;
Declare Tution_Fees_ varchar(200);Declare Entry_Requirement_ varchar(500); Declare Living_Expense_ varchar(100);Declare Work_Experience_ varchar(500);
Declare Registration_Fees_ varchar(200);Declare Date_Charges_ varchar(500); Declare Bank_Statements_ varchar(100);Declare Insurance_ varchar(500);
Declare VFS_Charges_ varchar(500);Declare Other_Charges_ varchar(500);
Declare Apostille_ varchar(500);Declare Sub_Section_Id_ int ;Declare Sub_Section_Name_ varchar(150);
Declare intake_temp3_ varchar(100);
Declare Course_Status int;
Set i=0;
SET import_master_id_ = (SELECT  COALESCE( MAX(import_master_id ),0)+1 FROM import_master);    

insert into import_master(Import_Master_Id,Entry_Date)values(Import_Master_Id_,now());
WHILE i < JSON_LENGTH(Course_Details) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Course'))) INTO Course_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Code'))) INTO Course_Code_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Subject'))) INTO Subject_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Duration'))) INTO Duration_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Level'))) INTO Level_Detail_Name_;    
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Ielts'))) INTO Minimum_Score_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Internship'))) INTO Internship_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Notes'))) INTO Notes_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Details'))) INTO Details_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Fees'))) INTO Application_Fees_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].University'))) INTO University_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Country'))) INTO Country_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Intake'))) INTO Intake_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Tag'))) INTO Tag_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Tution_Fees'))) INTO Tution_Fees_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Entry_Requirement'))) INTO Entry_Requirement_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Living_Expense'))) INTO Living_Expense_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Work_Experience'))) INTO Work_Experience_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Registration_Fees'))) INTO Registration_Fees_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Date_Charges'))) INTO Date_Charges_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Bank_Statements'))) INTO Bank_Statements_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Insurance'))) INTO Insurance_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].VFS_Charges'))) INTO VFS_Charges_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Apostille'))) INTO Apostille_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Other_Charges'))) INTO Other_Charges_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Details,CONCAT('$[',i,'].Sub_Section'))) INTO Sub_Section_Name_;

    #insert into db_logs_ (id,Description) values(0,Intake_Name_);
   
   
set subject_id_ =(select COALESCE( MAX(subject_id ),0)  from subject where subject_name=Subject_Name_);
    if(subject_id_ =0)
    then
SET subject_id_ = (SELECT  COALESCE( MAX(subject_id ),0)+1 FROM subject);    
insert into subject values(subject_id_,Subject_Name_,1,0);
    end if;    
    set Sub_Section_Id_ =(select COALESCE( MAX(Sub_Section_Id ),0)  from sub_section where Sub_Section_Name=Sub_Section_Name_ and DeleteStatus =0);
    if(Sub_Section_Id_ =0)
    then
SET Sub_Section_Id_ = (SELECT  COALESCE( MAX(Sub_Section_Id ),0)+1 FROM sub_section);    
insert into sub_section values(Sub_Section_Id_,Sub_Section_Name_,1,0);
    end if;    
    if ISNULL(Duration_Name_) = true then
    set Duration_Name_ = '';
    end if;
set duration_id_ =(select  COALESCE( MAX(duration_id ),0 ) from duration where duration_name=Duration_Name_ and DeleteStatus=0);
    if(duration_id_ =0)
    then
SET duration_id_ = (SELECT  COALESCE( MAX(duration_id ),0)+1 FROM duration);    
insert into duration values(duration_id_,Duration_Name_,1,0);
    end if;    
set level_detail_id_ =(select COALESCE( MAX(level_detail_id ),0) from level_detail where level_detail_name=Level_Detail_Name_ and DeleteStatus=0);
    if(level_detail_id_ =0)
    then
SET level_detail_id_ = (SELECT  COALESCE( MAX(level_detail_id ),0)+1 FROM level_detail);    
insert into level_detail values(level_detail_id_,Level_Detail_Name_,0);
    end if;        
set ielts_id_ =(select COALESCE( MAX(ielts_id ),0) from ielts where  Minimum_Score_>=Minimum_Score  &&  Minimum_Score_<= Maximum_Score and DeleteStatus=0);
    if(ielts_id_ =0)
    then
SET ielts_id_ = (SELECT  COALESCE( MAX(ielts_id ),0)+1 FROM ielts);    
insert into ielts values(ielts_id_,Minimum_Score_,Minimum_Score_,Minimum_Score_,0);
    end if;            
set internship_id_ =(select COALESCE( MAX(internship_id ),0) from internship where internship_name=Internship_Name_ and DeleteStatus=0);
    if(internship_id_ =0)
    then
SET internship_id_ = (SELECT  COALESCE( MAX(internship_id ),0)+1 FROM internship);    
insert into internship values(internship_id_,Internship_Name_,0);
    end if;      
   set country_id_ =(select COALESCE( MAX(country_id ),0) from country where country_name=Country_Name_ and DeleteStatus=0);
    if(country_id_ =0)
    then
SET country_id_ = (SELECT  COALESCE( MAX(country_id ),0)+1 FROM country);    
insert into country values(country_id_,Country_Name_,0);
    end if;
    
  set university_id_ =(select COALESCE( MAX(university_id ),0) from university where university_name=University_Name_ and DeleteStatus=0);
    if(university_id_ =0)
    then
SET university_id_ = (SELECT  COALESCE( MAX(university_id ),0)+1 FROM university);    
insert into university (University_Id,University_Name,Country_Id,Level_Detail_Id,DeleteStatus) values(university_id_,University_Name_,country_id_,level_detail_id_,0);
    end if; 
  SET Course_Id_ = (SELECT  COALESCE( MAX(Course_Id ),0)  FROM Course where Course_Name=Course_name_ and  Country_Id=Country_Id_ and University_Id=University_Id_
  and Subject_Id=Subject_Id_ and Sub_Section_Id=Sub_Section_Id_
  );      
      if(Course_Id_ >0)
    then
update course  set Course_name=Course_name_ ,Course_Code=Course_Code_,Subject_Id=Subject_Id_,Duration_Id=Duration_Id_,Level_Id=Level_Detail_Id_,
        Ielts_Minimum_Score=ielts_id_,Internship_Id=Internship_Id_,Notes=Notes_,Details=Details_,Application_Fees=Application_Fees_,
        University_Id=University_Id_,Country_Id=Country_Id_, Tag=Tag_ ,Sub_Section_Id=Sub_Section_Id_ ,
        SubjectName = Subject_Name_,DurationName = Duration_Name_,Level_DetailName = Level_Detail_Name_,internshipName = Internship_Name_,
        UniversityName = University_Name_,CountryName = Country_Name_,Sub_SectionName = Sub_Section_Name_,IntakeName = Intake_Name_
        where Course_Id =Course_Id_;
 else
SET Course_Id_ = (SELECT  COALESCE( MAX(Course_Id ),0)+1 FROM Course);    
INSERT INTO Course(Course_Id,Course_Name,Course_Code,University_Id,Level_Id,Subject_Id,Duration_Id,Country_Id,Details,Tution_Fees,Work_Experience,Application_Fees,Entry_Requirement,Duration,Living_Expense,Ielts_Minimum_Score,IELTS_Name,Internship_Id,Notes,Tag,Intake_Name,Course_Status,DeleteStatus,
        Registration_Fees,Date_Charges,Bank_Statements,Insurance,VFS_Charges,Apostille,Other_Charges,Sub_Section_Id,
        SubjectName,DurationName,Level_DetailName,internshipName,UniversityName,CountryName,Sub_SectionName)
values (Course_Id_,Course_Name_,Course_Code_,University_Id_,Level_Detail_Id_,Subject_Id_,Duration_Id_,Country_Id_,Details_,Tution_Fees_,Work_Experience_,Application_Fees_,Entry_Requirement_,Duration_Name_,Living_Expense_,ielts_id_,Minimum_Score_,Internship_Id_,Notes_,Tag_,Intake_Name_,1,false
        ,Registration_Fees_,Date_Charges_,Bank_Statements_,Insurance_,VFS_Charges_,Apostille_,Other_Charges_,Sub_Section_Id_,
        Subject_Name_,Duration_Name_,Level_Detail_Name_,Internship_Name_,University_Name_,Country_Name_,Sub_Section_Name_);  

end if;    
delete from course_intake where Course_Id=course_Id_;
do_this:
while j>0 do
#set Intake_Name_ = trim(Intake_Name_);
     
SET Intake_main_length = LENGTH(Intake_Name_);
#set Intake_temp1_ =(SELECT SUBSTRING_INDEX(Intake_Name_, ',',1));        
        set Intake_temp1_= SUBSTRING_INDEX(Intake_Name_, ",", 1);
       # set Intake_temp1_ = trim(Intake_temp1_);
       # if(Intake_temp1_ != '') then
# set intake_temp3_ =trim(Intake_temp1_);
#end if;
       

        set intake_id_ =(select COALESCE( MAX(intake_id ),0) from intake where intake_name=trim(Intake_temp1_) and DeleteStatus = 0 );
if(intake_id_ =0)
then
SET intake_id_ = (SELECT  COALESCE( MAX(intake_id ),0)+1 FROM intake);    
insert into intake values(intake_id_,trim(Intake_temp1_),0);
end if;
        insert into course_intake(Course_Id,Intake_Id,Intake_Status)values(Course_Id_,Intake_Id_,1);
SET intake_length_ = LENGTH(Intake_temp1_);
        
SET Intake_Name_ = MID(Intake_Name_, intake_length_+2, Intake_main_length);
        set j=length(Intake_main_length);
        
IF Intake_Name_ = NULL || Intake_Name_ = '' THEN
set j=0;
END IF;
END while;
set j=1;
INSERT INTO import_detail(Import_Master_Id,Course_Id)values(Import_Master_Id_,Course_Id_);    
   
SELECT i + 1 INTO i;      
END WHILE;

 select  import_master_id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Department`( In Department_Id_ int,
Department_Name_ varchar(50),
FollowUp_ TInyint,
Status_ varchar(50),
Department_Order_ int,
Color_ varchar(50),Department_Status_Id_ int,Transfer_Method_Id_ int,
Color_Type_Id_ int,Color_Type_Name_ varchar(45),
Status_Selection JSON)
Begin 
 DECLARE Status_Id_ int; 
DECLARE i int  DEFAULT 0;
	

    
 if  Department_Id_>0
  THEN 
	delete from Status_Selection where Department_Id=Department_Id_;
   
	UPDATE Department set Department_Id = Department_Id_ ,
	Department_Name = Department_Name_ ,
	FollowUp = FollowUp_ ,
	Status = Status_ ,
	Department_Order = Department_Order_ ,Department_Status_Id=Department_Status_Id_,Transfer_Method_Id=Transfer_Method_Id_,
	Color = Color_ ,Color_Type_Id=Color_Type_Id_,
    Color_Type_Name=Color_Type_Name_
    Where Department_Id=Department_Id_ ;
    update student set Followup_Department_Name = Department_Name_ where Followup_Department_Id = Department_Id_;
    update student set Color = Color_Type_Name_ where Followup_Department_Id = Department_Id_;
	ELSE 
	SET Department_Id_ = (SELECT  COALESCE( MAX(Department_Id ),0)+1 FROM Department); 
	INSERT INTO Department(Department_Id ,Department_Name ,FollowUp ,Status ,Department_Order ,
	Color ,Department_Status_Id,Current_User_Index,Total_User,Transfer_Method_Id,Is_Delete,Color_Type_Id,Color_Type_Name ) 
	values (Department_Id_ ,Department_Name_ ,FollowUp_ ,Status_ ,Department_Order_ ,Color_ ,Department_Status_Id_,1,0,
    Transfer_Method_Id_,false,Color_Type_Id_,Color_Type_Name_);
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

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Department_Status`( In Department_Status_Id_ int,
Department_Status_Name_ varchar(50),
Status_Order_ int,
Editable_ TINYINT,
Color_ varchar(50),Status_Type_Id_ int,Status_Type_Name_ varchar(250))
Begin 
 if  Department_Status_Id_>0
 THEN 
 UPDATE Department_Status set Department_Status_Id = Department_Status_Id_ ,
Department_Status_Name = Department_Status_Name_ ,
Status_Order = Status_Order_ ,
Editable = Editable_ ,
Color = Color_,Status_Type_Id=Status_Type_Id_,Status_Type_Name=Status_Type_Name_
  Where Department_Status_Id=Department_Status_Id_ ;
 update student set Department_Status_Name = Department_Status_Name_ where Status_Id = Department_Status_Id_;
 ELSE 
 SET Department_Status_Id_ = (SELECT  COALESCE( MAX(Department_Status_Id ),0)+1 FROM Department_Status); 
 INSERT INTO Department_Status(Department_Status_Id ,
Department_Status_Name ,
Status_Order ,
Editable ,
Color ,
Is_Delete,Status_Type_Id,
Status_Type_Name ) values (Department_Status_Id_ ,
Department_Status_Name_ ,
Status_Order_ ,
Editable_ ,
Color_ ,
false,
Status_Type_Id_,
Status_Type_Name_);
 End If ;
 select Department_Status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Document`( In Document_Id_ int,
Document_Name_ varchar(50))
Begin 
 if  Document_Id_>0
 THEN 
 UPDATE Document set Document_Id = Document_Id_ ,
Document_Name = Document_Name_  Where Document_Id=Document_Id_ ;
 ELSE 
 SET Document_Id_ = (SELECT  COALESCE( MAX(Document_Id ),0)+1 FROM Document); 
 INSERT INTO Document(Document_Id ,
Document_Name,DeleteStatus) values (Document_Id_ ,
Document_Name_,false );
 End If ;
 select Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_DocumentName`( In Document_Id_ int,
Document_Name_ varchar(500))
Begin 

 if  Document_Id_>0
 THEN 
 UPDATE document set Document_Id = Document_Id_ ,
Document_Name = Document_Name_ Where Document_Id = Document_Id_ ;
 ELSE 
 
 SET Document_Id_ = (SELECT  COALESCE( MAX(Document_Id ),0)+1 FROM document); 
 INSERT INTO document(Document_Id ,
Document_Name,DeleteStatus) values (Document_Id_ ,
Document_Name_,false );
 End If ;
 select Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Duration`( In Duration_Id_ int,
Duration_Name_ varchar(50))
Begin 
 if  Duration_Id_>0
 THEN 
 UPDATE Duration set Duration_Id = Duration_Id_ ,
Duration_Name = Duration_Name_  Where Duration_Id=Duration_Id_ ;
 ELSE 
 SET Duration_Id_ = (SELECT  COALESCE( MAX(Duration_Id ),0)+1 FROM Duration); 
 INSERT INTO Duration(Duration_Id ,
Duration_Name,DeleteStatus ) values (Duration_Id_ ,
Duration_Name_,false );
 End If ;
 select Duration_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Enquiry_Source`( In Enquiry_Source_Id_ int,
Enquiry_Source_Name_ varchar(45))
Begin 
 if  Enquiry_Source_Id_>0
 THEN 
 UPDATE Enquiry_Source set Enquiry_Source_Id = Enquiry_Source_Id_ ,
Enquiry_Source_Name = Enquiry_Source_Name_,Agent_Status=0 Where Enquiry_Source_Id=Enquiry_Source_Id_ ;
update student set Enquiry_Source_Name = Enquiry_Source_Name_ where Enquiry_Source_Id = Enquiry_Source_Id_;
 ELSE 
 SET Enquiry_Source_Id_ = (SELECT  COALESCE( MAX(Enquiry_Source_Id ),0)+1 FROM Enquiry_Source); 
 INSERT INTO Enquiry_Source(Enquiry_Source_Id ,
Enquiry_Source_Name,DeleteStatus,Agent_Status) values (Enquiry_Source_Id_ ,
Enquiry_Source_Name_,false,0 );
 End If ;
 select Enquiry_Source_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Fees`( In Fees_Id_ int,
Fees_Name_ varchar(45))
Begin 

 if  Fees_Id_>0
 THEN 
 UPDATE fees set Fees_Id = Fees_Id_ ,
Fees_Name = Fees_Name_ Where Fees_Id = Fees_Id_ ;
 ELSE 
 
 SET Fees_Id_ = (SELECT  COALESCE( MAX(Fees_Id ),0)+1 FROM fees); 
 INSERT INTO fees(Fees_Id ,
Fees_Name,DeleteStatus) values (Fees_Id_ ,
Fees_Name_,false );
 End If ;
 select Fees_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_FeesReceipt`( In FeesReceiptdetails_ json,
 FeesReceiptdetails_Value_ int,feesreceipt_document_ json,feesreceipt_document_Value_ int )
Begin
declare Fees_Receipt_Id_ int;declare Student_Id_ int;declare FeesreceiptDocument_Description_ Varchar(500);
declare Entry_date_ datetime;declare User_Id_ int;declare Description_ varchar(200);
declare Fees_Id_ int;declare Amount_ int;declare Fees_Name_ varchar(200);
declare Actual_Entry_date_ datetime;
declare Fee_Receipt_Branch_ int;
declare Voucher_No_ int;DECLARE Currency_ varchar(45);
declare FeesreceiptFile_Name_  varchar(500);declare FeesreceiptDocument_Name_  varchar(500);
declare FeesreceiptDocument_File_Name_  varchar(500);
declare Feesreceipt_document_Id_ int;declare Course_Name_ varchar(500);
declare Application_Fees_Paid_ varchar(45);
declare Amt_ varchar(45);
declare To_User_ int;declare Student_Name_ varchar(45);declare  Status_Id_ int;declare Status_Name_ varchar(45);declare Remark_ varchar(500);declare Notification_Id_ int;
declare From_User_Name_ varchar(45);declare ToUser_Name_ varchar(45);
declare Notification_Count_ int;declare Notification_Type_Name_ varchar(45);declare  Entry_Type_ int;

Declare i int default 0;
Declare j int default 0;
 Declare Target_ int;declare Registration_Branch_ int;declare Student_Registration_Id_ int;
declare Registered_User_ varchar(100);declare Registered_Branch_Name_ varchar(100);
declare first_Receipt int;
declare To_Account_Id_ int;declare To_Account_Name_ varchar(100);
declare Application_details_Id_ int; Declare Old_Application_details_Id_ int;
declare Old_Amount_ int;
/*DECLARE exit handler for sqlexception
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    START TRANSACTION;*/
if( FeesReceiptdetails_Value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Fees_Receipt_Id')) INTO Fees_Receipt_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Student_Id')) INTO Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Entry_date')) INTO Entry_date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.User_Id')) INTO User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Description')) INTO Description_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Fees_Id')) INTO Fees_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Amount')) INTO Amount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Currency')) INTO Currency_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.To_Account_Id')) INTO To_Account_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.To_Account_Name')) INTO To_Account_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Application_details_Id')) INTO Application_details_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Course_Name')) INTO Course_Name_;


#SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Actual_Entry_date')) INTO Actual_Entry_date_;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Fee_Receipt_Branch')) INTO Fee_Receipt_Branch_;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(FeesReceiptdetails_,'$.Voucher_No')) INTO Voucher_No_;

set  Application_Fees_Paid_ = (select Application_Fees_Paid from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus = 0 );
#insert into data_log_ values(0,Application_Fees_Paid_,'x');
set Fees_Name_ = (select Fees_Name from fees where Fees_Id = Fees_Id_ and DeleteStatus = 0 );
if(Fees_Receipt_Id_>0) then
	select amount,Application_details_Id into Old_Amount_,Old_Application_details_Id_ from fees_receipt Where Fees_Receipt_Id=Fees_Receipt_Id_;
    
    if(Old_Application_details_Id_>0) then
	update application_details set Application_Fees_Paid=Application_Fees_Paid-Old_Amount_ where Application_details_Id=Old_Application_details_Id_;
     end if;
  #insert into data_log_ values(0,Old_Amount_,Old_Application_details_Id_);
  
	UPDATE fees_receipt set Fees_Receipt_Id = Fees_Receipt_Id_,	Fees_Id = Fees_Id_,	Entry_Date=Entry_Date_,	Amount=Amount_,	Description=Description_,
	Student_Id=Student_Id_,	User_Id=User_Id_,Currency=Currency_,To_Account_Id=To_Account_Id_,To_Account_Name=To_Account_Name_
    ,Application_details_Id=Application_details_Id_	,Course_Name=Course_Name_#Fee_Receipt_Branch=Fee_Receipt_Branch_,Voucher_No=Voucher_No_
	Where Fees_Receipt_Id=Fees_Receipt_Id_;
 ELSE
#Registration

	SET Fee_Receipt_Branch_=(select Branch_Id from user_details where User_Details_Id=User_Id_);
	SET first_Receipt=(select count(Student_Id)  from fees_receipt where Student_Id=Student_Id_);
    
	if (first_Receipt=0) then
		set Registration_Branch_=Fee_Receipt_Branch_;
		set Target_=(select Registration_Target from user_details where User_Details_Id=User_Id_ );
		set Registered_User_=(select User_Details_Name from user_details where User_Details_Id=User_Id_ );
		set Registered_Branch_Name_=(select Branch_Name from branch where Branch_Id=Registration_Branch_);
        
	/* set Student_Registration_Id_ = (SELECT  COALESCE( MAX(Student_Registration_Id ),0)+1 FROM Student);
		Update Student set Is_Registered = true , Registered_By = User_Id_ , Registered_On = now(),
		Registration_Target=Target_,Registration_Branch=Registration_Branch_,
		Student_Registration_Id = Student_Registration_Id_,
		Registered_User=Registered_User_,Counsilor_User=User_Id_,Registered_Branch=Registered_Branch_Name_
		where Student_Id = Student_Id_; */
	 end if;
     
    
	SET Fees_Receipt_Id_ = (SELECT  COALESCE( MAX(Fees_Receipt_Id ),0)+1 FROM fees_receipt);
	SET Voucher_No_ = (SELECT  COALESCE( MAX(Voucher_No ),0)+1 FROM fees_receipt);
	INSERT INTO fees_receipt(Fees_Receipt_Id,Fees_Id ,
	Entry_Date,	Amount,	Description,	Student_Id,	User_Id,Actual_Entry_Date,
				Delete_Status,Fee_Receipt_Branch,Voucher_No,Currency,To_Account_Id,To_Account_Name,
                Application_details_Id,Course_Name,Fees_Receipt_Status,
                Refund_Requested_On,Refund_Requested_By,Refund_Request_Status
				)
				values (Fees_Receipt_Id_,Fees_Id_,Entry_Date_,Amount_,Description_,Student_Id_,User_Id_,
                now(),0,Fee_Receipt_Branch_,Voucher_No_,Currency_,
                To_Account_Id_,To_Account_Name_,Application_details_Id_,Course_Name_,1,now(),User_Id_,1);
				insert into transaction_history(Entry_date,User_Id,Student_Id,Description1,Description2,Description3,Transaction_type)
				values (Entry_date_,User_Id_,Student_Id_,Description_,Description_,Description_,0);
	 End If ;
     
     
       if(Application_details_Id_>0) then
       set Amt_ = (select Application_Fees_Paid from application_details where Application_details_Id=Application_details_Id_);
       if(Amt_=-1) then
        set Amt_=0;
       end if;
	 update application_details set Application_Fees_Paid=Amt_+Amount_ where Application_details_Id=Application_details_Id_;
      end if;
 end if;
 
 if( feesreceipt_document_Value_>0) then
		WHILE j < JSON_LENGTH(feesreceipt_document_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(feesreceipt_document_,CONCAT('$[',j,'].FeesreceiptFile_Name'))) INTO FeesreceiptFile_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(feesreceipt_document_,CONCAT('$[',j,'].FeesreceiptDocument_Name'))) INTO FeesreceiptDocument_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(feesreceipt_document_,CONCAT('$[',j,'].FeesreceiptDocument_File_Name'))) INTO FeesreceiptDocument_File_Name_;
		#SELECT JSON_UNQUOTE (JSON_EXTRACT(feesreceipt_document_,CONCAT('$[',j,'].FeesreceiptDocument_Description'))) INTO FeesreceiptDocument_Description_;
				SET Feesreceipt_document_Id_ = (SELECT  COALESCE( MAX(Feesreceipt_document_Id ),0)+1 FROM feesreceipt_document);
				insert into feesreceipt_document (Feesreceipt_document_Id,Student_Id,Entry_date,
				FeesreceiptFile_Name,FeesreceiptDocument_Name,
				FeesreceiptDocument_File_Name,Fees_Receipt_Id,DeleteStatus)
				values(Feesreceipt_document_Id_,Student_Id_,now(),FeesreceiptFile_Name_,
				FeesreceiptDocument_Name_,FeesreceiptDocument_File_Name_,Fees_Receipt_Id_,0);
		SELECT j + 1 INTO j;      
		END WHILE;
 end if;
 
 set To_User_ =83;
if User_Id_ !=To_User_ then 
	set Student_Name_ =(select Student_Name from Student where Student_Id = Student_Id_ and DeleteStatus=false);
	set Status_Id_ =0;
	set Status_Name_ ='';
	set Entry_Type_ = 4;
	set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = User_Id_ and DeleteStatus=false); 
	set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false); 
	set Notification_Type_Name_ = 'Receipt';
	SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
							values(Notification_Id_,User_Id_,From_User_Name_,To_User_,ToUser_Name_,Status_Id_,Status_Name_,1,Description_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_; 
end if;
#commit;
 select Fees_Receipt_Id_,Student_Name_,Notification_Type_Name_,From_User_Name_,To_User_,Entry_Type_,Notification_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_FollowUp`( In Student_Id_ int,By_User_Id_ int,
Branch_ int,Department_ int,Status_ int,User_Id_ int,Next_FollowUp_Date_ datetime,Remark_ varchar(100),Remark_Id_ int,Class_Id_ int,Class_Name_ varchar(100),
Sub_Status_Id_ int,Sub_Status_Name_ varchar(100),Department_Status_Name_ varchar(100),Branch_Name_ varchar(100),Department_Name_ varchar(100),By_User_Name_ varchar(100),To_User_Name_ varchar(100),Department_FollowUp_ int)
Begin
#DECLARE Student_Id_ int;
Declare i int;
declare Student_FollowUp_Id_ int;
declare import_master_id int default 0;
declare Master_Id_ int;

Set i=0;
set Department_Name_=( select Department_Name from department where Department_Id = Department_);
set Branch_Name_=( select Branch_Name from branch where Branch_Id = Branch_);


INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id,Branch,Remark,Remark_Id,By_User_Id,Class_Id,Class_Name ,DeleteStatus,FollowUP_Time,Actual_FollowUp_Date,Sub_Status_Id,Sub_Status_Name,Dept_StatusName,Branch_Name,Dept_Name,ByUserName,UserName,Entry_Type,FollowUp)
values (Student_Id_ ,Now(),Next_FollowUp_Date_,0,Department_ ,Status_ ,User_Id_,Branch_,Remark_,Remark_Id_,By_User_Id_,Class_Id_,Class_Name_,false,Now(),Now(),Sub_Status_Id_,Sub_Status_Name_,Department_Status_Name_,Branch_Name_,Department_Name_,By_User_Name_,To_User_Name_,1,Department_FollowUp_);
set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
#Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Next_FollowUp_Date = Next_FollowUp_Date_
#where student.Student_Id=Student_Id_;   
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Followup_Department_Id = Department_ ,Status_Id = Status_ ,Followup_Department_Name=Department_Name_,Followup_Branch_Name=Branch_Name_,Department_Status_Name=Department_Status_Name_,By_UserName=By_User_Name_,To_User_Name=To_User_Name_,FollowUp=Department_FollowUp_,
	To_User_Id = User_Id_,By_User_Id=By_User_Id_,Next_FollowUp_Date = Next_FollowUp_Date_ ,Remark = Remark_,Remark_Id = Remark_Id_,
	Followup_Branch_Id=Branch_,Class_Id=Class_Id_,Class_Name=Class_Name_,Sub_Status_Id=Sub_Status_Id_,Sub_Status_Name=Sub_Status_Name_
	where student.Student_Id=Student_Id_;
SELECT i + 1 INTO i;      

set import_master_id=1;
select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Front_Student`( In Work_Experience_Id_ int,
Slno_ int,Student_Id_ int,Ex_From_ varchar(25),Ex_To_ varchar(25),Years_ varchar(25),
Company_ varchar(250),Designation_ varchar(50),Salary_ varchar(45),Salary_Mode_ varchar(100))
Begin
if  Work_Experience_Id_>0
 THEN 
    UPDATE work_experience set Work_Experience_Id = Work_Experience_Id_ ,
    Slno = Slno_ ,Student_Id=Student_Id_,Ex_From=Ex_From_,Ex_To=Ex_To_,
    Years=Years_,Company=Company_,Designation=Designation_,Salary=Salary_,
    Salary_Mode=Salary_Mode_
    Where Work_Experience_Id=Work_Experience_Id_ ;
    
 ELSE 
    SET Work_Experience_Id_ = (SELECT  COALESCE( MAX(Work_Experience_Id ),0)+1 FROM work_experience); 
    SET Slno_ = (SELECT  COALESCE( MAX(Slno ),0)+1 FROM work_experience); 
    INSERT INTO work_experience(Work_Experience_Id,Slno,Student_Id,Ex_From,
Ex_To,Years,Company,Designation,Salary,Salary_Mode,DeleteStatus ) 
    values (Work_Experience_Id_,Slno_,Student_Id_,Ex_From_,
Ex_To_,Years_,Company_,Designation_,Salary_,Salary_Mode_,false);
 End If ;
 select Work_Experience_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Front_Student1`( In Unique_Id_ Varchar(200),Student_Name_ Varchar(100),Dob_ Varchar(100),Address1_ Varchar(2000),
Telephone_ Varchar(100),Guardian_telephone_ Varchar(100),Email_ Varchar(100),Marital_Status_Id_ int ,Marital_Status_Name_ Varchar(100),
Spouse_Name_ Varchar(100),No_Of_Kids_And_Age_ Varchar(100),Date_Of_Marriage_ Varchar(100),Spouse_Occupation_ Varchar(100),
Spouse_Qualification_ Varchar(100),Any_Previous_Visa_ text , Ielts_ Varchar(100),Ielts_Type_Id_ int,Taken_Date_ datetime, Exam_Check_ tinyint,Listening_ Varchar(100),
Reading_ Varchar(100),Writing_ Varchar(100),Speaking_ Varchar(100),Overall_ Varchar(100),Description_ Varchar(100),
Student_Experience_Data json,Qualification_Data json,Application_Details_Data json)
Begin


declare Ielts_Details_Id_ int;declare intake_Id_ int;
DECLARE i int  DEFAULT 0;DECLARE j int  DEFAULT 0;DECLARE k int  DEFAULT 0;
declare Work_Experience_Id_ int;declare Company_ Varchar(100);declare Designation_ Varchar(100);
declare Salary_ Varchar(100);declare Salary_Mode_ Varchar(100);declare Ex_From_ Varchar(100);declare Ex_To_ Varchar(100);declare Experience_Data_ Varchar(100);
declare Course_Fee_ Varchar(45);
declare Credential_ Varchar(100);declare school_ Varchar(100);declare Field_ Varchar(100);declare MarkPer_ Varchar(100);declare Backlog_History_ Varchar(500);
declare Year_of_passing_ Varchar(100);declare Duration_Id_ int;

declare Preference_ Varchar(250);declare Country_Name_ Varchar(250);declare University_Name_ Varchar(250);
declare Course_Name_ Varchar(250);declare intake_Name_ Varchar(250);declare Living_Expense_ Varchar(250);
declare Intake_Year_Id_ int;declare Intake_Year_Name_ Varchar(45);declare Country_Id_ Varchar(45);
declare Fromyear_ Varchar(25);declare Toyear_ Varchar(25);declare result_ Varchar(200);declare Student_Id_ varchar(500);
 #insert into  data_log_ values(1,Application_Details_Data.Intake_,'');
 #SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM student);

 
 /*INSERT INTO student(Student_Name,Dob,Address1,Phone_Number,Guardian_telephone,Email,Marital_Status_Id,
 Marital_Status_Name,Spouse_Name,No_of_Kids_and_Age,Date_of_Marriage,Spouse_Occupation,Spouse_Qualification,
 Previous_Visa_Rejection,DeleteStatus)
 values ( Student_Name_,Dob_,Address1_,Telephone_,Guardian_telephone_,Email_,Marital_Status_Id_,
 Marital_Status_Name_,Spouse_Name_,No_Of_Kids_And_Age_, Date_Of_Marriage_,Spouse_Occupation_,Spouse_Qualification_,
 Any_Previous_Visa_,false );*/
 
 set Student_Id_ = (select Student_Id from Student where  Unique_Id = Unique_Id_);

 update student set Student_Id=Student_Id_,
 Student_Name=Student_Name_,Dob=Dob_,Address1=Address1_,Phone_Number=Telephone_,Guardian_telephone=Guardian_telephone_,Email=Email_,Marital_Status_Id=Marital_Status_Id_,
 Marital_Status_Name=Marital_Status_Name_,Spouse_Name=Spouse_Name_,No_of_Kids_and_Age=No_Of_Kids_And_Age_,Date_of_Marriage=Date_Of_Marriage_,Spouse_Occupation=Spouse_Occupation_,Spouse_Qualification=Spouse_Qualification_,
 Previous_Visa_Rejection=Any_Previous_Visa_,Status_Student_Fill=1 Where Student_Id = Student_Id_ ;
 
 
 #SET Ielts_Details_Id_ = (SELECT  COALESCE( MAX(Ielts_Details_Id_ ),0)+1 FROM ielts_details);
 if ( Ielts_Type_Id_ !=0  or Listening_ !='' or Reading_ !='' or Writing_ !='' or Speaking_ !='' or Overall_ !='' or Description_ !='' or Exam_Check_ !=false   ) then
 INSERT INTO ielts_details(Student_Id,Ielts_Type,Ielts_Type_Name,Exam_Date,Listening, Reading,Writing ,Speaking ,Overall,Exam_Check,Description,DeleteStatus)
 values ( Student_Id_,Ielts_Type_Id_,Ielts_,Taken_Date_,Listening_,Reading_,Writing_,Speaking_,Overall_,Exam_Check_,Description_,false );
 end if;
 
WHILE i < JSON_LENGTH(Student_Experience_Data) DO

SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Experience_Data,CONCAT('$[',i,'].From'))) INTO Ex_From_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Experience_Data,CONCAT('$[',i,'].To'))) INTO Ex_To_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Experience_Data,CONCAT('$[',i,'].Employer_Name'))) INTO Company_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Experience_Data,CONCAT('$[',i,'].Designation'))) INTO Designation_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Experience_Data,CONCAT('$[',i,'].Salary'))) INTO Salary_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Experience_Data,CONCAT('$[',i,'].Salary_Mode'))) INTO Salary_Mode_;
       
if ( Ex_From_ !='' or Ex_To_ !='' or Company_ !='' or Designation_ !='' or Salary_ !='' or Salary_Mode_ !='' ) then
INSERT INTO work_experience(Student_Id ,Ex_From ,Ex_To  ,Company ,Designation,
         Salary,Salary_Mode,DeleteStatus )
values (Student_Id_ ,Ex_From_ ,Ex_To_ ,Company_ ,Designation_,
         Salary_,Salary_Mode_ ,false);
end if;
SELECT i + 1 INTO i;
END WHILE;
   
    WHILE j < JSON_LENGTH(Qualification_Data) DO

SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].Credential'))) INTO Credential_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].school'))) INTO school_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].Field'))) INTO Field_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].MarkPer'))) INTO MarkPer_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].Backlog_History'))) INTO Backlog_History_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].Year_of_passing'))) INTO Year_of_passing_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].Fromyear'))) INTO Fromyear_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].Toyear'))) INTO Toyear_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Qualification_Data,CONCAT('$[',j,'].result'))) INTO result_;
 
 if ( school_ !='' or Field_ !='' or MarkPer_ !='' or Backlog_History_ !='' or Year_of_passing_ !='' or Fromyear_ !='' or Toyear_ !='' or result_ !='' ) then
INSERT INTO qualification(Student_Id,Credential ,school ,Field  ,MarkPer ,Backlog_History,Year_of_passing,Fromyear,Toyear,result,DeleteStatus )
values (Student_Id_,Credential_ ,school_ ,Field_  ,MarkPer_ ,Backlog_History_,Year_of_passing_,Fromyear_,Toyear_,result_,false);
end if;
SELECT j + 1 INTO j;
END WHILE;
   
 
        WHILE k < JSON_LENGTH(Application_Details_Data) DO
       
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Preference'))) INTO Preference_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Country_Id'))) INTO Country_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Country_Name'))) INTO Country_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].University_Name'))) INTO University_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Course_Name'))) INTO Course_Name_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].intake_Id'))) INTO intake_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].intake_Name'))) INTO intake_Name_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Intake_Year_Id'))) INTO Intake_Year_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Intake_Year_Name'))) INTO Intake_Year_Name_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Living_Expense'))) INTO Living_Expense_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Course_Fee'))) INTO Course_Fee_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_Details_Data,CONCAT('$[',k,'].Duration_Id'))) INTO Duration_Id_;



if (Intake_Year_Id_ !='' or Intake_Year_Name_ !='' or Preference_ !='' or Country_Id_ !='' or Country_Name_ !='' or University_Name_ !='' or Course_Name_ !='' or intake_Id_ !='' or intake_Name_ !='' or Living_Expense_ !='' or Course_Fee_ !='' ) then
       
INSERT INTO application_details(Student_Id,Preference ,Country_Name ,University_Name  ,Course_Name ,Course_Fee,intake_Name,Living_Expense,Bph_Approved_Status,Student_Approved_Status,Remark,intake_Id,Country_Id,Intake_Year_Id,Intake_Year_Name,Activation_Status,Application_Source,Application_Fees_Paid,Duration_Id,DeleteStatus )
values (Student_Id_,Preference_ ,Country_Name_ ,University_Name_  ,Course_Name_ ,Course_Fee_,intake_Name_,Living_Expense_,1,0,'',intake_Id_,Country_Id_,Intake_Year_Id_,Intake_Year_Name_,0,0,-1,Duration_Id_,false);
end if;
SELECT k + 1 INTO k;
END WHILE;

 select Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Ielts_Details`( In Ielts_Details_Id_ int,
Slno_ int,Student_Id_ int,Ielts_Type_ int,Ielts_Type_Name_ varchar(455),Exam_Check_ tinyint,
Exam_Date_ Datetime,Description_ varchar(500),Listening_ varchar(45),Reading_ varchar(45),
Writing_ varchar(45),Speaking_ varchar(45),Overall_ varchar(45))
Begin
if  Ielts_Details_Id_>0
 THEN 
    UPDATE Ielts_Details set Ielts_Details_Id = Ielts_Details_Id_ ,
    Slno = Slno_ ,Student_Id=Student_Id_,Ielts_Type=Ielts_Type_,Ielts_Type_Name=Ielts_Type_Name_,
    Exam_Check=Exam_Check_,Exam_Date=Exam_Date_,Description=Description_,Listening=Listening_,Reading=Reading_,
    Writing=Writing_,Speaking=Speaking_,Overall=Overall_
    Where Ielts_Details_Id=Ielts_Details_Id_;
    
 ELSE 
    SET Ielts_Details_Id_ = (SELECT  COALESCE( MAX(Ielts_Details_Id ),0)+1 FROM Ielts_Details); 
    SET Slno_ = (SELECT  COALESCE( MAX(Slno ),0)+1 FROM Ielts_Details); 
    INSERT INTO Ielts_Details(Ielts_Details_Id,Slno,Student_Id,Ielts_Type,
Ielts_Type_Name,Exam_Check,Exam_Date,Description,Listening,Reading,Writing,Speaking,Overall,DeleteStatus ) 
    values (Ielts_Details_Id_,Slno_,Student_Id_,Ielts_Type_,
Ielts_Type_Name_,Exam_Check_,Exam_Date_,Description_,Listening_,Reading_,Writing_,Speaking_,Overall_,false);
 End If ;
 select Ielts_Details_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Intake`( In Intake_Id_ int,
Intake_Name_ varchar(50))
Begin 
 if  Intake_Id_>0
 THEN 
 UPDATE Intake set Intake_Id = Intake_Id_ ,
Intake_Name = Intake_Name_  Where Intake_Id=Intake_Id_ ;
 ELSE 
 SET Intake_Id_ = (SELECT  COALESCE( MAX(Intake_Id ),0)+1 FROM Intake); 
 INSERT INTO Intake(Intake_Id ,
Intake_Name,DeleteStatus ) values (Intake_Id_ ,
Intake_Name_,false );
 End If ;
 select Intake_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Internship`( In Internship_Id_ int,
Internship_Name_ varchar(50))
Begin 
 if  Internship_Id_>0
 THEN 
 UPDATE Internship set Internship_Id = Internship_Id_ ,
Internship_Name = Internship_Name_  Where Internship_Id=Internship_Id_ ;
 ELSE 
 SET Internship_Id_ = (SELECT  COALESCE( MAX(Internship_Id ),0)+1 FROM Internship); 
 INSERT INTO Internship(Internship_Id ,
Internship_Name,DeleteStatus ) values (Internship_Id_ ,
Internship_Name_,false );
 End If ;
 select Internship_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Invoice`( In Invoice_Details_ json,Invoice_Details_Value_ int,Invoice_document_ json,Invoice_Document_Value_ int )
Begin
 Declare Invoice_Id_ int;Declare Student_Id_ int;Declare Entry_Date_ datetime; Declare Description_ varchar(100);Declare Amount_ decimal(18,2);
 declare Invoice_File_Name_ varchar(100); declare Invoice_Document_Name_ varchar(100); declare Invoice_Document_File_Name_ varchar(100);
Declare i int default 0;Declare j int default 0;
/*DECLARE exit handler for sqlexception
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    START TRANSACTION;*/
if( Invoice_Details_Value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_Details_,'$.Invoice_Id')) INTO Invoice_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_Details_,'$.Student_Id')) INTO Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_Details_,'$.Entry_Date')) INTO Entry_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_Details_,'$.Description')) INTO Description_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_Details_,'$.Amount')) INTO Amount_;

if(Invoice_Id_>0) then
 UPDATE invoice set Invoice_Id = Invoice_Id_ ,Description = Description_,Student_Id = Student_Id_,Entry_Date = Entry_Date_,Amount = Amount_
  Where Invoice_Id = Invoice_Id_;
 ELSE  
SET Invoice_Id_ = (SELECT  COALESCE( MAX(Invoice_Id ),0)+1 FROM invoice);
 INSERT INTO invoice(Invoice_Id,Description ,Entry_Date,Student_Id,Amount,DeleteStatus)
            values (Invoice_Id_,Description_,Entry_Date_,Student_Id_,Amount_,0);
End If ;
 end if;
 if( Invoice_Document_Value_>0) then
WHILE j < JSON_LENGTH(Invoice_document_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_document_,CONCAT('$[',j,'].Invoice_File_Name'))) INTO Invoice_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_document_,CONCAT('$[',j,'].Invoice_Document_Name'))) INTO Invoice_Document_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Invoice_document_,CONCAT('$[',j,'].Invoice_Document_File_Name'))) INTO Invoice_Document_File_Name_;
        insert into Invoice_document (Invoice_Id,Entry_Date,Description,Invoice_Document_Name,Invoice_Document_File_Name,Invoice_File_Name,Student_Id,DeleteStatus)
        values(Invoice_Id_,now(),'',Invoice_Document_Name_,Invoice_Document_File_Name_,Invoice_File_Name_,Student_Id_,0);
SELECT j + 1 INTO j;      
END WHILE;
 end if;
#commit;
 select Invoice_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Level_Detail`( In Level_Detail_Id_ int,
Level_Detail_Name_ varchar(50))
Begin 
 if  Level_Detail_Id_>0
 THEN 
 UPDATE Level_Detail set Level_Detail_Id = Level_Detail_Id_ ,
Level_Detail_Name = Level_Detail_Name_  Where Level_Detail_Id=Level_Detail_Id_ ;
 ELSE 
 SET Level_Detail_Id_ = (SELECT  COALESCE( MAX(Level_Detail_Id ),0)+1 FROM Level_Detail); 
 INSERT INTO Level_Detail(Level_Detail_Id ,
Level_Detail_Name,DeleteStatus ) values (Level_Detail_Id_ ,
Level_Detail_Name_,false );
 End If ;
 select Level_Detail_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Lodgemet`(In Application_details_Id_ int,Login_User_ int,Application_Status_Id_ int,Application_Status_Name_ varchar(1000),Application_No_ varchar(45),Agent_Id_ int,
Agent_Name_ varchar(150),Offerletter_Type_Id_ int,Offerletter_Type_Name_ varchar(50),Conditions_Value_ int,Conditions_ Json)
BEGIN
declare Application_details_History_Id_ int;declare Fees_Receipt_Id_ int;declare Fee_Receipt_Branch_ int;declare first_Receipt int;
Declare Target_ int;declare Registration_Branch_ int;declare Student_Registration_Id_ int;declare Registered_User_ varchar(100);
declare Registered_Branch_Name_ varchar(100);declare bph_approved_status_ int; declare Student_Id_ int;declare counsellor_id_ int;
declare From_User_Name_ varchar(200);declare Bph_Status_Name_ varchar(200);declare Notification_Id_ int;declare Notification_Count_ int;
declare Student_Name_ varchar(200);declare Notification_Type_Name_ varchar(20);declare To_User_ int;declare To_User_Name_ varchar(45);declare Entry_Type_ int;
declare department_ int;declare Notification_Tik_ int;declare Transferdept_Tik_ int;declare Transfer_department_ int;
declare To_User_Transfer_ int;declare To_User_Name_Transfer_ varchar(500);declare Student_Status_Id_ int;declare Student_Status_Name_ varchar(500);
declare Conditions_Name_ varchar(100);Declare i int default 0;declare Conditions_Id_ int;
SET Student_Id_=(select Student_Id  from application_details where Application_details_Id=Application_details_Id_ 
and DeleteStatus=false);
#set counsellor_id_=(select Counsilor_User  from student where Student_Id=Student_Id_ and DeleteStatus=false);
#set Student_Status_Id_ = (select Status_Id  from student where Student_Id=Student_Id_);
#set Student_Status_Name_ = (select Department_Status_Name  from student where Student_Id=Student_Id_);
set Student_Name_ = (select Student_Name from student where Student_Id = Student_Id_);
Update application_details set User_Id=Login_User_,
Application_No=Application_No_,
Application_status_Id=Application_Status_Id_,Application_Status_Name=Application_Status_Name_,
Agent_Id=Agent_Id_,Agent_Name=Agent_Name_
where Application_details_Id = Application_details_Id_;
set Application_details_History_Id_=(select max(Application_details_History_Id) from Application_details_History
where Application_details_Id=Application_details_Id_ and Deletestatus=0);
Update application_details_history set 
Application_No=Application_No_,
Application_status_Id=Application_Status_Id_,Application_Status_Name=Application_Status_Name_,
Agent_Id=Agent_Id_,Agent_Name=Agent_Name_
where User_Id = Login_User_ and Application_details_History_Id = Application_details_History_Id_;

set From_User_Name_ =(select User_Details_Name from user_details where 
User_Details_Id = Login_User_ and DeleteStatus=false);  

set Notification_Tik_ =(select Notification_Status from application_status where 
Application_status_Id = Application_Status_Id_ and DeleteStatus=false); 

set Transferdept_Tik_ =(select Transfer_Status from application_status where 
Application_status_Id = Application_Status_Id_ and DeleteStatus=false); 

if (Transferdept_Tik_ =1) then
	set Transfer_department_ =(select Transfer_Department_Id from application_status where 
	Application_status_Id = Application_Status_Id_ and DeleteStatus=false);
end if;
if (Notification_Tik_ =1) then
	set department_ =(select Notification_Department_Id from application_status where 
	Application_status_Id = Application_Status_Id_ and DeleteStatus=false);

	set To_User_ =(select User_Id  from student_followup where 
	Department = department_  limit 1) ;

	set To_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and 
	DeleteStatus=false);  

	if  Login_User_ != To_User_ and To_User_>0 then
		set Notification_Type_Name_= 'Transfer';
		set Entry_Type_ = 1;
		SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
		insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,View_Status,Entry_Date,Student_Id,Student_Name,
		Status_Id,Status_Name,DeleteStatus,Description,Entry_Type)
		values(Notification_Id_,Login_User_,From_User_Name_,To_User_,To_User_Name_,1,now(),
		Student_Id_,Student_Name_,Application_details_Id_,Application_Status_Name_,false,Notification_Type_Name_,Entry_Type_);
		set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
		update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_;
	end if;		
end if;
if( Conditions_Value_>0) then
WHILE i < JSON_LENGTH(Conditions_) DO
	#SELECT JSON_UNQUOTE (JSON_EXTRACT(Conditions_,CONCAT('$[',i,'].Conditions_Id'))) INTO Conditions_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Conditions_,CONCAT('$[',i,'].Conditions_Name'))) INTO Conditions_Name_;
		insert into conditions (Conditions_Name,Application_details_Id,Student_Id,DeleteStatus)
		values(Conditions_Name_,Application_details_Id_,Student_Id_,0);
	Update application_details set Offerletter_Type_Id=Offerletter_Type_Id_,Offerletter_Type_Name=Offerletter_Type_Name_
	where Application_details_Id = Application_details_Id_;
	set Application_details_History_Id_=(select max(Application_details_History_Id) from Application_details_History where Application_details_Id=Application_details_Id_ and Deletestatus=0);
	Update application_details_history set Offerletter_Type_Id=Offerletter_Type_Id_,Offerletter_Type_Name=Offerletter_Type_Name_
	where Application_details_History_Id = Application_details_History_Id_;
	SELECT i + 1 INTO i;      
END WHILE;
end if;
select Application_details_Id_,To_User_,Student_Name_,From_User_Name_,Notification_Type_Name_,Entry_Type_,To_User_,Notification_Id_,Student_Id_,Transferdept_Tik_,Application_Status_Id_,Transfer_department_,Application_details_Id_,Notification_Tik_,Application_Status_Name_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_News`( In Docs_ Json,Document_value_ int)
Begin
declare Image_  varchar(500); declare File_Name_  varchar(100);declare News_Document_Id_ int;
declare Description_  text; Declare i int default 0;

if( Document_value_>0) then
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.News_Document_Id')) INTO News_Document_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Image')) INTO Image_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.File_Name')) INTO File_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Description')) INTO Description_;
	if(News_Document_Id_>0)
	then
		if Image_<>'' && Image_<>'undefined' then
			UPDATE news_document set Image = Image_,
            File_Name=File_Name_
            Where News_Document_Id=News_Document_Id_ ;
		end if;
		UPDATE news_document set 
        Description = Description_
		Where News_Document_Id=News_Document_Id_ ;
	else
		insert into news_document(Entry_date,File_Name,Image,Description,DeleteStatus)
		values (now(),File_Name_,Image_,Description_,false);
        set News_Document_Id_ =(SELECT LAST_INSERT_ID());
	end if;
end if;

select News_Document_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Offerchasingdetails`( In Application_details_Id_ int,Login_User_ int,Offerletter_Type_Id_ int,Offerletter_Type_Name_ varchar(50),Conditions_ Json,Conditions_Value_ int)
Begin

declare Conditions_Id_ int;
declare Conditions_Name_ varchar(100);
 Declare i int default 0;

declare Application_details_History_Id_ int;declare Fees_Receipt_Id_ int;declare Fee_Receipt_Branch_ int;declare first_Receipt int;
Declare Target_ int;declare Registration_Branch_ int;declare Student_Registration_Id_ int;declare Registered_User_ varchar(100);
declare Registered_Branch_Name_ varchar(100);declare bph_approved_status_ int; declare Student_Id_ int;declare counsellor_id_ int;
declare From_User_Name_ varchar(200);declare Bph_Status_Name_ varchar(200);declare Notification_Id_ int;declare Notification_Count_ int;
declare Student_Name_ varchar(200);declare Notification_Type_Name_ varchar(20);declare To_User_ int;declare To_User_Name_ varchar(45);declare Entry_Type_ int;

 
SET Student_Id_=(select Student_Id  from application_details where Application_details_Id=Application_details_Id_ 
and DeleteStatus=false);
set counsellor_id_=(select Counsilor_User  from student where Student_Id=Student_Id_ and DeleteStatus=false);


if( Conditions_Value_>0) then
WHILE i < JSON_LENGTH(Conditions_) DO
	#SELECT JSON_UNQUOTE (JSON_EXTRACT(Conditions_,CONCAT('$[',i,'].Conditions_Id'))) INTO Conditions_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Conditions_,CONCAT('$[',i,'].Conditions_Name'))) INTO Conditions_Name_;
		insert into conditions (Conditions_Name,Application_details_Id,DeleteStatus)
		values(Conditions_Name_,Application_details_Id_,0);
	Update application_details set Offerletter_Type_Id=Offerletter_Type_Id_,Offerletter_Type_Name=Offerletter_Type_Name_
	where Application_details_Id = Application_details_Id_;
	set Application_details_History_Id_=(select max(Application_details_History_Id) from Application_details_History where Application_details_Id=Application_details_Id_ and Deletestatus=0);
	Update application_details_history set Offerletter_Type_Id=Offerletter_Type_Id_,Offerletter_Type_Name=Offerletter_Type_Name_
	where Application_details_History_Id = Application_details_History_Id_;
	SELECT i + 1 INTO i;      
END WHILE;
end if;
select Application_details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Pre_Admission`( In Student_Preadmission_Checklist_Master_Id_ int,
Student_Id_ int,User_Id_ int,Country_Id_ int,Checklist_Details json)
Begin 

declare Checklist_Id_ int;Declare j int default 0;

 if  Student_Preadmission_Checklist_Master_Id_>0
 THEN 
	 delete from student_preadmission_checklist_details where Student_Preadmission_Checklist_Master_Id=Student_Preadmission_Checklist_Master_Id_;
	 UPDATE Student_Preadmission_Checklist_Master set Student_Preadmission_Checklist_Master_Id = Student_Preadmission_Checklist_Master_Id_ 
	#Student_Id=Student_Id_
	 Where Student_Preadmission_Checklist_Master_Id = Student_Preadmission_Checklist_Master_Id_ ;
 ELSE 
	 SET Student_Preadmission_Checklist_Master_Id_ = (SELECT  COALESCE( MAX(Student_Preadmission_Checklist_Master_Id ),0)+1 FROM Student_Preadmission_Checklist_Master); 
	 INSERT INTO Student_Preadmission_Checklist_Master(Student_Preadmission_Checklist_Master_Id ,Student_Id,Entry_Date,
	 Country_Id,DeleteStatus)
	 values (Student_Preadmission_Checklist_Master_Id_ ,Student_Id_,now(),
	 Country_Id_,false );
 End If ;
 
 WHILE j < JSON_LENGTH(Checklist_Details) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Checklist_Details,CONCAT('$[',j,'].Checklist_Id'))) INTO Checklist_Id_;
        insert into Student_Preadmission_Checklist_Details (Student_Preadmission_Checklist_Master_Id,Checklist_Id,DeleteStatus)
        values(Student_Preadmission_Checklist_Master_Id_,Checklist_Id_,0);

SELECT j + 1 INTO j;      
END WHILE;
 select Student_Preadmission_Checklist_Master_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_pre_visa`( In Student_Checklist_Master_Id_ int,
Student_Id_ int,User_Id_ int,Country_Id_ int,Checklist_Details json)
Begin 

declare Checklist_Id_ int;Declare j int default 0;

 if  Student_Checklist_Master_Id_>0
 THEN 
	 delete from Student_Checklist_Details where Student_Checklist_Master_Id=Student_Checklist_Master_Id_;
	 UPDATE Student_Checklist_Master set Student_Checklist_Master_Id = Student_Checklist_Master_Id_ 
	#Student_Id=Student_Id_
	 Where Student_Checklist_Master_Id = Student_Checklist_Master_Id_ ;
 ELSE 
	 SET Student_Checklist_Master_Id_ = (SELECT  COALESCE( MAX(Student_Checklist_Master_Id ),0)+1 FROM Student_Checklist_Master); 
	 INSERT INTO Student_Checklist_Master(Student_Checklist_Master_Id ,Student_Id,Entry_Date,
	 Country_Id,DeleteStatus)
	 values (Student_Checklist_Master_Id_ ,Student_Id_,now(),
	 Country_Id_,false );
 End If ;
 
 WHILE j < JSON_LENGTH(Checklist_Details) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Checklist_Details,CONCAT('$[',j,'].Checklist_Id'))) INTO Checklist_Id_;
        insert into Student_Checklist_Details (Student_Checklist_Master_Id,Checklist_Id,DeleteStatus)
        values(Student_Checklist_Master_Id_,Checklist_Id_,0);

SELECT j + 1 INTO j;      
END WHILE;
 select Student_Checklist_Master_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Profile`( In  Student_Id_ int , Enquiry_Source_Id_ int , Enquiry_Source_Name_ varchar(100) , Enquiryfor_Id_ int ,
Enquirfor_Name_ varchar(45) , Shore_Id_ int , Shore_Name_ varchar(45) , Enquiry_Mode_Id_ int , Enquiry_Mode_Name_ varchar(45) , Program_Course_Id_ int ,
Program_Course_Name_ varchar(1000) , Country_Id_ int , Country_Name_ varchar(1000) , Marital_Status_Id_ int , Marital_Status_Name_ varchar(45) , Passport_Id_ int ,
       Address1_ varchar(200) , Address2_ varchar(200) , Alternative_Email_ varchar(100) , Alternative_Phone_Number_ varchar(45) , Date_of_Marriage_ varchar(45) , Dob_ varchar(45) , Dropbox_Link_ varchar(1000) ,
Email_ varchar(100) , No_of_Kids_and_Age_ varchar(45) , Passport_No_ varchar(45) , Passport_Todate_ date , Passport_fromdate_ date , Phone_Number_ varchar(25) , Previous_Visa_Rejection_ varchar(1000) ,

        Reference_ varchar(45) , Spouse_Name_ varchar(45) , Spouse_Occupation_ varchar(45) , Spouse_Qualification_ varchar(45) , Student_Name_ varchar(500) , Whatsapp_ varchar(45) ,
Branch_ int , Branch_Name_ varchar(50) , By_User_Id_ int , By_User_Name_ varchar(45) , Department_ int , Department_FollowUp_ int , Department_Name_ varchar(50) , Department_Status_Name_ varchar(50) , Next_FollowUp_Date_ datetime ,
Remark_ varchar(4000) , Remark_id_ int , Status_Id_ int , To_User_Name_ varchar(250) , To_User_Id_ int , Student_Status_Id_ int , Agent_Id_ int , Flag_Student_ int , Flag_Followup_ int ,
Phone_Change_ int , Email_Change_ int , Alternative_Email_Change_ int , Alternative_Phone_Number_Change_ int , Whatsapp_Change_ int , Department_Id_ int , Branch_Id_ int,Unique_Id_ varchar(200),Class_Id_ int,Class_Name_ varchar(200),
Guardian_telephone_ varchar(25),Counsilor_Note_ text,BPH_Note_ text,Pre_Visa_Note_ text,
Sub_Status_Id_ int,Sub_Status_Name_ varchar(100),Status_Type_Id_ int,Status_Type_Name_ varchar(45),Agent_Country_ JSON,Agent_Country_Value_ int)
Begin
declare Agent_Country_Id_ int;declare Agent_Country_Name_ varchar(100);
declare Duplicate_Student_Id int; declare Alternate_student_Id int; declare Whatsap_student_Id int;
declare Email_Alternate_student_Id int;
declare Email_student_Id int;
declare Duplicate_Student_Name varchar(500); declare Duplicate_User_Name varchar(500); declare Duplicate_User_Id int;
declare Duplicate_Department_Name varchar(50);declare Duplicate_Remark_Name varchar(2000);
declare Duplicate_Department_Id_ int;declare Duplicate_Remark_Id_ int;declare Duplicate_FollowUp_Date datetime;declare Call_From int;
declare Previous_Followup_Date_ datetime;
declare Client_Accounts_Id_ int;
declare Color_Name_ varchar(50);

declare closed_temp_user_ int;
declare telesales_temp_user_ int;
declare customersuccess_temp_user_ int;
declare accounts_temp_user_ int;
declare counsilor_temp_user_ int;
declare auditor_temp_user_ int;
declare admission_temp_user_ int;
declare preadmission_temp_user_ int;
declare previsa_temp_user_ int;
declare preapplication_temp_user_ int;
declare visa_temp_user_ int;
declare To_User_Department int;
declare application_temp_user_ int;


declare  Duplicate_Student_Id_Alternate_Phone int;
declare Duplicate_Student_Id_Whatsapp int;
declare To_String varchar(100);
 Declare i int default 0;
declare Role_Id_ int;declare Student_FollowUp_Id_ int;declare FollowUp_Difference_ int;
declare First_Followup_Status_ int;

declare Duplicate_Email_Name varchar(500);
declare FollowUp_Count int;declare FollowUp_EntryDate datetime;declare First_FollowUp_Date datetime;
declare Duplicate_Message_ text;declare Duplicate_type int;

declare Duplicate_Registration int;declare Duplicate_Welcome_Status int;
declare Department_Status int;
Declare j int default 0;
declare Created_User_ varchar(100);
 
declare Student_Checklist_Id_ int;declare Check_List_Id_ int;
declare Checklist_Status_ int;declare Description_ Varchar(150);

declare Dept_count_ int;
declare First_Time_Dept_ tinyint;
declare Login_Branch_ int;

declare Default_Department_Id_ int;declare Default_Department_Name_ varchar(250);
declare Default_User_Id_ int;declare Default_User_Name_ varchar(250);
DECLARE Default_Status_Id_ int;DECLARE Default_Status_Name_ varchar(250);
declare User_List_ TEXT;declare alltime_view_ int;declare User_List_1 TEXT;declare Same_User_ text;
declare Application_Exist_ int;
declare x int;
 set x=0;
 
set closed_temp_user_ =0;
set telesales_temp_user_ =0;
set customersuccess_temp_user_ =0;
set accounts_temp_user_ =0;
set counsilor_temp_user_ =0;
set auditor_temp_user_ =0;
set admission_temp_user_ =0;
set preadmission_temp_user_ =0;
set previsa_temp_user_ =0;
set preapplication_temp_user_ =0;
set visa_temp_user_ =0;
set To_User_Department =0;
set application_temp_user_=0; 
 
#declare Profile_University_Name_ varchar(1000);declare Program_Course_Name_ varchar(1000);declare Profile_Country_Name_ varchar(1000);
/*DECLARE exit handler for sqlexception
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;

    START TRANSACTION;*/
   
   
if(Country_Id_ =-1) then
SET Country_Id_ = (select COALESCE( MAX(Country_Id ),0) from country where Country_Name=Country_Name_);
    #insert into data_logs values(1,Country_Id_);
if(Country_Id_=0) then
SET Country_Id_ = (SELECT  COALESCE( MAX(Country_Id ),0)+1 FROM country);
insert into country values(Country_Id_,Country_Name_,0);  
end if;
end if;

  if(Program_Course_Id_ =-1)then
SET Program_Course_Id_ = (select COALESCE( MAX(Course_Id ),0) from course where Course_Name=Program_Course_Name_);  
if(Program_Course_Id_ =0)then
SET Program_Course_Id_ = (SELECT  COALESCE( MAX(Course_Id ),0)+1 FROM course);    
insert into course(Course_Id,Country_Id,Course_Name, Subject_Id,Duration_Id,Level_Id,Ielts_Minimum_Score,internship_Id,IELTS_Name,Sub_Section_Id,DeleteStatus)
values(Program_Course_Id_,Country_Id_,Program_Course_Name_,0,0,0,0,0,0,0,0);  
end if;
 end if;      
           
if( Flag_Student_>0) then

	set Phone_Number_=REPLACE(REPLACE(REPLACE(REPLACE(Phone_Number_, ' ', ''), '\t', ''), '\n', ''), '+', '');
	set Alternative_Phone_Number_=REPLACE(REPLACE(REPLACE(REPLACE(Alternative_Phone_Number_, ' ', ''), '\t', ''), '\n', ''), '+', '');
	set Whatsapp_=REPLACE(REPLACE(REPLACE(REPLACE(Whatsapp_, ' ', ''), '\t', ''), '\n', ''), '+', '');
	set Guardian_telephone_=REPLACE(REPLACE(REPLACE(REPLACE(Guardian_telephone_, ' ', ''), '\t', ''), '\n', ''), '+', '');

if  Student_Id_>0 THEN

    if Phone_Number_!="" then
    
		Set Duplicate_Student_Id =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Phone_Number like concat('%',Phone_Number_,'%')
		 )  limit 1);
        if Duplicate_Student_Id>0 then
			set To_String=" Phone ";
		else
			Set Duplicate_Student_Id =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Alternative_Phone_Number like concat('%',Phone_Number_,'%')
			 )  limit 1);
			if Duplicate_Student_Id>0 then
				set To_String=" Alternative ";
			else
				Set Duplicate_Student_Id =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Whatsapp like concat('%',Phone_Number_,'%')
				 )  limit 1);
				if Duplicate_Student_Id>0 then
					set To_String=" Whatsapp ";
				end if;
                
			end if;
        end if;
      end if;
      
 
 
 if Alternative_Phone_Number_!="" then
 
		Set Duplicate_Student_Id_Alternate_Phone =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Phone_Number like concat('%',Alternative_Phone_Number_,'%')
		 )  limit 1);
        if Duplicate_Student_Id_Alternate_Phone>0 then
			set To_String=" Phone number ";
		else
			Set Duplicate_Student_Id_Alternate_Phone =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Alternative_Phone_Number like concat('%',Alternative_Phone_Number_,'%')
			 )  limit 1);
			if Duplicate_Student_Id_Alternate_Phone>0 then
				set To_String=" Alternative Phone number ";
			else
				Set Duplicate_Student_Id_Alternate_Phone =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Whatsapp like concat('%',Alternative_Phone_Number_,'%')
				 )  limit 1);
				if Duplicate_Student_Id_Alternate_Phone>0 then
					set To_String=" Whatsapp ";
				end if;
			end if;
            
        end if;
      end if;
     
  if Whatsapp_!="" then
  
		Set Duplicate_Student_Id_Whatsapp =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Phone_Number like concat('%',Whatsapp_,'%')
		 )  limit 1);
        if Duplicate_Student_Id_Whatsapp>0 then
			set To_String=" Phone number ";
		else
			Set Duplicate_Student_Id_Whatsapp =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Alternative_Phone_Number like concat('%',Whatsapp_,'%')
			 )  limit 1);
			if Duplicate_Student_Id_Whatsapp>0 then
				set To_String=" Alternative Phone number ";
			else
				Set Duplicate_Student_Id_Whatsapp =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Whatsapp like concat('%',Whatsapp_,'%')
				 )  limit 1);
				if Duplicate_Student_Id_Whatsapp>0 then
					set To_String=" Whatsapp ";
				end if;
			end if;
            
        end if;
      end if;





	if Email_!="" then
		set Email_student_Id= ( select Student_Id from Student where Student_Id != Student_Id_  and DeleteStatus=false  and   ( Email = concat('',Email_,'') or Alternative_Email  = concat('',Email_,'') ) limit 1);
	end if;
	if Alternative_Email_!="" then
		set Email_Alternate_student_Id= (select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false  and   ( Alternative_Email = concat('',Alternative_Email_,'') or Email = concat('',Alternative_Email_,'') ) limit 1);
	end if;

   if(Duplicate_Student_Id>0) then
  set Duplicate_type=1; 
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Remark_Id_ = (select Remark_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;
set Duplicate_Message_= concat('The Phone Number ', Phone_Number_ , ' Already Exist as ', To_String ,' for ',Duplicate_Student_Name,' and is handled by ',Duplicate_User_Name,' ',(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y')),' Department is:',Duplicate_Department_Name,' and Remark is:',Duplicate_Remark_Name     ) ;  
 
 elseif(Duplicate_Student_Id_Alternate_Phone>0) then
 set Duplicate_type=1; 
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Duplicate_Remark_Id_ = (select Remark_Id from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;
set Duplicate_Message_= concat('The Alternate Phone Number ', Alternative_Phone_Number_ , ' Already Exist as ', To_String,' for ',Duplicate_Student_Name,' and is handled by ',Duplicate_User_Name,' ',(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y')),' Department is:',Duplicate_Department_Name,' and Remark is:',Duplicate_Remark_Name     ) ;   
   
   elseif(Duplicate_Student_Id_Whatsapp>0) then
   set Duplicate_type=1; 
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
 set Duplicate_Message_= concat('The Whatsapp ', Whatsapp_ , ' Already Exist as ', To_String,' for ',Duplicate_Student_Name,' and is handled by ',Duplicate_User_Name,' ',' Followup Date is:',(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y')),' Department is:',Duplicate_Department_Name,' and Remark is:',Duplicate_Remark_Name     ) ;  
SET Student_Id_ = -1;                

elseif(Email_student_Id>0) then
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;                
elseif(Email_Alternate_student_Id>0) then
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;
else


       
UPDATE Student set Agent_Id=Client_Accounts_Id_,Student_Name = Student_Name_,
Address1 = Address1_ ,Address2 = Address2_ ,Email = Email_ ,Alternative_Email = Alternative_Email_ ,Alternative_Phone_Number = Alternative_Phone_Number_ ,Phone_Number = Phone_Number_ ,
Dob = Dob_ ,Country_Name = Country_Name_ ,Student_Status_Id = Student_Status_Id_,Enquiry_Source_Id = Enquiry_Source_Id_,
Whatsapp = Whatsapp_ ,Programme_Course=Program_Course_Name_,Reference=Reference_,
Passport_No=Passport_No_,Passport_fromdate=Passport_fromdate_,Passport_Todate=Passport_Todate_,
Passport_Id=Passport_Id_,Enquiry_Source_Name = Enquiry_Source_Name_,Enquiryfor_Id=Enquiryfor_Id_,Enquirfor_Name=Enquirfor_Name_,
Marital_Status_Id=Marital_Status_Id_,Marital_Status_Name=Marital_Status_Name_,Enquiry_Mode_Id=Enquiry_Mode_Id_,Enquiry_Mode_Name=Enquiry_Mode_Name_,
        Spouse_Name=Spouse_Name_,No_of_Kids_and_Age=No_of_Kids_and_Age_,Date_of_Marriage=Date_of_Marriage_,Previous_Visa_Rejection=Previous_Visa_Rejection_,
        Spouse_Occupation=Spouse_Occupation_,Spouse_Qualification=Spouse_Qualification_,Dropbox_Link=Dropbox_Link_,
Program_Course_Id=Program_Course_Id_,Profile_Country_Id=Country_Id_,Shore_Id=Shore_Id_,Shore_Name=Shore_Name_,Agent_Id=Agent_Id_,Guardian_telephone=Guardian_telephone_,
Created_On=now(),Counsilor_Note=Counsilor_Note_,BPH_Note=BPH_Note_,Pre_Visa_Note=Pre_Visa_Note_,
Status_Type_Id=Status_Type_Id_,Status_Type_Name=Status_Type_Name_,Color=Color_Name_
Where Student_Id=Student_Id_ ;
end if;
ELSE
if Phone_Number_!="" then
		Set Duplicate_Student_Id =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Phone_Number like concat('%',Phone_Number_,'%')
		 )  limit 1);
        if Duplicate_Student_Id>0 then
			set To_String=" Phone number ";
		else
			Set Duplicate_Student_Id =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Alternative_Phone_Number like concat('%',Phone_Number_,'%')
			 )  limit 1);
			if Duplicate_Student_Id>0 then
				set To_String=" Alternative Phone number ";
			else
				Set Duplicate_Student_Id =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Whatsapp like concat('%',Phone_Number_,'%')
				 )  limit 1);
				if Duplicate_Student_Id>0 then
					set To_String=" Whatsapp ";
				end if;
			end if;
            
        end if;
      end if;
      
 
 
 if Alternative_Phone_Number_!="" then
		Set Duplicate_Student_Id_Alternate_Phone =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Phone_Number like concat('%',Alternative_Phone_Number_,'%')
		 )  limit 1);
        if Duplicate_Student_Id_Alternate_Phone>0 then
			set To_String=" Phone number ";
		else
			Set Duplicate_Student_Id_Alternate_Phone =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Alternative_Phone_Number like concat('%',Alternative_Phone_Number_,'%')
			 )  limit 1);
			if Duplicate_Student_Id_Alternate_Phone>0 then
				set To_String=" Alternative Phone number ";
			else
				Set Duplicate_Student_Id_Alternate_Phone =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Whatsapp like concat('%',Alternative_Phone_Number_,'%')
				 )  limit 1);
				if Duplicate_Student_Id_Alternate_Phone>0 then
					set To_String=" Whatsapp ";
				end if;
			end if;
            
        end if;
      end if;
 #insert into data_logs values(0,Duplicate_Student_Id_Alternate_Phone);     
  if Whatsapp_!="" then
		Set Duplicate_Student_Id_Whatsapp =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Phone_Number like concat('%',Whatsapp_,'%')
		 )  limit 1);
        if Duplicate_Student_Id_Whatsapp>0 then
			set To_String=" Phone number ";
		else
			Set Duplicate_Student_Id_Whatsapp =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Alternative_Phone_Number like concat('%',Whatsapp_,'%')
			 )  limit 1);
			if Duplicate_Student_Id_Whatsapp>0 then
				set To_String=" Alternate Phone Number ";
			else
				Set Duplicate_Student_Id_Whatsapp =(select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Whatsapp like concat('%',Whatsapp_,'%')
				 )  limit 1);
				if Duplicate_Student_Id_Whatsapp>0 then
					set To_String=" Whatsapp ";
				end if;
			end if;
            
        end if;
      end if;

#Set Duplicate_Welcome_Status=(select Send_Welcome_Mail_Status from Student where Student_Id= Duplicate_Student_Id and DeleteStatus=false);

if Email_!="" then
set Email_student_Id= ( select Student_Id from Student where  DeleteStatus=false and ( Email = concat('',Email_,'') or Alternative_Email  = concat('',Email_,'') ) limit 1);
end if;
if Alternative_Email_!="" then
	set Email_Alternate_student_Id= (select Student_Id from Student where  DeleteStatus=false and ( Alternative_Email = concat('',Alternative_Email_,'') or Email  = concat('',Alternative_Email_,'') ) limit 1);
end if;




    if(Duplicate_Student_Id>0) then
    set Duplicate_type=1;
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;
 set Duplicate_Message_= concat('The Phone Number ', Phone_Number_ , ' Already Exist as ', To_String ,' for ',Duplicate_Student_Name,' and is handled by ',Duplicate_User_Name,' ',(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y')),'Department is:',Duplicate_Department_Name,' and Remark is:',Duplicate_Remark_Name     ) ;  

elseif(Duplicate_Student_Id_Alternate_Phone>0) then
set Duplicate_type=1;
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id_Alternate_Phone and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
 set Duplicate_Message_= concat('The Alternate Phone Number ', Alternative_Phone_Number_ , ' Already Exist as ', To_String,' for ',Duplicate_Student_Name,' and is handled by ',Duplicate_User_Name,' ',(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y')),' Department is:',Duplicate_Department_Name,' and Remark is:',Duplicate_Remark_Name     ) ;  
SET Student_Id_ = -1;  

elseif(Duplicate_Student_Id_Whatsapp>0) then
set Duplicate_type=1;
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id_Whatsapp and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;
 set Duplicate_Message_= concat('The Whatsapp ', Whatsapp_ , ' Already Exist as ', To_String,' for ',Duplicate_Student_Name,' and is handled by ',Duplicate_User_Name,' ','Followup Date is:',(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y')),' Department is:',Duplicate_Department_Name,' and Remark is:',Duplicate_Remark_Name     ) ;                 

elseif(Email_student_Id>0) then
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;                
elseif(Email_Alternate_student_Id>0) then
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Followup_Department_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;
else  
   
   #insert into data_log_ value(10,Country_Id_,Country_Name_);

if Department_Id_ = 326 then
set closed_temp_user_= By_User_Id_;

elseif Department_Id_ = 343 then
set telesales_temp_user_=By_User_Id_;

elseif Department_Id_ = 329 then
set customersuccess_temp_user_=By_User_Id_;

elseif Department_Id_ = 318 then
set accounts_temp_user_=By_User_Id_;

elseif Department_Id_ = 323 then
set counsilor_temp_user_=By_User_Id_;

elseif Department_Id_ = 333 then
set auditor_temp_user_=By_User_Id_;

elseif Department_Id_ = 317 then
set admission_temp_user_=By_User_Id_;

elseif Department_Id_ = 330 then
set preadmission_temp_user_=By_User_Id_;

elseif Department_Id_ = 332 then
set previsa_temp_user_=By_User_Id_;

elseif Department_Id_ = 322 then
set visa_temp_user_=By_User_Id_;

elseif Department_Id_ = 339 then
set preapplication_temp_user_=By_User_Id_;

elseif Department_Id_ = 335 then
set application_temp_user_=By_User_Id_;
end if; 


set To_User_Department =(select Department_Id from user_details where User_Details_Id= To_User_Id_); 

if To_User_Department = 326 then
set closed_temp_user_= To_User_Id_;

elseif To_User_Department = 343 then
set telesales_temp_user_=To_User_Id_;

elseif To_User_Department = 329 then
set customersuccess_temp_user_=To_User_Id_;

elseif To_User_Department = 318 then
set accounts_temp_user_=To_User_Id_;

elseif To_User_Department = 323 then
set counsilor_temp_user_=To_User_Id_;

elseif To_User_Department = 333 then
set auditor_temp_user_=To_User_Id_;

elseif To_User_Department = 317 then
set admission_temp_user_=To_User_Id_;

elseif To_User_Department = 330 then
set preadmission_temp_user_=To_User_Id_;

elseif To_User_Department = 332 then
set previsa_temp_user_=To_User_Id_;

elseif To_User_Department = 322 then
set visa_temp_user_=To_User_Id_;

elseif To_User_Department = 339 then
set preapplication_temp_user_=To_User_Id_;

elseif To_User_Department = 335 then
set application_temp_user_=To_User_Id_;
end if; 

      
       
#SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.By_User_Id')) INTO Created_By_;
set Created_User_ =(select User_Details_Name from user_details where User_Details_Id= By_User_Id_);   
set Color_Name_=(select Color_Type_Name from department where Department_Id=Department_);   
SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student);
       
INSERT INTO Student(Student_Id , Agent_Id, Entry_Date,Student_Name ,Address1 ,Address2 ,Email ,Alternative_Email,Phone_Number,Alternative_Phone_Number ,Dob ,Country_Name ,
Student_Status_Id,Enquiry_Source_Id ,Created_By,
Whatsapp,
DeleteStatus,Is_Registered,FollowUp_Count,FollowUp_EntryDate,
Entry_Type,First_Followup_Status,First_Followup_Date,Programme_Course,Reference,
Passport_No,Passport_fromdate,Passport_Todate,Passport_Id,Enquiry_Source_Name,Created_User
,Marital_Status_Id,Marital_Status_Name,Program_Course_Id,Profile_Country_Id,Created_On,
Enquiryfor_Id,Enquirfor_Name,Shore_Id,Shore_Name,Spouse_Name,Date_of_Marriage,Spouse_Occupation,Spouse_Qualification,Dropbox_Link,
No_of_Kids_and_Age,Previous_Visa_Rejection,Enquiry_Mode_Id,Enquiry_Mode_Name,Branch_Id,Department_Id,
Visa_User,Pre_Visa_User,Pre_Admission_User,Admission_User,Applicaton_User,Counsilor_User,Refund_user,Cas_User,Visa_Rejection_User,Pre_Application_User,Bph_User,Closed_User,
Unique_Id,Class_Id,Class_Name,Guardian_telephone,Link_Send_By,Status_Student_Fill,Counsilor_Note,
BPH_Note,Pre_Visa_Note,Sub_Status_Id,Sub_Status_Name)

values (Student_Id_ ,Agent_Id_,now(),Student_Name_ ,Address1_ ,Address2_ ,Email_ ,Alternative_Email_,Phone_Number_ ,
Alternative_Phone_Number_,Dob_ ,
Country_Name_ ,Student_Status_Id_,Enquiry_Source_Id_ ,By_User_Id_,
Whatsapp_,false,0,0,now(),1,1,now(),Program_Course_Name_,Reference_,
Passport_No_,Passport_fromdate_,Passport_Todate_,Passport_Id_,Enquiry_Source_Name_,Created_User_,
Marital_Status_Id_,Marital_Status_Name_,Program_Course_Id_,Country_Id_,now(),
Enquiryfor_Id_,Enquirfor_Name_,Shore_Id_,Shore_Name_,Spouse_Name_,Date_of_Marriage_,Spouse_Occupation_,Spouse_Qualification_,Dropbox_Link_,
No_of_Kids_and_Age_,Previous_Visa_Rejection_,Enquiry_Mode_Id_,Enquiry_Mode_Name_,Branch_Id_,Department_Id_,
visa_temp_user_,previsa_temp_user_,preadmission_temp_user_,admission_temp_user_,application_temp_user_,counsilor_temp_user_,accounts_temp_user_,customersuccess_temp_user_,telesales_temp_user_,preapplication_temp_user_,auditor_temp_user_,closed_temp_user_,
Unique_Id_,Class_Id_,Class_Name_,Guardian_telephone_,0,0,Counsilor_Note_,BPH_Note_,Pre_Visa_Note_,
Sub_Status_Id_,Sub_Status_Name_);
end if;
End If ;
#else
#set Student_Id_=1;
end if;
#insert into data_log_ values(0,FollowUp_Value_,Student_Id_);
if( Flag_Followup_>0 && Student_Id_>0) then
        #set Duplicate_Student_Name= "";
set Role_Id_=(select Role_Id from user_details where User_Details_Id=To_User_Id_);
#set Remark_Name_=(Select Remarks_Name from remarks where Remarks_Id=Remark_Id_);
set Student_FollowUp_Id_ =(SELECT Student_FollowUp_Id from student where Student_Id =Student_Id_);
set Previous_Followup_Date_ =(SELECT Next_FollowUp_Date from student where Student_Id =Student_Id_);
set FollowUp_Difference_= DATEDIFF(Previous_Followup_Date_,now() );
set alltime_view_ = (select count(All_Time_Departments) from all_time_departments where User_Id = By_User_Id_);
if alltime_view_>0 then
	SET User_List_1 = (select User_List from student where Student_Id = Student_Id_);
   # set Same_User_ = (select Student_Id from student where  (('*',By_User_Id_,'*') not in (User_List_1)));
    #if ( Same_User_!='') then
		if User_List_1!='' then
			set  User_List_ =CONCAT(User_List_1,',*',By_User_Id_, '*') ;
		else
			set  User_List_ =CONCAT('*',By_User_Id_, '*') ;
		end if;
	#end if;
else 
	set  User_List_ = 0;
end if;

set Default_Department_Id_=(select Default_Department_Id from branch where Branch_Id=Branch_Id_);
set Default_Department_Name_=(select Default_Department_Name from branch where Branch_Id=Branch_Id_);
set Default_Status_Id_=(select Department_Status_Id from department where Department_Id=Default_Department_Id_);
set Default_Status_Name_=(select Department_Status_Name from department_status where Department_Status_Id=Default_Status_Id_);


set Status_Type_Id_=(select Status_Type_Id from department_status where Department_Status_Id=Status_Id_);
set Status_Type_Name_=(select Status_Type_Name from department_status where Department_Status_Id=Status_Id_);


set Dept_count_=(select count( IFNULL(Department,0)) from student_followup where 
Student_Id=Student_Id_ and Department=Department_);

if(Dept_count_>0) then
	set First_Time_Dept_ =0;
else
	set First_Time_Dept_=1;
end if;

update student_followup set Actual_FollowUp_Date=Now(), FollowUp_Difference=FollowUp_Difference_ where Student_FollowUp_Id= Student_FollowUp_Id_ ;
INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id ,Branch,Remark,Remark_Id,By_User_Id ,
DeleteStatus,FollowUP_Time,Actual_FollowUp_Date,Entry_Type,Branch_Name,UserName,ByUserName,
Dept_StatusName,Dept_Name,Student,FollowUp,Class_Id,Class_Name,
Sub_Status_Id,Sub_Status_Name,Status_Type_Id,Status_Type_Name,First_Time_Dept)
values (Student_Id_ ,Now(),Next_FollowUp_Date_,0,Department_ ,Status_Id_ ,To_User_Id_ ,Branch_,Remark_,Remark_Id_,By_User_Id_,false,Now(),Now(),1
,Branch_Name_,To_User_Name_,By_User_Name_,Department_Status_Name_,Department_Name_,Student_Name_,Department_FollowUp_,Class_Id_,Class_Name_,
Sub_Status_Id_,Sub_Status_Name_,Status_Type_Id_,Status_Type_Name_,First_Time_Dept_);


       
       
       
set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
        #insert into data_log_ values (0,Student_FollowUp_Id_,'');
set First_Followup_Status_=(select First_Followup_Status from Student where Student_Id = Student_Id_);
if First_Followup_Status_=0 then
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Followup_Department_Id = Department_ ,Status_Id = Status_Id_ ,
To_User_Id = To_User_Id_ ,By_User_Id=By_User_Id_,Next_FollowUp_Date = Next_FollowUp_Date_ ,Remark = Remark_  ,Remark_Id = Remark_Id_,
Followup_Branch_Id=Branch_,FollowUp_Count=x+1,First_Followup_Status=1,First_Followup_Date=now(),Followup_Department_Name = Department_Name_,FollowUp=Department_FollowUp_,Followup_Branch_Name = Branch_Name_,Department_Status_Name=Department_Status_Name_,To_User_Name=To_User_Name_,
            Role_Id=Role_Id_,By_UserName = By_User_Name_,Class_Id=Class_Id_,Class_Name=Class_Name_,Sub_Status_Id=Sub_Status_Id_,Sub_Status_Name=Sub_Status_Name_
,Status_Type_Id=Status_Type_Id_,Status_Type_Name=Status_Type_Name_,Color=Color_Name_,User_List = User_List_
where student.Student_Id=Student_Id_;
else
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Followup_Department_Id = Department_ ,Status_Id = Status_Id_ ,
To_User_Id = To_User_Id_ ,By_User_Id=By_User_Id_,Next_FollowUp_Date = Next_FollowUp_Date_ ,Remark = Remark_  ,Remark_Id = Remark_Id_,
Followup_Branch_Id=Branch_,FollowUp_Count=x+1,Followup_Department_Name = Department_Name_,FollowUp=Department_FollowUp_,Followup_Branch_Name = Branch_Name_,Department_Status_Name=Department_Status_Name_,To_User_Name=To_User_Name_,Role_Id=Role_Id_,
            By_UserName = By_User_Name_,Class_Id=Class_Id_,Class_Name=Class_Name_,Sub_Status_Id=Sub_Status_Id_,Sub_Status_Name=Sub_Status_Name_
            ,Status_Type_Id=Status_Type_Id_,Status_Type_Name=Status_Type_Name_,
            Color=Color_Name_,User_List = User_List_
where student.Student_Id=Student_Id_;
set Application_Exist_ =(select COALESCE( MAX(Student_Id ),0) as Student_Id from application_details where Student_Id = Student_Id_ and DeleteStatus=0);
	if Application_Exist_ > 0 then
		update application_details set To_User_Id = To_User_Id_ where Student_Id = Student_Id_;
	end if;
end if;
select Student_Id_,Duplicate_Student_Name,Duplicate_User_Name;
end if;


if( Agent_Country_Value_>0) then
WHILE i < JSON_LENGTH(Agent_Country_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Agent_Country_,CONCAT('$[',i,'].Agent_Country_Id'))) INTO Agent_Country_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Agent_Country_,CONCAT('$[',i,'].Agent_Country_Name'))) INTO Agent_Country_Name_;
INSERT INTO student_agent_country(Student_Id,Agent_Id,Agent_Country_Id,Agent_Country_Name,DeleteStatus)
values (Student_Id_,Enquiry_Source_Id_,Agent_Country_Id_,Agent_Country_Name_,false);
SELECT i + 1 INTO i;
END WHILE;
end if;
insert into data_log_ values(0,Agent_Country_Value_,'');

#commit;
select Student_Id_,Duplicate_Student_Id,Duplicate_Student_Name,Duplicate_User_Name,(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y ')) as Duplicate_FollowUp_Date,Duplicate_Department_Name,Duplicate_Remark_Name,Duplicate_Registration,Department_Status,Duplicate_type,Duplicate_Message_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Qualification`( In Qualification_Id_ int,
slno_ int,Student_id_ int,Credential_ varchar(500),MarkPer_ varchar(20),school_ varchar(500),
Fromyear_ varchar(25),Toyear_ varchar(25),result_ varchar(50),Field_ varchar(250),Backlog_History_ varchar(250),
Year_of_passing_ varchar(100))
Begin
if  Qualification_Id_>0
 THEN 
    UPDATE qualification set Qualification_Id = Qualification_Id_ ,
    slno = slno_ ,Student_id=Student_id_,Credential=Credential_,school=school_,
    MarkPer=MarkPer_,Fromyear=Fromyear_,Toyear=Toyear_,result=result_,Field=Field_,
    Backlog_History = Backlog_History_,Year_of_passing=Year_of_passing_
    Where Qualification_Id=Qualification_Id_ ;
    
 ELSE 
    SET Qualification_Id_ = (SELECT  COALESCE( MAX(Qualification_Id ),0)+1 FROM qualification); 
    SET slno_ = (SELECT  COALESCE( MAX(slno ),0)+1 FROM qualification); 
    INSERT INTO qualification(Qualification_Id ,slno,Student_id,Credential,MarkPer,school,
    Fromyear,Toyear,result,Field,Backlog_History,Year_of_passing,DeleteStatus ) 
    values (Qualification_Id_ ,slno_,Student_id_,Credential_,MarkPer_,school_,
    Fromyear_,Toyear_,result_,Field_,Backlog_History_,Year_of_passing_,false);
 End If ;
 select Qualification_Id_,Student_id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Qualification_Details`( In qualificationdetails_ json,
qualificationdetails_Value_ int)
Begin
declare Qualification_Id_ int;declare slno_ int;declare Student_id_ int;
declare Credential_ varchar(500);declare school_ varchar(500);declare MarkPer_ varchar(5);
declare Fromyear_ varchar(25);declare Toyear_ varchar(25);declare result_ varchar(50);
declare Field_ varchar(250);declare Backlog_History_ varchar(250);declare Year_of_passing_ varchar(100);


Declare i int default 0;

if( qualificationdetails_Value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Qualification_Id')) INTO Qualification_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.slno')) INTO slno_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Student_id')) INTO Student_id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Credential')) INTO Credential_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.school')) INTO school_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.MarkPer')) INTO MarkPer_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Fromyear')) INTO Fromyear_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Toyear')) INTO Toyear_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.result')) INTO result_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Field')) INTO Field_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Backlog_History')) INTO Backlog_History_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(qualificationdetails_,'$.Year_of_passing')) INTO Year_of_passing_;

if(Qualification_Id_>0) then
 UPDATE qualification set Qualification_Id = Qualification_Id_ ,
    slno = slno_ ,Student_id=Student_id_,Credential=Credential_,school=school_,
    MarkPer=MarkPer_,Fromyear=Fromyear_,Toyear=Toyear_,result=result_,Field=Field_,
    Backlog_History = Backlog_History_,Year_of_passing=Year_of_passing_
    Where Qualification_Id=Qualification_Id_ ;
 ELSE  
 SET Qualification_Id_ = (SELECT  COALESCE( MAX(Qualification_Id ),0)+1 FROM qualification); 
    SET slno_ = (SELECT  COALESCE( MAX(slno ),0)+1 FROM qualification); 
    INSERT INTO qualification(Qualification_Id ,slno,Student_id,Credential,MarkPer,school,
    Fromyear,Toyear,result,Field,Backlog_History,Year_of_passing,DeleteStatus ) 
    values (Qualification_Id_ ,slno_,Student_id_,Credential_,MarkPer_,school_,
    Fromyear_,Toyear_,result_,Field_,Backlog_History_,Year_of_passing_,false);
 end if;
 End If ;
#commit;
 select Qualification_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Receipt`( In Fees_Receipt_Id_ int, Fees_Id_ int,
  Entry_Date_ datetime,
  Amount_ int ,
  Description_ varchar(200),
  Student_Id_ int,
  User_Id_ int
  )
Begin 
declare Fee_Receipt_Branch_ int;declare Voucher_No_ int;
if  Fees_Receipt_Id_>0
		 THEN 
		 UPDATE fees_receipt set Fees_Receipt_Id = Fees_Receipt_Id_ ,
		 Fees_Id = Fees_Id_,
		 Entry_Date=Entry_Date_,
		 Amount=Amount_,
		 Description=Description_,
		 Student_Id=Student_Id_,
		 User_Id=User_Id_
		 Where Fees_Receipt_Id=Fees_Receipt_Id_ ;
 ELSE 
			set Fee_Receipt_Branch_=(select Branch_Id from user_details where User_Details_Id=User_Id_);
			SET Fees_Receipt_Id_ = (SELECT  COALESCE( MAX(Fees_Receipt_Id ),0)+1 FROM fees_receipt); 
            SET Voucher_No_ = (SELECT  COALESCE( MAX(Voucher_No ),0)+1 FROM fees_receipt); 
			INSERT INTO fees_receipt(Fees_Receipt_Id,Fees_Id ,
			Entry_Date,
			Amount,
			Description,
			Student_Id,
			User_Id,
            Actual_Entry_Date,
            Delete_Status,
            Fee_Receipt_Branch,
            Voucher_No
            ) 
            values (Fees_Receipt_Id_,Fees_Id_,Entry_Date_,Amount_,Description_,Student_Id_,User_Id_,now(),0,Fee_Receipt_Branch_,Voucher_No_);
            
            insert into transaction_history(Entry_date,User_Id,Student_Id,Description1,Description2,Description3,Transaction_type)
            values (Entry_date_,User_Id_,Student_Id_,Description_,Description_,Description_,0);
			
 end if;
  select Fees_Receipt_Id_;
 end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Refund_Request`( In Refund_Request_Id_ int,
Student_Id_ int,User_Id_ int,Fees_Receipt_Id_ int,Reason_ varchar(5000),Remark_ varchar(5000))
Begin 
declare To_User_ int;declare Student_Name_ varchar(45);declare  Status_Id_ int;declare Status_Name_ varchar(45);declare Remark_ varchar(500);declare Notification_Id_ int;
declare From_User_Name_ varchar(45);declare ToUser_Name_ varchar(45);
declare Notification_Count_ int;declare Notification_Type_Name_ varchar(45);declare  Entry_Type_ int;
  /*if  Refund_Request_Id_>0
 THEN 
insert into data_log_ values(0,'','1');
UPDATE refund_request set Refund_Request_Id = Refund_Request_Id_ ,
 Student_Id = Student_Id_,User_Id=User_Id_,Fees_Receipt_Id=Fees_Receipt_Id_,
 Reason=Reason_,Remark=Remark_
 Where Refund_Request_Id = Refund_Request_Id_ ;

 ELSE */
 SET Refund_Request_Id_ = (SELECT  COALESCE( MAX(Refund_Request_Id ),0)+1 FROM refund_request); 
 INSERT INTO refund_request(Refund_Request_Id ,Student_Id,User_Id,
 Fees_Receipt_Id,Reason,Remark,Entry_Date,Delete_Status) values (Refund_Request_Id_,Student_Id_,User_Id_,
 Fees_Receipt_Id_,Reason_,Remark_,now(),false );
 
 UPDATE fees_receipt set Refund_Request_Status=2,Fees_Receipt_Status=3,
  Refund_Requested_By=User_Id_,Refund_Requested_On=now() 
  Where Fees_Receipt_Id = Fees_Receipt_Id_ ;
 
  set To_User_ = 99;
if User_Id_ !=To_User_ then 
	set Student_Name_ =(select Student_Name from Student where Student_Id = Student_Id_ and DeleteStatus=false);
	set Status_Id_ =0;
	set Status_Name_ ='';
	set Entry_Type_ = 6;
	set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = User_Id_ and DeleteStatus=false); 
	set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false); 
	set Notification_Type_Name_ = 'Refund Request';
	SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
							values(Notification_Id_,User_Id_,From_User_Name_,To_User_,ToUser_Name_,Status_Id_,Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_; 
end if;
# End If ;
 select Refund_Request_Id_,Student_Name_,Notification_Type_Name_,From_User_Name_,To_User_,Entry_Type_,Notification_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Remarks`( In Remarks_Id_ int,
Remarks_Name_ varchar(50))
Begin 
 if  Remarks_Id_>0
 THEN 
 UPDATE Remarks set Remarks_Id = Remarks_Id_ ,
Remarks_Name = Remarks_Name_  Where Remarks_Id=Remarks_Id_ ;
 ELSE 
 SET Remarks_Id_ = (SELECT  COALESCE( MAX(Remarks_Id ),0)+1 FROM Remarks); 
 INSERT INTO Remarks(Remarks_Id ,
Remarks_Name,DeleteStatus ) values (Remarks_Id_ ,
Remarks_Name_,false );
 End If ;
 select Remarks_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Review`( In Review_Id_ int,
Facebook_ tinyint,Instagram_ tinyint,Gmail_ tinyint,User_Id_ int,Student_Id_ int,Facebook_Date_ datetime,Instagram_Date_ datetime,Google_Date_ datetime,
Checklist_ tinyint,Kit_ tinyint,Ticket_ tinyint,Accomodation_ tinyint,Airport_Pickup_ tinyint,Checklist_Date_ datetime,Kit_Date_ datetime,Ticket_Date_ datetime,Accomodation_Date_ datetime,Airport_Pickup_Date_ datetime)
Begin 

 if  Review_Id_>0
 THEN 
 UPDATE review set Review_Id = Review_Id_ ,
Facebook = Facebook_,Instagram=Instagram_,Gmail=Gmail_,
User_Id=User_Id_,Student_Id=Student_Id_,Facebook_Date=Facebook_Date_,Instagram_Date=Instagram_Date_,Google_Date=Google_Date_,
Checklist=Checklist_,Kit=Kit_,Ticket=Ticket_,Accomodation=Accomodation_,Airport_Pickup=Airport_Pickup_,Checklist_Date=Checklist_Date_,
Kit_Date=Kit_Date_,Ticket_Date=Ticket_Date_,Accomodation_Date=Accomodation_Date_,Airport_Pickup_Date=Airport_Pickup_Date_
 Where  Review_Id = Review_Id_ ;
 ELSE 
 
 SET Review_Id_ = (SELECT  COALESCE( MAX(Review_Id ),0)+1 FROM review); 
 INSERT INTO review(Review_Id,Facebook,Instagram,Gmail,User_Id,Student_Id,
 Entry_Date,DeleteStatus,Facebook_Date,Instagram_Date,Google_Date,Checklist,Kit,Ticket,Accomodation,Airport_Pickup,Checklist_Date,Kit_Date,Ticket_Date,Accomodation_Date,Airport_Pickup_Date) 
 values (Review_Id_,Facebook_,Instagram_,Gmail_,User_Id_,Student_Id_,now(),false,Facebook_Date_,Instagram_Date_,Google_Date_,Checklist_,Kit_,Ticket_,Accomodation_,Airport_Pickup_,Checklist_Date_,Kit_Date_,Ticket_Date_,Accomodation_Date_,Airport_Pickup_Date_);
 End If ;
 select Review_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Role_Department`(In UserRoleString varchar(100),Department_String varchar(4000),User_Details_Id_ int)
BEGIN
update user_details set Role_String = UserRoleString ,Department_String = Department_String where User_Details_Id = User_Details_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student`( In Student_ Json,Followup_ Json,Student_Value_ int,FollowUp_Value_ int
,student_document_ Json,student_document_Value_ int,student_List_ json,Student_Checklist_Value_ int
)
Begin
DECLARE Student_Id_ int;declare Client_Accounts_Id_ int;declare Student_Name_ varchar(500);declare Last_Name_ varchar(50);
declare Gender_ varchar(50);declare Address1_ varchar(200);declare Address2_ varchar(200);declare Pincode_ varchar(7);
declare Email_ varchar(100);declare Alternative_Email_ varchar(100);declare Phone_Number_ varchar(25);declare Alternative_Phone_Number_ varchar(45);declare Dob_ varchar(45);declare Country_Name_ varchar(1000);declare Promotional_Code_ varchar(50);
declare Student_Status_Id_ int;declare Password_ varchar(20);declare Passport_Copy_ varchar(100);declare IELTS_ varchar(100);declare Enquiry_Source_Id_ int;
declare Passport_Photo_ varchar(100);declare Tenth_Certificate_ varchar(100);declare Work_Experience_ varchar(100);
declare Resume_ varchar(100);declare Facebook_ varchar(45);declare Whatsapp_ varchar(45) ;
declare  File_Name_ varchar(500);declare Document_Name_ varchar(500); Declare i int default 0;
declare Passport_Copy_File_Name_ varchar(500);declare IELTS_File_Name_ varchar(500);declare Passport_Photo_File_Name_ varchar(500);
declare Tenth_Certificate_File_Name_ varchar(500) ;declare Work_Experience_File_Name_ varchar(500) ;declare Resume_File_Name_ varchar(500);
declare Document_File_Name_ varchar(500);declare Duplicate_Student_Id int;
declare Duplicate_Student_Name varchar(500); declare Duplicate_User_Name varchar(500); declare Duplicate_User_Id int;
declare Created_By_ int;declare Email_student_Id int;declare Email_Alternate_student_Id int;
declare Alternate_student_Id int;declare Whatsap_student_Id int;declare Duplicate_Email_Name varchar(500);
declare FollowUp_Count int;declare FollowUp_EntryDate datetime;declare First_FollowUp_Date datetime;
declare Visa_Submission_Date_ varchar(45);
declare Intake_ varchar(45);declare Reference_ varchar(45);declare Activity_ varchar(45);declare Course_Link_ varchar(45);
declare Year_ varchar(45);declare College_University_ varchar(1000);
declare Programme_Course_ varchar(1000);declare Agent_ varchar(45);declare Status_Details_ varchar(45);declare Student_Remark_ varchar(45);
declare Send_Welcome_Mail_Status varchar(45);
declare Duplicate_Department_Name varchar(50);declare Duplicate_Remark_Name varchar(2000);
declare Duplicate_Department_Id_ int;declare Duplicate_Remark_Id_ int;declare Duplicate_FollowUp_Date datetime;declare Call_From int;
declare Duplicate_Registration int;declare Duplicate_Welcome_Status int;
declare Department_Status int;
declare sslc_year_ varchar(45);declare sslc_institution_ varchar(500);declare sslc_markoverall_ varchar(45);declare sslc_englishmark_ varchar(45);
declare plustwo_year_ varchar(45);declare plustwo_institution_ varchar(500);declare plustwo_markoverall_ varchar(45);declare plustwo_englishmark_ varchar(45);
declare graduation_year_ varchar(45);declare graduation_institution_ varchar(500);declare graduation_markoverall_ varchar(45);declare graduation_englishmark_ varchar(45);
declare postgraduation_year_ varchar(45);declare postgraduation_institution_ varchar(500);declare postgraduation_markoverall_ varchar(45);
declare postgraduation_englishmark_ varchar(45);declare other_year_ varchar(45);declare other_instituation_ varchar(500);declare other_markoverall_ varchar(45);declare other_englishmark_ varchar(45);

declare exp_institution_1_ varchar(500);declare exp_institution_2_ varchar(500);declare exp_institution_3_ varchar(500);declare exp_institution_4_ varchar(500);declare exp_designation_1_ varchar(45);
declare exp_designation_2_ varchar(45);declare exp_designation_3_ varchar(45);declare exp_designation_4_ varchar(45);declare exp_tenure_from_1_ date;declare exp_tenure_from_2_ date;
declare exp_tenure_from_3_ date;declare exp_tenure_from_4_ date;declare exp_tenure_to_1_ date;declare exp_tenure_to_2_ date;declare exp_tenure_to_3_ date;
declare exp_tenure_to_4_ date;declare IELTS_Overall_ varchar(45);declare IELTS_Listening_ varchar(45);declare IELTS_Reading_ varchar(45);declare IELTS_Writting_ varchar(45);
declare IELTS_Speaking_ varchar(45);declare Passport_No_ varchar(45);declare Passport_fromdate_ date;declare Passport_Todate_ date;
declare LOR_1_Id_ int;declare LOR_2_Id_ int;declare MOI_Id_ int;declare SOP_Id_ int;declare Ielts_Id_ int;declare Passport_Id_ int;
declare Resume_Id_ int;Declare j int default 0;
declare Agent_Name_ varchar(150);declare Enquiry_Source_Name_ varchar(100);declare Created_User_ varchar(100);
 
declare Student_Checklist_Id_ int;declare Check_List_Id_ int;declare Applicable_ int;
declare Checklist_Status_ int;declare Description_ Varchar(150);
declare Marital_Status_Id_ int ;declare Marital_Status_Name_ Varchar(45);
declare Program_Course_Id_ int;declare Profile_University_Id_ int;declare Profile_Country_Id_ int;declare Created_On_ varchar(45);
declare Intake_Id_ int;declare Login_Branch_ int;
declare Enquiryfor_Id_ int;declare Enquirfor_Name_ Varchar(45);declare Shore_Id_ int;declare Shore_Name_ Varchar(45);
declare Spouse_Name_ Varchar(45); declare Date_of_Marriage_ date;declare Spouse_Occupation_ Varchar(45);declare Spouse_Qualification_ Varchar(45);
declare Dropbox_Link_ Varchar(45);declare No_of_Kids_and_Age_ Varchar(45);declare Previous_Visa_Rejection_ varchar(4000);

declare Status_Type_Id_ int;declare Status_Type_Name_ varchar(100);

#declare Profile_University_Name_ varchar(1000);declare Program_Course_Name_ varchar(1000);declare Profile_Country_Name_ varchar(1000);
/*DECLARE exit handler for sqlexception
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;

    START TRANSACTION;*/
   
    set Call_From=1;
if( Student_Value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Id')) INTO Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Agent_Id')) INTO Client_Accounts_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Name')) INTO Student_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Last_Name')) INTO Last_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Gender')) INTO Gender_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Address1')) INTO Address1_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Address2')) INTO Address2_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Pincode')) INTO Pincode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Email')) INTO Email_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Alternative_Email')) INTO Alternative_Email_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Phone_Number')) INTO Phone_Number_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Alternative_Phone_Number')) INTO Alternative_Phone_Number_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Dob')) INTO Dob_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Country_Name')) INTO Country_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Promotional_Code')) INTO Promotional_Code_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Status_Id')) INTO Student_Status_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Enquiry_Source_Id')) INTO Enquiry_Source_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Password')) INTO Password_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_Copy')) INTO Passport_Copy_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.IELTS')) INTO IELTS_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_Photo')) INTO Passport_Photo_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Tenth_Certificate')) INTO Tenth_Certificate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Work_Experience')) INTO Work_Experience_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Resume')) INTO Resume_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Whatsapp')) INTO Whatsapp_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Facebook')) INTO Facebook_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_Copy_File_Name')) INTO Passport_Copy_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.IELTS_File_Name')) INTO IELTS_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_Photo_File_Name')) INTO Passport_Photo_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Tenth_Certificate_File_Name')) INTO Tenth_Certificate_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Work_Experience_File_Name')) INTO Work_Experience_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Resume_File_Name')) INTO Resume_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.College_University')) INTO College_University_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Programme_Course')) INTO Programme_Course_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Intake')) INTO Intake_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Reference')) INTO Reference_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Visa_Submission_Date')) INTO Visa_Submission_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Activity')) INTO Activity_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Course_Link')) INTO Course_Link_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Year')) INTO Year_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Agent')) INTO Agent_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Status_Details')) INTO Status_Details_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Remark')) INTO Student_Remark_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.sslc_year')) INTO sslc_year_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.sslc_institution')) INTO sslc_institution_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.sslc_markoverall')) INTO sslc_markoverall_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.sslc_englishmark')) INTO sslc_englishmark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.plustwo_year')) INTO plustwo_year_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.plustwo_institution')) INTO plustwo_institution_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.plustwo_markoverall')) INTO plustwo_markoverall_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.plustwo_englishmark')) INTO plustwo_englishmark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.graduation_year')) INTO graduation_year_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.graduation_institution')) INTO graduation_institution_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.graduation_markoverall')) INTO graduation_markoverall_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.graduation_englishmark')) INTO graduation_englishmark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.postgraduation_year')) INTO postgraduation_year_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.postgraduation_institution')) INTO postgraduation_institution_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.postgraduation_markoverall')) INTO postgraduation_markoverall_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.postgraduation_englishmark')) INTO postgraduation_englishmark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.other_year')) INTO other_year_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.other_instituation')) INTO other_instituation_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.other_markoverall')) INTO other_markoverall_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.other_englishmark')) INTO other_englishmark_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_institution_1')) INTO exp_institution_1_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_institution_2')) INTO exp_institution_2_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_institution_3')) INTO exp_institution_3_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_institution_4')) INTO exp_institution_4_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_designation_1')) INTO exp_designation_1_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_designation_2')) INTO exp_designation_2_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_designation_3')) INTO exp_designation_3_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_designation_4')) INTO exp_designation_4_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_from_1')) INTO exp_tenure_from_1_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_from_2')) INTO exp_tenure_from_2_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_from_3')) INTO exp_tenure_from_3_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_from_4')) INTO exp_tenure_from_4_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_to_1')) INTO exp_tenure_to_1_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_to_2')) INTO exp_tenure_to_2_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_to_3')) INTO exp_tenure_to_3_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.exp_tenure_to_4')) INTO exp_tenure_to_4_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.IELTS_Overall')) INTO IELTS_Overall_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.IELTS_Listening')) INTO IELTS_Listening_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.IELTS_Reading')) INTO IELTS_Reading_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.IELTS_Writting')) INTO IELTS_Writting_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.IELTS_Speaking')) INTO IELTS_Speaking_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_No')) INTO Passport_No_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_fromdate')) INTO Passport_fromdate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_Todate')) INTO Passport_Todate_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.LOR_1_Id')) INTO LOR_1_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.LOR_2_Id')) INTO LOR_2_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.MOI_Id')) INTO MOI_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.SOP_Id')) INTO SOP_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Ielts_Id')) INTO Ielts_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_Id')) INTO Passport_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Resume_Id')) INTO Resume_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Marital_Status_Id')) INTO Marital_Status_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Marital_Status_Name')) INTO Marital_Status_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Program_Course_Id')) INTO Program_Course_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Profile_University_Id')) INTO Profile_University_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Profile_Country_Id')) INTO Profile_Country_Id_;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Created_On')) INTO Created_On_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Intake_Id')) INTO Intake_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Enquiry_Source_Name')) INTO Enquiry_Source_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Login_Branch')) INTO Login_Branch_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Enquiryfor_Id')) INTO Enquiryfor_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Enquirfor_Name')) INTO Enquirfor_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Shore_Id')) INTO Shore_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Shore_Name')) INTO Shore_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Spouse_Name')) INTO Spouse_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Date_of_Marriage')) INTO Date_of_Marriage_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Spouse_Occupation')) INTO Spouse_Occupation_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Spouse_Qualification')) INTO Spouse_Qualification_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Dropbox_Link')) INTO Dropbox_Link_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.No_of_Kids_and_Age')) INTO No_of_Kids_and_Age_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Previous_Visa_Rejection')) INTO Previous_Visa_Rejection_;
if(Profile_University_Id_ =-1)
then
SET Profile_University_Id_ = (SELECT  COALESCE( MAX(University_Id ),0)+1 FROM university);    
insert into university(University_Id,University_Name,DeleteStatus) values(Profile_University_Id_,College_University_,0);          
end if;  
if(Profile_Country_Id_ =-1)
then
SET Profile_Country_Id_ = (SELECT  COALESCE( MAX(Country_Id ),0)+1 FROM country);    
insert into country values(Profile_Country_Id_,Country_Name_,0);          
end if;
if(Program_Course_Id_ =-1)
then
set intake_Id_ =(select COALESCE( MAX(intake_Id ),0)  from intake where intake_Name=Intake_);
SET Program_Course_Id_ = (SELECT  COALESCE( MAX(Course_Id ),0)+1 FROM course);    
insert into course(Course_Id,Country_Id,University_Id,Course_Name,intake_Name, Subject_Id,Duration_Id,Level_Id,Ielts_Minimum_Score,internship_Id,IELTS_Name,Sub_Section_Id,DeleteStatus)
values(Program_Course_Id_,Profile_Country_Id_,Profile_University_Id_,Programme_Course_,Intake_,0,0,0,0,0,0,0,0);  
insert into course_intake(Course_Id,intake_Id,intake_Status) values(Program_Course_Id_,intake_Id_,1) ;  
end if;



set Agent_Name_ =(select Agent_Name from agent where Agent_Id = Client_Accounts_Id_ and DeleteStatus=0 );

if  Student_Id_>0 THEN

          Set Duplicate_Student_Id = (select Student_Id from Student where Student_Id != Student_Id_ and student.Branch = Login_Branch_ and DeleteStatus=false and (Phone_Number like concat('%',Phone_Number_,'%')
        or Alternative_Phone_Number like concat('%',Phone_Number_,'%') or Whatsapp  like concat('%',Phone_Number_,'%') )  limit 1);
         

        if Email_!="" then
set Email_student_Id= ( select Student_Id from Student where Student_Id != Student_Id_  and DeleteStatus=false  and   ( Email like concat('%',Email_,'%') or Alternative_Email  like concat('%',Email_,'%') ) limit 1);
        end if;
        if Alternative_Email_!="" then
        set Email_Alternate_student_Id= (select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false  and   ( Alternative_Email like concat('%',Alternative_Email_,'%') or Email  like concat('%',Alternative_Email_,'%') ) limit 1);
        end if;
         if Alternative_Phone_Number_!="" then
Set Alternate_student_Id = (select Student_Id from Student where  Student_Id != Student_Id_ and  student.Branch = Login_Branch_ and DeleteStatus=false  and  (Phone_Number like concat('%',Alternative_Phone_Number_,'%') or Alternative_Phone_Number like concat('%',Alternative_Phone_Number_,'%') or Whatsapp  like concat('%',Alternative_Phone_Number_,'%')) limit 1);
 end if;
         
     
       
if Whatsapp_!="" then
Set Whatsap_student_Id = (select Student_Id from Student where Student_Id != Student_Id_ and  student.Branch = Login_Branch_ and DeleteStatus=false  and   (Phone_Number like concat('%',Whatsapp_,'%') or Alternative_Phone_Number like concat('%',Whatsapp_,'%') or Whatsapp  like concat('%',Whatsapp_,'%')) limit 1);
end if;
        if(Duplicate_Student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Remark_Id_ = (select Remark_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;  
        elseif(Alternate_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Duplicate_Remark_Id_ = (select Remark_Id from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;  
        elseif(Whatsap_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;                
elseif(Email_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;                
elseif(Email_Alternate_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false);
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;
else
UPDATE Student set Agent_Id=Client_Accounts_Id_,Student_Name = Student_Name_ ,Last_Name = Last_Name_ ,Gender = Gender_ ,
Address1 = Address1_ ,Address2 = Address2_ ,Pincode = Pincode_ ,Email = Email_ ,Alternative_Email = Alternative_Email_ ,Alternative_Phone_Number = Alternative_Phone_Number_ ,Phone_Number = Phone_Number_ ,
Dob = Dob_ ,Country_Name = Country_Name_ ,Promotional_Code = Promotional_Code_ ,Student_Status_Id = Student_Status_Id_,Enquiry_Source_Id = Enquiry_Source_Id_,Password = Password_ ,
Resume=Resume_,Whatsapp = Whatsapp_ ,Facebook = Facebook_,College_University=College_University_,Programme_Course=Programme_Course_,Intake=Intake_,Year=Year_,Reference=Reference_,
Visa_Submission_Date=Visa_Submission_Date_,Activity=Activity_,Course_Link=Course_Link_,Agent=Agent_,Status_Details=Status_Details_,Student_Remark=Student_Remark_,
sslc_year = sslc_year_,sslc_institution = sslc_institution_,sslc_markoverall = sslc_markoverall_,sslc_englishmark = sslc_englishmark_,plustwo_year = plustwo_year_,
plustwo_institution =  plustwo_institution_,plustwo_markoverall = plustwo_markoverall_,plustwo_englishmark = plustwo_englishmark_,graduation_year = graduation_year_,
graduation_institution = graduation_institution_,graduation_markoverall = graduation_markoverall_,graduation_englishmark = graduation_englishmark_,
postgraduation_year = postgraduation_year_,postgraduation_institution = postgraduation_institution_,postgraduation_markoverall = postgraduation_markoverall_,
postgraduation_englishmark = postgraduation_englishmark_,other_year = other_year_,other_instituation = other_instituation_,other_markoverall = other_markoverall_,
other_englishmark = other_englishmark_,exp_institution_1 = exp_institution_1_,exp_institution_2  = exp_institution_2_,exp_institution_3 =exp_institution_3_,
exp_institution_4 = exp_institution_4_, exp_designation_1  =exp_designation_1_,exp_designation_2  = exp_designation_2_,exp_designation_3  = exp_designation_3_,
exp_designation_4  = exp_designation_4_,exp_tenure_from_1 = exp_tenure_from_1_,exp_tenure_from_2  = exp_tenure_from_2_,exp_tenure_from_3 = exp_tenure_from_3_,
exp_tenure_from_4 = exp_tenure_from_4_,exp_tenure_to_1  = exp_tenure_to_1_,exp_tenure_to_2 = exp_tenure_to_2_,exp_tenure_to_3  = exp_tenure_to_3_,exp_tenure_to_4   = exp_tenure_to_4_,
IELTS_Overall =IELTS_Overall_, IELTS_Listening  = IELTS_Listening_,IELTS_Reading = IELTS_Reading_,IELTS_Writting  = IELTS_Writting_,IELTS_Speaking = IELTS_Speaking_,
Passport_No=Passport_No_,Passport_fromdate=Passport_fromdate_,Passport_Todate=Passport_Todate_,LOR_1_Id=LOR_1_Id_,LOR_2_Id=LOR_2_Id_,MOI_Id=MOI_Id_,SOP_Id=SOP_Id_,Ielts_Id=Ielts_Id_,
Passport_Id=Passport_Id_,Resume_Id=Resume_Id_,Agent_Name=Agent_Name_,Enquiry_Source_Name = Enquiry_Source_Name_,
Marital_Status_Id=Marital_Status_Id_,Marital_Status_Name=Marital_Status_Name_,
Program_Course_Id=Program_Course_Id_,Profile_University_Id=Profile_University_Id_,Profile_Country_Id=Profile_Country_Id_,
Created_On=now(),Intake_Id=Intake_Id_

Where Student_Id=Student_Id_ ;
if Passport_Copy_!="" then
UPDATE Student set Passport_Copy=Passport_Copy_, Passport_Copy_File_Name=Passport_Copy_File_Name_ Where Student_Id=Student_Id_ ;
end if;
if Tenth_Certificate_!="" then
UPDATE Student set Tenth_Certificate=Tenth_Certificate_,Tenth_Certificate_File_Name = Tenth_Certificate_File_Name_ Where Student_Id=Student_Id_ ;
end if;
if Work_Experience_!="" then
UPDATE Student set Work_Experience=Work_Experience_ ,Work_Experience_File_Name = Work_Experience_File_Name_ Where Student_Id=Student_Id_ ;
end if;
if Passport_Photo_!="" then
UPDATE Student set Passport_Photo=Passport_Photo_,Passport_Photo_File_Name = Passport_Photo_File_Name_ Where Student_Id=Student_Id_ ;
end if;
if IELTS_!="" then
UPDATE Student set IELTS=IELTS_,IELTS_File_Name = IELTS_File_Name_ Where Student_Id=Student_Id_ ;
end if;
if Resume_!="" then
UPDATE Student set  Resume=Resume_, Resume_File_Name = Resume_File_Name_ Where Student_Id=Student_Id_ ;
end if;
end if;
ELSE
Set Duplicate_Student_Id = (select Student_Id from Student where  DeleteStatus=false and student.Branch = Login_Branch_ and (Phone_Number like concat('%',Phone_Number_,'%')
        or Alternative_Phone_Number like concat('%',Phone_Number_,'%') or Whatsapp  like concat('%',Phone_Number_,'%') )  limit 1);
        Set Duplicate_Registration=(select Is_Registered from Student where Student_Id= Duplicate_Student_Id and DeleteStatus=false);
Set Duplicate_Welcome_Status=(select Send_Welcome_Mail_Status from Student where Student_Id= Duplicate_Student_Id and DeleteStatus=false);
if Email_!="" then
set Email_student_Id= ( select Student_Id from Student where  DeleteStatus=false and ( Email like concat('%',Email_,'%') or Alternative_Email  like concat('%',Email_,'%') ) limit 1);
        end if;
        if Alternative_Email_!="" then
        set Email_Alternate_student_Id= (select Student_Id from Student where  DeleteStatus=false and ( Alternative_Email like concat('%',Alternative_Email_,'%') or Email  like concat('%',Alternative_Email_,'%') ) limit 1);
        end if;
         if Alternative_Phone_Number_!="" then
Set Alternate_student_Id = (select Student_Id from Student where  DeleteStatus=false and student.Branch = Login_Branch_ and (Phone_Number like concat('%',Alternative_Phone_Number_,'%') or Alternative_Phone_Number like concat('%',Alternative_Phone_Number_,'%') or Whatsapp  like concat('%',Alternative_Phone_Number_,'%')) limit 1);
 end if;

       if Whatsapp_!="" then
Set Whatsap_student_Id = (select Student_Id from Student where  DeleteStatus=false and student.Branch = Login_Branch_ and  (Phone_Number like concat('%',Whatsapp_,'%') or Alternative_Phone_Number like concat('%',Whatsapp_,'%') or Whatsapp  like concat('%',Whatsapp_,'%')) limit 1);
end if;
       
         if(Duplicate_Student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;  
        elseif(Alternate_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Alternate_student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Alternate_student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Alternate_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;  
        elseif(Whatsap_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -1;                
elseif(Email_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;                
elseif(Email_Alternate_student_Id>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false );
set Duplicate_Department_Id_ = (select Department from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_FollowUp_Date = (select Next_FollowUp_date from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false );
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id and DeleteStatus=false );
set Duplicate_Department_Name=(select Department_Name from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
set Duplicate_Remark_Name=(select Remark from student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
set Department_Status=(select FollowUp from department where Department_Id = Duplicate_Department_Id_ and Is_Delete=false);
SET Student_Id_ = -2;
else
        SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.By_User_Id')) INTO Created_By_;
        set Created_User_ =(select User_Details_Name from user_details where User_Details_Id= Created_By_);
       
SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student);
INSERT INTO Student(Student_Id , Agent_Id, Entry_Date,Student_Name ,Last_Name ,Gender ,Address1 ,Address2 ,Pincode ,Email ,Alternative_Email,Phone_Number,Alternative_Phone_Number ,Dob ,Country_Name ,
Promotional_Code ,Student_Status_Id,Enquiry_Source_Id ,Password,Created_By,
Passport_Copy,IELTS,Passport_Photo,Tenth_Certificate, Work_Experience,Resume,Whatsapp,Facebook,
Passport_Copy_File_Name,IELTS_File_Name, Passport_Photo_File_Name,Tenth_Certificate_File_Name,Work_Experience_File_Name,Resume_File_Name,DeleteStatus,Is_Registered,FollowUp_Count,FollowUp_EntryDate,
Entry_Type,First_Followup_Status,First_Followup_Date,College_University,Programme_Course,Intake,Year,Reference,Visa_Submission_Date,Activity,Course_Link,Agent,Status_Details,Student_Remark,Send_Welcome_Mail_Status,
sslc_year,sslc_institution,sslc_markoverall,sslc_englishmark,plustwo_year,plustwo_institution,plustwo_markoverall,plustwo_englishmark,graduation_year,graduation_institution,
graduation_markoverall,graduation_englishmark,postgraduation_year,postgraduation_institution,postgraduation_markoverall,postgraduation_englishmark,other_year,other_instituation,
other_markoverall,other_englishmark,exp_institution_1,exp_institution_2,exp_institution_3,exp_institution_4,exp_designation_1,exp_designation_2,exp_designation_3,exp_designation_4,
exp_tenure_from_1,exp_tenure_from_2,exp_tenure_from_3,exp_tenure_from_4,exp_tenure_to_1,exp_tenure_to_2,exp_tenure_to_3,exp_tenure_to_4,IELTS_Overall,IELTS_Listening,
IELTS_Reading,IELTS_Writting,IELTS_Speaking,Passport_No,Passport_fromdate,Passport_Todate,LOR_1_Id, LOR_2_Id ,MOI_Id,SOP_Id,Ielts_Id,Passport_Id,Resume_Id,Agent_Name,Enquiry_Source_Name,Created_User
,Marital_Status_Id,Marital_Status_Name,Program_Course_Id,Profile_University_Id,Profile_Country_Id,Created_On,Intake_Id,
Enquiryfor_Id,Enquirfor_Name,Shore_Id,Shore_Name,Spouse_Name,Date_of_Marriage,Spouse_Occupation,Spouse_Qualification,Dropbox_Link,
No_of_Kids_and_Age,Previous_Visa_Rejection)
values (Student_Id_ ,Client_Accounts_Id_,now(),Student_Name_ ,Last_Name_ ,Gender_ ,Address1_ ,Address2_ ,Pincode_ ,Email_ ,Alternative_Email_,Phone_Number_ ,
Alternative_Phone_Number_,Dob_ ,
Country_Name_ ,Promotional_Code_ ,Student_Status_Id_,Enquiry_Source_Id_ ,Password_,Created_By_,
Passport_Copy_,IELTS_,Passport_Photo_,Tenth_Certificate_, Work_Experience_,Resume_,Whatsapp_,Facebook_,Passport_Copy_File_Name_,IELTS_File_Name_,
Passport_Photo_File_Name_,Tenth_Certificate_File_Name_,Work_Experience_File_Name_,Resume_File_Name_,
  false,0,0,now(),1,1,now(),College_University_,Programme_Course_,Intake_,Year_,Reference_,Visa_Submission_Date_,Activity_,Course_Link_,Agent_,Status_Details_,Student_Remark_,0,
  sslc_year_,sslc_institution_,sslc_markoverall_,sslc_englishmark_,plustwo_year_,plustwo_institution_,plustwo_markoverall_,plustwo_englishmark_,graduation_year_,
  graduation_institution_,graduation_markoverall_,graduation_englishmark_,postgraduation_year_,postgraduation_institution_,postgraduation_markoverall_,postgraduation_englishmark_,
  other_year_,other_instituation_,other_markoverall_,other_englishmark_,
  exp_institution_1_,exp_institution_2_,exp_institution_3_,exp_institution_4_,exp_designation_1_,exp_designation_2_,exp_designation_3_,exp_designation_4_,
exp_tenure_from_1_,exp_tenure_from_2_,exp_tenure_from_3_,exp_tenure_from_4_,exp_tenure_to_1_,exp_tenure_to_2_,exp_tenure_to_3_,exp_tenure_to_4_,IELTS_Overall_,IELTS_Listening_,
IELTS_Reading_,IELTS_Writting_,IELTS_Speaking_,Passport_No_,Passport_fromdate_,Passport_Todate_,LOR_1_Id_,LOR_2_Id_,MOI_Id_,SOP_Id_,Ielts_Id_,Passport_Id_,Resume_Id_,Agent_Name_,Enquiry_Source_Name_,Created_User_,
Marital_Status_Id_,Marital_Status_Name_,Program_Course_Id_,Profile_University_Id_,Profile_Country_Id_,now(),Intake_Id_,
Enquiryfor_Id_,Enquirfor_Name_,Shore_Id_,Shore_Name_,Spouse_Name_,Date_of_Marriage_,Spouse_Occupation_,Spouse_Qualification_,Dropbox_Link_,
No_of_Kids_and_Age_,Previous_Visa_Rejection_);
end if;
End If ;
 if( student_document_Value_>0) then
WHILE i < JSON_LENGTH(student_document_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(student_document_,CONCAT('$[',i,'].File_Name'))) INTO File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(student_document_,CONCAT('$[',i,'].Document_Name'))) INTO Document_Name_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(student_document_,CONCAT('$[',i,'].Document_File_Name'))) INTO Document_File_Name_;
        insert into student_document (Student_Id,File_Name,Document_Name,Document_File_Name,DeleteStatus) values(Student_Id_,File_Name_,Document_Name_,Document_File_Name_,0);
SELECT i + 1 INTO i;      
END WHILE;
 end if;
 
  if( Student_Checklist_Value_>0) then
WHILE j < JSON_LENGTH(student_List_) DO
#SELECT JSON_UNQUOTE (JSON_EXTRACT(student_List_,CONCAT('$[',i,'].Student_Checklist_Id'))) INTO Student_Checklist_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(student_List_,CONCAT('$[',j,'].Check_List_Id'))) INTO Check_List_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(student_List_,CONCAT('$[',j,'].Applicable'))) INTO Applicable_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(student_List_,CONCAT('$[',j,'].Checklist_Status'))) INTO Checklist_Status_;
        insert into student_checklist (Student_Checklist_Id,Check_List_Id,
        Student_Id,Applicable,Checklist_Status,Description,DeleteStatus)
        values(Student_Checklist_Id_,Check_List_Id_,
        Student_Id_,Applicable_,Checklist_Status_,Description_,0);
SELECT j + 1 INTO j;      
END WHILE;
 end if;
 
 else
set Student_Id_=1;
 end if;
 #insert into data_log_ values(0,FollowUp_Value_,Student_Id_);
 if( FollowUp_Value_>0 && Student_Id_>0)
then
        #set Duplicate_Student_Name= "";
        CALL Save_Student_FollowUp(FollowUp_,Student_Id_);
end if;
#commit;
 select Student_Id_,Duplicate_Student_Id,Duplicate_Student_Name,Duplicate_User_Name,(Date_Format(Duplicate_FollowUp_Date,'%d-%m-%Y ')) as Duplicate_FollowUp_Date,Duplicate_Department_Name,Duplicate_Remark_Name,Duplicate_Registration,Duplicate_Welcome_Status,Department_Status;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student1`( In
 Student_Id_ int,
 Client_Accounts_Id_ int,
Student_Name_ varchar(50),
Last_Name_ varchar(50),
Gender_ varchar(50),
Address1_ varchar(50),
Address2_ varchar(50),
Pincode_ varchar(7),
Email_ varchar(100),
Phone_Number_ varchar(25),
Dob_ date,
Country_ int,
Promotional_Code_ varchar(50),
Student_Status_Id_ int,
Password_ varchar(20))
Begin 
 if  Student_Id_>0
 THEN 
 UPDATE Student set Student_Id = Student_Id_ ,
Agent_Id=Client_Accounts_Id_,
Student_Name = Student_Name_ ,
Last_Name = Last_Name_ ,
Gender = Gender_ ,
Address1 = Address1_ ,
Address2 = Address2_ ,
Pincode = Pincode_ ,
Email = Email_ ,
Phone_Number = Phone_Number_ ,
Dob = Dob_ ,
Country = Country_ ,
Promotional_Code = Promotional_Code_ ,
Student_Status_Id = Student_Status_Id_ ,
Password = Password_  Where Student_Id=Student_Id_ ;
 ELSE 
 SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student); 
 INSERT INTO Student(Student_Id ,
 Agent_Id,
 Entry_Date,
Student_Name ,
Last_Name ,
Gender ,
Address1 ,
Address2 ,
Pincode ,
Email ,
Phone_Number ,
Dob ,
Country ,
Promotional_Code ,
Student_Status_Id ,
Password,DeleteStatus ) values (Student_Id_ ,
Client_Accounts_Id_,
now(),
Student_Name_ ,
Last_Name_ ,
Gender_ ,
Address1_ ,
Address2_ ,
Pincode_ ,
Email_ ,
Phone_Number_ ,
Dob_ ,
Country_ ,
Promotional_Code_ ,
Student_Status_Id_ ,
Password_,false );
 End If ;
 select Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Course`( In Student_Course_Apply_Id_ int,
Student_Id_ int,Course_Apply JSON,User_Id_ int)
BEGIN
DECLARE Course_Id_ int;declare Course_Branch_ int;
DECLARE i int  DEFAULT 0;
/*DECLARE exit handler for sqlexception
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
   
if  Student_Course_Apply_Id_>0
THEN
delete from student_course_selection where Student_Course_Apply_Id=Student_Course_Apply_Id_;
UPDATE student_course_apply set Student_Id = Student_Id_
Where Student_Course_Apply_Id=Student_Course_Apply_Id_ ;
ELSE
SET Student_Course_Apply_Id_ = (SELECT  COALESCE( MAX(Student_Course_Apply_Id ),0)+1 FROM student_course_apply);
INSERT INTO student_course_apply(Student_Course_Apply_Id ,Student_Id ,Entry_Date ,Status_Id,Paid_On,Total_Course ,User_Id)
values (Student_Course_Apply_Id_ ,Student_Id_ ,now() ,1,Curdate(),JSON_LENGTH(Course_Apply),User_Id_);
End If ;
 
 WHILE i < JSON_LENGTH(Course_Apply) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Apply,CONCAT('$[',i,'].Course_Id'))) INTO Course_Id_;
INSERT INTO student_course_selection(Course_Id,Student_Course_Apply_Id )
values (Course_Id_ ,Student_Course_Apply_Id_);

SELECT i + 1 INTO i;
END WHILE;  
 # COMMIT;
select student_course_selection.Student_Course_Apply_Id,Course_Name,student.Email,Student_Name,
 University_Name,Country.Country_Name,Subject_Name,Tution_Fees,Application_Fees,Entry_Requirement,
 Course.Work_Experience,Level_Detail_Name,Duration_Name,intake_Name,ielts.Ielts_Name,Details,Living_Expense,Notes,Course.Registration_Fees,
 Course.Date_Charges,Course.Bank_Statements,Course.Insurance,Course.VFS_Charges,Course.Apostille,Course.Other_Charges
 from student_course_apply
inner join student_course_selection on student_course_selection.Student_Course_Apply_Id=student_course_apply.Student_Course_Apply_Id
inner join student on student.Student_Id=student_course_apply.Student_Id
inner join Course on course.Course_Id=student_course_selection.Course_Id
inner join University on course.University_Id=University.University_Id
inner join Country on course.Country_Id=Country.Country_Id
inner join level_detail on course.Level_Id=level_detail.Level_Detail_Id
inner join duration on course.Duration_Id=duration.Duration_Id
inner join ielts on course.Ielts_Minimum_Score=ielts.Ielts_Id
inner join subject on course.Subject_Id=subject.Subject_Id
where student_course_selection.Student_Course_Apply_Id=Student_Course_Apply_Id_;


 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Document`( In Docs_ Json,Document_value_ int)
Begin
DECLARE Student_Id_ int;declare Image_  varchar(500); declare File_Name_  varchar(100);declare Student_Document_Id_ int;
declare Description_  text; Declare i int default 0;DECLARE Document_Id_ int;declare Document_Name_  varchar(100); 

if( Document_value_>0) then
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Student_Document_Id')) INTO Student_Document_Id_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Student_Id')) INTO Student_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Image')) INTO Image_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.File_Name')) INTO File_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Description')) INTO Description_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Document_Id')) INTO Document_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Document_Name')) INTO Document_Name_;
	#delete from student_document where Student_Id = Student_Id_;
	if(Student_Document_Id_>0)
	then
		if Image_<>'' && Image_<>'undefined' then
			UPDATE student_document set Image = Image_ Where Student_Document_Id=Student_Document_Id_ ;
		end if;
		UPDATE student_document set Student_Id = Student_Id_ ,Document_Id = Document_Id_,Document_Name = Document_Name_,Description = Description_
		Where Student_Document_Id=Student_Document_Id_ ;
	else
		insert into student_document(Student_Id,Entry_date,File_Name,Document_Id,Document_Name,Image,Description,DeleteStatus)
		values (Student_Id_ ,now(),File_Name_,Document_Id_,Document_Name_,Image_,Description_,false);
	end if;
end if;
select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_FollowUp`( In FollowUp_ JSON,Student_Id_ int)
Begin 
declare Student_FollowUp_Id_ int;declare Department_ int;declare Status_ int;
declare User_Id_ int;declare By_User_Id_ int;declare Next_FollowUp_Date_ datetime;declare Remark_Id_ int;
declare Remark_ varchar(4000);declare Branch_ int;declare Stage_ int;declare Entry_Date_ datetime;
declare FollowUp_Difference_ int;declare Student_Id_J int;declare FollowUP_Time_ datetime;
declare Previous_Followup_Date_ datetime; declare FollowUp_Count_ int;
declare Department_Name_ varchar(50);declare Dept_FollowUp_ int;declare Branch_Name_ varchar(50);declare Client_Accounts_Name_ varchar(500);
declare Department_Status_Name_ varchar(50);declare User_Details_Name_ varchar(250);declare Role_Id_ int;
declare By_User_Name_ varchar(100);declare Student_n varchar(100);declare Created_User_ varchar(100);declare Remark_Name_ varchar(200);
declare Status_Type_Id_ int;declare Status_Type_Name_ varchar(100);

declare x int;
declare First_Followup_Status_ int;
 declare Duplicate_Student_Name varchar(25); declare Duplicate_User_Name varchar(25);
 set x=0;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Student_Id')) INTO Student_Id_J;   
	if( Student_Id_J>0 )
		then set Student_Id_=Student_Id_J;
	end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Next_FollowUp_Date')) INTO Next_FollowUp_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Department')) INTO Department_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Status')) INTO Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.User_Id')) INTO User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Branch')) INTO Branch_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Remark')) INTO Remark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Remark_id')) INTO Remark_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.By_User_Id')) INTO By_User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Department_Name')) INTO Department_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Department_FollowUp')) INTO Dept_FollowUp_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Branch_Name')) INTO Branch_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Department_Status_Name')) INTO Department_Status_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Status_Type_Id')) INTO Status_Type_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Status_Type_Name')) INTO Status_Type_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.User_Details_Name')) INTO User_Details_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.By_User_Name')) INTO By_User_Name_;


set Role_Id_=(select Role_Id from user_details where User_Details_Id=User_Id_);

#set Remark_Name_=(Select Remarks_Name from remarks where Remarks_Id=Remark_Id_);
set Student_FollowUp_Id_ =(SELECT Student_FollowUp_Id from student where Student_Id =Student_Id_);
set Previous_Followup_Date_ =(SELECT Next_FollowUp_Date from student where Student_Id =Student_Id_);
set FollowUp_Difference_= DATEDIFF(Previous_Followup_Date_,now() );
update student_followup set Actual_FollowUp_Date=Now(), FollowUp_Difference=FollowUp_Difference_ where Student_FollowUp_Id= Student_FollowUp_Id_ ; 

 INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id ,Branch,Remark,Remark_Id,By_User_Id,FollowUp_Type ,
 DeleteStatus,FollowUP_Time,Actual_FollowUp_Date,Entry_Type,Branch_Name,UserName,ByUserName,Dept_StatusName,Dept_Name,Student,FollowUp,Status_Type_Id,Status_Type_Name) 
values (Student_Id_ ,Now(),Next_FollowUp_Date_,0,Department_ ,Status_ ,User_Id_ ,Branch_,Remark_,Remark_Id_,By_User_Id_,1,false,Now(),Now(),1,
Branch_Name_,User_Details_Name_,By_User_Name_,Department_Status_Name_,Department_Name_,Student_n,Dept_FollowUp_,Status_Type_Id_,Status_Type_Name_);

set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
set First_Followup_Status_=(select First_Followup_Status from Student where Student_Id = Student_Id_);
if First_Followup_Status_=0 then
	Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Department = Department_ ,Status = Status_ ,
	User_Id = User_Id_ ,By_User_Id=By_User_Id_,Next_FollowUp_Date = Next_FollowUp_Date_ ,Remark = Remark_  ,Remark_Id = Remark_Id_,
	Branch=Branch_,FollowUp_Count=x+1,First_Followup_Status=1,First_Followup_Date=now(),Department_Name = Department_Name_,
    FollowUp=Dept_FollowUp_,Branch_Name = Branch_Name_,Department_Status_Name=Department_Status_Name_,
    User_Details_Name=User_Details_Name_,Role_Id=Role_Id_,By_UserName = By_User_Name_,
    Status_Type_Id=Status_Type_Id_,Status_Type_Name=Status_Type_Name_
	
    where student.Student_Id=Student_Id_;
else
	Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Department = Department_ ,Status = Status_ ,
	User_Id = User_Id_ ,By_User_Id=By_User_Id_,Next_FollowUp_Date = Next_FollowUp_Date_ ,Remark = Remark_  ,Remark_Id = Remark_Id_,
	Branch=Branch_,FollowUp_Count=x+1,Department_Name = Department_Name_,FollowUp=Dept_FollowUp_,
    Branch_Name = Branch_Name_,Department_Status_Name=Department_Status_Name_,User_Details_Name=User_Details_Name_,
    Role_Id=Role_Id_,By_UserName = By_User_Name_
    ,Status_Type_Id=Status_Type_Id_,Status_Type_Name=Status_Type_Name_
	where student.Student_Id=Student_Id_;
end if;
 select Student_Id_,Duplicate_Student_Name,Duplicate_User_Name;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Import`( In Student_Details json,By_User_Id_ int,Branch_ int,Department_ int,Status_ int,To_User_ int,
Enquiry_Source_ int,Next_FollowUp_Date_ datetime,Login_Branch_ int)
Begin
Declare i int;DECLARE Student_Id_ int;
Declare intake_temp1_ varchar(100);Declare intake_temp2_ varchar(100);Declare intake_length_ int; declare Intake_main_length int;
declare Name_ varchar(100);declare Email_ varchar(100);declare Phone_ varchar(15);declare Whatsapp_ varchar(100);
declare Address1_ varchar(200);declare Last_Name_ varchar(100);declare Address2_ varchar(100);declare Pincode_ varchar(100);
declare Alternative_Email_ varchar(100);declare Alternative_Phone_Number_ varchar(100);declare Facebook_ varchar(100);
declare Duplicate_Student_Id int;declare Duplicate_Student_Name varchar(100); declare Student_FollowUp_Id_ int;
declare Duplicate_User_Name varchar(25); declare Duplicate_User_Id int; declare import_master_id int default 0;
declare Master_Id_ int;
declare Visa_Submission_Date_ varchar(20);declare Country_Name_ varchar(45);
declare Passport_fromdate_ date;declare Passport_Todate_ date;declare exp_tenure_from_1_ date;declare exp_tenure_from_2_ date;
declare exp_tenure_from_3_ date;declare exp_tenure_from_4_ date;declare exp_tenure_to_1_ date;declare exp_tenure_to_2_ date;declare exp_tenure_to_3_ date;
declare exp_tenure_to_4_ date;
declare Intake_ varchar(50);declare Reference_ varchar(50);declare Activity_ varchar(50);declare Visa_Outcome_ varchar(50);
declare Year_ varchar(50);declare College_University_ varchar(50);
declare Programme_Course_ varchar(50);declare Agent_ varchar(50);declare Status_Details_ varchar(45);
declare Student_Remark_ varchar(45);declare Created_On_ varchar(45);declare Department_Name_ varchar(100);
declare Dept_FollowUp_ int;declare Branch_Name_ varchar(100);declare Department_Status_Name_ varchar(100);
declare User_Details_Name_ varchar(100);declare Role_Id_ int;declare By_User_Name_ varchar(100);
declare Enquiry_Source_Name_ varchar(100);declare color_ varchar(25);
#DROP TEMPORARY TABLE Duplicate_Students;
#CREATE TEMPORARY TABLE Duplicate_Students
#(
# Student_Id int PRIMARY KEY,
#    Student_Name varchar(100),
 #  Mobile varchar(100),
#    By_User_Name varchar(100)
#);
Set i=0;
#SET import_master_id_ = (SELECT  COALESCE( MAX(import_master_id ),0)+1 FROM import_master);    
delete from Duplicate_Students;
#insert into import_master(Import_Master_Id,Entry_Date)values(Import_Master_Id_,now());
SET color_ = (SELECT  Color_Type_Name FROM department where Department_Id= Department_);
 SET Master_Id_ = (SELECT  COALESCE( MAX(Master_Id ),0)+1 FROM import_students_master);
 insert into import_students_master values(Master_Id_,By_User_Id_,Next_FollowUp_Date_);
WHILE i < JSON_LENGTH(Student_Details) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Name'))) INTO Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Mobile'))) INTO Phone_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Address'))) INTO Address1_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Country'))) INTO Country_Name_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].College_University'))) INTO College_University_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Programme_Course'))) INTO Programme_Course_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Intake'))) INTO Intake_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Year'))) INTO Year_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Reference'))) INTO Reference_ ;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Visa_Submission_Date'))) INTO Visa_Submission_Date_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Activity'))) INTO Activity_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Visa_Outcome'))) INTO Visa_Outcome_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Status'))) INTO Status_Details_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Remarks'))) INTO Student_Remark_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Agent'))) INTO Agent_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Whatsapp'))) INTO Whatsapp_ ;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Email'))) INTO Email_ ;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Date'))) INTO Created_On_ ;
  # if Whatsapp_='null' then
  # set Whatsapp_='';
   #end if;

if  ISNULL(Address1_) then set Address1_=''; end if;
if  ISNULL(Country_Name_) then set Country_Name_=''; end if;
if  ISNULL(College_University_) then set College_University_=''; end if;
if  ISNULL(Programme_Course_) then set Programme_Course_=''; end if;
if  ISNULL(Intake_) then set Intake_=''; end if;
if  ISNULL(Year_) then set Year_=''; end if;
if  ISNULL(Reference_) then set Reference_=''; end if;
if  ISNULL(Visa_Submission_Date_) then set Visa_Submission_Date_=''; end if;
if  ISNULL(Activity_) then set Activity_=''; end if;
if  ISNULL(Visa_Outcome_) then set Visa_Outcome_=''; end if;
if  ISNULL(Status_Details_) then set Status_Details_=''; end if;
if  ISNULL(Student_Remark_) then set Student_Remark_=''; end if;
if  ISNULL(Whatsapp_) then set Whatsapp_=''; end if;
#if  ISNULL(Created_On_) then set Created_On_=''; end if;
set Department_Name_ = (select Department_Name from  department where Department_Id = Department_ and Is_Delete=0);
set Dept_FollowUp_ = (select FollowUp from department where Department_Id = Department_  and Is_Delete=0 );
set Branch_Name_ =(select Branch_Name from branch where Branch_Id = Branch_ and Is_Delete=0 );
set Department_Status_Name_=(select Department_Status_Name from department_status where Department_Status_Id = Status_ and Is_Delete=0 );
set User_Details_Name_ =(select User_Details_Name from user_details where User_Details_Id=To_User_ );
set Role_Id_=(select Role_Id from user_details where User_Details_Id=To_User_);
set By_User_Name_=(select User_Details_Name from user_details where User_Details_Id=By_User_Id_);
set Enquiry_Source_Name_=(select Enquiry_Source_Name from enquiry_source where Enquiry_Source_Id=Enquiry_Source_);
    #insert into db_logs_ (id,Description) values(0,Intake_Name_);and Alternative_Phone_Number like concat('%',Phone_,'%')
    set Phone_=REPLACE(REPLACE(REPLACE(REPLACE(Phone_, ' ', ''), '\t', ''), '\n', ''), '+', ''); 
   Set Student_Id_ = (select Student_Id from Student where  DeleteStatus=0  and Phone_Number like concat('%',Phone_,'%') or Whatsapp like concat('%',Phone_,'%') or Alternative_Phone_Number like concat('%',Phone_,'%')    limit 1);
   #insert into data_logs values (0,Phone_);
  
if(Student_Id_>0) then
set Duplicate_User_Id = (select To_User_Id from Student where Student_Id = Student_Id_);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Student_Id_);
set Duplicate_User_Name = (select User_Details_Name from user_details where User_Details_Id = Duplicate_User_Id);
SET Student_Id_ = -1;
            insert into Duplicate_Students values(0,Student_Id_,Duplicate_Student_Name,Phone_,Duplicate_User_Name,Master_Id_);
else
SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student);
  
  
/*INSERT INTO Student(Student_Id , Agent_Id, Entry_Date,Student_Name ,Last_Name ,Gender ,Address1 ,Address2 ,Pincode ,Email ,Alternative_Email,Phone_Number,Alternative_Phone_Number ,Dob ,Country ,
Promotional_Code ,Student_Status_Id,Enquiry_Source_Id ,Password,Created_By,
Passport_Copy,IELTS,Passport_Photo,Tenth_Certificate, Work_Experience,Resume,Whatsapp,Facebook,
Passport_Copy_File_Name,IELTS_File_Name, Passport_Photo_File_Name,Tenth_Certificate_File_Name,Work_Experience_File_Name,
Resume_File_Name,DeleteStatus,By_User_Id,Branch,Department,Status,User_Id,Next_FollowUp_Date,Is_Registered)
        values (Student_Id_,1,now(),Name_ ,'',0,Address1_,'','',Email_ ,'',Phone_ ,'',now(),0,
'',0,Enquiry_Source_,'',By_User_Id_,'','','','','','','','','','','','','','',0,
By_User_Id_,Branch_,Department_,Status_,To_User_,Next_FollowUp_Date_,0); */
INSERT INTO Student(Student_Id , Agent_Id, Entry_Date,Student_Name ,Address1 ,Address2 ,Email ,Phone_Number,Dob ,Country_Name ,
Student_Status_Id,Next_FollowUp_Date,Followup_Department_Id,Status_Id,To_User_Id, Followup_Branch_Id,Remark,Remark_Id,By_User_Id,
DeleteStatus,Enquiry_Source_Id,Alternative_Phone_Number,Alternative_Email,
Whatsapp,Is_Registered,Registered_By ,Created_By,Programme_Course,
Reference,Agent,Student_Remark,Send_Welcome_Mail_Status,
Passport_fromdate,Passport_Todate,
Created_On,FollowUp,Followup_Branch_Name,Department_Status_Name,To_User_Name,Role_Id,Enquiry_Source_Name,Created_User,
By_UserName,Followup_Department_Name)
values(Student_Id_ , 1, now(),Name_  ,Address1_ ,'' ,Email_,Phone_,now() ,Country_Name_  ,0,
Next_FollowUp_Date_,Department_,Status_,To_User_, Branch_,'',0,By_User_Id_,
0,Enquiry_Source_,'','',
Whatsapp_,0,0 ,By_User_Id_,Programme_Course_,
Reference_,Agent_,Student_Remark_,0,
current_date(),current_date(),
now(),Dept_FollowUp_,Branch_Name_,
Department_Status_Name_,User_Details_Name_,Role_Id_,Enquiry_Source_Name_,By_User_Name_,By_User_Name_,Department_Name_);           
INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id ,Branch,Remark,Remark_Id,By_User_Id,Class_Id ,DeleteStatus,
FollowUP_Time,Actual_FollowUp_Date,Branch_Name,UserName,ByUserName,Dept_StatusName,Dept_Name,FollowUp)
values (Student_Id_ ,Now(),Next_FollowUp_Date_,0,Department_ ,Status_ ,To_User_ ,Branch_,0,0,By_User_Id_,1,false,Now(),Now(),
Branch_Name_,By_User_Name_,By_User_Name_,Department_Status_Name_,Department_Name_,Dept_FollowUp_);
set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Next_FollowUp_Date = Next_FollowUp_Date_,
Color=color_
 where student.Student_Id=Student_Id_;
end if;
SELECT i + 1 INTO i;      
END WHILE;
set import_master_id=1;
 select  import_master_id;
 select * from Duplicate_Students where Master_Id=Master_Id_;
 delete from Duplicate_Students where Master_Id=Master_Id_;
 end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Message`( In Student_Message_Id_ int,
Student_Id_ int,
Message_Detail_ varchar(2000))
Begin 
 if  Student_Message_Id_>0
 THEN 
 UPDATE Student_Message set Student_Message_Id = Student_Message_Id_ ,
Student_Id = Student_Id_ ,
Message_Detail = Message_Detail_  Where Student_Message_Id=Student_Message_Id_ ;
 ELSE 
 SET Student_Message_Id_ = (SELECT  COALESCE( MAX(Student_Message_Id ),0)+1 FROM Student_Message); 
 INSERT INTO Student_Message(Student_Message_Id ,
Student_Id ,
Message_Detail,Entry_Date,DeleteStatus ) values (Student_Message_Id_ ,
Student_Id_ ,
Message_Detail_,now(),false );
 End If ;
 select Student_Message_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Report_FollowUp`( In Student_Selected_Details_ json,By_User_Id_ int,
Branch_ int,Branch_Name_ varchar(50),By_User_Name_ varchar(50))
Begin
Declare i int;DECLARE Student_Id_ int;declare x int default 0;
declare Student_FollowUp_Id_ int;declare Department_ int;declare Remark_Id_ int;declare Status_ int ;
declare Next_FollowUp_Date_ datetime ;
declare import_master_id int default 0;declare Class_Id_ int;declare Class_Name_ varchar(100);
declare Master_Id_ int;declare Department_Status_Name_ varchar(50);declare Department_Name_ varchar(50);
declare User_Id_ int;declare User_Name_ varchar(100);

Set i=0;
WHILE i < JSON_LENGTH(Student_Selected_Details_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Selected_Details_,CONCAT('$[',i,'].Student_Id'))) INTO Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Selected_Details_,CONCAT('$[',i,'].User_Id'))) INTO User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Selected_Details_,CONCAT('$[',i,'].User_Name'))) INTO User_Name_;
set Department_ = (Select Followup_Department_Id from student where Student_Id = Student_Id_);
set Department_Name_ = (Select Followup_Department_Name from student where Student_Id = Student_Id_);
set Remark_Id_ = (Select Remark_Id from student where Student_Id = Student_Id_);
set Status_ = (Select Status_Id from student where Student_Id = Student_Id_);
set Department_Status_Name_ = (Select Department_Status_Name from student where Student_Id = Student_Id_);
set Next_FollowUp_Date_ = (Select Next_FollowUp_date from student where Student_Id = Student_Id_);

set Class_Id_ = (Select Class_Id from student where Student_Id = Student_Id_);
set Class_Name_ = (Select Class_Name from student where Student_Id = Student_Id_);

INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id ,Branch,By_User_Id,Class_Id ,Class_Name,
DeleteStatus,FollowUP_Time,Actual_FollowUp_Date,Remark_Id,Entry_Type,Branch_Name,UserName,ByUserName,Dept_StatusName,Dept_Name)
values (Student_Id_ ,Now(),Next_FollowUp_Date_,0,Department_ ,Status_ ,User_Id_ ,Branch_,By_User_Id_,Class_Id_,Class_Name_,false,Now(),Now(),
Remark_Id_,3,Branch_Name_,User_Name_,By_User_Name_,
Department_Status_Name_,Department_Name_);
set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Followup_Department_Id = Department_ ,Status_Id = Status_ ,
To_User_Id = User_Id_ ,By_User_Id=By_User_Id_,Next_FollowUp_date = Next_FollowUp_Date_ ,Remark_Id=Remark_Id_,
Followup_Branch_Id=Branch_,FollowUp_Count=x+1,Followup_Department_Name = Department_Name_,Followup_Branch_Name = Branch_Name_,Department_Status_Name = Department_Status_Name_,
By_UserName = By_User_Name_,To_User_Name = User_Name_
where student.Student_Id=Student_Id_;
SELECT i + 1 INTO i;      
END WHILE;
set import_master_id=1;
select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Status`( In Student_Status_Id_ int,
Student_Status_Name_ varchar(50))
Begin 
 if  Student_Status_Id_>0
 THEN 
 UPDATE Student_Status set Student_Status_Id = Student_Status_Id_ ,
Student_Status_Name = Student_Status_Name_  Where Student_Status_Id=Student_Status_Id_ ;
 ELSE 
 SET Student_Status_Id_ = (SELECT  COALESCE( MAX(Student_Status_Id ),0)+1 FROM Student_Status); 
 INSERT INTO Student_Status(Student_Status_Id ,
Student_Status_Name,DeleteStatus ) values (Student_Status_Id_ ,
Student_Status_Name_,false );
 End If ;
 select Student_Status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Subject`( In Subject_Id_ int,
Subject_Name_ varchar(50))
Begin 
 if  Subject_Id_>0
 THEN 
 UPDATE Subject set Subject_Id = Subject_Id_ ,
Subject_Name = Subject_Name_  Where Subject_Id=Subject_Id_ ;
 ELSE 
 SET Subject_Id_ = (SELECT  COALESCE( MAX(Subject_Id ),0)+1 FROM Subject); 
 INSERT INTO Subject(Subject_Id ,
Subject_Name,DeleteStatus ) values (Subject_Id_ ,
Subject_Name_,false );
 End If ;
 select Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Sub_Section`( In Sub_Section_Id_ int,
Sub_Section_Name_ varchar(50))
Begin 
 if  Sub_Section_Id_>0
 THEN 
	UPDATE sub_section set Sub_Section_Id = Sub_Section_Id_ ,Sub_Section_Name = Sub_Section_Name_  Where Sub_Section_Id=Sub_Section_Id_ ;
 ELSE 
	SET Sub_Section_Id_ = (SELECT  COALESCE( MAX(Sub_Section_Id ),0)+1 FROM sub_section); 
	INSERT INTO sub_section(Sub_Section_Id ,Sub_Section_Name,DeleteStatus ) values (Sub_Section_Id_ ,Sub_Section_Name_,false );
 End If ;
 select Sub_Section_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Sub_Status`( In Sub_Status_Id_ int,
Sub_Status_Name_ varchar(100),Status_Id_ int,FollowUp_ tinyint,Duration_ int)
Begin 
 if  Sub_Status_Id_>0
 THEN 
 UPDATE sub_status set Sub_Status_Id = Sub_Status_Id_ ,Status_Id=Status_Id_,
Sub_Status_Name = Sub_Status_Name_,FollowUp=FollowUp_,Duration=Duration_  Where Sub_Status_Id=Sub_Status_Id_ ;
 ELSE 
 SET Sub_Status_Id_ = (SELECT  COALESCE( MAX(Sub_Status_Id ),0)+1 FROM sub_status); 
 INSERT INTO sub_status(Sub_Status_Id ,Sub_Status_Name ,Status_Id,FollowUp,Duration,DeleteStatus ) 
 values (Sub_Status_Id_ ,Sub_Status_Name_ ,Status_Id_,FollowUp_,Duration_,false);
 End If ;
 select Sub_Status_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Task`( In Task_Id_ int,Task_Details_ varchar(2500),
By_User_Id_ int)
Begin 
 if  Task_Id_>0
 THEN 
 UPDATE task set Task_Id = Task_Id_ ,Task_Details = Task_Details_ ,
By_User_Id = By_User_Id_  Where  Task_Id = Task_Id_ ;
 #update student set Department_Status_Name = Department_Status_Name_ where Status = Department_Status_Id_;
 ELSE 
 SET Task_Id_ = (SELECT  COALESCE( MAX(Task_Id ),0)+1 FROM task); 
 INSERT INTO task(Task_Id ,Task_Details ,Entry_Date ,By_User_Id ,DeleteStatus ) 
 values (Task_Id_ ,Task_Details_ ,curdate() ,By_User_Id_ ,false);
 End If ;
 select Task_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Task_Item`( In Task_Item_Id_ int,
Task_Item_Name_ varchar(45),Duration_ int,Task_Item_Group_Id_ int)
Begin 
 if  Task_Item_Id_>0
 THEN 
 UPDATE task_item set Task_Item_Id = Task_Item_Id_ ,
Task_Item_Name = Task_Item_Name_,Duration=Duration_,Task_Item_Group=4 
Where Task_Item_Id=Task_Item_Id_ ;
#update student set Enquiry_Source_Name = Enquiry_Source_Name_ where Enquiry_Source_Id = Enquiry_Source_Id_;
 ELSE 
 SET Task_Item_Id_ = (SELECT  COALESCE( MAX(Task_Item_Id ),0)+1 FROM task_item); 
 INSERT INTO task_item(Task_Item_Id ,
Task_Item_Name,Duration,Task_Item_Group,Delete_Status) values (Task_Item_Id_ ,
Task_Item_Name_,Duration_,4,false );
 End If ;
 select Task_Item_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_University`( In University_Id_ int,
University_Name_ varchar(50))
Begin 
 if  University_Id_>0
 THEN 
 UPDATE University set University_Id = University_Id_ ,
University_Name = University_Name_  Where University_Id=University_Id_ ;
 ELSE 
 SET University_Id_ = (SELECT  COALESCE( MAX(University_Id ),0)+1 FROM University); 
 INSERT INTO University(University_Id ,
University_Name,DeleteStatus ) values (University_Id_ ,
University_Name_,false );
 End If ;
 select University_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_University_Photos`(in University_Id_ int,
Photo json)
BEGIN
DECLARE University_Image_ varchar(50);DECLARE i int  DEFAULT 0;
/*DECLARE exit handler for sqlexception  
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
#ROLLBACK;
END;
DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
#ROLLBACK;
END;
    START TRANSACTION;*/
 WHILE i < JSON_LENGTH(Photo) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Photo,CONCAT('$[',i,'].File_name'))) INTO University_Image_;
   
INSERT INTO University_Photos(University_Id,University_Image,DeleteStatus )
values (University_Id_ ,University_Image_ ,false);
SELECT i + 1 INTO i;
END WHILE;  
#COMMIT;
select University_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_User_Details`( In User_Details_Id_ decimal,
User_Details_Name_ varchar(250),Password_ varchar(250),Working_Status_ int,
User_Type_ int,Role_Id_ decimal,Branch_ int,Address1_ varchar(250),Address2_ varchar(250),Address3_ varchar(250),
Address4_ varchar(250),Pincode_ varchar(250),Mobile_ varchar(250),Email_ varchar(250),
Employee_Id_ int,Registration_Target_ int,FollowUp_Target_ varchar(250),Department_Id_ int,Department_Name_ varchar(100),Backup_User_Id_ int,Backup_User_Name_ varchar(45),Default_Application_Status_Id_ int,Default_Application_Status_Name_ varchar(100),User_Menu_Selection JSON,User_Department JSON,
User_Application_Group json,User_Application_Status json,Application_View_ varchar(20),Application_Group_Value int,Application_Status_Value_ int,
All_Time_Department_View varchar(20),All_time_Department_Value_ int,All_Time_Departments_ json)
BEGIN

DECLARE MenuDepartment_Id_ int;DECLARE Branch_Id_ int;DECLARE View_Entry_ varchar(25);declare Old_Role_Id_ int;
DECLARE VIew_All_ varchar(25); DECLARE VIew_All_1 varchar(25);
DECLARE Menu_Id_ int;DECLARE IsEdit_ varchar(25);DECLARE IsSave_ varchar(25);
DECLARE IsDelete_ varchar(25);DECLARE IsView_ varchar(25); DECLARE Menu_Status_ varchar(25);declare SlNo_ int;
declare User_Max_Count int;
declare Current_User_Count int; declare Old_Status_Id_ int;declare Current_Slno_ int;declare Total_User_ int; 
declare Old_Department_ int;
declare Department_Total_Count int;declare m int default 0;declare Application_Group_Id_ int;declare Application_Group_Name_ varchar(100);declare Application_Group_View_ varchar(20);
declare n int default 0;declare Application_status_Id_ int;declare Application_Status_Name_ varchar(100);declare Application_Status_View_ varchar(20);
DECLARE i int  DEFAULT 0;DECLARE o int  DEFAULT 0;declare Department_Id_All_ int;declare checkbox_view_ varchar(20);
declare Updated_Serial_Id_ int;declare Notification_Type_Name_ varchar(45);
#insert into data_log_ values(0,User_Menu_Selection,'1');
#insert into data_log_ values(0,User_Department,'1');
/*DECLARE exit handler for sqlexception
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
#insert into data_log_ values(0,Application_Group_Value,Application_Status_Value_);

delete from User_Menu_Selection where User_Id=User_Details_Id_;
delete from user_department where User_Id=User_Details_Id_;
delete from user_application_group where User_Id=User_Details_Id_;
delete from user_application_status where User_Id=User_Details_Id_;
delete from all_time_departments where User_Id=User_Details_Id_;


if  User_Details_Id_>0 THEN
	set Old_Role_Id_ = (select Role_Id from user_details where User_Details_Id = User_Details_Id_ );
	set Old_Status_Id_=(select Working_Status from user_details where User_Details_Id = User_Details_Id_ );
	set Current_Slno_=(select Sub_Slno from user_details where User_Details_Id = User_Details_Id_);
	set Old_Department_=(select Department_Id from user_details where User_Details_Id = User_Details_Id_ );
	if( Old_Status_Id_=2 or Old_Status_Id_=3) and  1=Working_Status_ then
		update department set Total_User=Total_User+1 where Department_Id=Department_Id_;
		set Department_Total_Count=(select Total_User from department where Department_Id=Department_Id_);
		update user_details set Sub_Slno=Department_Total_Count where User_Details_Id=User_Details_Id_;
	elseif ( Old_Status_Id_=1 and Working_Status_=1) then
		if Old_Department_ !=Department_Id_ then 
			update department set Total_User=Total_User-1 where Department_Id=Old_Department_;
            update department set Current_User_Index=Current_User_Index-1 where Department_Id=Old_Department_
            and Current_User_Index > Total_User and Current_User_Index !=1 ;
			update department set Total_User=Total_User+1 where Department_Id=Department_Id_;
			set Department_Total_Count=(select Total_User from department where Department_Id=Department_Id_);
			UPDATE user_details set Sub_Slno=Sub_Slno-1 where Sub_Slno>Current_Slno_ and user_details.Department_Id=Old_Department_;
			 update user_details set Sub_Slno=Department_Total_Count where User_Details_Id=User_Details_Id_;
		end if;
	elseif ( Working_Status_=2 or Working_Status_=3) and  1=Old_Status_Id_ then
		UPDATE user_details set Sub_Slno=Sub_Slno-1 where Sub_Slno>Current_Slno_ and user_details.Department_Id=Old_Department_;
        update department set Total_User=Total_User-1 where Department_Id=Old_Department_;
        update user_details set Sub_Slno=0 where User_Details_Id=User_Details_Id_;
	end if;
    set Updated_Serial_Id_ = (SELECT  COALESCE( MAX(Updated_Serial_Id ),0)+1 FROM User_Details where User_Details_Id = User_Details_Id_);
    set Notification_Type_Name_ = 'User Details Updated';
	#if Application_View_ = 'true' then set Application_View_ = 1; else set Application_View_ = 0; end if;
	UPDATE User_Details set User_Details_Name = User_Details_Name_ ,Password = Password_ ,Working_Status = Working_Status_ ,
	User_Type = User_Type_ ,Role_Id = Role_Id_ ,Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_ ,Branch_Id=Branch_,
	Address4 = Address4_ ,Pincode = Pincode_ ,Mobile = Mobile_ ,Email = Email_,Employee_Id=Employee_Id_,Registration_Target=Registration_Target_,
	FollowUp_Target=FollowUp_Target_,Department_Id=Department_Id_,Department_Name=Department_Name_,Backup_User_Id=Backup_User_Id_,Backup_User_Name=Backup_User_Name_,Application_View = Application_View_,
    All_Time_Department = All_Time_Department_View,Default_Application_Status_Id=Default_Application_Status_Id_,Default_Application_Status_Name=Default_Application_Status_Name_,Updated_Serial_Id = Updated_Serial_Id_
	,Agent_Status=0
    Where User_Details_Id=User_Details_Id_ ;
	update student set To_User_Name = User_Details_Name_ where To_User_Id = User_Details_Id_;
	update student set Created_User = User_Details_Name_ where Created_By = User_Details_Id_;
	update student set Registered_User = User_Details_Name_ where Registered_By = User_Details_Id_;
	update student set By_UserName = User_Details_Name_ where By_User_Id = User_Details_Id_;
	update student set By_UserName = User_Details_Name_ where By_User_Id = User_Details_Id_;
	update student set Role_Id = Role_Id_ where To_User_Id = User_Details_Id_;
ELSE
	set User_Max_Count=(select Settings_Value from settings_table where  Settings_Id=49);
	set Current_User_Count=(select count(User_Details_Id) from user_details where DeleteStatus=0);
	if User_Max_Count>Current_User_Count then       
		SET User_Details_Id_ = (SELECT  COALESCE( MAX(User_Details_Id ),0)+1 FROM User_Details);
		set SlNo_ = (SELECT  COALESCE( MAX(Sub_Slno ),0)+1 FROM User_Details where Department_Id = Department_Id_);
		#if Application_View_ = 'true' then set Application_View_ = 1; else set Application_View_ = 0; end if;
		INSERT INTO User_Details(User_Details_Id ,User_Details_Name ,Password ,Working_Status ,User_Type ,Role_Id ,Branch_Id,
		Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,Mobile ,Email ,Employee_Id,Registration_Target,FollowUp_Target,
		Department_Id,Department_Name,Sub_Slno,Backup_User_Id,Backup_User_Name,Application_View,
        All_Time_Department,Default_Application_Status_Id,Default_Application_Status_Name,
        Updated_Serial_Id,DeleteStatus,Agent_Status )
		values (User_Details_Id_ ,User_Details_Name_ ,Password_ ,Working_Status_ ,User_Type_ ,
		Role_Id_ ,Branch_,Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,Mobile_ ,Email_ ,Employee_Id_,Registration_Target_,FollowUp_Target_,
		Department_Id_,Department_Name_,SlNo_,Backup_User_Id_,Backup_User_Name_,
        Application_View_,All_Time_Department_View,Default_Application_Status_Id_,
        Default_Application_Status_Name_,0,false,0);

		update department set Total_User = SlNo_ where Department_Id=Department_Id_;
	else
		SET User_Details_Id_ = -1;
	end if;
End If ;
if  User_Details_Id_>0 then
	WHILE i < JSON_LENGTH(User_Department) DO
	SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Department,CONCAT('$[',i,'].Department_Id'))) INTO MenuDepartment_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Department,CONCAT('$[',i,'].Branch_Id'))) INTO Branch_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Department,CONCAT('$[',i,'].Check_Box_View'))) INTO View_Entry_;
	if(View_Entry_='true')
		then set View_Entry_=1;
	else set View_Entry_=0;
end if;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Department,CONCAT('$[',i,']. Check_Box_VIew_All'))) INTO VIew_All_;
	set VIew_All_1=VIew_All_;
	if(VIew_All_='true')
		then set VIew_All_=1;
	else set VIew_All_=0;
	end if;

	INSERT INTO User_Department(User_Id,Department_Id,Branch_Id,View_Entry,VIew_All,Is_Delete )
	values (User_Details_Id_,MenuDepartment_Id_,Branch_Id_,View_Entry_,VIew_All_,false);  
	SELECT i + 1 INTO i;
	END WHILE;  
set i=0;
WHILE i < JSON_LENGTH(User_Menu_Selection) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Menu_Selection,CONCAT('$[',i,'].Menu_Id'))) INTO Menu_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Menu_Selection,CONCAT('$[',i,'].IsEdit'))) INTO IsEdit_;
        if(IsEdit_='true')
then set IsEdit_=1;
else set IsEdit_=0;
end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Menu_Selection,CONCAT('$[',i,'].IsSave'))) INTO IsSave_;
if(IsSave_='true')
then set IsSave_=1;
else set IsSave_=0;
end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Menu_Selection,CONCAT('$[',i,'].IsDelete'))) INTO IsDelete_;
  if(IsDelete_='true')
then set IsDelete_=1;
else set IsDelete_=0;
end if;
           SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Menu_Selection,CONCAT('$[',i,'].IsView'))) INTO IsView_;
  if(IsView_='true')
then set IsView_=1;
else set IsView_=0;
end if;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Menu_Selection,CONCAT('$[',i,'].Menu_Status'))) INTO Menu_Status_;
  if(Menu_Status_='true')
then set Menu_Status_=1;
else set Menu_Status_=0;
end if;          
INSERT INTO User_Menu_Selection(Menu_Id,User_Id,IsEdit,IsSave,IsDelete ,IsView,Menu_Status,DeleteStatus )
values (Menu_Id_ ,User_Details_Id_ ,IsEdit_ ,IsSave_ ,IsDelete_ ,IsView_ ,Menu_Status_ ,false);
SELECT i + 1 INTO i;
END WHILE;

	if  Application_Group_Value >0 then
		WHILE m < JSON_LENGTH(User_Application_Group) DO
			SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Application_Group,CONCAT('$[',m,'].Application_Group_Id'))) INTO Application_Group_Id_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Application_Group,CONCAT('$[',m,'].Application_Group_Name'))) INTO Application_Group_Name_;
            SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Application_Group,CONCAT('$[',m,'].View'))) INTO Application_Group_View_;
            if Application_Group_View_ = 'true' then set Application_Group_View_ = 1;else set Application_Group_View_ = 0;end if;
            insert into user_application_group(User_Id,Application_Group_Id,Application_Group_Name,View,DeleteStatus)
            values(User_Details_Id_,Application_Group_Id_,Application_Group_Name_,Application_Group_View_,0);
		SELECT m + 1 INTO m;
		end while;
	end if;
    if  Application_Status_Value_ >0 then
		WHILE n < JSON_LENGTH(User_Application_Status) DO
			SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Application_Status,CONCAT('$[',n,'].Application_status_Id'))) INTO Application_status_Id_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Application_Status,CONCAT('$[',n,'].Application_Status_Name'))) INTO Application_Status_Name_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Application_Status,CONCAT('$[',n,'].View'))) INTO Application_Status_View_;
            if Application_Status_View_ = 'true' then set Application_Status_View_ = 1; else set Application_Status_View_ = 0;end if;
            insert into user_application_status(User_Id,Application_Status_Id,Application_Status_Name,View,DeleteStatus)
            values(User_Details_Id_,Application_status_Id_,Application_Status_Name_,Application_Status_View_,0);
		SELECT n + 1 INTO n;
		end while;
	end if;
    if All_Time_Department_View = 1 then
		if All_time_Department_Value_>0 then
			WHILE o < JSON_LENGTH(All_Time_Departments_) DO
				SELECT JSON_UNQUOTE (JSON_EXTRACT(All_Time_Departments_,CONCAT('$[',o,'].Department_Id'))) INTO Department_Id_All_;
                SELECT JSON_UNQUOTE (JSON_EXTRACT(All_Time_Departments_,CONCAT('$[',o,'].checkbox_view'))) INTO checkbox_view_;
                if checkbox_view_ = 'true' then set checkbox_view_ = 1; else set checkbox_view_ = 0;end if;
				insert into All_Time_Departments(Department_Id,User_Id,View,DeleteStatus)
				values(Department_Id_All_,User_Details_Id_,checkbox_view_,0);
				SELECT o + 1 INTO o;
			end while;
		end if;
    end if;
end if;
 #COMMIT;
 
 select User_Details_Id_,Branch_Id_,Notification_Type_Name_;
 if Old_Role_Id_ != Role_Id_ then
	update student set Role_Id = Role_Id_ where To_User_Id = User_Details_Id_;
end if;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_User_Role`( In User_Role_Id_ int,
User_Role_Name_ varchar(50),
Role_Under_Id_ int)
Begin 
 if  User_Role_Id_>0
 THEN 
 UPDATE user_role set User_Role_Id = User_Role_Id_ ,
User_Role_Name=User_Role_Name_,
Role_Under_Id = Role_Under_Id_  Where User_Role_Id=User_Role_Id_ ;
 ELSE 
 SET User_Role_Id_ = (SELECT  COALESCE( MAX(User_Role_Id ),0)+1 FROM user_role); 
 INSERT INTO user_role(User_Role_Id ,
User_Role_Name ,
Role_Under_Id ,
Is_Delete ) values (User_Role_Id_ ,
User_Role_Name_ ,
Role_Under_Id_,
false);
 End If ;
 select User_Role_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Viewconditions`( In Conditions_ Json,
Conditions_Value_ int)
Begin 
 Declare i int default 0;
  declare Conditions_Id_ INT;
 declare Condition_Remark_ TEXT;
 if( Conditions_Value_>0) then
WHILE i < JSON_LENGTH(Conditions_) DO
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Conditions_,CONCAT('$[',i,'].Conditions_Id'))) INTO Conditions_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Conditions_,CONCAT('$[',i,'].Condition_Remark'))) INTO Condition_Remark_;
		
	Update conditions set 
    Condition_Remark=Condition_Remark_
	where Conditions_Id = Conditions_Id_;
	
	SELECT i + 1 INTO i;      
END WHILE;
end if;
 select Conditions_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Visa`( In Visa_Details_ json,Visa_Details_Value_ int,Visa_document_ json,Visa_Document_Value_ int )
Begin
 Declare Visa_Id_ varchar(100);Declare Student_Id_ int;Declare Approved_Date_ Datetime; Declare Visa_Granted_ varchar(10);Declare Application_No_ varchar(100);Declare Total_Fees_ varchar(100);Declare Scholarship_Fees_ varchar(100);Declare Balance_Fees_ varchar(100);Declare Paid_Fees_ varchar(100);
 declare Visa_File_Name_ varchar(100); declare Visa_Document_Name_ varchar(100);declare Visa_Document_File_Name_ varchar(100);
 Declare Visa_File_ varchar(10);Declare Visa_Letter_ varchar(10);Declare Approved_Date_L_ Datetime;
 Declare Approved_Date_F_ Datetime;declare Visa_Type_Id_ int;declare Visa_Type_Name_ varchar(45);declare Description_ varchar(100);
Declare i int default 0;Declare j int default 0;

declare Visa_Rejected_ varchar(10);Declare Visa_Rejected_Date_ Datetime;
declare ATIP_Submitted_ varchar(10);Declare ATIP_Submitted_Date_ Datetime;
declare ATIP_Received_ varchar(10);Declare ATIP_Received_Date_ Datetime;
declare Visa_Re_Submitted_ varchar(10);Declare Visa_Re_Submitted_Date_ Datetime;

declare Security_Question_ varchar(1500);declare Password_ varchar(45);declare Username_ varchar(45);
/*DECLARE exit handler for sqlexception
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    DECLARE exit handler for sqlwarning
BEGIN
GET DIAGNOSTICS CONDITION 1
@p1 = RETURNED_SQLSTATE, @p2 = MESSAGE_TEXT;
SELECT @p2 AS MESSAGE_TEXT, @p1 AS RETURNED_SQLSTATE;
ROLLBACK;
END;
    START TRANSACTION;*/
if( Visa_Details_Value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Id')) INTO Visa_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Student_Id')) INTO Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Approved_Date')) INTO Approved_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Approved_Date_L')) INTO Approved_Date_L_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Approved_Date_F')) INTO Approved_Date_F_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Granted')) INTO Visa_Granted_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Letter')) INTO Visa_Letter_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_File')) INTO Visa_File_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Application_No')) INTO Application_No_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Total_Fees')) INTO Total_Fees_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Scholarship_Fees')) INTO Scholarship_Fees_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Balance_Fees')) INTO Balance_Fees_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Paid_Fees')) INTO Paid_Fees_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Type_Id')) INTO Visa_Type_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Type_Name')) INTO Visa_Type_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Description')) INTO Description_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Username')) INTO Username_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Password')) INTO Password_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Security_Question')) INTO Security_Question_;


SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Rejected')) INTO Visa_Rejected_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Rejected_Date')) INTO Visa_Rejected_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.ATIP_Submitted')) INTO ATIP_Submitted_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.ATIP_Submitted_Date')) INTO ATIP_Submitted_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.ATIP_Received')) INTO ATIP_Received_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.ATIP_Received_Date')) INTO ATIP_Received_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Re_Submitted')) INTO Visa_Re_Submitted_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_Details_,'$.Visa_Re_Submitted_Date')) INTO Visa_Re_Submitted_Date_;





if (Visa_Granted_ = 'true' )
then
set Visa_Granted_= 1;
 else
set Visa_Granted_= 0;
end if;

if (Visa_Letter_ = 'true' )
then
set Visa_Letter_= 1;
 else
set Visa_Letter_= 0;
end if;

if (Visa_File_ = 'true' )
then
set Visa_File_= 1;
 else
set Visa_File_= 0;
end if;


if (Visa_Rejected_ = 'true' )
then
set Visa_Rejected_= 1;
 else
set Visa_Rejected_= 0;
end if;

if (ATIP_Submitted_ = 'true' )
then
set ATIP_Submitted_= 1;
 else
set ATIP_Submitted_= 0;
end if;

if (ATIP_Received_ = 'true' )
then
set ATIP_Received_= 1;
 else
set ATIP_Received_= 0;
end if;

if (Visa_Re_Submitted_ = 'true' )
then
set Visa_Re_Submitted_= 1;
 else
set Visa_Re_Submitted_= 0;
end if;

if(Visa_Id_>0) then
 UPDATE visa set Visa_Id = Visa_Id_ ,Visa_Granted = Visa_Granted_,Visa_Letter = Visa_Letter_,Visa_File = Visa_File_,Student_Id = Student_Id_,Approved_Date = Approved_Date_,Approved_Date_L = Approved_Date_L_,Approved_Date_F = Approved_Date_F_,
 Application_No = Application_No_,Total_Fees=Total_Fees_,Scholarship_Fees=Scholarship_Fees_,Balance_Fees=Balance_Fees_,Paid_Fees=Paid_Fees_,
 Visa_Type_Id=Visa_Type_Id_,Visa_Type_Name=Visa_Type_Name_,Description=Description_,Username=Username_,Password=Password_,Security_Question=Security_Question_,
 Visa_Rejected=Visa_Rejected_,Visa_Rejected_Date=Visa_Rejected_Date_,ATIP_Submitted=ATIP_Submitted_,ATIP_Submitted_Date=ATIP_Submitted_Date_,ATIP_Received=ATIP_Received_,
 ATIP_Received_Date=ATIP_Received_Date_,Visa_Re_Submitted=Visa_Re_Submitted_,Visa_Re_Submitted_Date=Visa_Re_Submitted_Date_
  Where Visa_Id = Visa_Id_;
 ELSE  
SET Visa_Id_ = (SELECT  COALESCE( MAX(Visa_Id ),0)+1 FROM visa);
 INSERT INTO visa(Visa_Id,Visa_Granted ,Visa_Letter,Visa_File,Approved_Date,Approved_Date_L,Approved_Date_F,Student_Id,
 Application_No,Total_Fees,Scholarship_Fees,Balance_Fees,Paid_Fees,Visa_Type_Id,Visa_Type_Name,Description,Username,Password,Security_Question,
 Visa_Rejected,
Visa_Rejected_Date,
ATIP_Submitted,
ATIP_Submitted_Date,
ATIP_Received,
ATIP_Received_Date,
Visa_Re_Submitted,
Visa_Re_Submitted_Date,
 DeleteStatus)
            values (Visa_Id_,Visa_Granted_,Visa_Letter_,Visa_File_,Approved_Date_,Approved_Date_L_,Approved_Date_F_,
            Student_Id_,Application_No_,Total_Fees_,Scholarship_Fees_,Balance_Fees_,Paid_Fees_,Visa_Type_Id_,
            Visa_Type_Name_,Description_,Username_,Password_,Security_Question_,
  Visa_Rejected_,
Visa_Rejected_Date_,
ATIP_Submitted_,
ATIP_Submitted_Date_,
ATIP_Received_,
ATIP_Received_Date_,
Visa_Re_Submitted_,
Visa_Re_Submitted_Date_,          
0);
End If ;
 end if;
 if( Visa_Document_Value_>0) then
WHILE j < JSON_LENGTH(Visa_document_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_document_,CONCAT('$[',j,'].Visa_File_Name'))) INTO Visa_File_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_document_,CONCAT('$[',j,'].Visa_Document_Name'))) INTO Visa_Document_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Visa_document_,CONCAT('$[',j,'].Visa_Document_File_Name'))) INTO Visa_Document_File_Name_;
        insert into visa_document (Visa_Id,Entry_Date,Description,Visa_Document_Name,Visa_Document_File_Name,Visa_File_Name,Student_Id,DeleteStatus)
        values(Visa_Id_,now(),'',Visa_Document_Name_,Visa_Document_File_Name_,Visa_File_Name_,Student_Id_,0);
SELECT j + 1 INTO j;      
END WHILE;
 end if;
#commit;
 select Visa_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_work_experience`( In Work_Experience_Id_ int,
Slno_ int,Student_Id_ int,Ex_From_ varchar(25),Ex_To_ varchar(25),Years_ varchar(25),
Company_ varchar(1000),Designation_ varchar(1000),Salary_ varchar(45),Salary_Mode_ varchar(100))
Begin
if  Work_Experience_Id_>0
 THEN 
    UPDATE work_experience set Work_Experience_Id = Work_Experience_Id_ ,
    Slno = Slno_ ,Student_Id=Student_Id_,Ex_From=Ex_From_,Ex_To=Ex_To_,
    Years=Years_,Company=Company_,Designation=Designation_,Salary=Salary_,
    Salary_Mode=Salary_Mode_
    Where Work_Experience_Id=Work_Experience_Id_ ;
    
 ELSE 
    SET Work_Experience_Id_ = (SELECT  COALESCE( MAX(Work_Experience_Id ),0)+1 FROM work_experience); 
    SET Slno_ = (SELECT  COALESCE( MAX(Slno ),0)+1 FROM work_experience); 
    INSERT INTO work_experience(Work_Experience_Id,Slno,Student_Id,Ex_From,
Ex_To,Years,Company,Designation,Salary,Salary_Mode,DeleteStatus ) 
    values (Work_Experience_Id_,Slno_,Student_Id_,Ex_From_,
Ex_To_,Years_,Company_,Designation_,Salary_,Salary_Mode_,false);
 End If ;
 select Work_Experience_Id_,Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Account_Group`( In Group_Name_ varchar(100))
Begin 
set Group_Name_ = Concat( '%',Group_Name_ ,'%');
SELECT Second.Account_Group_Id,Second.Primary_Id,Second.Group_Name,Second.Under_Group,
First.Group_Name as UnderGroup
FROM Account_Group as Second inner join Account_Group as First 
on First.Account_Group_Id=Second.Under_Group
where Second.Group_Name LIKE Group_Name_
and Second.Account_Group_Id>35 AND First.DeleteStatus=False AND Second.DeleteStatus=False;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Account_Group_Typeahead`( In Group_Name_ varchar(100))
Begin 
set Group_Name_ = Concat( '%',Group_Name_ ,'%');
SELECT
Account_Group_Id,Group_Name
FROM Account_Group 
where Group_Name LIKE Group_Name_ 
and Group_Name Not in('Sundry Debtors')
and DeleteStatus=False
order by Group_Name asc Limit 5 ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Agent`( In Client_Accounts_Name_ varchar(100),Account_Group_ int,Pointer_Start_ Varchar(10), 
Pointer_Stop_ Varchar(10), Page_Length_ Varchar(10))
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value=""; 

if Client_Accounts_Name_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and Client_Accounts.Client_Accounts_Name like '%",Client_Accounts_Name_ ,"%'") ;
end if;

if Account_Group_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Client_Accounts.Account_Group_Id =",Account_Group_);
end if;


SET @query = Concat("select * from (SELECT 
Client_Accounts.Client_Accounts_Id,Client_Accounts.Client_Accounts_Code,
Client_Accounts.Client_Accounts_Name,Client_Accounts.Client_Accounts_No,Client_Accounts.Address1,
Client_Accounts.Address2,Client_Accounts.Address3,Client_Accounts.Address4,
Client_Accounts.PinCode,Client_Accounts.StateCode,Client_Accounts.GSTNo,Client_Accounts.PanNo,
Client_Accounts.State,Client_Accounts.Country,Client_Accounts.Phone,
Client_Accounts.Mobile,Client_Accounts.Email,Client_Accounts.Opening_Balance,
Client_Accounts.Description1,Client_Accounts.UserId,
Client_Accounts.LedgerInclude,Client_Accounts.CanDelete,Client_Accounts.Opening_Type
,Client_Accounts.Commision,
(Date_Format(Client_Accounts.Entry_Date,'%Y-%m-%d')) As Entry_Date,
Client_Accounts.Account_Group_Id ,Group_Name Account_Group_Name,
Client_Accounts.Employee_Id,Emp.Client_Accounts_Name as Employee,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY client_accounts.Client_Accounts_Name DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From Client_Accounts
inner join Account_Group on Account_Group.Account_Group_Id=Client_Accounts.Account_Group_Id
inner join Client_Accounts as Emp on Client_Accounts.Employee_Id=Emp.Client_Accounts_Id
where Client_Accounts.Client_Accounts_Id>35 and  Client_Accounts.DeleteStatus=false   ",SearchbyName_Value, ")
 as lds WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_," order by  RowNo LIMIT ",Page_Length_);
 
PREPARE QUERY FROM @query;
EXECUTE QUERY;


#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Agent_Details`(In Agent_Name_ varchar(500))
Begin 
 set Agent_Name_ = Concat( '%',Agent_Name_ ,'%');
 SELECT Agent_Id,
Agent_Name,Phone,Email,Address,Description,User_Name,Password
From agent where Agent_Name like Agent_Name_ and DeleteStatus=false 
Order by Agent_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Agent_Student`(
	In From_Date_ date,
	To_Date_ date,
	Is_Date_Check_ Tinyint,
	SearchbyName_ varchar(50), 
	Pointer_Start_ int, 
	Pointer_Stop_ int, 
	Page_Length_ int,
	Login_Agent_ INT,
    Ielts_Status_ int,
    Status_ int
)
BEGIN 
	DECLARE Search_Date_ varchar(500);
	DECLARE SearchbyName_Value varchar(4000);
	SET Search_Date_="";
	SET SearchbyName_Value=""; 
	IF Is_Date_Check_=true THEN
		SET Search_Date_=CONCAT(Search_Date_," AND DATE(Student.Entry_Date) >= '", From_Date_ ,"'
		AND DATE(Student.Entry_Date) <= '", To_Date_,"'");
	END IF;
	IF(SearchbyName_ !='') THEN
		SET Is_Date_Check_ = false;
		SET SearchbyName_Value = REPLACE(REPLACE(SearchbyName_Value,'+',''),' ','');
		SET SearchbyName_Value = CONCAT(SearchbyName_Value," AND (student.Student_Name LIKE '%",SearchbyName_ ,"%' OR 
		REPLACE(REPLACE(student.Phone_Number,'+',''),' ','') LIKE '%",SearchbyName_ ,"%'
		OR REPLACE(REPLACE(student.Whatsapp,'+',''),' ','') LIKE '%",SearchbyName_ ,"%' 
		OR REPLACE(REPLACE(student.Alternative_Phone_Number,'+',''),' ','') LIKE '%",SearchbyName_ ,"%' 
		OR student.Email LIKE '%",SearchbyName_ ,"%' OR student.Alternative_Email LIKE '%",SearchbyName_ ,"%')");
	END IF;
	IF Login_Agent_>0 THEN
		SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND student.Created_By =",Login_Agent_);
	END IF;
    IF Ielts_Status_>0 THEN
		SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND student.Ielts_Status_Id =",Ielts_Status_);
	END IF;
    IF Status_>0 THEN
		SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND student.Status_Id =",Status_);
	END IF;
	SET @query = CONCAT("SELECT * FROM (SELECT student.Student_Id, (DATE_FORMAT(student.Entry_Date,'%d-%m-%Y')) Entry_Date,
		student.Student_Name, student.Address1, student.Email, student.Phone_Number, Ielts_Status_Name,Enquiry_Source_Name,
        Department_Status_Name,CAST(CAST(ROW_NUMBER() OVER (ORDER BY Student.Student_Name DESC) AS UNSIGNED) AS SIGNED) AS RowNo 
		FROM Student WHERE Student.DeleteStatus = false ", Search_Date_, SearchbyName_Value, " ORDER BY Student.Entry_Date DESC) 
		AS lds WHERE RowNo >= ",Pointer_Start_," AND RowNo <= ",Pointer_Stop_," ORDER BY RowNo LIMIT ",Page_Length_);

	PREPARE QUERY FROM @query;
	EXECUTE QUERY;
	#SELECT @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_ApplicationDetails`(In Application_details_Id_ int)
Begin
declare SearchbyName_Value varchar(2000);
 set SearchbyName_Value=''; 

 if Application_details_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.Application_details_Id =",Application_details_Id_);
end if;

SET @query = Concat("select Application_details_Id,Student_Id,Country_Name,Application_details_history_Id
 from application_details_history
 where application_details_history.DeleteStatus=false ",SearchbyName_Value," order by Application_details_Id desc");
  PREPARE QUERY FROM @query;
  EXECUTE QUERY;
 #select @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Application_Group_Typeahead`( In Application_Group_Name_ varchar(100))
Begin
 set Application_Group_Name_ = Concat( '%',Application_Group_Name_ ,'%');
select  application_group.Application_Group_Id,Application_Group_Name
From application_group
where application_group.DeleteStatus=false
order by Application_Group_Name asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Application_List`( In Login_User_Id_ Int,Enrolled_Application_Only_View_Permission_ int)
Begin
declare SearchbyName_Value varchar(2000);declare SearchbyPermission_Value varchar(2000);
set SearchbyName_Value = "";set SearchbyPermission_Value = "";
if Enrolled_Application_Only_View_Permission_>0 then
	SET SearchbyPermission_Value =concat(SearchbyPermission_Value," and ifnull(application_details.Is_Entrolled,0) =",1);
end if;
#if Login_User_Id_>0 then
	#SET SearchbyName_Value =concat(SearchbyName_Value," and user_application_status.User_Id =",Login_User_Id_);
    #SET SearchbyName_Value =concat(SearchbyName_Value," and application_details.User_Id =",Login_User_Id_);
#end if;
SET @query = Concat( "SELECT Application_details_Id ,Student_Id,Country_Id,Application_Source,
Country_Name,University_Id,University_Name,Course_Id,Course_Name,intake_Id,
intake_Name,Intake_Year_Id,Intake_Year_Name,Student_Reference_Id,Application_No,
Date_Of_Applying, (Date_Format(Date_Of_Applying,'%d-%m-%y')) as Grid_Date ,application_details.Remark,
application_details.Application_status_Id,application_details.Application_Status_Name
,Agent_Id,Agent_Name,Reference_No,Activation_Status,Course_Fee,Living_Expense,Preference,Paid_Status,Application_Fees_Paid,Portal_User_Name,Password,
Offer_Student_Id,Fees_Payment_Last_Date,
IFNULL(Feespaymentcheck, 0) as Feespaymentcheck, IFNULL(Offer_Received, 0) as Offer_Received,Duration_Id,
application_status.Application_Status_Id as Application_Status_Id,
application_status.Application_Status_Name as Application_Status_Name,
application_status.Transfer_Status,application_status.Notification_Status,
application_status.Notification_Department_Id,application_status.Notification_Department_Name,
application_status.Transfer_Department_Id,application_status.Transfer_Department_Name,
application_status.Application_status_Id as Appstatusid ,application_status.Application_Status_Name as AppstatusName,Student_Name,Group_Restriction,
Offerletter_Type_Id,Offerletter_Type_Name
From application_details
inner join application_status on application_status.Application_Status_Id=application_details.Application_Status_Id
where  application_details.DeleteStatus=false and application_details.Application_Status_Id in 
(select Application_Status_Id  from user_application_status where User_Id=",Login_User_Id_," )" ,SearchbyName_Value,SearchbyPermission_Value,"
order by application_details.Application_details_Id desc");

#inner join user_application_status on user_application_status.Application_Status_Id=application_details.Application_Status_Id

PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Application_List_old`( In Login_User_Id_ Int)
Begin
SELECT Application_details_Id ,Student_Id,Country_Id,Application_Source,
Country_Name,University_Id,University_Name,Course_Id,Course_Name,intake_Id,
intake_Name,Intake_Year_Id,Intake_Year_Name,Student_Reference_Id,Application_No,
Date_Of_Applying, (Date_Format(Date_Of_Applying,'%d-%m-%y')) as Grid_Date ,application_details.Remark,
application_details.Application_status_Id,application_details.Application_Status_Name
,Agent_Id,Agent_Name,Reference_No,Activation_Status,Course_Fee,Living_Expense,Preference,Student_Approved_Status,
Student_Approve_Status.Status_Name as Status_Name_Approval,Bph_Approved_Status,
bph_status.Bph_Status_Name as Bph_Status_Name,Paid_Status,Application_Fees_Paid,Portal_User_Name,Password,
Offer_Student_Id,Fees_Payment_Last_Date,
IFNULL(Feespaymentcheck, 0) as Feespaymentcheck, IFNULL(Offer_Received, 0) as Offer_Received,Duration_Id,
user_application_status.Application_Status_Id as Application_Status_Id,
user_application_status.Application_Status_Name as Application_Status_Name,User_Application_Status_Id,
application_status.Transfer_Status,application_status.Notification_Status,
application_status.Notification_Department_Id,application_status.Notification_Department_Name,
application_status.Transfer_Department_Id,application_status.Transfer_Department_Name,
application_status.Application_status_Id as Appstatusid ,application_status.Application_Status_Name as AppstatusName

From application_details 
inner join Student_Approve_Status on Student_Approve_Status.Student_Approve_Status_Id = application_details.Student_Approved_Status
inner join bph_status on bph_status.Bph_Status_Id = application_details.Bph_Approved_Status
inner join user_application_status on user_application_status.Application_Status_Id=application_details.Application_Status_Id
and user_application_status.User_Id=Login_User_Id_
inner join application_status on application_status.Application_Status_Id=application_details.Application_Status_Id
where application_details.User_Id = Login_User_Id_ and application_details.DeleteStatus=false and  View=1;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Application_report`(In Fromdate_ date,Todate_ date,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Login_User_Id_ int,Status_Value int,Agent_Id_ int,Application_status_Id_ int,Intake_Id_ int,Intake_Year_Id_ int,Country_Id_ int,University_Id_ int,Is_Active_Check_ Tinyint)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);declare Department_String_ varchar(4000);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;declare RoleId_ varchar(100);
declare pos2to int; declare PageSize int;declare User_Type_ int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
 set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);

if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and user_details.Branch_Id =",Branch_);
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.User_Id =",By_User_);
end if;
if Agent_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and agent.Agent_Id =",Agent_Id_);
end if;
if Application_status_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_status.Application_status_Id =",Application_status_Id_);
end if;

if Intake_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.intake_Id =",Intake_Id_);
end if;

if Intake_Year_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.Intake_Year_Id =",Intake_Year_Id_);
end if;

if Country_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.Country_Id =",Country_Id_);
end if;

if University_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.University_Id =",University_Id_);
end if;

if Is_Active_Check_=true then
SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.Activation_Status =",Is_Active_Check_);
end if;

if Status_Value=2 then
Set SearchbyName_Value= Concat( SearchbyName_Value," and application_details_history.Activation_Status= ",1) ;
    elseif Status_Value=3 then
    Set SearchbyName_Value= Concat( SearchbyName_Value," and application_details_history.Activation_Status= ",0) ;
    end if;

/*if User_Type_=2 then
         SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.User_Id =",Login_User_Id_);
else
    SET SearchbyName_Value =concat(SearchbyName_Value," and application_details_history.User_Id in (select User_Details_Id from user_details where Branch_Id in (select
        distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
if Is_Date_Check_=true then
set Search_Date_=concat( " and date(application_details_history.Date_Of_Applying) >= '", Fromdate_ ,"' and  date(application_details_history.Date_Of_Applying) <= '", Todate_,"'");
set Search_Date_union=concat( SearchbyName_Value," and  application_details_history.Date_Of_Applying < '", Fromdate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat( "select student.Student_Id,student.Student_Name Student,student.Phone_Number Mobile,Branch.Branch_Name Branch,
user_details.User_Details_Name User,application_details_history.Country_Name Country,University_Name University,Course_Name Course,intake_Name Intake,Intake_Year_Name Intake_Year,application_details_history.Remark Remark,
application_status.Application_Status_Name Status,agent.Agent_Name Agent,(Date_Format(application_details_history.Date_Of_Applying,'%d-%m-%Y ')) As Applied_Date,if (application_details_history.Activation_Status>0,'Active','Deactive')  AS Activation_Status
 from student
inner join application_details_history on application_details_history.Student_Id=student.Student_Id
inner join user_details on user_details.User_Details_Id=application_details_history.User_Id
inner join Branch on Branch.Branch_Id= user_details.Branch_Id
left join agent on agent.Agent_Id= application_details_history.Agent_Id
inner join application_status on application_status.Application_status_Id= application_details_history.Application_status_Id
where student.DeleteStatus=0 and application_details_history.DeleteStatus=0   ",SearchbyName_Value," ",Search_Date_," ",Department_String_,"
and user_details.Role_Id in(",RoleId_,") 
 order by User_Details_Id ");

PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Application_Status`( In Application_Status_Name_ varchar(45))
Begin
 set Application_Status_Name_ = Concat( '%',Application_Status_Name_ ,'%');
 SELECT Application_status_Id,
Application_Status_Name,Application_Group_Id,Application_Group_Name,Notification_Department_Id,Notification_Department_Name,Transfer_Department_Id,Transfer_Department_Name,Transfer_Status,Notification_Status,Group_Restriction From application_status where Application_Status_Name like Application_Status_Name_
and DeleteStatus=false
order by  Application_Status_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Backup_User_Typeahead`(in User_Details_Name_ varchar(100))
BEGIN
 set User_Details_Name_ = Concat( '%',User_Details_Name_ ,'%');
select  user_details.User_Details_Id,User_Details_Name
From user_details
where User_Details_Name like User_Details_Name_  and user_details.DeleteStatus=false
order by User_Details_Name asc   ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Branch`( In Branch_Name_ varchar(100))
Begin 
 set Branch_Name_ = Concat( '%',Branch_Name_ ,'%');
 SELECT Branch_Id,
Branch_Name,
Address,
Location,
District,
State,
Country,
PinCode,
Branch.Phone_Number,
Branch.Email,
Branch_Code,
Default_Department_Id,
Default_Department_Name,
Default_User_Id,
Default_User_Name,
Default_Status_Id, 
Default_Status_Name,
Is_FollowUp
 From Branch 
 where Branch_Name like Branch_Name_ and Branch.Is_Delete=false 
 Order by Branch_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_BranchDefaultDepartment_Typeahead`(In Branch_Id_ int)
BEGIN
SELECT
Default_Department_Id,Default_Department_Name
from branch 
where Branch_Id=Branch_Id_ and branch.Is_Delete=false ;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Branchwise_Summary`(In Fromdate_ date,Todate_ date,RoleId_ varchar(100),Department_String varchar(1000),Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';


set Search_Date_=concat( " and date(fees_receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(fees_receipt.Entry_Date) <= '", Todate_,"'");


SET @query = Concat( "select sum(fees_receipt.Amount) Branch_Total , Branch_Name from 
student
inner join fees_receipt on student.Student_Id=fees_receipt.Student_Id
inner join Branch on Branch.Branch_Id= student.Branch
where fees_receipt.Delete_Status=0",Search_Date_," 
group by student.Branch ");
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Branch_Department_Typeahead`(In Branch_Id_ int,
Department_Name_ Varchar(100))
BEGIN
 set Department_Name_ = Concat( '%',Department_Name_ ,'%');
SELECT
Department.Department_Id,
Department_Name,Department.FollowUp Department_FollowUp
from Department
inner join Branch_Department on Department.Department_Id=Branch_Department.Department_Id and Branch_department.Branch_Id=Branch_Id_
where Department_Name like Department_Name_
and Department.Is_Delete=false and Department.Transfer_Method_Id=2
ORDER BY Department_Order Asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Branch_Typeahead`( In Branch_Name_ varchar(100))
Begin 
 set Branch_Name_ = Concat( '%',Branch_Name_ ,'%');
 SELECT 
 Branch_Id,
Branch_Name,
Address,
Location,
District,
State,
Country,
PinCode,
Phone_Number,
Email,
Branch_Code,Default_Department_Id,Default_Department_Name,Default_User_Id,
Default_User_Name,Default_Status_Id,Default_Status_Name,Is_FollowUp
From Branch where Branch_Name like Branch_Name_ and Is_Delete=false 
ORDER BY Branch_Name Asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Branch_User_Typeahead`(In Branch_Id_ int,
User_Details_Name_ varchar(100))
BEGIN 
 set User_Details_Name_ = Concat( '%',User_Details_Name_ ,'%');

SELECT
user_details.User_Details_Id,
User_Details_Name
from user_details 
inner join branch on user_details.Branch_Id=branch.Branch_Id 
and branch.Branch_Id=Branch_Id_
where User_Details_Name like User_Details_Name_ and user_details.DeleteStatus=false 
ORDER BY User_Details_Name Asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Check_List`( In Check_List_Name_ varchar(100))
Begin 
 set Check_List_Name_ = Concat( '%',Check_List_Name_ ,'%');
 SELECT Check_List_Id,
Check_List_Name
From check_list where Check_List_Name like Check_List_Name_ and DeleteStatus=false 
Order by Check_List_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Client_Accounts`( In Client_Accounts_Name_ varchar(100),Account_Group_ int,Pointer_Start_ Varchar(10), 
Pointer_Stop_ Varchar(10), Page_Length_ Varchar(10))
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value=""; 
/*
if Client_Accounts_Name_ !='' then
	set SearchbyName_Value = concat( "'%",Client_Accounts_Name_ ,"%'");
	SET SearchbyName_Value =concat(" and Client_Accounts.Client_Accounts_Name like " ,Client_Accounts_Name_);
end if;
*/

if Client_Accounts_Name_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and Client_Accounts.Client_Accounts_Name like '%",Client_Accounts_Name_ ,"%'") ;
end if;

if Account_Group_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Client_Accounts.Account_Group_Id =",Account_Group_);
end if;


SET @query = Concat("select * from (SELECT 
Client_Accounts.Client_Accounts_Id,Client_Accounts.Client_Accounts_Code,
Client_Accounts.Client_Accounts_Name,Client_Accounts.Client_Accounts_No,Client_Accounts.Address1,
Client_Accounts.Address2,Client_Accounts.Address3,Client_Accounts.Address4,
Client_Accounts.PinCode,Client_Accounts.StateCode,Client_Accounts.GSTNo,Client_Accounts.PanNo,
Client_Accounts.State,Client_Accounts.Country,Client_Accounts.Phone,
Client_Accounts.Mobile,Client_Accounts.Email,Client_Accounts.Opening_Balance,
Client_Accounts.Description1,Client_Accounts.UserId,
Client_Accounts.LedgerInclude,Client_Accounts.CanDelete,Client_Accounts.Opening_Type
,Client_Accounts.Commision,
(Date_Format(Client_Accounts.Entry_Date,'%Y-%m-%d')) As Entry_Date,
Client_Accounts.Account_Group_Id ,Group_Name Account_Group_Name,
Client_Accounts.Employee_Id,Emp.Client_Accounts_Name as Employee,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY client_accounts.Client_Accounts_Name DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From Client_Accounts
inner join Account_Group on Account_Group.Account_Group_Id=Client_Accounts.Account_Group_Id
inner join Client_Accounts as Emp on Client_Accounts.Employee_Id=Emp.Client_Accounts_Id
where Client_Accounts.Client_Accounts_Id>35 and  Client_Accounts.DeleteStatus=false   ",SearchbyName_Value, ")
 as lds WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_," order by  RowNo LIMIT ",Page_Length_);
 
PREPARE QUERY FROM @query;
EXECUTE QUERY;


#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Conditions`(In Application_details_Id_ int)
Begin 
 SELECT * From conditions where Application_details_Id=Application_details_Id_ ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Counselor_Fees_Receipt_Report`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,Fees_Id int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';

if(SearchbyName_ !='0') then
	if Search_By_=1 then
	SET SearchbyName_Value =   Concat( " and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
end if;
if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Department =",Department_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Branch =",Branch_);
end if;
if Login_User_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.User_Id =",Login_User_Id_);
end if;
if Fees_Id>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.Fees_Id =",Fees_Id);
end if;
if Is_Date_Check_=true then
set Search_Date_=concat( " and date(Fees_Receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(Fees_Receipt.Entry_Date) <= '", Todate_,"'");

ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat( "select student.Student_Id,
student.Student_Name,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,
    (Date_Format(Fees_Receipt.Entry_Date,'%d-%m-%Y')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Department.Department_Name,Department.FollowUp,Department_Status.Department_Status_Name,T.User_Details_Name,
B.User_Details_Name Registered_By_Name,Branch.Branch_Name,Is_Registered,user_details.User_Details_Name As Created_By_Name,
    F_user.User_Details_Name As Fees_Collected_By,Fees_Receipt.Amount,Fees_Receipt.Description,Fees.Fees_Name 
from student
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Department on Department.Department_Id= student.Department  
inner join Branch on Branch.Branch_Id= student.Branch
inner join Department_Status on Department_Status.Department_Status_Id=student.Status
inner join user_details as T on T.User_Details_Id=student.User_Id
left join user_details as B on B.User_Details_Id=student.Registered_By
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join user_details as F_user on F_user.User_Details_Id=Fees_Receipt.User_Id
inner join Fees on Fees.Fees_Id=Fees_Receipt.Fees_Id 
where student.DeleteStatus=0    and student.DeleteStatus=0  ",SearchbyName_Value," ",Search_Date_,"
order by Fees_Receipt.Entry_Date ");

PREPARE QUERY FROM @query;
#select @query;


EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Counselor_Registration_Report`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN

declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
if(SearchbyName_ !='0') then
if Search_By_=1 then
SET SearchbyName_Value =   Concat( " and student.Student_Name like '%",SearchbyName_ , "%' " ) ;
end if;
end if;
if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Department =",Department_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Branch =",Branch_);
end if;
if Login_User_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",Login_User_Id_);
end if;
if Is_Date_Check_=true then
set Search_Date_=concat( " and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery=""; 

SET @query = Concat( "select student.Student_Id,
student.Student_Name,student.Phone_Number,student.Remark,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,
    (Date_Format(student.Entry_Date,'%d-%m-%Y')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Department.Department_Name,Department.FollowUp,Department_Status.Department_Status_Name,T.User_Details_Name,
B.User_Details_Name Registered_By_Name,
Branch.Branch_Name,Is_Registered,user_details.User_Details_Name As Created_By_Name
from student
inner join Department on Department.Department_Id= student.Department  
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Branch
inner join Department_Status on Department_Status.Department_Status_Id=student.Status
inner join user_details as T on T.User_Details_Id=student.User_Id
inner join user_details as B on B.User_Details_Id=student.Registered_By
where student.DeleteStatus=0    and student.Is_Registered=1  ",SearchbyName_Value," ",Search_Date_,"
order by student.Registered_On");

PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;

select 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Country`( In Country_Name_ varchar(100))
Begin 
 set Country_Name_ = Concat( '%',Country_Name_ ,'%');
 SELECT Country_Id,
Country_Name From Country where Country_Name like Country_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Country_Typeahead`( In Country_Name_ varchar(100))
Begin
 set Country_Name_ = Concat( '%',Country_Name_ ,'%');
select  Country.Country_Id,Country_Name
From Country
where Country.DeleteStatus=false
order by Country_Name asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course`(In Course_Name_ varchar(100),Level_Id_ int,Country_Id_ int,Internship_Id_ int,
Duration_Id_ int,University_Id_ int,Subject_Id_ int ,Sub_Section_Id_ int, Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
Begin 
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
if Course_Name_!='' then
	SET SearchbyName_Value =concat( SearchbyName_Value ," and Course.Course_Name like '%",Course_Name_ ,"%'") ;
end if;
if Level_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Level_Id =",Level_Id_);
end if;
if Country_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Country_Id =",Country_Id_);
end if;
if Internship_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.internship_Id =",Internship_Id_);
end if;
if Duration_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Duration_Id =",Duration_Id_);
end if;
if University_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.University_Id =",University_Id_);
end if;
if Subject_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Subject_Id =",Subject_Id_);
end if;
if Sub_Section_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Sub_Section_Id =",Sub_Section_Id_);
end if;
SET @query = Concat("select * from ( select * from (
SELECT 1 tp, Course_Id,Course_Name,Course_Code,CountryName,UniversityName,DurationName,Level_DetailName,SubjectName,Sub_SectionName,internshipName,course.Internship_Id,
course.Country_Id,course.Subject_Id,course.Sub_Section_Id,course.University_Id,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Course.Course_Name DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From Course 
where Course.DeleteStatus = false  " ,SearchbyName_Value," order by Course.Course_Name desc )
as lds WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ ," ) as t union 
SELECT 0 tp, count(Course_Id)as Course_Id ,''CountryName,''Course_Code,''Country_Name,''UniversityName,''DurationName,''Level_DetailName,
''SubjectName,''Sub_SectionName,''internshipName,0 Internship_Id,
'0' Country_Id,0 Subject_Id,0 Sub_Section_Id,0 University_Id,
0 RowNo From Course 
where Course.DeleteStatus = false  " ,SearchbyName_Value, " order by tp desc");
PREPARE QUERY FROM @query;
EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Courses_Fees_Typeahead`( In Course_Name_ varchar(500),Student_Id_ int)
Begin
set Course_Name_ = Concat( '%',Course_Name_ ,'%');
select Course_Id,Course_Name,University_Id,University_Name as University,Country_Id,Country_Name as Country,
Application_details_Id,Student_Id
From application_details
where  application_details.Student_Id=Student_Id_ and  Course_Name like Course_Name_ and application_details.DeleteStatus=false
order by Course_Name;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Courses_Typeahead`( In Course_Name_ varchar(500))
Begin
 set Course_Name_ = Concat( '%',Course_Name_ ,'%');
select  course.Course_Id,Course_Name
From course
where  course.DeleteStatus=false
order by Course_Name;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Import`(In From_Date_ datetime,To_Date_ datetime,Is_Date_Check_ Tinyint)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
Declare Import_Master_Id_ int;
set Search_Date_="";set SearchbyName_Value=""; 
if Is_Date_Check_=true then
	set Search_Date_=concat(" and date(import_master.Entry_Date) >= '", From_Date_ ,"' and  date(import_master.Entry_Date) <= '", To_Date_,"'");
end if;

SET @query = Concat("SELECT Import_Master_Id,(Date_Format(Entry_Date,'%Y-%m-%d')) Entry_Date
 From import_master  order by import_master.Entry_Date desc ");
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into db_logs values(1,@query,1,1);
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Intake`( In Course_Intake_Name_ varchar(100))
Begin 
 set Course_Intake_Name_ = Concat( '%',Course_Intake_Name_ ,'%');
 SELECT Course_Id,
Intake_Id From Course_Intake where Course_Intake_Name like Course_Intake_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Typeahead`(In Country_Id_ int,Subject_Id_ varchar(100),Level_Id_ int,
Course_Name_ varchar(100),Duration_Id_ varchar(100),Ielts_Minimum_Score_ int,Intake_Id_ int,Internship_Id_ int)
Begin 
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value=""; 

if Course_Name_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and course.Course_Name like '%",Course_Name_ ,"%'") ;
end if;
if Duration_Id_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and course.Duration_Id in (",Duration_Id_ ,")") ;
end if;
if Subject_Id_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and course.Subject_Id in (",Subject_Id_ ,")") ;
end if;
if Country_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Country_Id =",Country_Id_);
end if;
if Intake_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course_intake.Intake_Id =",Intake_Id_);
end if;

if Level_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Level_Id =",Level_Id_);
end if;
if Ielts_Minimum_Score_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Ielts_Minimum_Score =",Ielts_Minimum_Score_);
end if;
if Internship_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and course.Internship_Id =",Internship_Id_);
end if;


SET @query = Concat("SELECT Course_Id,Course_Name,country.Country_Id,University_Name
From course 
 inner join country  on course.Country_Id = country.Country_Id
 inner join university on course.University_Id = university.University_Id 
 
 where course.DeleteStatus = false and country.DeleteStatus = false ",SearchbyName_Value," order by course.Course_Name asc ");
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into db_logs values(1,@query,1,1);
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_DefaultDepartmentStatus_Typeahead`(In Branch_Id_ int, Department_Id_ int)
BEGIN
SELECT
Default_Status_Id,Default_Status_Name
from branch 
where Branch_Id=Branch_Id_ and  Default_Department_Id=Department_Id_ and branch.Is_Delete=false ;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_DefaultDepartment_User_Typeahead`(Department_Id_ int)
BEGIN
select
 Default_Department_Id,Default_Department_Name,Default_User_Id,Default_User_Name
from branch 
where Default_Department_Id=Department_Id_ and Is_Delete=0;  
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_DefultUser_Typeahead`(In Branch_Id_ int,Department_Id_ int)
BEGIN
SELECT
User_Details_Id,User_Details_Name
from user_details  where Branch_Id=Branch_Id_ and Department_Id = Department_Id_ and  DeleteStatus=0; 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department`( In Department_Name_ varchar(100))
Begin 
 set Department_Name_ = Concat( '%',Department_Name_ ,'%');
 SELECT Department_Id,
Department_Name,
FollowUp,
Status,Transfer_Method_Id,
Department_Order,Department_Status_Id,
Color,Color_Type_Id,Color_Type_Name From Department where Department_Name like Department_Name_ and Is_Delete=false 
Order by Department_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_Status`( In Department_Status_Name_ varchar(100))
Begin 
 set Department_Status_Name_ = Concat( '%',Department_Status_Name_ ,'%');
 SELECT Department_Status_Id,
Department_Status_Name,
Status_Order,
Editable,
Color,Status_Type_Id,Status_Type_Name
 From Department_Status where Department_Status_Name like Department_Status_Name_
 and Is_Delete=false 
Order by Department_Status_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_Status_Typeahead`(In Department_Id_ int,

Department_Status_Name_ varchar(100))
BEGIN
set Department_Status_Name_ = Concat( '%',Department_Status_Name_ ,'%');
select
 Department_Status_Name,Department_Status_Id ,Department_Status.Status_Type_Id,Department_Status.Status_Type_Name
 from Department_Status
 inner join Status_Selection
 on Department_Status.Department_Status_Id=Status_Selection.Status_Id
 and Status_Selection.Department_Id=Department_Id_
 where Department_Status_Name like Department_Status_Name_ 
 and Department_Status.Is_Delete=false
 ORDER BY Department_Status_Name Asc 
 ;
 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_Transfer_Status_Typeahead`(In Department_Id_ int,

Department_Status_Name_ varchar(100))
BEGIN

 set Department_Status_Name_ = Concat( '%',Department_Status_Name_ ,'%');
select
 Department_Status_Name,Department_Status_Id 
 from Department_Status
 inner join Status_Selection
 on Department_Status.Department_Status_Id=Status_Selection.Status_Id
 and Status_Selection.Department_Id=Department_Id_
 where Department_Status_Name like Department_Status_Name_ 
 and Department_Status.Is_Delete=false
 ORDER BY Department_Status_Name Asc 
 ;
 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_Typeahead`( Student_Id_ int)
BEGIN
SELECT
Department.Department_Id,
Department_Name,Department.FollowUp Department_FollowUp
from Department 
where  Department.Is_Delete=false 
and Department_Id in (select distinct(Department)
from student_followup where Student_Id=Student_Id_ )

 ORDER BY Department_Order Asc ;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_Typeahead_Tasknew`( Student_Id_ int)
BEGIN
SELECT
 Department ,Dept_Name
from student_followup where Student_Id=Student_Id_ and ifnull(First_Time_Dept,0) =1; 

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_User_Typeahead`(IN Branch_Id_ int,
Department_Id_ int,Users_Name_ varchar(100))
BEGIN
set Users_Name_ = Concat( '%',Users_Name_ ,'%');
/*select
 distinct user_details.User_Details_Id,User_Details_Name
from user_details
 inner join User_Department on user_details.User_Details_Id=User_Department.User_Id  and user_details.Branch_Id=Branch_Id_
 and User_Department.Department_Id=Department_Id_ and user_department.Branch_Id=Branch_Id_
where User_Details_Name like Users_Name_  and user_details.DeleteStatus=false and user_details.Working_Status=1
 ORDER BY User_Details_Name Asc ;*/
 select
 user_details.User_Details_Id,User_Details_Name
from user_details
 where user_details.Branch_Id=Branch_Id_
 and Department_Id=Department_Id_
and User_Details_Name like Users_Name_  and user_details.DeleteStatus=false and user_details.Working_Status=1
 ORDER BY User_Details_Name Asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_User_Typeahead_New`(IN Branch_Id_ int,
Department_Id_ int,Users_Name_ varchar(100),Usertype_ int)
BEGIN

set Users_Name_ = Concat( '%',Users_Name_ ,'%');
/*select
 distinct user_details.User_Details_Id,User_Details_Name
from user_details
 inner join User_Department on user_details.User_Details_Id=User_Department.User_Id  and user_details.Branch_Id=Branch_Id_
 and User_Department.Department_Id=Department_Id_ and user_department.Branch_Id=Branch_Id_
where User_Details_Name like Users_Name_  and user_details.DeleteStatus=false and user_details.Working_Status=1
 ORDER BY User_Details_Name Asc ;*/
 if (Usertype_=1) then
 select
 user_details.User_Details_Id,User_Details_Name
from user_details
 where
 #user_details.Branch_Id=Branch_Id_
# and Department_Id=Department_Id_
 User_Details_Name like Users_Name_  and user_details.DeleteStatus=false and user_details.Working_Status=1
 ORDER BY User_Details_Name Asc ; 
 else 
 select
 user_details.User_Details_Id,User_Details_Name
from user_details
 where user_details.Branch_Id=Branch_Id_
 and Department_Id=Department_Id_
and User_Details_Name like Users_Name_  and user_details.DeleteStatus=false and user_details.Working_Status=1
 ORDER BY User_Details_Name Asc ;
 end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_User_Typeahead_Task`(IN Department_Id_ int)
BEGIN
 select
 user_details.User_Details_Id,User_Details_Name
from user_details
 where Department_Id=Department_Id_  and user_details.DeleteStatus=false and user_details.Working_Status=1
 ORDER BY User_Details_Name Asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Department_User_Typeahead_Tasknew`(IN Department_Id_ int,Student_Id_ int)
BEGIN
select
 User_Id,UserName
from student_followup 
where Student_Id=Student_Id_ and Department=Department_Id_ and ifnull(First_Time_Dept,0) =1;  
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Document`( In Student_Id_ int)
Begin 
 SELECT * From student_document where Student_Id = Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Documentation_Report`(In Phone_Number_ varchar(25),User_id_ int)
BEGIN
declare SearchbyNumber_Value varchar(500);
declare Alternative_Phone_ varchar(25);
 set SearchbyNumber_Value = replace(replace(SearchbyNumber_Value,'+',''),' ','');
SET SearchbyNumber_Value = Concat(" and replace(replace(student.Phone_Number,'+',''),' ','') like '%",Phone_Number_,"%'
     or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",Phone_Number_,"%' or replace(replace(student.Alternative_Phone_Number,'+',''),' ','') like '%",Phone_Number_,"%' ") ;
SET @query = Concat( "select student.Student_Id,
student.Student_Name,student.Phone_Number,student.Alternative_Phone_Number,student.Remark,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,
    (Date_Format(student.Entry_Date,'%d-%m-%Y')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Department.Department_Name,Department.FollowUp,Department_Status.Department_Status_Name,T.User_Details_Name,
B.User_Details_Name Registered_By_Name,
Branch.Branch_Name,Is_Registered,user_details.User_Details_Name As Created_By_Name,Whatsapp
from student
inner join Department on Department.Department_Id= student.Department  
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Branch
inner join Department_Status on Department_Status.Department_Status_Id=student.Status
inner join user_details as T on T.User_Details_Id=student.User_Id
inner join user_details as B on B.User_Details_Id=student.Created_By
where student.DeleteStatus=0 and student.student_id in (select distinct Student_Id from student_followup where By_User_Id=" , User_id_ ,")",SearchbyNumber_Value," 
order by student.Phone_Number");
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
select 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_DocumentName`( In Document_Name_ varchar(45))
Begin 
 set Document_Name_ = Concat( '%',Document_Name_ ,'%');
 SELECT Document_Id,
Document_Name From document where Document_Name like Document_Name_ and DeleteStatus=false order by Document_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Duration`( In Duration_Name_ varchar(100))
Begin 
 set Duration_Name_ = Concat( '%',Duration_Name_ ,'%');
 SELECT Duration_Id,
Duration_Name From Duration where Duration_Name like Duration_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Efficiency_Count_Report`(In Fromdate_ date,Todate_ date,Branch_ int,
By_User_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Branch =",Branch_);
end if;

	set Search_Date_=concat( SearchbyName_Value," and student.Next_FollowUp_Date >= '", Fromdate_ ,"' and  student.Next_FollowUp_Date <= '", Todate_,"'");
	set Search_Date_union=concat( SearchbyName_Value," and  student.Entry_Date < '", Fromdate_,"'");
    
SET @query = Concat("select count(student_followup.Student_Id) Count,Date_Format(Entry_Date,'%H') Entry_Date
from student_followup 
	inner join user_details as B on B.User_Details_Id=student_followup.By_User_Id 
    inner join Branch on Branch.Branch_Id= Student_followup.Branch
    and date(student_followup.Entry_Date )
    and B.User_Details_Id= '", By_User_,"'
    and Branch.Branch_Id= '", Branch_,"'
    group by FollowUp_Difference,By_User_Id
    "
    );	 
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Employee_Summary`(In Fromdate_ date,
 Todate_ date,Login_User_Id_ int,
 Is_Date_Check_ tinyint,Branch_ int
 )
BEGIN
#select 1;
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
set Search_Date_=''; set SearchbyName_Value='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);


if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
 if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;

if User_Type_=2 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;

SET @query =concat ( "select Followup_Branch_Name Branch,To_User_Name Assigned_To,sum(Data_Count) as No_of_Students,sum(Registration_Count) as Registration_Count ,
sum(Total) as Receipt_Amount
from (
 select To_User_Name,count(student.Student_Id) as Data_Count,
sum(student.Is_Registered) as Registration_Count, 0 as Total,Followup_Branch_Name
from  student
where student.DeleteStatus=0    ",Search_Date_,SearchbyName_Value,"  
group by student.To_User_Id,Followup_Branch_Id
  union
select To_User_Name,0 as Data_Count,
0 as Registration_Count, sum(fees_receipt.Amount) as Total,Followup_Branch_Name
from student
left join fees_receipt on fees_receipt.Student_Id=student.Student_Id
where student.DeleteStatus=0   ",Search_Date_,SearchbyName_Value,"  
group by student.To_User_Id,Followup_Branch_Id) as ld
   group by To_User_Name,Followup_Branch_Name
order by To_User_Name,Followup_Branch_Name ");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Enquiry_Conversion`(In Fromdate_ date, Todate_ date,Login_User_Id_ int,Is_Date_Check_ tinyint,Branch_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);


set Search_Date_=''; set SearchbyName_Value='';
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);

if Is_Date_Check_=true then
set Search_Date_=concat(SearchbyName_Value, " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
 if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
SET @query = Concat( " select Followup_Branch_Name as Branch,Enquiry_Source_Name as Enquiry_Source, sum(Data_Count) as No_of_Students,
sum(Registration_Count) as Registration,sum(Total) as ReceivedAmount
from (
select Enquiry_Source_Name,count(student.Student_Id) as Data_Count,
sum(student.Is_Registered) as Registration_Count, 0 as Total,Followup_Branch_Name
from student 
	where student.DeleteStatus=0   ",Search_Date_,"",SearchbyName_Value," ",Department_String_," and student.Role_Id  in(",RoleId_,")
	group by Enquiry_Source_Id,Followup_Branch_Id
   union
select Enquiry_Source_Name,0 as Data_Count,
0 as Registration_Count, sum(fees_receipt.Amount) as Total,Followup_Branch_Name
from student 
left join fees_receipt on fees_receipt.Student_Id=student.Student_Id 
	where student.DeleteStatus=0  and fees_receipt.Delete_Status=0 ",Search_Date_,"",SearchbyName_Value," ",Department_String_," and student.Role_Id  in(",RoleId_,")
	group by Enquiry_Source_Id,Followup_Branch_Id) as ld
   group by Enquiry_Source_Name,Followup_Branch_Name 
order by Enquiry_Source_Name,Followup_Branch_Name");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Enquiry_Source`( In Enquiry_Source_Name_ varchar(45))
Begin 
 set Enquiry_Source_Name_ = Concat( '%',Enquiry_Source_Name_ ,'%');
 SELECT Enquiry_Source_Id,
Enquiry_Source_Name,Agent_Status From Enquiry_Source where Enquiry_Source_Name like Enquiry_Source_Name_ 
and DeleteStatus=false 
order by  Enquiry_Source_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Enquiry_Source_Report`(In Search_Fromdate_ date,Todate_ date,Is_Date_Check_ tinyint,Branch_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';

if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Branch =",Branch_);
end if;

if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(student.Entry_Date) >= '", Search_Fromdate_,"' and  date(student.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;

SET @query = Concat( " select count(student.Student_Id) Enquiry_Source_Count,Enquiry_Source_Name,Branch_Name
from student 
	inner join enquiry_source on enquiry_source.Enquiry_Source_Id= student.Enquiry_Source_Id
    inner join Branch on Branch.Branch_Id= student.Branch
	where student.DeleteStatus=0   ",Page_Index1_-1,"",PageSize,"
	 group by student.Branch ");
	 
PREPARE QUERY FROM @query;
#select @query;


EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Enquiry_Source_Summary_Track`( Fromdate_ date, Todate_ date,Login_User_Id_ int,Is_Date_Check_ tinyint,Branch_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
set Search_Date_=''; set SearchbyName_Value='';
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
SET @query = Concat( " select Followup_Branch_Id,Followup_Branch_Name Branch, Enquiry_Source_Name Enquiry_Source,count(student.Student_Id) as No_of_Students from
		student 
		where student.DeleteStatus=0   ", Search_Date_ ," ",SearchbyName_Value," ",Department_String_,"
		and student.Role_Id in(",RoleId_,") 
		group by Enquiry_Source_Id,Followup_Branch_Name
		order by Branch,To_User_Id
    ");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
#select @query;

EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees`( In Fees_Name_ varchar(45))
Begin 
 set Fees_Name_ = Concat( '%',Fees_Name_ ,'%');
 SELECT Fees_Id,
Fees_Name From fees where Fees_Name like Fees_Name_ and DeleteStatus=false order by Fees_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Data`( In Fees_Name_ varchar(45))
Begin 
 set Fees_Name_ = Concat( '%',Fees_Name_ ,'%');
 SELECT Fees_Id,
Fees_Name From fees where Fees_Name like Fees_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Receipt_Report`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,To_Account_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,Fees_Id int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare User_Type_ int;declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
  set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);

if(SearchbyName_ !='0') then
if Search_By_=1 then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
end if;
end if;
if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Department_);
end if;
if To_Account_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.To_Account_Id =",To_Account_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and  fees_receipt.Fee_Receipt_Branch =",Branch_);
end if;
if User_Type_=2 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.User_Id =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Fees_Receipt.User_Id =",By_User_);
end if;
if Fees_Id>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.Fees_Id =",Fees_Id);
end if;
if Is_Date_Check_=true then
set Search_Date_=concat(SearchbyName_Value, " and date(Fees_Receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(Fees_Receipt.Entry_Date) <= '", Todate_,"'");

ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat( "select student.Student_Id,
student.Student_Name,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,
    (Date_Format(Fees_Receipt.Entry_Date,'%d-%m-%Y  %h:%i')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Department.Department_Name,Department.FollowUp,Department_Status.Department_Status_Name,T.User_Details_Name,
B.User_Details_Name Registered_By_Name,Branch.Branch_Name,Is_Registered,user_details.User_Details_Name As Created_By_Name,
    F_user.User_Details_Name As Fees_Collected_By,Fees_Receipt.Amount,Fees_Receipt.Description,Fees.Fees_Name ,By_User_Id,Fees_Receipt.User_Id as User_Id_,Fees_Receipt.To_Account_Id,
    Fees_Receipt.To_Account_Name,student.Student_Id
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
left join user_details as B on B.User_Details_Id=student.Registered_By
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join user_details as F_user on F_user.User_Details_Id=Fees_Receipt.User_Id
inner join Fees on Fees.Fees_Id=Fees_Receipt.Fees_Id
    where student.DeleteStatus=0 and  fees_receipt.Delete_Status=0  ",SearchbyName_Value," ",Search_Date_,"

order by Fees_Receipt.Entry_Date ");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Intake`( In Intake_Name_ varchar(100))
Begin 
 set Intake_Name_ = Concat( '%',Intake_Name_ ,'%');
 SELECT Intake_Id,
Intake_Name From Intake where Intake_Name like Intake_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Internship`( In Internship_Name_ varchar(100))
Begin 
 set Internship_Name_ = Concat( '%',Internship_Name_ ,'%');
 SELECT Internship_Id,
Internship_Name From Internship where Internship_Name like Internship_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Level_Detail`( In Level_Detail_Name_ varchar(100))
Begin 
 set Level_Detail_Name_ = Concat( '%',Level_Detail_Name_ ,'%');
 SELECT Level_Detail_Id,
Level_Detail_Name From Level_Detail where Level_Detail_Name like Level_Detail_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Notification`( In Login_User_ Int,notification_type_ int,Sort_By_ int,Page_Index1_ int,Page_Index2_ int)
Begin
declare pos1frm int;declare pos1to int;declare pos2frm int;declare pos2to int; declare PageSize int;
declare SearchbyName_Value varchar(2000);
  set pos1frm=0; set pos1to=0; set pos2frm=0; set pos2to=0; set PageSize=10; set SearchbyName_Value='';
if Login_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Notification.To_User =",Login_User_);
end if;
if notification_type_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Notification.Entry_Type =",notification_type_);
end if;
if Sort_By_ =1 then
SET SearchbyName_Value =concat(SearchbyName_Value," and ifnull(Notification.Read_Status,0) =",0);
end if;
SET @query = Concat( " select Notification_Id ,From_User , From_User_Name ,To_User , To_User_Name ,Status_Id ,Status_Name ,
View_Status,Remark ,(Date_Format(Entry_Date,'%d-%m-%Y %h:%i')) As Entry_Date,Student_Id , Student_Name ,Description,Entry_Type,Read_Status
from Notification
where  Notification.DeleteStatus=false ",SearchbyName_Value,"
order by Notification_Id DESC LIMIT ",Page_Index1_ -1,",",PageSize," ");
PREPARE QUERY FROM @query;
#insert into data_log_ values(0,@query ,'' );
#select @query;
EXECUTE QUERY;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Passport_Expiry_Report`(In Fromdate_ date,Todate_ date,By_User_ int,Login_User_Id_ int,look_In_Date_Value tinyint)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);declare Department_String_ varchar(4000);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;declare RoleId_ varchar(100);
declare pos2to int; declare PageSize int;declare User_Type_ int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';

  set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
 set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);

 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 
 if look_In_Date_Value=true then
	set Search_Date_=concat( SearchbyName_Value," and date(student.Passport_Todate) >= '", Fromdate_ ,"' and  date(student.Passport_Todate) <= '", Todate_,"'");
else	
set Search_Date_= "and 1 =1 ";
end if;
#insert into data_log_ value(0,Department_String_student_followup_,'');
SET @query = Concat("select Student_Name,Phone_Number,Passport_No ,(Date_Format(student.Passport_fromdate,'%d-%m-%Y')) As Start_Date,
(Date_Format(student.Passport_Todate,'%d-%m-%Y')) AS Expiry_Date,Passport_Id,user_details.User_Details_Name as Counsilor_User,student.Student_Id
from student

	Left join user_details on student.Counsilor_User =user_details.User_Details_Id
    where student.DeleteStatus=0 and Passport_Id =1 ",Search_Date_," ",SearchbyName_Value," ",Department_String_," 
	and student.Role_Id in(",RoleId_,")
   order by Student_Id ");
PREPARE QUERY FROM @query;
#select @query;

#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Receipt`( In Student_Id_ int)
Begin 
 SELECT Fees_Receipt_Id,
Student_Id,
(Date_Format(Entry_Date,'%Y-%m-%d')) As Entry_date,
(Date_Format(Entry_Date,'%d-%m-%Y')) As RecepitEntry_Date,
User_Details_Name,
Description,
Fees_Name,
fees_receipt.Fees_Id,Course_Name,Application_details_Id,
Amount,Currency,To_Account_Name,To_Account_Id,Fees_Receipt_Status_Name,
(Date_Format(Actual_Entry_Date,'%d-%m-%Y %h:%i')) As Actual_Entry_Date,Voucher_No,
Fees_Receipt_Status,Refund_Request_Status


 From fees_receipt 
 inner join fees on fees_receipt.Fees_Id= fees.Fees_Id  
 inner join Fees_Receipt_Status on fees_receipt.Fees_Receipt_Status=Fees_Receipt_Status.Fees_Receipt_Status_Id
inner join user_details on fees_receipt.User_Id=user_details.User_Details_Id 
where  Student_Id=Student_Id_ and Delete_Status=false
 order by Fees_Receipt_Id asc ;
 select Fees_Id,Fees_Name from fees where DeleteStatus=false order by Fees_Name asc;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Receipt_Confirmation`(In Fromdate_ date, Todate_ date,Login_User_Id_ int,Is_Date_Check_ tinyint,Branch_ int,Fees_Receipt_Status_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);


set Search_Date_=''; set SearchbyName_Value='';
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);

if Is_Date_Check_=true then
set Search_Date_=concat(SearchbyName_Value, " and date(fees_receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(fees_receipt.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
 if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;

 if Fees_Receipt_Status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.Fees_Receipt_Status =",Fees_Receipt_Status_);
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
SET @query = Concat("select student.Student_Id,
student.Student_Name,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,Application_details_Id,
    (Date_Format(Fees_Receipt.Entry_Date,'%d-%m-%Y')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Branch.Branch_Name,Fees_Receipt_Status_Name,Fees_Receipt_Status,Fees_Receipt_Id,
    Fees_Receipt.Amount,Fees.Fees_Name 
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_,"
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
left join user_details as B on B.User_Details_Id=student.Registered_By
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join Fees_Receipt_Status on Fees_Receipt_Status.Fees_Receipt_Status_Id=Fees_Receipt.Fees_Receipt_Status
inner join user_details as F_user on F_user.User_Details_Id=Fees_Receipt.User_Id
inner join Fees on Fees.Fees_Id=Fees_Receipt.Fees_Id 
    where student.DeleteStatus=0 and  fees_receipt.Delete_Status=0  ",SearchbyName_Value," ",Search_Date_,"
and T.Role_Id in(",RoleId_,")
order by Fees_Receipt.Entry_Date ");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Refund_Approval`(In Fromdate_ date, Todate_ date,Login_User_Id_ int,Is_Date_Check_ tinyint,Branch_ int,Fees_Receipt_Status_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);


set Search_Date_=''; set SearchbyName_Value='';
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);

if Is_Date_Check_=true then
set Search_Date_=concat(SearchbyName_Value, " and date(fees_receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(fees_receipt.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
 if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;

 if Fees_Receipt_Status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.Fees_Receipt_Status =",Fees_Receipt_Status_);
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
SET @query = Concat("select student.Student_Id,
student.Student_Name,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,
    (Date_Format(Fees_Receipt.Entry_Date,'%d-%m-%Y ')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Branch.Branch_Name,Fees_Receipt_Status_Name,Fees_Receipt_Status,Fees_Receipt_Id,
    Fees_Receipt.Amount,Fees.Fees_Name,Fees_Receipt_Status_Name 
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_,"
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
left join user_details as B on B.User_Details_Id=student.Registered_By
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join Fees_Receipt_Status on Fees_Receipt_Status.Fees_Receipt_Status_Id=Fees_Receipt.Fees_Receipt_Status
inner join user_details as F_user on F_user.User_Details_Id=Fees_Receipt.User_Id
inner join Fees on Fees.Fees_Id=Fees_Receipt.Fees_Id 
    where student.DeleteStatus=0 and  fees_receipt.Delete_Status=0  ",SearchbyName_Value," ",Search_Date_," and Fees_Receipt.Refund_Request_Status=2 
and T.Role_Id in(",RoleId_,")
order by Fees_Receipt.Entry_Date ");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Refund_Confirmation`(In Fromdate_ date, Todate_ date,Login_User_Id_ int,Is_Date_Check_ tinyint,Branch_ int,Fees_Receipt_Status_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);


set Search_Date_=''; set SearchbyName_Value='';
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);

if Is_Date_Check_=true then
set Search_Date_=concat(SearchbyName_Value, " and date(fees_receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(fees_receipt.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
 if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;

 if Fees_Receipt_Status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.Fees_Receipt_Status =",Fees_Receipt_Status_);
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
SET @query = Concat("select student.Student_Id,
student.Student_Name,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,
    (Date_Format(Fees_Receipt.Entry_Date,'%d-%m-%Y ')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Branch.Branch_Name,Fees_Receipt_Status_Name,Fees_Receipt_Status,Fees_Receipt_Id,
    Fees_Receipt.Amount,Fees.Fees_Name,Fees_Receipt_Status_Name ,Fees_Receipt.Comment
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_,"
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
left join user_details as B on B.User_Details_Id=student.Registered_By
inner join Fees_Receipt on Fees_Receipt.Student_Id=student.Student_Id
inner join Fees_Receipt_Status on Fees_Receipt_Status.Fees_Receipt_Status_Id=Fees_Receipt.Fees_Receipt_Status
inner join user_details as F_user on F_user.User_Details_Id=Fees_Receipt.User_Id
inner join Fees on Fees.Fees_Id=Fees_Receipt.Fees_Id 
    where student.DeleteStatus=0 and  fees_receipt.Delete_Status=0 and Fees_Receipt.Fees_Receipt_Status in(4,5,6)    ",SearchbyName_Value," ",Search_Date_,"
and T.Role_Id in(",RoleId_,")
order by Fees_Receipt.Entry_Date ");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Registration_Report`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,View_Branch_ varchar(250))
BEGIN
declare RoleId_ varchar(100);declare Department_String_ varchar(5000);
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare User_Type_ int;declare Department_String_Registered_By varchar(5000);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
if(SearchbyName_ !='0') then
	if Search_By_=1 then
	SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
/*if View_Branch_!="" then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_Branch =",View_Branch_);
end if;*/

if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Department_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and  student.Registration_Branch =",Branch_);
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",By_User_);
end if;
if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_Registered_By =REPLACE(Department_String_,'By_User_Id','Registered_By');
#insert into data_log_ value(0,Department_String_Registered_By,RoleId_);
SET @query = Concat( "select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,
(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,B.User_Details_Name Registered_By,student.Student_Name Student,
student.Phone_Number Mobile,D.Branch_Name Branch, (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Follow_Up_On,Department.Department_Name Department,
Department_Status.Department_Status_Name Status,T.User_Details_Name To_Staff,user_details.User_Details_Name As Created_By,
(Date_Format(student.Entry_Date,'%d-%m-%Y   %h:%i')) As Created_On,student.Remark,student.Student_Id
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch as D on D.Branch_Id= student.Registration_Branch
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
inner join user_details as B on B.User_Details_Id=student.Registered_By
where student.DeleteStatus=0   and student.Is_Registered=1  ",SearchbyName_Value," ",Search_Date_," and student.Registered_Branch='",View_Branch_,"'
)as lds )as ldtwo
order by tp ");
#",Department_String_Registered_By," and T.Role_Id in(",RoleId_,")
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
select @query;
#inner join Branch on Branch.Branch_Id= student.Branch
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Remarks`( In Remarks_Name_ varchar(100))
Begin 
 set Remarks_Name_ = Concat( '%',Remarks_Name_ ,'%');
 SELECT Remarks_Id,
Remarks_Name From Remarks where Remarks_Name like Remarks_Name_ and DeleteStatus=false 
order by Remarks_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,Enquiry_For_ int,Class_ int,Sort_By_ int,Intake_ int,Intake_Year_ int,Agent_ int,
By_User_ int,By_User_Id_ int,Status_Id_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,Register_Value int,Enquiry_Source_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;declare Search_Date_Follow_ varchar(500);
declare pos2to int; declare PageSize int;declare Search_By_Registered varchar(500);declare User_Status int;declare more_info int;
declare closedentries varchar(1000); declare missedcount varchar(2000);declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
declare Search_Order varchar(100);declare Alltimdept_id_ varchar(500);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10; set more_info=0; 
 set SearchbyName_Value='';
 set Search_Date_=''; set Search_Date_Follow_='';
 set closedentries='';
/*set pos1frm = ((Page_Index1_ * PageSize) + 1 - RowCount);set pos1to = (((Page_Index1_ + 1) * PageSize) + RowCount);
    if (RowCount2 > 0 && RowCount > 0 && Page_Index1_ > 0)    then set pos1frm = 0;set pos1to = 0; end if;
set pos2frm = ((Page_Index2_ * PageSize) + 1 - RowCount); set pos2to = (((Page_Index2_ + 1) * PageSize) + RowCount);
       if (RowCount2 > 0 && RowCount > 0 && Page_Index1_ > 0)    then set pos2frm = 0;set pos2to = 0; end if;*/
    #set pos2frm = 0;#set pos2to = 10;
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
SET Alltimdept_id_ =(SELECT GROUP_CONCAT(Department_Id SEPARATOR ',') FROM all_time_departments where User_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Status= (select Working_Status from user_details where User_Details_Id=Login_User_Id_ ); 
if Isnull(Alltimdept_id_) then set Alltimdept_id_ = 0; end if;
if(SearchbyName_ !='') then
 set Is_Date_Check_ = false;
set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
SET SearchbyName_Value =   Concat( SearchbyName_Value," and (student.Student_Name like '%",SearchbyName_ ,"%' or 
replace(replace(student.Phone_Number,'+',''),' ','') like '%",SearchbyName_ ,"%'
or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",SearchbyName_ ,"%' or
replace(replace(student.Alternative_Phone_Number,'+',''),' ','') like '%",SearchbyName_ ,"%' or
student.Email like '%",SearchbyName_ ,"%' or student.Alternative_Email like '%",SearchbyName_ ,"%') ") ;
end if;
if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Department_);
/*else 
	if(SearchbyName_ !='') then
		set Is_Date_Check_=false;
	else
		set closedentries=concat(" and student.FollowUp =1");
	end if;*/
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;
if Enquiry_For_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiryfor_Id =",Enquiry_For_);
end if;
if Class_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Class_Id =",Class_);
end if;
if Intake_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Proceeding_Intake_Id =",Intake_);
end if;
if Intake_Year_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Proceeding_Year_Id =",Intake_Year_);
end if;
if Agent_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Proceeding_Partner_Id =",Agent_);
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;
if By_User_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.By_User_Id =",By_User_Id_);
end if;
if Status_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status_Id =",Status_Id_);
end if;

if Enquiry_Source_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiry_Source_Id =",Enquiry_Source_);
end if;

if Sort_By_=1 then
	Set Search_Order=concat(Search_Order,"  ,student.Student_Name asc" );
elseif Sort_By_=2 then
	Set Search_Order=concat(Search_Order,"  ,student.Student_Name desc" );
elseif Sort_By_=3 then
	Set Search_Order=concat(Search_Order,"  ,student.FollowUp_Entrydate asc" );
else
	Set Search_Order=concat(Search_Order,"  ,student.FollowUp_Entrydate desc" );
end if;

if Register_Value=2 then
Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Is_Registered= ",1) ;
    elseif Register_Value=3 then
    Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Is_Registered= ",0) ;
    end if;

/*if(SearchbyName_ !='') then
	set Is_Date_Check_=false;
		#set closedentries=concat(" and Department_FollowUP =0");
		else
		set closedentries=concat(" and student.FollowUp =1");
		end if;*/
        
        #insert into data_log_ value(0,SearchbyName_Value,'');
        
if User_Status=1 then
	if Is_Date_Check_=true then
			set Search_Date_=concat( " and  student.Next_FollowUp_Date <= '", Todate_,"'");
           #set Search_Date_=concat( " and date(student.Next_FollowUp_Date) >= '", Fromdate_ ,"' and   date(student.Next_FollowUp_Date) <= '", Todate_,"'");
				set Search_Date_Follow_= concat( " and date(student.Next_FollowUp_Date) >= '", Fromdate_ ,"' and  date(student.Next_FollowUp_Date) <= '", Todate_,"'");
				set closedentries=concat(" and FollowUp =1");
			set missedcount=concat("
				union 
				select 3 tp,count(student.Student_Id) Student_Id,'' Student_Name
				,'','', now(),now(),'',1,'','','','',1,1,1,1,'','','' ,'','',''
				from student  
				where student.DeleteStatus=0 and FollowUp=1    and date(student.Next_FollowUp_Date) <'",  Fromdate_,"' ",Department_String_,SearchbyName_Value,"
				and  (student.Role_Id  in(",RoleId_,") or  ( student.User_List like '%*",Login_User_Id_,"*%' and student.Followup_Department_Id in(",Alltimdept_id_,") ))  
				");
		#set Search_Date_union=concat( " and  Leads.Next_FollowUp_Date < '", Fromdate_,"'");
	ELSE
				set Search_Date_= "and 1 =1 ";
				set Search_Date_Follow_= "and 1 =1 ";
			set missedcount=concat("
				  union
				select 3 tp,0 Student_Id, ''
				,'','', now(),now(),'',1,'','','','',1,1,1,1,'','','','','','' ");
	end if;
		SET @query = Concat( "select * from ( select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,student.Student_Id,
			student.Student_Name,student.Phone_Number,student.Remark,(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
            (Date_Format(student.Next_FollowUp_Date,'%Y-%m-%d')) As Actual_Next_FollowUp_Date,
			Followup_Department_Name Department_Name,FollowUp,Department_Status_Name, To_User_Name User_Details_Name,
			Followup_Branch_Name Branch_Name,Client_Accounts_Name,Agent_Id,student.Is_Registered,1 as User_Status,0 as more_info,Country_Name,
            Send_Welcome_Mail_Status,Unique_Id,Class_Name,Color,Enquiry_Source_Name
			from student
		where student.DeleteStatus=0  ",Search_Date_," ",Department_String_,closedentries," ",SearchbyName_Value,"
		and (student.Role_Id  in(",RoleId_,") or  ( student.User_List like '%*",Login_User_Id_,"*%' and student.Followup_Department_Id in(",Alltimdept_id_,") ))",
		" order by unix_timestamp(date_format(Next_FollowUp_Date,'%Y-%m-%d'))  desc ,Student_Name asc LIMIT ",Page_Index1_-1 ,",",PageSize,") as one "
		,missedcount,
		" union
				select 4 tp,count(student.Student_Id) Student_Id,'' Student_Name
				,'','', now(),now(),'',1,'','','','',1,1,1,1,'','','','','',''
				from student
				where student.DeleteStatus=0 and FollowUp=1    ",Search_Date_Follow_," ",Department_String_,SearchbyName_Value,"
				and (student.Role_Id  in(",RoleId_,") or  ( student.User_List like '%*",Login_User_Id_,"*%' and student.Followup_Department_Id in(",Alltimdept_id_,") )) order by tp ,Next_FollowUp_Date;");
		#insert into db_logs values(0,CURDATE(),1,1, @query,'','');
		PREPARE QUERY FROM @query;
        #delete from data_log_;
		#insert into data_log_ value(0,@query,'');
		EXECUTE QUERY;
else
select 2 as User_Status;
end if;     
# LIMIT ",Page_Index1_-1 ,",",PageSize,"
#select @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Agent`(In From_Date_ datetime,To_Date_ datetime,Is_Date_Check_ Tinyint,Student_Name_ varchar(100),
Phone_Number_ varchar(25), Agent_Id_ int,Student_Status_Id_ int, Pointer_Start_ Varchar(10), Pointer_Stop_ Varchar(10), Page_Length_ Varchar(10))
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(4000);
set Search_Date_="";set SearchbyName_Value=""; 

if Is_Date_Check_=true then
	set Search_Date_=concat(SearchbyName_Value," and date(Student.Entry_Date) >= '", From_Date_ ,"' and  date(Student.Entry_Date) <= '", To_Date_,"'");
end if;
if Student_Name_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and Student.Student_Name like '%",Student_Name_ ,"%'") ;
end if;
if Phone_Number_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and Student.Phone_Number like '%",Phone_Number_ ,"%'") ;
end if;
if Agent_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Student.Agent_Id =",Agent_Id_);
end if;
if Student_Status_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Student.Student_Status_Id =",Student_Status_Id_);
end if;

/* inner join student_course_apply on Student.Student_Id = student_course_apply.Student_Id 
 inner join student_course_selection  on student_course_apply.Student_Course_Apply_Id = student_course_selection.Student_Course_Apply_Id 
 inner join course on student_course_selection.Course_Id = course.Course_Id */
 
SET @query = Concat("select * from (SELECT student.Student_Id,(Date_Format(student.Entry_Date,'%Y-%m-%d')) Entry_Date,student.Student_Name,student.Address1,
student.Email,student.Phone_Number,student.Agent_Id,client_accounts.Client_Accounts_Name,student_status.Student_Status_Name,
 CAST(CAST(ROW_NUMBER()OVER(ORDER BY Student.Student_Name DESC )AS UNSIGNED)AS SIGNED)AS RowNo
 From Student 

 inner join client_accounts on student.Agent_Id=client_accounts.Client_Accounts_Id
 inner join student_status on student.Student_Status_Id=student_status.Student_Status_Id
 
 where Student.DeleteStatus = false  ", Search_Date_ ,SearchbyName_Value," order by Student.Entry_Date desc  )
 as lds WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
 order by  RowNo LIMIT ",Page_Length_);
 
PREPARE QUERY FROM @query;

EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Count`(In Fromdate_ date,Todate_ date,RoleId_ varchar(100),Department_String varchar(1000),Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
if(SearchbyName_ !='0') then
	if Search_By_=1 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
end if;
if Department_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Department =",Department_);
end if;
if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Branch =",Branch_);
end if;
if By_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",By_User_);
end if;
if Is_Date_Check_=true then
	set Search_Date_=concat( " and student.Next_FollowUp_Date >= '", Fromdate_ ,"' and  student.Next_FollowUp_Date <= '", Todate_,"'");
	set Search_Date_union=concat( " and  student.Entry_Date < '", Fromdate_,"'");
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat(    "select B.User_Details_Name By_User,Department.Department_Name, count(student.Student_Id) Count
from student 
	inner join Department on Department.Department_Id= student.Department  ",Search_Date_," ",Department_String," 
	inner join user_details as B on B.User_Details_Id=student.By_User_Id 
and student.DeleteStatus=0  ",SearchbyName_Value,"  and B.Role_Id in(",RoleId_,") group by student.Department,By_User_Id 
 order by Count desc"
    );
	 
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Count_Track_Report`(In Fromdate_ date,
By_User_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';

SET @query = Concat("select count(student_followup.Student_Id) Count,Date_Format(Entry_Date,'%H') Entry_Date
from student_followup 
	inner join user_details as B on B.User_Details_Id=student_followup.By_User_Id and date(student_followup.Entry_Date )= '", Fromdate_,"'
    and B.User_Details_Id= '", By_User_,"'
    group by (Date_Format(Entry_Date,'%H')) order by Entry_Date asc"
    );	 
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Document`( In Student_Document_Name_ varchar(100))
Begin 
 set Student_Document_Name_ = Concat( '%',Student_Document_Name_ ,'%');
 SELECT Student_Document_Id,
Student_Id,
Document_Id From Student_Document where Student_Document_Name like Student_Document_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Import`(In From_Date_ datetime,To_Date_ datetime,Is_Date_Check_ Tinyint)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
declare Search_Date_union varchar(500);
#Declare Import_Master_Id_ int;
set Search_Date_="";set SearchbyName_Value=""; 
if Is_Date_Check_=true then
	set Search_Date_=concat(" and date(import_students_master.Entry_Date) >= '", From_Date_ ,"' and  date(import_students_master.Entry_Date) <= '", To_Date_,"'");
end if;

SET @query = Concat("SELECT User_Details_Name,(Date_Format(Entry_Date,'%Y-%m-%d')) Entry_Date
 From import_students_master ",Search_Date_," 
 inner join user_details  on  user_details.User_Details_Id = import_students_master.By_User_Id 
 order by import_students_master.Entry_Date desc ");
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into db_logs values(1,@query,1,1);
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Message`( In Student_Id_ varchar(100))
Begin 

 SELECT Student_Message_Id,
Student_Id,
Message_Detail From Student_Message where Student_Id=Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Old`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Status_Id_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,Register_Value int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare Search_By_Registered varchar(500);declare User_Status int;declare more_info int;
declare closedentries varchar(1000); declare missedcount varchar(1000);declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10; set more_info=0; 
 set SearchbyName_Value='';
 set Search_Date_='';
 set closedentries='';
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);

 
 set User_Status= (select Working_Status from user_details where User_Details_Id=Login_User_Id_ );
if(SearchbyName_ !='') then
#if Search_By_=1 then
 set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%' or  replace(replace(student.Phone_Number,'+',''),' ','') like '%",SearchbyName_ ,"%'
        or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",SearchbyName_ ,"%' or replace(replace(student.Alternative_Phone_Number,'+',''),' ','') like '%",SearchbyName_ ,"%' or  student.Email like '%",SearchbyName_ ,"%' or student.Alternative_Email like '%",SearchbyName_ ,"%' ") ;
#end if;
							/*    if Search_By_=2 then
							   set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
							   
							SET SearchbyName_Value =   Concat(SearchbyName_Value, " and replace(replace(student.Phone_Number,'+',''),' ','') like '%",SearchbyName_ ,"%'
									or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",SearchbyName_ ,"%' or replace(replace(student.Alternative_Phone_Number,'+',''),' ','') like '%",SearchbyName_ ,"%' ") ;
							end if;
							if Search_By_=3 then
							SET SearchbyName_Value =   Concat(SearchbyName_Value, " and student.Email like '%",SearchbyName_ ,"%'
							or student.Alternative_Email like '%",SearchbyName_ ,"%' ") ;
							end if;*/

end if;

if Register_Value=2 then
Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Is_Registered= ",1) ;
    elseif Register_Value=3 then
    Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Is_Registered= ",0) ;
    end if;
   
if Department_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Department =",Department_);
else 
	if(SearchbyName_ !='') then
		set Is_Date_Check_=false;
	else
		set closedentries=concat(" and student.FollowUp =1");
	end if;

end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Branch =",Branch_);
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",By_User_);
end if;
if Status_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status =",Status_Id_);
end if;
if(SearchbyName_ !='') then
	set Is_Date_Check_=false;
end if;
if Is_Date_Check_=true then
set Search_Date_=concat( " and date(student.Next_FollowUp_Date) >= '", Fromdate_ ,"' and  date(student.Next_FollowUp_Date) <= '", Todate_,"'");
set Search_Date_union=concat( " and  date(student.Next_FollowUp_Date) < '", Fromdate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
if User_Status=1 then
	if Is_Date_Check_=true then
		#inner join user_details on user_details.User_Details_Id=student.User_Id
		#inner join user_details as B on B.User_Details_Id=student.By_User_Id
		#B.User_Details_Name Registered_By_Name,
		set UnionQuery=concat(" union select * from(select  CAST(CAST(2 AS UNSIGNED) AS SIGNED)   as tp,student.Student_Id,
		student.Student_Name,student.Phone_Number,student.Remark,(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
		Department_Name,FollowUp,Department_Status_Name,User_Details_Name,
		CAST(CAST(ROW_NUMBER()OVER(ORDER BY student.Student_Id DESC,Student.Next_FollowUp_Date desc)AS UNSIGNED)AS SIGNED)AS
		RowNo,Branch_Name,Client_Accounts_Name,Agent_Id,student.Is_Registered,1 as User_Status,0 as more_info,Country_Name,Send_Welcome_Mail_Status
		from student
		where FollowUp=1 and student.DeleteStatus=0 ",Search_Date_union ," ",Department_String_,"
		and student.Role_Id in(",RoleId_,") ",SearchbyName_Value, " " ,Search_Date_union,"
		)as lds WHERE RowNo >=",RowCount," AND RowNo<= ",RowCount2
		);
		set missedcount=concat("
		union 
		select 3 tp,count(student.Student_Id) Student_Id,'' Student_Name,'','', now(),'',1,'','',1,'','',1,1,1,1,'','' 
		from student
		where student.Role_Id in(",RoleId_,") ",Department_String_,"
		and student.DeleteStatus=0 and FollowUp=1   ",SearchbyName_Value," and date(student.Next_FollowUp_Date) <'",  Fromdate_,"'");
	else
		set missedcount=concat("
		union 
		select 3 tp,0 Student_Id, '','','', now(),'',1,'','',1,'','',1,1,1,1,'','' ");
	end if;
	SET @query = Concat( "select * from ( select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,student.Student_Id,
	student.Student_Name,student.Phone_Number,student.Remark,(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
	Department_Name,FollowUp,Department_Status_Name, User_Details_Name,
	CAST(CAST(ROW_NUMBER()OVER(ORDER BY student.Student_Id DESC,Student.Next_FollowUp_Date desc)AS UNSIGNED)AS SIGNED)AS
	RowNo,Branch_Name,Client_Accounts_Name,Agent_Id,student.Is_Registered,1 as User_Status,0 as more_info,Country_Name,Send_Welcome_Mail_Status
	from student
	where student.DeleteStatus=0 ",Search_Date_," ",Department_String_,closedentries,"
	and student.Role_Id in(",RoleId_,") ",SearchbyName_Value,"
	)as lds WHERE RowNo >=",Page_Index1_," AND RowNo<= ",Page_Index2_,UnionQuery,"
	)as ldtwo order by tp, RowNo LIMIT ",PageSize ,") as ldthree " , missedcount," union
	select 4 tp,count(student.Student_Id) Student_Id,'' Student_Name,'','', now(),'',1,'','',1,'','',1,1,1,1,'','' 
	from student
	where student.DeleteStatus=0 and FollowUp=1 and student.Role_Id in(",RoleId_,")  ",Search_Date_,Department_String_,SearchbyName_Value,"
	order by tp ,Next_FollowUp_Date asc");
	PREPARE QUERY FROM @query;
	#select @query;
	EXECUTE QUERY;
else
 select 2 as User_Status;
 end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Report`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Enquiry_Source_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,Is_Old_Datas_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,remarks_ int,To_User_ int,Status_Id_ int,Register_Value int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(1000);declare Search_Old_Date_ varchar(1000);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
   set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
if(SearchbyName_ !='0') then
	if Search_By_=1 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
    if Search_By_=2 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Email like '%",SearchbyName_ ,"%'") ;
	end if;
    if Search_By_=3 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Phone_Number like '%",SearchbyName_ ,"%'") ;
	end if;
end if;
if Department_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Department_);
end if;

if Enquiry_Source_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiry_Source_Id =",Enquiry_Source_);
end if;

if Register_Value=2 then
Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Is_Registered= ",1) ;
    elseif Register_Value=3 then
    Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Is_Registered= ",0) ;
    end if;
if Status_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status_Id =",Status_Id_);
end if;
if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;
if By_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",By_User_);
end if;
if To_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",To_User_);
end if;
if remarks_ >0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Remark_Id =",remarks_);
end if;


if Is_Date_Check_=true then
	set Search_Date_=concat( SearchbyName_Value," and date(student.Next_FollowUp_date) >= '", Fromdate_ ,"' and  date(student.Next_FollowUp_date) <= '", Todate_,"'");
	
ELSE
	set Search_Date_= "and 1 =1 ";
end if;

if Is_Old_Datas_=true then
	 set Search_Old_Date_= "and 1 =1 ";
	
ELSE
	#set Search_Old_Date_=concat( SearchbyName_Value," and date(student.Created_On) < '2022-09-30' ");
    set Search_Old_Date_=concat( SearchbyName_Value," and date(student.Created_On) >='2022-01-30' ");
   
end if;



set UnionQuery="";
SET @query = Concat( "select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,CAST(CAST(ROW_NUMBER()OVER(ORDER BY student.Student_Id DESC)AS UNSIGNED)AS SIGNED)AS 
No,student.Student_Id,(Date_Format(student.Created_On,'%d-%m-%Y   %h:%i')) As Created_On,user_details.User_Details_Name As Created_By,student.Student_Name Student,
enquiry_source.Enquiry_Source_Name AS Enquiry_Source,student.Is_Registered,Department_Status.Department_Status_Name,
student.Phone_Number Mobile,Branch.Branch_Name Branch,(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Follow_Up_On,Department.Department_Name Department,
Department_Status.Department_Status_Name Status,T.User_Details_Name To_Staff,B.User_Details_Name Registered_By,(Date_Format(student.Registered_On,'%d-%m-%Y   %h:%i')) As Registered_On ,
student.Remark,student.Email
from student 
	inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_," 
	inner join user_details on user_details.User_Details_Id=student.Created_By 
	inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
	inner join enquiry_source on enquiry_source.Enquiry_Source_Id= student.Enquiry_Source_Id
	inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id 
	inner join user_details as T on T.User_Details_Id=student.To_User_Id 
   
	left join user_details as B on B.User_Details_Id=student.Registered_By 
	where student.DeleteStatus=0    and student.DeleteStatus=0  ",SearchbyName_Value," ",Search_Date_," ",Search_Old_Date_," 
	and T.Role_Id in(",RoleId_,"))as lds )as ldtwo
	order by tp ");	 
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Status`( In Student_Status_Name_ varchar(100))
Begin 
 set Student_Status_Name_ = Concat( '%',Student_Status_Name_ ,'%');
 SELECT Student_Status_Id,
Student_Status_Name From Student_Status where Student_Status_Name like Student_Status_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Summary`(In Fromdate_ date,Todate_ date,RoleId_ varchar(100),Department_String varchar(1000),Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
if(SearchbyName_ !='0') then
	if Search_By_=1 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
end if;
if Department_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Department =",Department_);
end if;
if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Branch =",Branch_);
end if;
if By_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",By_User_);
end if;
if Is_Date_Check_=true then
	set Search_Date_=concat( SearchbyName_Value," and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
	
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat("select count(student.Student_Id) Count,Department_Name
from student
	inner join department on student.Department=department.Department_Id     
    group by department.Department_Id"
    );	 
	 
PREPARE QUERY FROM @query;
#select @query;


EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Summary_Report`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;declare User_Type_ int;
declare pos2to int; declare PageSize int;declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Branch_Id =",Branch_);
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/

if Is_Date_Check_=true then
	set Search_Date_=concat( SearchbyName_Value," and date(student.Next_FollowUp_Date) >= '", Fromdate_ ,"' and  date(student.Next_FollowUp_Date) <= '", Todate_,"'");
	
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat("select Followup_Branch_Name Branch,Followup_Department_Name Department,count(student.Student_Id) No_of_Students
from student
    where  student.DeleteStatus=0 ",Search_Date_," ",SearchbyName_Value,"  ",Department_String_," and student.Role_Id in(",RoleId_,") 
    group by student.Followup_Department_Id ,student.Followup_Branch_Id order by Followup_Branch_Id,Followup_Department_Id"
    );	 
	 
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');

EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_With_PhoneNumber`(In Phone_Number_ varchar(100))
BEGIN
declare SearchbyNumber_Value varchar(500);
declare Alternative_Phone_ varchar(25);
 set SearchbyNumber_Value = replace(replace(SearchbyNumber_Value,'+',''),' ','');
SET SearchbyNumber_Value = Concat(" where replace(replace(student.Phone_Number,'+',''),' ','') like '%",Phone_Number_,"%'
     or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",Phone_Number_,"%' or replace(replace(student.Alternative_Phone_Number,'+',''),' ','') like '%",Phone_Number_,"%'  or  student.Email like '%",Phone_Number_ ,"%' or student.Alternative_Email like '%",Phone_Number_ ,"%'  ") ;
#SET SearchbyNumber_Value=Concat( SearchbyNumber_Value," and( student.Phone_Number =",Phone_Number_," or student.Alternative_Phone_Number = ",Phone_Number_," or student.Whatsapp = ",Phone_Number_,")" ) ;

 # Concat( SearchbyNumber_Value," and( student.Phone_Number =",Phone_Number_," or student.Alternative_Phone_Number = ",Phone_Number_," or student.Whatsapp = ",Phone_Number_,")" ) ;
#SET SearchbyNumber_Value =   Concat() ;

        #SET SearchbyNumber_Value =   Concat( " and student.Phone_Number =",Phone_Number_ , " or  (student.Alternative_Phone_Number =)",Phone_Number_ ) ;
SET @query = Concat( "select student.Student_Id,
student.Student_Name,student.Phone_Number,student.Alternative_Phone_Number,student.Remark,(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,
    (Date_Format(student.Entry_Date,'%d-%m-%Y')) As Entry_Date,  (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Department.Department_Name,Department.FollowUp,Department_Status.Department_Status_Name,T.User_Details_Name,
B.User_Details_Name Registered_By_Name,
Branch.Branch_Name,Is_Registered,user_details.User_Details_Name As Created_By_Name,Whatsapp,student.Email
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  and student.DeleteStatus=0 
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch on Branch.Branch_Id= student.Followup_Branch_Id
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
inner join user_details as B on B.User_Details_Id=student.Created_By
",SearchbyNumber_Value," 
order by student.Phone_Number");
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
select 1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Subject`( In Subject_Name_ varchar(100))
Begin 
 set Subject_Name_ = Concat( '%',Subject_Name_ ,'%');
 SELECT Subject_Id,
Subject_Name From Subject where Subject_Name like Subject_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Substatus_Typeahead`(In Status_Id_ int,Sub_Status_Name_ varchar(100))
BEGIN
set Sub_Status_Name_ = Concat( '%',Sub_Status_Name_ ,'%');
select Sub_Status_Name,Sub_Status_Id ,Status_Id,FollowUp,Duration
 from sub_status where Sub_Status_Name like Sub_Status_Name_  and Status_Id=Status_Id_
 and sub_status.DeleteStatus=false
 ORDER BY Sub_Status_Name Asc 
 ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Sub_Section`( In Sub_Section_Name_ varchar(100))
Begin 
 set Sub_Section_Name_ = Concat( '%',Sub_Section_Name_ ,'%');
 SELECT Sub_Section_Id,
Sub_Section_Name From Sub_Section where Sub_Section_Name like Sub_Section_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Task`( In Task_Details_ varchar(2500),
Fromdate_ date,Todate_ date,Is_Date_Check_ tinyint,Usersearch_ int)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
declare User_Type_ int;
set Search_Date_=''; set SearchbyName_Value='';
if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(task.Entry_Date) >= '", Fromdate_ ,"' 
and  date(task.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
if Task_Details_!='' then
set SearchbyName_Value =Concat( SearchbyName_Value," and task.Task_Details like '%",Task_Details_ ,"%'") ;
end if;

 if Usersearch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and task.By_User_Id =",Usersearch_);
end if;




SET @query = Concat( " select Task_Id,Task_Details,User_Details_Name,(Date_Format(task.Entry_Date,'%d-%m-%Y')) 
 as Entry_Date ,task.By_User_Id,user_details.User_Details_Name
from task 
inner join user_details on task.By_User_Id = user_details.User_Details_Id
		where task.DeleteStatus=0   ", Search_Date_ ,"",SearchbyName_Value,"
		order by Task_Id
    ");
PREPARE QUERY FROM @query;
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Task_Data`(In Fromdate_ date, Todate_ date,Login_User_Id_ int,Is_Date_Check_ tinyint,Status_ int,Task_ int, Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);set Search_Date_=''; set SearchbyName_Value='';
if Is_Date_Check_=true then
	set Search_Date_=concat( SearchbyName_Value," and date(Student_Task.Followup_Date) >= '", Fromdate_ ,"' and  date(Student_Task.Followup_Date) <= '", Todate_,"'");
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
 if Status_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Student_Task.Task_Status =",Status_);
#else
#SET SearchbyName_Value =concat(SearchbyName_Value," and Student_Task.Task_Status =1");
end if;
 if Task_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Student_Task.Task_Item_Id =",Task_);
end if;
/*if User_Type_=2 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Created_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
SET @query = Concat("select * from (select * from (select 4 as tp,Student_Task.Student_Task_Id,Student_Id,Student_Name,student_task.Task_Item_Id,student_task.Task_Group_Id,
(Date_Format(Student_Task.Followup_Date,'%d-%m-%Y')) As Followup_Date,(Date_Format(Student_Task.Followup_Date,'%Y-%m-%d')) As ActualFollowup_Date,
 To_User_Name,Status_Name,Remark,Task_Item_Name,(Date_Format(Entry_Date,'%d-%m-%Y-%h:%i')) As Entry_Date,CAST(CAST(ROW_NUMBER()OVER(ORDER BY student_task.Student_Name DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from Student_Task 
inner join task_item on student_task.Task_Item_Id = task_item.Task_Item_Id
where DeleteStatus=0  and (To_User =",Login_User_Id_," or By_User_Id =",Login_User_Id_," ) ",SearchbyName_Value," ",Search_Date_,"
order by Student_Task.Followup_Date) 
as lds WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ ," ) as t union 
select 3 as tp, count(Student_Task_Id),Student_Id,'',0,0,now(),now(),'','','','',now(),0
from Student_Task 
inner join task_item on student_task.Task_Item_Id = task_item.Task_Item_Id
where DeleteStatus=0  and (To_User =",Login_User_Id_," or By_User_Id =",Login_User_Id_," ) ",SearchbyName_Value," ",Search_Date_," order by tp desc");
PREPARE QUERY FROM @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Task_front_view`(In Usersearch_ int)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare Fromdate_ date;
#Fromdate_ date,Is_Date_Check_ tinyint
set Search_Date_=''; set SearchbyName_Value='';
set  Fromdate_ =now();
#if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(task.Entry_Date) = '", Fromdate_ ,"'");
#ELSE
#set Search_Date_= "and 1 =1 ";
#end if;
/*if Task_Details_!='' then
set SearchbyName_Value =Concat( SearchbyName_Value," and task.Task_Details like '%",Task_Details_ ,"%'") ;
end if;*/

 if Usersearch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and task.By_User_Id =",Usersearch_);
end if;

SET @query = Concat( " select Task_Id,Task_Details,User_Details_Name,(Date_Format(task.Entry_Date,'%d-%m-%Y')) 
 as Entry_Date ,task.By_User_Id
from task 
inner join user_details on task.By_User_Id = user_details.User_Details_Id
where task.DeleteStatus=0   ", Search_Date_ ,"",SearchbyName_Value,"
order by Task_Id
    ");
PREPARE QUERY FROM @query;
EXECUTE QUERY;
#select @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Task_Item`( In Task_Item_Search_ varchar(45))
Begin 
 set Task_Item_Search_ = Concat( '%',Task_Item_Search_ ,'%');
 SELECT Task_Item_Id,
Task_Item_Name,Task_Item_Group,Duration From task_item where Task_Item_Name like Task_Item_Search_ 
and Delete_Status=false 
order by  Task_Item_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_University`( In University_Name_ varchar(100))
Begin 
 set University_Name_ = Concat( '%',University_Name_ ,'%');
 SELECT University_Id,
University_Name From University where University_Name like University_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_University_Typeahead`( In University_Name_ varchar(150))
Begin
 set University_Name_ = Concat( '%',University_Name_ ,'%');
select  university.University_Id,University_Name
From university
where university.DeleteStatus=false
order by University_Name ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Userwise_Summary`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare User_Type_ int;declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);

if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.User_Id =",By_User_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.Fee_Receipt_Branch =",Branch_);
end if;
if User_Type_=2 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.User_Id=",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and fees_receipt.User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;
if Is_Date_Check_=true then
set Search_Date_=concat(SearchbyName_Value, " and date(fees_receipt.Entry_Date) >= '", Fromdate_ ,"' and  date(fees_receipt.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
#insert into data_log_ value(0,RoleId_,'');",Department_String_,"and user_details.Role_Id in(",RoleId_,")
SET @query = Concat( "select Branch.Branch_Name Branch,user_details.User_Details_Name User, 
sum(fees_receipt.Amount) Amount,User_Details_Id from fees_receipt
inner join Branch on Branch.Branch_Id= fees_receipt.Fee_Receipt_Branch
inner join user_details on User_Details_Id =fees_receipt.User_Id
where fees_receipt.Delete_Status=0   ",Search_Date_," ",SearchbyName_Value,"  
group by fees_receipt.User_Id ,Fee_Receipt_Branch  order by Branch and fees_receipt.User_Id");
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
#insert into data_log_ value(0,@query,'');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Details`( In User_Details_Name_ varchar(100), Branch_Id_ int,Department_Id_ int,User_Status_Id_ int )
Begin 
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
if (User_Details_Name_ !='0') then
	 set  SearchbyName_Value =    Concat( SearchbyName_Value," and user_details.User_Details_Name like '%",User_Details_Name_,"%'");
end if;
if Branch_Id_>0 then
 set SearchbyName_Value =  Concat(SearchbyName_Value," and user_details.Branch_Id = " , Branch_Id_);
end if;
if Department_Id_>0 then
 set SearchbyName_Value =  Concat(SearchbyName_Value," and user_details.Department_Id = " , Department_Id_);
end if;
if User_Status_Id_>0 then
 set SearchbyName_Value =  Concat(SearchbyName_Value," and user_details.Working_Status = " , User_Status_Id_);
end if;
 SET @query = Concat("SELECT User_Details_Id,User_Details_Name,Password,Working_Status,User_Type,Role_Id,User_Status_Name,User_Type_Name,Branch_Name,
 User_Details.Address1, User_Details.Address2,User_Details.Address3,User_Details.Address4,User_Details.Pincode,
 User_Details.Mobile,User_Details.Email,branch.Branch_Id,branch.Branch_Name,User_Details.Registration_Target,User_Details.FollowUp_Target,Department_Id,Department_Name,Backup_User_Id,Backup_User_Name
,Application_View,All_Time_Department as All_Time_Department_View,Default_Application_Status_Id,
Default_Application_Status_Name,Agent_Status
From User_Details
#inner join User_Details as Backup_User on Backup_User.Backup_User_Id=User_Details.User_Details_Id
inner join user_status on User_Details.Working_Status=user_status.User_Status_Id
inner join user_type on User_Details.User_Type=user_type.User_Type_Id
inner join branch on User_Details.Branch_Id=branch.Branch_Id
where User_Details.DeleteStatus=false and  Agent_Status=0",SearchbyName_Value,"
order by User_Details_Id ");
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Menu_Selection`( )
Begin 
SELECT 
	Menu_Id,
	Menu_Name,
	Menu_Order,
	IsEdit Edit_Check,
	IsSave Save_Check,
	IsDelete  Delete_Check,
	IsView,
	Menu_Status 
From Menu 
	where Menu_Status=1 and DeleteStatus=false 
order by Menu.Menu_Order,Menu_Order_Sub asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Role`(In User_Role_Name_ varchar(100))
BEGIN
 set User_Role_Name_ = Concat( '%',User_Role_Name_ ,'%');
 SELECT second.User_Role_Id,second.User_Role_Name,second.Role_Under_Id,
 first.User_Role_Name as Role_Under
 from 
 User_Role  as second 
 inner join User_Role as first
 on first.User_Role_Id=second.Role_Under_Id
 where second.User_Role_Name like User_Role_Name_ 
 and first.Is_Delete=false AND Second.Is_Delete=False
order by User_Role_Name asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Role_Typeahead`( In User_Role_Name_ varchar(100))
Begin 
set User_Role_Name_ = Concat( '%',User_Role_Name_ ,'%');
SELECT
User_Role_Id,User_Role_Name
FROM user_role 
where User_Role_Name LIKE User_Role_Name_ 
and User_Role_Name Not in('Sundry Debtors')
and DeleteStatus=False
order by User_Role_Name asc Limit 5 ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Typeahead`( In User_Details_Name_ varchar(100))
Begin 
set User_Details_Name_ = Concat( '%',User_Details_Name_ ,'%');
SELECT
User_Details_Id,User_Details_Name
FROM User_Details 
where User_Details_Name LIKE User_Details_Name_ 
and User_Details_Name Not in('Sundry Debtors')
and DeleteStatus=False
order by User_Details_Name asc Limit 5 ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Typeahead_ByUser`(In Login_Id_ int,User_Details_Name_ varchar(100))
BEGIN
declare SearchbyName_Value varchar(2000);
declare User_Type_ int;
 set SearchbyName_Value='';
 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_Id_);
 set User_Details_Name_ =  Concat( " and User_Details_Name LIKE '%",User_Details_Name_,"%' ") ;
if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and User_Details_Id =",Login_Id_);
else
    SET SearchbyName_Value =concat(SearchbyName_Value," and User_Details_Id in (select User_Details_Id from user_details where Branch_Id in (select
	distinct Branch_Id from user_department where User_Id =",Login_Id_," and VIew_All=1))");
end if;

SET @query = Concat("select User_Details_Id,User_Details_Name  
from 
 user_details 
where DeleteStatus=0  ",User_Details_Name_," ",SearchbyName_Value,"
order by User_Details_Name asc Limit 5 ");
PREPARE QUERY FROM @query;
#select @query;


EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Work_History`(In Fromdate_ date,
 Todate_ date,Login_User_Id_ int,
 Is_Date_Check_ tinyint,Branch_ int 
 )
BEGIN
#select 1;
declare Department_String_dpt_ varchar(5000);declare Department_String_student_followup_ varchar(5000);
declare Department_String_student_ varchar(5000);
declare Department_String_followup_ varchar(5000);declare Department_String_student_1_ varchar(5000);declare Department_String_dpt_t_  varchar(5000);
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);declare User_Type_ int;
declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
set Search_Date_=''; set SearchbyName_Value='';
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);

	set Department_String_student_followup_ =REPLACE(Department_String_,'student','student_followup');
	#insert into data_log_ values(0,Department_String_student_followup_,'');
	set Department_String_followup_ =REPLACE(Department_String_student_followup_,'Followup_Branch_Id','Branch');
	set Department_String_student_ =REPLACE(Department_String_followup_,'To_User_Id','User_Id');
	set Department_String_student_1_ =REPLACE(Department_String_student_,'Created_By','By_User_Id');
	set Department_String_dpt_ =REPLACE(Department_String_student_1_,'Followup_Department_Id','Department');
	set Department_String_dpt_t_ =REPLACE(Department_String_dpt_,'User_List','User_Id');

#insert into data_log_ values(0,Department_String_,'');
if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(student_followup.Entry_Date) >= '", Fromdate_ ,"' and  date(student_followup.Entry_Date) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
 if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.Branch =",Branch_);
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.By_User_Id =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.By_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
SET @query =concat ( "select count(Student_FollowUp_Id) as Data_Count,Remark as Remarks_Name,ByUserName as User_Details_Name
from student_followup
	#inner join user_details on  user_details.User_Details_Id=student_followup.By_User_Id
    #inner join Branch on Branch.Branch_Id= student_followup.Branch
    #inner join Department on Department.Department_Id= student_followup.Department   
    #and Role_Id in(",RoleId_,") 
	#left join remarks on remarks.Remarks_Id=student_followup.Remark_Id
	where student_followup.DeleteStatus=0   ",Search_Date_,SearchbyName_Value," ",Department_String_dpt_t_,"
	group by UserName,student_followup.Remark_Id
");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Work_report`(Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare User_Type_ int;declare RoleId_ varchar(100);
declare Department_String_student_followup_ varchar(5000);declare Department_String_dpt_ varchar(5000);
declare Department_String_student_ varchar(5000);declare Department_String_ varchar(4000);
declare Department_String_followup_ varchar(5000);declare Department_String_student_1_ varchar(5000);declare Department_String_dpt_t_  varchar(5000);

 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
 set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
 
	set Department_String_student_followup_ =REPLACE(Department_String_,'student','student_followup');
	#insert into data_log_ values(0,Department_String_student_followup_,'');
	set Department_String_followup_ =REPLACE(Department_String_student_followup_,'Followup_Branch_Id','Branch');
	set Department_String_student_ =REPLACE(Department_String_followup_,'To_User_Id','User_Id');
	set Department_String_student_1_ =REPLACE(Department_String_student_,'Created_By','By_User_Id');
	set Department_String_dpt_ =REPLACE(Department_String_student_1_,'Followup_Department_Id','Department');
	set Department_String_dpt_t_ =REPLACE(Department_String_dpt_,'User_List','User_Id');

if(SearchbyName_ !='0') then
if Search_By_=1 then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%' ") ;
end if;
end if;
if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.Department =",Department_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and t.Branch_Id =",Branch_);
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Student_followup.By_User_Id =",By_User_);
end if;
/*if User_Type_=2 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.By_User_Id =",Login_User_Id_);
else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.By_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
if Is_Date_Check_=true then
set Search_Date_=concat( " and date(Student_followup.Entry_Date) >= '", Fromdate_ ,"' and  date(Student_followup.Entry_Date) <= '", Todate_,"'");
set Search_Date_union=concat( SearchbyName_Value," and  student.Entry_Date < '", Fromdate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat( "select student.Student_Name Student,student.Phone_Number Mobile,Branch.Branch_Name Branch,
(Date_Format(Student_followup.Next_FollowUp_Date,'%d-%m-%Y ')) As Follow_Up, (Date_Format(Student_followup.Entry_Date,'%d-%m-%Y   %h:%i')) As Entry_Date,
Department.Department_Name Department,Department_Status.Department_Status_Name Status,T.User_Details_Name Follow_Up_By,Touser.User_Details_Name as Assigned_To,
Student_followup.Remark,student.Student_Id
from student
	inner join student_followup on Student.Student_Id=Student_followup.Student_Id
	inner join Department on Department.Department_Id= Student_followup.Department
	inner join Department_Status on Department_Status.Department_Status_Id=Student_followup.Status
	inner join user_details as T on T.User_Details_Id=Student_followup.By_User_Id
	inner join Branch on Branch.Branch_Id= t.Branch_Id
	inner join  user_details as Touser on Touser.User_Details_Id =student.To_User_Id
	where student.DeleteStatus=0 and student_followup.Entry_Type =1 ",SearchbyName_Value," ",Search_Date_," 
    ",Department_String_dpt_t_,"
	order by Student_followup.By_User_Id  ");

PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Work_Summary`(In Fromdate_ date,Todate_ date,By_User_ int,Login_User_Id_ int,look_In_Date_Value tinyint,Branch_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);declare Department_String_ varchar(4000);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;declare RoleId_ varchar(100);
declare pos2to int; declare PageSize int;declare User_Type_ int;
declare Department_String_student_followup_ varchar(5000);declare Department_String_dpt_ varchar(5000);
declare Department_String_student_ varchar(5000);
declare Department_String_followup_ varchar(5000);declare Department_String_student_1_ varchar(5000);declare Department_String_dpt_t_  varchar(5000);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
 
 
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);

set Department_String_student_followup_ =REPLACE(Department_String_,'student','student_followup');
#insert into data_log_ values(0,Department_String_student_followup_,'');
set Department_String_followup_ =REPLACE(Department_String_student_followup_,'Followup_Branch_Id','Branch');
set Department_String_student_ =REPLACE(Department_String_followup_,'To_User_Id','User_Id');
set Department_String_student_1_ =REPLACE(Department_String_student_,'Created_By','By_User_Id');
set Department_String_dpt_ =REPLACE(Department_String_student_1_,'Followup_Department_Id','Department');
set Department_String_dpt_t_ =REPLACE(Department_String_dpt_,'User_List','User_Id');
 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and user_details.Branch_Id =",Branch_);
end if;
/*if User_Type_=2 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.By_User_Id =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student_followup.By_User_Id in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
 if look_In_Date_Value=true then
set Search_Date_=concat( SearchbyName_Value," and date(student_followup.Entry_Date) >= '", Fromdate_ ,"' and  date(student_followup.Entry_Date) <= '", Todate_,"'");
else
set Search_Date_= "and 1 =1 ";
end if;
#insert into data_log_ value(0,Department_String_student_followup_,'');
SET @query = Concat("select User_Details_Name To_Staff,T.Branch_Name Branch,count(student_followup.Student_Id) No_of_Follow_Up,User_Details_Id
from student_followup
inner join user_details on student_followup.By_User_Id=user_details.User_Details_Id
    inner join branch on Branch.Branch_Id= student_followup.Branch
    inner join branch as T on T.Branch_Id=user_details.Branch_Id
    where student_followup.DeleteStatus=0 and Entry_Type =1 ",Search_Date_," ",SearchbyName_Value," ",Department_String_dpt_t_,"
and Role_Id in(",RoleId_,")
    group by student_followup.By_User_Id
   order by User_Id , Branch ");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `SendLInk`( In Student_Id_ Int,Login_User_Id_ int)
Begin
Update student set Link_Send_By=Login_User_Id_,Link_Send_On=now()
where Student_Id=Student_Id_;
select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Send_Welcome_Mail`( In Student_Id_ int , User_Id_ int )
BEGIN
Declare Transaction_Id_ int;
    Declare Transaction_type_ int;
    set Transaction_type_=(select Transaction_TypeId from transaction_type where Type_Name='welcome mail' and DeleteStatus=0  );
insert into transaction_history(Transaction_Id,Entry_date,User_Id,Student_Id,Description1,Description2,Description3,Transaction_type)
    values (Transaction_Id_,now(),User_Id_,Student_Id_,'','','',Transaction_type_ );
    update student set Send_Welcome_Mail_Status=1 where Student_Id=Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `SOP_Mode_Dropdown`()
BEGIN
select * from sop_mode;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Approve`(In Application_details_Id_ int,Login_User_ int  )
BEGIN
declare Application_details_History_Id_ int;
declare From_User_Name_ varchar(200);declare Notification_Id_ int;declare Notification_Count_ int;declare Student_Name_ varchar(200);declare Student_Id_ int;
declare Notification_Type_Name_ varchar(20);declare Entry_Type_ int;
Update application_details set Student_Approved_Status = true
where Application_details_Id = Application_details_Id_;
set Student_Id_ = (select Student_Id from application_details where Application_details_Id = Application_details_Id_);
set Application_details_History_Id_=(select max(Application_details_History_Id) from Application_details_History where Application_details_Id=Application_details_Id_);

Update application_details_history set Student_Approved_Status =true
where User_Id = Login_User_ and Application_details_History_Id = Application_details_History_Id_;
/*
set To_User_ =(select Applicaton_User from Student where Student_Id = Student_Id_ and DeleteStatus=false); 
set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false); 
set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_ and DeleteStatus=false);   
set Student_Name_ = (select Student_Name from student where Student_Id = Student_Id_); 
set Notification_Type_Name_ =  'Application';
set Entry_Type_  = 2;
 SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
values(Notification_Id_,Login_User_,From_User_Name_,To_User_,ToUser_Name_,0,'',1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = Login_User_);    
update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=Login_User_; 
#Update application_details_history set Student_Approved_Status = true
#where Application_details_Id = Application_details_Id_;
*/
select Application_details_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Login_Check`(in Email_ varchar(100),in Password_ VARCHAR(50))
BEGIN
SELECT Student_Id,Student_Name
From student 
 where 
 Email =Email_ and Password=Password_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Preadmission_Checklist_Master_Id_`( In Student_Preadmission_Checklist_Master_Id_ Int)
Begin
declare Student_Checklist_Country_Id_ int;
set Student_Checklist_Country_Id_ =0;
set Student_Checklist_Country_Id_ =(SELECT Country_Id from student_preadmission_checklist_master where Student_Preadmission_Checklist_Master_Id =Student_Preadmission_Checklist_Master_Id_);

SELECT Checklist.Checklist_Id,Checklist_Name,Checklist.Country_Id,Student_Checklist_Master_Id
,case when student_preadmission_checklist_details.Checklist_Id>0 then 1 else 0 end as Check_Box
FROM Checklist  
left join student_preadmission_checklist_details on Checklist.Checklist_Id=student_preadmission_checklist_details.Checklist_Id
and student_preadmission_checklist_details.Student_Preadmission_Checklist_Master_Id = Student_Preadmission_Checklist_Master_Id_  where Checklist.Country_Id=Student_Checklist_Country_Id_
 order by Checklist_Id;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Registration_By_Enquirysource`(Fromdate_ date,Todate_ date,  Branch_  int,Is_Date_Check_ Tinyint,Login_User_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare RoleId_ varchar(100);
declare SearchbyName_Value varchar(2000);declare User_Type_ int;declare Department_String_ varchar(4000);
set SearchbyName_Value='';
set Search_Date_='';
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
#set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
if Is_Date_Check_=true then
	set Search_Date_=concat(SearchbyName_Value, " and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'");
ELSE
	set Search_Date_= "and 1 =1 ";
end if;

/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",Login_User_Id_);
else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By in (select User_Details_Id from user_details where Branch_Id in (select
	distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/

if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registration_Branch =",Branch_);
end if;
SET @query = Concat( "select  Enquiry_Source_Name as Enquiry_source,Enquiry_Source_Id,Registered_Branch Branch,count(student.Student_Id) as No_of_Registration
from student
where student.DeleteStatus=0 and student.Is_Registered=1 ",Search_Date_," ",SearchbyName_Value," ",Department_String_," and student.Role_Id in(",RoleId_,")
group by student.Enquiry_Source_Id order by Branch");
PREPARE QUERY FROM @query;
#select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Registration_By_Enquirysource_Report`(In Fromdate_ date,Todate_ date,Search_By_ int,
SearchbyName_ varchar(50),Department_ int,Branch_ int,Enquiry_Source_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare User_Type_ int;declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
 set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
 set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
if(SearchbyName_ !='0') then
	if Search_By_=1 then
	SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
end if;
/*if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;*/
if Department_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Followup_Department_Id =",Department_);
end if;
if Branch_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and  student.Registration_Branch =",Branch_);
end if;
#if By_User_>0 then
#SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",By_User_);
#end if;
if Enquiry_Source_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiry_Source_Id  =",Enquiry_Source_);
end if;
if Is_Date_Check_=true then
set Search_Date_=concat( SearchbyName_Value," and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'");
ELSE
set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat( "select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,
(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As Registered_On ,B.User_Details_Name Registered_By,student.Student_Name Student,
student.Phone_Number Mobile,D.Branch_Name Branch, (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Follow_Up_On,Department.Department_Name Department,
Department_Status.Department_Status_Name Status,T.User_Details_Name To_Staff,user_details.User_Details_Name As Created_By,
(Date_Format(student.Entry_Date,'%d-%m-%Y   %h:%i')) As Created_On,student.Remark,enquiry_source.Enquiry_Source_Name as Enquiry_Source,student.Student_Id
from student
inner join Department on Department.Department_Id= student.Followup_Department_Id  ",Department_String_,"
inner join user_details on user_details.User_Details_Id=student.Created_By
inner join Branch as D on D.Branch_Id= student.Registration_Branch
inner join Department_Status on Department_Status.Department_Status_Id=student.Status_Id
inner join user_details as T on T.User_Details_Id=student.To_User_Id
inner join enquiry_source on enquiry_source.Enquiry_Source_Id= student.Enquiry_Source_Id
inner join user_details as B on B.User_Details_Id=student.Registered_By
where student.DeleteStatus=0    and student.Is_Registered=1  ",SearchbyName_Value," ",Search_Date_,"
and T.Role_Id in(",RoleId_,"))as lds )as ldtwo
order by tp ");

PREPARE QUERY FROM @query;
#select @query;inner join Branch on Branch.Branch_Id= student.Branch

EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Registration_Summary`(In Fromdate_ date,Todate_ date,  Branch_  int,Is_Date_Check_ Tinyint,Login_User_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare RoleId_ varchar(100);declare Department_String_ varchar(4000);
declare SearchbyName_Value varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';
set Search_Date_='';
set RoleId_ =(select Role_String from user_details where User_Details_Id = Login_User_Id_);
set Department_String_ = (select Department_String from user_details where User_Details_Id = Login_User_Id_);
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User_Id_);
#set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
if Is_Date_Check_=true then
	set Search_Date_=concat(SearchbyName_Value, " and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'");
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
if User_Type_=2 then
 	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",Login_User_Id_);
    else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By in (select User_Details_Id from user_details where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");
end if;
if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registration_Branch =",Branch_);
end if;
#Department_String_ ","  and user_details.Role_Id in(",RoleId_,")
SET @query = Concat( "select  Registered_Branch Branch,user_details.User_Details_Name User,count(student.Student_Id) as No_of_Registration,
Registered_By User_Details_Id
from student
inner join user_details on user_details.User_Details_Id=student.Registered_By
where student.DeleteStatus=0 and student.Is_Registered=1 ",Search_Date_," ",SearchbyName_Value," 
group by student.Registered_By,Registered_Branch order by Branch,To_User_Id");
PREPARE QUERY FROM @query;
select @query;
#insert into data_log_ value(0,@query,'');
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Subject_Typeahead`( In Subject_Name_ varchar(100))
Begin
 set Subject_Name_ = Concat( '%',Subject_Name_ ,'%');
select  Subject.Subject_Id,Subject_Name
From Subject
where Subject_Name like Subject_Name_  and Subject.DeleteStatus=false
order by Subject_Name asc  limit 5  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Sub_Section_Typeahead`( In Sub_Section_Name_ varchar(100))
Begin
 set Sub_Section_Name_ = Concat( '%',Sub_Section_Name_ ,'%');
select  Sub_Section.Sub_Section_Id,Sub_Section_Name
From Sub_Section
where Sub_Section_Name like Sub_Section_Name_  and Sub_Section.DeleteStatus=false
order by Sub_Section_Name asc  limit 5  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Task_Item_Dropdown`(In Task_Group_Id_ int)
BEGIN
select * from task_item where Delete_Status=0 and Task_Item_Group=Task_Group_Id_ ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Task_Item_Dropdown_All`()
BEGIN
select * from task_item where Delete_Status=0  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Task_Status_Dropdown`()
BEGIN
select * from Task_Status where Delete_Status=0 ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Transfer_Cofirmation`( In Student_Id_ Int,Transfer_Source_ varchar(45),Login_User_Id_ int,Department_Id_ int,Remark_ varchar(1000),Transfer_Status_Id_ int,Transfer_Status_Name_ varchar(4000),Sub_Status_Id_ int,Sub_Status_Name_ varchar(100),Application_Id_Ref_ int)
Begin
declare User_Id_ int;declare User_Status_ int;declare Backup_User_ int;declare Working_Status_ int;declare Sub_User_ int;declare Status_Id_ int;declare Department_Status_Id_ int;
declare Department_Status_Name_ varchar(50);declare Branch_ int;declare Branch_Name_ varchar(50);declare By_User_Name_ varchar(250);declare Department_Name_ varchar(100);declare Student_Name_ varchar(500);
declare Department_FollowUp_ tinyint;declare To_User_Name_ varchar(250);declare Student_FollowUp_Id_ int;declare Remark_Id_ int;declare Role_Id_ int;declare Total_User_ int;declare Notification_Id_ int;
declare Notification_Count_ int;declare Notification_Type_Name_ varchar(20);declare Color_Type_Name_ varchar(100);
declare From_User_Name_ varchar(45);declare ToUser_Name_ varchar(45);declare Entry_Type_ int;
declare x int;declare CreatedBy_Id_ int;declare CreatedBy_Dept_ int;declare First_Time_Dept_ tinyint;declare Application_Exist_ int;
declare User_List_ TEXT;declare alltime_view_ int;declare User_List_1 TEXT;
set x=0;
set Transfer_Status_Id_ = (select Department_Status_Id from department where Department_Id = Department_Id_ and Is_Delete=0);
set Transfer_Status_Name_ = (select Department_Status_Name from department_status where Department_Status_Id = Transfer_Status_Id_ and Is_Delete=0);
 set User_Id_ = (select   COALESCE( User_Id ,0)  from student_followup where Student_Id=Student_Id_ and Department = Department_Id_ and First_Time_Dept = true);
 #insert into data_log_ values(0,User_Id_,'0');
if User_Id_>0 then
	set First_Time_Dept_ = 0;
else
	set First_Time_Dept_ = 1;
end if;
if User_Id_ = 0 then
	set CreatedBy_Id_ =  (select COALESCE( User_Id ,0) from  student where  Student_Id=Student_Id_);
    set CreatedBy_Dept_ = (select COALESCE( Department_Id ,0) from  user_details where  User_Details_Id = CreatedBy_Id_);
    if CreatedBy_Dept_ = Department_Id_ then
		set User_Id_ = CreatedBy_Id_;
	end if;
end if;

#insert into  data_logs values (0,User_Id_);
#set Department_Status_Id_=(select Department_Status_Id from department where Department_Id=Department_Id_);
select Department_Status_Id,Total_User,Current_User_Index,Department_Name,FollowUp,Color_Type_Name into
Department_Status_Id_,Total_User_,Sub_User_ ,Department_Name_,Department_FollowUp_,Color_Type_Name_
from department where Department_Id=Department_Id_ ;   
 #insert into data_log_ values(0,'1',Department_Id_);     
set Department_Status_Name_=(select Department_Status_Name from department_status where Department_Status_Id=Department_Status_Id_);
#insert into  data_logs values (0,Department_Status_Name_);
select Working_Status,Backup_User_Id
into Working_Status_,Backup_User_
from user_details  where User_Details_Id=User_Id_ ;

if (User_Id_>0) then
   # set Working_Status_ =( select Working_Status from user_details where User_Details_Id=User_Id_);
    #set Backup_User_=( select Backup_User_Id from user_details where User_Details_Id=User_Id_);
	if Working_Status_=3 or Working_Status_=2  then
		set User_Id_ = Backup_User_;
	end if;
else
		#set Sub_User_ =( select department.current_user from department where Department_Id=Department_Id_);
		set User_Id_=(select User_Details_Id from user_details where Sub_Slno=Sub_User_ and Department_Id=Department_Id_ );
		#insert into  data_logs values(1,User_Id_);  
      
		if  ISNULL(User_Id_) then
			SET Student_Id_ = -1;
		else    
        
			if Total_User_=Sub_User_ then
				set Sub_User_=1;
			else
				set Sub_User_=Sub_User_+1;
                 
			end if;
		update department set Current_User_Index =Sub_User_  where Department_Id=Department_Id_;
        
		end if;
end if;
 #insert into data_log_ values(0,Sub_User_,'6');
    if (Student_Id_ <> -1)then
		select Working_Status,Backup_User_Id ,Role_Id,Branch_Id,User_Details_Name
		into Working_Status_,Backup_User_,Role_Id_ ,Branch_ ,To_User_Name_ from User_Details where User_Details_Id=User_Id_ ;
		#set Branch_ = (select Branch_Id from user_details where  User_Details_Id=Login_User_Id_);
		set Branch_Name_=(select Branch_Name from branch where Branch_Id=Branch_);
		set By_User_Name_=(select User_Details_Name from user_details where User_Details_Id=Login_User_Id_);
		#set Department_Name_=(select Department_Name from department where Department_Id=Department_Id_);
		set Student_Name_ =(select Student_Name from student where Student_Id=Student_Id_);
		#set Department_FollowUp_=(select FollowUp from department where Department_Id=Department_Id_);
		#set Role_Id_=(select Role_Id from user_details where User_Details_Id=User_Id_);
		#set To_User_Name_=(select User_Details_Name from user_details where User_Details_Id=User_Id_);
		#set Remark_=(select Remarks_Name from remarks where Remarks_Id=Remark_Id_);
		#insert into data_log_ values(0,Branch_,Branch_Name_);
		INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id ,Branch,Remark,Remark_Id,By_User_Id,
		Class_Id ,DeleteStatus,FollowUP_Time,Actual_FollowUp_Date,Entry_Type,Branch_Name,UserName,ByUserName,Dept_StatusName,Dept_Name,Student,FollowUp,Sub_Status_Id,Sub_Status_Name,First_Time_Dept)
		values (Student_Id_ ,Now(),Now(),0,Department_Id_ ,Transfer_Status_Id_ ,User_Id_ ,Branch_,Remark_,0,Login_User_Id_,1,false,
		Now(),Now(),3,Branch_Name_,To_User_Name_,By_User_Name_,Transfer_Status_Name_,Department_Name_,Student_Name_,Department_FollowUp_,0,'',First_Time_Dept_);
		set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
        set alltime_view_ = (select count(All_Time_Departments) from all_time_departments where User_Id = Login_User_Id_);
		if alltime_view_>0 then
			SET User_List_1 = (select User_List from student where Student_Id = Student_Id_);
			if User_List_1!='' then
				set  User_List_ =CONCAT(User_List_1,',*',Login_User_Id_, '*') ;
			else
				set  User_List_ =CONCAT('*',Login_User_Id_, '*') ;
			end if;
		else 
			set  User_List_ = 0;
		end if;
		Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Followup_Department_Id = Department_Id_ ,Status_Id = Transfer_Status_Id_ ,
		To_User_Id = User_Id_ ,By_User_Id=Login_User_Id_,Next_FollowUp_Date = Now() ,Remark = Remark_  ,Remark_Id = 0,
		Followup_Branch_Id=Branch_,FollowUp_Count=x+1,Followup_Department_Name = Department_Name_,FollowUp=Department_FollowUp_,Followup_Branch_Name = Branch_Name_,Department_Status_Name=Transfer_Status_Name_,To_User_Name=To_User_Name_,Role_Id=Role_Id_,By_UserName = By_User_Name_,
        Sub_Status_Id=Sub_Status_Id_,Sub_Status_Name=Sub_Status_Name_,Color=Color_Type_Name_
		,User_List = User_List_ where student.Student_Id=Student_Id_;
        
		if Login_User_Id_ != User_Id_ then
			set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_Id_ and DeleteStatus=false);
			set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = User_Id_ and DeleteStatus=false);  
			set Notification_Type_Name_  = 'Transfer';
			set Entry_Type_ = 1;
			SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
			insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
			values(Notification_Id_,Login_User_Id_,From_User_Name_,User_Id_,ToUser_Name_,Transfer_Status_Id_,Transfer_Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);

			set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = User_Id_);    
			update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=User_Id_;              
		end if;   
       set Application_Exist_ =(select COALESCE( MAX(Student_Id ),0) as Student_Id from application_details where Student_Id = Student_Id_ and DeleteStatus=0);
		
        if Application_Exist_ > 0 then
			if Application_Id_Ref_>0 then
				update application_details set To_User_Id = User_Id_ where  Application_details_Id = Application_Id_Ref_;
			else
                update application_details set To_User_Id = User_Id_ where Student_Id = Student_Id_;
			end if;
		end if;
	end if;
select Student_Id_,Student_Name_,From_User_Name_,Notification_Type_Name_,Entry_Type_,User_Id_,Notification_Id_,Student_Id_,ToUser_Name_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Transfer_With_Application`( In Student_Id_ Int,Transfer_Source_ varchar(45),Login_User_Id_ int,
Department_Id_ int,Application_List json)
Begin 
declare User_Id_ int;
declare User_Status_ int;
declare Backup_User_ int;
declare Working_Status_ int;
declare Sub_User_ int;
declare Status_Id_ int;
declare Department_Status_Id_ int;
declare Department_Status_Name_ varchar(50);
declare Branch_ int;
declare Branch_Name_ varchar(50);
declare By_User_Name_ varchar(250);
declare Department_Name_ varchar(100);
declare Student_Name_ varchar(500);
declare Department_FollowUp_ tinyint;
declare To_User_Name_ varchar(250);
declare Student_FollowUp_Id_ int;
declare Remark_Id_ int;
declare Role_Id_ int;
declare Total_User_ int;
declare x int;
declare Application_details_Id_ int;
declare Application_status_Id_ int;
declare Application_Status_Name_ varchar(45);declare To_User_ int;declare Notification_Id_ int;declare Remark_ varchar(500);
declare From_User_Name_ varchar(45);declare ToUser_Name_ varchar(45);declare Notification_Count_ int;declare Notification_Type_Name_ varchar(20);
declare i int  DEFAULT 0;declare Entry_Type_ int;

set x=0;
if (Transfer_Source_='admission') then
	#set User_Id_ = (select Pre_Application_User from student where Student_Id=Student_Id_);
    	set User_Id_ = (select   COALESCE( Admission_User ,0)    from student where Student_Id=Student_Id_); 
    set Department_Id_=317;  
    set Application_status_Id_=9;    
elseif (Transfer_Source_='bph') then
	#set User_Id_ = (select Bph_User from student where Student_Id=Student_Id_);
	set User_Id_ = (select   COALESCE( Bph_User ,0)    from student where Student_Id=Student_Id_); 
    set Department_Id_=333; 
    set Application_status_Id_=10;
end if;
set Application_Status_Name_ = (select Application_Status_Name from application_status where Application_status_Id=Application_status_Id_);
#set Department_Status_Id_=(select Department_Status_Id from department where Department_Id=Department_Id_);
select Department_Status_Id,Total_User,Current_User_Index,Department_Name,FollowUp into 
		Department_Status_Id_,Total_User_,Sub_User_ ,Department_Name_,Department_FollowUp_
		from department where Department_Id=Department_Id_ ;        
set Department_Status_Name_=(select Department_Status_Name from department_status where Department_Status_Id=Department_Status_Id_);
	select Working_Status,Backup_User_Id
	 into Working_Status_,Backup_User_ 
	 from user_details  where User_Details_Id=User_Id_ ;
	if (User_Id_>0) then	
	   # set Working_Status_ =( select Working_Status from user_details where User_Details_Id=User_Id_);
		#set Backup_User_=( select Backup_User_Id from user_details where User_Details_Id=User_Id_);
		if Working_Status_=3 or Working_Status_=2  then
			set User_Id_ = Backup_User_;
		end if;
	else
		#set Sub_User_ =( select department.current_user from department where Department_Id=Department_Id_);
		set User_Id_=(select User_Details_Id from user_details where Sub_Slno=Sub_User_ and Department_Id=Department_Id_ );
		   if  ISNULL(User_Id_) then 
				SET Student_Id_ = -1;            
			else     
				if Total_User_=Sub_User_ then
					set Sub_User_=1;
				else
					set Sub_User_=Sub_User_+1;
				end if;
			#insert into data_log_ values(0,Sub_User_,Sub_User_);
			update department set Current_User_Index =Sub_User_  where Department_Id=Department_Id_;
		end if;
	end if;    
    if (Student_Id_<>-1) then				
		select Working_Status,Backup_User_Id ,Role_Id,Branch_Id,User_Details_Name
		into Working_Status_,Backup_User_,Role_Id_ ,Branch_ ,To_User_Name_ from User_Details where User_Details_Id=User_Id_ ;
		#set Branch_ = (select Branch_Id from user_details where  User_Details_Id=Login_User_Id_);
		set Branch_Name_=(select Branch_Name from branch where Branch_Id=Branch_);
		set By_User_Name_=(select User_Details_Name from user_details where User_Details_Id=Login_User_Id_);
		#set Department_Name_=(select Department_Name from department where Department_Id=Department_Id_);
		set Student_Name_ =(select Student_Name from student where Student_Id=Student_Id_);
		#set Department_FollowUp_=(select FollowUp from department where Department_Id=Department_Id_);
		#set Role_Id_=(select Role_Id from user_details where User_Details_Id=User_Id_);
		#set To_User_Name_=(select User_Details_Name from user_details where User_Details_Id=User_Id_);
		#set Remark_=(select Remarks_Name from remarks where Remarks_Id=Remark_Id_);
		#insert into data_log_ values(0,Branch_,Branch_Name_);
		INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference,Department ,Status ,User_Id ,Branch,Remark,Remark_Id,By_User_Id,
		Class_Id ,DeleteStatus,FollowUP_Time,Actual_FollowUp_Date,Entry_Type,Branch_Name,UserName,ByUserName,Dept_StatusName,Dept_Name,Student,FollowUp) 
		values (Student_Id_ ,Now(),Now(),0,Department_Id_ ,Department_Status_Id_ ,User_Id_ ,Branch_,'',0,Login_User_Id_,1,false,
		Now(),Now(),3,Branch_Name_,To_User_Name_,By_User_Name_,Department_Status_Name_,Department_Name_,Student_Name_,Department_FollowUp_);
		set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
		Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Followup_Department_Id = Department_Id_ ,Status_Id = Department_Status_Id_ ,
		To_User_Id = User_Id_ ,By_User_Id=Login_User_Id_,Next_FollowUp_Date = Now() ,Remark_Id = 0,
		Followup_Branch_Id=Branch_,FollowUp_Count=x+1,Followup_Department_Name = Department_Name_,FollowUp=Department_FollowUp_,Followup_Branch_Name = Branch_Name_,Department_Status_Name=Department_Status_Name_,To_User_Name=To_User_Name_,Role_Id=Role_Id_,By_UserName = By_User_Name_
		where student.Student_Id=Student_Id_;
			if (Transfer_Source_='admission') then
				Update student set Admission_User=User_Id_ where student.Student_Id=Student_Id_;    
			elseif (Transfer_Source_='bph') then
				Update student set Bph_User=User_Id_ where student.Student_Id=Student_Id_;
			end if;
		WHILE i < JSON_LENGTH(Application_List) DO
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Application_List,CONCAT('$[',i,'].Application_details_Id'))) INTO Application_details_Id_;
			insert into application_details_history (Application_details_Id,Student_Id,Country_Id,Country_Name,
			University_Id,University_Name,Course_Id,Course_Name,
			intake_Id,intake_Name,Intake_Year_Id,Intake_Year_Name,Date_Of_Applying,Remark,
			Application_status_Id,Application_Status_Name,Agent_Id,Agent_Name,Activation_Status,
			SlNo,User_Id,Course_Fee,Living_Expense,DeleteStatus,Bph_Approved_Status,Bph_Approved_By,
			Bph_Approved_Date,Student_Approved_Status)
			select Application_details_Id,Student_Id,Country_Id,Country_Name,University_Id,
			University_Name,Course_Id,Course_Name,
			intake_Id,intake_Name,Intake_Year_Id,Intake_Year_Name,Date_Of_Applying,Remark,
			Application_status_Id_,Application_Status_Name_,Agent_Id,Agent_Name,0,0,
			User_Id,Course_Fee,Living_Expense,false,true,User_Id,now(),true  
			from application_details where Application_details_Id=Application_details_Id_;
			UPDATE application_details set
			Application_status_Id=Application_status_Id_,
			Application_Status_Name=Application_Status_Name_
			Where Application_details_Id=Application_details_Id_;
			SELECT i + 1 INTO i;
		END WHILE; 


if (Transfer_Source_='admission') then
		set To_User_ =(select Admission_User from Student where Student_Id = Student_Id_ and DeleteStatus=false);   
elseif (Transfer_Source_='bph') then
		set To_User_ =(select Bph_User from Student where Student_Id = Student_Id_ and DeleteStatus=false);   
end if;
        
if Login_User_Id_!=To_User_ then
	set Student_Name_ =(select Student_Name from Student where Student_Id = Student_Id_ and DeleteStatus=false);
	set Remark_ =(select Remark from application_details where Application_details_Id = Application_details_Id_ and DeleteStatus=false);    
	set From_User_Name_ =(select User_Details_Name from user_details where User_Details_Id = Login_User_Id_ and DeleteStatus=false); 
	set ToUser_Name_ =(select User_Details_Name from user_details where User_Details_Id = To_User_ and DeleteStatus=false); 
	set Notification_Type_Name_ = 'Transfer'; 
	set Entry_Type_ = 1;
		SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
	insert into Notification (Notification_Id,From_User,From_User_Name,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type)
	values(Notification_Id_,Login_User_Id_,From_User_Name_,To_User_,ToUser_Name_,Application_status_Id_,Application_Status_Name_,1,Remark_,now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_);
		
	set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM User_Details where User_Details_Id = To_User_);    
	update User_Details set Notification_Count = Notification_Count_ where User_Details_Id=To_User_; 
end if;        
end if;
select Student_Id_,Student_Name_,From_User_Name_,Notification_Type_Name_,Entry_Type_,To_User_,Notification_Id_,Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `University_Typeahead`( In University_Name_ varchar(100))
Begin
 set University_Name_ = Concat( '%',University_Name_ ,'%');
select  University.University_Id,University_Name
From University
where University_Name like University_Name_ and  University.DeleteStatus=false
order by University_Name asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `University_Typeahead_with_Level_Country`( In Country_Id int,Level_Detail_Id int ,University_Name_ varchar(100))
Begin
 set University_Name_ = Concat( '%',University_Name_ ,'%');
select  University.University_Id,University_Name
From University
where University_Name like University_Name_ and   University.Country_Id=Country_Id 
and University.Level_Detail_Id=Level_Detail_Id and University.DeleteStatus=false
order by University_Name asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_Read_Status`(In login_user_ int,Notification_Id_ int)
BEGIN
update notification set Read_Status =1 where Notification_Id = Notification_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Update_Student`( In Student_Id_ int,Agent_Id_ int,Student_Name_ varchar(50),
Last_Name_ varchar(50),Address1_ varchar(50),Address2_ varchar(50),
Pincode_ varchar(7),Email_ varchar(100),Phone_Number_ varchar(25),
Promotional_Code_ varchar(50),Student_Status_Id_ int,Password_ varchar(20))
Begin 
 if  Student_Id_>0
 THEN 
 UPDATE Student set Student_Name = Student_Name_ ,Last_Name = Last_Name_ ,Agent_Id=Agent_Id_,
Address1 = Address1_ ,Address2 = Address2_ ,Pincode = Pincode_ ,Email = Email_ ,
Phone_Number = Phone_Number_ ,Promotional_Code = Promotional_Code_ ,
Student_Status_Id = Student_Status_Id_ ,Password = Password_  
Where Student_Id=Student_Id_ ;
ELSE 
 SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM student); 
  INSERT INTO Student(Student_Id , Agent_Id, Entry_Date,Student_Name ,Last_Name ,Gender ,  Address1 ,
  Address2 ,Pincode ,Email ,Phone_Number ,Dob ,Country ,Promotional_Code ,Student_Status_Id ,Password,DeleteStatus ) 
  values (Student_Id_ ,Agent_Id_,now(),Student_Name_ ,Last_Name_ ,0 ,Address1_ ,
Address2_ ,Pincode_ ,Email_ ,Phone_Number_ ,now() ,0 ,Promotional_Code_ ,1 ,
Password_,false );
End If ;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Upload_Resume`( In Docs_ Json,Document_value_ int)
Begin
DECLARE Student_Id_ int;
declare ImageFile_Resume_  varchar(4000); 
declare Item_Images_Id_  int; 
declare SlNo_  varchar(100); 
Declare i int default 0;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Student_Id')) INTO Student_Id_;
if( Document_value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.ImageFile_Resume')) INTO ImageFile_Resume_;
end if;
if(Student_Id_>0)
then
update student set Resume = ImageFile_Resume_ where Student_Id = Student_Id_;
end if;
select Student_Id_;
 End$$
DELIMITER ;
