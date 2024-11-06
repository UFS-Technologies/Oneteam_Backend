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
CREATE DEFINER=`root`@`%` PROCEDURE `Accounts_Typeahead`( In Account_Group_Id_ varchar(100),Client_Accounts_Name_ varchar(100))
Begin 
	set Client_Accounts_Name_ = Concat( "'%",Client_Accounts_Name_ ,"%'");
Set @query=CONCAT("	SELECT 	Client_Accounts_Id,	Client_Accounts_Name,Address1,Address2,
Address3,Address4,Mobile
	From Client_Accounts 
    where    Account_Group_Id IN(",Account_Group_Id_,") and 
    Client_Accounts_Name like ",  Client_Accounts_Name_,"     and DeleteStatus=false 
    ORDER BY Client_Accounts_Name Asc Limit 5 ");
     PREPARE QUERY FROM @query;EXECUTE QUERY;
  # select @query;
    
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
CREATE DEFINER=`root`@`%` PROCEDURE `Activate_Status`(In Student_Id_ int )
BEGIN
Update student set Activate_Status = true
where Student_Id = Student_Id_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Agent_Login`( In Users_Name_ VARCHAR(50),
in Password_ VARCHAR(50))
BEGIN
SELECT 
Student_Id,Student_Name
From student 
 where 
 Phone =Users_Name_ and Password=Password_ and Fees_Status=1 and Activate_Status=1 and DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Applied_Reject_Detaild_Report`(In Student_Id_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Student_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and applied_jobs.Student_Id =",Student_Id_);
end if;

SET @query = Concat("  SELECT job_posting.Job_Title Job,Company_Name,(Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) As Reject_date,Student_Name,applied_jobs.Remark,
Apply_Type,applied_jobs.Student_Id,
 CASE
                WHEN applied_jobs.Interview_Status = 1 THEN 'Interview Scheduled'
                ELSE 'Interview Not Scheduled'
            END AS Interview_Status_Name,
            CASE
                WHEN applied_jobs.Placement_Status = 1 THEN 'Placed'
                ELSE 'Not Placed'
            END AS Placement_Status_Name,Resume_Status_Name

 From  applied_jobs
inner join student on Student.Student_Id=applied_jobs.Student_Id
inner join job_posting on applied_jobs.Job_Id=job_posting.Job_Posting_Id
where   Student.DeleteStatus=0 and Student.Registered=1 and applied_jobs.DeleteStatus =0 and job_posting.DeleteStatus=0 
" ,SearchbyName_Value , " 
order by Student.Student_Id ASC 
" );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Apply_Jobs`( In Applied_Jobs_Id_ int,
Student_Id_ int,
Job_Id_ int,
Entry_Date_ datetime,Apply_Type_ int)
Begin 
if Apply_Type_=null then set Apply_Type_=1; end if;
 if  Applied_Jobs_Id_>0
 THEN 
 UPDATE applied_jobs set Applied_Jobs_Id = Applied_Jobs_Id_ ,
Student_Id = Student_Id_ ,
Job_Id = Job_Id_ ,
Entry_Date = Entry_Date_,Apply_Type=Apply_Type_  Where Applied_Jobs_Id=Applied_Jobs_Id_ ;
 ELSE 
 SET Applied_Jobs_Id_ = (SELECT  COALESCE( MAX(Applied_Jobs_Id ),0)+1 FROM applied_jobs); 
 INSERT INTO applied_jobs(Applied_Jobs_Id ,Student_Id ,Job_Id,Entry_Date,Apply_Type,DeleteStatus) 
values (Applied_Jobs_Id_,Student_Id_,Job_Id_,Entry_Date_,Apply_Type_,false);
 End If ;
 if Apply_Type_=1 then
	update student set applied=applied+1 where Student_Id=Student_Id_;
elseif Apply_Type_=2 then
	update student set rejected=rejected+1 where Student_Id=Student_Id_;
end if;
 select Applied_Jobs_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Automatic_App_Notification`()
BEGIN
select Student_Name, count(Job_Id) as Job_Count,Job_Id,Candidate_Id,Last_Date,Apply_Status,Device_Id from job_candidate
inner join student on student.Student_Id = job_candidate.Candidate_Id
where  Last_Date >= curdate() and student.DeleteStatus=false and Apply_Status=0  
group by Candidate_Id,Student_Name,Job_Id,Last_Date,Apply_Status,Device_Id;
select  student.Student_Id,Student_Name Student,student.Phone,student_course.Batch_Name Batch,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
sum(student_fees_installment_details.Balance_Amount) as Amount,
student_course.Course_Name Course,users.Users_Name teammember ,users.Mobile as UserMobile, DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 3 DAY) before_theredays,
DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) before_onedays,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY) today
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18,19) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and ((current_date()= DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 3 DAY)) or
 (current_date() = DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY))) or
 curdate() = student_fees_installment_details.Instalment_Date group by student.Student_Id,Student_Name ,student.Phone,student_course.Batch_Name ,student_course.Start_Date,student_fees_installment_details.Instalment_Date,
student_course.Course_Name ,users.Users_Name  ,users.Mobile , DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 3 DAY) ,
DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) ,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY)
 order by student.Student_Id ASC;
select  student.Student_Id,Student_Name Student,student.Phone,student_course.Batch_Name Batch,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
sum(student_fees_installment_details.Balance_Amount) as Amount,
student_course.Course_Name Course,users.Users_Name teammember ,users.Mobile as UserMobile,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY) duedate
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18,19) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and  curdate() >= student_fees_installment_details.Instalment_Date
group by student.Student_Id,Student_Name ,student.Phone,student_course.Batch_Name ,
student_course.Start_Date,
student_fees_installment_details.Instalment_Date,
student_course.Course_Name ,users.Users_Name  ,users.Mobile ,
DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY)
order by student.Student_Id ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Change_Application_Status`( In Application_details_Id_ Int,Student_Id_ int,Application_Status_Id_ int,
Application_Status_Remark_ varchar(2000))
Begin
declare Application_Status_Name_ varchar(100);
set Application_Status_Name_ =(select Application_Status_Name from application_status where Application_Status_Id=Application_Status_Id_ );

update application_details set Application_Status_Id =Application_Status_Id_ ,Application_Status_Name=Application_Status_Name_ ,
Application_Status_Remark=Application_Status_Remark_
where Application_details_Id =Application_details_Id_ and Student_Id=Student_Id_ ;

 select Application_details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Change_Status`( In Login_User_ Int,Complaint_Id_ int,Status_ int)
Begin 
declare Current_Complaint_Complete_Status_ int;declare Update_Complaint_Complete_Status_ int;declare Complaint_Complete_Status_ int;
# set Current_Complaint_Complete_Status_ =(select Complaint_Status from Complaint where Complaint_Id=Complaint_Id_);
if(Status_ = 1) then
 update Complaint set Complaint_Status=2  where Complaint_Id=Complaint_Id_ ;
end if;
if(Status_ =2) then
 update Complaint set Complaint_Status=1   where Complaint_Id=Complaint_Id_ ;
end if;
 #set Update_Complaint_Complete_Status_ =(select Complaint_Status from Complaint where Complaint_Id=Complaint_Id_);
 #if (Current_Complaint_Complete_Status_=Update_Complaint_Complete_Status_) then
 #set Complaint_Complete_Status_=-1 ;
 set Complaint_Complete_Status_ =(select Complaint_Status from Complaint where Complaint_Id=Complaint_Id_);
 #end if;
 select Complaint_Id_,Complaint_Complete_Status_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Change_Student_Status`(In Student_Status_ int,Student_Id_ int  )
BEGIN
Update Student set Student_Status = Student_Status_
where Student_Id = Student_Id_;
select Student_Status_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Check_Candidate_Mail`( In Email_ varchar(1000))
Begin 
 SELECT Candidate_Id, Candidate_Name,Password 
 From candidate where Email =Email_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Check_OTP`(In OTP int,Student_Id_ int)
BEGIN
Select Student_Id,Student_Name,OTP from  student
where Student_Id=Student_Id_ and OTP=OTP ;
select Student_Id_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Deactivate_Status`(In Student_Id_ int )
BEGIN
Update student set Activate_Status = false
where Student_Id = Student_Id_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Accounts`( In Accounts_Id_ Int)
Begin 
 update Accounts set DeleteStatus=true where Accounts_Id =Accounts_Id_ ;
 select Accounts_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Agent`( In Agent_Id_ Int)
Begin 
declare From_Account_Id_ int;declare DeleteStatus_ tinyint;

set From_Account_Id_=(select Client_Accounts_Id from Agent where Agent_Id=Agent_Id_ and DeleteStatus=0);

delete From Accounts WHERE Tran_Type='RV' AND Tran_Id in (select Receipt_Voucher_Id from
receipt_voucher where  From_Account_Id=From_Account_Id_);

update client_accounts set DeleteStatus=true where Client_Accounts_Id =From_Account_Id_ ;
update receipt_voucher set DeleteStatus=true where From_Account_Id =From_Account_Id_ ;

update Agent set DeleteStatus=true where Agent_Id =Agent_Id_ ;
#commit;

set DeleteStatus_=1;

 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Agent_Commision`( In Agent_Commision_Id_ Int)
Begin 
 update Agent_Commision set DeleteStatus=true where Agent_Commision_Id =Agent_Commision_Id_ ;
 select Agent_Commision_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Agent_Course_Type`( In Agent_Course_Type_Id_ Int)
Begin 
 update Agent_Course_Type set DeleteStatus=true where Agent_Course_Type_Id =Agent_Course_Type_Id_ ;
 select Agent_Course_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Batch`( In Batch_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Batch set DeleteStatus=true where Batch_Id =Batch_Id_ ;
  set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Candidate`( In Candidate_Id_ Int)
Begin 
declare From_Account_Id_ int;  declare DeleteStatus_ tinyint;
set From_Account_Id_=(select Client_Accounts_Id from Candidate where Candidate_Id=Candidate_Id_ and DeleteStatus=0);

update client_accounts set DeleteStatus=true where Client_Accounts_Id =From_Account_Id_ ;
update Candidate set DeleteStatus=true where Candidate_Id =Candidate_Id_ ;
update Candidate_followup set DeleteStatus=true where Candidate_Id =Candidate_Id_ ;
 set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Candidate_Followup`( In Candidate_Followup_Id_ Int)
Begin 
 update Candidate_Followup set DeleteStatus=true where Candidate_Followup_Id =Candidate_Followup_Id_ ;
 select Candidate_Followup_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Candidate_Job_Apply`( In Candidate_Job_Apply_Id_ Int)
Begin 
 update Candidate_Job_Apply set DeleteStatus=true where Candidate_Job_Apply_Id =Candidate_Job_Apply_Id_ ;
 select Candidate_Job_Apply_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Category`( In Category_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Category set DeleteStatus=true where Category_Id =Category_Id_ ;
 set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Certificates`( In Certificates_Id_ Int)
Begin 
 update Certificates set DeleteStatus=true where Certificates_Id =Certificates_Id_ ;
 select Certificates_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Certificate_Request`( In Certificate_Request_Id_ Int)
Begin 
 update Certificate_Request set DeleteStatus=true where Certificate_Request_Id =Certificate_Request_Id_ ;
 select Certificate_Request_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course`( In Course_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
if exists(select Course_Id from Course where  DeleteStatus=False and 
	Course_Id =Course_Id_ and Course_Id  not in
	(select student_course.Course_Id  from student_course where DeleteStatus=False))
then
	update Course set DeleteStatus=true where Course_Id =Course_Id_ ;
	update Course_Fees set DeleteStatus=true where Course_Id =Course_Id_ ;
	update Course_Subject set DeleteStatus=true where Course_Id =Course_Id_ ;
	set DeleteStatus_=1;
else
	set DeleteStatus_=0;
end if;

select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course_Fees`( In Course_Fees_Id_ Int)
Begin 
 update Course_Fees set DeleteStatus=true where Course_Fees_Id =Course_Fees_Id_ ;
 select Course_Fees_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course_Import_Details`( In Course_Import_Details_Id_ Int)
Begin 
 update Course_Import_Details set DeleteStatus=true where Course_Import_Details_Id =Course_Import_Details_Id_ ;
 select Course_Import_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course_Import_Master`( In Course_Import_Master_Id_ Int)
Begin 
 update Course_Import_Master set DeleteStatus=true where Course_Import_Master_Id =Course_Import_Master_Id_ ;
 select Course_Import_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course_Subject`( In Course_Subject_Id_ Int)
Begin 
 update Course_Subject set DeleteStatus=true where Course_Subject_Id =Course_Subject_Id_ ;
 select Course_Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Course_Type`( In Course_Type_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Course_Type set DeleteStatus=true where Course_Type_Id =Course_Type_Id_ ;
 set DeleteStatus_=1;
 
 select DeleteStatus_;
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
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Employer_Details`( In Employer_Details_Id_ Int)
Begin 
update Employer_Details set Delete_Status=true where Employer_Details_Id =Employer_Details_Id_ ; 
 select Employer_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Employer_Status`( In Employer_Status_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Employer_Status set DeleteStatus=true where Employer_Status_Id =Employer_Status_Id_ ;

  set DeleteStatus_=1;
 
 select DeleteStatus_;
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
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Exam_Details`( In Exam_Details_Id_ Int)
Begin 
 update Exam_Details set DeleteStatus=true where Exam_Details_Id =Exam_Details_Id_ ;
 select Exam_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Exam_Master`( In Exam_Master_Id_ Int)
Begin 
 update Exam_Master set DeleteStatus=true where Exam_Master_Id =Exam_Master_Id_ ;
 select Exam_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Experience`( In Experience_Id_ Int)
Begin 
 update Experience set DeleteStatus=true where Experience_Id =Experience_Id_ ;
 select Experience_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Fees_Instalment`( In Fees_Instalment_Id_ Int)
Begin 
 update Fees_Instalment set DeleteStatus=true where Fees_Instalment_Id =Fees_Instalment_Id_ ;
 select Fees_Instalment_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Fees_Receipt`( In Fees_Receipt_Id_ Int)
Begin 
 update Fees_Receipt set DeleteStatus=true where Fees_Receipt_Id =Fees_Receipt_Id_ ;
 select Fees_Receipt_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Fees_Type`( In Fees_Type_Id_ Int)
Begin 
 update Fees_Type set DeleteStatus=true where Fees_Type_Id =Fees_Type_Id_ ;
 select Fees_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Followup_Type`( In Followup_Type_Id_ Int)
Begin 
 update Followup_Type set DeleteStatus=true where Followup_Type_Id =Followup_Type_Id_ ;
 select Followup_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Functionl_Area`( In Functionl_Area_Id_ Int)
Begin 
 update Functionl_Area set DeleteStatus=true where Functionl_Area_Id =Functionl_Area_Id_ ;
 select Functionl_Area_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Job_Opening`( In Job_Opening_Id_ Int)
Begin 
declare DeleteStatus_ int;declare Job_Posting_Id_ int;
 set Job_Posting_Id_ = (select IFNULL(Job_Posting_Id, 0) from job_opening where Job_Opening_Id=Job_Opening_Id_ and DeleteStatus=0);
 if(Job_Posting_Id_>0) then
 set DeleteStatus_=-1;
 else
	 update job_opening set DeleteStatus=true where Job_Opening_Id =Job_Opening_Id_ ;
	 update job_opening_followup set DeleteStatus=true where Job_Opening_Id =Job_Opening_Id_ ;
	 update employer_details set Job_Opening_Id=0 where  Job_Opening_Id =Job_Opening_Id_;
set DeleteStatus_=1;
 end if;
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Job_Posting`( In Job_Posting_Id_ Int)
Begin 
declare DeleteStatus_ tinyint;declare Job_Opening_Id_ int;

set Job_Opening_Id_ = (select IFNULL(Job_Opening_Id, 0) from job_opening where Job_Posting_Id=Job_Posting_Id_ and DeleteStatus=0);
if Job_Opening_Id_ > 0 then
  update job_opening set Job_Posting_Id=0 where Job_Opening_Id =Job_Opening_Id_ ;
end if;
 update Job_Posting set DeleteStatus=true where Job_Posting_Id =Job_Posting_Id_ ;
 set DeleteStatus_=1;
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Mark_List`( In Mark_List_Id_ Int)
Begin 
 update Mark_List set DeleteStatus=true where Mark_List_Id =Mark_List_Id_ ;
 select Mark_List_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Part`( In Part_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Part set DeleteStatus=true where Part_Id =Part_Id_ ;
  set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Period`( In Period_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Period set DeleteStatus=true where Period_Id =Period_Id_ ;
  set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Qualification`( In Qualification_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Qualification set DeleteStatus=true where Qualification_Id =Qualification_Id_ ;
  set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Question`( In Question_Id_ Int)
Begin 
 update Question set DeleteStatus=true where Question_Id =Question_Id_ ;
 select Question_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Question_Import_Details`( In Question_Import_Details_Id_ Int)
Begin 
 update Question_Import_Details set DeleteStatus=true where Question_Import_Details_Id =Question_Import_Details_Id_ ;
 select Question_Import_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Question_Import_Master`( In Question_Import_Master_Id_ Int)
Begin 
 update Question_Import_Master set DeleteStatus=true where Question_Import_Master_Id =Question_Import_Master_Id_ ;
 update question set DeleteStatus=true where Question_Import_Master_Id =Question_Import_Master_Id_ ;
 select Question_Import_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Receipt_Voucher`( In Receipt_Voucher_Id_ Int)
Begin 
 update Receipt_Voucher set DeleteStatus=true where Receipt_Voucher_Id =Receipt_Voucher_Id_ ;
   DELETE FROM Accounts WHERE Tran_Type='RV' AND Tran_Id=Receipt_Voucher_Id_;
 select Receipt_Voucher_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Self_Placement`( In Self_Placement_Id_ Int)
Begin
 if(Self_Placement_Id_>0) then
 update self_placement set DeleteStatus=true where Self_Placement_Id =Self_Placement_Id_ ;
 set Self_Placement_Id_ =1;
 else set Self_Placement_Id_=0;
 end if;
 select Self_Placement_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Settings`( In Settings_Id_ Int)
Begin 
 update Settings set DeleteStatus=true where Settings_Id =Settings_Id_ ;
 select Settings_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Specialization`( In Specialization_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Specialization set DeleteStatus=true where Specialization_Id =Specialization_Id_ ;
  set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_State`( In State_Id_ Int)
Begin 
  declare DeleteStatus_ tinyint;
  
if exists (select student.State_Id  from student where State_Id=State_Id_ and DeleteStatus=False) then
	set DeleteStatus_=0;
else
  update State set DeleteStatus=true where State_Id =State_Id_ ;
	update state_district set DeleteStatus=true where State_Id =State_Id_ ;
 set DeleteStatus_=1;
end if;

 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_State_District`( In State_District_Id_ Int)
Begin 
  declare DeleteStatus_ tinyint;
if exists 
	(select student.District_Id  from student where District_Id =State_District_Id_ and  DeleteStatus=False)
    then

	set DeleteStatus_=0;
else
update state_district set DeleteStatus=true where State_District_Id =State_District_Id_ ;

 set DeleteStatus_=1;
end if;
 
 select DeleteStatus_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Status`( In Status_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Status set DeleteStatus=true where Status_Id =Status_Id_ ;

  set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student`( In Student_Id_ Int)
Begin 
declare applied_Jobs_ varchar(500);declare Reject_Jobs_ varchar(500);
declare From_Account_Id_ int;  declare DeleteStatus_ tinyint;
set From_Account_Id_=(select Client_Accounts_Id from Student where Student_Id=Student_Id_ and DeleteStatus=0);

delete From Accounts WHERE Tran_Type='RV' AND Tran_Id in (select Receipt_Voucher_Id from
receipt_voucher where  From_Account_Id=From_Account_Id_);
update client_accounts set DeleteStatus=true where Client_Accounts_Id =From_Account_Id_ ;
update receipt_voucher set DeleteStatus=true where From_Account_Id =From_Account_Id_ ;

update student_fees_installment_details set DeleteStatus=true where Student_Fees_Installment_Master_Id in 
(select Student_Fees_Installment_Master_Id from Student_Fees_Installment_Master where Student_Id=Student_Id_);
update student_fees_installment_master set DeleteStatus=true where Student_Id =Student_Id_ ;
update student_course set DeleteStatus=true where Student_Id =Student_Id_ ;
update student_course_subject set DeleteStatus=true where Student_Id =Student_Id_ ;

update mark_list set DeleteStatus=true where Mark_List_Master_Id in 
(select Mark_List_Master_Id from mark_list_master where Student_Id=Student_Id_);
update mark_list_master set DeleteStatus=true where Student_Id =Student_Id_ ;

update Student set DeleteStatus=true where Student_Id =Student_Id_ ;
update student_followup set DeleteStatus=true where Student_Id =Student_Id_ ;
 set DeleteStatus_=1;
 
set applied_Jobs_ = (select distinct  Job_Id from  job_candidate where Candidate_Id=Student_Id_ and Apply_Status=1);
set Reject_Jobs_ = (select distinct  Job_Id from  job_candidate where Candidate_Id=Student_Id_ and Apply_Status=2);
if applied_Jobs_ !='' then
update job_posting set Applied_Count = Applied_Count-1 where  Job_Posting_Id in(applied_Jobs_);
end if;
if Reject_Jobs_ !='' then
update job_posting set Reject_Count = Reject_Count-1 where  Job_Posting_Id in(Reject_Jobs_);
end if;
  
 select DeleteStatus_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Course`( In Student_Course_Id_ Int)
Begin 
 update Student_Course set DeleteStatus=true where Student_Course_Id =Student_Course_Id_ ;
 select Student_Course_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Course_Subject`( In Student_Course_Subject_Id_ Int)
Begin 
 update Student_Course_Subject set DeleteStatus=true where Student_Course_Subject_Id =Student_Course_Subject_Id_ ;
 select Student_Course_Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Followup`( In Student_Followup_Id_ Int)
Begin 
 update Student_Followup set DeleteStatus=true where Student_Followup_Id =Student_Followup_Id_ ;
 select Student_Followup_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Student_Receipt_Voucher`( In Receipt_Voucher_Id_ Int)
Begin 
declare Student_Course_Id_ int;
declare old_fees_ decimal(18,2) default 0;
set old_fees_=(select Amount from receipt_voucher where Receipt_Voucher_Id=Receipt_Voucher_Id_);
set Student_Course_Id_=(select Student_Course_Id from Receipt_Voucher 
where Receipt_Voucher_Id=Receipt_Voucher_Id_ and DeleteStatus=0); 
 update Student_Course set Fee_Paid=Fee_Paid-old_fees_  where Student_Course_Id=Student_Course_Id_ and DeleteStatus=0;
 update Receipt_Voucher set DeleteStatus=true where Receipt_Voucher_Id =Receipt_Voucher_Id_ ;
 DELETE FROM Accounts WHERE Tran_Type='RV' AND Tran_Id=Receipt_Voucher_Id_;
 CALL update_Installment_Status(Student_Course_Id_,Receipt_Voucher_Id_);
 select Receipt_Voucher_Id_;
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
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Study_Materials`( In Study_Materials_Id_ Int)
Begin 
 update Study_Materials set DeleteStatus=true where Study_Materials_Id =Study_Materials_Id_ ;
 select Study_Materials_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Subject`( In Subject_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Subject set DeleteStatus=true where Subject_Id =Subject_Id_ ;
 set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_University`( In University_Id_ Int)
Begin 
 update University set DeleteStatus=true where University_Id =University_Id_ ;
 select University_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_University_Followup`( In University_Followup_Id_ Int)
Begin 
 update University_Followup set DeleteStatus=true where University_Followup_Id =University_Followup_Id_ ;
 select University_Followup_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Users`( In Users_Id_ Int)
Begin 
update User_Menu_Selection set DeleteStatus=true where User_Id =Users_Id_ ;
 update Users set DeleteStatus=true where Users_Id =Users_Id_ ;
 select Users_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_User_Role`( In User_Role_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update User_Role set DeleteStatus=true where User_Role_Id =User_Role_Id_ ;
   set DeleteStatus_=1;
 
 select DeleteStatus_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_User_Type`( In User_Type_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update User_Type set DeleteStatus=true where User_Type_Id =User_Type_Id_ ;
   set DeleteStatus_=1;
 
 select DeleteStatus_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Delete_Vacancy_Source`( In Vacancy_Source_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
 update Vacancy_Source set DeleteStatus=true where Vacancy_Source_Id =Vacancy_Source_Id_ ;

  set DeleteStatus_=1;
 
 select DeleteStatus_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Disable_Student_Status`(In Student_Id_ int )
BEGIN
Update student set Student_Status = false
where Student_Id = Student_Id_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Download_Certificate_Data`( In Student_Id_ Int)
Begin
insert into download_certificate(Student_Id,Download_Date) values(Student_Id_,now());
select Student_Id_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Dropdown_Status`()
BEGIN
SELECT 
Status_Id,Status_Name
From status
 where DeleteStatus=false and Group_Id = 3
ORDER BY Status_Name ASC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Dropdown_Users`()
BEGIN
SELECT Users_Id,Users_Name From users where DeleteStatus=false 
ORDER BY Users_Name ASC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Enable_Student_Status`(In Student_Id_ int )
BEGIN
Update student set Student_Status = true
where Student_Id = Student_Id_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `FollowUp_Summary`(In  By_User_ varchar(200),Login_User_ int)
BEGIN
declare Search_Date_ varchar(500);declare Department_String varchar(2000);declare User_Type_ int;
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_);
 #if User_Type_=2 then
 #	SET Department_String =concat(Department_String," and student.To_User_Id =",Login_User_);
#else
	SET Department_String =concat(Department_String," and (student.To_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_, " ) or student.To_User_Id =" , Login_User_, ")");
#end if; 
 

		#set Search_Date_=concat( " and student.Next_FollowUp_Date >= '", From_Date_ ,"' and student.Next_FollowUp_Date <= '", To_Date_,"'");
	set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
 
/*if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;*/

if By_User_!=''   and   By_User_!='0'  then
    set SearchbyName_Value=concat(" and student.To_User_Id in(",By_User_,")");
end if;

SET @query = Concat( "select users.Users_Name To_Staff,Agent_Name as Branch, count(student.Student_Id) as Pending,users.Users_Id
from student
inner join users on users.Users_Id=student.To_User_Id
inner join agent on agent.Agent_Id = users.Agent_Id
inner join status on status.Status_Id = student.Status
where student.DeleteStatus=0 and student.Registered=0 and status.FollowUp=1 and student.Status not in(18,19)",SearchbyName_Value," ",Department_String,"",Search_Date_,"
group by student.To_User_Id
 ");
/*group by student.User_Id*/
PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Accounts`( In Accounts_Id_ Int)
Begin 
 SELECT Accounts_Id,
Date,
Client_Id,
DR,
CR,
X_Client_Id,
Voucher_No,
Voucher_Type,
Description,
Status,
Daybbok From Accounts where Accounts_Id =Accounts_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Agent`( In Agent_Id_ Int)
Begin 
 SELECT Agent_Id,
Agent_Name,
Address1,
Address2,
Address3,
Address4,
Pincode,
Phone,
Mobile,
Whatsapp,
DOB,
Gender,
Email,
Alternative_Email,
Passport_No,
Passport_Expiry,
User_Name,
Password,
Photo,
GSTIN,
Category_Id,
Commission,
User_Id From Agent where Agent_Id =Agent_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Agentdetails_print`(In User_Id_ int)
BEGIN
declare Agent_ int;
set Agent_=(Select Agent_Id from users where Users_Id=User_Id_);
select 
Agent_Name,Address1,Address2,Address3,Address4,Pincode,Phone,Mobile,Email
 from agent where  Agent_Id=Agent_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Agent_Commision`( In Agent_Commision_Id_ Int)
Begin 
 SELECT Agent_Commision_Id,
Agent_Id,
Category_Id,
Category_Name,
Commision_Per,
Commision_Amount From Agent_Commision where Agent_Commision_Id =Agent_Commision_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Agent_Course_Type`( In Agent_Course_Type_Id_ Int)
Begin 
 SELECT Agent_Course_Type_Id,
Agent_Id,
Course_Type_Id,
Cousrse_Type_Name From Agent_Course_Type where Agent_Course_Type_Id =Agent_Course_Type_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_All_Notification`(In Date_ date,User_Id_ int,login_Id_ int)
BEGIN
declare To_Date_ date;
set To_Date_=CURDATE() ;
select Description as Notification_Type_Name,Student_Name ,Entry_Type,Notification_Id,Student_Id from
notification where ifnull(Read_Status,0) != 1 and DeleteStatus =0 and To_User = login_Id_  
order by Notification_Id desc limit 10;
select count(Notification_Id) as Counts from notification where ifnull(Read_Status,0) != 1 and DeleteStatus =0 and To_User = login_Id_  
order by Notification_Id ;
/*select count(Student_Task_Id) as Student_Task_Count from Student_Task  where DeleteStatus=0
and Student_Task.Task_Status =1 and To_User =login_Id_ and
 date(Student_Task.Followup_Date) <= To_Date_ ;
 select Updated_Serial_Id from user_details where User_Details_Id = login_Id_ and DeleteStatus=0;*/
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Application_Settings`()
BEGIN
select * from application_settings where DeleteStatus=0 ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Applied_List_Admin`(In  
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int,Apply_type_ int,Is_Date_ tinyint,
Fromdate_ datetime,Todate_ datetime)
Begin 
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);
set SearchbyName_Value=''; set Search_Date_='';
/*if Student_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Student_Id =",Student_Id_);
end if;*/
if Apply_type_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and applied_jobs.Apply_Type =",Apply_type_);
end if;
if Is_Date_>0 then
    set Search_Date_=concat( " and applied_jobs.Entry_Date >= '", Fromdate_ ,"' and applied_jobs.Entry_Date <= '", Todate_,"'");
    ELSE
    set Search_Date_= "and 1 =1 ";
end if;
SET @query = Concat("select * from (select 
student.Student_Name,Job_Code,Job_Title,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY applied_jobs.Applied_Jobs_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from student  
inner join applied_jobs on student.Student_Id=applied_jobs.Student_Id 
inner join job_posting on applied_jobs.Job_Id=job_posting.Job_Posting_Id				
WHERE student.DeleteStatus = false",SearchbyName_Value," ",Search_Date_," ) as lds WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );
PREPARE QUERY FROM @query;
EXECUTE QUERY;
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Applied_List_Mobile`(In Student_Id_ int, 
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int,Apply_type_ int)
Begin 
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
if Student_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Student_Id =",Student_Id_);
end if;
if Apply_type_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and applied_jobs.Apply_Type =",Apply_type_);
end if;
SET @query = Concat("select * from (select 
applied_jobs.Entry_Date,Job_Code,Job_Title,No_Of_Vaccancy,Experience_Name,Job_Location,Qualification_Name,
Functional_Area_Name,Specialization_Name,Salary,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY applied_jobs.Applied_Jobs_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from student  
inner join applied_jobs on student.Student_Id=applied_jobs.Student_Id 
inner join job_posting on applied_jobs.Job_Id=job_posting.Job_Posting_Id				
WHERE student.DeleteStatus = false",SearchbyName_Value,") as lds WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );
PREPARE QUERY FROM @query;
EXECUTE QUERY;
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_App_Dashboard`( In  
Student_Id_ int)
Begin
 select ifnull(Offer,0) Offer,ifnull(Applied,0)Applied,ifnull(Rejected,0)Rejected,ifnull(Interview_Count,0) as Interview, ifnull(Placement_Count,0) as Placed from student where Student_Id=Student_Id_ ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Attendance`(in Attendance_Master_Id_ int,Course_Id_ int,Batch_Id_ int,Faculty_ int)
BEGIN
select Student.Student_Id,Student_Name,
case when attendance_student.Attendance_Master_Id>0  and  attendance_student.Attendance_Status>0 then 1 else 0 end as Check_Box
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id 
and student_course.Course_Id=Course_Id_ and Batch_Id=Batch_Id_ and Faculty_Id=Faculty_  and student_course.DeleteStatus=0
left join attendance_student on attendance_student.Student_Id=Student.Student_Id
and Attendance_Master_Id=Attendance_Master_Id_ and  attendance_student.DeleteStatus=0
where Student.DeleteStatus=0;
 
select distinct Student_Course_Subject.Subject_Id,Subject_Name,Minimum_Mark,Task,Day,Heading,
case when attendance_subject.Attendance_Master_Id>0 then 1 else 0 end as Checkbox
from Student_Course_Subject
left join attendance_subject on attendance_subject.Subject_Id=Student_Course_Subject.Subject_Id 
and  Attendance_Master_Id=Attendance_Master_Id_
where  Student_Course_Subject.DeleteStatus=0 and Student_Course_Subject.Course_Id=Course_Id_ order by Checkbox asc;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Attendance_Details`( In Student_Id_ int,Course_Id_ int)
BEGIN
# SELECT Attendance_Student_Id,(Date_Format(attendance_master.Date,'%d-%m-%Y')) As Attendance_Date ,attendance_student.Attendance_Status,
declare Batch_End_Date_ date;declare Batch_Start_Date_ date;declare curdate date;
set Batch_End_Date_ = (select Batch_End_Date from student_course where Student_Id=Student_Id_ and Course_Id=Course_Id_);
set Batch_Start_Date_ = (select Batch_Start_Date from student_course where Student_Id=Student_Id_ and Course_Id=Course_Id_);
set curdate=curdate();
if(Batch_End_Date_>curdate()) then
select Batch_Start_Date_,Batch_End_Date_,curdate,DATEDIFF(curdate(),Batch_Start_Date_) AS total_no_of_days,count(attendance_student.Student_Id) as No_of_attendance,
    ((DATEDIFF(curdate(),Batch_Start_Date_))-(count(attendance_student.Student_Id)))Absent_Days
From attendance_student
inner join attendance_master  on attendance_master.Attendance_Master_Id=attendance_student.Attendance_Master_Id
inner join student_course  on student_course.Student_Id=attendance_student.Student_Id
where attendance_student.Student_Id=Student_Id_  and attendance_student.DeleteStatus=false
    group by student_course.Batch_Start_Date;  
else
select Batch_Start_Date_,Batch_End_Date_,curdate,DATEDIFF(Batch_End_Date_,Batch_Start_Date_) AS total_no_of_days,count(attendance_student.Student_Id) as No_of_attendance,
    ((DATEDIFF(Batch_End_Date_,Batch_Start_Date_)) -(count(attendance_student.Student_Id)))Absent_Days
From attendance_student
inner join attendance_master  on attendance_master.Attendance_Master_Id=attendance_student.Attendance_Master_Id
inner join student_course  on student_course.Student_Id=attendance_student.Student_Id
where attendance_student.Student_Id=Student_Id_  and attendance_student.DeleteStatus=false
    group by student_course.Batch_Start_Date;    
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Attendance_Details_old`( In Student_Id_ int,Course_Id_ int)
BEGIN
# SELECT Attendance_Student_Id,(Date_Format(attendance_master.Date,'%d-%m-%Y')) As Attendance_Date ,attendance_student.Attendance_Status,
declare Batch_End_Date_ date;declare Batch_Start_Date_ date;
set Batch_End_Date_ = (select Batch_End_Date from student_course where Student_Id=Student_Id_ and Course_Id=Course_Id_);
set Batch_Start_Date_ = (select Batch_Start_Date from student_course where Student_Id=Student_Id_ and Course_Id=Course_Id_);

if(Batch_End_Date_>curdate()) then
	select (Date_Format( student_course.Batch_Start_Date,'%d-%m-%Y')) As Batch_Start_Date ,
	DATEDIFF( curdate(),student_course.Batch_Start_Date) AS total_no_of_days,count(attendance_student.Student_Id) as No_of_attendance
	From attendance_student 
	inner join attendance_master  on attendance_master.Attendance_Master_Id=attendance_student.Attendance_Master_Id
	inner join student_course  on student_course.Student_Id=attendance_student.Student_Id
	where attendance_student.Student_Id=Student_Id_  and attendance_student.DeleteStatus=false group by student_course.Batch_Start_Date;
    

	SELECT 
	SUM(IF(DAYOFWEEK(date) = 1, 1, 0)) AS number_of_sundays
	FROM (
	SELECT DATE( Batch_Start_Date_) + INTERVAL (a.a + (10 * b.a)) DAY AS date
	FROM (
	SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
	) AS a
	CROSS JOIN (
	SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
	) AS b
	WHERE DATE( Batch_Start_Date_) + INTERVAL (a.a + (10 * b.a)) DAY BETWEEN  Batch_Start_Date_ AND curdate()
	) AS date_range;

else
	select (Date_Format( student_course.Batch_Start_Date,'%d-%m-%Y')) As Batch_Start_Date ,
	DATEDIFF( student_course.Batch_End_Date,student_course.Batch_Start_Date) AS total_no_of_days,count(attendance_student.Student_Id) as No_of_attendance
	From attendance_student 
	inner join attendance_master  on attendance_master.Attendance_Master_Id=attendance_student.Attendance_Master_Id
	inner join student_course  on student_course.Student_Id=attendance_student.Student_Id
	where attendance_student.Student_Id=Student_Id_  and attendance_student.DeleteStatus=false group by student_course.Batch_Start_Date;
    
    SELECT 
	SUM(IF(DAYOFWEEK(date) = 1, 1, 0)) AS number_of_sundays
	FROM (
	SELECT DATE( Batch_Start_Date_) + INTERVAL (a.a + (10 * b.a)) DAY AS date
	FROM (
	SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
	) AS a
	CROSS JOIN (
	SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
	) AS b
	WHERE DATE( Batch_Start_Date_) + INTERVAL (a.a + (10 * b.a)) DAY BETWEEN  Batch_Start_Date_ AND Batch_End_Date_
	) AS date_range;
    
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Automatic_Mails`()
BEGIN

select Users_Name,users.Email,To_User_Id,count(Student_Id) as count from student
inner join users on users.Users_Id=student.To_User_Id
where  Next_FollowUp_Date = curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22) group by Users_Name,users.Email,To_User_Id order by To_User_Id ASC;


select Student_Name, CourseName,Phone,StatusName,Remark,Users_Name,users.Email,To_User_Id,(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,count(Student_Id) as count from student
inner join users on users.Users_Id=student.To_User_Id
where  Next_FollowUp_Date = curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22) 
group by Student_Name, CourseName,Phone,StatusName,Remark,Users_Name,users.Email,To_User_Id, Next_FollowUp_Date
order by To_User_Id ASC;


select Users_Name,users.Email,To_User_Id,count(Student_Id) as count from student
inner join users on users.Users_Id=student.To_User_Id
inner join status on status.Status_Id = student.Status
where  Next_FollowUp_Date < curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22) and student.Registered=0 and status.FollowUp=1  group by Users_Name,users.Email,To_User_Id  order by To_User_Id ASC;


select Student_Name, CourseName,Phone,StatusName,Remark,Users_Name,users.Email,To_User_Id ,(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date, count(Student_Id) as count from student
inner join users on users.Users_Id=student.To_User_Id
inner join status on status.Status_Id = student.Status
where  Next_FollowUp_Date < curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22) and student.Registered=0 and status.FollowUp=1 
 group by Student_Name, CourseName,Phone,StatusName,Remark,Users_Name,users.Email,To_User_Id ,Next_FollowUp_Date 
 order by To_User_Id ASC;


select users.Users_Name ,users.Email,student.To_User_Id as To_User_Id,count(student.Student_Id) as count
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and  student_fees_installment_details.Instalment_Date <= curdate()
group by users.Users_Name  ,users.Email,student.To_User_Id  
order by To_User_Id ASC;



select  student.Student_Id,Student_Name Student,student.Phone,sum(student_fees_installment_details.Balance_Amount) as Amount,student_course.Batch_Name Batch,student.To_User_Id,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
users.Users_Name  ,users.Email as Email, DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY) before_onedays
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and  student_fees_installment_details.Instalment_Date <= curdate() 
group by student.Student_Id,Student_Name ,student.Phone,student_course.Batch_Name ,student.To_User_Id,
student_fees_installment_details.Instalment_Date,
users.Users_Name  ,users.Email , DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY) 
order by student.To_User_Id ASC;


select student.To_User_Id,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) before_onedays,
users.Users_Name teammember ,users.Email as Email,sum(student_fees_installment_details.Balance_Amount) as Amount,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and ( (current_date() = DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY)))
group by student.To_User_Id,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) ,
users.Users_Name  ,users.Email  ,student_fees_installment_details.Instalment_Date
order by student.To_User_Id ASC;



select  student.Student_Id,Student_Name Student,student.Phone,sum(student_fees_installment_details.Balance_Amount) as Amount,student_course.Batch_Name Batch,student.To_User_Id,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
users.Users_Name teammember ,users.Email as Email, DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) before_onedays
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and ( (current_date() = DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY)))
group by student.Student_Id,Student_Name ,student.Phone,student_course.Batch_Name,student.To_User_Id,
student_fees_installment_details.Instalment_Date,
users.Users_Name  ,users.Email , DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) 
order by User_Id ASC;


select  User_Id as To_User_Id,users.Users_Name teammember ,users.Email as Email,DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY) before_onedays,count(student.Student_Id) as count
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
where  student.DeleteStatus=0 and student.Status not in(18 ,23,22) and ( (current_date() = DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY)))
group by User_Id ,users.Users_Name ,users.Email ,DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY)  
order by User_Id ASC;



select User_Id as To_User_Id,  student.Student_Id,Student_Name Student,student.Phone,student_course.Batch_Name Batch,
(Date_Format(student_course.Batch_Start_Date,'%d-%m-%Y')) As Batch_Start_Date, users.Users_Name teammember ,users.Email as Email,DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY) before_onedays,
count(student.Student_Id) as count
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
where  student.DeleteStatus=0 and student.Status not in(18 ,23,22) and ( (current_date() = DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY)))
group by User_Id ,  student.Student_Id,Student_Name ,student.Phone,student_course.Batch_Name ,
student_course.Batch_Start_Date , users.Users_Name  ,users.Email,DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY)   
order by User_Id ASC;

select  (Date_Format(curdate(),'%d-%m-%Y')) As Next_FollowUp_Date;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Automatic_Mails1`()
BEGIN

select Users_Name,users.Email,To_User_Id,(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date from student
inner join users on users.Users_Id=student.To_User_Id
where  Next_FollowUp_Date = curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22) group by To_User_Id  order by To_User_Id ASC;


select Student_Name, CourseName,Phone,StatusName,Remark,Users_Name,users.Email,To_User_Id,(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date from student
inner join users on users.Users_Id=student.To_User_Id
where  Next_FollowUp_Date = curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22) group by Student_Id,To_User_Id  order by To_User_Id ASC;


select Users_Name,users.Email,To_User_Id,(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date from student
inner join users on users.Users_Id=student.To_User_Id
where  Next_FollowUp_Date < curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22)  group by To_User_Id order by To_User_Id ASC;


select Student_Name, CourseName,Phone,StatusName,Remark,Users_Name,users.Email,To_User_Id ,(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date from student
inner join users on users.Users_Id=student.To_User_Id
where  Next_FollowUp_Date < curdate() and student.DeleteStatus=false and Status not in( 18 ,23,22)  group by Student_Id,To_User_Id order by To_User_Id ASC;


select users.Users_Name  ,users.Email,student.To_User_Id as To_User_Id
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and  student_fees_installment_details.Instalment_Date <= curdate() group by User_Id  order by User_Id ASC;



select  student.Student_Id,Student_Name Student,student.Phone,sum(student_fees_installment_details.Balance_Amount) as Amount,student_course.Batch_Name Batch,student.To_User_Id,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
users.Users_Name  ,users.Email as Email, DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY) before_onedays
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and  student_fees_installment_details.Instalment_Date <= curdate() group by student.Student_Id,Student_Name,User_Id  order by User_Id ASC;



select student.To_User_Id,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) before_onedays,
users.Users_Name teammember ,users.Email as Email
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and ( (current_date() = DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY))) group by student.Student_Id,Student_Name,teammember  order by User_Id ASC;



select  student.Student_Id,Student_Name Student,student.Phone,sum(student_fees_installment_details.Balance_Amount) as Amount,student_course.Batch_Name Batch,student.To_User_Id,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
users.Users_Name teammember ,users.Email as Email, DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) before_onedays
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18 ,23,22) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and ( (current_date() = DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY))) group by student.Student_Id,Student_Name,teammember  order by User_Id ASC;


select  User_Id as To_User_Id,users.Users_Name teammember ,users.Email as Email,DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY) before_onedays
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
where  student.DeleteStatus=0 and student.Status not in(18 ,23,22) and ( (current_date() = DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY)))
group by student.Student_Id,Student_Name,teammember  order by User_Id ASC;



select User_Id as To_User_Id,  student.Student_Id,Student_Name Student,student.Phone,student_course.Batch_Name Batch,
(Date_Format(student_course.Batch_Start_Date,'%d-%m-%Y')) As Batch_Start_Date, users.Users_Name teammember ,users.Email as Email,DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY) before_onedays
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.To_User_Id
where  student.DeleteStatus=0 and student.Status not in(18 ,23,22) and ( (current_date() = DATE_SUB(student_course.Batch_Start_Date, INTERVAL 1 DAY)))
group by student.Student_Id,Student_Name,teammember  order by User_Id ASC;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Batch`(In Batch_Id_ Int)
Begin 
SELECT Batch_Id,Batch_Name,(Date_Format(Start_Date,'%d-%m-%Y')) As Start_Date,(Date_Format(Start_Date,'%Y-%m-%d')) As Actual_Start_Date,
(Date_Format(End_Date,'%d-%m-%Y')) As End_Date,(Date_Format(End_Date,'%Y-%m-%d')) As Actual_End_Date,
 Course_Id , Course_Name , Trainer_Id , Trainer_Name ,Branch_Id ,Branch_Name ,Batch_Start_Time , Batch_End_Time
From Batch
where Batch_Id =Batch_Id_ and DeleteStatus=false;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Candidate`( In Candidate_Id_ Int)
Begin 
 SELECT Candidate_Id,Candidate_Name,Address1,Address2,Address3,Address4,Pincode,Phone,
Mobile,Whatsapp,DOB,Gender,Email,Alternative_Email,Passport_No,Passport_Expiry,
User_Name,Password,IFNULL(Photo,'') Photo ,User_Id,Registered_By,Registered,Registered_On,
Functional_Area_Id,Functional_Area_Name,Specialization_Id,Specialization_Name,
Experience_Id,Experience_Name,Qualification_Id,Qualification_Name, IFNULL(Resume,''),Postlookingfor
 From Candidate where Candidate_Id =Candidate_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Candidate_Details`( In Candidate_Id_ Int)
Begin 
SELECT Candidate_Id,Candidate_Name,Address1,Address2,Address3,Address4,Pincode,Phone,Mobile,Whatsapp,
(Date_Format(DOB,'%Y-%m-%d')) as DOB,Gender,Email,Passport_No,Passport_Expiry,Password,Photo,Postlookingfor,Functional_Area_Name,Specialization_Name,Experience_Name,
Qualification_Name,Resume,Functional_Area_Id,Experience_Id,Qualification_Id,Specialization_Id
From candidate
/*left join gender on gender.Gender_Id=candidate.Gender
left join functionl_area on functionl_area.Functionl_Area_Id=candidate.Functional_Area_Id
left join experience on experience.Experience_Id=candidate.Experience_Id
left join qualification on qualification.Qualification_Id=candidate.Qualification_Id
left join specialization on specialization.Specialization_Id=candidate.Specialization_Id*/
 where Candidate_Id =Candidate_Id_ and candidate.DeleteStatus=false ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Candidate_Followup`( In Candidate_Followup_Id_ Int)
Begin 
 SELECT Candidate_Followup_Id,
Candidate_Id,
Entry_Date,
Next_FollowUp_Date,
FollowUp_Difference,
Status,
User_Id,
Remark,
Remark_Id,
FollowUp_Type,
FollowUP_Time,
Actual_FollowUp_Date,
Entry_Type From Candidate_Followup where Candidate_Followup_Id =Candidate_Followup_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Candidate_FollowUp_Details`( In Candidate_Id_ Int)
Begin 
SELECT	Candidate.Candidate_Followup_Id,Candidate.Status,Status_Name,Candidate.To_User_Id,
Users_Name To_User_Name,(Date_Format(Next_FollowUp_Date,'%Y-%m-%d')) As Next_FollowUp_Date,Remark,
By_User_Id,Candidate.Candidate_Id,Status.FollowUp FollowUp
From Candidate
inner join Status on Candidate.Status=Status.Status_Id
inner join Users on Candidate.To_User_Id=Users.Users_Id
 where Candidate.Candidate_Id =Candidate_Id_  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Candidate_FollowUp_History`( In Candidate_Id_ Int)
Begin 
SET @query = Concat( " SELECT Status.Status_Name,(Date_Format(Next_FollowUp_Date,'%Y-%m-%d')) As Next_FollowUp_Date,
(Date_Format(Entry_Date,'%Y-%m-%d-%h:%i')) As Entry_Date,
To_User.Users_Name To_User_Name,By_User.Users_Name By_User_Name,
Remark,FollowUp_Difference,(Date_Format(Actual_FollowUp_Date,'%Y-%m-%d')) As Actual_FollowUp_Date
From Candidate_Followup
inner join Status on Candidate_Followup.Status=Status.Status_Id
inner join Users To_User on Candidate_Followup.To_User_Id=To_User.Users_Id 
inner join Users By_User on Candidate_Followup.By_User_Id=By_User.Users_Id
where Candidate_Followup.Candidate_Id = ",Candidate_Id_,"   and Candidate_Followup.DeleteStatus=false
order by Entry_Date");
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;

End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Candidate_Job_Apply`( In Candidate_Id_ Int)
Begin 
 SELECT  Candidate_Id,job_posting.Job_Posting_Id,Job_Code,Job_Title,Company_Name,(Date_Format(Entry_Date,'%Y-%m-%d')) as Entry_Date
/* No_Of_Vaccancy,job_posting.Qualification_Name,Experience,Job_Location,Salary,job_posting.Functional_Area_Name,
 job_posting.Specialization_Name,Status_Name,Descritpion */
 From Candidate_Job_Apply
 inner join job_posting on job_posting.Job_Posting_Id=Candidate_Job_Apply.Job_Posting_Id
 where Candidate_Id =Candidate_Id_ and job_posting.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Category`( )
Begin 
 SELECT Category_Id,
Category_Name,
Commision_Percentage,
User_Id From Category where DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Certificates`( In Certificates_Id_ Int)
Begin 
 SELECT Certificates_Id,
Certificates_Name,
User_Id From Certificates where Certificates_Id =Certificates_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Certificate_Request`( In Certificate_Request_Id_ Int)
Begin 
 SELECT Certificate_Request_Id,
Student_Id,
Date,
Certificates_Id,
Status From Certificate_Request where Certificate_Request_Id =Certificate_Request_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Companydetails`()
BEGIN
select * from company ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Complaint`( In  Student_Id_ INT)
Begin 
 SELECT Complaint_Id , Student_Id,  Description  ,(Date_Format(Entry_Date,'%d-%m-%Y-%h:%i')) As Entry_Date  From complaint where Student_Id =Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course`( In Course_Id_ Int)
Begin 
select Course_Fees_Id,Course_Id ,Course_Fees.Fees_Type_Id ,Amount ,No_Of_Instalment ,Fees_Type_Name,
		Instalment_Period,Course_Fees.Tax,Period_Id, (Date_Format(Period_From,'%Y-%m-%d')) as Period_From,(Date_Format(Period_To,'%Y-%m-%d')) as Period_To,Period_Name from Course_Fees 
        inner join  Fees_Type on Fees_Type.Fees_Type_Id=Course_Fees.Fees_Type_Id
        where Course_Id =Course_Id_ and Course_Fees.DeleteStatus=false ;
 SELECT Course_Subject_Id,Course_Id ,Course_Subject.Part_Id ,Subject_Id ,Subject_Name ,Minimum_Mark ,
		Maximum_Mark ,Online_Exam_Status ,No_of_Question ,Exam_Duration,Part_Name,Online_Exam_Status_Name,Task,Day,Heading
        From Course_Subject 
        inner join  Part on Part.Part_Id=Course_Subject.Part_Id
        inner join  Online_Exam_Status on Online_Exam_Status.Online_Exam_Status_Id=Course_Subject.Online_Exam_Status
        where Course_Id =Course_Id_ and Course_Subject.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Details_Student_Check`(in Student_Id_ int)
BEGIN
select Student_Course_Id, Course_Id,Course_Name  ,Installment_Type_Id
from student_course where Student_Id=Student_Id_ and DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Fees`( In Course_Fees_Id_ Int)
Begin 
 SELECT Course_Fees_Id,
Course_Id,
Fees_Type_Id,
Amount,
No_Of_Instalment,
Instalment_Period From Course_Fees where Course_Fees_Id =Course_Fees_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Import_Details`( In Course_Import_Details_Id_ Int)
Begin 
 SELECT Course_Import_Details_Id,
Course_Import_Master_Id,
Course_Id From Course_Import_Details where Course_Import_Details_Id =Course_Import_Details_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Import_Master`( In Course_Import_Master_Id_ Int)
Begin 
 SELECT Course_Import_Master_Id,
Date,
User_Id From Course_Import_Master where Course_Import_Master_Id =Course_Import_Master_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Student`(in Course_Id_ int)
BEGIN
select Course_Id,Course_Type_Id,Course_Type_Name,Duration,Agent_Amount,User_Id,Total_Fees
		from Course
        where Course_Id =Course_Id_ and Course.DeleteStatus=false ;
 SELECT Course_Subject_Id,Course_Id ,Course_Subject.Part_Id ,Subject_Id ,Subject_Name ,Minimum_Mark ,
		Maximum_Mark ,Online_Exam_Status ,No_of_Question ,Exam_Duration,Part_Name,Online_Exam_Status_Name,Task  ,Day,Heading
        From Course_Subject 
        inner join  Part on Part.Part_Id=Course_Subject.Part_Id
        inner join  Online_Exam_Status on Online_Exam_Status.Online_Exam_Status_Id=Course_Subject.Online_Exam_Status
        where Course_Id =Course_Id_ and Course_Subject.DeleteStatus=false ;
/*select Course_Fees_Id,Course_Id ,Course_Fees.Fees_Type_Id ,Amount ,No_Of_Instalment ,Fees_Type_Name,
		Instalment_Period,Tax from Course_Fees 
        inner join  Fees_Type on Fees_Type.Fees_Type_Id=Course_Fees.Fees_Type_Id
        where Course_Id =Course_Id_ and Course_Fees.DeleteStatus=false ;*/
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Subject`( In Course_Subject_Id_ Int)
Begin 
 SELECT Course_Subject_Id,
Course_Id,
Part_Id,
Subject_Id,
Subject_Name,
Minimum_Mark,
Maximum_Mark,
Online_Exam_Status,
No_of_Question,
Exam_Duration From Course_Subject where Course_Subject_Id =Course_Subject_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Course_Type`( In Course_Type_Id_ Int)
Begin 
 SELECT Course_Type_Id,
Course_Type_Name,
User_Id From Course_Type where Course_Type_Id =Course_Type_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Dashboard_Count`(In Login_User_Id_ int)
BEGIN
declare Fromdate_ date;declare Todate_ date;declare Department_String varchar(2000);
declare C_Day varchar(100);
declare user_String varchar(2000);declare Search_Date_ varchar(200);declare User_Type_ int;
set Fromdate_=now();set Todate_=now();set Search_Date_='';set user_String='';set Department_String='';

set User_Type_=(select User_Type from Users where Users_Id=Login_User_Id_);
set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
set C_Day=DAY(now());
#if User_Type_=2 then
  SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.User_Id =" , Login_User_Id_, ")");
 # SET user_String =concat(Department_String," and receipt_voucher.User_Id =",Login_User_Id_);
 
  SET user_String =concat(" and (receipt_voucher.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or receipt_voucher.User_Id =" , Login_User_Id_, ")");
 
#end if;

SET @query = Concat( "select 1 as tp,count(student.Student_Id) as Data_Count
from student
inner join Users on Users.Users_Id=student.User_Id
where student.DeleteStatus=0  and date(student.Entry_Date) >= '", Fromdate_ ,"' and  
date(student.Entry_Date) <= '", Todate_,"' ",Department_String,"
   union
select 2 as tp,count(student.Student_Id) as Data_Count
from student
inner join Users on Users.Users_Id=student.User_Id
inner join student_course on student_course.Student_Id=student.Student_Id
where student.DeleteStatus=0 and  student.Registered=1 and date(student.Registered_On) >= '", Fromdate_ ,"' and  
date(student.Registered_On) <= '", Todate_,"' ",Department_String,"
union
select 3 as tp,count(student.Student_Id) as Data_Count
from student
inner join Users on Users.Users_Id=student.User_Id
inner join Status on Status.Status_Id=student.Status
where student.DeleteStatus=0 and Status.FollowUp=1 and student.Registered=0  and date(student.Next_FollowUp_Date) <'",
 Fromdate_,"' ",Department_String,"
union
select 4 as tp,count(student.Student_Id) as Data_Count
from student
inner join Users on Users.Users_Id=student.User_Id
inner join Status on Status.Status_Id=student.Status
where student.DeleteStatus=0 and Status.FollowUp=1  and student.Registered=0   and date(student.Next_FollowUp_Date) ='",Fromdate_,"' ",Department_String,"
   union
select 8 as tp,count(student.Student_Id) as Data_Count
from student
inner join Users on Users.Users_Id=student.User_Id
inner join student_course on student_course.Student_Id=student.Student_Id
where student.DeleteStatus=0 and  student.Registered=1 and date(student.Registered_On) >= '", Fromdate_ ,"' and  
date(student.Registered_On) <= '", Todate_,"' ",Department_String,"
union
 select 5 as tp,COALESCE(sum(student_fees_installment_details.Balance_Amount),0) as Data_Count
 from student
inner join Users on Users.Users_Id=student.User_Id
inner join student_course on student_course.Student_Id=student.Student_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Course_Id=student_course.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_master.Student_Fees_Installment_Master_Id=student_fees_installment_details.Student_Fees_Installment_Master_Id
where student.DeleteStatus=0 and student.Status not in(18,19) and  student_fees_installment_details.DeleteStatus=0
 and date(student_fees_installment_details.Instalment_Date) = '", Fromdate_ ,"'
",Department_String,"
union
select 6 as tp,COALESCE(sum(student_fees_installment_details.Balance_Amount),0) as Data_Count
 from student
inner join Users on Users.Users_Id=student.User_Id
inner join student_course on student_course.Student_Id=student.Student_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Course_Id=student_course.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_master.Student_Fees_Installment_Master_Id=student_fees_installment_details.Student_Fees_Installment_Master_Id
where student.DeleteStatus=0 and student_fees_installment_details.DeleteStatus=0 and student.Status not in(18,19) 
 and date(student_fees_installment_details.Instalment_Date) = '", DATE_ADD(Fromdate_,INTERVAL 1 DAY) ,"'
",Department_String,"
union
SELECT 7 as tp,COALESCE(sum(receipt_voucher.Amount),0) Data_Count
From student 
inner join student_course on student_course.Student_Id=student.Student_Id
inner join receipt_voucher on receipt_voucher.Student_Course_Id=student_course.Student_Course_Id
where receipt_voucher.DeleteStatus=0 and  date( receipt_voucher.Date) >'",  Date_Sub(Fromdate_,INTERVAL C_Day DAY) ,"'
and date(receipt_voucher.Date) <= '", Fromdate_ ,"' "
,user_String,"
union
select 8 as tp,COALESCE(sum(student_fees_installment_details.Balance_Amount),0) as Data_Count
 from student
inner join Users on Users.Users_Id=student.User_Id
inner join student_course on student_course.Student_Id=student.Student_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Course_Id=student_course.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_master.Student_Fees_Installment_Master_Id=student_fees_installment_details.Student_Fees_Installment_Master_Id
where student.DeleteStatus=0 and student_fees_installment_details.DeleteStatus=0
  and date(student_fees_installment_details.Instalment_Date) > '",  Date_Sub(Fromdate_,INTERVAL C_Day DAY) ,"'
and date(student_fees_installment_details.Instalment_Date) <= '", Fromdate_ ,"'
",Department_String,"order by tp
    ");
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
#insert into data_log_ values(0,@query,'');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Document`( In Document_Id_ Int)
Begin 
 SELECT Document_Id,
Student_Id,
Document_Name,
Files From Document where Document_Id =Document_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Employer_Status`( )
Begin 
 SELECT Employer_Status_Id,
Employer_Status_Name,Followup,
User_Id From Employer_Status where  DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Exam_Details`( In Exam_Details_Id_ Int)
Begin 
 SELECT Exam_Details_Id,
Exam_Master_Id,
Question_Id,
Question_Name,
Option_1,
Option_2,
Option_3,
Option_4,
Question_Answer From Exam_Details where Exam_Details_Id =Exam_Details_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Exam_Master`( In Exam_Master_Id_ Int)
Begin 
 SELECT Exam_Master_Id,
Exam_Date,
Student_Id,
Subject_Id,
Subject_Name,
Start_Time,
End_Time,
Mark_Obtained,
User_Id From Exam_Master where Exam_Master_Id =Exam_Master_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Experience`( In Experience_Id_ Int)
Begin 
 SELECT Experience_Id,
Experience_Name,
User_Id From Experience where Experience_Id =Experience_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Fees_Instalment`( In Fees_Instalment_Id_ Int)
Begin 
 SELECT Fees_Instalment_Id,Student_Id,Course_Id,Fees_Type_Id,Instalment_Date,Amount,Status 
 From Fees_Instalment where Fees_Instalment_Id =Fees_Instalment_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Fees_Receipt`( In Fees_Receipt_Id_ Int)
Begin 
 SELECT Fees_Receipt_Id,
Fees_Installment_Id,
Course_Id,
Course_Name,
Student_Id,
Fees_Type_Id,
Fees_Type_Name,
Amount,
Date From Fees_Receipt where Fees_Receipt_Id =Fees_Receipt_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Fees_Type`( In Fees_Type_Id_ Int)
Begin 
 SELECT Fees_Type_Id,
Fees_Type_Name,
User_Id From Fees_Type where Fees_Type_Id =Fees_Type_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_FollowUp_Details`( In Student_Id_ Int)
Begin 
SELECT	student.Student_Followup_Id,student.Status,Status_Name,student.To_User_Id,
Users_Name To_User_Name,(Date_Format(Next_FollowUp_Date,'%Y-%m-%d')) As Next_FollowUp_Date,Remark,
By_User_Id,student.Student_Id,Status.FollowUp FollowUp
From student
inner join Status on student.Status=Status.Status_Id
inner join Users on student.To_User_Id=Users.Users_Id
 where student.Student_Id =Student_Id_  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_FollowUp_History`( In Student_Id_ Int)
Begin 
SET @query = Concat( " SELECT Status.Status_Name,(Date_Format(Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
(Date_Format(Entry_Date,'%d-%m-%Y-%h:%i')) As Entry_Date,
To_User.Users_Name To_User_Name,By_User.Users_Name By_User_Name,
Remark,convert(DATEDIFF(now(),Entry_Date),SIGNED) as Sort_Coloumn,FollowUp_Difference,(Date_Format(Actual_FollowUp_Date,'%d-%m-%Y')) As Actual_FollowUp_Date
From Student_Followup
inner join Status on Student_Followup.Status=Status.Status_Id
inner join Users To_User on Student_Followup.To_User_Id=To_User.Users_Id 
inner join Users By_User on Student_Followup.By_User_Id=By_User.Users_Id
where Student_Followup.Student_Id = ",Student_Id_,"   and Student_Followup.DeleteStatus=false
order by Student_Followup.Student_Followup_Id desc");
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
#convert(DATEDIFF(now,Entry_Date),SIGNED)
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Followup_Type`( In Followup_Type_Id_ Int)
Begin 
 SELECT Followup_Type_Id,
Followup_Type_Name,
User_Id From Followup_Type where Followup_Type_Id =Followup_Type_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Functionl_Area`( In Functionl_Area_Id_ Int)
Begin 
 SELECT Functionl_Area_Id,
Functionl_Area_Name,
User_Id From Functionl_Area where Functionl_Area_Id =Functionl_Area_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Individual_Notification`(In Student_Id_ int,Notification_Id_ int,Login_user_Id_ int)
BEGIN
declare Notification_Count_ int;
declare Old_Notification_Count int;
update notification set Read_Status=1 where Notification_Id =Notification_Id_ and DeleteStatus=0;
set Old_Notification_Count= (select Notification_Count from users where Users_Id = Login_user_Id_);
update users set Notification_Count = Old_Notification_Count-1 where Users_Id=Login_user_Id_;
set  Notification_Count_ = (select Notification_Count from users where Users_Id = Login_user_Id_) ;
select Notification_Count_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Installment_Details`(in Installment_Type_Id int,Course_Id_ int,Student_Course_Id_ int)
BEGIN
declare Receipt_Voucher_Id_ int;
declare Date_ date;
set Date_ =curdate();
if Student_Course_Id_>0 then
set Receipt_Voucher_Id_=(select Receipt_Voucher_Id from receipt_voucher where Student_Course_Id=Student_Course_Id_ and DeleteStatus=0 order by Receipt_Voucher_Id asc limit 1);
end if;
    if (Receipt_Voucher_Id_>0) then
        set Date_ =(select Date_Format(Date,'%Y-%m-%d') as Entry_Date from receipt_voucher where Receipt_Voucher_Id=Receipt_Voucher_Id_ and Student_Course_Id=Student_Course_Id_
         order by Receipt_Voucher_Id asc limit 1);    
         #insert into db_logs values(0,Date_,Receipt_Voucher_Id_);
    end if;
 select Course_Fees_Id ,Course_Id , Fees_Type_Id , Amount Fees_Amount,Instalment_Period ,Period_Id,(Date_Format(Period_From,'%Y-%m-%d')) as Period_From,
 (Date_Format(Period_To,'%Y-%m-%d')) as Period_To,Tax Tax_Percentage,1 as Status,Amount as Balance_Amount
from course_fees where Date_ between Period_From and Period_To and Course_Id=Course_Id_ and Fees_Type_Id = Installment_Type_Id and DeleteStatus=0
order by Instalment_Period asc;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Interview`(in Interview_Master_Id_ int,Course_Id_ int)
BEGIN
select Student.Student_Id,Student_Name,Course_Name,Interview_student.Interview_Master_Id,interview_master.Description,
case when Interview_student.Interview_Master_Id>0 then 1 else 0 end as Check_Box
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id 
and student_course.Course_Id=Course_Id_  and student_course.DeleteStatus=0
inner join Interview_student on Interview_student.Student_Id=Student.Student_Id
and Interview_Master_Id=Interview_Master_Id_ 
inner join interview_master on interview_master.Interview_Master_Id=Interview_student.Interview_Master_Id 
and  Interview_student.DeleteStatus=0
where Student.DeleteStatus=0 order by Student_Name asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Interview_Student`(In Transaction_Master_Id_ int)
BEGIN

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Job_Opening_Followup_History`(In Job_Opening_Id_ int )
Begin 
 SELECT job_opening_followup.Job_Opening_Followup_Id,job_opening_followup.Job_Opening_Id,DATE_FORMAT(job_opening_followup.Followup_Date, '%d-%m-%Y') AS Followup_Date,
 DATE_FORMAT(job_opening_followup.Entry_Date, '%d-%m-%Y-%h:%m:%s') AS Entry_Date,
 DATE_FORMAT(job_opening_followup.Actual_Followup_Date, '%d-%m-%Y') AS Actual_Followup_Date,
 job_opening_followup.Employee_Status_Id,job_opening_followup.Employee_Status_Name,job_opening_followup.To_Staff_Id,job_opening_followup.To_Staff_Name,job_opening_followup.Remark,
 job_opening_followup.By_User_Id,job_opening_followup.By_User_Name,  IFNULL(Followup,0) Followup From job_opening_followup
 INNER JOIN job_opening ON job_opening.Job_Opening_Id = job_opening_followup.Job_Opening_Id 
 where  job_opening_followup.DeleteStatus=false and job_opening_followup.Job_Opening_Id =Job_Opening_Id_ order by  job_opening_followup.Entry_Date,job_opening_followup.Job_Opening_Followup_Id desc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Job_Posting`( In Job_Posting_Id_ Int)
Begin 
SELECT Job_Posting_Id,Job_Code,Job_Title,Descritpion,Skills,No_Of_Vaccancy,Experience,
Job_Location,Qualification,Functional_Area,Specialization,Salary,Last_Date,Company_Name,
Address,Contact_Name,Contact_No,Email,Address1,Address2,Address3,Address4,Pincode,Status,
Logo,User_Id ,Company_Id,Course_Id,Course_Name,Gender_Id,Gender_Name,Last_Time
From Job_Posting where Job_Posting_Id =Job_Posting_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Last_Candidate_FollowUp`( In User_Id_ Int)
Begin 
Declare Followup_Id_ int;
set Followup_Id_=(select Max(Candidate_Followup_Id) from Candidate_followup where By_User_Id =User_Id_ and DeleteStatus=false);

 SELECT Candidate_followup.Status,Candidate_followup.To_User_Id,
Users.Users_Name To_User_Name ,status.FollowUp  FollowUp,By_User_Id,Status_Name
From Candidate_followup
inner join status on Candidate_followup.Status=status.Status_Id
inner join Users on Candidate_followup.To_User_Id=Users.Users_Id 
and Candidate_followup.Candidate_Followup_Id=Candidate_followup.Candidate_Followup_Id
 where Candidate_followup.Candidate_FollowUp_Id =Followup_Id_  and Candidate_followup.DeleteStatus=false;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Last_FollowUp`( In User_Id_ Int)
Begin 
Declare Followup_Id_ int;
set Followup_Id_=(select Max(Student_Followup_Id) from student_followup where By_User_Id =User_Id_ and DeleteStatus=false);

 SELECT student_followup.Status,student_followup.To_User_Id,
Users.Users_Name To_User_Name ,status.FollowUp  FollowUp,By_User_Id,Status_Name
From student_followup
inner join status on student_followup.Status=status.Status_Id
inner join Users on student_followup.To_User_Id=Users.Users_Id 
and student_followup.Student_Followup_Id=student_followup.Student_Followup_Id
 where student_followup.Student_FollowUp_Id =Followup_Id_  and student_followup.DeleteStatus=false;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Lead_Load_Data_ByUser`(In Login_User Int )
BEGIN
declare User_Type_ int;
set User_Type_=(select User_Type from user_details where User_Details_Id=Login_User);
if User_Type_=2 then
 	#SET SearchbyName_Value =concat(SearchbyName_Value," and User_Details_Id =",Login_Id_);
    SELECT User_Details_Id,User_Details_Name From user_details  where  DeleteStatus=false and User_Details_Id =Login_User order by  User_Details_Name asc ;  
else
	SELECT User_Details_Id,User_Details_Name From user_details  where  DeleteStatus=false and User_Details_Id in (select User_Details_Id from user_details where Branch_Id in (select
	distinct Branch_Id from user_department where User_Id =Login_User and VIew_All=1)) order by  User_Details_Name asc ;   
end if;
#SELECT Department_Id,Department_Name From department where  DeleteStatus=false  order by Department_Name asc ;
#SELECT User_Details_Id,User_Details_Name From user_details  where  DeleteStatus=false order by  User_Details_Name asc ;
SELECT Department_Id,Department_Name From department where  Is_Delete=false and
Department_Id in (select distinct Department_Id from user_department where User_Id =Login_User and View_Entry=1) order by Department_Name asc ;
SELECT Branch_Id,Branch_Name From branch where  Is_Delete=false and Branch_Id in (select
	distinct Branch_Id from user_department where User_Id =Login_User and VIew_Entry=1) order by Branch_Name asc ;
SELECT Fees_Id,Fees_Name From fees where  DeleteStatus=false  order by Fees_Name asc; 
SELECT Remarks_Id,Remarks_Name From remarks where  DeleteStatus=false  order by Remarks_Name asc; 
SELECT Department_Status_Id,Department_Status_Name From department_status where  Is_Delete=false  order by Department_Status_Name asc ;    
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Load_Dropdowns_Data`()
BEGIN
SELECT State_Id,State_Name from State where DeleteStatus=false  order by State_Id asc ;
SELECT Gender_Id,Gender_Name from Gender where DeleteStatus=false order by  Gender_Id asc ;
SELECT Qualification_Id,Qualification_Name from Qualification where DeleteStatus=false  order by Qualification_Id asc ;
SELECT Enquiry_Source_Id,Enquiry_Source_Name from Enquiry_Source where DeleteStatus=false  order by Enquiry_Source_Id asc ;
SELECT Installment_Type_Id,Installment_Type_Name,No_Of_Installment,Duration from installment_type where DeleteStatus=false  order by Installment_Type_Id asc; 
SELECT Exam_Status_Id,Exam_Status_Name from Exam_Status where DeleteStatus=false  order by Exam_Status_Id asc; 
SELECT Mode_Id,Mode_Name from Mode where DeleteStatus=false  order by Mode_Id asc; 
SELECT Client_Accounts_Id,Client_Accounts_Name
from client_accounts where DeleteStatus=false and Account_Group_Id = 35 order by Client_Accounts_Id asc;
select Course_Id,Course_Name from course where DeleteStatus=false order by Course_Id asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Login_User_Type`( In Login_User_ Int)
Begin 
 SELECT Users_Id,Users_Name,User_Type,Role_Id From users where Users_Id=Login_User_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Mark_List`( In Mark_List_Id_ Int)
Begin 
 SELECT Mark_List_Id,
Student_Id,
Course_Id,
Course_Name,
Subject_Id,
Subject_Name,
Minimum_Mark,
Maximum_Mark,
Mark_Obtained,
User_Id From Mark_List where Mark_List_Id =Mark_List_Id_ and DeleteStatus=false ;
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
User_Menu_Selection.Menu_Status,Menu_Type
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
CREATE DEFINER=`root`@`%` PROCEDURE `get_Notification_Status`( In Student_Id_ Int)
Begin
SELECT  Student_Status ,Resume_Status_Id  ,Resume_Status_Name,Resume,Image_ResumeFilename
 From student where Student_Id =Student_Id_ and DeleteStatus=false ;
 select  student_course.Course_Name,Duration,Batch_Complete_Status ,
(Date_Format(Batch_Complete_Date ,'%d-%m-%Y')) As Batch_Complete_Date,
(Date_Format(batch.Start_Date ,'%d-%m-%Y')) As Start_Date
 from student_course inner join batch on
batch.batch_id=student_course.batch_id  where Student_Id =Student_Id_ limit 1;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_OTP`(In Phone_ Varchar(100),OTP_ int)
BEGIN
#insert into db_Logs values (4,Phone_,OTP_); as Student_Id_
	update student set OTP=OTP_ where Phone=Phone_ and DeleteStatus=0;
	select Student_Id Student_Id_ ,OTP_ from student where Phone=Phone_ and DeleteStatus=0;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Outstanding_Fees`()
BEGIN
select  student.Student_Id,Student_Name Student,student.Phone,student_course.Batch_Name Batch,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
sum(student_fees_installment_details.Balance_Amount) as Amount,
student_course.Course_Name Course,users.Users_Name teammember ,users.Mobile as Mobile, DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 7 DAY) before_sevendays,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 2 DAY) before_twodays
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18,19) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and ((current_date()= DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 7 DAY)) or (current_date() = DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 2 DAY))) group by student.Student_Id,Student_Name  order by student.Student_Id ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Outstanding_Fees_Whatsapp`()
BEGIN
select  student.Student_Id,Student_Name Student,student.Phone,student_course.Batch_Name Batch,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
sum(student_fees_installment_details.Balance_Amount) as Amount,
student_course.Course_Name Course,users.Users_Name teammember ,users.Mobile as UserMobile, DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 3 DAY) before_theredays,
DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY) before_onedays,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY) today
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18,19) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and ((current_date()= DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 3 DAY)) or (current_date() = DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 1 DAY))) or curdate() = student_fees_installment_details.Instalment_Date group by student.Student_Id,Student_Name  order by student.Student_Id ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Overdue_Fees_Whatsapp`()
BEGIN
select  student.Student_Id,Student_Name Student,student.Phone,student_course.Batch_Name Batch,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
sum(student_fees_installment_details.Balance_Amount) as Amount,
student_course.Course_Name Course,users.Users_Name teammember ,users.Mobile as UserMobile,DATE_SUB(student_fees_installment_details.Instalment_Date, INTERVAL 0 DAY) duedate
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18,19) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
and  curdate() >= student_fees_installment_details.Instalment_Date group by student.Student_Id,Student_Name  order by student.Student_Id ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Part`( In Part_Id_ Int)
Begin 
 SELECT Part_Id,
Part_Name,
User_Id From Part where Part_Id =Part_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Period`(In Period_Id_ Int)
Begin 
SELECT Period_Id,Period_Name,(Date_Format(Period_From,'%d-%m-%Y')) As Start_Date,(Date_Format(Period_From,'%Y-%m-%d')) As  Start_Date,
(Date_Format(Period_To,'%d-%m-%Y')) As End_Date,(Date_Format(Period_To,'%Y-%m-%d')) As  End_Date 
 
From Period
where Period_Id =Period_Id_ and DeleteStatus=false;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Placed`(in Placed_Master_Id_ int,Course_Id_ int)
BEGIN
select Student.Student_Id,Student_Name,Course_Name,placed_master.Description,
case when Placed_student.Placed_Master_Id>0 then 1 else 0 end as Check_Box
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id 
and student_course.Course_Id=Course_Id_  and student_course.DeleteStatus=0
inner join Placed_student on Placed_student.Student_Id=Student.Student_Id
and Placed_Master_Id=Placed_Master_Id_ 
inner join placed_master on placed_master.Placed_Master_Id=Placed_student.Placed_Master_Id 
and  Placed_student.DeleteStatus=0
where Student.DeleteStatus=0;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Qualification`( In Qualification_Id_ Int)
Begin 
 SELECT Qualification_Id,
Qualification_Name,
User_Id From Qualification where Qualification_Id =Qualification_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Question`( In Question_Id_ Int)
Begin 
 SELECT Question_Id,
Question_Name,
Option_1,
Option_2,
Option_3,
Option_4,
Correct_Answer,
Subject_Id,
Subject_Name,
Course_Id,
Course_Name,
Semester_Id,
Semester_Name From Question where Question_Id =Question_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Question_Import`( In Question_Import_Master_Id_ Int)
Begin 
 SELECT Question_Id,Question_Name,Option_1,Option_2,Option_3,Option_4,
Correct_Answer
 From Question where Question_Import_Master_Id =Question_Import_Master_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Receipt_History`( In Agent_Id_ int)
BEGIN
declare From_Account_Id_ int;
set From_Account_Id_=(select Client_Accounts_Id from Agent Where Agent_Id=Agent_Id_ and Agent.DeleteStatus=false);
 SELECT Receipt_Voucher_Id,Receipt_Voucher.From_Account_Id,FromAcc.Client_Accounts_Name as FromAccount_Name,
(Date_Format(Receipt_Voucher.Date,'%Y-%m-%d')) As Date ,(Date_Format(Receipt_Voucher.Date,'%d-%m-%Y')) As Search_Date ,
Amount,Receipt_Voucher.To_Account_Id,
ToAcc.Client_Accounts_Name as ToAccount_Name,Concat( Receipt_Voucher.Voucher_No ,'') Voucher_No,
Receipt_Voucher.User_Id,Receipt_Voucher.Description,Payment_Mode,Payment_Status,Mode_Name
 From Receipt_Voucher 
inner join Client_Accounts as FromAcc on FromAcc.Client_Accounts_Id=Receipt_Voucher.From_Account_Id
inner join Client_Accounts as ToAcc on ToAcc.Client_Accounts_Id=Receipt_Voucher.To_Account_Id
inner join Mode on Receipt_Voucher.Payment_Mode=Mode.Mode_Id
inner join Users on Receipt_Voucher.User_Id=Users.Users_Id
 where Receipt_Voucher.DeleteStatus=false and  From_Account_Id=From_Account_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Resumefilefor_Report`( In Student_Id_ Int)
Begin 
 SELECT Resume,Image_ResumeFilename,Student_Name,Course_Name
From student  INNER JOIN student_course ON student_course.Student_Id=student.Student_Id
 where student.Student_Id =Student_Id_ and student.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Self_Placement`( In Student_Id_ Int)
Begin 
 SELECT Self_Placement_Id , 
Company_Name ,
Designation , 
(Date_Format(self_placement.Placed_Date,'%d-%m-%Y')) as Placed_Date ,(Date_Format(self_placement.Placed_Date,'%Y-%m-%d')) as Placed_Date_s ,
Student_Course_Id ,
Student_Id  From self_placement where Student_Id =Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Settings`( In Settings_Id_ Int)
Begin 
 SELECT Settings_Id,
Settings_Name,
Settings_Group From Settings where Settings_Id =Settings_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Specialization`( In Specialization_Id_ Int)
Begin 
 SELECT Specialization_Id,
Specialization_Name,
User_Id From Specialization where Specialization_Id =Specialization_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_State_District`(in State_Id_ int)
BEGIN
select State_District_Id,District_Name,State_Id from state_district
where DeleteStatus=0 and State_Id=State_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Status`( )
Begin 
 SELECT Status_Id,
Status_Name,
User_Id From Status where  DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student`( In Student_Id_ Int)
Begin
SELECT Student_Id,Student_Name,IFNULL(Address1,'') Address1,IFNULL(Address2,'') Address2,IFNULL(Address3,'') Address3,IFNULL(Address4,'') Address4,IFNULL(Pincode,'') Pincode,Phone,IFNULL(Mobile,'') Mobile,IFNULL(Whatsapp,'') Whatsapp,Gender,Email,
IFNULL(Alternative_Email,'') Alternative_Email,IFNULL(Passport_No,'') Passport_No,IFNULL(Passport_Expiry,'') Passport_Expiry,User_Name,Password,IFNULL(Photo,'') Photo ,Student.User_Id,Registered_By,
Registered,Registered_On,Registration_No,IFNULL(Role_No,'') Role_No,Enquiry_Source,Student.State_Id,Student.District_Id,To_User_Id,
Student.Course_Id,Student.Qualification_Id,District_Name,Course_Name,IFNULL(College_Name,'') College_Name,
(Date_Format(student.DOB,'%Y-%m-%d')) as DOB,Mail_Status,Status,Student_Status,Blacklist_Status,Activate_Status,Fees_Status,IFNULL(Year_Of_Pass_Id,0) Year_Of_Pass_Id,
IFNULL(Year_Of_Passing,'') Year_Of_Passing,
Id_Proof_Id , Id_Proof_Name ,Id_Proof_No ,IFNULL(Id_Proof_FileName,'') Id_Proof_FileName,IFNULL(Id_Proof_File ,'') Id_Proof_File,Resume_Status_Id,Resume_Status_Name,Image_ResumeFilename,Resume
From Student
left join State on State.State_Id=Student.State_Id
left join state_district on state_district.State_District_Id=Student.District_Id
left join Course on Course.Course_Id=Student.Course_Id
left join qualification on qualification.Qualification_Id=Student.Qualification_Id
where Student_Id =Student_Id_ and Student.DeleteStatus=false ;

select Student_Course_Id,Course_Name,Course_Id,Student_Id,Batch_Name,sum(Fee_Paid) as Fee_Paid,Faculty_Id ,Users_Name as trainer from student_course  
inner join users on student_course.Faculty_Id=users.Users_Id where Student_Id=Student_Id_ and student_course.DeleteStatus=0
group by Student_Course_Id,Course_Name,Course_Id,Student_Id,Batch_Name,Faculty_Id ,Users_Name;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Course`( In Student_Id_ Int)
Begin 
SELECT Student_Course_Id,Student_Id,Course_Name_Details,Course_Id,Course_Name,By_User_Id,Status ,Course_Type_Id,
Course_Type_Name,Total_Fees,Agent_Amount,Batch_Id,Batch_Name,Faculty_Id,users.Users_Name Faculty_Name,
Installment_Type_Id,No_Of_Installment,Duration,
	(Date_Format(Student_Course.Entry_Date,'%Y-%m-%d')) As Entry_Date,(Date_Format(Student_Course.Start_Date,'%Y-%m-%d')) As Start_Date,
	(Date_Format(Student_Course.Join_Date,'%Y-%m-%d')) As Join_Date,(Date_Format(Student_Course.End_Date,'%Y-%m-%d')) As End_Date
	From Student_Course
	left join  users on users.Users_Id=Student_Course.Faculty_Id
	where Student_Id =Student_Id_ and Student_Course.DeleteStatus=false ;
    
SELECT Student_Course_Subject_Id,Student_Id,Course_Id,Course_Name,Subject_Id,Subject_Name,Part.Part_Id,Part_Name,
	Minimum_Mark,Maximum_Mark,Online_Exam_Status,No_of_Question,Exam_Duration,Exam_Attended_Status ,Online_Exam_Status_Name
	From Student_Course_Subject 
        inner join  Part on Part.Part_Id=Student_Course_Subject.Part_Id
        inner join  Online_Exam_Status on Online_Exam_Status.Online_Exam_Status_Id=Student_Course_Subject.Online_Exam_Status
	where Student_Id =Student_Id_ and Student_Course_Subject.DeleteStatus=false and Student_Course_Id=Student_Course_Id_;
    
SELECT student_fees_installment_master.Student_Fees_Installment_Master_Id,Student_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,
Fees_Type_Name,Amount ,No_Of_Instalment,Instalment_Period,Instalment_Date,Student_Fees_Installment_Details_Id,Fees_Amount,Status,Balance_Amount,
Tax,Tax_Percentage
	From student_fees_installment_master
        inner join  student_fees_installment_details on student_fees_installment_master.Student_Fees_Installment_Master_Id=student_fees_installment_details.Student_Fees_Installment_Master_Id
	where  Student_Course_Id=Student_Course_Id_ and Student_Id =Student_Id_ and student_fees_installment_master.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Course_Click`( In Student_Id_ Int,Student_Course_Id_ int,Fees_Type_Id_ int)
Begin 
SELECT Student_Course_Id,Student_Id,Course_Name_Details,Course_Id,Course_Name,By_User_Id,Status ,Course_Type_Id,
Course_Type_Name,Total_Fees,Agent_Amount,Batch_Id,Batch_Name,Faculty_Id,users.Users_Name Faculty_Name,
Installment_Type_Id,No_Of_Installment,Duration,Laptop_details_Id,Laptop_details_Name,
	(Date_Format(Student_Course.Entry_Date,'%Y-%m-%d')) As Entry_Date,(Date_Format(Student_Course.Start_Date,'%Y-%m-%d')) As Start_Date,
	(Date_Format(Student_Course.Join_Date,'%Y-%m-%d')) As Join_Date,(Date_Format(Student_Course.End_Date,'%Y-%m-%d')) As End_Date,Start_Time,End_Time
	From Student_Course
	left join  users on users.Users_Id=Student_Course.Faculty_Id
	where Student_Id =Student_Id_ and Student_Course_Id=Student_Course_Id_ and Student_Course.DeleteStatus=false ;
    
SELECT Student_Course_Subject_Id,Student_Id,Course_Id,Course_Name,Subject_Id,Subject_Name,Part.Part_Id,Part_Name,
	Minimum_Mark,Maximum_Mark,Online_Exam_Status,No_of_Question,Exam_Duration,Exam_Attended_Status ,Online_Exam_Status_Name,Task  ,Day,Heading
	From Student_Course_Subject 
        inner join  Part on Part.Part_Id=Student_Course_Subject.Part_Id
        inner join  Online_Exam_Status on Online_Exam_Status.Online_Exam_Status_Id=Student_Course_Subject.Online_Exam_Status
	where Student_Id =Student_Id_ and Student_Course_Id=Student_Course_Id_  and Student_Course_Subject.DeleteStatus=false ;

    
SELECT student_fees_installment_master.Student_Fees_Installment_Master_Id,Student_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,
Fees_Type_Name,Amount ,No_Of_Instalment,Instalment_Period,Instalment_Date,Student_Fees_Installment_Details_Id,Fees_Amount,Status,Balance_Amount,
Tax,Tax_Percentage
	From student_fees_installment_master
        inner join  student_fees_installment_details on student_fees_installment_master.Student_Fees_Installment_Master_Id=student_fees_installment_details.Student_Fees_Installment_Master_Id
	where Student_Id =Student_Id_ and student_fees_installment_master.Student_Course_Id=Student_Course_Id_ 
  #  and student_fees_installment_master.Fees_Type_Id=Fees_Type_Id_ 
    and student_fees_installment_master.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Course_Subject`( In Student_Course_Subject_Id_ Int)
Begin 
 SELECT Student_Course_Subject_Id,Student_Id,Course_Id,Course_Name,Subject_Id,Subject_Name,
Minimum_Mark,Maximum_Mark,Online_Exam_Status,No_of_Question,Exam_Duration,Exam_Attended_Status 
From Student_Course_Subject 
where Student_Course_Subject_Id =Student_Course_Subject_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Followup`( In Student_Followup_Id_ Int)
Begin 
 SELECT Student_Followup_Id,
Student_Id,
Entry_Date,
Next_FollowUp_Date,
FollowUp_Difference,
Status,
User_Id,
Remark,
Remark_Id,
FollowUp_Type,
FollowUP_Time,
Actual_FollowUp_Date From Student_Followup where Student_Followup_Id =Student_Followup_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Mark_List`(in Student_Id_ int)
BEGIN
select Mark_List_Master_Id ,Student_Id ,Course_Id ,Course_Name ,User_Id
from Mark_List_Master where Student_Id=Student_Id_ and DeleteStatus=0;

select mark_list.Mark_List_Master_Id ,Subject_Id ,Subject_Name ,Minimum_Mark ,Maximum_Mark ,
	Mark_Obtained ,Grade,mark_list.Exam_Status_Id,Exam_Status_Name
	from mark_list
	inner join mark_list_master on mark_list_master.Mark_List_Master_Id=mark_list.Mark_List_Master_Id
	inner join Exam_Status on Exam_Status.Exam_Status_Id=mark_list.Exam_Status_Id
where mark_list_master.Student_Id=Student_Id_ and mark_list.DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Receipt_History`( In Student_Id_ int,Course_Id_ int)
BEGIN
declare From_Account_Id_ int;
set From_Account_Id_=(select Client_Accounts_Id from Student Where Student_Id=Student_Id_ and Student.DeleteStatus=false);
 SELECT Receipt_Voucher_Id,Receipt_Voucher.From_Account_Id,FromAcc.Client_Accounts_Name as FromAccount_Name,
(Date_Format(Receipt_Voucher.Date,'%Y-%m-%d')) As Date ,(Date_Format(Receipt_Voucher.Date,'%d-%m-%Y')) As Search_Date ,
Amount,Receipt_Voucher.To_Account_Id,
ToAcc.Client_Accounts_Name as ToAccount_Name,Concat( Receipt_Voucher.Voucher_No ,'') Voucher_No,
Receipt_Voucher.User_Id,Receipt_Voucher.Description,Payment_Mode,Payment_Status,Mode_Name,
Receipt_Voucher.Bill_No,Receipt_Voucher.Student_Course_Id,Receipt_Voucher.Fees_Type_Id,
Receipt_Voucher.Center_Code,Tax_Percentage,Receipt_Voucher.Student_Fees_Installment_Details_Id,
ToAcc.Client_Accounts_No as Company_Name,ToAcc.Address1 as Address1,
ToAcc.Address2 as Address2,ToAcc.Address3 as Address3,
ToAcc.PinCode as PinCode,ToAcc.GSTNo as GSTNo,Receipt_Image_File,Receipt_Image_File_Name
 From Receipt_Voucher 
inner join Client_Accounts as FromAcc on FromAcc.Client_Accounts_Id=Receipt_Voucher.From_Account_Id
inner join Client_Accounts as ToAcc on ToAcc.Client_Accounts_Id=Receipt_Voucher.To_Account_Id
inner join Mode on Receipt_Voucher.Payment_Mode=Mode.Mode_Id
inner join Users on Receipt_Voucher.User_Id=Users.Users_Id
 where Receipt_Voucher.DeleteStatus=false and  From_Account_Id=From_Account_Id_ and  Course_Id= Course_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Student_Receipt_Image`( In Receipt_Voucher_Id_ int)
BEGIN
 SELECT Receipt_Image_File,Receipt_Image_File_Name
 From Receipt_Voucher 
 where Receipt_Voucher.DeleteStatus=false and  Receipt_Voucher_Id=Receipt_Voucher_Id_ ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Study_Materials`( In Study_Materials_Id_ Int)
Begin 
 SELECT Study_Materials_Id,
Course_Id,
Part_Id,
Subject_Id,
Course_Subject_Id,
Study_Materials_Name,
File_Name From Study_Materials where Study_Materials_Id =Study_Materials_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Subject`( In Subject_Id_ Int)
Begin 
 SELECT Subject_id,
Subject_Name,
Exam_status,
User_Id From Subject where Subject_Id =Subject_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_ToStaff_Mobile`(In userid int )
Begin 
 SELECT Users_Name,Mobile From users where  DeleteStatus=false AND Users_Id=userid ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Transaction`(in Transaction_Master_Id_ int,Course_Id_ int)
BEGIN
declare Portion_Covered_ int;
#set Portion_Covered_ = (select Portion_Covered from transaction_master where Course_Id = Course_Id_ );
select Student.Student_Id,Student_Name,Course_Name,transaction_master.Portion_Covered,transaction_master.Description,
Transaction_student.Transaction_Master_Id,
case when Transaction_student.Transaction_Master_Id>0 then 1 else 0 end as Check_Box
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id 
and student_course.Course_Id=Course_Id_ and student_course.DeleteStatus=0
left join Transaction_student on Transaction_student.Student_Id=Student.Student_Id
and Transaction_Master_Id=Transaction_Master_Id_
inner join transaction_master on transaction_master.Transaction_Master_Id=transaction_student.Transaction_Master_Id 
and  Transaction_student.DeleteStatus=0 
where Student.DeleteStatus=0 order by Student_Name asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_University`( In University_Id_ Int)
Begin 
 SELECT University_Id,
University_Name,
Address1,
Address2,
Address3,
Address4,
Pincode,
Phone,
Mobile,
Email,
User_Id From University where University_Id =University_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_University_Followup`( In University_Followup_Id_ Int)
Begin 
 SELECT University_Followup_Id,
University_Id,
Entry_Date,
Next_FollowUp_Date,
FollowUp_Difference,
Status,
User_Id,
Remark,
Remark_Id,
FollowUp_Type,
FollowUP_Time,
Actual_FollowUp_Date,
Entry_Type From University_Followup where University_Followup_Id =University_Followup_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Users_Edit`( In Users_Id_ Int)
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
  and User_Id =Users_Id_ where Menu.Menu_Status=1 and
  Menu.DeleteStatus=false order by Menu_Id ;
 End$$
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
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Role`( In User_Role_Id_ Int)
Begin 
 SELECT User_Role_Id,
User_Role_Name,
Role_Under_Id From User_Role where User_Role_Id =User_Role_Id_ and DeleteStatus=false ;
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
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Sub_Edit`( In User_Id_ Int)
Begin 
 SELECT users.Users_Id User_Selection_Id,Users_Name,
 case when user_sub.User_Selection_Id>0 then 1 else 0 end as Check_Box
 From Users  
 left join user_sub on  Users.Users_Id=user_sub.User_Selection_Id and 
 user_sub.DeleteStatus=false   and user_sub.Users_Id=User_Id_
  where Users.DeleteStatus=false order by user_sub.Users_Id ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_User_Type`( )
Begin 
 SELECT User_Type_Id,
User_Type_Name From User_Type where  DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Get_Vacancy_Source`( )
Begin 
 SELECT Vacancy_Source_Id,
Vacancy_Source_Name From Vacancy_Source where  DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `History_Of_Interview_Schedule`(In Student_Id_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Student_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_candidate.Candidate_Id =",Student_Id_);
end if;

SET @query = Concat("  SELECT job_posting.Job_Title Job,Company_Name,(Date_Format(job_posting.Entry_Date,'%d-%m-%Y')) As Job_post_date,Student_Name,
(Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) As Reject_date,applied_jobs.Remark,(Date_Format(applied_jobs.Interview_Date,'%d-%m-%Y')) As Interview_Date,
(Date_Format(applied_jobs.Placement_Date,'%d-%m-%Y')) As Placement_Date,
 CASE
                WHEN job_candidate.Apply_Status = 1 THEN 'Apply'
                  WHEN job_candidate.Apply_Status = 2 THEN 'Reject'
                    WHEN job_candidate.Apply_Status = 0 THEN 'Not Responded'
            END AS Apply_Status_Name,
            
            CASE
                WHEN applied_jobs.Interview_Status = 1 THEN 'Interview Scheduled'
                ELSE 'Interview Not Scheduled'
            END AS Interview_Status_Name,
            CASE
                WHEN applied_jobs.Placement_Status = 1 THEN 'Placed'
                ELSE 'Not Placed'
            END AS Placement_Status_Name,Resume_Status_Name
            

 From  job_candidate
inner join student on Student.Student_Id=job_candidate.Candidate_Id
inner join job_posting on job_candidate.Job_Id=job_posting.Job_Posting_Id
Left join applied_jobs on job_candidate.Job_Id=applied_jobs.Job_Id
where   Student.DeleteStatus=0 and Student.Registered=1 and   job_posting.DeleteStatus=0 
" ,SearchbyName_Value , " 
order by Student.Student_Id ASC 
" );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Job_Apply_Reject`( In Apply_Type_ int,Job_Id_ int, Student_Id_ int,Remark_ varchar(100))
Begin 
declare Applied_Jobs_Id_ int;declare total_rejection_ int;declare Black_List_ int;
declare Entry_Date_ datetime;declare Resume_staus_ int;
if Apply_Type_ =1 then 
set Remark_='';
end if;
set Resume_staus_ =( select Resume_Status_Id from student where Student_Id=Student_Id_);
 if Resume_staus_=3 then
		set Entry_Date_=now();
		  if ifnull(Apply_Type_,0)=0 then 
		  set Apply_Type_=1; 
		  end if;
		 SET Applied_Jobs_Id_ = (SELECT  COALESCE( MAX(Applied_Jobs_Id ),0)+1 FROM applied_jobs); 
		 INSERT INTO applied_jobs(Applied_Jobs_Id ,Student_Id ,Job_Id,Entry_Date,Apply_Type,DeleteStatus,Remark,Current_Status,Interview_Status,Placement_Status) 
		values (Applied_Jobs_Id_,Student_Id_,Job_Id_,Entry_Date_,Apply_Type_,false,Remark_,1,0,0);
		  
		 if Apply_Type_=1 then
			update student set applied=applied+1 where Student_Id=Student_Id_;
			update job_posting set Applied_Count=Applied_Count+1 where Job_Posting_Id=Job_Id_;
			update job_candidate set Apply_Status=1 where Job_Id=Job_Id_ and Candidate_Id = Student_Id_;
		elseif Apply_Type_=2 then
			update student set rejected=rejected+1 where Student_Id=Student_Id_;
			update job_posting set Reject_Count=Reject_Count+1 where Job_Posting_Id=Job_Id_;
			 update job_candidate set Apply_Status=2 where Job_Id=Job_Id_ and Candidate_Id = Student_Id_;
			#set total_rejection_ = (select Rejected from student where Student_Id=Student_Id_);
			#set Black_List_ =(select mod(total_rejection_,3));
			#if Black_List_ =0 then 
				#update student set Blacklist_Status=true where Student_Id=Student_Id_;
			#end if;
		end if;
else 
set Applied_Jobs_Id_ =-1 ;
end if;
insert into data_log_ values(0,Applied_Jobs_Id_,Job_Id_);
 select Applied_Jobs_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Job_Apply_Reject_Interview`( In Student_Id_ int,Applied_Jobs_Id_ int,Interview_Type_ int,Remark_ varchar(100))
Begin 

if Interview_Type_ =1 or 3 then 
set Remark_='';
end if;

update applied_jobs set Interview_Attending_Rejecting =Interview_Type_ ,Interview_Attending_Rejecting_Date = now(),Interview_Rejection_Remark=Remark_ 
where Student_Id=Student_Id_ and Applied_Jobs_Id = Applied_Jobs_Id_;

select Applied_Jobs_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Job_Opening_Pending_Followups_Report`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Job_id_ varchar(100),Team_Member_Selection_ varchar(500),
Employee_Status_Id_ int,Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(job_opening.Next_Followup_Date) >= '", Fromdate_ ,"' and  date(job_opening.Next_Followup_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

if Team_Member_Selection_!=''   and   Team_Member_Selection_!='0'  then
    set SearchbyName_Value=concat(" and job_opening.To_Staff_Id in(",Team_Member_Selection_,")");
end if;

if Job_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_opening.Job_Opening_Id =",Job_id_);
end if;
if Employee_Status_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_opening.Employee_Status_Id =",Employee_Status_Id_);
end if;

SET @query = Concat("SELECT Job_Title,Company_Name,
Employee_Status_Name,To_Staff_Name,DATE_FORMAT(Next_Followup_Date, '%d-%m-%Y') AS Next_Followup_Date, DATE_FORMAT(Entry_Date, '%d-%m-%Y') AS Entry_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY job_opening.Job_Opening_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From job_opening
where job_opening.DeleteStatus=false and job_opening.Job_Posting_Id =0 and Followup=1 " ,SearchbyName_Value , " ",Search_Date_,"
order by Job_Opening_Id ASC" );

PREPARE QUERY FROM @query;EXECUTE QUERY;
insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Job_Opening_Pending_Followups_Summary`(In  By_User_ varchar(200),Login_User_ int)
BEGIN
declare Search_Date_ varchar(500);declare Department_String varchar(2000);declare User_Type_ int;
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_);
 #if User_Type_=2 then
 #	SET Department_String =concat(Department_String," and student.To_User_Id =",Login_User_);
#else
	SET Department_String =concat(Department_String," and (student.To_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_, " ) or student.To_User_Id =" , Login_User_, ")");
#end if; 
 

		#set Search_Date_=concat( " and student.Next_FollowUp_Date >= '", From_Date_ ,"' and student.Next_FollowUp_Date <= '", To_Date_,"'");
	set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
 
/*if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;*/

if By_User_!=''   and   By_User_!='0'  then
    set SearchbyName_Value=concat(" and student.To_User_Id in(",By_User_,")");
end if;

SET @query = Concat( "select users.Users_Name To_Staff,Agent_Name as Branch, count(student.Student_Id) as Pending,users.Users_Id
from student
inner join users on users.Users_Id=student.To_User_Id
inner join agent on agent.Agent_Id = users.Agent_Id
inner join status on status.Status_Id = student.Status
where student.DeleteStatus=0 and student.Registered=0 and status.FollowUp=1 and student.Status not in(18,19)",SearchbyName_Value," ",Department_String,"",Search_Date_,"
group by student.To_User_Id
 ");
/*group by student.User_Id*/
PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Job_Post_Exist_Check`(In Job_Opening_Id_ int )
Begin 

SELECT COALESCE(jp.Job_Posting_Id, 0) AS Job_Posting_Id 
FROM job_opening jo
LEFT JOIN job_posting jp ON jo.Job_Opening_Id = jp.Job_Opening_Id
WHERE jo.Job_Opening_Id = Job_Opening_Id_;

#select (IFNULL(Job_Posting_Id, 0)) AS Job_Posting_Id from job_posting where Job_Opening_Id=Job_Opening_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Agent`( )
Begin 
 SELECT Agent_Id,
Agent_Name,
User_Id From Agent where  DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_BatchPage_Dropdowns`()
BEGIN
select Course_Id,Course_Name from course where DeleteStatus=false;
select Agent_Id,Agent_Name from agent where DeleteStatus=false;
select Users_Id,Users_Name from users where DeleteStatus=false and Working_Status=1 and Role_Id=5;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Candidate_Dropdowns`()
BEGIN

select Functionl_Area_Id,Functionl_Area_Name from Functionl_Area where DeleteStatus=false;

select Specialization_Id,Specialization_Name from Specialization where DeleteStatus=false;

select Experience_Id,Experience_Name from Experience where DeleteStatus=false;

select Qualification_Id,Qualification_Name from Qualification where DeleteStatus=false;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Category_Commission`( In Category_Id_ varchar(100))
Begin 
 
 SELECT Commision_Percentage From Category where  Category_Id= Category_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Course`()
BEGIN
select Course_Id,Course_Name from course where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Course_DropDowns`()
BEGIN

select Course_Type_Id,Course_Type_Name from Course_Type where DeleteStatus=false;

select Fees_Type_Id,Fees_Type_Name from Fees_Type where DeleteStatus=false;

select Part_Id,Part_Name from Part where DeleteStatus=false;

select Online_Exam_Status_Id,Online_Exam_Status_Name from Online_Exam_Status where DeleteStatus=false;

select Period_Id,Period_Name,Period_From,Period_To from period where DeleteStatus=false;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Employer_Details`()
BEGIN
select Employer_Details_Id,Company_Name
from Employer_Details
where Delete_Status=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Enquiry_Source`()
BEGIN
select Enquiry_Source_Id,Enquiry_Source_Name from Enquiry_Source where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Exam_Status`()
BEGIN
select Exam_Status_Id,Exam_Status_Name from Exam_Status where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Fees_Type`()
BEGIN
select *
from fees_type
where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Gender`()
BEGIN
select Gender_Id,Gender_Name from Gender where DeleteStatus=0;
select Vacancy_Source_Id,Vacancy_Source_Name from vacancy_source  where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Id_Proof`()
BEGIN
select Id_Proof_Id,Id_Proof_Name from id_proof
where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Installment_Type`()
BEGIN
select Installment_Type_Id,Installment_Type_Name,No_Of_Installment,Duration from installment_type where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Interview_Student`(In Transaction_Master_Id_ int)
BEGIN
select transaction_master.Transaction_Master_Id,employer_details.Employer_Details_Id,(Date_Format(transaction_master.Date,'%Y-%m-%d')) as Date ,transaction_master.User_Id,transaction_master.Batch_Id,
users.Users_Name Faculty_Name,transaction_master.Course_Id,Course_Name,transaction_master.Description,Company_Name
from transaction_master
inner join course on course.Course_Id = transaction_master.Course_Id
inner join users on users.Users_Id = transaction_master.User_Id
inner join employer_details on employer_details.Employer_Details_Id = transaction_master.Employer_Details_Id
where transaction_master.DeleteStatus = false
and  transaction_master.Transaction_Master_Id = Transaction_Master_Id_;

select Student_Name,transaction_student.Transaction_Master_Id,transaction_student.Student_Id,Transaction_Type,Course_Name
from transaction_student
 inner join student on student.Student_Id = transaction_student.Student_Id
 inner join student_course on student_course.Student_Id = student.Student_Id
 inner join transaction_master on transaction_master.Transaction_Master_Id = transaction_student.Transaction_Master_Id 
 and student_course.Course_Id = transaction_master.Course_Id
 where transaction_student.DeleteStatus = false  and
 transaction_student.Transaction_Master_Id = Transaction_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Laptopdetails`()
BEGIN
select Laptop_details_Id,Laptop_details_Name from laptop_details where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Mode`()
BEGIN
select Mode_Id,Mode_Name from Mode where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Placement_Student`(In Interview_Master_Id_ int)
BEGIN
SELECT interview_master.Interview_Master_Id,Employer_Details.Employer_Details_Id,
(Date_Format(interview_master.Date,'%Y-%m-%d')) As Date,
(Date_Format(interview_master.Interview_Date,'%Y-%m-%d')) As Interview_Date,interview_master.User_Id,interview_master.Batch_Id,
users.Users_Name Faculty_Name,interview_master.Course_Id,Course_Name,interview_master.Description,
Company_Name
From interview_master 
inner join Course on Course.Course_Id=interview_master.Course_Id
inner join users on users.Users_Id=interview_master.User_Id
inner join Employer_Details on Employer_Details.Employer_Details_Id=interview_master.Employer_Details_Id
where  interview_master.DeleteStatus=false  
and interview_master.Interview_Master_Id =Interview_Master_Id_;

SELECT Student_Name,Interview_Master_Id,interview_student.Student_Id,Course_Name
From interview_student 
inner join student on student.Student_Id = interview_student.Student_Id
inner join student_course on student_course.Student_Id=Student.Student_Id
where  interview_student.DeleteStatus=false   and interview_student.Interview_Master_Id = Interview_Master_Id_; 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Qualification`()
BEGIN
select Qualification_Id,Qualification_Name from Qualification where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Resume_Status`()
BEGIN
select Resume_Status_Id,Resume_Status_Name from resume_status where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Student_Search_Dropdowns`(in Group_Id_ int)
BEGIN
select Status_Id,Status_Name from Status where Group_Id=Group_Id_ and DeleteStatus=0;

select Users_Id,Users_Name from Users where  DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Users`()
BEGIN
 SELECT users.Users_Id User_Selection_Id,Users_Name from Users where DeleteStatus=0;
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
CREATE DEFINER=`root`@`%` PROCEDURE `Load_Year_of_Pass`()
BEGIN
select Year_Of_Pass_Id,Year_Of_Pass_Name from year_of_pass
where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Login_Check`( In Users_Name_ VARCHAR(50),
in Password_ VARCHAR(50))
BEGIN
SELECT 
Users_Id,Users_Name,User_Type,Role_Id,Agent_Id,Mobile
From Users 
 where 
 Users_Name =Users_Name_ and Password=Password_ and users.DeleteStatus =false and Working_Status=1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Mark_As_Complete`( In Login_User_ Int,Batch_Id_ int,Status_ int)
Begin 
declare Current_Batch_Complete_Status_ int;declare Update_Batch_Complete_Status_ int;declare Batch_Complete_Status_ int;declare User_role_ int;
 set Current_Batch_Complete_Status_ =(select Batch_Complete_Status from batch where Batch_Id=Batch_Id_);
 
 set User_role_ =(select User_Type from users where Users_Id= Login_User_);
 
if(User_role_=2) then
	if(Status_ = 1) then
	 update batch set Batch_Complete_Status=1 , Batch_Complete_Date=now() where Batch_Id=Batch_Id_ and Trainer_Id=Login_User_;
	end if;
	if(Status_ = 0) then
	 update batch set Batch_Complete_Status=0 , Batch_Complete_Date=null where Batch_Id=Batch_Id_ and Trainer_Id=Login_User_;
	end if;
	 set Update_Batch_Complete_Status_ =(select Batch_Complete_Status from batch where Batch_Id=Batch_Id_);
	 if (Current_Batch_Complete_Status_=Update_Batch_Complete_Status_) then
	 set Batch_Complete_Status_=-1 ;
	 else set Batch_Complete_Status_ =(select Batch_Complete_Status from batch where Batch_Id=Batch_Id_);
	 end if;
	 select Batch_Id_,Batch_Complete_Status_;
end if; 

if(User_role_=1) then
	if(Status_ = 1) then
	 update batch set Batch_Complete_Status=1 , Batch_Complete_Date=now() where Batch_Id=Batch_Id_ ;
	end if;
	if(Status_ = 0) then
	 update batch set Batch_Complete_Status=0 , Batch_Complete_Date=null where Batch_Id=Batch_Id_ ;
	end if;
	 set Update_Batch_Complete_Status_ =(select Batch_Complete_Status from batch where Batch_Id=Batch_Id_);
	 if (Current_Batch_Complete_Status_=Update_Batch_Complete_Status_) then
	 set Batch_Complete_Status_=-1 ;
	 else set Batch_Complete_Status_ =(select Batch_Complete_Status from batch where Batch_Id=Batch_Id_);
	 end if;
	 select Batch_Id_,Batch_Complete_Status_;
end if; 

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Moveto_Blacklist_Status`(In Student_Id_ int )
BEGIN
Update student set Blacklist_Status = true
where Student_Id = Student_Id_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Notification_Read_Status`( In Notification_Count_ Int,User_Id_ int)
Begin 
#insert into data_log_ values(0,Notification_Count_,User_Id_);
update users set Notification_Count = Notification_Count - Notification_Count_ where Users_Id = User_Id_ and DeleteStatus=0;
update notification set Read_Status = true where To_User = User_Id_ and DeleteStatus = 0;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Pending_FollowUp`(In  By_User_ int,Login_User_ int)
BEGIN
declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_);
 #if User_Type_=2 then
 	#SET Department_String =concat(Department_String," and student.To_User_Id =",Login_User_);
#else
	SET Department_String =concat(Department_String," and (student.To_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_, " ) or student.To_User_Id =" , Login_User_, ")");
#end if; 
 
 #if Is_Date_>0 then 
	#	set Search_Date_=concat( " and student.Next_FollowUp_Date >= '", From_Date_ ,"' and student.Next_FollowUp_Date < '", To_Date_,"'");
	set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
 #ELSE
#	set Search_Date_= "and 1 =1 ";
   
#	# set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
#set Search_Date_=concat( " and date(student.Next_FollowUp_Date) < '", Date_Format( Now(),'%Y-%m-%d'),"'" );
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;

SET @query = Concat( "select T.Users_Name To_Staff,Agent_Name as Branch,Student_Name Student,student.Student_Id,student.Phone Mobile, (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Followup_On,
B.Users_Name as Registered_By,T.Users_Id ,student.District_Id ,state_district.District_Name,Year_Of_Passing
from student
inner join users as T on T.Users_Id=student.To_User_Id
left join users as B on B.Users_Id=student.Registered_By
inner join agent on agent.Agent_Id = T.Agent_Id
inner join status on status.Status_Id = student.Status
inner join state_district on state_district.State_District_Id=student.District_Id
where student.DeleteStatus=0 and student.Registered=0 and status.FollowUp=1 and student.Status not in(18,19)" ,SearchbyName_Value," ",Department_String," ",Search_Date_,"
order by Next_FollowUp_Date asc ");
PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Public_Save_Candidate_Front`(In Candidate_ Json,Candidate_Value_ int)
BEGIN
Declare Candidate_Id_ int;Declare Candidate_Name_ varchar(100); Declare Address1_ varchar(100); 
Declare Address2_ varchar(100); Declare Address3_ varchar(100); Declare Address4_ varchar(100);
Declare Pincode_ varchar(100);Declare Phone_ varchar(100); Declare Mobile_ varchar(100); 
Declare Whatsapp_ varchar(100); Declare DOB_ date;Declare Gender_ int;declare Email_ varchar(100); 
Declare Alternative_Email_ varchar(100);Declare Passport_No_ varchar(100); 
Declare Passport_Expiry_ varchar(100); Declare User_Name_ varchar(100); 
Declare Password_ varchar(100); Declare Photo_ varchar(100); Declare User_Id_ int;
Declare Functional_Area_Id_ int; Declare Functional_Area_Name_ varchar(100);
Declare Specialization_Id_ int; Declare Specialization_Name_ varchar(100);
Declare Experience_Id_ int; Declare Experience_Name_ varchar(100);
Declare Qualification_Id_ int; Declare Qualification_Name_ varchar(100);
Declare Resume_ varchar(4000); Declare Postlookingfor_ varchar(100);


 Declare i int default 0;

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
if(Candidate_Value_>0) then
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Candidate_Id')) INTO Candidate_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Candidate_Name')) INTO Candidate_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address1')) INTO Address1_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address2')) INTO Address2_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address3')) INTO Address3_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address4')) INTO Address4_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Pincode')) INTO Pincode_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Phone')) INTO Phone_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Mobile')) INTO Mobile_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Whatsapp')) INTO Whatsapp_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.DOB')) INTO DOB_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Gender')) INTO Gender_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Email')) INTO Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Alternative_Email')) INTO Alternative_Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Passport_No')) INTO Passport_No_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Passport_Expiry')) INTO Passport_Expiry_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.User_Name')) INTO User_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Password')) INTO Password_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Photo')) INTO Photo_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.User_Id')) INTO User_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Functional_Area_Id')) INTO Functional_Area_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Functional_Area_Name')) INTO Functional_Area_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Specialization_Id')) INTO Specialization_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Specialization_Name')) INTO Specialization_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Experience_Id')) INTO Experience_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Experience_Name')) INTO Experience_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Qualification_Id')) INTO Qualification_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Qualification_Name')) INTO Qualification_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Resume')) INTO Resume_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Postlookingfor')) INTO Postlookingfor_;
   
    
    
if Candidate_Id_>0 then
		 UPDATE Candidate set Candidate_Name = Candidate_Name_ ,Address1 = Address1_ ,Address2 = Address2_ ,
		Address3 = Address3_ ,Address4 = Address4_ ,Pincode = Pincode_  ,Phone = Phone_ ,Mobile = Mobile_ ,
		Whatsapp = Whatsapp_ ,DOB = DOB_ ,Gender = Gender_ ,Email = Email_ ,Alternative_Email = Alternative_Email_ ,
		Passport_No = Passport_No_ ,Passport_Expiry = Passport_Expiry_ ,User_Name = User_Name_ ,
		Password = Password_ ,User_Id = User_Id_ ,Functional_Area_Id=Functional_Area_Id_,Functional_Area_Name=Functional_Area_Name_,
        Specialization_Id=Specialization_Id_,Specialization_Name=Specialization_Name_,Experience_Id=Experience_Id_,Experience_Name=Experience_Name_,
        Qualification_Id=Qualification_Id_,Qualification_Name=Qualification_Name_,Postlookingfor=Postlookingfor_
        Where Candidate_Id=Candidate_Id_;        
		if Photo_!="" then
			UPDATE Candidate set Photo=Photo_ Where Candidate_Id=Candidate_Id_ ;
		end if;
		if Resume_!="" then
			UPDATE Candidate set Resume=Resume_ Where Candidate_Id=Candidate_Id_ ;
		end if;
	end if;
End if;

#commit;
 select Candidate_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Public_Search_Job`(In Job_Title_ varchar(100),
Qualification_ int,Experience_ int,Functional_Area_ int,Specialization_ int)
Begin 
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
if Job_Title_!='' then
SET SearchbyName_Value =Concat(SearchbyName_Value, " and job_posting.Job_Title like '%",Job_Title_ ,"%'") ;
end if;

if Qualification_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Qualification =",Qualification_);
end if;

if Experience_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Experience =",Experience_);
end if;

if Functional_Area_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Functional_Area =",Functional_Area_);
end if;

if Specialization_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Specialization =",Specialization_);
end if;

SET @query = Concat("select Job_Posting_Id,Job_Title,No_Of_Vaccancy,Qualification_Name,Experience,Job_Location,Salary,
Functional_Area_Name,Specialization_Name,Company_Name,Descritpion,Skills,Salary from  
job_posting 
where job_posting.DeleteStatus = 0 ",SearchbyName_Value);
PREPARE QUERY FROM @query;
EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Register_Candidate`(In Candidate_Id_ int , User_Id_ int )
BEGIN
declare Client_Accounts_Id_ int;declare Client_Accounts_Name_ varchar(100);declare Address1_ varchar(100);
declare Address2_ varchar(100);declare Address3_ varchar(100);declare Address4_ varchar(100);
declare Pincode_ varchar(100);declare Phone_ varchar(100);declare Mobile_ varchar(100);declare Email_ varchar(100);

select Candidate_Name,Address1,Address2,Address3,Address4,Pincode,Phone,Mobile,Email
INTO Client_Accounts_Name_,Address1_,Address2_,Address3_,Address4_,Pincode_,Phone_,Mobile_,Email_
from Candidate  where Candidate_Id=Candidate_Id_;
set Client_Accounts_Id_=(select COALESCE(Client_Accounts_Id,0) from  Candidate where Candidate_Id=Candidate_Id_ and DeleteStatus=false);
	if (Client_Accounts_Id_>0) then
		update Client_Accounts set Email=Email_,Client_Accounts_Name=Client_Accounts_Name_,Account_Group_Id=3,
        Address1=Address1_,Address2=Address2_,Address3=Address3_,Address4=Address4_,
		Pincode=Pincode_,Phone=Phone_,Mobile=Mobile_ where Client_Accounts_Id=Client_Accounts_Id_;
	else
		 INSERT INTO Client_Accounts(Client_Accounts_Id ,Account_Group_Id ,Client_Accounts_Code ,
		Client_Accounts_Name ,Client_Accounts_No ,Address1 ,Address2 ,Address3 ,Address4 ,PinCode ,
		StateCode,GSTNo,PanNo, State ,Country ,Phone ,Mobile ,Email ,Opening_Balance ,Description1 ,
		Entry_Date ,UserId ,LedgerInclude ,CanDelete ,Commision ,Opening_Type,Employee_Id,DeleteStatus ) 
		values (Client_Accounts_Id_ ,3 ,'' ,Client_Accounts_Name_ ,
		'' ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,PinCode_ ,
		'','','', '' ,'' ,Phone_ ,Mobile_ ,Email_ ,0 ,'' ,
		curdate() ,User_Id_ ,'Y' ,'Y' ,0 ,0,0,false);
        set Client_Accounts_Id_ =(SELECT LAST_INSERT_ID());
        end if;

Update Candidate set Registered = true , Registered_By = User_Id_ ,
 Registered_On = now(),Client_Accounts_Id=Client_Accounts_Id_
where Candidate_Id = Candidate_Id_;
select Candidate_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Register_Student`(In Student_Id_ int , User_Id_ int )
BEGIN
declare Client_Accounts_Id_ int;declare Client_Accounts_Name_ varchar(100);declare Address1_ varchar(100);
declare Address2_ varchar(100);declare Address3_ varchar(100);declare Address4_ varchar(100);
declare Pincode_ varchar(100);declare Phone_ varchar(100);declare Mobile_ varchar(100);declare Email_ varchar(100);
declare Is_registered_ tinyint;declare Is_Mail_Status_ tinyint;declare Is_Status_ tinyint;
select Student_Name,Address1,Address2,Address3,Address4,Pincode,Phone,Mobile,Email
INTO Client_Accounts_Name_,Address1_,Address2_,Address3_,Address4_,Pincode_,Phone_,Mobile_,Email_
from Student  where Student_Id=Student_Id_;
set Client_Accounts_Id_=(select COALESCE(Client_Accounts_Id,0) from  Student where Student_Id=Student_Id_ and DeleteStatus=false);
	if (Client_Accounts_Id_>0) then
		update Client_Accounts set Email=Email_,Client_Accounts_Name=Client_Accounts_Name_,Account_Group_Id=3,
        Address1=Address1_,Address2=Address2_,Address3=Address3_,Address4=Address4_,
		Pincode=Pincode_,Phone=Phone_,Mobile=Mobile_ where Client_Accounts_Id=Client_Accounts_Id_;
	else
		 INSERT INTO Client_Accounts(Client_Accounts_Id ,Account_Group_Id ,Client_Accounts_Code ,
		Client_Accounts_Name ,Client_Accounts_No ,Address1 ,Address2 ,Address3 ,Address4 ,PinCode ,
		StateCode,GSTNo,PanNo, State ,Country ,Phone ,Mobile ,Email ,Opening_Balance ,Description1 ,
		Entry_Date ,UserId ,LedgerInclude ,CanDelete ,Commision ,Opening_Type,Employee_Id,DeleteStatus ) 
		values (Client_Accounts_Id_ ,3 ,'' ,Client_Accounts_Name_ ,
		'' ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,PinCode_ ,
		'','','', '' ,'' ,Phone_ ,Mobile_ ,Email_ ,0 ,'' ,
		curdate() ,User_Id_ ,'Y' ,'Y' ,0 ,0,0,false);
        set Client_Accounts_Id_ =(SELECT LAST_INSERT_ID());
        end if;

Update Student set Registered = true , Registered_By = User_Id_ ,
 Registered_On = now(),Client_Accounts_Id=Client_Accounts_Id_,Student_Owner_Id=User_Id_
where Student_Id = Student_Id_;
#set Is_registered_ = (select Registered from student where Student_Id = Student_Id_);
#set Is_Mail_Status_ = (select Mail_Status from student where Student_Id = Student_Id_);
#set Is_Status_ = (select Status_FollowUp from student where Student_Id = Student_Id_);
#select Student_Id_,Is_registered_,Is_Mail_Status_,Is_Status_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Reminder_Notification`()
BEGIN
select Student_Name, count(Job_Id) as Job_Count,Job_Id,Candidate_Id,Last_Date,Apply_Status,Device_Id from job_candidate
inner join student on student.Student_Id = job_candidate.Candidate_Id
where  Last_Date >= curdate() and student.DeleteStatus=false and Apply_Status=0  group by Candidate_Id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Blacklist_Status`(In Student_Id_ int )
BEGIN
Update student set Blacklist_Status = false
where Student_Id = Student_Id_;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Registration`(In Student_Id_ int )
BEGIN
declare Is_registered_ tinyint;declare Is_Mail_Status_ tinyint;declare Is_Status_ tinyint;

Update Student set Registered = false
where Student_Id = Student_Id_;

/*set Is_registered_ = (select Registered from student where Student_Id = Student_Id_);
set Is_Mail_Status_ = (select Mail_Status from student where Student_Id = Student_Id_);
set Is_Status_ = (select Status_FollowUp from student where Student_Id = Student_Id_);
select Student_Id_,Is_registered_,Is_Mail_Status_,Is_Status_;*/
select Student_Id_;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Registration_Agent`(In Agent_Id_ int )
BEGIN
Update Agent set Is_Registered = false
where Agent_Id = Agent_Id_;
select Agent_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Remove_Registration_Candidate`(In Student_Id_ int )
BEGIN
Update Candidate set Registered = false
where Candidate_Id = Candidate_Id_;
select Candidate_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Reset_Notification_Count`(In User_Id_ int)
BEGIN
declare Notification_Count_ int;
update users set Notification_Count = 0 where Users_Id = User_Id_;
update notification set Read_Status = 1 where To_User = User_Id_;
set  Notification_Count_ = (select Notification_Count from users where Users_Id = User_Id_) ;
select Notification_Count_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Resume_Upload_Notification_Mail`()
BEGIN
select Company_Name,Email from company where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Accounts`( In Accounts_Id_ int,
Date_ datetime,
Client_Id_ int,
DR_ decimal,
CR_ decimal,
X_Client_Id_ int,
Voucher_No_ varchar(100),
Voucher_Type_ varchar(100),
Description_ varchar(4000),
Status_ int,
Daybbok_ varchar(5))
Begin 
 if  Accounts_Id_>0
 THEN 
 UPDATE Accounts set Accounts_Id = Accounts_Id_ ,
Date = Date_ ,
Client_Id = Client_Id_ ,
DR = DR_ ,
CR = CR_ ,
X_Client_Id = X_Client_Id_ ,
Voucher_No = Voucher_No_ ,
Voucher_Type = Voucher_Type_ ,
Description = Description_ ,
Status = Status_ ,
Daybbok = Daybbok_  Where Accounts_Id=Accounts_Id_ ;
 ELSE 
 SET Accounts_Id_ = (SELECT  COALESCE( MAX(Accounts_Id ),0)+1 FROM Accounts); 
 INSERT INTO Accounts(Accounts_Id ,
Date ,
Client_Id ,
DR ,
CR ,
X_Client_Id ,
Voucher_No ,
Voucher_Type ,
Description ,
Status ,
Daybbok ) values (Accounts_Id_ ,
Date_ ,
Client_Id_ ,
DR_ ,
CR_ ,
X_Client_Id_ ,
Voucher_No_ ,
Voucher_Type_ ,
Description_ ,
Status_ ,
Daybbok_ );
 End If ;
 select Accounts_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Agent`( In Agent_Id_ int,Agent_Name_ varchar(100),Address1_ varchar(100),Address2_ varchar(100),Address3_ varchar(100),
Address4_ varchar(100),Pincode_ varchar(100),Phone_ varchar(100),Mobile_ varchar(100),Whatsapp_ varchar(100),DOB_ datetime,Gender_ int,Email_ varchar(100),
Alternative_Email_ varchar(100),User_Name_ varchar(100),Password_ varchar(100),Photo_ varchar(100),GSTIN_ varchar(100),Category_Id_ int,Commission_ decimal(18,2),User_Id_ int,
Comm_Address1_ varchar(100),Comm_Address2_ varchar(100),Comm_Address3_ varchar(100),Comm_Address4_ varchar(100),Comm_Pincode_ varchar(100),Comm_Mobile_ varchar(100),
Center_Name_ varchar(100),Center_Code_ varchar(100),Agent_Fees_ decimal(18,2))
Begin 
declare Client_Accounts_Id_ int default 0;
 if  Agent_Id_>0 THEN 
			UPDATE Agent set Agent_Name = Agent_Name_,Address1 = Address1_,Address2 = Address2_,Address3 = Address3_,Address4 = Address4_,Pincode = Pincode_,Phone = Phone_,
            Mobile = Mobile_,Whatsapp = Whatsapp_,DOB = DOB_,Gender = Gender_,Email = Email_,Alternative_Email = Alternative_Email_,User_Name = User_Name_,Password = Password_,
            Photo = Photo_,GSTIN = GSTIN_,Category_Id = Category_Id_,Commission = Commission_,User_Id = User_Id_,Comm_Address1=Comm_Address1_,Comm_Address2=Comm_Address2_,
            Comm_Address3=Comm_Address3_,Comm_Address4=Comm_Address4_,Comm_Pincode=Comm_Pincode_,Comm_Mobile=Comm_Mobile_,Center_Name=Center_Name_,Center_Code = Center_Code_,
            Agent_Fees = Agent_Fees_ Where Agent_Id=Agent_Id_ ;
        ELSE 
			SET Agent_Id_ = (SELECT  COALESCE( MAX(Agent_Id ),0)+1 FROM Agent); 
			INSERT INTO Agent(Agent_Id ,Agent_Name ,Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,Phone ,Mobile ,Whatsapp ,DOB ,Gender ,Email ,Alternative_Email ,
			 User_Name ,Password ,Photo ,GSTIN ,Category_Id ,Commission ,User_Id ,Expiry_Status,Payemt_Status,Comm_Address1,Comm_Address2,Comm_Address3,Comm_Address4,Comm_Pincode,
             Comm_Mobile,Center_Name,Center_Code,Agent_Fees,DeleteStatus) 
			values (Agent_Id_ ,Agent_Name_ ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,Phone_ ,Mobile_ ,Whatsapp_ ,DOB_ ,Gender_ ,Email_ ,Alternative_Email_ ,
			User_Name_ ,Password_ ,Photo_ ,GSTIN_ ,Category_Id_ ,Commission_ ,User_Id_ ,'10','8',Comm_Address1_,Comm_Address2_,Comm_Address3_,Comm_Address4_,Comm_Pincode_,
             Comm_Mobile_,Center_Name_,Center_Code_ ,Agent_Fees_ ,false);
 End If ;
 select Agent_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Agent_Commision`( In Agent_Commision_Id_ int,
Agent_Id_ int,
Category_Id_ int,
Category_Name_ varchar(100),
Commision_Per_ varchar(100),
Commision_Amount_ decimal)
Begin 
 if  Agent_Commision_Id_>0
 THEN 
 UPDATE Agent_Commision set Agent_Commision_Id = Agent_Commision_Id_ ,
Agent_Id = Agent_Id_ ,
Category_Id = Category_Id_ ,
Category_Name = Category_Name_ ,
Commision_Per = Commision_Per_ ,
Commision_Amount = Commision_Amount_  Where Agent_Commision_Id=Agent_Commision_Id_ ;
 ELSE 
 SET Agent_Commision_Id_ = (SELECT  COALESCE( MAX(Agent_Commision_Id ),0)+1 FROM Agent_Commision); 
 INSERT INTO Agent_Commision(Agent_Commision_Id ,
Agent_Id ,
Category_Id ,
Category_Name ,
Commision_Per ,
Commision_Amount ,
DeleteStatus ) values (Agent_Commision_Id_ ,
Agent_Id_ ,
Category_Id_ ,
Category_Name_ ,
Commision_Per_ ,
Commision_Amount_ ,
false);
 End If ;
 select Agent_Commision_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Agent_Course_Type`( In Agent_Course_Type_Id_ int,
Agent_Id_ int,
Course_Type_Id_ int,
Cousrse_Type_Name_ varchar(100))
Begin 
 if  Agent_Course_Type_Id_>0
 THEN 
 UPDATE Agent_Course_Type set Agent_Course_Type_Id = Agent_Course_Type_Id_ ,
Agent_Id = Agent_Id_ ,
Course_Type_Id = Course_Type_Id_ ,
Cousrse_Type_Name = Cousrse_Type_Name_  Where Agent_Course_Type_Id=Agent_Course_Type_Id_ ;
 ELSE 
 SET Agent_Course_Type_Id_ = (SELECT  COALESCE( MAX(Agent_Course_Type_Id ),0)+1 FROM Agent_Course_Type); 
 INSERT INTO Agent_Course_Type(Agent_Course_Type_Id ,
Agent_Id ,
Course_Type_Id ,
Cousrse_Type_Name ,
DeleteStatus ) values (Agent_Course_Type_Id_ ,
Agent_Id_ ,
Course_Type_Id_ ,
Cousrse_Type_Name_ ,
false);
 End If ;
 select Agent_Course_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Agent_Registration`( In Agent_Id_ int)
Begin 
declare cur_date_ datetime; declare Expirty_Date_ datetime;
declare Client_Accounts_Id_ int;declare Client_Accounts_Name_ varchar(100);declare Address1_ varchar(100);
declare Address2_ varchar(100);declare Address3_ varchar(100);declare Address4_ varchar(100);
declare Pincode_ varchar(100);declare Phone_ varchar(100);declare Mobile_ varchar(100);declare Email_ varchar(100);

set cur_date_=now();
 set Expirty_Date_=DATE_ADD(cur_date_, INTERVAL 1 YEAR) ;
 
select Agent_Name,Address1,Address2,Address3,Address4,Pincode,Phone,Mobile,Email
INTO Client_Accounts_Name_,Address1_,Address2_,Address3_,Address4_,Pincode_,Phone_,Mobile_,Email_
from Agent  where Agent_Id=Agent_Id_;

set Client_Accounts_Id_=(select COALESCE(Client_Accounts_Id,0) from  Agent where Agent_Id=Agent_Id_ and DeleteStatus=false);
	if (Client_Accounts_Id_>0) then
		update Client_Accounts set Email=Email_,Client_Accounts_Name=Client_Accounts_Name_,Account_Group_Id=3,
        Address1=Address1_,Address2=Address2_,Address3=Address3_,Address4=Address4_,
		Pincode=Pincode_,Phone=Phone_,Mobile=Mobile_ where Client_Accounts_Id=Client_Accounts_Id_;
	else
		 INSERT INTO Client_Accounts(Client_Accounts_Id ,Account_Group_Id ,Client_Accounts_Code ,
		Client_Accounts_Name ,Client_Accounts_No ,Address1 ,Address2 ,Address3 ,Address4 ,PinCode ,
		StateCode,GSTNo,PanNo, State ,Country ,Phone ,Mobile ,Email ,Opening_Balance ,Description1 ,
		Entry_Date ,UserId ,LedgerInclude ,CanDelete ,Commision ,Opening_Type,Employee_Id,DeleteStatus ) 
		values (Client_Accounts_Id_ ,1 ,'' ,Client_Accounts_Name_ ,'' ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,
        PinCode_ ,		'','','', '' ,'' ,Phone_ ,Mobile_ ,Email_ ,0 ,'' ,
		curdate() ,0 ,'Y' ,'Y' ,0 ,0,0,false);
        set Client_Accounts_Id_ =(SELECT LAST_INSERT_ID());
        end if;
 
if Client_Accounts_Id_=0 then
	set Client_Accounts_Id_ =(SELECT LAST_INSERT_ID());
end if;
UPDATE Agent set Is_Registered= true, Client_Accounts_Id=Client_Accounts_Id_,Expiry_Status=1,
Expirty_Date=Expirty_Date_
 Where Agent_Id=Agent_Id_ ;    
 select Agent_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Application_Settings`( In Application_Settings_Id_ int,Users_Id_ int,Users_Name_ varchar(100),
Complaint_Users_Id_ int,Complaint_Users_Name_ varchar(100))
Begin

if  Application_Settings_Id_>0
THEN
UPDATE application_settings set Application_Settings_Id=Application_Settings_Id_, Users_Id=Users_Id_,Users_Name=Users_Name_,DeleteStatus=0 ,
Complaint_Users_Name=Complaint_Users_Name_,Complaint_Users_Id=Complaint_Users_Id_
Where Application_Settings_Id = Application_Settings_Id_ ;  
End If ;
select Application_Settings_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Applied_Candidate`(in Candidate_Job_Apply_Id_ int,Status_Id_ int,Status_Name_ varchar(100))
BEGIN
update candidate_job_apply set Status_Id=Status_Id_,Status_Name=Status_Name_ 
where Candidate_Job_Apply_Id=Candidate_Job_Apply_Id_ and DeleteStatus=0;
select Candidate_Job_Apply_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Attendance`( In Attendance_Master_Id_ int,
Course_Id_ int,Batch_Id_ int,Faculty_Id_ int,Duration_ decimal(18,2),Percentage_ int,
Attendance_Student JSON,Attendance_Subject JSON,
Attendance_Student_Value_ int,Attendance_Subject_Value_ int )
BEGIN
DECLARE Student_Id_ int;DECLARE Subject_Id_ int;DECLARE Attendance_Status_ int;DECLARE Student_Id_1 int;
DECLARE Attendance_Status_1 varchar(10);DECLARE length int;
declare attendance_master_exist_id_ int;
DECLARE i int  DEFAULT 0;DECLARE j int  DEFAULT 0;DECLARE k int  DEFAULT 0;
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
#insert into data_log_ values (0,Attendance_Student,Attendance_Subject);
set attendance_master_exist_id_ = (select  COALESCE( MAX(Attendance_Master_Id ),0) from attendance_master where Course_Id=Course_Id_ and Batch_Id=Batch_Id_ and Faculty_Id=Faculty_Id_ and Date=curdate()
and DeleteStatus=0);
#insert into data_log_ values(0,attendance_master_exist_id_,1);				
			if  Attendance_Master_Id_>0 THEN
            #delete from attendance_syllabus_master where Course_Id=Course_Id_ and Batch_Id=Batch_Id_;
				delete from attendance_student where Attendance_Master_Id=Attendance_Master_Id_;
				delete from attendance_subject where Attendance_Master_Id=Attendance_Master_Id_;
				UPDATE Attendance_Master set Course_Id = Course_Id_ ,Batch_Id = Batch_Id_ ,
				Faculty_Id = Faculty_Id_ ,Duration=Duration_
				Where Attendance_Master_Id=Attendance_Master_Id_ ;
			ELSE
		if (attendance_master_exist_id_=0) then
				SET Attendance_Master_Id_ = (SELECT  COALESCE( MAX(Attendance_Master_Id ),0)+1 FROM Attendance_Master);
				INSERT INTO Attendance_Master(Attendance_Master_Id ,Course_Id ,Batch_Id ,Faculty_Id,
				Duration,Date,DeleteStatus )
				values (Attendance_Master_Id_,Course_Id_ ,Batch_Id_ ,Faculty_Id_,
				Duration_,curdate(),false);
		else 
		set Attendance_Master_Id_ = -5;    
		end if;
			End If ;
			if  Attendance_Master_Id_>0 then
			  if( Attendance_Student_Value_>0) then
				WHILE i < JSON_LENGTH(Attendance_Student) DO
					SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Student,CONCAT('$[',i,'].Student_Id'))) INTO Student_Id_;
					SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Student,CONCAT('$[',i,'].Check_Box'))) INTO Attendance_Status_1;
					if Attendance_Status_1 = 'false' then
						set Attendance_Status_ =0;
					else
						set Attendance_Status_ =1;
					end if;
					INSERT INTO Attendance_Student(Attendance_Master_Id,Student_Id,Attendance_Status,DeleteStatus )
					values (Attendance_Master_Id_ ,Student_Id_ ,Attendance_Status_,false);
					Update Student set Portion_Covered=Percentage_,Portion_Covered_Date=curdate() where Student_Id=Student_Id_ and DeleteStatus=0;
					SELECT i + 1 INTO i;
				END WHILE;
			end if;			
		  if( Attendance_Subject_Value_>0) then
				WHILE j < JSON_LENGTH(Attendance_Subject) DO
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Subject,CONCAT('$[',j,'].Subject_Id'))) INTO Subject_Id_;
					INSERT INTO attendance_syllabus_master(Attendance_Syllabus_Master_Id,Course_Id,Batch_Id,Syllabus_Id,DeleteStatus )
					values (0 ,Course_Id_,Batch_Id_,Subject_Id_,false);
				INSERT INTO Attendance_Subject(Attendance_Master_Id,Subject_Id,DeleteStatus )
				values (Attendance_Master_Id_ ,Subject_Id_ ,false);
				SELECT j + 1 INTO j;
				END WHILE;  
			 end if;
			   /* if( Absent_Value_>0) then
				WHILE k < JSON_LENGTH(Absent_Student) DO
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Absent_Student,CONCAT('$[',k,'].Student_Id'))) INTO Student_Id_1;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Absent_Student,CONCAT('$[',k,'].Check_Box'))) INTO Attendance_Status_1;       
				if Attendance_Status_1 = 'false' then
					set Attendance_Status_ =0;
				end if;
				INSERT INTO Attendance_Student(Attendance_Master_Id,Student_Id,Attendance_Status,DeleteStatus )
				values (Attendance_Master_Id_ ,Student_Id_1 ,Attendance_Status_,false);
				SELECT k + 1 INTO k;
				END WHILE; 
				end if*/				
			end if;
#COMMIT;
select Attendance_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Batch`( In Batch_Id_ int,Batch_Name_ varchar(100),User_Id_ int,Start_Date_ datetime,End_Date_ datetime,
Course_Id_ int ,Course_Name_ varchar(200) ,Trainer_Id_ int,Trainer_Name_ varchar(100) ,Branch_Id_ int ,Branch_Name_ varchar(100) ,Batch_Start_Time_ time ,Batch_End_Time_ time)
Begin 
 if  Batch_Id_>0
 THEN 
	UPDATE Batch set Batch_Id = Batch_Id_ ,Batch_Name = Batch_Name_ ,User_Id = User_Id_,Start_Date = Start_Date_ ,End_Date = End_Date_ ,
    Course_Id = Course_Id_, Course_Name =Course_Name_, Trainer_Id =Trainer_Id_, Trainer_Name =Trainer_Name_,Branch_Id =Branch_Id_, Branch_Name =Branch_Name_,
    Batch_Start_Time =Batch_Start_Time_, Batch_End_Time =Batch_End_Time_

    Where Batch_Id=Batch_Id_ ;
	UPDATE Student_Course set Start_Date = Start_Date_ ,End_Date = End_Date_ ,Batch_Start_Date=Start_Date_,Batch_End_Date=End_Date_,
	Batch_Start_Time=Batch_Start_Time_ ,Batch_End_Time=Batch_End_Time_ ,Batch_Branch_Id = Branch_Id_ Where Batch_Id=Batch_Id_ ;
 ELSE 
	SET Batch_Id_ = (SELECT  COALESCE( MAX(Batch_Id ),0)+1 FROM Batch); 
	INSERT INTO Batch(Batch_Id ,Batch_Name ,User_Id ,Entry_Date,Start_Date,End_Date,DeleteStatus, Course_Id , Course_Name , Trainer_Id , Trainer_Name ,Branch_Id ,
    Branch_Name ,Batch_Start_Time , Batch_End_Time ,Batch_Complete_Status ) 
	values (Batch_Id_ ,Batch_Name_ ,User_Id_ ,curdate(), Start_Date_,End_Date_,false, Course_Id_ , Course_Name_ , Trainer_Id_, Trainer_Name_ ,Branch_Id_ ,
    Branch_Name_ ,Batch_Start_Time_ , Batch_End_Time_,0 );
 End If ;
 select Batch_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Candidate`(In Candidate_ Json,Followup_ Json,Candidate_Value_ int,FollowUp_Value_ int)
BEGIN
Declare Candidate_Id_ int;Declare Candidate_Name_ varchar(100); Declare Address1_ varchar(100); 
Declare Address2_ varchar(100); Declare Address3_ varchar(100); Declare Address4_ varchar(100);
Declare Pincode_ varchar(100);Declare Phone_ varchar(100); Declare Mobile_ varchar(100); 
Declare Whatsapp_ varchar(100); Declare DOB_ datetime;Declare Gender_ int;declare Email_ varchar(100); 
Declare Alternative_Email_ varchar(100);Declare Passport_No_ varchar(100); 
Declare Passport_Expiry_ varchar(100); Declare User_Name_ varchar(100); 
Declare Password_ varchar(100); Declare Photo_ varchar(100); Declare User_Id_ int;
Declare Functional_Area_Id_ int; Declare Functional_Area_Name_ varchar(100);
Declare Specialization_Id_ int; Declare Specialization_Name_ varchar(100);
Declare Experience_Id_ int; Declare Experience_Name_ varchar(100);
Declare Qualification_Id_ int; Declare Qualification_Name_ varchar(100);
Declare Resume_ varchar(4000); Declare Postlookingfor_ varchar(100);

declare Duplicate_Candidate_Id int;
declare Duplicate_Candidate_Name varchar(25); declare Duplicate_User_Name varchar(25); declare Duplicate_User_Id int;
declare Created_By_ int;declare Email_Candidate_Id int;declare Email_Alternate_Candidate_Id int;
declare Alternate_Candidate_Id int;declare Whatsap_Candidate_Id int;declare Duplicate_Email_Name varchar(50);
 Declare i int default 0;

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
if( Candidate_Value_>0) then
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Candidate_Id')) INTO Candidate_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Candidate_Name')) INTO Candidate_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address1')) INTO Address1_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address2')) INTO Address2_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address3')) INTO Address3_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Address4')) INTO Address4_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Pincode')) INTO Pincode_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Phone')) INTO Phone_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Mobile')) INTO Mobile_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Whatsapp')) INTO Whatsapp_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.DOB')) INTO DOB_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Gender')) INTO Gender_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Email')) INTO Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Alternative_Email')) INTO Alternative_Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Passport_No')) INTO Passport_No_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Passport_Expiry')) INTO Passport_Expiry_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.User_Name')) INTO User_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Password')) INTO Password_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Photo')) INTO Photo_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.User_Id')) INTO User_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Functional_Area_Id')) INTO Functional_Area_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Functional_Area_Name')) INTO Functional_Area_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Specialization_Id')) INTO Specialization_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Specialization_Name')) INTO Specialization_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Experience_Id')) INTO Experience_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Experience_Name')) INTO Experience_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Qualification_Id')) INTO Qualification_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Qualification_Name')) INTO Qualification_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Resume')) INTO Resume_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Candidate_,'$.Postlookingfor')) INTO Postlookingfor_;
if  Candidate_Id_>0 THEN
		Set Duplicate_Candidate_Id = (select Candidate_Id from Candidate where Candidate_Id != Candidate_Id_ and DeleteStatus=false and (Phone like concat('%',Phone_,'%')
		or Mobile like concat('%',Phone_,'%') or Whatsapp  like concat('%',Phone_,'%') )  limit 1);
		if Email_!="" then
			set Email_Candidate_Id= ( select Candidate_Id from Candidate where Candidate_Id != Candidate_Id_  and DeleteStatus=false  and   ( Email like concat('%',Email_,'%') or Alternative_Email  like concat('%',Email_,'%') ) limit 1);
		end if;
		if Alternative_Email_!="" then
			set Email_Alternate_Candidate_Id= (select Candidate_Id from Candidate where Candidate_Id != Candidate_Id_ and DeleteStatus=false  and   ( Alternative_Email like concat('%',Alternative_Email_,'%') or Email  like concat('%',Alternative_Email_,'%') ) limit 1);
		end if;
		if Mobile_!="" then
			Set Alternate_Candidate_Id = (select Candidate_Id from Candidate where  Candidate_Id != Candidate_Id_ and DeleteStatus=false  and  (Phone like concat('%',Mobile_,'%') or Mobile like concat('%',Mobile_,'%') or Whatsapp  like concat('%',Mobile_,'%')) limit 1);
		end if;
		if Whatsapp_!="" then
			Set Whatsap_Candidate_Id = (select Candidate_Id from Candidate where Candidate_Id != Candidate_Id_ and DeleteStatus=false  and   (Phone like concat('%',Whatsapp_,'%') or Mobile like concat('%',Whatsapp_,'%') or Whatsapp  like concat('%',Whatsapp_,'%')) limit 1);
		end if;
	if(Duplicate_Candidate_Id>0) then
		set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Duplicate_Candidate_Id and DeleteStatus=false);
		set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Duplicate_Candidate_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Candidate_Id_ = -1;  
	elseif(Alternate_Candidate_Id>0) then
		set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Alternate_Candidate_Id and DeleteStatus=false);
		set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Alternate_Candidate_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Candidate_Id_ = -1;  
	elseif(Whatsap_Candidate_Id>0) then
		set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Whatsap_Candidate_Id and DeleteStatus=false);
		set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Whatsap_Candidate_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Candidate_Id_ = -1;                
	elseif(Email_Candidate_Id>0) then
		set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Email_Candidate_Id and DeleteStatus=false);
		set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Email_Candidate_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Candidate_Id_ = -2;                
	elseif(Email_Alternate_Candidate_Id>0) then
		set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Email_Alternate_Candidate_Id and DeleteStatus=false);
		set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Email_Alternate_Candidate_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Candidate_Id_ = -2;
	Else
		 UPDATE Candidate set Candidate_Name = Candidate_Name_ ,Address1 = Address1_ ,Address2 = Address2_ ,
		Address3 = Address3_ ,Address4 = Address4_ ,Pincode = Pincode_ ,Phone = Phone_ ,Mobile = Mobile_ ,
		Whatsapp = Whatsapp_ ,DOB = DOB_ ,Gender = Gender_ ,Email = Email_ ,Alternative_Email = Alternative_Email_ ,
		Passport_No = Passport_No_ ,Passport_Expiry = Passport_Expiry_ ,User_Name = User_Name_ ,
		Password = Password_ ,User_Id = User_Id_ ,Functional_Area_Id=Functional_Area_Id_,Functional_Area_Name=Functional_Area_Name_,
        Specialization_Id=Specialization_Id_,Specialization_Name=Specialization_Name_,Experience_Id=Experience_Id_,Experience_Name=Experience_Name_,
        Qualification_Id=Qualification_Id_,Qualification_Name=Qualification_Name_,Postlookingfor=Postlookingfor_
        Where Candidate_Id=Candidate_Id_;        
		if Photo_!="" then
			UPDATE Candidate set Photo=Photo_ Where Candidate_Id=Candidate_Id_ ;
		end if;
		if Resume_!="" then
			UPDATE Candidate set Resume=Resume_ Where Candidate_Id=Candidate_Id_ ;
		end if;
	end if;
ELSE
		Set Duplicate_Candidate_Id = (select Candidate_Id from Candidate where  DeleteStatus=false and (Phone like concat('%',Phone_,'%')
		or Mobile like concat('%',Phone_,'%') or Whatsapp  like concat('%',Phone_,'%') )  limit 1);
		if Email_!="" then
			set Email_Candidate_Id= ( select Candidate_Id from Candidate where  DeleteStatus=false and ( Email like concat('%',Email_,'%') or Alternative_Email  like concat('%',Email_,'%') ) limit 1);
        end if;
        if Alternative_Email_!="" then
			set Email_Alternate_Candidate_Id= (select Candidate_Id from Candidate where  DeleteStatus=false and ( Alternative_Email like concat('%',Alternative_Email_,'%') or Email  like concat('%',Alternative_Email_,'%') ) limit 1);
        end if;
         if Mobile_!="" then
			Set Alternate_Candidate_Id = (select Candidate_Id from Candidate where  DeleteStatus=false and (Phone like concat('%',Mobile_,'%') or Mobile like concat('%',Mobile_,'%') or Whatsapp  like concat('%',Mobile_,'%')) limit 1);
		 end if;

       if Whatsapp_!="" then
			Set Whatsap_Candidate_Id = (select Candidate_Id from Candidate where  DeleteStatus=false and  (Phone like concat('%',Whatsapp_,'%') or Mobile like concat('%',Whatsapp_,'%') or Whatsapp  like concat('%',Whatsapp_,'%')) limit 1);
		end if;       
		if(Duplicate_Candidate_Id>0) then
			set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Duplicate_Candidate_Id and DeleteStatus=false );
			set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Duplicate_Candidate_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
		SET Candidate_Id_ = -1;  
		elseif(Alternate_Candidate_Id>0) then
			set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Alternate_Candidate_Id and DeleteStatus=false );
			set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Alternate_Candidate_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
		SET Candidate_Id_ = -1;  
		elseif(Whatsap_Candidate_Id>0) then
			set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Whatsap_Candidate_Id and DeleteStatus=false );
			set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Whatsap_Candidate_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
			SET Candidate_Id_ = -1;                
		elseif(Email_Candidate_Id>0) then
			set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Email_Candidate_Id and DeleteStatus=false );
			set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Email_Candidate_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
		SET Candidate_Id_ = -2;                
		elseif(Email_Alternate_Candidate_Id>0) then
			set Duplicate_User_Id = (select User_Id from Candidate where Candidate_Id = Email_Alternate_Candidate_Id and DeleteStatus=false );
			set Duplicate_Candidate_Name = (select Candidate_Name from Candidate where Candidate_Id = Email_Alternate_Candidate_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
			SET Candidate_Id_ = -2;
		else
		SET Candidate_Id_ = (SELECT  COALESCE( MAX(Candidate_Id ),0)+1 FROM Candidate);
		INSERT INTO Candidate(Candidate_Id ,Candidate_Name ,Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,
		Phone ,Mobile ,Whatsapp ,DOB ,Gender ,Email ,Alternative_Email ,Passport_No ,Passport_Expiry ,
		User_Name ,Password ,Photo ,Registered,Registered_By,Registered_On,User_Id ,
        Functional_Area_Id,Functional_Area_Name,Specialization_Id,Specialization_Name,
       Experience_Id,Experience_Name,Qualification_Id,Qualification_Name, Resume,Postlookingfor,DeleteStatus )
		values (Candidate_Id_ ,Candidate_Name_ ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,
		Phone_ ,Mobile_ ,Whatsapp_ ,DOB_ ,Gender_ ,Email_ ,Alternative_Email_ ,Passport_No_ ,
		Passport_Expiry_ ,User_Name_ ,Password_ ,Photo_ ,0,0,curdate(),User_Id_,
        Functional_Area_Id_,Functional_Area_Name_,Specialization_Id_,Specialization_Name_,
       Experience_Id_,Experience_Name_,Qualification_Id_,Qualification_Name_, Resume_,Postlookingfor_,false);
	end if;
End If ;
else
	set Candidate_Id_=2;
End If ;

 if( FollowUp_Value_>0  and  Candidate_Id_>0) then
        #set Duplicate_Candidate_Name= "";
        CALL Save_Candidate_Followup(FollowUp_,Candidate_Id_);
end if;
#commit;
 select Candidate_Id_,Duplicate_Candidate_Name,Duplicate_User_Name;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Candidate_Followup`(In FollowUp_ JSON,Candidate_Id_ int)
Begin 
Declare Candidate_Followup_Id_ int;Declare Entry_Date_ datetime;
Declare Next_FollowUp_Date_ datetime;declare FollowUp_Difference_ int;
Declare Status_ int;Declare By_User_Id_ int;Declare Remark_ varchar(4000);
Declare Remark_Id_ int;Declare FollowUp_Type_ int;Declare FollowUP_Time_ varchar(100);
Declare Actual_FollowUp_Date_ datetime;declare Candidate_Id_J int;declare To_User_Id_ int;

 declare Duplicate_Candidate_Name varchar(25); declare Duplicate_User_Name varchar(25);

SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Candidate_Id')) INTO Candidate_Id_J;   
	if( Candidate_Id_J>0 )
		then set Candidate_Id_=Candidate_Id_J;
	end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Next_FollowUp_Date')) INTO Next_FollowUp_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Status')) INTO Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.By_User_Id')) INTO By_User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.To_User_Id')) INTO To_User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Remark')) INTO Remark_;

 INSERT INTO Candidate_Followup(Candidate_Followup_Id ,Candidate_Id ,Entry_Date ,Next_FollowUp_Date ,
FollowUp_Difference ,Status ,By_User_Id ,Remark ,Remark_Id ,FollowUp_Type ,FollowUP_Time ,
Actual_FollowUp_Date,Entry_Type,To_User_Id,DeleteStatus ) 
values (Candidate_Followup_Id_ ,Candidate_Id_ ,curdate() ,Next_FollowUp_Date_ ,0 ,
Status_ ,By_User_Id_ ,Remark_ ,0 ,1 ,'' ,curdate() ,'',To_User_Id_,false);
set Candidate_Followup_Id_ =(SELECT LAST_INSERT_ID());

update Candidate set Candidate_Followup_Id=Candidate_Followup_Id_,Next_FollowUp_Date=Next_FollowUp_Date_,
FollowUp_Difference=0,Status=Status_,By_User_Id=By_User_Id_,To_User_Id=To_User_Id_,Remark=Remark_,Remark_Id=0,
FollowUp_Type=1,FollowUP_Time='',Actual_FollowUp_Date=now() ,Entry_Type='' where Candidate_Id=Candidate_Id_;

 select Candidate_Id_,Duplicate_Candidate_Name,Duplicate_User_Name;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Candidate_JobApply_Public`( In Candidate_Id_ Int,Job_Posting_Id_ int)
Begin
 INSERT INTO candidate_job_apply(Job_Posting_Id,Candidate_Id,Entry_Date,Status_Id,Status_Name,DeleteStatus)
  values (Job_Posting_Id_,Candidate_Id_,now(),7,'Apply',0); 
select Job_Posting_Id_;

End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Candidate_JobApply_Public_Check`( In Candidate_Id_ Int,Job_Posting_Id_ int)
Begin
select count(Candidate_Id)  from candidate_job_apply where Candidate_Id=Candidate_Id_ and Job_Posting_Id=Job_Posting_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Candidate_Job_Apply`( In Candidate_Job_Apply_Id_ int,
Candidate_Id_ int,
Entry_Date_ datetime,
Skills_ varchar(100),
Designation_ varchar(100),
Functional_Area_Id_ int,
Functional_Area_Name_ varchar(100),
Specialization_Id_ int,
Specialization_Name_ varchar(100),
Experience_Id_ int,
Experience_Name_ varchar(100),
Qualification_Id_ int,
Qualification_Name_ varchar(100),
Remark_ varchar(4000),
Resume_ varchar(100),
Experience_Certificate_ varchar(100),
Photo_ varchar(100),
Status_Id_ int,
Status_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Candidate_Job_Apply_Id_>0
 THEN 
 UPDATE Candidate_Job_Apply set Candidate_Job_Apply_Id = Candidate_Job_Apply_Id_ ,
Candidate_Id = Candidate_Id_ ,
Entry_Date = Entry_Date_ ,
Skills = Skills_ ,
Designation = Designation_ ,
Functional_Area_Id = Functional_Area_Id_ ,
Functional_Area_Name = Functional_Area_Name_ ,
Specialization_Id = Specialization_Id_ ,
Specialization_Name = Specialization_Name_ ,
Experience_Id = Experience_Id_ ,
Experience_Name = Experience_Name_ ,
Qualification_Id = Qualification_Id_ ,
Qualification_Name = Qualification_Name_ ,
Remark = Remark_ ,
Resume = Resume_ ,
Experience_Certificate = Experience_Certificate_ ,
Photo = Photo_ ,
Status_Id = Status_Id_ ,
Status_Name = Status_Name_ ,
User_Id = User_Id_  Where Candidate_Job_Apply_Id=Candidate_Job_Apply_Id_ ;
 ELSE 
 SET Candidate_Job_Apply_Id_ = (SELECT  COALESCE( MAX(Candidate_Job_Apply_Id ),0)+1 FROM Candidate_Job_Apply); 
 INSERT INTO Candidate_Job_Apply(Candidate_Job_Apply_Id ,
Candidate_Id ,
Entry_Date ,
Skills ,
Designation ,
Functional_Area_Id ,
Functional_Area_Name ,
Specialization_Id ,
Specialization_Name ,
Experience_Id ,
Experience_Name ,
Qualification_Id ,
Qualification_Name ,
Remark ,
Resume ,
Experience_Certificate ,
Photo ,
Status_Id ,
Status_Name ,
User_Id ,
DeleteStatus ) values (Candidate_Job_Apply_Id_ ,
Candidate_Id_ ,
Entry_Date_ ,
Skills_ ,
Designation_ ,
Functional_Area_Id_ ,
Functional_Area_Name_ ,
Specialization_Id_ ,
Specialization_Name_ ,
Experience_Id_ ,
Experience_Name_ ,
Qualification_Id_ ,
Qualification_Name_ ,
Remark_ ,
Resume_ ,
Experience_Certificate_ ,
Photo_ ,
Status_Id_ ,
Status_Name_ ,
User_Id_ ,
false);
 End If ;
 select Candidate_Job_Apply_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Candidate_Public`( In Candidate_Id_ int,
Candidate_Name_ varchar(100),Mobile_ varchar(100),Email_ varchar(100),Password_ varchar(100))
Begin 
 SET Candidate_Id_ = (SELECT  COALESCE( MAX(Candidate_Id ),0)+1 FROM Candidate); 
 INSERT INTO Candidate(Candidate_Id ,Candidate_Name ,Mobile ,Email,User_Name,Password,DeleteStatus ) 
values (Candidate_Id_ ,Candidate_Name_ ,Mobile_ ,Email_, Email_,Password_ ,0); 
 select Candidate_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Category`( In Category_Id_ int,
Category_Name_ varchar(100),
Commision_Percentage_ decimal,
User_Id_ int)
Begin 
 if  Category_Id_>0
 THEN 
 UPDATE Category set Category_Id = Category_Id_ ,
Category_Name = Category_Name_ ,
Commision_Percentage = Commision_Percentage_ ,
User_Id = User_Id_  Where Category_Id=Category_Id_ ;
 ELSE 
 SET Category_Id_ = (SELECT  COALESCE( MAX(Category_Id ),0)+1 FROM Category); 
 INSERT INTO Category(Category_Id ,
Category_Name ,
Commision_Percentage ,
User_Id ,
DeleteStatus ) values (Category_Id_ ,
Category_Name_ ,
Commision_Percentage_ ,
User_Id_ ,
false);
 End If ;
 select Category_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Certificates`( In Certificates_Id_ int,
Certificates_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Certificates_Id_>0
 THEN 
 UPDATE Certificates set Certificates_Id = Certificates_Id_ ,
Certificates_Name = Certificates_Name_ ,
User_Id = User_Id_  Where Certificates_Id=Certificates_Id_ ;
 ELSE 
 SET Certificates_Id_ = (SELECT  COALESCE( MAX(Certificates_Id ),0)+1 FROM Certificates); 
 INSERT INTO Certificates(Certificates_Id ,
Certificates_Name ,
User_Id ,
DeleteStatus ) values (Certificates_Id_ ,
Certificates_Name_ ,
User_Id_ ,
false);
 End If ;
 select Certificates_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Certificate_Request`( In Certificate_Request_Id_ int,
Student_Id_ int,
Date_ datetime,
Certificates_Id_ int,
Status_ int)
Begin 
 if  Certificate_Request_Id_>0
 THEN 
 UPDATE Certificate_Request set Certificate_Request_Id = Certificate_Request_Id_ ,
Student_Id = Student_Id_ ,
Date = Date_ ,
Certificates_Id = Certificates_Id_ ,
Status = Status_  Where Certificate_Request_Id=Certificate_Request_Id_ ;
 ELSE 
 SET Certificate_Request_Id_ = (SELECT  COALESCE( MAX(Certificate_Request_Id ),0)+1 FROM Certificate_Request); 
 INSERT INTO Certificate_Request(Certificate_Request_Id ,
Student_Id ,
Date ,
Certificates_Id ,
Status ,
DeleteStatus ) values (Certificate_Request_Id_ ,
Student_Id_ ,
Date_ ,
Certificates_Id_ ,
Status_ ,
false);
 End If ;
 select Certificate_Request_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Company`( In Company_ JSON, Company_value_ int)
Begin 
DECLARE Company_Id_ int;DECLARE Company_Name_ varchar(45);DECLARE Phone1_ varchar(45);
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
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Company_Name'))) INTO Company_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Phone1'))) INTO Phone1_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Email'))) INTO Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Website'))) INTO Website_;	
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Address1'))) INTO Address1_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Address2'))) INTO Address2_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Address3'))) INTO Address3_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Company_,('$.Logo'))) INTO  Logo_;
	if( Company_Id_>0 )
	then
		if Logo_<>''  and  Logo_<>'undefined' then
			UPDATE Company set Logo = Logo_ Where Company_Id=Company_Id_ ;
		end if;
		UPDATE Company set Company_Id = Company_Id_ ,Company_Name = Company_Name_ ,Phone1 = Phone1_ ,Mobile=Phone1_,
		Website = Website_ ,Email = Email_,Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_
		Where Company_Id = Company_Id_ ;	
	end if;
end if;
#commit;
select Company_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Complaint`(IN Complaint_Id_ INT,  Student_Id_ INT,  Description_ VARCHAR(2000))
BEGIN
 declare Student_Name_  varchar(100);
declare To_User_ int;
declare To_User_Name_ varchar(100);
declare Notification_Type_Name_ varchar(100);
declare Notification_Id_ int;
declare Notification_Count_ int;
declare Entry_Type_ int;
declare Unread_Status int;

    IF Complaint_Id_>0 THEN
        UPDATE complaint
        SET Student_Id = Student_Id_, Description = Description_
        WHERE Complaint_Id = Complaint_Id_;
    ELSE
		SET Complaint_Id_ = (SELECT  COALESCE( MAX(Complaint_Id ),0)+1 FROM complaint); 
        INSERT INTO complaint (Complaint_Id, Student_Id, Description, Entry_Date, DeleteStatus,Complaint_Status)
        VALUES (Complaint_Id_, Student_Id_, Description_, NOW(), 0,1);
        
        set To_User_=(select Complaint_Users_Id from application_settings where DeleteStatus=0);
		set To_User_Name_=(select Complaint_Users_Name from application_settings where DeleteStatus=0);
		set Unread_Status=0;
        set Student_Name_=(select Student_Name from student where DeleteStatus=0 and Student_Id=Student_Id_);
if Unread_Status=null or '' then set Unread_Status=0;end if;
		if (To_User_>0)then
			set Notification_Type_Name_ =(select Notification_Type_Name from Notification_Type where Notification_Type_Id=2);
			set Entry_Type_ =2;
			if(Unread_Status = 0) then    
			SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
			insert into Notification (Notification_Id,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,Description,Entry_Type,Read_Status,Notification_Type_Name)
								values(Notification_Id_,To_User_,To_User_Name_,0,'',1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_,0,Notification_Type_Name_);

			set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM users where Users_Id = To_User_);    
			update users set Notification_Count = Notification_Count_ where Users_Id=To_User_;              
		end if;
		end if;

    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course`( In Course_Id_ int,Course_Name_ varchar(1000),
Course_Type_Id_ int,Course_Type_Name_ varchar(100),Duration_ varchar(100),Agent_Amount_ decimal,User_Id_ int,
Total_Fees_ decimal(18,2),Fees_Type_Id_ int ,Course_Subject Json,Course_Fees Json,Is_Check tinyint )
Begin
declare Amount_ decimal(18,2);declare Instalment_Period_ decimal(18,2);
declare Part_Id_ int;declare Subject_Id_ int;declare Subject_Name_ varchar(1000);declare Minimum_Mark_ varchar(100);
declare Maximum_Mark_ varchar(100);declare Online_Exam_Status_ int;declare No_of_Question_ varchar(100);
declare Exam_Duration_ varchar(100);declare Tax_ decimal(18,2);declare Period_Id_ int;declare Period_From_ datetime;declare Period_To_ datetime;declare Period_Name_ varchar(45);

declare Task_ longtext;
declare Day_ varchar(45);
declare Heading_ text;

#declare No_Of_Instalment_ int;
DECLARE i int  DEFAULT 0;DECLARE j int  DEFAULT 0;

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
if  Course_Id_>0
THEN
Delete from Course_Subject where Course_Id=Course_Id_;
delete from Course_Fees where Course_Id=Course_Id_;
UPDATE Course set Course_Id = Course_Id_ ,Course_Name = Course_Name_ ,Course_Type_Id = Course_Type_Id_ ,
Course_Type_Name = Course_Type_Name_ ,Duration = Duration_ ,Agent_Amount = Agent_Amount_ ,User_Id = User_Id_ ,
Total_Fees=Total_Fees_,Fees_Type_Id=Fees_Type_Id_ Where Course_Id=Course_Id_ ;

update student set CourseName = Course_Name_ where Course_Id = Course_Id_;
ELSE
SET Course_Id_ = (SELECT  COALESCE( MAX(Course_Id ),0)+1 FROM Course);
INSERT INTO Course(Course_Id ,Course_Name ,Course_Type_Id ,Course_Type_Name ,Duration ,Agent_Amount ,
User_Id ,Total_Fees,Fees_Type_Id, DeleteStatus )
values (Course_Id_ ,Course_Name_ ,Course_Type_Id_ ,Course_Type_Name_ ,Duration_ ,Agent_Amount_ ,
User_Id_ ,Total_Fees_,Fees_Type_Id_,false);
End If ;
#if Pack_Length_>0 then

WHILE i < JSON_LENGTH(Course_Fees) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Fees_Type_Id'))) INTO Fees_Type_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Amount'))) INTO Amount_;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].No_Of_Instalment'))) INTO No_Of_Instalment_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Instalment_Period'))) INTO Instalment_Period_;
       SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Tax'))) INTO Tax_;
       
       SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Period_Id'))) INTO Period_Id_;
       SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Period_From'))) INTO Period_From_;
       SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Period_To'))) INTO Period_To_;
       SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Fees,CONCAT('$[',i,'].Period_Name'))) INTO Period_Name_;
       
INSERT INTO Course_Fees(Course_Id ,Fees_Type_Id ,Amount ,
         #No_Of_Instalment ,
Instalment_Period ,Tax ,Period_Id,Period_From,Period_To,Period_Name,DeleteStatus )
values (Course_Id_ ,Fees_Type_Id_ ,Amount_ ,
        #No_Of_Instalment_ ,
Instalment_Period_ ,Tax_ ,Period_Id_,Period_From_,Period_To_,Period_Name_,false);

SELECT i + 1 INTO i;
        END WHILE;
    # end if;
# if Packing_Length_>0 then
        WHILE j < JSON_LENGTH(Course_Subject) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Part_Id'))) INTO Part_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Subject_Id'))) INTO Subject_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Subject_Name'))) INTO Subject_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Minimum_Mark'))) INTO Minimum_Mark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Maximum_Mark'))) INTO Maximum_Mark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Online_Exam_Status'))) INTO Online_Exam_Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].No_of_Question'))) INTO No_of_Question_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Exam_Duration'))) INTO Exam_Duration_;

SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Task'))) INTO Task_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Day'))) INTO Day_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Course_Subject,CONCAT('$[',j,'].Heading'))) INTO Heading_;
       
       set Subject_Id_ =(select COALESCE( MAX(Subject_Id ),0)  from subject where Subject_Name=Subject_Name_);
if(Subject_Id_ =0)
then
SET Subject_Id_ = (SELECT  COALESCE( MAX(Subject_Id ),0)+1 FROM subject);    
insert into subject values(Subject_Id_,Subject_Name_,0,User_Id_,0,Task_,Day_,Heading_);          
end if;  
INSERT INTO Course_Subject(Course_Id ,Part_Id ,Subject_Id ,Subject_Name ,Minimum_Mark ,Maximum_Mark ,Online_Exam_Status ,No_of_Question ,Exam_Duration ,DeleteStatus, 
Task,Day,Heading)
values (Course_Id_ ,Part_Id_ ,Subject_Id_ ,Subject_Name_ ,Minimum_Mark_ ,Maximum_Mark_ ,Online_Exam_Status_ ,No_of_Question_ ,Exam_Duration_ ,false,Task_,Day_,Heading_);

if  Is_Check=1
THEN
UPDATE student_course_subject set Minimum_Mark = Minimum_Mark_
 Where Subject_Id=Subject_Id_ and Course_Id=Course_Id_ ;
End If ;

SELECT j + 1 INTO j;
        END WHILE;
#end if;
 
 #COMMIT;
 select Course_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course_Fees`( In Course_Fees_Id_ int,
Course_Id_ int,
Fees_Type_Id_ int,
Amount_ decimal,
No_Of_Instalment_ varchar(100),
Instalment_Period_ varchar(100))
Begin 
 if  Course_Fees_Id_>0
 THEN 
 UPDATE Course_Fees set Course_Fees_Id = Course_Fees_Id_ ,
Course_Id = Course_Id_ ,
Fees_Type_Id = Fees_Type_Id_ ,
Amount = Amount_ ,
No_Of_Instalment = No_Of_Instalment_ ,
Instalment_Period = Instalment_Period_  Where Course_Fees_Id=Course_Fees_Id_ ;
 ELSE 
 SET Course_Fees_Id_ = (SELECT  COALESCE( MAX(Course_Fees_Id ),0)+1 FROM Course_Fees); 
 INSERT INTO Course_Fees(Course_Fees_Id ,
Course_Id ,
Fees_Type_Id ,
Amount ,
No_Of_Instalment ,
Instalment_Period ,
DeleteStatus ) values (Course_Fees_Id_ ,
Course_Id_ ,
Fees_Type_Id_ ,
Amount_ ,
No_Of_Instalment_ ,
Instalment_Period_ ,
false);
 End If ;
 select Course_Fees_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course_Import_Details`( In Course_Import_Details_Id_ int,
Course_Import_Master_Id_ int,
Course_Id_ int)
Begin 
 if  Course_Import_Details_Id_>0
 THEN 
 UPDATE Course_Import_Details set Course_Import_Details_Id = Course_Import_Details_Id_ ,
Course_Import_Master_Id = Course_Import_Master_Id_ ,
Course_Id = Course_Id_  Where Course_Import_Details_Id=Course_Import_Details_Id_ ;
 ELSE 
 SET Course_Import_Details_Id_ = (SELECT  COALESCE( MAX(Course_Import_Details_Id ),0)+1 FROM Course_Import_Details); 
 INSERT INTO Course_Import_Details(Course_Import_Details_Id ,
Course_Import_Master_Id ,
Course_Id ,
DeleteStatus ) values (Course_Import_Details_Id_ ,
Course_Import_Master_Id_ ,
Course_Id_ ,
false);
 End If ;
 select Course_Import_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course_Import_Master`( In Course_Import_Master_Id_ int,
Date_ datetime,
User_Id_ int)
Begin 
 if  Course_Import_Master_Id_>0
 THEN 
 UPDATE Course_Import_Master set Course_Import_Master_Id = Course_Import_Master_Id_ ,
Date = Date_ ,
User_Id = User_Id_  Where Course_Import_Master_Id=Course_Import_Master_Id_ ;
 ELSE 
 SET Course_Import_Master_Id_ = (SELECT  COALESCE( MAX(Course_Import_Master_Id ),0)+1 FROM Course_Import_Master); 
 INSERT INTO Course_Import_Master(Course_Import_Master_Id ,
Date ,
User_Id ,
DeleteStatus ) values (Course_Import_Master_Id_ ,
Date_ ,
User_Id_ ,
false);
 End If ;
 select Course_Import_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course_Subject`( In Course_Subject_Id_ int,
Course_Id_ int,
Part_Id_ int,
Subject_Id_ int,
Subject_Name_ varchar(100),
Minimum_Mark_ varchar(100),
Maximum_Mark_ varchar(100),
Online_Exam_Status_ varchar(100),
No_of_Question_ varchar(100),
Exam_Duration_ varchar(100))
Begin 
 if  Course_Subject_Id_>0
 THEN 
 UPDATE Course_Subject set Course_Subject_Id = Course_Subject_Id_ ,
Course_Id = Course_Id_ ,
Part_Id = Part_Id_ ,
Subject_Id = Subject_Id_ ,
Subject_Name = Subject_Name_ ,
Minimum_Mark = Minimum_Mark_ ,
Maximum_Mark = Maximum_Mark_ ,
Online_Exam_Status = Online_Exam_Status_ ,
No_of_Question = No_of_Question_ ,
Exam_Duration = Exam_Duration_  Where Course_Subject_Id=Course_Subject_Id_ ;
 ELSE 
 SET Course_Subject_Id_ = (SELECT  COALESCE( MAX(Course_Subject_Id ),0)+1 FROM Course_Subject); 
 INSERT INTO Course_Subject(Course_Subject_Id ,
Course_Id ,
Part_Id ,
Subject_Id ,
Subject_Name ,
Minimum_Mark ,
Maximum_Mark ,
Online_Exam_Status ,
No_of_Question ,
Exam_Duration ,
DeleteStatus ) values (Course_Subject_Id_ ,
Course_Id_ ,
Part_Id_ ,
Subject_Id_ ,
Subject_Name_ ,
Minimum_Mark_ ,
Maximum_Mark_ ,
Online_Exam_Status_ ,
No_of_Question_ ,
Exam_Duration_ ,
false);
 End If ;
 select Course_Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Course_Type`( In Course_Type_Id_ int,
Course_Type_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Course_Type_Id_>0
 THEN 
 UPDATE Course_Type set Course_Type_Id = Course_Type_Id_ ,
Course_Type_Name = Course_Type_Name_ ,
User_Id = User_Id_  Where Course_Type_Id=Course_Type_Id_ ;
 ELSE 
 SET Course_Type_Id_ = (SELECT  COALESCE( MAX(Course_Type_Id ),0)+1 FROM Course_Type); 
 INSERT INTO Course_Type(Course_Type_Id ,
Course_Type_Name ,
User_Id ,
DeleteStatus ) values (Course_Type_Id_ ,
Course_Type_Name_ ,
User_Id_ ,
false);
 End If ;
 select Course_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Document`( In Document_Id_ int,
Student_Id_ int,
Document_Name_ varchar(100),
Files_ varchar(100))
Begin 
 if  Document_Id_>0
 THEN 
 UPDATE Document set Document_Id = Document_Id_ ,
Student_Id = Student_Id_ ,
Document_Name = Document_Name_ ,
Files = Files_  Where Document_Id=Document_Id_ ;
 ELSE 
 SET Document_Id_ = (SELECT  COALESCE( MAX(Document_Id ),0)+1 FROM Document); 
 INSERT INTO Document(Document_Id ,
Student_Id ,
Document_Name ,
Files ,
DeleteStatus ) values (Document_Id_ ,
Student_Id_ ,
Document_Name_ ,
Files_ ,
false);
 End If ;
 select Document_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Employer_Details`( In Employer_Details_Id_ int,
Company_Name_ varchar(100),Contact_Person_ varchar(100),Contact_Number_ varchar(25),Email_Id_ varchar(1000),
Company_Location_ varchar(100),Website_ varchar(1000))
Begin 

 if   Employer_Details_Id_>0
 THEN 
 UPDATE Employer_Details set Employer_Details_Id = Employer_Details_Id_ ,
Company_Name = Company_Name_, Contact_Person = Contact_Person_, Contact_Number = Contact_Number_,
Email_Id = Email_Id_,Company_Location = Company_Location_,Website = Website_
 Where Employer_Details_Id = Employer_Details_Id_ ;
 ELSE 

 SET Employer_Details_Id_ = (SELECT  COALESCE( MAX(Employer_Details_Id ),0)+1 FROM Employer_Details); 
 INSERT INTO Employer_Details(Employer_Details_Id ,Company_Name ,Contact_Person ,Contact_Number ,Email_Id ,Company_Location ,Website ,Delete_Status,Entry_Date) 
values (Employer_Details_Id_ ,Company_Name_ ,Contact_Person_ ,Contact_Number_ ,Email_Id_ ,Company_Location_ ,Website_ ,false ,now());
 End If ;
 select Employer_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Employer_Status`( In Employer_Status_Id_ int,
Employer_Status_Name_ varchar(100),FollowUp_ tinyint,User_Id_ int)
Begin 
if  Employer_Status_Id_>0 THEN 
	UPDATE Employer_Status set Employer_Status_Name = Employer_Status_Name_ ,
	FollowUp=FollowUp_,User_Id = User_Id_ 
	Where Employer_Status_Id=Employer_Status_Id_ ;
   # update student set StatusName = Status_Name_,Status_FollowUp =FollowUp_  where Status = Status_Id_;
    #update student_followup set StatusName = Status_Name_,Status_FollowUp = FollowUp_ where Status = Status_Id_;
ELSE 
	SET Employer_Status_Id_ = (SELECT  COALESCE( MAX(Employer_Status_Id ),0)+1 FROM Employer_Status); 
	INSERT INTO Employer_Status(Employer_Status_Id ,Employer_Status_Name ,FollowUp,User_Id ,Group_Id,DeleteStatus ) 
	values (Employer_Status_Id_ ,Employer_Status_Name_ ,FollowUp_,User_Id_ ,3,false);
End If ;
	select Employer_Status_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Enquiry_Source`( In Enquiry_Source_Id_ int,
Enquiry_Source_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Enquiry_Source_Id_>0
 THEN 
 UPDATE Enquiry_Source set Enquiry_Source_Id = Enquiry_Source_Id_ ,
Enquiry_Source_Name = Enquiry_Source_Name_ ,
User_Id = User_Id_  Where Enquiry_Source_Id=Enquiry_Source_Id_ ;
 ELSE 
 SET Enquiry_Source_Id_ = (SELECT  COALESCE( MAX(Enquiry_Source_Id ),0)+1 FROM Enquiry_Source); 
 INSERT INTO Enquiry_Source(Enquiry_Source_Id ,
Enquiry_Source_Name ,
User_Id ,
DeleteStatus ) values (Enquiry_Source_Id_ ,
Enquiry_Source_Name_ ,
User_Id_ ,
false);
 End If ;
 select Enquiry_Source_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Exam_Details`( In Exam_Details_Id_ int,
Exam_Master_Id_ int,
Question_Id_ int,
Question_Name_ varchar(100),
Option_1_ varchar(100),
Option_2_ varchar(100),
Option_3_ varchar(100),
Option_4_ varchar(100),
Question_Answer_ varchar(100))
Begin 
 if  Exam_Details_Id_>0
 THEN 
 UPDATE Exam_Details set Exam_Details_Id = Exam_Details_Id_ ,
Exam_Master_Id = Exam_Master_Id_ ,
Question_Id = Question_Id_ ,
Question_Name = Question_Name_ ,
Option_1 = Option_1_ ,
Option_2 = Option_2_ ,
Option_3 = Option_3_ ,
Option_4 = Option_4_ ,
Question_Answer = Question_Answer_  Where Exam_Details_Id=Exam_Details_Id_ ;
 ELSE 
 SET Exam_Details_Id_ = (SELECT  COALESCE( MAX(Exam_Details_Id ),0)+1 FROM Exam_Details); 
 INSERT INTO Exam_Details(Exam_Details_Id ,
Exam_Master_Id ,
Question_Id ,
Question_Name ,
Option_1 ,
Option_2 ,
Option_3 ,
Option_4 ,
Question_Answer ,
DeleteStatus ) values (Exam_Details_Id_ ,
Exam_Master_Id_ ,
Question_Id_ ,
Question_Name_ ,
Option_1_ ,
Option_2_ ,
Option_3_ ,
Option_4_ ,
Question_Answer_ ,
false);
 End If ;
 select Exam_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Exam_Master`( In Exam_Master_Id_ int,
Exam_Date_ datetime,
Student_Id_ int,
Subject_Id_ int,
Subject_Name_ varchar(100),
Start_Time_ datetime,
End_Time_ datetime,
Mark_Obtained_ varchar(100),
User_Id_ int)
Begin 
 if  Exam_Master_Id_>0
 THEN 
 UPDATE Exam_Master set Exam_Master_Id = Exam_Master_Id_ ,
Exam_Date = Exam_Date_ ,
Student_Id = Student_Id_ ,
Subject_Id = Subject_Id_ ,
Subject_Name = Subject_Name_ ,
Start_Time = Start_Time_ ,
End_Time = End_Time_ ,
Mark_Obtained = Mark_Obtained_ ,
User_Id = User_Id_  Where Exam_Master_Id=Exam_Master_Id_ ;
 ELSE 
 SET Exam_Master_Id_ = (SELECT  COALESCE( MAX(Exam_Master_Id ),0)+1 FROM Exam_Master); 
 INSERT INTO Exam_Master(Exam_Master_Id ,
Exam_Date ,
Student_Id ,
Subject_Id ,
Subject_Name ,
Start_Time ,
End_Time ,
Mark_Obtained ,
User_Id ,
DeleteStatus ) values (Exam_Master_Id_ ,
Exam_Date_ ,
Student_Id_ ,
Subject_Id_ ,
Subject_Name_ ,
Start_Time_ ,
End_Time_ ,
Mark_Obtained_ ,
User_Id_ ,
false);
 End If ;
 select Exam_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Experience`( In Experience_Id_ int,
Experience_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Experience_Id_>0
 THEN 
 UPDATE Experience set Experience_Id = Experience_Id_ ,
Experience_Name = Experience_Name_ ,
User_Id = User_Id_  Where Experience_Id=Experience_Id_ ;
 ELSE 
 SET Experience_Id_ = (SELECT  COALESCE( MAX(Experience_Id ),0)+1 FROM Experience); 
 INSERT INTO Experience(Experience_Id ,
Experience_Name ,
User_Id ,
DeleteStatus ) values (Experience_Id_ ,
Experience_Name_ ,
User_Id_ ,
false);
 End If ;
 select Experience_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Fees_Receipt`( In Fees_Receipt_Id_ int,
Fees_Installment_Id_ int,
Course_Id_ int,
Course_Name_ varchar(100),
Student_Id_ int,
Fees_Type_Id_ int,
Fees_Type_Name_ varchar(100),
Amount_ decimal,
Date_ datetime)
Begin 
 if  Fees_Receipt_Id_>0
 THEN 
 UPDATE Fees_Receipt set Fees_Receipt_Id = Fees_Receipt_Id_ ,
Fees_Installment_Id = Fees_Installment_Id_ ,
Course_Id = Course_Id_ ,
Course_Name = Course_Name_ ,
Student_Id = Student_Id_ ,
Fees_Type_Id = Fees_Type_Id_ ,
Fees_Type_Name = Fees_Type_Name_ ,
Amount = Amount_ ,
Date = Date_  Where Fees_Receipt_Id=Fees_Receipt_Id_ ;
 ELSE 
 SET Fees_Receipt_Id_ = (SELECT  COALESCE( MAX(Fees_Receipt_Id ),0)+1 FROM Fees_Receipt); 
 INSERT INTO Fees_Receipt(Fees_Receipt_Id ,
Fees_Installment_Id ,
Course_Id ,
Course_Name ,
Student_Id ,
Fees_Type_Id ,
Fees_Type_Name ,
Amount ,
Date ,
DeleteStatus ) values (Fees_Receipt_Id_ ,
Fees_Installment_Id_ ,
Course_Id_ ,
Course_Name_ ,
Student_Id_ ,
Fees_Type_Id_ ,
Fees_Type_Name_ ,
Amount_ ,
Date_ ,
false);
 End If ;
 select Fees_Receipt_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Fees_Type`( In Fees_Type_Id_ int,
Fees_Type_Name_ varchar(100),
User_Id_ tinyint)
Begin 
 if  Fees_Type_Id_>0
 THEN 
 UPDATE Fees_Type set Fees_Type_Id = Fees_Type_Id_ ,
Fees_Type_Name = Fees_Type_Name_ ,
User_Id = User_Id_  Where Fees_Type_Id=Fees_Type_Id_ ;
 ELSE 
 SET Fees_Type_Id_ = (SELECT  COALESCE( MAX(Fees_Type_Id ),0)+1 FROM Fees_Type); 
 INSERT INTO Fees_Type(Fees_Type_Id ,
Fees_Type_Name ,
User_Id ,
DeleteStatus ) values (Fees_Type_Id_ ,
Fees_Type_Name_ ,
User_Id_ ,
false);
 End If ;
 select Fees_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Followup_Type`( In Followup_Type_Id_ int,
Followup_Type_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Followup_Type_Id_>0
 THEN 
 UPDATE Followup_Type set Followup_Type_Id = Followup_Type_Id_ ,
Followup_Type_Name = Followup_Type_Name_ ,
User_Id = User_Id_  Where Followup_Type_Id=Followup_Type_Id_ ;
 ELSE 
 SET Followup_Type_Id_ = (SELECT  COALESCE( MAX(Followup_Type_Id ),0)+1 FROM Followup_Type); 
 INSERT INTO Followup_Type(Followup_Type_Id ,
Followup_Type_Name ,
User_Id ,
DeleteStatus ) values (Followup_Type_Id_ ,
Followup_Type_Name_ ,
User_Id_ ,
false);
 End If ;
 select Followup_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Functionl_Area`( In Functionl_Area_Id_ int,
Functionl_Area_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Functionl_Area_Id_>0
 THEN 
 UPDATE Functionl_Area set Functionl_Area_Id = Functionl_Area_Id_ ,
Functionl_Area_Name = Functionl_Area_Name_ ,
User_Id = User_Id_  Where Functionl_Area_Id=Functionl_Area_Id_ ;
 ELSE 
 SET Functionl_Area_Id_ = (SELECT  COALESCE( MAX(Functionl_Area_Id ),0)+1 FROM Functionl_Area); 
 INSERT INTO Functionl_Area(Functionl_Area_Id ,
Functionl_Area_Name ,
User_Id ,
DeleteStatus ) values (Functionl_Area_Id_ ,
Functionl_Area_Name_ ,
User_Id_ ,
false);
 End If ;
 select Functionl_Area_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Interview`( In Interview_Master_Id_ int,
Course_Id_ int,Batch_Id_ int,User_Id_ int,Employer_Details_Id_ int,Description_ varchar(4000),Interview_Date_ datetime,
Interview_Student JSON)
BEGIN
DECLARE Student_Id_ int;DECLARE Company_Name_ Varchar(100);
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
   
START Transaction;*/
set Company_Name_=(select Company_Name from Company where Company_Id=1);
	if  Interview_Master_Id_>0 THEN
		delete from Interview_student where Interview_Master_Id=Interview_Master_Id_;
		UPDATE Interview_Master set Course_Id = Course_Id_ ,Batch_Id = Batch_Id_ ,
        User_Id = User_Id_ ,Employer_Details_Id=Employer_Details_Id_,Description=Description_,Interview_Date=Interview_Date_
		Where Interview_Master_Id=Interview_Master_Id_ ;
	ELSE
		SET Interview_Master_Id_ = (SELECT  COALESCE( MAX(Interview_Master_Id ),0)+1 FROM Interview_Master);
		INSERT INTO Interview_Master(Interview_Master_Id ,Course_Id ,Batch_Id ,User_Id,Employer_Details_Id,
        Date,Description,Interview_Date,DeleteStatus )
		values (Interview_Master_Id_,Course_Id_ ,Batch_Id_ ,User_Id_,Employer_Details_Id_,
        curdate(),Description_,Interview_Date_,false);
	End If ;
	if  Interview_Master_Id_>0 then
		WHILE i < JSON_LENGTH(Interview_Student) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Interview_Student,CONCAT('$[',i,'].Student_Id'))) INTO Student_Id_;
		INSERT INTO Interview_Student(Interview_Master_Id,Student_Id,DeleteStatus )
		values (Interview_Master_Id_ ,Student_Id_ ,false);
        Update Student set Interview_Schedule=1 , Interview_Schedule_Date=Interview_Date_ 
        where Student_Id=Student_Id_ and DeleteStatus=0;
		SELECT i + 1 INTO i;
		END WHILE;  
    end if;
#COMMIT;
	select Interview_Master_Id_,Description_,Phone,Company_Name_,(Date_Format(Interview_Date_,'%d-%m-%Y')) As Interview_Date_
    from student 
	where Student_Id in(select Student_Id from Interview_Student 
	where Interview_Master_Id=Interview_Master_Id_);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Job_Opening`( 
    In Job_Opening_Id_ int,Job_Title_ varchar(45),Comapny_Id_ int,Company_Name_ varchar(500),Contact_No_ varchar(45),No_of_Vacancy_ int,Salary_ varchar(100),Location_ varchar(45),
	Next_Followup_Date_ datetime,Employee_Status_Id_ int,Employee_Status_Name_ varchar(100),To_Staff_Id_ int,To_Staff_Name_ varchar(100),Remark_ varchar(1500),
    Contact_Person_ varchar(250),Email_ varchar(100),Address_ varchar(500),Website_ varchar(500),Gender_Id_ int,Gender_Name_ varchar(100),By_User_Id_ int,By_User_Name_ varchar(100),
    Job_Opening_Description_ varchar(4500),Vacancy_Source_Id_ int ,Vacancy_Source_Name_ varchar(500)
)
BEGIN 
declare Job_Opening_Followup_Id_ int;declare Followup_ tinyint;

set Followup_ = ( select FollowUp from employer_status where  Employer_Status_Id = Employee_Status_Id_);

 IF  Job_Opening_Id_>0 THEN 
	 UPDATE job_opening SET Job_Title = Job_Title_,Comapny_Id = Comapny_Id_,Company_Name = Company_Name_,Contact_No = Contact_No_,No_of_Vacancy = No_of_Vacancy_,Salary = Salary_,Location = Location_,
	 Next_Followup_Date = Next_Followup_Date_,Employee_Status_Id = Employee_Status_Id_,Employee_Status_Name = Employee_Status_Name_,To_Staff_Id = To_Staff_Id_,
	 To_Staff_Name = To_Staff_Name_,Remark = Remark_,Contact_Person = Contact_Person_,Email = Email_,Address = Address_,Website = Website_,Gender_Id = Gender_Id_,Gender_Name = Gender_Name_,
	 Job_Opening_Description = Job_Opening_Description_,By_User_Id=By_User_Id_,By_User_Name=By_User_Name_ ,Vacancy_Source_Id=Vacancy_Source_Id_ ,Vacancy_Source_Name=Vacancy_Source_Name_,Followup=Followup_
     WHERE Job_Opening_Id=Job_Opening_Id_;
 ELSE 
	 SET Job_Opening_Id_= (SELECT  COALESCE(MAX(Job_Opening_Id),0)+1 FROM job_opening);
     
     if  Comapny_Id_>0
	 THEN 
	 UPDATE employer_details set Employer_Details_Id = Comapny_Id_,Company_Name = Company_Name_,Contact_Person = Contact_Person_,Contact_Number = Contact_No_,Email_Id = Email_,
	 Company_Location = Location_,Website = Website_ Where Employer_Details_Id=Comapny_Id_;
	 ELSE 
	 SET Comapny_Id_ = (SELECT  COALESCE( MAX(Employer_Details_Id ),0)+1 FROM employer_details); 
	 INSERT INTO employer_details(Employer_Details_Id,Company_Name,Contact_Person,Contact_Number,Email_Id,Company_Location,Website,Delete_Status,Entry_Date,Job_Opening_Id)
	 values (Comapny_Id_,Company_Name_,Contact_Person_,Contact_No_,Email_,Location_,Website_,0,now(),Job_Opening_Id_);
	End If ;


	 INSERT INTO job_opening(Job_Opening_Id,Job_Title,Comapny_Id,Company_Name,Contact_No,No_of_Vacancy,Salary,Location,Next_Followup_Date,Entry_Date,Employee_Status_Id,Employee_Status_Name,
	 To_Staff_Id,To_Staff_Name,Remark,Contact_Person,Email,Address,Website,Gender_Id,Gender_Name,Job_Opening_Description,By_User_Id,By_User_Name,DeleteStatus,Vacancy_Source_Id,Vacancy_Source_Name,Job_Posting_Id,Followup)
     VALUES (Job_Opening_Id_, Job_Title_, Comapny_Id_, Company_Name_, Contact_No_, No_of_Vacancy_, Salary_, Location_, Next_Followup_Date_, now(), Employee_Status_Id_, Employee_Status_Name_, 
	 To_Staff_Id_, To_Staff_Name_, Remark_, Contact_Person_, Email_, Address_, Website_, Gender_Id_, Gender_Name_, Job_Opening_Description_,By_User_Id_,By_User_Name_, 0,Vacancy_Source_Id_,Vacancy_Source_Name_,0,Followup_
	 );
 END IF ;
 
 SET Job_Opening_Followup_Id_= (SELECT  COALESCE(MAX(Job_Opening_Followup_Id),0)+1 FROM job_opening_followup); 
 INSERT INTO job_opening_followup(Job_Opening_Followup_Id,Job_Opening_Id,Followup_Date,Entry_Date,Employee_Status_Id,Employee_Status_Name,To_Staff_Id,To_Staff_Name,Remark,By_User_Id,By_User_Name,DeleteStatus,Actual_Followup_Date)
 VALUES (Job_Opening_Followup_Id_, Job_Opening_Id_, Next_Followup_Date_, now(), Employee_Status_Id_, Employee_Status_Name_, To_Staff_Id_, To_Staff_Name_, Remark_,By_User_Id_,By_User_Name_, 0,now());
 
 SELECT Job_Opening_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Job_Opening_Followup`( In Job_Opening_Id_ int,Job_Opening_Followup_Id_ int,Next_Followup_Date_ datetime,Employee_Status_Id_ int,
Employee_Status_Name_ varchar(100),To_Staff_Id_ int,To_Staff_Name_ varchar(100),Remark_ varchar(1500),By_User_Id_ int,By_User_Name_ varchar(100))
BEGIN 
declare Followup_ tinyint;

 set Followup_ = ( select FollowUp from employer_status where  Employer_Status_Id = Employee_Status_Id_);
 
 SET Job_Opening_Followup_Id_= (SELECT  COALESCE(MAX(Job_Opening_Followup_Id),0)+1 FROM job_opening_followup); 
 INSERT INTO job_opening_followup(Job_Opening_Followup_Id,Job_Opening_Id,Followup_Date,Entry_Date,Employee_Status_Id,Employee_Status_Name,To_Staff_Id,To_Staff_Name,Remark,By_User_Id,By_User_Name,DeleteStatus,Actual_Followup_Date)
 VALUES (Job_Opening_Followup_Id_, Job_Opening_Id_, Next_Followup_Date_, curdate(), Employee_Status_Id_, Employee_Status_Name_, To_Staff_Id_, To_Staff_Name_, Remark_,By_User_Id_,By_User_Name_, 0,now());
 
 IF  Job_Opening_Id_>0 THEN 
	 UPDATE job_opening SET Next_Followup_Date = Next_Followup_Date_,Employee_Status_Id = Employee_Status_Id_,Employee_Status_Name = Employee_Status_Name_,To_Staff_Id = To_Staff_Id_,
	 To_Staff_Name = To_Staff_Name_,Remark = Remark_,By_User_Id=By_User_Id_,By_User_Name=By_User_Name_,Followup=Followup_ WHERE Job_Opening_Id=Job_Opening_Id_;
 END IF ;
 
 SELECT Job_Opening_Followup_Id_;
 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Job_Posting`( In Job_Posting_Id_ int,
Job_Title_ varchar(100),Descritpion_ varchar(4000),Skills_ varchar(100),No_Of_Vaccancy_ varchar(100),
Experience_ int,Experience_Name_ varchar(100),Job_Location_ varchar(100),Qualification_ int,Qualification_Name_ varchar(100),
Functional_Area_ int,Functional_Area_Name_ varchar(100),Specialization_ int,Specialization_Name_ Varchar(100),
Salary_ varchar(100),Last_Date_ datetime,Company_Id_ int,Company_Name_ varchar(100),Address_ varchar(100),Contact_Name_ varchar(100),
Contact_No_ varchar(100),Email_ varchar(100),Address1_ varchar(100),Address2_ varchar(100),Address3_ varchar(100),
Address4_ varchar(100),Pincode_ varchar(100),Status_ int,Logo_ varchar(100),User_Id_ int,Course_Id_ int,Course_Name_ varchar(100),
Gender_Id_ int,Gender_Name_ varchar(45),Last_Time_ time,Job_Opening_Id_ int)
Begin  
Declare Old_Course_Id int; declare student_id_new_ int;declare Job_Code_ varchar(100);declare Job_Code_No_ int;

SET Job_Code_No_ = (SELECT  COALESCE( MAX(Job_Code_No ),0)+1 FROM Job_Posting);

SET Job_Code_ = CONCAT('OT0', Job_Code_No_);

if  Job_Posting_Id_>0 THEN
set Old_Course_Id =(select Course_Id from Job_Posting where Job_Posting_Id=Job_Posting_Id_ );
UPDATE Job_Posting set Job_Title = Job_Title_ ,Descritpion = Descritpion_ ,
Skills = Skills_ ,No_Of_Vaccancy = No_Of_Vaccancy_ ,Experience = Experience_ ,Job_Location = Job_Location_ ,
Qualification = Qualification_ ,Functional_Area = Functional_Area_ ,Specialization = Specialization_ ,
Salary = Salary_ ,Last_Date = Last_Date_ ,Company_Name = Company_Name_ ,Company_Id=Company_Id_,Address = Address_ ,
Contact_Name = Contact_Name_ ,Contact_No = Contact_No_ ,Email = Email_ ,Address1 = Address1_ ,
Address2 = Address2_ ,Address3 = Address3_ ,Address4 = Address4_ ,Pincode = Pincode_ ,
Status = Status_ ,User_Id = User_Id_ ,Experience_Name=Experience_Name_,Qualification_Name=Qualification_Name_,
    Functional_Area_Name=Functional_Area_Name_,Specialization_Name=Specialization_Name_,Course_Id=Course_Id_,Course_Name=Course_Name_,
    Gender_Id=Gender_Id_,Gender_Name=Gender_Name_,Last_Time=Last_Time_
    #Job_Code = Job_Code_ ,
    Where Job_Posting_Id=Job_Posting_Id_ ;
    if Logo_ !='' then
update Job_Posting set Logo = Logo_  where Job_Posting_Id=Job_Posting_Id_ ;
    end if;

   /* if Gender_Id_=3 then
update Student SET Offer= Offer-1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
inner join student_course on Student.Student_Id=student_course.Student_Id  and student_course.Course_Id=Old_Course_Id
and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0 )as a );
    else
   
    update Student SET Offer= Offer-1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
inner join student_course on Student.Student_Id=student_course.Student_Id and Student.Gender=Gender_Id_  and student_course.Course_Id=Old_Course_Id
and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0)as a );
   

    end if;*/
   
        update Student SET Offer= Offer-1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Candidate_Id as Student_Id From job_candidate where Job_Id=job_posting_Id_ ) as a);
    delete from job_candidate where job_id=job_posting_Id_;
     
 ELSE
SET Job_Posting_Id_ = (SELECT  COALESCE( MAX(Job_Posting_Id ),0)+1 FROM Job_Posting);
INSERT INTO Job_Posting(Job_Posting_Id ,Job_Code ,Job_Title ,Descritpion ,Skills ,No_Of_Vaccancy ,
Experience,Experience_Name,Job_Location ,Qualification ,Qualification_Name,Functional_Area ,Functional_Area_Name,
    Specialization, Specialization_Name ,Salary ,Last_Date ,Company_Id,Company_Name ,
Address ,Contact_Name ,Contact_No ,Email ,Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,Status ,
Logo ,User_Id ,Course_Id,Course_Name,DeleteStatus,Entry_Date,Applied_Count,Reject_Count,Gender_Id,Gender_Name,Job_Code_No,Last_Time ,Job_Opening_Id)
values (Job_Posting_Id_ ,Job_Code_ ,Job_Title_ ,Descritpion_ ,Skills_ ,No_Of_Vaccancy_ ,Experience_ ,
    Experience_Name_, Job_Location_ ,Qualification_ ,Qualification_Name_,Functional_Area_ ,Functional_Area_Name_,
    Specialization_ , Specialization_Name_,Salary_ ,Last_Date_ ,Company_Id_,Company_Name_ ,
Address_ ,Contact_Name_ ,Contact_No_ ,Email_ ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,
Status_ ,Logo_ ,User_Id_ ,Course_Id_,Course_Name_,false,CURDATE(),0,0,Gender_Id_,Gender_Name_,Job_Code_No_,Last_Time_,Job_Opening_Id_);
     insert into notifications values(0,Job_Title_,Descritpion_,'',Job_Posting_Id_);
     
if(Job_Opening_Id_>0) then
update  job_opening set Job_Posting_Id = Job_Posting_Id_ where Job_Opening_Id =Job_Opening_Id_;
end if;

 End If ;
 if Gender_Id_=3 then
update Student SET Offer= Offer+1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and  student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0)as a );
INSERT INTO job_candidate (Job_Candidate_Id, Job_Id,Last_Date,Apply_Status, Candidate_Id)
     SELECT distinct 0, Job_Posting_Id_ ,Last_Date_,0,Student.Student_Id FROM Student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0;
     else
     update Student SET Offer= Offer+1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and Student.Gender=Gender_Id_ and  student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0)as a );
INSERT INTO job_candidate (Job_Candidate_Id, Job_Id,Last_Date,Apply_Status, Candidate_Id)
     SELECT distinct 0, Job_Posting_Id_ ,Last_Date_,0,Student.Student_Id FROM Student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and Student.Gender=Gender_Id_ and student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0;
    # end if;
     end if;
     
   set student_id_new_ = (select  COALESCE( MAX(Student.Student_Id ),0)  FROM Student inner join job_candidate on job_candidate.Candidate_Id=student.Student_Id
   inner join job_posting on job_posting.Job_Posting_Id=job_candidate.Job_Id
	and job_candidate.Job_Id=Job_Posting_Id_ and student.DeleteStatus =0 and Device_Id IS NOT NULL  and Device_Id !='' and job_posting.Last_Date >= curdate() 
    and job_candidate.Candidate_Id not in(select Student_Id from applied_jobs where Job_Id=Job_Posting_Id_));
    
    #insert into data_log_ values(0,student_id_new_,'v');

if student_id_new_ != 0 then
#insert into data_log_ values(0,Job_Posting_Id_,'');
   SELECT distinct   Job_Posting_Id_ ,Student.Student_Id,Student.Student_Name, (Date_Format(job_posting.Last_Date,'%d-%m-%Y')) as Last_Date,Job_Title,Last_Time,Student.Phone,
   Device_Id FROM Student inner join job_candidate on job_candidate.Candidate_Id=student.Student_Id
   inner join job_posting on job_posting.Job_Posting_Id=job_candidate.Job_Id
	and student.DeleteStatus =0 and job_candidate.Job_Id=Job_Posting_Id_ and Device_Id IS NOT NULL  and Device_Id !='' and job_posting.Last_Date >= curdate() 
    and job_candidate.Candidate_Id not in(select Student_Id from applied_jobs where Job_Id=Job_Posting_Id_);
else
   select Job_Posting_Id_;
end if; 


#update student set Blacklist_Status=true where (student.Offer-(Applied+Rejected))>3;
 #insert into data_log_ values(0,Job_Posting_Id_,'x');  
 end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Job_Posting_old`( In Job_Posting_Id_ int,Job_Code_ varchar(100),
Job_Title_ varchar(100),Descritpion_ varchar(4000),Skills_ varchar(100),No_Of_Vaccancy_ varchar(100),
Experience_ int,Experience_Name_ varchar(100),Job_Location_ varchar(100),Qualification_ int,Qualification_Name_ varchar(100),
Functional_Area_ int,Functional_Area_Name_ varchar(100),Specialization_ int,Specialization_Name_ Varchar(100),
Salary_ varchar(100),Last_Date_ datetime,Company_Id_ int,Company_Name_ varchar(100),Address_ varchar(100),Contact_Name_ varchar(100),
Contact_No_ varchar(100),Email_ varchar(100),Address1_ varchar(100),Address2_ varchar(100),Address3_ varchar(100),
Address4_ varchar(100),Pincode_ varchar(100),Status_ int,Logo_ varchar(100),User_Id_ int,Course_Id_ int,Course_Name_ varchar(100),Gender_Id_ int,Gender_Name_ varchar(45))
Begin  
Declare Old_Course_Id int;
if  Job_Posting_Id_>0 THEN
set Old_Course_Id =(select Course_Id from Job_Posting where Job_Posting_Id=Job_Posting_Id_ );
UPDATE Job_Posting set Job_Code = Job_Code_ ,Job_Title = Job_Title_ ,Descritpion = Descritpion_ ,
Skills = Skills_ ,No_Of_Vaccancy = No_Of_Vaccancy_ ,Experience = Experience_ ,Job_Location = Job_Location_ ,
Qualification = Qualification_ ,Functional_Area = Functional_Area_ ,Specialization = Specialization_ ,
Salary = Salary_ ,Last_Date = Last_Date_ ,Company_Name = Company_Name_ ,Company_Id=Company_Id_,Address = Address_ ,
Contact_Name = Contact_Name_ ,Contact_No = Contact_No_ ,Email = Email_ ,Address1 = Address1_ ,
Address2 = Address2_ ,Address3 = Address3_ ,Address4 = Address4_ ,Pincode = Pincode_ ,
Status = Status_ ,User_Id = User_Id_ ,Experience_Name=Experience_Name_,Qualification_Name=Qualification_Name_,
    Functional_Area_Name=Functional_Area_Name_,Specialization_Name=Specialization_Name_,Course_Id=Course_Id_,Course_Name=Course_Name_,
    Gender_Id=Gender_Id_,Gender_Name=Gender_Name_
    Where Job_Posting_Id=Job_Posting_Id_ ;
    if Logo_ !='' then
update Job_Posting set Logo = Logo_  where Job_Posting_Id=Job_Posting_Id_ ;
    end if;

   /* if Gender_Id_=3 then
update Student SET Offer= Offer-1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
inner join student_course on Student.Student_Id=student_course.Student_Id  and student_course.Course_Id=Old_Course_Id
and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0 )as a );
    else
   
    update Student SET Offer= Offer-1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
inner join student_course on Student.Student_Id=student_course.Student_Id and Student.Gender=Gender_Id_  and student_course.Course_Id=Old_Course_Id
and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0)as a );
   

    end if;*/
   
        update Student SET Offer= Offer-1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Candidate_Id as Student_Id From job_candidate where Job_Id=job_posting_Id_ ) as a);
    delete from job_candidate where job_id=job_posting_Id_;
     
 ELSE
SET Job_Posting_Id_ = (SELECT  COALESCE( MAX(Job_Posting_Id ),0)+1 FROM Job_Posting);
INSERT INTO Job_Posting(Job_Posting_Id ,Job_Code ,Job_Title ,Descritpion ,Skills ,No_Of_Vaccancy ,
Experience,Experience_Name,Job_Location ,Qualification ,Qualification_Name,Functional_Area ,Functional_Area_Name,
    Specialization, Specialization_Name ,Salary ,Last_Date ,Company_Id,Company_Name ,
Address ,Contact_Name ,Contact_No ,Email ,Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,Status ,
Logo ,User_Id ,Course_Id,Course_Name,DeleteStatus,Entry_Date,Applied_Count,Reject_Count,Gender_Id,Gender_Name )
values (Job_Posting_Id_ ,Job_Code_ ,Job_Title_ ,Descritpion_ ,Skills_ ,No_Of_Vaccancy_ ,Experience_ ,
    Experience_Name_, Job_Location_ ,Qualification_ ,Qualification_Name_,Functional_Area_ ,Functional_Area_Name_,
    Specialization_ , Specialization_Name_,Salary_ ,Last_Date_ ,Company_Id_,Company_Name_ ,
Address_ ,Contact_Name_ ,Contact_No_ ,Email_ ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,
Status_ ,Logo_ ,User_Id_ ,Course_Id_,Course_Name_,false,CURDATE(),0,0,Gender_Id_,Gender_Name_);
     insert into notifications values(0,Job_Title_,Descritpion_,'',Job_Posting_Id_);
     


 End If ;
 if Gender_Id_=3 then
update Student SET Offer= Offer+1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and  student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0)as a );
INSERT INTO job_candidate (Job_Candidate_Id, Job_Id, Candidate_Id)
     SELECT distinct 0, Job_Posting_Id_ ,Student.Student_Id FROM Student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0;
     else
     update Student SET Offer= Offer+1 WHERE Student_Id In (select Student_Id FROM ( select distinct  Student.Student_Id as Student_Id From student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and Student.Gender=Gender_Id_ and  student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0)as a );
INSERT INTO job_candidate (Job_Candidate_Id, Job_Id, Candidate_Id)
     SELECT distinct 0, Job_Posting_Id_ ,Student.Student_Id FROM Student
     inner join student_course on Student.Student_Id=student_course.Student_Id  and Student.Gender=Gender_Id_ and student_course.Course_Id=Course_Id_
     and Student_Status=1 and Activate_Status=1 and Fees_Status=1 and Blacklist_Status=0;
    # end if;
     end if;
   
 #select Job_Posting_Id_;
 
   SELECT distinct   Job_Posting_Id_ ,Student.Student_Id,Device_Id FROM Student inner join job_candidate on job_candidate.Candidate_Id=student.Student_Id
   inner join job_posting on job_posting.Job_Posting_Id=job_candidate.Job_Id
	and job_candidate.Job_Id=Job_Posting_Id_ and job_posting.Last_Date >= curdate() and job_candidate.Candidate_Id not in(select Student_Id from applied_jobs where Job_Id=Job_Posting_Id_);

   
     
 end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Mark_List`( In Mark_List_Id_ int,
Student_Id_ int,
Course_Id_ int,
Course_Name_ varchar(100),
Subject_Id_ int,
Subject_Name_ varchar(100),
Minimum_Mark_ varchar(100),
Maximum_Mark_ varchar(100),
Mark_Obtained_ varchar(100),
User_Id_ int)
Begin 
 if  Mark_List_Id_>0
 THEN 
 UPDATE Mark_List set Mark_List_Id = Mark_List_Id_ ,
Student_Id = Student_Id_ ,
Course_Id = Course_Id_ ,
Course_Name = Course_Name_ ,
Subject_Id = Subject_Id_ ,
Subject_Name = Subject_Name_ ,
Minimum_Mark = Minimum_Mark_ ,
Maximum_Mark = Maximum_Mark_ ,
Mark_Obtained = Mark_Obtained_ ,
User_Id = User_Id_  Where Mark_List_Id=Mark_List_Id_ ;
 ELSE 
 SET Mark_List_Id_ = (SELECT  COALESCE( MAX(Mark_List_Id ),0)+1 FROM Mark_List); 
 INSERT INTO Mark_List(Mark_List_Id ,
Student_Id ,
Course_Id ,
Course_Name ,
Subject_Id ,
Subject_Name ,
Minimum_Mark ,
Maximum_Mark ,
Mark_Obtained ,
User_Id ,
DeleteStatus ) values (Mark_List_Id_ ,
Student_Id_ ,
Course_Id_ ,
Course_Name_ ,
Subject_Id_ ,
Subject_Name_ ,
Minimum_Mark_ ,
Maximum_Mark_ ,
Mark_Obtained_ ,
User_Id_ ,
false);
 End If ;
 select Mark_List_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Mark_List_Master`( In Mark_List_Master_Id_ int,
Student_Id_ int,Course_Id_ int,Course_Name_ varchar(100),User_Id_ int,Mark_List Json)
Begin 
declare Subject_Id_ int;declare Subject_Name_ varchar(100);declare Minimum_Mark_ varchar(100);
declare Maximum_Mark_ varchar(100);
declare Mark_Obtained_ varchar(100);declare Grade_ varchar(100);declare Exam_Status_Id_ int;
DECLARE i int  DEFAULT 0;

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
	if  Mark_List_Master_Id_>0 THEN 
		Delete from mark_list where Mark_List_Master_Id=Mark_List_Master_Id_;
		UPDATE mark_list_master set Mark_List_Master_Id = Mark_List_Master_Id_ ,Student_Id = Student_Id_ ,Course_Id = Course_Id_ ,
		Course_Name = Course_Name_ ,User_Id = User_Id_  
		Where Mark_List_Master_Id=Mark_List_Master_Id_ ;
	ELSE 
		SET Mark_List_Master_Id_ = (SELECT  COALESCE( MAX(Mark_List_Master_Id ),0)+1 FROM mark_list_master); 
		INSERT INTO mark_list_master(Mark_List_Master_Id ,Student_Id ,Course_Id ,Course_Name ,User_Id ,DeleteStatus ) 
		values (Mark_List_Master_Id_ ,Student_Id_ ,Course_Id_ ,Course_Name_ ,User_Id_ ,false);
	End If ;
	WHILE i < JSON_LENGTH(Mark_List) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Mark_List,CONCAT('$[',i,'].Subject_Id'))) INTO Subject_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Mark_List,CONCAT('$[',i,'].Subject_Name'))) INTO Subject_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Mark_List,CONCAT('$[',i,'].Minimum_Mark'))) INTO Minimum_Mark_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Mark_List,CONCAT('$[',i,'].Maximum_Mark'))) INTO Maximum_Mark_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Mark_List,CONCAT('$[',i,'].Mark_Obtained'))) INTO Mark_Obtained_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Mark_List,CONCAT('$[',i,'].Grade'))) INTO Grade_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Mark_List,CONCAT('$[',i,'].Exam_Status_Id'))) INTO Exam_Status_Id_;
        
		 INSERT INTO Mark_List(Mark_List_Master_Id ,Subject_Id ,Subject_Name ,Minimum_Mark ,Maximum_Mark ,
		Mark_Obtained ,Grade,Exam_Status_Id,DeleteStatus )
		values (Mark_List_Master_Id_ ,Subject_Id_ ,Subject_Name_ ,Minimum_Mark_ ,Maximum_Mark_ ,
		Mark_Obtained_ ,Grade_ ,Exam_Status_Id_ ,false);
		SELECT i + 1 INTO i;
	END WHILE;
 select Mark_List_Master_Id_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Mark_Placement`(In Placement_Date_ date, Applied_Jobs_Id_ varchar(1000),Placement_Description_ varchar(2000),Placement_Schedule_User_ int,
Student_Id_ varchar(1000),Job_Id_ int)
BEGIN
declare Job_Opening_Id_ int;declare employe_status_ int;

set @query=Concat("update applied_jobs set Placement_Date='",Placement_Date_,"',Placement_Status=1,Current_Status=3,
Placement_Description ='",Placement_Description_,"',Placement_Schedule_User=",Placement_Schedule_User_," where Applied_Jobs_Id in (" , Applied_Jobs_Id_ , ")");
PREPARE QUERY FROM @query;EXECUTE QUERY;

set @query=Concat("update student set Placement_Count= Placement_Count+1 where Student_Id in (" , Student_Id_ , ")");
PREPARE QUERY FROM @query;EXECUTE QUERY;

set Job_Opening_Id_ =(select Job_Opening_Id from job_posting where Job_Posting_Id =Job_Id_);
set employe_status_ =(select Employee_Status_Id from job_opening where Job_Opening_Id =Job_Opening_Id_);
if(employe_status_!=6) then 
update job_opening set Employee_Status_Id=7 ,Employee_Status_Name="placed" where Job_Opening_Id =Job_Opening_Id_; 
end if;


 set @query=Concat("SELECT  distinct  1 as status_,  Student.Student_Id,Device_Id,(Date_Format(Placement_Date,'%d-%m-%Y')) As Placement_Date,
 Placement_Status,Placement_Description,Job_Id,job_posting.Job_Title,
 job_posting.Company_Name FROM Student 
inner join applied_jobs on applied_jobs.Student_Id=student.Student_Id
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id
and student.DeleteStatus =0 and  Placement_Status !=0 and  Job_Id='",Job_Id_,"'
 and applied_jobs.Student_Id  in (" , Student_Id_ , ")");
 

PREPARE QUERY FROM @query;EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Part`( In Part_Id_ int,
Part_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Part_Id_>0
 THEN 
 UPDATE Part set Part_Id = Part_Id_ ,
Part_Name = Part_Name_ ,
User_Id = User_Id_  Where Part_Id=Part_Id_ ;
 ELSE 
 SET Part_Id_ = (SELECT  COALESCE( MAX(Part_Id ),0)+1 FROM Part); 
 INSERT INTO Part(Part_Id ,
Part_Name ,
User_Id ,
DeleteStatus ) values (Part_Id_ ,
Part_Name_ ,
User_Id_ ,
false);
 End If ;
 select Part_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Period`( In Period_Id_ int,Period_Name_ varchar(100), Period_From_ datetime,Period_To_ datetime,Duration_ varchar(100) )
Begin 
 if  Period_Id_>0
 THEN 
	UPDATE Period set Period_Id = Period_Id_ ,Period_Name = Period_Name_  ,Period_From = Period_From_ ,Period_To = Period_To_  ,Duration=Duration_  Where Period_Id=Period_Id_ ;
    update course_fees set Period_From=Period_From_ ,Period_To=Period_To_,Period_Name=Period_Name_ where Period_Id=Period_Id_;
    
	 
 ELSE 
	SET Period_Id_ = (SELECT  COALESCE( MAX(Period_Id ),0)+1 FROM Period); 
	INSERT INTO Period(Period_Id ,Period_Name , Period_From,Period_To,DeleteStatus,Duration  ) 
	values (Period_Id_ ,Period_Name_ , Period_From_,Period_To_,false,Duration_  );
 End If ;
 select Period_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Placed`( In Placed_Master_Id_ int,
Course_Id_ int,Batch_Id_ int,User_Id_ int,Employer_Details_Id_ int,Description_ varchar(4000),Placed_Date_ datetime,
Placed_Student JSON)
BEGIN
DECLARE Student_Id_ int;DECLARE Company_Name_ Varchar(100);
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
   
START Transaction;*/
set Company_Name_=(select Company_Name from Company where Company_Id=1);
	if  Placed_Master_Id_>0 THEN
		delete from Placed_student where Placed_Master_Id=Placed_Master_Id_;
		UPDATE Placed_Master set Course_Id = Course_Id_ ,Batch_Id = Batch_Id_ ,
        User_Id = User_Id_ ,Employer_Details_Id=Employer_Details_Id_,Description=Description_,Placed_Date=Placed_Date_
		Where Placed_Master_Id=Placed_Master_Id_ ;
	ELSE
		SET Placed_Master_Id_ = (SELECT  COALESCE( MAX(Placed_Master_Id ),0)+1 FROM Placed_Master);
		INSERT INTO Placed_Master(Placed_Master_Id ,Course_Id ,Batch_Id ,User_Id,Employer_Details_Id,
        Date,Description,Placed_Date,DeleteStatus )
		values (Placed_Master_Id_,Course_Id_ ,Batch_Id_ ,User_Id_,Employer_Details_Id_,
        curdate(),Description_,Placed_Date_,false);
	End If ;
	if  Placed_Master_Id_>0 then
		WHILE i < JSON_LENGTH(Placed_Student) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Placed_Student,CONCAT('$[',i,'].Student_Id'))) INTO Student_Id_;
		INSERT INTO Placed_Student(Placed_Master_Id,Student_Id,DeleteStatus )
		values (Placed_Master_Id_ ,Student_Id_ ,false);
        Update Student set Placed=1 , Placed_Date=Placed_Date_ 
        where Student_Id=Student_Id_ and DeleteStatus=0;
		SELECT i + 1 INTO i;
		END WHILE;  
    end if;
#COMMIT;
	select Placed_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Qualification`( In Qualification_Id_ int,
Qualification_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Qualification_Id_>0
 THEN 
 UPDATE Qualification set 
Qualification_Name = Qualification_Name_ ,
User_Id = User_Id_  Where Qualification_Id=Qualification_Id_ ;
update student set QualificationName = Qualification_Name_ where Qualification_Id = Qualification_Id_;
 ELSE 
 SET Qualification_Id_ = (SELECT  COALESCE( MAX(Qualification_Id ),0)+1 FROM Qualification); 
 INSERT INTO Qualification(Qualification_Id ,
Qualification_Name ,
User_Id ,
DeleteStatus ) values (Qualification_Id_ ,
Qualification_Name_ ,
User_Id_ ,
false);
 End If ;
 select Qualification_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Question`( In Question_Id_ int,
Question_Name_ varchar(100),
Option_1_ varchar(100),
Option_2_ varchar(100),
Option_3_ varchar(100),
Option_4_ varchar(100),
Correct_Answer_ varchar(100),
Subject_Id_ int,
Subject_Name_ varchar(100),
Course_Id_ int,
Course_Name_ varchar(100),
Semester_Id_ int,
Semester_Name_ varchar(100))
Begin 
 if  Question_Id_>0
 THEN 
 UPDATE Question set Question_Id = Question_Id_ ,
Question_Name = Question_Name_ ,
Option_1 = Option_1_ ,
Option_2 = Option_2_ ,
Option_3 = Option_3_ ,
Option_4 = Option_4_ ,
Correct_Answer = Correct_Answer_ ,
Subject_Id = Subject_Id_ ,
Subject_Name = Subject_Name_ ,
Course_Id = Course_Id_ ,
Course_Name = Course_Name_ ,
Semester_Id = Semester_Id_ ,
Semester_Name = Semester_Name_  Where Question_Id=Question_Id_ ;
 ELSE 
 SET Question_Id_ = (SELECT  COALESCE( MAX(Question_Id ),0)+1 FROM Question); 
 INSERT INTO Question(Question_Id ,
Question_Name ,
Option_1 ,
Option_2 ,
Option_3 ,
Option_4 ,
Correct_Answer ,
Subject_Id ,
Subject_Name ,
Course_Id ,
Course_Name ,
Semester_Id ,
Semester_Name ,
DeleteStatus ) values (Question_Id_ ,
Question_Name_ ,
Option_1_ ,
Option_2_ ,
Option_3_ ,
Option_4_ ,
Correct_Answer_ ,
Subject_Id_ ,
Subject_Name_ ,
Course_Id_ ,
Course_Name_ ,
Semester_Id_ ,
Semester_Name_ ,
false);
 End If ;
 select Question_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Question_Import_Master`( In Question_Import_Details json,Question_Import_Master_Id_ int,
User_Id_ int,Course_Id_ int,Course_Name_ varchar(100),Semester_Id_ int,Semester_Name_ varchar(100),Subject_Id_ int,Subject_Name_ varchar(100))
Begin
declare Question_Id_ int;Declare i int;declare Question_Import_Details_Id_ int;
declare Question_Name_ varchar(100);declare Option_1_ varchar(100);
declare Option_2_ varchar(100);declare Option_3_ varchar(100);
declare Option_4_ varchar(100);declare Correct_Answer_ varchar(100);
Set i=0;
if Question_Import_Master_Id_>0
then
delete from question where Question_Import_Master_Id=Question_Import_Master_Id_;
Update question set Question_Import_Master_Id=Question_Import_Master_Id_,User_Id=User_Id_,Course_Id=Course_Id_,
Course_Name=Course_Name_,Semester_Id=Semester_Id_,Semester_Name=Semester_Name_,Subject_Id=Subject_Id_,
Subject_Name=Subject_Name_ Where Question_Import_Master_Id=Question_Import_Master_Id_ ;

else
 SET Question_Import_Master_Id_ = (SELECT  COALESCE( MAX(Question_Import_Master_Id ),0)+1 FROM question_import_master);
 insert into question_import_master values(Question_Import_Master_Id_,now(),User_Id_,Course_Id_,Course_Name_,Semester_Id_,Semester_Name_,
 Subject_Id_,Subject_Name_,false);
end if;
WHILE i < JSON_LENGTH(Question_Import_Details) DO
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Question_Import_Details,CONCAT('$[',i,'].Question_Name'))) INTO Question_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Question_Import_Details,CONCAT('$[',i,'].Option_1'))) INTO Option_1_ ;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Question_Import_Details,CONCAT('$[',i,'].Option_2'))) INTO Option_2_ ;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Question_Import_Details,CONCAT('$[',i,'].Option_3'))) INTO Option_3_ ;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Question_Import_Details,CONCAT('$[',i,'].Option_4'))) INTO Option_4_ ;
     SELECT JSON_UNQUOTE (JSON_EXTRACT(Question_Import_Details,CONCAT('$[',i,'].Correct_Answer'))) INTO Correct_Answer_ ;   
	insert into question(Question_Id,Question_Name,Question_Import_Master_Id,Option_1,Option_2,Option_3,Option_4,Correct_Answer,Subject_Id,Subject_Name,
	Course_Id,Course_Name,Semester_Id,Semester_Name,DeleteStatus)
   values(Question_Id_,Question_Name_,Question_Import_Master_Id_,Option_1_,Option_2_,Option_3_,Option_4_ ,Correct_Answer_,Subject_Id_,Subject_Name_,
	Course_Id_,Course_Name_,Semester_Id_,Semester_Name_,0);   
SELECT i + 1 INTO i;      
END WHILE;
 select Question_Import_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Receipt_Voucher`( In Receipt_Voucher_Id_ decimal,
Date_ datetime,Agent_Id_ DECIMAL(18,0),Amount_ DECIMAL(18,2),Payment_Mode_ decimal(18,0),
User_Id_ decimal(18,0),Payment_Status_ varchar(50),To_Account_Id_ decimal(18,0),
Description_ varchar(1000))
Begin 
	declare Voucher_No_ DECIMAL(18,0);declare Accounts_Id_ decimal(18,0);
	declare YearFrom datetime;declare YearTo datetime;DECLARE Check_Box_ varchar(25);
	declare Discount_ decimal(18,2);declare Receiving_Amount_ DECIMAL(18,2);
	declare From_Account_Id_ int;declare Center_Code_ varchar(100);declare Bill_No_ varchar(100);

	set From_Account_Id_=(select Client_Accounts_Id from Agent where Agent_Id=Agent_Id_);
	set Center_Code_=(select Center_Code from agent where Agent_Id=Agent_Id_ and DeleteStatus=0);

	set YearFrom=(select Account_Years.YearFrom from Account_Years where  
	Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
	set YearTo=(select Account_Years.YearTo from Account_Years where 
	Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
    
if exists(select distinct Voucher_No from Receipt_Voucher) then
	set Voucher_No_=(SELECT  COALESCE( MAX(Voucher_No ),0)+1 FROM Receipt_Voucher
	where Date_Format(Date,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') 
	and Date_Format(YearTo,'%Y-%m-%d') and DeleteStatus=false);  
else 
	if exists(select Receipt_Voucher_No from General_Settings)	then
		set Voucher_No_=(select COALESCE(Receipt_Voucher_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;
end if;
if  Receipt_Voucher_Id_>0 THEN 
	set Voucher_No_=(select Voucher_No from Receipt_Voucher Where  Receipt_Voucher_Id=Receipt_Voucher_Id_ );
	DELETE FROM Accounts WHERE Tran_Type='RV' AND Tran_Id=Receipt_Voucher_Id_;
	UPDATE Receipt_Voucher set Date = Date_  ,From_Account_Id = From_Account_Id_ ,
	Amount = Amount_ ,To_Account_Id = To_Account_Id_ ,Payment_Mode = Payment_Mode_ ,
	User_Id = User_Id_,Payment_Status=Payment_Status_ ,Description=Description_
	Where Receipt_Voucher_Id=Receipt_Voucher_Id_ ;
ELSE 
	SET Bill_No_ =COALESCE( Center_Code_ , Voucher_No_) ; 
	SET Receipt_Voucher_Id_ = (SELECT  COALESCE( MAX(Receipt_Voucher_Id ),0)+1 FROM Receipt_Voucher); 
	INSERT INTO Receipt_Voucher(Receipt_Voucher_Id ,Date ,Voucher_No ,From_Account_Id ,Amount ,
	Payment_Mode,User_Id,Payment_Status,To_Account_Id ,Description,Bill_No,Student_Course_Id,
    Fees_Type_Id,Center_Code,DeleteStatus) 
	values (Receipt_Voucher_Id_ ,Date_ ,Voucher_No_ ,From_Account_Id_ ,Amount_ ,
	Payment_Mode_ ,User_Id_ ,Payment_Status_,To_Account_Id_,Description_,Bill_No_,0,0,Center_Code_,false);
End If ;
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
	VoucherType,Description1,Status,DayBook,Payment_Status)
	values(Accounts_Id_,Date_,From_Account_Id_,0,Amount_,To_Account_Id_,'RV',Receipt_Voucher_Id_,
	Voucher_No_,2,Description_,'','',Payment_Status_);

	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
	VoucherType,Description1,Status,DayBook,Payment_Status) 
	values(Accounts_Id_,Date_,To_Account_Id_,Amount_,0,From_Account_Id_,'RV',Receipt_Voucher_Id_,
	Voucher_No_ ,2,Description_,'','Y',Payment_Status_); 

select Receipt_Voucher_Id_,Voucher_No_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_ReSchedule_Interview`(In Interview_Date_ date, Applied_Jobs_Id_ varchar(1000),Interview_Description_ varchar(2000),Interview_Schedule_User_ int,
Student_Id_ varchar(1000),Job_Id_ int,Interview_Location_ varchar(250),Interview_Time_ time)
BEGIN

set @query=Concat("update applied_jobs set Interview_Date='",Interview_Date_,"',Interview_Status=1,Current_Status=2,Interview_Attending_Rejecting=3,
Interview_Location ='",Interview_Location_,"',Interview_Time ='",Interview_Time_,"',Interview_Description ='",Interview_Description_,"',Interview_Schedule_User=",Interview_Schedule_User_," where Applied_Jobs_Id in (" , Applied_Jobs_Id_ , ")");

PREPARE QUERY FROM @query;EXECUTE QUERY;

/*set @query=Concat("update student set Interview_Count= Interview_Count+1 where Student_Id in (" , Student_Id_ , ")");

PREPARE QUERY FROM @query;EXECUTE QUERY;
*/

set @query=Concat("SELECT  distinct  1 as status_,  Student.Student_Id,Student.Student_Name,Device_Id,(Date_Format(Interview_Date,'%d-%m-%Y')) As Interview_Date,
Interview_Status,Interview_Description,Job_Id,job_posting.Job_Title ,Applied_Jobs_Id,Interview_Attending_Rejecting,
job_posting.Company_Name FROM Student 
inner join applied_jobs on applied_jobs.Student_Id=student.Student_Id
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id
and student.DeleteStatus =0 and  Interview_Status !=0  and  Job_Id='",Job_Id_,"'
 and applied_jobs.Student_Id  in (" , Student_Id_ , ") ");

PREPARE QUERY FROM @query;EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Schedule_Interview`(In Interview_Date_ date, Applied_Jobs_Id_ varchar(1000),Interview_Description_ varchar(2000),Interview_Schedule_User_ int,
Student_Id_ varchar(1000),Job_Id_ int,Interview_Location_ varchar(250),Interview_Time_ time)
BEGIN
declare Job_Opening_Id_ int;declare employe_status_ int;

set @query=Concat("update applied_jobs set Interview_Date='",Interview_Date_,"',Interview_Status=1,Current_Status=2,Interview_Attending_Rejecting=3,
Interview_Location ='",Interview_Location_,"',Interview_Time ='",Interview_Time_,"',Interview_Description ='",Interview_Description_,"',Interview_Schedule_User=",Interview_Schedule_User_," where Applied_Jobs_Id in (" , Applied_Jobs_Id_ , ")");

PREPARE QUERY FROM @query;EXECUTE QUERY;

set @query=Concat("update student set Interview_Count= Interview_Count+1 where Student_Id in (" , Student_Id_ , ")");

PREPARE QUERY FROM @query;EXECUTE QUERY;

set Job_Opening_Id_ =(select Job_Opening_Id from job_posting where Job_Posting_Id =Job_Id_);
set employe_status_ =(select Employee_Status_Id from job_opening where Job_Opening_Id =Job_Opening_Id_);
if(employe_status_!=6) then 
update job_opening set Employee_Status_Id=6 ,Employee_Status_Name="interview schedule" where Job_Opening_Id =Job_Opening_Id_; 
end if;

set @query=Concat("SELECT  distinct  1 as status_,  Student.Student_Id,Student.Student_Name,Device_Id,(Date_Format(Interview_Date,'%d-%m-%Y')) As Interview_Date,
Interview_Status,Interview_Description,Job_Id,job_posting.Job_Title ,Applied_Jobs_Id,Interview_Attending_Rejecting,
job_posting.Company_Name FROM Student 
inner join applied_jobs on applied_jobs.Student_Id=student.Student_Id
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id
and student.DeleteStatus =0 and  Interview_Status !=0  and  Job_Id='",Job_Id_,"'
 and applied_jobs.Student_Id  in (" , Student_Id_ , ") ");

PREPARE QUERY FROM @query;EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Self_Placed`( In Self_Placement_Id_ int,Student_Id_ int,
Company_Name_ varchar(500),Designation_ varchar(500),Placed_Date_ date,Student_Course_Id_ int)
Begin 
 if  Self_Placement_Id_>0
 THEN 
 UPDATE self_placement set Company_Name =Company_Name_,
Designation = Designation_ ,
Placed_Date =Placed_Date_ ,
Student_Course_Id =Student_Course_Id_ ,
 Student_Id =Student_Id_  Where Self_Placement_Id=Self_Placement_Id_ ;
 ELSE 
 SET Self_Placement_Id_ = (SELECT  COALESCE( MAX(Self_Placement_Id ),0)+1 FROM self_placement); 
 INSERT INTO self_placement(Self_Placement_Id ,Company_Name ,Designation,Placed_Date,Student_Course_Id,Student_Id,DeleteStatus ,Entry_Date) 
 values (Self_Placement_Id_ ,Company_Name_ ,Designation_,Placed_Date_,Student_Course_Id_,Student_Id_,false,NOW());
 End If ;
 select Self_Placement_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Settings`( In Settings_Id_ int,
Settings_Name_ varchar(100),
Settings_Group_ int)
Begin 
 if  Settings_Id_>0
 THEN 
 UPDATE Settings set Settings_Id = Settings_Id_ ,
Settings_Name = Settings_Name_ ,
Settings_Group = Settings_Group_  Where Settings_Id=Settings_Id_ ;
 ELSE 
 SET Settings_Id_ = (SELECT  COALESCE( MAX(Settings_Id ),0)+1 FROM Settings); 
 INSERT INTO Settings(Settings_Id ,
Settings_Name ,
Settings_Group ,
DeleteStatus ) values (Settings_Id_ ,
Settings_Name_ ,
Settings_Group_ ,
false);
 End If ;
 select Settings_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Specialization`( In Specialization_Id_ int,
Specialization_Name_ varchar(100),
User_Id_ int)
Begin 
 if  Specialization_Id_>0
 THEN 
 UPDATE Specialization set Specialization_Id = Specialization_Id_ ,
Specialization_Name = Specialization_Name_ ,
User_Id = User_Id_  Where Specialization_Id=Specialization_Id_ ;
 ELSE 
 SET Specialization_Id_ = (SELECT  COALESCE( MAX(Specialization_Id ),0)+1 FROM Specialization); 
 INSERT INTO Specialization(Specialization_Id ,
Specialization_Name ,
User_Id ,
DeleteStatus ) values (Specialization_Id_ ,
Specialization_Name_ ,
User_Id_ ,
false);
 End If ;
 select Specialization_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_State`( In State_Id_ int,
State_Name_ varchar(100))
Begin 
 if  State_Id_>0
 THEN 
 UPDATE State set State_Id = State_Id_ ,
State_Name = State_Name_  Where State_Id=State_Id_ ;
 ELSE 
 SET State_Id_ = (SELECT  COALESCE( MAX(State_Id ),0)+1 FROM State); 
 INSERT INTO State(State_Id ,State_Name ,DeleteStatus ) 
 values (State_Id_ ,State_Name_ ,false);
 End If ;
 select State_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_State_District`( In State_District_Id_ int,
District_Name_ varchar(100),State_Id_ int)
Begin 
 if  State_District_Id_>0
 THEN 
 UPDATE state_district set State_District_Id = State_District_Id_ ,State_Id=State_Id_,
District_Name = District_Name_  Where State_District_Id=State_District_Id_ ;
 ELSE 
 SET State_District_Id_ = (SELECT  COALESCE( MAX(State_District_Id ),0)+1 FROM state_district); 
 INSERT INTO state_district(State_District_Id ,District_Name ,State_Id,DeleteStatus ) 
 values (State_District_Id_ ,District_Name_ ,State_Id_,false);
 End If ;
 select State_District_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Status`( In Status_Id_ int,
Status_Name_ varchar(100),FollowUp_ tinyint,User_Id_ int)
Begin 
if  Status_Id_>0 THEN 
	UPDATE Status set Status_Name = Status_Name_ ,
	FollowUp=FollowUp_,User_Id = User_Id_ 
	Where Status_Id=Status_Id_ ;
    update student set StatusName = Status_Name_,Status_FollowUp =FollowUp_  where Status = Status_Id_;
    update student_followup set StatusName = Status_Name_,Status_FollowUp = FollowUp_ where Status = Status_Id_;
ELSE 
	SET Status_Id_ = (SELECT  COALESCE( MAX(Status_Id ),0)+1 FROM Status); 
	INSERT INTO Status(Status_Id ,Status_Name ,FollowUp,User_Id ,Group_Id,DeleteStatus ) 
	values (Status_Id_ ,Status_Name_ ,FollowUp_,User_Id_ ,3,false);
End If ;
	select Status_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student`(In Student_ Json,Followup_ Json,Student_Value_ int,FollowUp_Value_ int)
BEGIN
Declare Student_Id_ int;Declare Student_Name_ varchar(100); Declare Address1_ varchar(100); 
Declare Address2_ varchar(100); Declare Address3_ varchar(100); Declare Address4_ varchar(100);
Declare Pincode_ varchar(100);Declare Phone_ varchar(100); Declare Mobile_ varchar(100); 
Declare Whatsapp_ varchar(100); Declare DOB_ varchar(50);Declare Gender_ int;declare Email_ varchar(100); 
Declare Alternative_Email_ varchar(100);Declare Passport_No_ varchar(100); 
Declare Passport_Expiry_ varchar(100); Declare User_Name_ varchar(100); 
Declare Password_ varchar(100); Declare Photo_ varchar(100); Declare User_Id_ int;
Declare Registration_No_ varchar(100); Declare Role_No_ varchar(100);declare Enquiry_Source_ int;
Declare State_Id_ int;Declare District_Id_ int;Declare Course_Id_ int;Declare Qualification_Id_ int;
declare College_Name_ varchar(100);

declare Duplicate_Student_Id int;declare Agent_Id_ int;
declare Duplicate_Student_Name varchar(25); declare Duplicate_User_Name varchar(25); declare Duplicate_User_Id int;
declare Created_By_ int;declare Email_student_Id int;declare Email_Alternate_student_Id int;
declare Alternate_student_Id int;declare Whatsap_student_Id int;declare Duplicate_Email_Name varchar(50);
declare Course_Name_ varchar(100);declare Qualification_Name_ varchar(100);
declare Year_Of_Passing_ varchar(100) ;
declare Id_Proof_Id_ int ;
declare Id_Proof_Name_ varchar(100) ;
declare Id_Proof_No_ varchar(100);
declare Id_Proof_FileName_ varchar(500) ;
declare Id_Proof_File_ varchar(500);
declare Year_Of_Pass_Id_ int ;
declare Resume_Status_Id_ int ;
declare Resume_Status_Name_ varchar(100) ;
declare Enquiry_Source_Name_ varchar(100) ;
#declare Student_Owner_Id_ int;



 Declare i int default 0;

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
if( Student_Value_>0) then
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Id')) INTO Student_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Name')) INTO Student_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Address1')) INTO Address1_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Address2')) INTO Address2_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Address3')) INTO Address3_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Address4')) INTO Address4_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Pincode')) INTO Pincode_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Phone')) INTO Phone_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Mobile')) INTO Mobile_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Whatsapp')) INTO Whatsapp_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.DOB')) INTO DOB_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Gender')) INTO Gender_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Email')) INTO Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Alternative_Email')) INTO Alternative_Email_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_No')) INTO Passport_No_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Passport_Expiry')) INTO Passport_Expiry_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.User_Name')) INTO User_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Password')) INTO Password_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Photo')) INTO Photo_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.User_Id')) INTO User_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Registration_No')) INTO Registration_No_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Role_No')) INTO Role_No_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Enquiry_Source')) INTO Enquiry_Source_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Enquiry_Source_Name')) INTO Enquiry_Source_Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.State_Id')) INTO State_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.District_Id')) INTO District_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Course_Id')) INTO Course_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Qualification_Id')) INTO Qualification_Id_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Course_Name')) INTO Course_Name_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Qualification_Name')) INTO Qualification_Name_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.College_Name')) INTO College_Name_;
     SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Year_Of_Pass_Id')) INTO Year_Of_Pass_Id_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Year_Of_Passing')) INTO Year_Of_Passing_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Id_Proof_Id')) INTO Id_Proof_Id_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Id_Proof_Name')) INTO Id_Proof_Name_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Id_Proof_No')) INTO Id_Proof_No_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Id_Proof_FileName')) INTO Id_Proof_FileName_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Id_Proof_File')) INTO Id_Proof_File_;
     #SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Student_Owner_Id')) INTO Student_Owner_Id_;
    
      /*SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Resume_Status_Id')) INTO Resume_Status_Id_;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_,'$.Resume_Status_Name')) INTO Resume_Status_Name_;*/

    
    set Agent_Id_=(select Agent_Id from Users where Users_Id=User_Id_ and DeleteStatus=0);
if  Student_Id_>0 THEN
		Set Duplicate_Student_Id = (select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false and (Phone like concat('%',Phone_,'%')
		or Mobile like concat('%',Phone_,'%') or Whatsapp  like concat('%',Phone_,'%') )  limit 1);
		if Email_!="" then
			set Email_student_Id= ( select Student_Id from Student where Student_Id != Student_Id_  and DeleteStatus=false  and   ( Email like concat('%',Email_,'%') or Alternative_Email  like concat('%',Email_,'%') ) limit 1);
		end if;
		if Alternative_Email_!="" then
			set Email_Alternate_student_Id= (select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false  and   ( Alternative_Email like concat('%',Alternative_Email_,'%') or Email  like concat('%',Alternative_Email_,'%') ) limit 1);
		end if;
		if Mobile_!="" or Mobile_!=null then
			Set Alternate_student_Id = (select Student_Id from Student where  Student_Id != Student_Id_ and DeleteStatus=false  and  (Phone like concat('%',Mobile_,'%') or Mobile like concat('%',Mobile_,'%') or Whatsapp  like concat('%',Mobile_,'%')) limit 1);
		end if;
       
		if Whatsapp_!="" or Whatsapp_!=null then
		Set Whatsap_student_Id = (select Student_Id from Student where Student_Id != Student_Id_ and DeleteStatus=false  and   (Phone like concat('%',Whatsapp_,'%') or Mobile like concat('%',Whatsapp_,'%') or Whatsapp  like concat('%',Whatsapp_,'%')) limit 1);
        end if;
	if(Duplicate_Student_Id>0) then
		set Duplicate_User_Id = (select User_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
		set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Student_Id_ = -1;  
	elseif(Alternate_student_Id>0) then
		set Duplicate_User_Id = (select User_Id from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
		set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Alternate_student_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Student_Id_ = -1;  
	elseif(Whatsap_student_Id>0) then
		set Duplicate_User_Id = (select User_Id from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
		set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Student_Id_ = -3;                
	elseif(Email_student_Id>0) then
		set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false);
		set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_student_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Student_Id_ = -2;                
	elseif(Email_Alternate_student_Id>0) then
		set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
		set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Student_Id_ = -2;
	Else
		 UPDATE Student set Student_Name = Student_Name_ ,Address1 = Address1_ ,Address2 = Address2_ ,
		Address3 = Address3_ ,Address4 = Address4_ ,Pincode = Pincode_ ,Phone = Phone_ ,Mobile = Mobile_ ,
		Whatsapp = Whatsapp_ ,DOB = DOB_ ,Gender = Gender_ ,Email = Email_ ,Alternative_Email = Alternative_Email_ ,
		Passport_No = Passport_No_ ,Passport_Expiry = Passport_Expiry_ ,User_Name = User_Name_ ,
        Registration_No=Registration_No_,Role_No=Role_No_,Agent_Id=Agent_Id_,Enquiry_Source=Enquiry_Source_,
		Password = Password_ ,User_Id = User_Id_,State_Id = State_Id_ ,District_Id = District_Id_,
		Course_Id = Course_Id_ ,Qualification_Id = Qualification_Id_ , CourseName = Course_Name_, QualificationName = Qualification_Name_,
        College_Name = College_Name_,Mail_Status=1,Year_Of_Pass_Id=Year_Of_Pass_Id_,Year_Of_Passing=Year_Of_Passing_,Id_Proof_Id=Id_Proof_Id_,
        Id_Proof_Name=Id_Proof_Name_,Id_Proof_No =Id_Proof_No_,Id_Proof_FileName = Id_Proof_FileName_,Id_Proof_File=Id_Proof_File_ ,Enquiry_Source_Name=Enquiry_Source_Name_
       # Resume_Status_Id =Resume_Status_Id_,Resume_Status_Name =Resume_Status_Name_ 
        Where Student_Id=Student_Id_;        
		if Photo_!="" then
			UPDATE Student set Photo=Photo_ Where Student_Id=Student_Id_ ;
		end if;
	end if;
ELSE
		Set Duplicate_Student_Id = (select Student_Id from Student where  DeleteStatus=false and (Phone like concat('%',Phone_,'%')
		or Mobile like concat('%',Phone_,'%') or Whatsapp  like concat('%',Phone_,'%') )  limit 1);
		if Email_!="" then
			set Email_student_Id= ( select Student_Id from Student where  DeleteStatus=false and ( Email like concat('%',Email_,'%') or Alternative_Email  like concat('%',Email_,'%') ) limit 1);
        end if;
        if Alternative_Email_!="" then
			set Email_Alternate_student_Id= (select Student_Id from Student where  DeleteStatus=false and ( Alternative_Email like concat('%',Alternative_Email_,'%') or Email  like concat('%',Alternative_Email_,'%') ) limit 1);
        end if;
         if Mobile_!="" and Mobile_!=null then
			Set Alternate_student_Id = (select Student_Id from Student where  DeleteStatus=false and (Phone like concat('%',Mobile_,'%') or Mobile like concat('%',Mobile_,'%') or Whatsapp  like concat('%',Mobile_,'%')) limit 1);
		 end if;

       if Whatsapp_!="" or Whatsapp_!=null then
			Set Whatsap_student_Id = (select Student_Id from Student where  DeleteStatus=false and  (Phone like concat('%',Whatsapp_,'%') or Mobile like concat('%',Whatsapp_,'%') or Whatsapp  like concat('%',Whatsapp_,'%')) limit 1);
		end if;       
		if(Duplicate_Student_Id>0) then
			set Duplicate_User_Id = (select User_Id from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false );
			set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Duplicate_Student_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
		SET Student_Id_ = -1;  
		elseif(Alternate_student_Id>0) then
			set Duplicate_User_Id = (select User_Id from Student where Student_Id = Alternate_student_Id and DeleteStatus=false );
			set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Alternate_student_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
		SET Student_Id_ = -1;  
		/*elseif(Whatsap_student_Id>0) then
			set Duplicate_User_Id = (select User_Id from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false );
			set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
			SET Student_Id_ = -1;   */
            
		elseif(Whatsap_student_Id>0) then
		set Duplicate_User_Id = (select User_Id from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
		set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Whatsap_student_Id and DeleteStatus=false);
		set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false);
		SET Student_Id_ = -3;
        insert into data_log_ values(0,Student_Id_,Whatsap_student_Id);
		elseif(Email_student_Id>0) then
			set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_student_Id and DeleteStatus=false );
			set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_student_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
		SET Student_Id_ = -2;                
		elseif(Email_Alternate_student_Id>0) then
			set Duplicate_User_Id = (select User_Id from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false );
			set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Email_Alternate_student_Id and DeleteStatus=false );
			set Duplicate_User_Name = (select Users_Name from Users where Users_Id = Duplicate_User_Id and DeleteStatus=false );
			SET Student_Id_ = -2;
		else
		SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student);
		INSERT INTO Student(Student_Id ,Student_Name ,Entry_Date,Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,
		Phone ,Mobile ,Whatsapp ,DOB ,Gender ,Email ,Alternative_Email ,Passport_No ,Passport_Expiry ,
		User_Name ,Password ,Photo ,User_Id ,Agent_Id,Enquiry_Source,Registered_By,Registered,Registered_On,Registration_No,Role_No,
        Client_Accounts_Id,Placed,Placed_Date,Interview_Schedule,Interview_Schedule_Date,
        Resume_Send,Resume_Send_Date,Portion_Covered,Portion_Covered_Date,State_Id,District_Id,Course_Id,Qualification_Id,CourseName,QualificationName,Mail_Status,
        College_Name,DeleteStatus,Paid_Status,Student_Status,Offer,Applied,Rejected,
        Blacklist_Status,Activate_Status,Fees_Status,Interview_Count,Placement_Count,Year_Of_Pass_Id,Year_Of_Passing,Id_Proof_Id,Id_Proof_Name,Id_Proof_No,Id_Proof_FileName,Id_Proof_File,
        Resume_Status_Id,Resume_Status_Name,Enquiry_Source_Name
        )
		values (Student_Id_ ,Student_Name_ ,Curdate(),Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,
		Phone_ ,Mobile_ ,Whatsapp_ ,DOB_ ,Gender_ ,Email_ ,Alternative_Email_ ,Passport_No_ ,
		Passport_Expiry_ ,User_Name_ ,Password_ ,Photo_ ,User_Id_ ,Agent_Id_,Enquiry_Source_,0,0,curdate(),Registration_No_,Role_No_,
        0,0,curdate(),0,curdate(),0,curdate(),0,curdate(),State_Id_,District_Id_,Course_Id_,Qualification_Id_,Course_Name_,Qualification_Name_,1,College_Name_,false,0,1,0,0,0,
        0,1,0,0,0,Year_Of_Pass_Id_,Year_Of_Passing_,Id_Proof_Id_,Id_Proof_Name_,Id_Proof_No_,Id_Proof_FileName_,Id_Proof_File_,
        4,'Not Uploaded',Enquiry_Source_Name_
        );
	end if;
End If ;
else
	set Student_Id_=2;
End If ;

 if( FollowUp_Value_>0  and  Student_Id_>0) then
        #set Duplicate_Student_Name= "";
        CALL Save_Student_Followup(FollowUp_,Student_Id_);
end if;
#commit;
 select Student_Id_,Student_Name_,Phone_,Email_,Duplicate_Student_Name,Duplicate_User_Name;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student1`( In Student_Id_ int,
Student_Name_ varchar(100),Address1_ varchar(100),Address2_ varchar(100),
Address3_ varchar(100),Address4_ varchar(100),Pincode_ varchar(100),
Phone_ varchar(100),Mobile_ varchar(100),Whatsapp_ varchar(100),
DOB_ datetime,Gender_ int,Email_ varchar(100),Alternative_Email_ varchar(100),
Passport_No_ varchar(100),Passport_Expiry_ varchar(100),User_Name_ varchar(100),
Password_ varchar(100),Photo_ varchar(100),User_Id_ int)
Begin 
 if  Student_Id_>0
 THEN 
 UPDATE Student set Student_Id = Student_Id_ ,
Student_Name = Student_Name_ ,
Address1 = Address1_ ,
Address2 = Address2_ ,
Address3 = Address3_ ,
Address4 = Address4_ ,
Pincode = Pincode_ ,
Phone = Phone_ ,
Mobile = Mobile_ ,
Whatsapp = Whatsapp_ ,
DOB = DOB_ ,
Gender = Gender_ ,
Email = Email_ ,
Alternative_Email = Alternative_Email_ ,
Passport_No = Passport_No_ ,
Passport_Expiry = Passport_Expiry_ ,
User_Name = User_Name_ ,
Password = Password_ ,
Photo = Photo_ ,
User_Id = User_Id_  Where Student_Id=Student_Id_ ;
 ELSE 
 SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student); 
 INSERT INTO Student(Student_Id ,
Student_Name ,
Address1 ,
Address2 ,
Address3 ,
Address4 ,
Pincode ,
Phone ,
Mobile ,
Whatsapp ,
DOB ,
Gender ,
Email ,
Alternative_Email ,
Passport_No ,
Passport_Expiry ,
User_Name ,
Password ,
Photo ,
User_Id ,
DeleteStatus ) values (Student_Id_ ,
Student_Name_ ,
Address1_ ,
Address2_ ,
Address3_ ,
Address4_ ,
Pincode_ ,
Phone_ ,
Mobile_ ,
Whatsapp_ ,
DOB_ ,
Gender_ ,
Email_ ,
Alternative_Email_ ,
Passport_No_ ,
Passport_Expiry_ ,
User_Name_ ,
Password_ ,
Photo_ ,
User_Id_ ,
false);
 End If ;
 select Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Course`( In Student_Course_Id_ int,
Student_Id_ int,Entry_Date_ datetime,Course_Name_Details_ varchar(100),Course_Id_ int,Course_Name_ varchar(1000),
Start_Date_ datetime,End_Date_ datetime,Join_Date_ datetime,By_User_Id_ int,Status_ int,
Course_Type_Id_ int,Course_Type_Name_ varchar(100),Agent_Amount_ Decimal(18,2),Total_Fees_ decimal(18,2),
Batch_Id_ int,Batch_Name_ varchar(100),Faculty_Id_ int,Installment_Type_Id_ int,No_Of_Installment_ int,
Duration_ int,Laptop_details_Id_ int,Laptop_details_Name_ varchar(500),
Student_Course_Subject json,Student_Fees_Installment_Save json,Start_Time_ time, End_Time_ time,Student_Course_Subject_Value_ int)
Begin 
Declare Subject_Id_ int;Declare Subject_Name_ varchar(1000);Declare Minimum_Mark_ varchar(100);declare Part_Id_ int;
Declare Maximum_Mark_ varchar(100);Declare Online_Exam_Status_ varchar(100);Declare Obtained_Mark_ varchar(100);
Declare No_of_Question_ varchar(100);Declare Exam_Duration_ varchar(100);Declare Exam_Attended_Status_ varchar(100);

declare Course_Fees_Id_ int;declare Fees_Type_Id_ int;declare Instalment_Date_ Datetime;declare Amount_ decimal(18,2);
declare Fees_Type_Name_ varchar(100);declare No_Of_Instalment_ int;declare Instalment_Period_ int;
declare Fees_Amount_ decimal(18,2);declare Tax_ decimal(18,2);declare Tax_Percentage_ decimal(18,2);
declare Student_Fees_Installment_Master_Id_ int;declare Student_Fees_Installment_Master_Id_Old_ int;declare Student_Fees_Installment_Master_Id_Temp_ int;
declare new_balance decimal(18,2) default 0;
declare feesreceipt decimal(18,2) default 0;
declare feesstatus int default 0;

declare Batch_Start_Date_ datetime(6) ;declare Batch_Branch_Id_ int;
declare Batch_End_Date_ datetime(6) ;
declare Batch_Start_Time_ time ;
declare Batch_End_Time_ time;

declare Task_ longtext;
declare Day_ varchar(45);
declare Heading_ text;

DECLARE i int  DEFAULT 0;DECLARE j int  DEFAULT 0;

Declare Phone_ varchar(50);Declare Email_ varchar(100);Declare Student_Name_ varchar(100);
  /* DECLARE exit handler for sqlexception
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
    
     insert into data_log_ values (0,Student_Course_Subject,'xx');
     
set Batch_Start_Date_ =(select Start_Date from batch where Batch_Id=Batch_Id_) ;
set Batch_End_Date_ = (select End_Date from batch where Batch_Id=Batch_Id_);
set Batch_Start_Time_ =(select Batch_Start_Time from batch where Batch_Id=Batch_Id_) ;
set Batch_End_Time_ =(select Batch_End_Time from batch where Batch_Id=Batch_Id_);
 set Batch_Branch_Id_ =(select Branch_Id from batch where Batch_Id=Batch_Id_);
 
set Phone_ =(select Phone from Student where Student_Id=Student_Id_ and DeleteStatus=0);
set Email_ =(select Email from Student where Student_Id=Student_Id_ and DeleteStatus=0);
set Student_Name_ =(select Student_Name from Student where Student_Id=Student_Id_ and DeleteStatus=0);
#set Fees_Type_Id_=1;
set No_Of_Instalment_=1;
set Instalment_Period_=1;
set Tax_=1;
if  Student_Course_Id_>0 THEN 
		 delete from student_fees_installment_details where Student_Fees_Installment_Master_Id in (select Student_Fees_Installment_Master_Id from Student_Fees_Installment_Master where Student_Id=Student_Id_);              
        delete from Student_Fees_Installment_Master where Student_Id=Student_Id_ and Student_Course_Id = Student_Course_Id_ ; 
         delete from student_course_subject where Student_Id=Student_Id_ ; 
	UPDATE Student_Course set Student_Id = Student_Id_ ,Entry_Date = Entry_Date_ ,Join_Date = Join_Date_ ,
	Course_Name_Details = Course_Name_Details_ ,Course_Id = Course_Id_ ,Course_Name = Course_Name_ ,
	Start_Date = Start_Date_ ,End_Date = End_Date_ ,By_User_Id = By_User_Id_ ,
	Status = Status_,Course_Type_Id=Course_Type_Id_,Course_Type_Name=Course_Type_Name_,Agent_Amount=Agent_Amount_,
	Total_Fees=Total_Fees_,Batch_Id=Batch_Id_,Batch_Name=Batch_Name_ ,Faculty_Id=Faculty_Id_,
    Installment_Type_Id=Installment_Type_Id_,Duration=Duration_,No_Of_Installment=No_Of_Installment_,
    Laptop_details_Id=Laptop_details_Id_,Laptop_details_Name=Laptop_details_Name_,Start_Time=Start_Time_,
    End_Time=End_Time_,
    Batch_Start_Date=Batch_Start_Date_,Batch_End_Date=Batch_End_Date_,Batch_Start_Time=Batch_Start_Time_,Batch_End_Time=Batch_End_Time_,Batch_Branch_Id=Batch_Branch_Id_
    Where Student_Course_Id=Student_Course_Id_ ;
    set feesreceipt =(select COALESCE(sum(Amount),0) from receipt_voucher where Student_Course_Id=Student_Course_Id_ and DeleteStatus=0);
ELSE 
 SET Student_Course_Id_ = (SELECT  COALESCE( MAX(Student_Course_Id ),0)+1 FROM Student_Course); 
	INSERT INTO Student_Course(Student_Course_Id ,Student_Id ,Entry_Date ,Course_Name_Details ,Course_Id ,Course_Name ,
	Start_Date ,End_Date ,Join_Date ,By_User_Id ,Status ,Course_Type_Id,Course_Type_Name,Agent_Amount,
    Total_Fees,Batch_Id,Batch_Name,Faculty_Id,Fee_Paid,Installment_Type_Id,No_Of_Installment,Duration,DeleteStatus,
    Laptop_details_Id,Laptop_details_Name,Start_Time,End_Time,
    Batch_Start_Date,Batch_End_Date,Batch_Start_Time,Batch_End_Time,Batch_Branch_Id) 
	values (Student_Course_Id_ ,Student_Id_,now(),Course_Name_Details_ ,Course_Id_ ,Course_Name_ ,Start_Date_ ,
	End_Date_ ,Join_Date_ ,By_User_Id_ ,Status_ ,Course_Type_Id_ ,Course_Type_Name_ ,Agent_Amount_,Total_Fees_,
    Batch_Id_,Batch_Name_,Faculty_Id_,0,Installment_Type_Id_,1,Duration_,false,
     Laptop_details_Id_,Laptop_details_Name_,Start_Time_,End_Time_,
     Batch_Start_Date_,Batch_End_Date_,Batch_Start_Time_,Batch_End_Time_,Batch_Branch_Id_);
 End If ;
 
 insert into data_log_ values (0,Student_Course_Subject_Value_,'dsf');
if Student_Course_Id_>0 then
if Student_Course_Subject_Value_>0 then
	WHILE i < JSON_LENGTH(Student_Course_Subject) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Subject_Id'))) INTO Subject_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Subject_Name'))) INTO Subject_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Part_Id'))) INTO Part_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Minimum_Mark'))) INTO Minimum_Mark_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Maximum_Mark'))) INTO Maximum_Mark_;	
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Online_Exam_Status'))) INTO Online_Exam_Status_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].No_of_Question'))) INTO No_of_Question_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Exam_Duration'))) INTO Exam_Duration_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Exam_Attended_Status'))) INTO Exam_Attended_Status_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Obtained_Mark'))) INTO Obtained_Mark_;
        
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Task'))) INTO Task_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Day'))) INTO Day_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Heading'))) INTO Heading_;

		INSERT INTO Student_Course_Subject(Student_Id ,Course_Id ,Course_Name ,Subject_Id ,Subject_Name ,Part_Id,Minimum_Mark ,
		Maximum_Mark ,Online_Exam_Status ,No_of_Question ,Exam_Duration ,Exam_Attended_Status ,Obtained_Mark,Student_Course_Id,DeleteStatus, Task,Day,Heading )
		values (Student_Id_ ,Course_Id_ ,Course_Name_ ,Subject_Id_ ,Subject_Name_ ,Part_Id_,Minimum_Mark_ ,
		Maximum_Mark_ ,Online_Exam_Status_ ,No_of_Question_ ,Exam_Duration_ ,0 ,Obtained_Mark_,Student_Course_Id_,false,Task_,Day_,Heading_);
		SELECT i + 1 INTO i;
	END WHILE;
   end if;
		set Student_Fees_Installment_Master_Id_Old_=-2;
        
        Delete from Student_Fees_Installment_Master where Student_Course_Id=Student_Course_Id_;
        
        SET Student_Fees_Installment_Master_Id_ = (SELECT  COALESCE( MAX(Student_Fees_Installment_Master_Id ),0)+1 FROM Student_Fees_Installment_Master); 
				INSERT INTO Student_Fees_Installment_Master(Student_Fees_Installment_Master_Id,Student_Id,Student_Course_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,Fees_Type_Name,
							Amount,No_Of_Instalment,Instalment_Period,Tax,DeleteStatus) 
				values (Student_Fees_Installment_Master_Id_,Student_Id_,Student_Course_Id_,Course_Fees_Id_,Course_Id_,Fees_Type_Id_,Fees_Type_Name_,
							Amount_,No_Of_Instalment_,Instalment_Period_,Tax_,false);
        
        
		WHILE j < JSON_LENGTH(Student_Fees_Installment_Save) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Student_Fees_Installment_Master_Id'))) INTO Student_Fees_Installment_Master_Id_Temp_;  
		if Student_Fees_Installment_Master_Id_Old_ <>Student_Fees_Installment_Master_Id_Temp_  then
          	if  Student_Fees_Installment_Master_Id_Temp_>=0 then 
				
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Course_Fees_Id'))) INTO Course_Fees_Id_;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Type_Id'))) INTO Fees_Type_Id_;
                
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Type_Name'))) INTO Fees_Type_Name_;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Amount'))) INTO Amount_;
                
                
				#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].No_Of_Instalment'))) INTO No_Of_Instalment_;
				#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Instalment_Period'))) INTO Instalment_Period_;
				#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Tax'))) INTO Tax_;
				#SET Student_Fees_Installment_Master_Id_ = (SELECT  COALESCE( MAX(Student_Fees_Installment_Master_Id ),0)+1 FROM Student_Fees_Installment_Master); 
				#INSERT INTO Student_Fees_Installment_Master(Student_Fees_Installment_Master_Id,Student_Id,Student_Course_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,Fees_Type_Name,
				#			Amount,No_Of_Instalment,Instalment_Period,Tax,DeleteStatus) 
				#values (Student_Fees_Installment_Master_Id_,Student_Id_,Student_Course_Id_,Course_Fees_Id_,Course_Id_,Fees_Type_Id_,Fees_Type_Name_,
				#			Amount_,No_Of_Instalment_,Instalment_Period_,Tax_,false);
		    end if;
            else 
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Instalment_Date'))) INTO Instalment_Date_;             
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Amount'))) INTO Fees_Amount_;      
               
                if(feesreceipt>=Fees_Amount_) then
					set feesstatus=1;
                    set feesreceipt=feesreceipt-Fees_Amount_;
                    set new_balance=0;
				else
					set feesstatus=0;
                    set new_balance=Fees_Amount_-feesreceipt;
                    set feesreceipt=0;
                end if;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Tax_Percentage'))) INTO Tax_Percentage_;
				INSERT INTO student_fees_installment_details(Student_Fees_Installment_Master_Id,Instalment_Date,Fees_Amount,Status,Tax_Percentage,Balance_Amount,DeleteStatus) 
				values (Student_Fees_Installment_Master_Id_,Instalment_Date_,Fees_Amount_,feesstatus,Tax_Percentage_, new_balance,false); 
		end if;
		set  Student_Fees_Installment_Master_Id_Old_ = Student_Fees_Installment_Master_Id_Temp_;
		SELECT j + 1 INTO j;
	END WHILE; 
end if;
if not exists(select Course_Id,Batch_Id from course_batch where  DeleteStatus=False and Course_Id =Course_Id_ and   Batch_Id = Batch_Id_)
then
insert into course_batch(Course_Id,Batch_Id,DeleteStatus) values(Course_Id_,Batch_Id_,0);
end if;
 select Student_Course_Id_,Course_Name_,Phone_,Email_,Student_Name_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Course_orginal`( In Student_Course_Id_ int,
Student_Id_ int,Entry_Date_ datetime,Course_Name_Details_ varchar(100),Course_Id_ int,Course_Name_ varchar(1000),
Start_Date_ datetime,End_Date_ datetime,Join_Date_ datetime,By_User_Id_ int,Status_ int,
Course_Type_Id_ int,Course_Type_Name_ varchar(100),Agent_Amount_ Decimal(18,2),Total_Fees_ decimal(18,2),
Batch_Id_ int,Batch_Name_ varchar(100),Faculty_Id_ int,Installment_Type_Id_ int,No_Of_Installment_ int,
Duration_ int,Laptop_details_Id_ int,Laptop_details_Name_ varchar(500),
Student_Course_Subject json,Student_Fees_Installment_Save json,Start_Time_ time, End_Time_ time)
Begin 
Declare Subject_Id_ int;Declare Subject_Name_ varchar(1000);Declare Minimum_Mark_ varchar(100);declare Part_Id_ int;
Declare Maximum_Mark_ varchar(100);Declare Online_Exam_Status_ varchar(100);Declare Obtained_Mark_ varchar(100);
Declare No_of_Question_ varchar(100);Declare Exam_Duration_ varchar(100);Declare Exam_Attended_Status_ varchar(100);

declare Course_Fees_Id_ int;declare Fees_Type_Id_ int;declare Instalment_Date_ Datetime;declare Amount_ decimal(18,2);
declare Fees_Type_Name_ varchar(100);declare No_Of_Instalment_ int;declare Instalment_Period_ int;
declare Fees_Amount_ decimal(18,2);declare Tax_ decimal(18,2);declare Tax_Percentage_ decimal(18,2);
declare Student_Fees_Installment_Master_Id_ int;declare Student_Fees_Installment_Master_Id_Old_ int;declare Student_Fees_Installment_Master_Id_Temp_ int;
declare new_balance decimal(18,2) default 0;
declare feesreceipt decimal(18,2) default 0;
declare feesstatus int default 0;

declare Batch_Start_Date_ datetime(6) ;declare Batch_Branch_Id_ int;
declare Batch_End_Date_ datetime(6) ;
declare Batch_Start_Time_ time ;
declare Batch_End_Time_ time;

declare Task_ longtext;
declare Day_ varchar(45);
declare Heading_ text;

DECLARE i int  DEFAULT 0;DECLARE j int  DEFAULT 0;

Declare Phone_ varchar(50);Declare Email_ varchar(100);Declare Student_Name_ varchar(100);
  /* DECLARE exit handler for sqlexception
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
    
set Batch_Start_Date_ =(select Start_Date from batch where Batch_Id=Batch_Id_) ;
set Batch_End_Date_ = (select End_Date from batch where Batch_Id=Batch_Id_);
set Batch_Start_Time_ =(select Batch_Start_Time from batch where Batch_Id=Batch_Id_) ;
set Batch_End_Time_ =(select Batch_End_Time from batch where Batch_Id=Batch_Id_);
 set Batch_Branch_Id_ =(select Branch_Id from batch where Batch_Id=Batch_Id_);
 
set Phone_ =(select Phone from Student where Student_Id=Student_Id_ and DeleteStatus=0);
set Email_ =(select Email from Student where Student_Id=Student_Id_ and DeleteStatus=0);
set Student_Name_ =(select Student_Name from Student where Student_Id=Student_Id_ and DeleteStatus=0);
#set Fees_Type_Id_=1;
set No_Of_Instalment_=1;
set Instalment_Period_=1;
set Tax_=1;
if  Student_Course_Id_>0 THEN 
		 delete from student_fees_installment_details where Student_Fees_Installment_Master_Id in (select Student_Fees_Installment_Master_Id from Student_Fees_Installment_Master where Student_Id=Student_Id_);              
        delete from Student_Fees_Installment_Master where Student_Id=Student_Id_ and Student_Course_Id = Student_Course_Id_ ; 
         delete from student_course_subject where Student_Id=Student_Id_ ; 
	UPDATE Student_Course set Student_Id = Student_Id_ ,Entry_Date = Entry_Date_ ,Join_Date = Join_Date_ ,
	Course_Name_Details = Course_Name_Details_ ,Course_Id = Course_Id_ ,Course_Name = Course_Name_ ,
	Start_Date = Start_Date_ ,End_Date = End_Date_ ,By_User_Id = By_User_Id_ ,
	Status = Status_,Course_Type_Id=Course_Type_Id_,Course_Type_Name=Course_Type_Name_,Agent_Amount=Agent_Amount_,
	Total_Fees=Total_Fees_,Batch_Id=Batch_Id_,Batch_Name=Batch_Name_ ,Faculty_Id=Faculty_Id_,
    Installment_Type_Id=Installment_Type_Id_,Duration=Duration_,No_Of_Installment=No_Of_Installment_,
    Laptop_details_Id=Laptop_details_Id_,Laptop_details_Name=Laptop_details_Name_,Start_Time=Start_Time_,
    End_Time=End_Time_,
    Batch_Start_Date=Batch_Start_Date_,Batch_End_Date=Batch_End_Date_,Batch_Start_Time=Batch_Start_Time_,Batch_End_Time=Batch_End_Time_,Batch_Branch_Id=Batch_Branch_Id_
    Where Student_Course_Id=Student_Course_Id_ ;
    set feesreceipt =(select COALESCE(sum(Amount),0) from receipt_voucher where Student_Course_Id=Student_Course_Id_ and DeleteStatus=0);
ELSE 
 SET Student_Course_Id_ = (SELECT  COALESCE( MAX(Student_Course_Id ),0)+1 FROM Student_Course); 
	INSERT INTO Student_Course(Student_Course_Id ,Student_Id ,Entry_Date ,Course_Name_Details ,Course_Id ,Course_Name ,
	Start_Date ,End_Date ,Join_Date ,By_User_Id ,Status ,Course_Type_Id,Course_Type_Name,Agent_Amount,
    Total_Fees,Batch_Id,Batch_Name,Faculty_Id,Fee_Paid,Installment_Type_Id,No_Of_Installment,Duration,DeleteStatus,
    Laptop_details_Id,Laptop_details_Name,Start_Time,End_Time,
    Batch_Start_Date,Batch_End_Date,Batch_Start_Time,Batch_End_Time,Batch_Branch_Id) 
	values (Student_Course_Id_ ,Student_Id_,now(),Course_Name_Details_ ,Course_Id_ ,Course_Name_ ,Start_Date_ ,
	End_Date_ ,Join_Date_ ,By_User_Id_ ,Status_ ,Course_Type_Id_ ,Course_Type_Name_ ,Agent_Amount_,Total_Fees_,
    Batch_Id_,Batch_Name_,Faculty_Id_,0,Installment_Type_Id_,1,Duration_,false,
     Laptop_details_Id_,Laptop_details_Name_,Start_Time_,End_Time_,
     Batch_Start_Date_,Batch_End_Date_,Batch_Start_Time_,Batch_End_Time_,Batch_Branch_Id_);
 End If ;
if Student_Course_Id_>0 then
	WHILE i < JSON_LENGTH(Student_Course_Subject) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Subject_Id'))) INTO Subject_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Subject_Name'))) INTO Subject_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Part_Id'))) INTO Part_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Minimum_Mark'))) INTO Minimum_Mark_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Maximum_Mark'))) INTO Maximum_Mark_;	
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Online_Exam_Status'))) INTO Online_Exam_Status_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].No_of_Question'))) INTO No_of_Question_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Exam_Duration'))) INTO Exam_Duration_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Exam_Attended_Status'))) INTO Exam_Attended_Status_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Obtained_Mark'))) INTO Obtained_Mark_;
        
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Task'))) INTO Task_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Day'))) INTO Day_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Course_Subject,CONCAT('$[',i,'].Heading'))) INTO Heading_;

		INSERT INTO Student_Course_Subject(Student_Id ,Course_Id ,Course_Name ,Subject_Id ,Subject_Name ,Part_Id,Minimum_Mark ,
		Maximum_Mark ,Online_Exam_Status ,No_of_Question ,Exam_Duration ,Exam_Attended_Status ,Obtained_Mark,Student_Course_Id,DeleteStatus, Task,Day,Heading )
		values (Student_Id_ ,Course_Id_ ,Course_Name_ ,Subject_Id_ ,Subject_Name_ ,Part_Id_,Minimum_Mark_ ,
		Maximum_Mark_ ,Online_Exam_Status_ ,No_of_Question_ ,Exam_Duration_ ,0 ,Obtained_Mark_,Student_Course_Id_,false,Task_,Day_,Heading_);
		SELECT i + 1 INTO i;
	END WHILE;
		set Student_Fees_Installment_Master_Id_Old_=-2;
        
        Delete from Student_Fees_Installment_Master where Student_Course_Id=Student_Course_Id_;
        
        SET Student_Fees_Installment_Master_Id_ = (SELECT  COALESCE( MAX(Student_Fees_Installment_Master_Id ),0)+1 FROM Student_Fees_Installment_Master); 
				INSERT INTO Student_Fees_Installment_Master(Student_Fees_Installment_Master_Id,Student_Id,Student_Course_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,Fees_Type_Name,
							Amount,No_Of_Instalment,Instalment_Period,Tax,DeleteStatus) 
				values (Student_Fees_Installment_Master_Id_,Student_Id_,Student_Course_Id_,Course_Fees_Id_,Course_Id_,Fees_Type_Id_,Fees_Type_Name_,
							Amount_,No_Of_Instalment_,Instalment_Period_,Tax_,false);
        
        
		WHILE j < JSON_LENGTH(Student_Fees_Installment_Save) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Student_Fees_Installment_Master_Id'))) INTO Student_Fees_Installment_Master_Id_Temp_;  
		if Student_Fees_Installment_Master_Id_Old_ <>Student_Fees_Installment_Master_Id_Temp_  then
          	if  Student_Fees_Installment_Master_Id_Temp_>=0 then 
				
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Course_Fees_Id'))) INTO Course_Fees_Id_;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Type_Id'))) INTO Fees_Type_Id_;
                
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Type_Name'))) INTO Fees_Type_Name_;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Amount'))) INTO Amount_;
                
                
				#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].No_Of_Instalment'))) INTO No_Of_Instalment_;
				#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Instalment_Period'))) INTO Instalment_Period_;
				#SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Tax'))) INTO Tax_;
				#SET Student_Fees_Installment_Master_Id_ = (SELECT  COALESCE( MAX(Student_Fees_Installment_Master_Id ),0)+1 FROM Student_Fees_Installment_Master); 
				#INSERT INTO Student_Fees_Installment_Master(Student_Fees_Installment_Master_Id,Student_Id,Student_Course_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,Fees_Type_Name,
				#			Amount,No_Of_Instalment,Instalment_Period,Tax,DeleteStatus) 
				#values (Student_Fees_Installment_Master_Id_,Student_Id_,Student_Course_Id_,Course_Fees_Id_,Course_Id_,Fees_Type_Id_,Fees_Type_Name_,
				#			Amount_,No_Of_Instalment_,Instalment_Period_,Tax_,false);
		    end if;
            else 
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Instalment_Date'))) INTO Instalment_Date_;             
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Fees_Amount'))) INTO Fees_Amount_;      
               
                if(feesreceipt>=Fees_Amount_) then
					set feesstatus=1;
                    set feesreceipt=feesreceipt-Fees_Amount_;
                    set new_balance=0;
				else
					set feesstatus=0;
                    set new_balance=Fees_Amount_-feesreceipt;
                    set feesreceipt=0;
                end if;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Fees_Installment_Save,CONCAT('$[',j,'].Tax_Percentage'))) INTO Tax_Percentage_;
				INSERT INTO student_fees_installment_details(Student_Fees_Installment_Master_Id,Instalment_Date,Fees_Amount,Status,Tax_Percentage,Balance_Amount,DeleteStatus) 
				values (Student_Fees_Installment_Master_Id_,Instalment_Date_,Fees_Amount_,feesstatus,Tax_Percentage_, new_balance,false); 
		end if;
		set  Student_Fees_Installment_Master_Id_Old_ = Student_Fees_Installment_Master_Id_Temp_;
		SELECT j + 1 INTO j;
	END WHILE; 
end if;
if not exists(select Course_Id,Batch_Id from course_batch where  DeleteStatus=False and Course_Id =Course_Id_ and   Batch_Id = Batch_Id_)
then
insert into course_batch(Course_Id,Batch_Id,DeleteStatus) values(Course_Id_,Batch_Id_,0);
end if;
 select Student_Course_Id_,Course_Name_,Phone_,Email_,Student_Name_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Course_Subject`( In Student_Course_Subject_Id_ int,
Student_Id_ int,
Course_Id_ int,
Course_Name_ varchar(1000),
Subject_Id_ int,
Subject_Name_ varchar(1000),
Minimum_Mark_ varchar(100),
Maximum_Mark_ varchar(100),
Online_Exam_Statusuu7ytrefsertytrewertrfs_ varchar(100),
No_of_Question_ varchar(100),
Exam_Duration_ varchar(100),
Exam_Attended_Status_ varchar(100))
Begin 
 if  Student_Course_Subject_Id_>0
 THEN 
 UPDATE Student_Course_Subject set Student_Course_Subject_Id = Student_Course_Subject_Id_ ,
Student_Id = Student_Id_ ,
Course_Id = Course_Id_ ,
Course_Name = Course_Name_ ,
Subject_Id = Subject_Id_ ,
Subject_Name = Subject_Name_ ,
Minimum_Mark = Minimum_Mark_ ,
Maximum_Mark = Maximum_Mark_ ,
Online_Exam_Statusuu7ytrefsertytrewertrfs = Online_Exam_Statusuu7ytrefsertytrewertrfs_ ,
No_of_Question = No_of_Question_ ,
Exam_Duration = Exam_Duration_ ,
Exam_Attended_Status = Exam_Attended_Status_  Where Student_Course_Subject_Id=Student_Course_Subject_Id_ ;
 ELSE 
 SET Student_Course_Subject_Id_ = (SELECT  COALESCE( MAX(Student_Course_Subject_Id ),0)+1 FROM Student_Course_Subject); 
 INSERT INTO Student_Course_Subject(Student_Course_Subject_Id ,
Student_Id ,
Course_Id ,
Course_Name ,
Subject_Id ,
Subject_Name ,
Minimum_Mark ,
Maximum_Mark ,
Online_Exam_Statusuu7ytrefsertytrewertrfs ,
No_of_Question ,
Exam_Duration ,
Exam_Attended_Status ,
DeleteStatus ) values (Student_Course_Subject_Id_ ,
Student_Id_ ,
Course_Id_ ,
Course_Name_ ,
Subject_Id_ ,
Subject_Name_ ,
Minimum_Mark_ ,
Maximum_Mark_ ,
Online_Exam_Statusuu7ytrefsertytrewertrfs_ ,
No_of_Question_ ,
Exam_Duration_ ,
Exam_Attended_Status_ ,
false);
 End If ;
 select Student_Course_Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Data_FollowUp`( In Student_Selected_Details_ json,By_User_Id_ int,
Branch_ int,User_Id_ int,Branch_Name_ varchar(50),User_Name_ varchar(50),By_User_Name_ varchar(50),Full_Transfer_Value_ int)
Begin
Declare i int;DECLARE Student_Id_ int;declare x int default 0;declare Created_User_Id_ int;
declare Student_FollowUp_Id_ int;declare Remark_Id_ int;declare Status_ int ;
declare Next_FollowUp_Date_ datetime ;declare Remark_  varchar(100);
declare import_master_id int default 0;declare Role_Id_ int;
declare Master_Id_ int;declare Department_Status_Name_ varchar(50);
#declare Department_Name_ varchar(50);
#declare Department_ int;

Set i=0;
WHILE i < JSON_LENGTH(Student_Selected_Details_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Selected_Details_,CONCAT('$[',i,'].Student_Id'))) INTO Student_Id_;

set Status_ = (Select Status from student where Student_Id = Student_Id_);
#set Department_Status_Name_ = (Select Department_Status_Name from student where Student_Id = Student_Id_);
set Next_FollowUp_Date_ = (Select Next_FollowUp_date from student where Student_Id = Student_Id_);
#set Role_Id_ = (Select Role_Id from user_details where User_Details_Id = User_Id_);
#insert into data_log_ value(0,Department_,Department_Name_);

INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference ,Status ,
By_User_Id ,To_User_Id,Remark,Remark_Id ,FollowUp_Type,FollowUP_Time,Actual_FollowUp_Date,DeleteStatus)
values (Student_Id_ ,Now(),Next_FollowUp_Date_,0 ,Status_ ,By_User_Id_ ,User_Id_,Remark_,Remark_Id_,0,0,now(),0);
set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());

if Full_Transfer_Value_>0 then SET Created_User_Id_ = User_Id_;
else SET Created_User_Id_ = (select User_Id from student where Student_Id=Student_Id_);
end if;
#insert into data_log_ values(0,Created_User_Id_,'');
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Status = Status_ ,
To_User_Id = User_Id_ ,By_User_Id=By_User_Id_,Next_FollowUp_Date = Next_FollowUp_Date_ ,Remark_Id=Remark_Id_,
Agent_Id=Branch_,User_Id=Created_User_Id_,ToUserName =User_Name_,ByUserName=By_User_Name_ where student.Student_Id=Student_Id_;
#insert into data_log_ values(0,Created_User_Id_,User_Id_);
SELECT i + 1 INTO i;      
END WHILE;
set import_master_id=1;
select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Followup`(In FollowUp_ JSON,Student_Id_ int)
Begin 
Declare Student_Followup_Id_ int;Declare Entry_Date_ datetime;
Declare Next_FollowUp_Date_ datetime;declare FollowUp_Difference_ int;
Declare Status_ int;Declare By_User_Id_ int;Declare Remark_ varchar(4000);
Declare Remark_Id_ int;Declare FollowUp_Type_ int;Declare FollowUP_Time_ varchar(100);
Declare Actual_FollowUp_Date_ datetime;declare Student_Id_J int;declare To_User_Id_ int;
Declare Previous_Followup_Id int;
declare Duplicate_Student_Name varchar(25); declare Duplicate_User_Name varchar(25);
declare Student_Name_ varchar(25); declare Phone_ varchar(25);declare Email_ varchar(100);
declare Status_Name_ varchar(50);declare To_User_Name_ varchar(50);declare By_User_Name_ varchar(50);declare Status_FollowUp_ int;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Student_Id')) INTO Student_Id_J;   
	if( Student_Id_J>0 )
		then set Student_Id_=Student_Id_J;
	end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Next_FollowUp_Date')) INTO Next_FollowUp_Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Status')) INTO Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.By_User_Id')) INTO By_User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.To_User_Id')) INTO To_User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Remark')) INTO Remark_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.Status_Name')) INTO Status_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.To_User_Name')) INTO To_User_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.By_User_Name')) INTO By_User_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(FollowUp_,'$.FollowUp')) INTO Status_FollowUp_;

 INSERT INTO Student_Followup(Student_Followup_Id ,Student_Id ,Entry_Date ,Next_FollowUp_Date ,FollowUp_Difference ,Status ,By_User_Id ,To_User_Id,Remark ,
 Remark_Id ,FollowUp_Type ,FollowUP_Time ,Actual_FollowUp_Date ,StatusName,ToUserName,ByUserName,Status_FollowUp,DeleteStatus ) 
values (Student_Followup_Id_ ,Student_Id_ ,now() ,Next_FollowUp_Date_ ,0 ,
Status_ ,By_User_Id_ ,To_User_Id_,Remark_ ,0 ,1 ,'' ,now() ,Status_Name_,To_User_Name_,By_User_Name_,Status_FollowUp_,false);
set Student_Followup_Id_ =(SELECT LAST_INSERT_ID());

set Previous_Followup_Id= (select COALESCE( Student_Followup_Id ,0)  from student where Student_Id=Student_Id_);
if(Previous_Followup_Id>0) then
	update Student_Followup set Actual_FollowUp_Date=now() where Student_Followup_Id=Previous_Followup_Id;
end if;

update Student set Student_Followup_Id=Student_Followup_Id_,Next_FollowUp_Date=Next_FollowUp_Date_,
FollowUp_Difference=0,Status=Status_,By_User_Id=By_User_Id_,To_User_Id=To_User_Id_,Remark=Remark_,Remark_Id=0,
FollowUp_Type=1,FollowUP_Time='',Actual_FollowUp_Date=now(),StatusName = Status_Name_,User_Id = To_User_Id_,
ToUserName = To_User_Name_,ByUserName = By_User_Name_,Status_FollowUp = Status_FollowUp_,Mail_Status=1,Student_Owner_Id=To_User_Id_
  where Student_Id=Student_Id_;

if(Status_=18) then
update Student set DropOut_Date=now()   where Student_Id=Student_Id_;
end if;
 #select Student_Id_,Student_Name_,Phone_,Email_,Duplicate_Student_Name,Duplicate_User_Name;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Import`( In Student_Details json,By_User_Id_ int,Status_ int,To_User_ int,
Enquiry_Source_ int,Next_FollowUp_Date_ date,Status_Name_ varchar(100),Enquiry_Source_Name_ varchar(100),To_User_Name_ varchar(100),By_User_Name_ varchar(100),Status_FollowUp_ int,Remark_ varchar(100))
BEGIN
Declare i int;DECLARE Student_Id_ int;
declare Name_ varchar(100);declare Email_ varchar(100);declare Phone_ varchar(15);declare Whatsapp_ varchar(100);
declare Address1_ varchar(200);declare Last_Name_ varchar(100);declare Address2_ varchar(100);declare Pincode_ varchar(100);
declare Alternative_Email_ varchar(100);declare Alternative_Phone_ varchar(100);declare Facebook_ varchar(100);
declare Duplicate_Student_Id int;declare Duplicate_Student_Name varchar(100); declare Student_FollowUp_Id_ int;
declare Duplicate_ varchar(25); declare Duplicate_User_Id int; declare import_master_id int default 0;
declare Master_Id_ int;declare Qualification_Name_ varchar(100);declare Qualification_Id_ int;
declare Student_Remark_ varchar(45);declare Department_Name_ varchar(100);
declare Location_Name_ varchar(100);declare Location_Id_ int;declare College_Name_ varchar(100);
declare Dept_FollowUp_ int;declare Branch_Name_ varchar(100);declare Department_Status_Name_ varchar(100);
declare Role_Id_ int;declare By__ varchar(100);declare Enquiry_Source_Name_ varchar(100); declare Duplicate_User_Name varchar(100);
Set i=0;
delete from Duplicate_Students;
#insert into import_master(Import_Master_Id,Entry_Date)values(Import_Master_Id_,now());
 SET Master_Id_ = (SELECT  COALESCE( MAX(Master_Id ),0)+1 FROM import_students_master);
 insert into import_students_master values(Master_Id_,By_User_Id_,Next_FollowUp_Date_);
WHILE i < JSON_LENGTH(Student_Details) DO
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Name'))) INTO Name_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Mobile'))) INTO Phone_ ;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Address'))) INTO Address1_ ;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Remarks'))) INTO Student_Remark_ ;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Whatsapp'))) INTO Whatsapp_ ;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Email'))) INTO Email_ ;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Qualification'))) INTO Qualification_Name_ ;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].Location'))) INTO Location_Name_ ;
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Student_Details,CONCAT('$[',i,'].College_Name'))) INTO College_Name_ ;
    
	set Qualification_Name_ = replace(replace(Qualification_Name_,' ',''),' ','');
	set Location_Name_ = replace(replace(Location_Name_,' ',''),' ','');
    
    set Qualification_Id_ =(select COALESCE( MAX(Qualification_Id ),0)  from qualification where Qualification_Name=Qualification_Name_ and DeleteStatus=0 );
    if(Qualification_Id_ =0)
    then
	SET Qualification_Id_ = 26;
    set Qualification_Name_ = 'Others';
	end if; 
    
    set Location_Id_ =(select COALESCE( MAX(State_District_Id ),0)  from state_district where District_Name=Location_Name_ and DeleteStatus=0);
    if(Location_Id_ =0)
    then
	SET Location_Id_ =19 ;
	end if; 
    

   Set Student_Id_ = (select Student_Id from Student where  DeleteStatus=0 and Phone like concat('%',Phone_,'%') or Whatsapp like concat('%',Phone_,'%')    limit 1);
if(Student_Id_>0) then
set Duplicate_User_Id = (select User_Id from Student where Student_Id = Student_Id_);
set Duplicate_Student_Name = (select Student_Name from Student where Student_Id = Student_Id_);
set Duplicate_User_Name = (select Users_Name from users where Users_Id = Duplicate_User_Id);
SET Student_Id_ = -1;
            insert into Duplicate_Students values(0,Student_Id_,Duplicate_Student_Name,Phone_,Duplicate_User_Name,Master_Id_);
else
SET Student_Id_ = (SELECT  COALESCE( MAX(Student_Id ),0)+1 FROM Student);
INSERT INTO Student(Student_Id , Agent_Id, Entry_Date,Student_Name ,Gender ,Address1 ,Address2 ,Pincode ,Email ,
Phone,DOB ,Password,Next_FollowUp_Date,Status,User_Id,Remark_Id,
DeleteStatus,Enquiry_Source,Alternative_Email,Whatsapp,Registered,Registered_By ,By_User_Id,Remark,
Enquiry_Source_Name,ByUserName,Status_FollowUp,To_User_Id,ToUserName,FollowUp_Type,Mail_Status,Mobile,StatusName,Qualification_Id,District_Id,College_Name,QualificationName,State_Id
,Resume_Status_Id,Resume_Status_Name, Blacklist_Status,Activate_Status,Fees_Status,Student_Status)
values(Student_Id_ , 1, now(),Name_ ,0 ,Address1_ ,'' ,'',Email_,Phone_,now(),'',Next_FollowUp_Date_,Status_,
To_User_,0,0,Enquiry_Source_,'',Whatsapp_,0,0 ,By_User_Id_,Remark_,
Enquiry_Source_Name_,By_User_Name_,Status_FollowUp_,To_User_,To_User_Name_,2,0,'',Status_Name_,Qualification_Id_,Location_Id_,College_Name_,Qualification_Name_,1,
4,'Not Uploaded', 0,1,0,1);
           
INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference ,Status ,To_User_Id ,
Remark,Remark_Id,By_User_Id,FollowUp_Type ,DeleteStatus,
FollowUP_Time,Actual_FollowUp_Date,ToUserName,ByUserName,StatusName)
values (Student_Id_ ,Now(),Next_FollowUp_Date_,0,Status_ ,To_User_ ,0,0,By_User_Id_,2,false,Now(),Now(),
To_User_Name_,By_User_Name_,Status_Name_);
set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Next_FollowUp_Date = Next_FollowUp_Date_ where student.Student_Id=Student_Id_;
           
end if;
SELECT i + 1 INTO i;      
END WHILE;
set import_master_id=1;

 select  import_master_id;
 select * from Duplicate_Students where Master_Id=Master_Id_;
 delete from Duplicate_Students where Master_Id=Master_Id_;
# DROP TEMPORARY TABLE Duplicate_Students;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Receipt_Voucher`( In Receipt_Voucher_ json)
Begin
declare Receipt_Voucher_Id_ decimal;declare Date_ datetime;declare Student_Id_ DECIMAL(18,0);declare Amount_ DECIMAL(18,2);declare Payment_Mode_ decimal(18,0);
declare User_Id_ decimal(18,0);declare Payment_Status_ varchar(50);declare To_Account_Id_ decimal(18,0);declare To_Account_Name_ varchar(100);declare Description_ varchar(1000);
declare Student_Fees_Installment_Details_Id_ int;declare Student_Course_Id_ int;declare Fees_Type_Id_ int;declare Tax_Percentage_ decimal(18,2);declare Course_Id_ int;
declare Receipt_Image_File_ varchar(200);declare Receipt_Image_File_Name_ varchar(200);
declare Voucher_No_ DECIMAL(18,0);declare Accounts_Id_ decimal(18,0);
declare YearFrom datetime;declare YearTo datetime;DECLARE Check_Box_ varchar(25);
declare Discount_ decimal(18,2);declare Receiving_Amount_ DECIMAL(18,2);
declare From_Account_Id_ int;declare Center_Code_ varchar(100);declare Bill_No_ varchar(100);
Declare Phone_ varchar(50);declare Full_Amount_ decimal(18,2);declare Fees_Balance_Amount_ decimal(18,2);
declare Balance_Amount_ decimal(18,2);  declare Fee_Paid_ decimal(18,2);Declare Student_Name_ varchar(100);
Declare Email_ varchar(100);declare Old_paid decimal(18,2) default 0;
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
    
Declare i int default 0;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Receipt_Voucher_Id')) INTO Receipt_Voucher_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Date')) INTO Date_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.From_Account_Id')) INTO Student_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Amount')) INTO Amount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Payment_Mode')) INTO Payment_Mode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.User_Id')) INTO User_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Payment_Status')) INTO Payment_Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.To_Account_Id')) INTO To_Account_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.To_Account_Name')) INTO To_Account_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Description')) INTO Description_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Student_Fees_Installment_Details_Id')) INTO Student_Fees_Installment_Details_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Student_Course_Id')) INTO Student_Course_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Fees_Type_Id')) INTO Fees_Type_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Tax_Percentage')) INTO Tax_Percentage_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Course_Id')) INTO Course_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Receipt_Image_File')) INTO Receipt_Image_File_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Receipt_Voucher_,'$.Receipt_Image_File_Name')) INTO Receipt_Image_File_Name_;

    
    set Phone_ =(select Phone from Student where Student_Id=Student_Id_ and DeleteStatus=0);
    set Student_Name_ =(select Student_Name from Student where Student_Id=Student_Id_ and DeleteStatus=0);
    set Email_=(select Email from Student where Student_Id=Student_Id_ and DeleteStatus=0);
	set From_Account_Id_=(select Client_Accounts_Id from student where Student_Id=Student_Id_);
	set YearFrom=(select Account_Years.YearFrom from Account_Years where  
	Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
		set YearTo=(select Account_Years.YearTo from Account_Years where
		Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
		Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
	if exists(select distinct Voucher_No from Receipt_Voucher) then
		set Voucher_No_=(SELECT  COALESCE( MAX(Voucher_No ),0)+1 FROM Receipt_Voucher
		where Date_Format(Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d')
		and Date_Format(YearTo,'%Y-%m-%d') and DeleteStatus=false);  
	else
	if exists(select Receipt_Voucher_No from General_Settings) then
		set Voucher_No_=(select COALESCE(Receipt_Voucher_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;
	end if;
if  Receipt_Voucher_Id_>0  THEN
set Old_paid=(select Amount from Receipt_Voucher Where  Receipt_Voucher_Id=Receipt_Voucher_Id_);
	set Voucher_No_=(select Voucher_No from Receipt_Voucher Where  Receipt_Voucher_Id=Receipt_Voucher_Id_ );
	DELETE FROM Accounts WHERE Tran_Type='RV' AND Tran_Id=Receipt_Voucher_Id_;
	UPDATE Receipt_Voucher set Date = Date_  ,From_Account_Id = From_Account_Id_ ,
	Amount = Amount_ ,To_Account_Id = To_Account_Id_ ,Payment_Mode = Payment_Mode_ ,
	User_Id = User_Id_,Payment_Status=Payment_Status_ ,Description=Description_,
	Tax_Percentage=Tax_Percentage_, Course_Id = Course_Id_,To_Account_Name=To_Account_Name_,
    Receipt_Image_File=Receipt_Image_File_,Receipt_Image_File_Name=Receipt_Image_File_Name_
	Where Receipt_Voucher_Id=Receipt_Voucher_Id_ ;
ELSE
	SET Bill_No_ =(SELECT  COALESCE( MAX(Bill_No ),0)+1 FROM Receipt_Voucher);
	SET Receipt_Voucher_Id_ = (SELECT  COALESCE( MAX(Receipt_Voucher_Id ),0)+1 FROM Receipt_Voucher);
	INSERT INTO Receipt_Voucher(Receipt_Voucher_Id ,Date ,Entry_Date,Voucher_No ,From_Account_Id ,Amount ,
	Payment_Mode,User_Id,Payment_Status,To_Account_Id ,Description,Bill_No,Student_Course_Id,
    Fees_Type_Id,Center_Code,Tax_Percentage,Student_Fees_Installment_Details_Id,Course_Id,To_Account_Name,Receipt_Image_File,Receipt_Image_File_Name,DeleteStatus )
	values (Receipt_Voucher_Id_ ,Date_ ,now(),Voucher_No_ ,From_Account_Id_ ,Amount_ ,
	Payment_Mode_ ,User_Id_ ,Payment_Status_,To_Account_Id_,Description_,Bill_No_,Student_Course_Id_,
    Fees_Type_Id_,'',Tax_Percentage_,Student_Fees_Installment_Details_Id_,Course_Id_,To_Account_Name_,Receipt_Image_File_,Receipt_Image_File_Name_,false);
 End If ;   
    set Fee_Paid_=(select Fee_Paid from Student_Course where Student_Course_Id=Student_Course_Id_);
    set Fee_Paid_=Fee_Paid_-Old_paid+Amount_ ;
    update Student_Course set Fee_Paid=Fee_Paid_   where Student_Course_Id=Student_Course_Id_ and DeleteStatus=0;
   set Balance_Amount_=(select Balance_Amount from Student_Fees_Installment_Details
    where Student_Fees_Installment_Details_Id=Student_Fees_Installment_Details_Id_ and DeleteStatus=0);
set Old_paid=(select Amount from Receipt_Voucher Where  Receipt_Voucher_Id=Receipt_Voucher_Id_);
    set Balance_Amount_=Balance_Amount_ - Amount_;
    update Student_Fees_Installment_Details set Balance_Amount=Balance_Amount_ where DeleteStatus=0 and
	Student_Fees_Installment_Details_Id=Student_Fees_Installment_Details_Id_;
	if Balance_Amount_=0 then
		update Student_Fees_Installment_Details set Status=1 where DeleteStatus=0 and
		Student_Fees_Installment_Details_Id=Student_Fees_Installment_Details_Id_;
	End If ;
   
if  Receipt_Voucher_Id_>0  THEN
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Date_,From_Account_Id_,0,Amount_,To_Account_Id_,'RV',Receipt_Voucher_Id_,
Voucher_No_,2,Description_,'','',Payment_Status_);

set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Date_,To_Account_Id_,Amount_,0,From_Account_Id_,'RV',Receipt_Voucher_Id_,
Voucher_No_ ,2,Description_,'','Y',Payment_Status_);
End If ;
/*set Full_Amount_=(select Amount from student_fees_installment_master where Course_Id=Student_Course_Id_
and Fees_Type_Id=Fees_Type_Id_ and DeleteStatus=0);
set Fees_Balance_Amount_=Full_Amount_-Amount_;*/
set Fee_Paid_ =(select Sum(Amount) from receipt_voucher where  Student_Course_Id= Student_Course_Id_ and DeleteStatus=0);
set Balance_Amount_ =(select Sum(Fees_Amount) from student_fees_installment_details inner join student_fees_installment_master on student_fees_installment_details.Student_Fees_Installment_Master_Id= student_fees_installment_master.Student_Fees_Installment_Master_Id where  Student_Course_Id= Student_Course_Id_ and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0);
set Balance_Amount_=Balance_Amount_-Fee_Paid_;
CALL update_Installment_Status(Student_Course_Id_,Receipt_Voucher_Id_);

#commit;

select Receipt_Voucher_Id_,Voucher_No_,Phone_,Amount_,Balance_Amount_,Student_Name_,Email_,
(Date_Format(Date_,'%d-%m-%Y')) Date_;
SELECT student_fees_installment_master.Student_Fees_Installment_Master_Id,Student_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,
Fees_Type_Name,Amount ,No_Of_Instalment,Instalment_Period,Instalment_Date,Student_Fees_Installment_Details_Id,Fees_Amount,Status,Balance_Amount,
Tax,Tax_Percentage From student_fees_installment_master
inner join  student_fees_installment_details on student_fees_installment_master.Student_Fees_Installment_Master_Id=student_fees_installment_details.Student_Fees_Installment_Master_Id
where Student_Id =Student_Id_ and student_fees_installment_master.Course_Id=Course_Id_  and student_fees_installment_master.DeleteStatus=false ;

select sum(Amount) Amount from  receipt_voucher where Student_Course_Id=Student_Course_Id_ and DeleteStatus=false ;

select (student_fees_installment_details.Balance_Amount) as BalanceAmount,(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) Instalment_Date 
From student_fees_installment_master 
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=
student_fees_installment_master.Student_Fees_Installment_Master_Id and student_fees_installment_master.Student_Id=Student_Id_ and
student_fees_installment_master.Course_Id=Course_Id_ where student_fees_installment_details.Balance_Amount>0 
order by student_fees_installment_details.Instalment_Date asc limit 1;

if Balance_Amount_<=0 then
update student set Fees_Status=1 where student.Student_Id=Student_Id_;
end if;
 
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Receipt_Voucher_old`( In Receipt_Voucher_Id_ decimal,
Date_ datetime,Student_Id_ DECIMAL(18,0),Amount_ DECIMAL(18,2),Payment_Mode_ decimal(18,0),User_Id_ decimal(18,0),
Payment_Status_ varchar(50),To_Account_Id_ decimal(18,0),To_Account_Name_ varchar(100),Description_ varchar(1000),Student_Fees_Installment_Details_Id_ int,
Student_Course_Id_ int,Fees_Type_Id_ int,Tax_Percentage_ decimal(18,2),Course_Id_ int)
Begin
declare Voucher_No_ DECIMAL(18,0);declare Accounts_Id_ decimal(18,0);
declare YearFrom datetime;declare YearTo datetime;DECLARE Check_Box_ varchar(25);
declare Discount_ decimal(18,2);declare Receiving_Amount_ DECIMAL(18,2);
declare From_Account_Id_ int;declare Center_Code_ varchar(100);declare Bill_No_ varchar(100);
Declare Phone_ varchar(50);declare Full_Amount_ decimal(18,2);declare Fees_Balance_Amount_ decimal(18,2);
    declare Balance_Amount_ decimal(18,2);  declare Fee_Paid_ decimal(18,2);Declare Student_Name_ varchar(100);
    Declare Email_ varchar(100);declare Old_paid decimal(18,2) default 0;
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
    set Phone_ =(select Phone from Student where Student_Id=Student_Id_ and DeleteStatus=0);
    set Student_Name_ =(select Student_Name from Student where Student_Id=Student_Id_ and DeleteStatus=0);
    set Email_=(select Email from Student where Student_Id=Student_Id_ and DeleteStatus=0);
	set From_Account_Id_=(select Client_Accounts_Id from student where Student_Id=Student_Id_);
	set YearFrom=(select Account_Years.YearFrom from Account_Years where  
	Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
		set YearTo=(select Account_Years.YearTo from Account_Years where
		Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
		Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
	if exists(select distinct Voucher_No from Receipt_Voucher) then
		set Voucher_No_=(SELECT  COALESCE( MAX(Voucher_No ),0)+1 FROM Receipt_Voucher
		where Date_Format(Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d')
		and Date_Format(YearTo,'%Y-%m-%d') and DeleteStatus=false);  
	else
	if exists(select Receipt_Voucher_No from General_Settings) then
		set Voucher_No_=(select COALESCE(Receipt_Voucher_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;
	end if;
if  Receipt_Voucher_Id_>0  THEN
set Old_paid=(select Amount from Receipt_Voucher Where  Receipt_Voucher_Id=Receipt_Voucher_Id_);
	set Voucher_No_=(select Voucher_No from Receipt_Voucher Where  Receipt_Voucher_Id=Receipt_Voucher_Id_ );
	DELETE FROM Accounts WHERE Tran_Type='RV' AND Tran_Id=Receipt_Voucher_Id_;
	UPDATE Receipt_Voucher set Date = Date_  ,From_Account_Id = From_Account_Id_ ,
	Amount = Amount_ ,To_Account_Id = To_Account_Id_ ,Payment_Mode = Payment_Mode_ ,
	User_Id = User_Id_,Payment_Status=Payment_Status_ ,Description=Description_,
	Tax_Percentage=Tax_Percentage_, Course_Id = Course_Id_,To_Account_Name=To_Account_Name_
	Where Receipt_Voucher_Id=Receipt_Voucher_Id_ ;
ELSE
	SET Bill_No_ =(SELECT  COALESCE( MAX(Bill_No ),0)+1 FROM Receipt_Voucher);
	SET Receipt_Voucher_Id_ = (SELECT  COALESCE( MAX(Receipt_Voucher_Id ),0)+1 FROM Receipt_Voucher);
	INSERT INTO Receipt_Voucher(Receipt_Voucher_Id ,Date ,Entry_Date,Voucher_No ,From_Account_Id ,Amount ,
	Payment_Mode,User_Id,Payment_Status,To_Account_Id ,Description,Bill_No,Student_Course_Id,
    Fees_Type_Id,Center_Code,Tax_Percentage,Student_Fees_Installment_Details_Id,Course_Id,To_Account_Name,DeleteStatus )
	values (Receipt_Voucher_Id_ ,Date_ ,now(),Voucher_No_ ,From_Account_Id_ ,Amount_ ,
	Payment_Mode_ ,User_Id_ ,Payment_Status_,To_Account_Id_,Description_,Bill_No_,Student_Course_Id_,
    Fees_Type_Id_,'',Tax_Percentage_,Student_Fees_Installment_Details_Id_,Course_Id_,To_Account_Name_,false);
 End If ;   
    set Fee_Paid_=(select Fee_Paid from Student_Course where Student_Course_Id=Student_Course_Id_);
    set Fee_Paid_=Fee_Paid_-Old_paid+Amount_ ;
    update Student_Course set Fee_Paid=Fee_Paid_   where Student_Course_Id=Student_Course_Id_ and DeleteStatus=0;
   set Balance_Amount_=(select Balance_Amount from Student_Fees_Installment_Details
    where Student_Fees_Installment_Details_Id=Student_Fees_Installment_Details_Id_ and DeleteStatus=0);
set Old_paid=(select Amount from Receipt_Voucher Where  Receipt_Voucher_Id=Receipt_Voucher_Id_);
    set Balance_Amount_=Balance_Amount_ - Amount_;
    update Student_Fees_Installment_Details set Balance_Amount=Balance_Amount_ where DeleteStatus=0 and
	Student_Fees_Installment_Details_Id=Student_Fees_Installment_Details_Id_;
	if Balance_Amount_=0 then
		update Student_Fees_Installment_Details set Status=1 where DeleteStatus=0 and
		Student_Fees_Installment_Details_Id=Student_Fees_Installment_Details_Id_;
	End If ;
   
if  Receipt_Voucher_Id_>0  THEN
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Date_,From_Account_Id_,0,Amount_,To_Account_Id_,'RV',Receipt_Voucher_Id_,
Voucher_No_,2,Description_,'','',Payment_Status_);

set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Date_,To_Account_Id_,Amount_,0,From_Account_Id_,'RV',Receipt_Voucher_Id_,
Voucher_No_ ,2,Description_,'','Y',Payment_Status_);
End If ;
/*set Full_Amount_=(select Amount from student_fees_installment_master where Course_Id=Student_Course_Id_
and Fees_Type_Id=Fees_Type_Id_ and DeleteStatus=0);
set Fees_Balance_Amount_=Full_Amount_-Amount_;*/
set Fee_Paid_ =(select Sum(Amount) from receipt_voucher where  Student_Course_Id= Student_Course_Id_ and DeleteStatus=0);
set Balance_Amount_ =(select Sum(Fees_Amount) from student_fees_installment_details inner join student_fees_installment_master on student_fees_installment_details.Student_Fees_Installment_Master_Id= student_fees_installment_master.Student_Fees_Installment_Master_Id where  Student_Course_Id= Student_Course_Id_ and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0);
set Balance_Amount_=Balance_Amount_-Fee_Paid_;
CALL update_Installment_Status(Student_Course_Id_,Receipt_Voucher_Id_);

#commit;

select Receipt_Voucher_Id_,Voucher_No_,Phone_,Amount_,Balance_Amount_,Student_Name_,Email_,
(Date_Format(Date_,'%d-%m-%Y')) Date_;
SELECT student_fees_installment_master.Student_Fees_Installment_Master_Id,Student_Id,Course_Fees_Id,Course_Id,Fees_Type_Id,
Fees_Type_Name,Amount ,No_Of_Instalment,Instalment_Period,Instalment_Date,Student_Fees_Installment_Details_Id,Fees_Amount,Status,Balance_Amount,
Tax,Tax_Percentage From student_fees_installment_master
inner join  student_fees_installment_details on student_fees_installment_master.Student_Fees_Installment_Master_Id=student_fees_installment_details.Student_Fees_Installment_Master_Id
where Student_Id =Student_Id_ and student_fees_installment_master.Course_Id=Course_Id_  and student_fees_installment_master.DeleteStatus=false ;

select sum(Amount) Amount from  receipt_voucher where Student_Course_Id=Student_Course_Id_ and DeleteStatus=false ;

select (student_fees_installment_details.Balance_Amount) as BalanceAmount,(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) Instalment_Date 
From student_fees_installment_master 
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=
student_fees_installment_master.Student_Fees_Installment_Master_Id and student_fees_installment_master.Student_Id=Student_Id_ and
student_fees_installment_master.Course_Id=Course_Id_ where student_fees_installment_details.Balance_Amount>0 
order by student_fees_installment_details.Instalment_Date asc limit 1;

if Balance_Amount_=0 then
update student set Fees_Status=1 where student.Student_Id=Student_Id_;
end if;
 
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Student_Report_FollowUp`( In Student_Id_ int, Status_ int,
To_User_Id_ int,Remark_ varchar(4000),Next_FollowUp_Date_ datetime,By_User_Id_ int,StatusName_ varchar(50),
ToUserName_ varchar(50),ByUserName_ varchar(50),Status_FollowUp_ varchar(50),Remark_Id_ int)
Begin
declare x int default 0;
declare Student_FollowUp_Id_ int;


INSERT INTO student_followup(Student_Id ,Entry_Date,Next_FollowUp_Date,FollowUp_Difference ,Status  ,
By_User_Id,To_User_Id,
Remark,Remark_Id,FollowUp_Type,FollowUP_Time,Actual_FollowUp_Date,StatusName,
ToUserName,ByUserName,Status_FollowUp,DeleteStatus)

values (Student_Id_ ,Now(),Next_FollowUp_Date_,0 ,Status_  ,By_User_Id_,To_User_Id_,
Remark_,Remark_Id_,1,Now(),Now(),StatusName_,
ToUserName_,ByUserName_,Status_FollowUp_,false);

set Student_FollowUp_Id_ =(SELECT LAST_INSERT_ID());
Update student set Student_FollowUp_Id=Student_FollowUp_Id_ ,Status = Status_ ,
User_Id = To_User_Id_ ,To_User_Id = To_User_Id_,By_User_Id=By_User_Id_,
Next_FollowUp_Date = Next_FollowUp_Date_ ,Remark_Id=Remark_Id_,Remark=Remark_,Status_FollowUp=Status_FollowUp_,
ToUserName=ToUserName_,ByUserName=ByUserName_
where student.Student_Id=Student_Id_;
select Student_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Study_Materials`( In Study_Materials_Id_ int,
Course_Id_ int,
Part_Id_ int,
Subject_Id_ int,
Course_Subject_Id_ int,
Study_Materials_Name_ varchar(100),
File_Name_ varchar(100))
Begin 
 if  Study_Materials_Id_>0
 THEN 
 UPDATE Study_Materials set Study_Materials_Id = Study_Materials_Id_ ,
Course_Id = Course_Id_ ,
Part_Id = Part_Id_ ,
Subject_Id = Subject_Id_ ,
Course_Subject_Id = Course_Subject_Id_ ,
Study_Materials_Name = Study_Materials_Name_ ,
File_Name = File_Name_  Where Study_Materials_Id=Study_Materials_Id_ ;
 ELSE 
 SET Study_Materials_Id_ = (SELECT  COALESCE( MAX(Study_Materials_Id ),0)+1 FROM Study_Materials); 
 INSERT INTO Study_Materials(Study_Materials_Id ,
Course_Id ,
Part_Id ,
Subject_Id ,
Course_Subject_Id ,
Study_Materials_Name ,
File_Name ,
DeleteStatus ) values (Study_Materials_Id_ ,
Course_Id_ ,
Part_Id_ ,
Subject_Id_ ,
Course_Subject_Id_ ,
Study_Materials_Name_ ,
File_Name_ ,
false);
 End If ;
 select Study_Materials_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Subject`( In Subject_Id_ int,
Subject_Name_ varchar(1000),
Exam_status_ int,
User_Id_ int)
Begin 
 if  Subject_Id_>0
 THEN 
 UPDATE Subject set Subject_id = Subject_id_ ,
Subject_Name = Subject_Name_ ,
Exam_status = Exam_status_ ,
User_Id = User_Id_  Where Subject_Id=Subject_Id_ ;
 ELSE 
 SET Subject_Id_ = (SELECT  COALESCE( MAX(Subject_Id ),0)+1 FROM Subject); 
 INSERT INTO Subject(Subject_Id ,
Subject_Name ,
Exam_status ,
User_Id ,
DeleteStatus ) values (Subject_Id_ ,
Subject_Name_ ,
Exam_status_ ,
User_Id_ ,
false);
 End If ;
 select Subject_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Syllabus_Import`(In Syllabus_Import_Details_ json,User_Id_ int,Course_Id_ int,Course_Name_ varchar(500))
Begin 

declare Subject_Id_ int;
declare Subject_Name_ longtext;
declare Course_Subject_Id_ int;
declare Exam_status_ int;
declare Task_ longtext;
declare Day_ varchar(45);
declare Heading_ text;
Declare i int default 0;



WHILE i < JSON_LENGTH(Syllabus_Import_Details_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Syllabus_Import_Details_,CONCAT('$[',i,'].Day'))) INTO Day_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Syllabus_Import_Details_,CONCAT('$[',i,'].Topic'))) INTO Subject_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Syllabus_Import_Details_,CONCAT('$[',i,'].Task'))) INTO Task_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Syllabus_Import_Details_,CONCAT('$[',i,'].Heading'))) INTO Heading_;
        
		SET Subject_Id_ = (SELECT  COALESCE( MAX(Subject_Id ),0)+1 FROM Subject); 
		INSERT INTO Subject(Subject_Id ,Subject_Name ,Exam_status ,User_Id ,DeleteStatus,Task,Day,Heading ) 
		values (Subject_Id_ ,Subject_Name_ ,0 ,User_Id_ ,false,Task_,Day_,Heading_);	
        
        SET Course_Subject_Id_ = (SELECT  COALESCE( MAX(Course_Subject_Id),0)+1 FROM course_subject); 
		INSERT INTO course_subject(Course_Subject_Id ,Course_Id ,Part_Id ,Subject_Id ,Subject_Name,Minimum_Mark,Maximum_Mark,Online_Exam_Status,No_of_Question,Exam_Duration,DeleteStatus,Task,Day,Heading ) 
		                   values (Course_Subject_Id_ ,Course_Id_ ,1 ,Subject_Id_ ,Subject_Name_,'','',1,'','',false,Task_,Day_,Heading_);	
        

set i=i+1;
End While;

 select Subject_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Transaction`( In Transaction_Master_Id_ int,
Course_Id_ int,Batch_Id_ int,User_Id_ int,Employer_Details_Id_ int,Portion_Covered_ int,Description_ varchar(4000),
Transaction_Student JSON)
BEGIN

DECLARE Student_Id_ int;DECLARE Company_Name_ Varchar(100);DECLARE Phone_ Varchar(100);

DECLARE i int  DEFAULT 0;DECLARE j int  DEFAULT 0;
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
set Company_Name_=(select Company_Name from Company where Company_Id=1);
	if  Transaction_Master_Id_>0 THEN
		delete from Transaction_student where Transaction_Master_Id=Transaction_Master_Id_;
		UPDATE Transaction_Master set Course_Id = Course_Id_ ,Batch_Id = Batch_Id_ ,
        User_Id = User_Id_ ,Employer_Details_Id=Employer_Details_Id_,Portion_Covered=Portion_Covered_,Description=Description_
		Where Transaction_Master_Id=Transaction_Master_Id_ ;
	ELSE
		SET Transaction_Master_Id_ = (SELECT  COALESCE( MAX(Transaction_Master_Id ),0)+1 FROM Transaction_Master);
		INSERT INTO Transaction_Master(Transaction_Master_Id ,Course_Id ,Batch_Id ,User_Id,Employer_Details_Id,
        Portion_Covered,Date,Description,DeleteStatus )
		values (Transaction_Master_Id_,Course_Id_ ,Batch_Id_ ,User_Id_,Employer_Details_Id_,
        Portion_Covered_,curdate(),Description_,false);
	End If ;
	if  Transaction_Master_Id_>0 then
		WHILE i < JSON_LENGTH(Transaction_Student) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Transaction_Student,CONCAT('$[',i,'].Student_Id'))) INTO Student_Id_;
		INSERT INTO Transaction_Student(Transaction_Master_Id,Student_Id,Transaction_Type,DeleteStatus )
		values (Transaction_Master_Id_ ,Student_Id_ ,1,false);
        Update Student set Resume_Send=1, Resume_Send_Date=curdate()         
       where Student_Id=Student_Id_ and DeleteStatus=0;
		SELECT i + 1 INTO i;
		END WHILE;  
    end if;
#COMMIT;
	
	select Transaction_Master_Id_,Description_,Phone,Company_Name_
    from student 
	where Student_Id in(select Student_Id from Transaction_Student 
	where Transaction_Master_Id=Transaction_Master_Id_);
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_University`( In University_Id_ int,
University_Name_ varchar(100),
Address1_ varchar(100),
Address2_ varchar(100),
Address3_ varchar(100),
Address4_ varchar(100),
Pincode_ varchar(100),
Phone_ varchar(100),
Mobile_ varchar(100),
Email_ varchar(100),
User_Id_ int)
Begin 
 if  University_Id_>0
 THEN 
 UPDATE University set University_Id = University_Id_ ,
University_Name = University_Name_ ,
Address1 = Address1_ ,
Address2 = Address2_ ,
Address3 = Address3_ ,
Address4 = Address4_ ,
Pincode = Pincode_ ,
Phone = Phone_ ,
Mobile = Mobile_ ,
Email = Email_ ,
User_Id = User_Id_  Where University_Id=University_Id_ ;
 ELSE 
 SET University_Id_ = (SELECT  COALESCE( MAX(University_Id ),0)+1 FROM University); 
 INSERT INTO University(University_Id ,
University_Name ,
Address1 ,
Address2 ,
Address3 ,
Address4 ,
Pincode ,
Phone ,
Mobile ,
Email ,
User_Id ,
DeleteStatus ) values (University_Id_ ,
University_Name_ ,
Address1_ ,
Address2_ ,
Address3_ ,
Address4_ ,
Pincode_ ,
Phone_ ,
Mobile_ ,
Email_ ,
User_Id_ ,
false);
 End If ;
 select University_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_University_Followup`( In University_Followup_Id_ int,
University_Id_ int,
Entry_Date_ datetime,
Next_FollowUp_Date_ datetime,
FollowUp_Difference_ int,
Status_ int,
User_Id_ int,
Remark_ varchar(4000),
Remark_Id_ int,
FollowUp_Type_ int,
FollowUP_Time_ varchar(100),
Actual_FollowUp_Date_ datetime,
Entry_Type_ varchar(100))
Begin 
 if  University_Followup_Id_>0
 THEN 
 UPDATE University_Followup set University_Followup_Id = University_Followup_Id_ ,
University_Id = University_Id_ ,
Entry_Date = Entry_Date_ ,
Next_FollowUp_Date = Next_FollowUp_Date_ ,
FollowUp_Difference = FollowUp_Difference_ ,
Status = Status_ ,
User_Id = User_Id_ ,
Remark = Remark_ ,
Remark_Id = Remark_Id_ ,
FollowUp_Type = FollowUp_Type_ ,
FollowUP_Time = FollowUP_Time_ ,
Actual_FollowUp_Date = Actual_FollowUp_Date_ ,
Entry_Type = Entry_Type_  Where University_Followup_Id=University_Followup_Id_ ;
 ELSE 
 SET University_Followup_Id_ = (SELECT  COALESCE( MAX(University_Followup_Id ),0)+1 FROM University_Followup); 
 INSERT INTO University_Followup(University_Followup_Id ,
University_Id ,
Entry_Date ,
Next_FollowUp_Date ,
FollowUp_Difference ,
Status ,
User_Id ,
Remark ,
Remark_Id ,
FollowUp_Type ,
FollowUP_Time ,
Actual_FollowUp_Date ,
Entry_Type ,
DeleteStatus ) values (University_Followup_Id_ ,
University_Id_ ,
Entry_Date_ ,
Next_FollowUp_Date_ ,
FollowUp_Difference_ ,
Status_ ,
User_Id_ ,
Remark_ ,
Remark_Id_ ,
FollowUp_Type_ ,
FollowUP_Time_ ,
Actual_FollowUp_Date_ ,
Entry_Type_ ,
false);
 End If ;
 select University_Followup_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Users`( In Users_Id_ decimal,
Users_Name_ varchar(250),Password_ varchar(250),Working_Status_ int,
User_Type_ int,Role_Id_ decimal,Agent_ int,Address1_ varchar(250),Address2_ varchar(250),Address3_ varchar(250),
Address4_ varchar(250),Pincode_ varchar(250),Mobile_ varchar(250),Email_ varchar(250),
Employee_Id_ int,Registration_Target_ int,FollowUp_Target_ int,User_Menu_Selection  JSON,User_Sub json)
BEGIN

DECLARE Department_Id_ int;DECLARE Agent_Id_ int;DECLARE View_Entry_ varchar(25);
DECLARE VIew_All_ varchar(25); DECLARE VIew_All_1 varchar(25);DECLARE User_Selection_Id_ int;
DECLARE Menu_Id_ int;DECLARE IsEdit_ varchar(25);DECLARE IsSave_ varchar(25);
DECLARE IsDelete_ varchar(25);DECLARE IsView_ varchar(25); DECLARE Menu_Status_ varchar(25);
        declare User_Max_Count int;
    declare Current_User_Count int;
DECLARE i int  DEFAULT 0;DECLARE j int  DEFAULT 0;
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
if  Users_Id_>0
THEN
delete from User_Menu_Selection where User_Id=Users_Id_;
delete from user_sub where Users_Id=Users_Id_;

UPDATE Users set Users_Name = Users_Name_ ,Password = Password_ ,Working_Status = Working_Status_ ,
User_Type = User_Type_ ,Role_Id = Role_Id_ ,Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_ ,Agent_Id=Agent_,
Address4 = Address4_ ,Pincode = Pincode_ ,Mobile = Mobile_ ,Email = Email_,Employee_Id=Employee_Id_,Registration_Target=Registration_Target_,
FollowUp_Target=FollowUp_Target_
Where Users_Id=Users_Id_ ;
update student set ToUserName = Users_Name_ where To_User_Id = Users_Id_;
update student set ByUserName = Users_Name_ where By_User_Id = Users_Id_;
update student_followup set ToUserName = Users_Name_ where To_User_Id = Users_Id_;
update student_followup set ByUserName = Users_Name_ where By_User_Id = Users_Id_;
ELSE
/*
set User_Max_Count=(select Settings_Value from settings_table where  Settings_Id=1);
set Current_User_Count=(select count(Users_Id) from Users where DeleteStatus=0);
if User_Max_Count>Current_User_Count then*/
       
SET Users_Id_ = (SELECT  COALESCE( MAX(Users_Id ),0)+1 FROM Users);
INSERT INTO Users(Users_Id ,Users_Name ,Password ,Working_Status ,User_Type ,Role_Id ,Agent_Id,
Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,Mobile ,Email ,Employee_Id,Registration_Target,FollowUp_Target,DeleteStatus )
values (Users_Id_ ,Users_Name_ ,Password_ ,Working_Status_ ,User_Type_ ,Role_Id_ ,Agent_,
Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,Mobile_ ,Email_ ,Employee_Id_,Registration_Target_,FollowUp_Target_,false);

End If ;
    if  Users_Id_>0 then
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
values (Menu_Id_ ,Users_Id_ ,IsEdit_ ,IsSave_ ,IsDelete_ ,IsView_ ,Menu_Status_ ,false);
SELECT i + 1 INTO i;
END WHILE;  
end if;
 #COMMIT;
 
if  Users_Id_>0 then
	WHILE j < JSON_LENGTH(User_Sub) DO
	SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Sub,CONCAT('$[',j,'].User_Selection_Id'))) INTO User_Selection_Id_;
    insert into User_Sub (Users_Id,User_Selection_Id,DeleteStatus)
    values(Users_Id_,User_Selection_Id_,0);
SELECT j + 1 INTO j;
END WHILE;  
end if;
 select Users_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_User_Role`( In User_Role_Id_ int,
User_Role_Name_ varchar(100),
Role_Under_Id_ int)
Begin 
 if  User_Role_Id_>0
 THEN 
 UPDATE User_Role set User_Role_Id = User_Role_Id_ ,
User_Role_Name = User_Role_Name_ ,
Role_Under_Id = Role_Under_Id_  Where User_Role_Id=User_Role_Id_ ;
 ELSE 
 SET User_Role_Id_ = (SELECT  COALESCE( MAX(User_Role_Id ),0)+1 FROM User_Role); 
 INSERT INTO User_Role(User_Role_Id ,
User_Role_Name ,
Role_Under_Id ,
DeleteStatus ) values (User_Role_Id_ ,
User_Role_Name_ ,
Role_Under_Id_ ,
false);
 End If ;
 select User_Role_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_User_Type`( In User_Type_Id_ int,
User_Type_Name_ varchar(100))
Begin 
 if  User_Type_Id_>0
 THEN 
 UPDATE User_Type set User_Type_Id = User_Type_Id_ ,
User_Type_Name = User_Type_Name_  Where User_Type_Id=User_Type_Id_ ;
 ELSE 
 SET User_Type_Id_ = (SELECT  COALESCE( MAX(User_Type_Id ),0)+1 FROM User_Type); 
 INSERT INTO User_Type(User_Type_Id ,
User_Type_Name ,
DeleteStatus ) values (User_Type_Id_ ,
User_Type_Name_ ,
false);
 End If ;
 select User_Type_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Save_Vacancy_Source`( In Vacancy_Source_Id_ int,
Vacancy_Source_Name_ varchar(100))
Begin 
if  Vacancy_Source_Id_>0 THEN 
	UPDATE Vacancy_Source set Vacancy_Source_Name = Vacancy_Source_Name_ 
	Where Vacancy_Source_Id=Vacancy_Source_Id_ ;
   # update student set StatusName = Status_Name_,Status_FollowUp =FollowUp_  where Status = Status_Id_;
    #update student_followup set StatusName = Status_Name_,Status_FollowUp = FollowUp_ where Status = Status_Id_;
ELSE 
	SET Vacancy_Source_Id_ = (SELECT  COALESCE( MAX(Vacancy_Source_Id ),0)+1 FROM Vacancy_Source); 
	INSERT INTO Vacancy_Source(Vacancy_Source_Id ,Vacancy_Source_Name ,DeleteStatus ) 
	values (Vacancy_Source_Id_ ,Vacancy_Source_Name_ ,false);
End If ;
	select Vacancy_Source_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Accounts`( In Accounts_Name_ varchar(100))
Begin 
 set Accounts_Name_ = Concat( '%',Accounts_Name_ ,'%');
 SELECT Accounts_Id,
Date,
Client_Id,
DR,
CR,
X_Client_Id,
Voucher_No,
Voucher_Type,
Description,
Status,
Daybbok From Accounts where Accounts_Name like Accounts_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Active_Batch_Report`(in Is_Date_Check_ tinyint,
Fromdate_ datetime,Todate_ datetime,Batch_Id_ int,Search_Staff_ int,Course_ int,User_Id_ int,Branch_Id_ INT)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);
declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';  set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 if Search_Staff_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",Search_Staff_);
end if;
 if Batch_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Id =",Batch_Id_);
end if;
 if Course_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Course_Id =",Course_);
end if;
 if Branch_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Branch_Id =",Branch_Id_);
end if;
/*if Is_Date_Check_>0 then
    set Search_Date_=concat( " and student_course.Start_Date >= '", Fromdate_ ,"' and  student_course.Start_Date <= '", Todate_,"'");
    ELSE
    set Search_Date_= "and 1 =1 ";
end if;*/
if Is_Date_Check_>0 then
    set Search_Date_=concat( " and student_course.Start_Date <= '", Fromdate_ ,"'");
    ELSE
    set Search_Date_= "and 1 =1 ";
end if;
SET @query = Concat("select student_course.Batch_Name Batch,student_course.Course_Name Course,
(Date_Format(student_course.Batch_Start_Date,'%d-%m-%Y')) As StartDate,student_course.Batch_Start_Time Start_Time,
count(student_course.Student_Id) as Current_Admission_Count,batch.Branch_Name Branch,Faculty.Users_Name as Faculty,
(Date_Format(student_course.Batch_End_Date,'%d-%m-%Y')) As End_Date,
student_course.Batch_End_Time End_Time From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users Faculty on Faculty.Users_Id=student_course.Faculty_Id
inner join batch on batch.Batch_Id=  student_course.Batch_Id
inner join agent on agent.Agent_Id=student_course.Batch_Branch_Id  ",SearchbyName_Value," ",Search_Date_," ",Department_String,"
WHERE student_course.DeleteStatus=0 and Batch_Complete_Status!=1 and student.Status !=18
group by student_course.Batch_Name ,student_course.Course_Name,student_course.Batch_Start_Date,
student_course.Batch_Start_Time,batch.Branch_Name,Faculty.Users_Name,student_course.Batch_End_Date,student_course.Batch_End_Time
order by  student_course.Batch_Start_Date desc; " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
#insert into data_log_ values(0,@query,'');
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Admission_Report`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,User_Id_ int,Login_User_Id_ int,
Course_Id_ int ,Enquiry_Source_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_Id_);
 #if User_Type_=2 then
  #	SET Department_String =concat(Department_String," and student.Registered_By =",Login_User_Id_);
 #else
	SET Department_String =concat(Department_String," and (student.Registered_By in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.Registered_By =" , Login_User_Id_, ")");
 #end if; 
if Is_Date_>0 then
	set Search_Date_=concat( " and date(student_course.Join_Date) >= '", Fromdate_ ,"' and  date(student_course.Join_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

if User_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",User_Id_);
end if;


if Enquiry_Source_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiry_Source =",Enquiry_Source_Id_);
end if;


if Course_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Course_Id =",Course_Id_);
end if;

SET @query = Concat("SELECT Student_Name Student,student.Student_Id,student_course.Course_Name Course,Year_Of_Passing,
(Date_Format(student_course.Join_Date,'%d-%m-%Y')) As JoiningDate,Fee_Paid FeePaid,student.Phone,student.Whatsapp,
Registered_By.Users_Name TeamMember,Enquiry_Source.Enquiry_Source_Name EnquirySource,
Agent.Agent_Name Branch,student.Address1 Location,student.District_Id ,state_district.District_Name
From student 
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users Registered_By on Registered_By.Users_Id=student.Registered_By
inner join Enquiry_Source on Enquiry_Source.Enquiry_Source_Id=student.Enquiry_Source
inner join Agent on Agent.Agent_Id=student.Agent_Id
inner join state_district on state_district.State_District_Id=student.District_Id
where  student.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Agent`( In Agent_Name_ varchar(100))
Begin 
 set Agent_Name_ = Concat( '%',Agent_Name_ ,'%');
 SELECT Agent.*, category.Category_Name From Agent inner join category on Agent.Category_Id=category.Category_Id
 where Agent_Name like Agent_Name_ and Agent.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Agent_Commision`( In Agent_Commision_Name_ varchar(100))
Begin 
 set Agent_Commision_Name_ = Concat( '%',Agent_Commision_Name_ ,'%');
 SELECT Agent_Commision_Id,
Agent_Id,
Category_Id,
Category_Name,
Commision_Per,
Commision_Amount From Agent_Commision where Agent_Commision_Name like Agent_Commision_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Agent_Course_Type`( In Agent_Course_Type_Name_ varchar(100))
Begin 
 set Agent_Course_Type_Name_ = Concat( '%',Agent_Course_Type_Name_ ,'%');
 SELECT Agent_Course_Type_Id,
Agent_Id,
Course_Type_Id,
Cousrse_Type_Name From Agent_Course_Type where Agent_Course_Type_Name like Agent_Course_Type_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Appliedcount_Details`(In Job_Posting_Id_ int,Job_Title_ varchar(100))
BEGIN
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
if Job_Posting_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Posting_Id =",Job_Posting_Id_);
end if;
#if(Job_Title_ !='') then
#		SET SearchbyName_Value =Concat( SearchbyName_Value," and job_posting.Job_Title like '%",Job_Title_ ,"%'") ;
#end if;
SET @query = Concat( "select Student_Name,job_posting.Company_Name Company,student.Phone Mobile,Image_ResumeFilename,Placement_Status , Interview_Status , 
student.Student_Id Student_Id,Applied_Jobs_Id,
(Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) Entry_Date,Resume,Job_Title,Job_Posting_Id,
 (Date_Format(Interview_Date,'%d-%m-%Y')) Interview_Date ,  (Date_Format(Placement_Date,'%d-%m-%Y')) Placement_Date , student_course.Course_Name,Phone,
 Interview_Description ,Placement_Description ,CourseName,DATE_FORMAT(applied_jobs.Entry_Date,'%H:%i:%s') Apply_Time,Interview_Location,Interview_Time,

 CASE applied_jobs.Interview_Attending_Rejecting
                WHEN 1 THEN 'Inteview Apply'
                WHEN 2 THEN 'Inteview Reject'
                WHEN 3 THEN 'Not Responded'
                ELSE ''
            END AS Interview_Attending_Rejecting_Name,
Interview_Attending_Rejecting,(Date_Format(Interview_Attending_Rejecting_Date,'%d-%m-%Y')) Interview_Attending_Rejecting_Date,Interview_Rejection_Remark
from student
inner join applied_jobs on applied_jobs.Student_Id=student.Student_Id
inner join student_course on student_course.Student_Id=student.Student_Id
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id
where student.DeleteStatus=0 and job_posting.Applied_Count>=1 and applied_jobs.Apply_Type=1 and job_posting.DeleteStatus=0  ",SearchbyName_Value," 
order by student.Student_Id asc ");
PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Appliedcount_Details1`(In Job_Posting_Id_ int,Job_Title_ varchar(100))
BEGIN
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
if Job_Posting_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Posting_Id =",Job_Posting_Id_);
end if;
#if(Job_Title_ !='') then
#		SET SearchbyName_Value =Concat( SearchbyName_Value," and job_posting.Job_Title like '%",Job_Title_ ,"%'") ;
#end if;
 SET @query = CONCAT(
        "SELECT 
            student.Student_Name,
            student.Student_Id,
            applied_jobs.Applied_Jobs_Id,
            DATE_FORMAT(applied_jobs.Entry_Date,'%d-%m-%Y') AS Entry_Date,
            student.Resume,
            student.Image_ResumeFilename,
            job_posting.Job_Title,
            job_posting.Job_Posting_Id,
            DATE_FORMAT(applied_jobs.Interview_Date,'%d-%m-%Y') AS Interview_Date,
            applied_jobs.Interview_Status,
            DATE_FORMAT(applied_jobs.Placement_Date,'%d-%m-%Y') AS Placement_Date,
            applied_jobs.Placement_Status,
            applied_jobs.Interview_Description,
            applied_jobs.Placement_Description,
            student.Phone AS Mobile,
            job_posting.Company_Name AS Company,
            CASE applied_jobs.Interview_Attending_Rejecting
                WHEN 1 THEN 'Inteview Apply'
                WHEN 2 THEN 'Inteview Reject'
                WHEN 3 THEN 'Not Responded'
                ELSE ''
            END AS Interview_Attending_Rejecting_Name,applied_jobs.Interview_Attending_Rejecting,
            DATE_FORMAT(applied_jobs.Interview_Attending_Rejecting_Date,'%d-%m-%Y') AS Interview_Attending_Rejecting_Date,
            applied_jobs.Interview_Rejection_Remark
        FROM 
            student
            INNER JOIN applied_jobs ON applied_jobs.Student_Id = student.Student_Id
            INNER JOIN job_posting ON job_posting.Job_Posting_Id = applied_jobs.Job_Id
        WHERE 
            student.DeleteStatus = 0
            AND job_posting.Applied_Count >= 1
            AND applied_jobs.Apply_Type = 1
            AND job_posting.DeleteStatus = 0 
            ", SearchbyName_Value, " 
        ORDER BY student.Student_Id ASC"
    );
PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Applied_Candidate`(in Fromdate_ datetime,Todate_ datetime,Candidate_Name_ Varchar(100))
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';

if Candidate_Name_ !='' then	
    SET SearchbyName_Value =concat(SearchbyName_Value," and candidate.Candidate_Name like '%",Candidate_Name_ ,"%'");
end if;

set Search_Date_=concat( " and date(candidate_job_apply.Entry_Date) >= '", Fromdate_ ,"' and  date(candidate_job_apply.Entry_Date) <= '", Todate_,"'");

SET @query = Concat("SELECT candidate.Candidate_Id,candidate.Candidate_Name,Job_Location,
Job_Title,Company_Name,job_posting.Job_Posting_Id,candidate_job_apply.Status_Id,candidate_job_apply.Status_Name,
Contact_Name,Contact_No,Candidate_Job_Apply_Id,
(Date_Format(candidate_job_apply.Entry_Date,'%Y-%m-%d')) As Entry_Date
From candidate 
inner join candidate_job_apply on candidate_job_apply.Candidate_Id=candidate.Candidate_Id
inner join job_posting on candidate_job_apply.Job_Posting_Id=job_posting.Job_Posting_Id
where  candidate.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_," 
order by job_posting.Job_Posting_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Applied_Mobile`(In Student_Id_ int, Pointer_Start_ int ,
 Pointer_Stop_ int,Page_Length_ int)
Begin 
 
SET @query = Concat("select * from (select Job_Title,SUBSTRING(Descritpion,1,5) as Descritpion,Job_Posting_Id,
(Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) As Last_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from job_posting inner join applied_jobs on applied_jobs.job_id =Job_Posting_Id
WHERE  Apply_Type=1 and Student_Id =",Student_Id_," ) as lds 
order by  RowNo  " );
#LIMIT,Page_Length_
#  WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"

PREPARE QUERY FROM @query;
EXECUTE QUERY;
#insert into db_logs values(3,Student_Id_,'');
#insert into db_logs values(2,@query,'');
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Attendance`(in Course_Id_ int,Batch_Id_ int,Faculty_Id_ int)
BEGIN
select Student.Student_Id,Student_Name,1 Check_Box
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id
where student_course.Course_Id=Course_Id_ and Batch_Id=Batch_Id_ and Faculty_Id=Faculty_Id_ and 
student_course.DeleteStatus=0 and Student.DeleteStatus=0 and Student.status not in(18,19);

select distinct Student_Course_Subject.Subject_Id,Subject_Name,0 Checkbox,Minimum_Mark,Task, 
Day,Heading from Student_Course_Subject
where Student_Course_Subject.Course_Id=Course_Id_  and Student_Course_Subject.DeleteStatus=0 ;

/*select distinct Student_Course_Subject.Subject_Id,Subject_Name,Minimum_Mark,
case when attendance_subject.Attendance_Master_Id>0 then 1 else 0 end as Checkbox
from Student_Course_Subject
left join attendance_subject on attendance_subject.Subject_Id=Student_Course_Subject.Subject_Id 
where  Student_Course_Subject.DeleteStatus=0 and Student_Course_Subject.Course_Id=Course_Id_;*/
select  Subject_Id,Subject_Name,Minimum_Mark,Task ,Day , Heading,
#case when attendance_syllabus_master.Attendance_Syllabus_Master_Id>0 then 1 else 0 end 
0 as Checkbox
from course_subject 
where Course_Id= Course_Id_ 
order by Subject_Id asc;

select  Syllabus_Id Subject_Id
from attendance_syllabus_master where Batch_Id=Batch_Id_  
and Course_Id= Course_Id_
order by Subject_Id asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Attendance1`(in Course_Id_ int,Batch_Id_ int,Faculty_Id_ int)
BEGIN
select Student.Student_Id,Student_Name,1 Check_Box
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id
where student_course.Course_Id=Course_Id_ and Batch_Id=Batch_Id_ and Faculty_Id=Faculty_Id_ and 
student_course.DeleteStatus=0 and Student.DeleteStatus=0 and Student.status!=18;
select distinct Student_Course_Subject.Subject_Id,Subject_Name,0 Checkbox,Minimum_Mark
from Student_Course_Subject
where Student_Course_Subject.Course_Id=Course_Id_  and Student_Course_Subject.DeleteStatus=0 ;

/*select distinct Student_Course_Subject.Subject_Id,Subject_Name,Minimum_Mark,
case when attendance_subject.Attendance_Master_Id>0 then 1 else 0 end as Checkbox
from Student_Course_Subject
left join attendance_subject on attendance_subject.Subject_Id=Student_Course_Subject.Subject_Id 
where  Student_Course_Subject.DeleteStatus=0 and Student_Course_Subject.Course_Id=Course_Id_;*/


select distinct Student_Course_Subject.Subject_Id,Subject_Name,Minimum_Mark,
case when attendance_subject.Attendance_Master_Id>0 then 1 else 0 end as Checkbox
from attendance_subject 
inner join attendance_master on attendance_master.Attendance_Master_Id=
attendance_subject.Attendance_Master_Id and Attendance_Master.Batch_Id=Batch_Id_
and Course_Id=Course_Id_ right join Student_Course_Subject
 on attendance_subject.Subject_Id=Student_Course_Subject.Subject_Id

where  Student_Course_Subject.DeleteStatus=0 and Student_Course_Subject.Course_Id=Course_Id_  ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Attendance_Report`(in Fromdate_ datetime,Todate_ datetime,
Faculty_Id_ int,Course_Id_ int, Batch_Id_ varchar(200),Attendance_Status_Id int,User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';
set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 #if User_Type_=2 then
  #	SET Department_String =concat(Department_String," and attendance_master.Faculty_Id =",User_Id_);
 #else

	SET Department_String =concat(Department_String," and (attendance_master.Faculty_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or attendance_master.Faculty_Id =" , User_Id_, ")");
 #end if; 
 # SET Department_String =concat(Department_String," and (attendance_master.Faculty_Id in(select User_Selection_Id
 # from user_sub where user_sub.Users_Id=", User_Id_, " ) or attendance_master.Faculty_Id =" , User_Id_, ")");
	set Search_Date_=concat( " and attendance_master.Date >= '", Fromdate_ ,"' and  attendance_master.Date <= '", Todate_,"'");
#if User_Id_>0 then
	#SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",User_Id_);
#end if;
if Faculty_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_master.Faculty_Id =",Faculty_Id_);
end if;

if (Course_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_master.Course_Id =",Course_Id_);
end if;
/*if (Batch_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_master.Batch_Id =",Batch_Id_);
end if;*/

if Batch_Id_!=''   and   Batch_Id_!='0'  then
    set SearchbyName_Value=concat(" and attendance_master.Batch_Id in(",Batch_Id_,")");
end if;


if (Attendance_Status_Id=1) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_student.Attendance_Status =",1);
    elseif (Attendance_Status_Id=2) then 
		SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_student.Attendance_Status =",0);
end if;

SET @query = Concat("SELECT (Date_Format(attendance_master.Date,'%d-%m-%Y')) As Date,Student_Name Student,student.Student_Id,Year_Of_Passing,
Course.Course_Name Course,Batch_Name Batch,users.Users_Name Users,Student.ToUserName,
attendance_master.Duration,if(attendance_student.Attendance_Status>0,'Present','Absent') as Attendance_Status_Name,
student.District_Id ,state_district.District_Name,
(Date_Format(Batch.Start_Date,'%d-%m-%Y')) Start_Date,
(Date_Format(Batch.End_Date,'%d-%m-%Y')) End_Date,
Batch.Batch_Start_Time,Batch.Batch_End_Time,Phone
From attendance_master 
inner join attendance_student on attendance_master.Attendance_Master_Id=attendance_student.Attendance_Master_Id
inner join Student on Student.Student_Id=attendance_student.Student_Id
inner join Course on Course.Course_Id=attendance_master.Course_Id
inner join Batch on Batch.Batch_Id=attendance_master.Batch_Id
inner join users on users.Users_Id=attendance_master.Faculty_Id
inner join state_district on state_district.State_District_Id=student.District_Id
where  attendance_master.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
order by attendance_master.Attendance_Master_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Attendance_Student`(in Is_Date_ tinyint, Fromdate_ datetime,Todate_ datetime,
Course_Id_ int,Batch_Id_ int,Faculty_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and attendance_master.Date >= '", Fromdate_ ,"' and  attendance_master.Date <= '", Todate_,"'");
end if;
if Course_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_master.Course_Id =",Course_Id_);
end if;
if Batch_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_master.Batch_Id =",Batch_Id_);
end if;
if Faculty_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and attendance_master.Faculty_Id =",Faculty_Id_);
end if;

SET @query = Concat("SELECT attendance_master.Attendance_Master_Id,attendance_master.Duration,
(Date_Format(attendance_master.Date,'%d-%m-%Y')) As Date,attendance_master.Batch_Id,
users.Users_Name Faculty_Name,attendance_master.Course_Id,Course.Course_Name,Batch_Name
From attendance_master 
inner join Course on Course.Course_Id=attendance_master.Course_Id
inner join Batch on Batch.Batch_Id=attendance_master.Batch_Id
inner join users on users.Users_Id=attendance_master.Faculty_Id
where  attendance_master.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_," 
order by attendance_master.Attendance_Master_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch`( In Batch_Name_ varchar(100))
Begin 
 set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
 SELECT Batch_Id,
Batch_Name,(Date_Format(Start_Date,'%Y-%m-%d')) As Start_Date,
(Date_Format(End_Date,'%Y-%m-%d')) As End_Date,
 Course_Id , Course_Name , Trainer_Id , Trainer_Name ,Branch_Id ,
    Branch_Name ,Batch_Start_Time , Batch_End_Time,
User_Id From Batch where Batch_Name like Batch_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Completion`(IN Is_Date_Check_ TINYINT,Fromdate_ DATETIME,Todate_ DATETIME,Batch_Id_ INT,Search_Staff_ INT,Course_ INT,
User_Id_ INT,FollowUp_Branch_Id_ int
)
BEGIN

  DECLARE SearchbyName_Value VARCHAR(2000);
  DECLARE Search_Date_ VARCHAR(500);
  DECLARE Department_String VARCHAR(2000);
  DECLARE User_Type_ INT;

  SET SearchbyName_Value = '';
  SET Search_Date_ = '';
  SET Department_String = '';

  SET User_Type_ = (SELECT User_Type FROM users WHERE Users_Id = User_Id_);
  SET Department_String =concat(Department_String," and (batch.Trainer_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or batch.Trainer_Id =" , User_Id_, ")");
  
  IF Search_Staff_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Trainer_Id =", Search_Staff_);
  END IF;

  IF Batch_Id_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Batch_Id =", Batch_Id_);
  END IF;
  
    IF FollowUp_Branch_Id_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Branch_Id =", FollowUp_Branch_Id_);
  END IF;

  IF Course_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Course_Id =", Course_);
  END IF;


  IF Is_Date_Check_ > 0 THEN
     SET Search_Date_ = CONCAT(" AND batch.Start_Date >= '", Fromdate_, "' AND batch.Start_Date <= '", Todate_, "'");
  ELSE
    SET Search_Date_ = "AND 1 = 1";
  END IF;

# Batch_Id,Batch_Name,Branch_Name,Duration,Course_Name

SET @query = CONCAT(
    "SELECT batch.Batch_Id, batch.Batch_Name,count(Student_Id) as No_of_students,batch.Branch_Name,batch.Batch_Start_Time,
    (DATE_FORMAT(Batch_Complete_Date, '%d-%m-%Y')) AS Batch_Complete_Date, (DATE_FORMAT(batch.Start_Date, '%d-%m-%Y')) AS Start_Date,
    (DATE_FORMAT(batch.End_Date, '%d-%m-%Y')) AS End_Date, batch.Trainer_Name, Batch_Complete_Status,
    CASE 
        WHEN Batch_Complete_Status = 1 THEN 'Complete'
        ELSE 'Incomplete'
    END AS Batch_Complete_Status_Name
    FROM batch
    INNER JOIN student_course ON batch.Batch_Id = student_course.Batch_Id
    #INNER JOIN attendance_subject ON attendance_subject.Attendance_Master_Id = attendance_master.Attendance_Master_Id
    #INNER JOIN course_subject ON course_subject.Subject_Id = attendance_subject.Attendance_Subject_Id
     
    WHERE batch.DeleteStatus = 0 AND student_course.DeleteStatus = 0 ", Search_Date_, " ", Department_String, " ", SearchbyName_Value, "
    GROUP BY batch.Batch_Id, batch.Batch_Name, 
    batch.Start_Date, batch.End_Date, Trainer_Name
    ORDER BY batch.Batch_Id ASC;"
);


  PREPARE QUERY FROM @query;
  EXECUTE QUERY;
  #select @query;
 # INSERT INTO data_log_ VALUES (0, @query, '');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_End_Warning`(IN User_Id_ INT)
BEGIN
  DECLARE SearchbyName_Value VARCHAR(2000);
  DECLARE Search_Date_ VARCHAR(500);
  DECLARE Department_String VARCHAR(2000);
  DECLARE User_Type_ INT; DECLARE Fromdate_ DATETIME; DECLARE Is_Date_Check_ int;
  DECLARE Todate_ DATETIME;DECLARE Todate_1_ DATETIME;DECLARE Todate_2_ DATETIME;DECLARE Todate_3_ DATETIME;DECLARE Todate_4_ DATETIME;DECLARE Todate_5_ DATETIME;
  DECLARE Todate_6_ DATETIME;DECLARE Todate_7_ DATETIME;
  SET SearchbyName_Value = '';
  SET Search_Date_ = '';
  SET Department_String = '';
  SET Fromdate_ = curdate();
  SET Is_Date_Check_ = 1;
 /* SET User_Type_ = (SELECT User_Type FROM users WHERE Users_Id = User_Id_);
  SET Department_String = CONCAT(Department_String, " AND (batch.Trainer_Id IN (SELECT User_Selection_Id FROM user_sub WHERE user_sub.Users_Id = ", User_Id_, ")
  OR batch.Trainer_Id =", User_Id_, ")"); */
  
  
IF Is_Date_Check_ > 0 THEN
    SET Todate_ = DATE_ADD(Fromdate_, INTERVAL 15 DAY);
    SET Todate_1_ = DATE_ADD(Fromdate_, INTERVAL 10 DAY);
    SET Todate_2_ = DATE_ADD(Fromdate_, INTERVAL 5 DAY);
    SET Todate_3_ = DATE_ADD(Fromdate_, INTERVAL 4 DAY);
    SET Todate_4_ = DATE_ADD(Fromdate_, INTERVAL 3 DAY);
    SET Todate_5_ = DATE_ADD(Fromdate_, INTERVAL 2 DAY);
	SET Todate_6_ = DATE_ADD(Fromdate_, INTERVAL 1 DAY);
    SET Todate_7_ = DATE_ADD(Fromdate_, INTERVAL 0 DAY);
    
    SET Search_Date_ = CONCAT(" AND( (batch.End_Date = '", DATE_FORMAT(Todate_, '%Y-%m-%d'), "') or (batch.End_Date = '", DATE_FORMAT(Todate_1_, '%Y-%m-%d'), "') 
    or (batch.End_Date = '", DATE_FORMAT(Todate_2_, '%Y-%m-%d'), "')
    or (batch.End_Date = '", DATE_FORMAT(Todate_3_, '%Y-%m-%d'), "') 
    or (batch.End_Date = '", DATE_FORMAT(Todate_4_, '%Y-%m-%d'), "')
    or (batch.End_Date = '", DATE_FORMAT(Todate_5_, '%Y-%m-%d'), "')
    or (batch.End_Date = '", DATE_FORMAT(Todate_6_, '%Y-%m-%d'), "')
    or (batch.End_Date < CURDATE()  )
    or (batch.End_Date = '", DATE_FORMAT(Todate_7_, '%Y-%m-%d'), "'))");
 
END IF;


    /*IF User_Id_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " OR (batch.End_Date < CURDATE()  )");
  END IF;*/
  

  SET @query = CONCAT(
    "SELECT batch.Batch_Name, DATE_FORMAT(batch.End_Date, '%d-%m-%Y') AS End_Date, batch.Trainer_Name, batch.Batch_Complete_Status, Course_Name
    ,DATEDIFF(batch.End_Date, CURDATE()) AS datecount
    FROM batch
    WHERE batch.DeleteStatus = 0 and Batch_Complete_Status != 1 and batch.Trainer_Id= ",User_Id_,"  ", SearchbyName_Value, Search_Date_, "
    GROUP BY batch.Batch_Id, batch.Batch_Name, batch.Start_Date, batch.End_Date, Trainer_Name
    ORDER BY batch.Batch_Id ASC;"
  );

  PREPARE QUERY FROM @query;
  EXECUTE QUERY;
  #select @query;
  INSERT INTO data_log_ VALUES (0, @query, '');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Report`(in Is_Date_Check_ tinyint,
Fromdate_ datetime,Todate_ datetime,Batch_Id_ int,Search_Staff_ int,User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);
declare Department_String varchar(2000);declare User_Type_ int;declare User_Role_ int;
set SearchbyName_Value='';  set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
set User_Role_=(select Role_Id from users where Users_Id=User_Id_);

 if Search_Staff_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",Search_Staff_);
end if;

 if Batch_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Id =",Batch_Id_);
end if;
if Is_Date_Check_>0 then
    set Search_Date_=concat( " and student_course.Batch_Start_Date >= '", Fromdate_ ,"' and  student_course.Batch_Start_Date <= '", Todate_,"'");
    ELSE
    set Search_Date_= "and 1 =1 ";
end if;

if User_Type_ =2 and User_Role_!= 4  then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",User_Id_);
end if;

SET @query = Concat(" select Student_Name Student, Phone,student.Email,Year_Of_Passing,student_course.Batch_Name Batch,Faculty.Users_Name as Faculty,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,(Date_Format(student_course.End_Date,'%d-%m-%Y')) As End_Date,
Registered_By.Users_Name TeamMember,(Date_Format(student.Registered_On,'%d-%m-%Y')) As Registered_On,student_course.Laptop_details_Name Lapdetails,
student.Student_Id,student_course.Course_Name Course
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join users Registered_By on Registered_By.Users_Id=student.Registered_By
inner join users Faculty on Faculty.Users_Id=student_course.Faculty_Id
",SearchbyName_Value," ",Search_Date_," ",Department_String," where  student.DeleteStatus=0 and student.Status not in(18,19) 
group by student.Student_Id,Student_Name ,student_course.Batch_Name,Phone,student.Email,Year_Of_Passing,(Date_Format(student_course.Start_Date,'%d-%m-%Y')) ,(Date_Format(student_course.End_Date,'%d-%m-%Y')) ,(Date_Format(student.Registered_On,'%d-%m-%Y')) ,
student_course.Course_Name,Registered_By.Users_Name ,Faculty.Users_Name ,student_course.Laptop_details_Name  order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;
EXECUTE QUERY;
select @query;
#insert into data_log_ values(0,@query,'');
#and student_fees_installment_details.Instalment_Date < now()
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Report_old`(in Is_Date_Check_ tinyint,
Fromdate_ datetime,Todate_ datetime,Batch_Id_ int,Search_Staff_ int,User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);
declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';  set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 /*if(SearchbyName_ !='') then
set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
SET SearchbyName_Value =   Concat( SearchbyName_Value," and ( student.Student_Name like '%",SearchbyName_ ,"%' or  replace(replace(student.Phone,'+',''),' ','') like '%",SearchbyName_ ,"%'
or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",SearchbyName_ ,"%' or  student.Email like '%",SearchbyName_ ,"%' or student.Alternative_Email like '%",SearchbyName_ ,"%' )") ;
end if;*/

#SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
#from user_sub where user_sub.Users_Id=", User_Id_, " ) or student.User_Id =" , User_Id_, ")");

 if Search_Staff_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",Search_Staff_);
end if;

 if Batch_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Id =",Batch_Id_);
end if;
if Is_Date_Check_>0 then
    set Search_Date_=concat( " and student_course.Batch_Start_Date >= '", Fromdate_ ,"' and  student_course.Batch_Start_Date <= '", Todate_,"'");
    ELSE
    set Search_Date_= "and 1 =1 ";
end if;
#insert into data_log_ values(0,@query,'');
#set Search_Date_=concat( " and date(student_fees_installment_details.Instalment_Date) > '", Fromdate_,"'" );
SET @query = Concat(" select  student.Student_Id,Student_Name Student,student_course.Batch_Name Batch,Phone,Year_Of_Passing,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_course.End_Date,'%d-%m-%Y')) As End_Date,
(Date_Format(student.Registered_On,'%d-%m-%Y')) As Registered_On,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
sum(student_fees_installment_details.Balance_Amount) as Amount,Fee_Paid FeePaid,
student_course.Course_Name Course,Registered_By.Users_Name TeamMember,
Faculty.Users_Name as Faculty,student_fees_installment_details.Balance_Amount Due_Amount,student_course.Laptop_details_Name Lapdetails
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join users Registered_By on Registered_By.Users_Id=student.Registered_By
inner join users Faculty on Faculty.Users_Id=student_course.Faculty_Id
inner join state_district on state_district.State_District_Id=student.District_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
 ",SearchbyName_Value," ",Search_Date_," ",Department_String," where  student.DeleteStatus=0 and student.Status not in(18,19) and student_fees_installment_master.DeleteStatus=0 and student_fees_installment_details.DeleteStatus=0
group by student.Student_Id,Student_Name ,student_course.Batch_Name,Phone,Year_Of_Passing,(Date_Format(student_course.Start_Date,'%d-%m-%Y')) ,(Date_Format(student_course.End_Date,'%d-%m-%Y')) ,(Date_Format(student.Registered_On,'%d-%m-%Y')) ,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) ,Fee_Paid ,student_course.Course_Name,Registered_By.Users_Name ,Faculty.Users_Name ,student_fees_installment_details.Balance_Amount,student_course.Laptop_details_Name  order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;
EXECUTE QUERY;
select @query;
#and student_fees_installment_details.Instalment_Date < now()
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Typeahead`(in Batch_Name_ varchar(100))
BEGIN
 set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
From Batch
where Batch.DeleteStatus=false
order by Batch_Name asc   ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Typeahead_1`(in Batch_Name_ varchar(100),Course_Id_ int)
BEGIN
 /*set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
select  Batch.Batch_Id,Batch_Name
From Batch
where Batch_Name like Batch_Name_  and Batch.DeleteStatus=false
order by Batch_Name asc   ;*/
select distinct batch.Batch_Id,batch.Batch_Name from course_batch
 inner join batch on course_batch.Batch_Id = batch.Batch_Id where course_batch.Course_Id= Course_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Typeahead_2`(in Batch_Name_ varchar(100),Course_Id_ int)
BEGIN
 set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
From Batch
where Batch.DeleteStatus=false and Course_Id=Course_Id_
order by Batch_Name asc   ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Typeahead_Attendance`(in Batch_Name_ varchar(100),Course_Id_ int,Login_User_ int)
BEGIN
declare user_type_ int;
set user_type_ =(select User_Type from users where Users_Id=Login_User_);
if(user_type_!=1) then
	set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
	select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date,Batch_Complete_Status
	From Batch
	where Batch.DeleteStatus=false and Course_Id=Course_Id_ and Trainer_Id=Login_User_
	order by Batch_Name asc   ;
else
	set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
	select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
	From Batch
	where Batch.DeleteStatus=false and Course_Id=Course_Id_ 
	order by Batch_Name asc   ;
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Typeahead_Attendance1`(in Batch_Name_ varchar(100),Course_Id_ int,Login_User_ int)
BEGIN
declare user_type_ int;
set user_type_ =(select User_Type from users where Users_Id=Login_User_);
if(user_type_!=1) then
set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date,Batch_Complete_Status
From Batch
where Batch.DeleteStatus=false and Course_Id=Course_Id_ and Trainer_Id=Login_User_ and (Batch_Complete_Status=0 or isnull(Batch_Complete_Status))
order by Batch_Name asc   ;
else
set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
From Batch
where Batch.DeleteStatus=false and Course_Id=Course_Id_  and (Batch_Complete_Status=0 or isnull(Batch_Complete_Status))
order by Batch_Name asc   ;
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Typeahead_Report`(in Batch_Name_ varchar(100),Login_User_ int)
BEGIN
declare user_type_ int;
set user_type_ =(select User_Type from users where Users_Id=Login_User_);
if(user_type_!=1) then
	set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
	select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
	From Batch
	where Batch.DeleteStatus=false  and Trainer_Id=Login_User_
	order by Batch_Name asc   ;
else
	set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
	select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
	From Batch
	where Batch.DeleteStatus=false  
	order by Batch_Name asc   ;
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Batch_Typeahead_Report_New`(in Batch_Name_ varchar(100),Login_User_ int,Trainer_ int)
BEGIN
declare user_type_ int;
set user_type_ =(select User_Type from users where Users_Id=Login_User_);
if(user_type_!=1) then
	set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
	select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
	From Batch
	where Batch.DeleteStatus=false  and Trainer_Id=Login_User_ and Batch_Complete_Status=0
	order by Batch_Name asc   ;
elseif(Trainer_>0) then
	set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
	select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
	From Batch
	where Batch.DeleteStatus=false  and Batch_Complete_Status=0 and Trainer_Id=Trainer_
	order by Batch_Name asc   ;
else
	set Batch_Name_ = Concat( '%',Batch_Name_ ,'%');
	select  Batch.Batch_Id,Batch_Name,Start_Date,End_Date
	From Batch
	where Batch.DeleteStatus=false  and Batch_Complete_Status=0
	order by Batch_Name asc   ;
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Branch_Typeahead`( In Branch_Name_ varchar(100))
Begin 
 set Branch_Name_ = Concat( '%',Branch_Name_ ,'%');
 SELECT Agent_Id,Agent_Name From agent where Agent_Name like Branch_Name_ and DeleteStatus=false 
 ORDER BY Agent_Name Asc LIMIT 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Branch_User_Typeahead`(In Branch_Id_ int,Users_Name_ varchar(100))
BEGIN 
 set Users_Name_ = Concat( '%',Users_Name_ ,'%');
SELECT
users.Users_Id,Users_Name from users 
inner join agent on users.Agent_Id=agent.Agent_Id and agent.Agent_Id=Branch_Id_
where Users_Name like Users_Name_ and users.DeleteStatus=false 
ORDER BY Users_Name Asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Candidate`( In Fromdate_ date,Todate_ date,
SearchbyName_ varchar(50),By_User_ int,Status_Id_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,Register_Value int)
Begin 
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare Search_By_Registered varchar(500);declare User_Status int;declare more_info int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10; set more_info=0;
 set SearchbyName_Value=''; set Search_Date_='';
 set User_Status= (select Working_Status from Users where Users_Id=Login_User_Id_ );
 if(SearchbyName_ !='') then
	set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
	SET SearchbyName_Value =   Concat( SearchbyName_Value," and Candidate.Candidate_Name like '%",SearchbyName_ ,"%' or  replace(replace(Candidate.Phone,'+',''),' ','') like '%",SearchbyName_ ,"%'
	or  replace(replace(Candidate.Whatsapp,'+',''),' ','')  like '%",SearchbyName_ ,"%' or  Candidate.Email like '%",SearchbyName_ ,"%' or Candidate.Alternative_Email like '%",SearchbyName_ ,"%' ") ;
end if;
if Register_Value=2 then
	Set SearchbyName_Value= Concat( SearchbyName_Value," and Candidate.Registered= ",1) ;
elseif Register_Value=3 then
    Set SearchbyName_Value= Concat( SearchbyName_Value," and Candidate.Registered= ",0) ;
end if;
if By_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Candidate.By_User_Id =",By_User_);
end if;
if Status_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Candidate.Status =",Status_Id_);
end if;
if(SearchbyName_ !='') then
	set Is_Date_Check_=false;
end if;
if Is_Date_Check_=true then
	set Search_Date_=concat( " and date(Candidate.Next_FollowUp_Date) >= '", Fromdate_ ,"' and  
    date(Candidate.Next_FollowUp_Date) <= '", Todate_,"'");
	set Search_Date_union=concat( " and  date(Candidate.Next_FollowUp_Date) < '", Fromdate_,"'");
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
if User_Status=1 then
if Is_Date_Check_=true then

#inner join user_details on user_details.User_Details_Id=Candidate.User_Id
#inner join user_details as B on B.User_Details_Id=Candidate.By_User_Id
#B.User_Details_Name Registered_By_Name,
set UnionQuery=concat("  union select * from(select  CAST(CAST(2 AS UNSIGNED) AS SIGNED)   as tp,Candidate.Candidate_Id,
Candidate.Candidate_Name,Candidate.Phone,Candidate.Remark,(Date_Format(Candidate.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Status.Status_Name,T.Users_Name Users_Name,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Candidate.Candidate_Id DESC,Candidate.Next_FollowUp_Date desc)AS UNSIGNED)AS SIGNED)AS
RowNo,Candidate.Registered,1 as User_Status,0 as more_info
from Candidate
inner join Status on Status.Status_Id=Candidate.Status
inner join Users as T on T.Users_Id=Candidate.To_User_Id
where Candidate.DeleteStatus=0    ",SearchbyName_Value, " " ,Search_Date_union,"
)as lds WHERE RowNo >=",RowCount," AND RowNo<= ",RowCount2
);
end if;
SET @query = Concat( "select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,Candidate.Candidate_Id,
Candidate.Candidate_Name,Candidate.Phone,Candidate.Remark,(Date_Format(Candidate.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
Status.Status_Name,T.Users_Name Users_Name,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Candidate.Candidate_Id DESC,Candidate.Next_FollowUp_Date desc)AS UNSIGNED)AS SIGNED)AS
RowNo,Candidate.Registered,1 as User_Status,0 as more_info
from Candidate
inner join Status on Status.Status_Id=Candidate.Status
inner join Users as T on T.Users_Id=Candidate.To_User_Id
where Candidate.DeleteStatus=0 ", SearchbyName_Value," ",Search_Date_,"
)as lds  WHERE RowNo >=",Page_Index1_," AND RowNo<= ", Page_Index2_,UnionQuery,"
)as ldtwo order by tp, RowNo LIMIT ",PageSize
);

PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
else
 select 2 as User_Status;
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Candidate_Followup`( In Candidate_Followup_Name_ varchar(100))
Begin 
 set Candidate_Followup_Name_ = Concat( '%',Candidate_Followup_Name_ ,'%');
 SELECT Candidate_Followup_Id,
Candidate_Id,
Entry_Date,
Next_FollowUp_Date,
FollowUp_Difference,
Status,
User_Id,
Remark,
Remark_Id,
FollowUp_Type,
FollowUP_Time,
Actual_FollowUp_Date,
Entry_Type From Candidate_Followup where Candidate_Followup_Name like Candidate_Followup_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Candidate_Job_Apply`( In Candidate_Job_Apply_Name_ varchar(100))
Begin 
 set Candidate_Job_Apply_Name_ = Concat( '%',Candidate_Job_Apply_Name_ ,'%');
 SELECT Candidate_Job_Apply_Id,
Candidate_Id,
Entry_Date,
Skills,
Designation,
Functional_Area_Id,
Functional_Area_Name,
Specialization_Id,
Specialization_Name,
Experience_Id,
Experience_Name,
Qualification_Id,
Qualification_Name,
Remark,
Resume,
Experience_Certificate,
Photo,
Status_Id,
Status_Name,
User_Id From Candidate_Job_Apply where Candidate_Job_Apply_Name like Candidate_Job_Apply_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Category`( In Category_Name_ varchar(100))
Begin 
 set Category_Name_ = Concat( '%',Category_Name_ ,'%');
 SELECT Category_Id,
Category_Name,
Commision_Percentage,
User_Id From Category where Category_Name like Category_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Certificates`( In Certificates_Name_ varchar(100))
Begin 
 set Certificates_Name_ = Concat( '%',Certificates_Name_ ,'%');
 SELECT Certificates_Id,
Certificates_Name,
User_Id From Certificates where Certificates_Name like Certificates_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Certificate_Report`(in Is_Date_Check_ tinyint,
Fromdate_ datetime,Todate_ datetime,Batch_Id_ int,Search_Staff_ int,User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);
declare Department_String varchar(2000);declare User_Type_ int;declare User_Role_ int;
set SearchbyName_Value='';  set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
set User_Role_=(select Role_Id from users where Users_Id=User_Id_);

 if Search_Staff_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",Search_Staff_);
end if;

 if Batch_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Id =",Batch_Id_);
end if;
if Is_Date_Check_>0 then
    set Search_Date_=concat( " and student_course.Batch_Start_Date >= '", Fromdate_ ,"' and  student_course.Batch_Start_Date <= '", Todate_,"'");
    ELSE
    set Search_Date_= "and 1 =1 ";
end if;

if User_Type_ =2 and User_Role_!= 4  then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",User_Id_);
end if;

SET @query = Concat(" select Student_Name Student, student.Phone,student.Email,Year_Of_Passing,student_course.Batch_Name Batch,Faculty.Users_Name as Faculty,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,(Date_Format(student_course.End_Date,'%d-%m-%Y')) As End_Date,
Registered_By.Users_Name TeamMember,(Date_Format(student.Registered_On,'%d-%m-%Y')) As Registered_On,student_course.Laptop_details_Name Lapdetails,
student.Student_Id,student_course.Course_Name Course,
(Date_Format(Download_Date,'%d-%m-%Y-%h:%i')) As Download_Date,student_course.Course_Name,agent.Agent_Name,ToUserName as T_member
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join users Team_Member on Team_Member.Users_Id=student.User_Id
inner join users Registered_By on Registered_By.Users_Id=student.Registered_By
inner join users Faculty on Faculty.Users_Id=student_course.Faculty_Id
inner join download_certificate on download_certificate.Student_Id=student.Student_Id
inner join agent on agent.Agent_Id=student_course.Batch_Branch_Id
",SearchbyName_Value," ",Search_Date_," ",Department_String," where  student.DeleteStatus=0 and student.Status not in(18,19)
  order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;
EXECUTE QUERY;
select @query;
#insert into data_log_ values(0,@query,'');
#and student_fees_installment_details.Instalment_Date < now()
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Certificate_Request`( In Certificate_Request_Name_ varchar(100))
Begin 
 set Certificate_Request_Name_ = Concat( '%',Certificate_Request_Name_ ,'%');
 SELECT Certificate_Request_Id,
Student_Id,
Date,
Certificates_Id,
Status From Certificate_Request where Certificate_Request_Name like Certificate_Request_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Company_List_Report`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Company_id_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(employer_details.Entry_Date) >= '", Fromdate_ ,"' and  date(employer_details.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

if Company_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and employer_details.Employer_Details_Id =",Company_id_);
end if;

SET @query = Concat("select * from(SELECT Employer_Details_Id,Company_Name,Contact_Person,Contact_Number,Email_Id,Company_Location,Website,
(Date_Format(employer_details.Entry_Date,'%d-%m-%Y')) As Entry_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY employer_details.Employer_Details_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From employer_details
where employer_details.Delete_Status=false " ,SearchbyName_Value , " ",Search_Date_,") as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );

PREPARE QUERY FROM @query;EXECUTE QUERY;
insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Company_Typeahead`( In Company_Name_ varchar(100))
Begin
 set Company_Name_ = Concat( '%',Company_Name_ ,'%');
select  employer_details.Employer_Details_Id,Company_Name,Contact_Person,Contact_Number,Email_Id,Company_Location,Website
From employer_details
where employer_details.Delete_Status=false
order by Company_Name ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Company_Typeahead_For_Report`( In Company_Name_ varchar(100))
Begin
 set Company_Name_ = Concat( '%',Company_Name_ ,'%');
select  Company_Id,Company_Name
From job_posting
where DeleteStatus=false
order by Company_Name ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Complaint`( In  Student_Id_ INT)
Begin 
 SELECT Complaint_Id , Student_Id  Description  ,(Date_Format(Entry_Date,'%d-%m-%Y-%h:%i')) As Entry_Date  From complaint where Student_Id =Student_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Complaint_Details`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Status_ int,Login_User_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';

if Is_Date_>0 then
	set Search_Date_=concat( " and date(complaint.Entry_Date) >= '", Fromdate_ ,"' and  date(complaint.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;


if Status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and complaint.Complaint_Status =",Status_);
end if;


SET @query = Concat("select * from(SELECT Complaint_Id,Student_Name,student.Phone Mobile,complaint.Student_Id,Description, 
DATE_FORMAT(complaint.Entry_Date, '%d-%m-%Y') AS Entry_Date,Complaint_Status,
CASE Complaint_Status
                WHEN 1 THEN 'Pending'
                WHEN 2 THEN 'Solved'
                ELSE ''
            END AS Complaint_Status_Name,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY complaint.Complaint_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From complaint
inner join student on student.Student_Id=complaint.Student_Id
where complaint.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_,") as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );

PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Conversion_Report`(in Is_Date_ tinyint,Todate_ datetime,Login_User_Id_ int,User_Id_ varchar(200))
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
declare Fromdate_ datetime;
set Fromdate_ =(SELECT DATE_SUB(Todate_, INTERVAL 90 DAY));
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_Id_);
SET Department_String =concat(Department_String," and (student.Student_Owner_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.Student_Owner_Id =" , Login_User_Id_, ")");
 #end if;  
if Is_Date_>0 then
set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
    ELSE
set Search_Date_= "and 1 =1 ";
end if;
if User_Id_!=''   and   User_Id_!='0'  then
    set SearchbyName_Value=concat(" and student.Student_Owner_Id in(",User_Id_,")");
end if;

SET @query = Concat( "
SELECT count(student.Student_Id) lead_count,sum(student.Registered) admission_count,
        Round(((sum(student.Registered)/count(student.Student_Id))*100),2)conversion_count ,Registered_By.Users_Name TeamMember
From student
inner join users Registered_By on Registered_By.Users_Id=student.Student_Owner_Id and Registered_By.working_status=1
where  student.DeleteStatus=false and Registered_By.Users_Id not in (1) " ,SearchbyName_Value , " ",Search_Date_," ",Department_String," group by TeamMember
" );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
#insert into data_log_ values(0,@query,'');
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Conversion_Report_loginuser`(in Is_Date_ tinyint,Todate_ datetime,Login_User_Id_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
declare Fromdate_ datetime;
set Fromdate_ =(SELECT DATE_SUB(Todate_, INTERVAL 90 DAY));
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;
if Login_User_Id_!=''   and   Login_User_Id_!='0'  then
    set SearchbyName_Value=concat(" and student.Student_Owner_Id in(",Login_User_Id_,")");
end if;

SET @query = Concat( "
SELECT count(student.Student_Id) lead_count,sum(student.Registered) admission_count,
        Round(((sum(student.Registered)/count(student.Student_Id))*100),2)conversion_count ,Registered_By.Users_Name TeamMember
From student
inner join users Registered_By on Registered_By.Users_Id=student.Student_Owner_Id
where  student.DeleteStatus=false and Registered_By.Users_Id not in (1) " ,SearchbyName_Value , " ",Search_Date_," ",Department_String," group by TeamMember
" );
PREPARE QUERY FROM @query;
EXECUTE QUERY;
insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Conversion_Report_Old`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Login_User_Id_ int,User_Id_ varchar(200))
BEGIN 
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_Id_);
 #if User_Type_=2 then
 	 #SET Department_String =concat(Department_String," and student.By_User_Id =",Login_User_Id_);
 #else
	SET Department_String =concat(Department_String," and (student.By_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.By_User_Id =" , Login_User_Id_, ")");
 #end if;   
if Is_Date_>0 then
	set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;


if User_Id_!=''   and   User_Id_!='0'  then
    set SearchbyName_Value=concat(" and student.By_User_Id in(",User_Id_,")");
end if;



SET @query = Concat("SELECT  admission_count,lead_count,Round(((admission_count/lead_count)*100),2)as convesion_count, lead_query.TeamMember
FROM (
    SELECT COUNT(student.Student_Id) AS lead_count,
        (CASE WHEN student.Registered_By > 0 THEN Registered_By.Users_Name ELSE users.Users_Name END) AS TeamMember
    FROM student 
    INNER JOIN users ON users.Users_Id = student.By_User_Id
    LEFT JOIN users Registered_By ON Registered_By.Users_Id = student.Registered_By
    WHERE student.DeleteStatus = FALSE " ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
    GROUP BY student.User_Id
) AS lead_query
LEFT JOIN (
    SELECT COUNT(student.Student_Id) AS admission_count, Registered_By.Users_Name AS TeamMember
    FROM student 
    INNER JOIN student_course ON student_course.Student_Id = student.Student_Id
    INNER JOIN users Registered_By ON Registered_By.Users_Id = student.Registered_By
    WHERE student.DeleteStatus = FALSE " ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
    GROUP BY student.User_Id
) AS admission_query ON lead_query.TeamMember = admission_query.TeamMember 

" );
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Conversion_Report_old1`(in Is_Date_ tinyint,Todate_ datetime,Login_User_Id_ int,User_Id_ varchar(200))
BEGIN 
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
declare Fromdate_ datetime;
set Fromdate_ =(SELECT DATE_SUB(Todate_, INTERVAL 90 DAY));
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_Id_);
	SET Department_String =concat(Department_String," and (student.By_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.By_User_Id =" , Login_User_Id_, ")");
 #end if;   
if Is_Date_>0 then
	set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;
if User_Id_!=''   and   User_Id_!='0'  then
    set SearchbyName_Value=concat(" and student.By_User_Id in(",User_Id_,")");
end if;

SET @query = Concat("select lead_query.TeamMember,lead_count,admission_count,Round(((admission_count/lead_count)*100),2)conversion_count 
from(
		SELECT count(student.Student_Id) admission_count,Registered_By.Users_Name TeamMember
		From student 
		inner join student_course on student_course.Student_Id=student.Student_Id
		inner join users Registered_By on Registered_By.Users_Id=student.Registered_By
		inner join Enquiry_Source on Enquiry_Source.Enquiry_Source_Id=student.Enquiry_Source
		inner join Agent on Agent.Agent_Id=student.Agent_Id
		inner join state_district on state_district.State_District_Id=student.District_Id
		where  student.DeleteStatus=false and Registered_By.Users_Id not in (1) " ,SearchbyName_Value , " ",Search_Date_," ",Department_String," group by TeamMember)
	as admission_query
inner join
		(SELECT count(student.Student_Id)lead_count,(case when student.Registered_By>0 then Registered_By.Users_Name else users.Users_Name end) AS TeamMember
		From student 
		inner join users  on users.Users_Id=student.By_User_Id
		inner join Status on Status.Status_Id=student.Status
		inner join Enquiry_Source on Enquiry_Source.Enquiry_Source_Id=student.Enquiry_Source
		inner join Agent on Agent.Agent_Id=student.Agent_Id
		inner join Course on Course.Course_Id=student.Course_Id
		inner join state_district on state_district.State_District_Id=student.District_Id
		left join users Registered_By on Registered_By.Users_Id=student.Registered_By
		where  student.DeleteStatus=false 
        and Users.Users_Id not in (1)
        " ,SearchbyName_Value , " ",Search_Date_," ",Department_String," group by TeamMember)
	lead_query  on lead_query.TeamMember = admission_query.TeamMember

" );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
insert into data_log_ values(0,@query,'');
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course`( In Course_Name_ varchar(100),Course_Type_Id_ int)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(4000);
set Search_Date_="";set SearchbyName_Value=""; 

if Course_Name_ !='' then	
    SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Course_Name like '%",Course_Name_ ,"%'");
end if;
if Course_Type_Id_>0 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and Course.Course_Type_Id =",Course_Type_Id_);
end if;
 SET @query = Concat("SELECT Course_Id,Course_Name,Course_Type_Id,Course_Type_Name,
Duration,Agent_Amount,User_Id,Total_Fees,Fees_Type_Id
 From Course 
where  DeleteStatus=false " ,Search_Date_,SearchbyName_Value," order by Course.Course_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Fees`( In Course_Fees_Name_ varchar(100))
Begin 
 set Course_Fees_Name_ = Concat( '%',Course_Fees_Name_ ,'%');
 SELECT Course_Fees_Id,
Course_Id,
Fees_Type_Id,
Amount,
No_Of_Instalment,
Instalment_Period From Course_Fees where Course_Fees_Name like Course_Fees_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Import_Details`( In Course_Import_Details_Name_ varchar(100))
Begin 
 set Course_Import_Details_Name_ = Concat( '%',Course_Import_Details_Name_ ,'%');
 SELECT Course_Import_Details_Id,
Course_Import_Master_Id,
Course_Id From Course_Import_Details where Course_Import_Details_Name like Course_Import_Details_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Import_Master`( In Course_Import_Master_Name_ varchar(100))
Begin 
 set Course_Import_Master_Name_ = Concat( '%',Course_Import_Master_Name_ ,'%');
 SELECT Course_Import_Master_Id,
Date,
User_Id From Course_Import_Master where Course_Import_Master_Name like Course_Import_Master_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Part_Typeahead`(In Course_Id_ int,Part_Name_ varchar(45))
BEGIN
	select Part_Id,Part_Name from part where Part_Id in( select distinct Part_Id from course_subject where Course_Id=Course_Id_);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Subject`( In Course_Subject_Name_ varchar(100))
Begin 
 set Course_Subject_Name_ = Concat( '%',Course_Subject_Name_ ,'%');
 SELECT Course_Subject_Id,
Course_Id,
Part_Id,
Subject_Id,
Subject_Name,
Minimum_Mark,
Maximum_Mark,
Online_Exam_Status,
No_of_Question,
Exam_Duration From Course_Subject where Course_Subject_Name like Course_Subject_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Type`( In Course_Type_Name_ varchar(100))
Begin 
 set Course_Type_Name_ = Concat( '%',Course_Type_Name_ ,'%');
 SELECT Course_Type_Id,
Course_Type_Name,
User_Id From Course_Type where Course_Type_Name like Course_Type_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Course_Typeahead`(in Course_Name_ varchar(100))
BEGIN
 set Course_Name_ = Concat( '%',Course_Name_ ,'%');
select  Course.Course_Id,Course_Name
From Course
where  Course.DeleteStatus=false
order by Course_Name asc   ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_District_Typeahead`( In District_Name_ varchar(100))
Begin
 set District_Name_ = Concat( '%',District_Name_ ,'%');
select  State_District_Id,District_Name
From state_district
where state_district.DeleteStatus=false
order by District_Name ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Document`( In Document_Name_ varchar(100))
Begin 
 set Document_Name_ = Concat( '%',Document_Name_ ,'%');
 SELECT Document_Id,
Student_Id,
Document_Name,
Files From Document where Document_Name like Document_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_DropOut_Report`(in Is_Date_Check_ Tinyint,
Fromdate_ date,Todate_ date,Course_Id_ int,ToStaff_ varchar(200),User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';  set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);

SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
from user_sub where user_sub.Users_Id=", User_Id_, " ) or student.User_Id =" , User_Id_, ")");

if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Course_Id =",Course_Id_);
end if;

/*if ToStaff_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",ToStaff_);
end if;*/

if ToStaff_!=''   and   ToStaff_!='0'  then
    set SearchbyName_Value=concat(" and student.To_User_Id in(",ToStaff_,")");
end if;

/*if Is_Date_Check_=true then
set Search_Date_=concat( " and date(student_course.Join_Date) >= '", Fromdate_,"' and date(student_course.Join_Date) <= '", Todate_,"'" );
ELSE
set Search_Date_= " and 1 =1 ";
end if;*/

if Is_Date_Check_=true then
set Search_Date_=concat( " and date(student.DropOut_Date) >= '", Fromdate_,"' and date(student.DropOut_Date) <= '", Todate_,"'" );
ELSE
set Search_Date_= " and 1 =1 ";
end if;

SET @query = Concat(" select  student.Student_Id,Student_Name Student,Phone,ToUserName teammember,(Date_Format(student_course.Join_Date,'%d-%m-%Y')) As Join_Date,
#(Date_Format(student.DropOut_Date,'%d-%m-%Y')) As DropOut_Date,
student_course.Course_Name Course,student.Status,status.Status_Name,Year_Of_Passing,
(Date_Format(receipt_voucher.Date ,'%d-%m-%Y')) As First_Fees_Paid,
sum(Amount)TotalFeesPaid
From student
left join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join status on student.Status=status.Status_Id
left join receipt_voucher on student_course.Student_Course_Id=receipt_voucher.Student_Course_Id
  ",Department_String," where student.DeleteStatus=0 and student.Status=18 ",SearchbyName_Value," ",Search_Date_,"
group by student.Student_Id,Student_Name ,Phone,ToUserName ,(Date_Format(student_course.Join_Date,'%d-%m-%Y')) ,
student_course.Course_Name ,student.Status,status.Status_Name,Year_Of_Passing,
(Date_Format(receipt_voucher.Date ,'%d-%m-%Y'))  order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Employer_Details`( In Company_Name_ varchar(100))
Begin 
 set Company_Name_ = Concat( '%',Company_Name_ ,'%');
 SELECT Employer_Details_Id,
Company_Name,Contact_Person,Contact_Number,Email_Id,Company_Location,Website
 From Employer_Details where Company_Name like Company_Name_ and Delete_Status=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Employer_Status`( In Employer_Status_Name_ varchar(100))
Begin 
declare Status_Name_ varchar(100);
 set Status_Name_ = Concat( '%',Employer_Status_Name_ ,'%');
 SELECT Employer_Status_Id,Employer_Status_Name,FollowUp,
User_Id From Employer_Status where Employer_Status_Name like Status_Name_ and Group_Id=3 and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Employer_Status_Typeahead`( In Employer_Status_Name_ varchar(100))
Begin
 set Employer_Status_Name_ = Concat( '%',Employer_Status_Name_ ,'%');
select  Employer_Status_Id,Employer_Status_Name ,FollowUp,User_Id,Group_Id From employer_status where DeleteStatus=false and Group_Id=3
order by Order_By ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Enquiry_Source`( In Enquiry_Source_Name_ varchar(100))
Begin 
 set Enquiry_Source_Name_ = Concat( '%',Enquiry_Source_Name_ ,'%');
 SELECT Enquiry_Source_Id,
Enquiry_Source_Name,
User_Id From Enquiry_Source where Enquiry_Source_Name like Enquiry_Source_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Exam_Details`( In Exam_Details_Name_ varchar(100))
Begin 
 set Exam_Details_Name_ = Concat( '%',Exam_Details_Name_ ,'%');
 SELECT Exam_Details_Id,
Exam_Master_Id,
Question_Id,
Question_Name,
Option_1,
Option_2,
Option_3,
Option_4,
Question_Answer From Exam_Details where Exam_Details_Name like Exam_Details_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Exam_Master`( In Exam_Master_Name_ varchar(100))
Begin 
 set Exam_Master_Name_ = Concat( '%',Exam_Master_Name_ ,'%');
 SELECT Exam_Master_Id,
Exam_Date,
Student_Id,
Subject_Id,
Subject_Name,
Start_Time,
End_Time,
Mark_Obtained,
User_Id From Exam_Master where Exam_Master_Name like Exam_Master_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Experience`( In Experience_Name_ varchar(100))
Begin 
 set Experience_Name_ = Concat( '%',Experience_Name_ ,'%');
 SELECT Experience_Id,
Experience_Name,
User_Id From Experience where Experience_Name like Experience_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Faculty_Typeahead`(IN Users_Name_ varchar(100),
Role_Type_ int)
BEGIN
set Users_Name_ = Concat( '%',Users_Name_ ,'%');
#If(Role_Type_=0)
#then
#select Users.Users_Id,Users_Name,User_Role_Id
#from Users
#inner join user_role on user_role.User_Role_Id=Users.Role_Id
#where User_Role_Id not in (5) and Users.DeleteStatus=false; 
#else
select Users.Users_Id,Users_Name,User_Role_Id
from Users
inner join user_role on user_role.User_Role_Id=Users.Role_Id
where User_Role_Id in (5,4) and Users.DeleteStatus=false and Users.Working_Status=1
ORDER BY Users_Name Asc ;
#end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Collection_Report`(in Is_Date_ tinyint,  Fromdate_ datetime,Todate_ datetime,
User_Id_ int,Login_User_ int,Mode_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';
set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_);
#if User_Type_=2 then
 #    SET Department_String =concat(Department_String," and student.User_Id =",Login_User_);
#else
    SET Department_String =concat(Department_String," and (receipt_voucher.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_, " ) or receipt_voucher.User_Id=" , Login_User_, ")");
#end if;   
  

if Is_Date_>0 then
    set Search_Date_=concat( " and receipt_voucher.Date >= '", Fromdate_ ,"' and  receipt_voucher.Date <= '", Todate_,"'");
    ELSE
    set Search_Date_= "and 1 =1 ";
end if;
if User_Id_>0 then
    SET SearchbyName_Value =concat(SearchbyName_Value," and receipt_voucher.User_Id =",User_Id_);
end if;
if Mode_>0 then
    SET SearchbyName_Value =concat(SearchbyName_Value," and receipt_voucher.Payment_Mode =",Mode_);
end if;




SET @query = Concat("SELECT student.Student_Id,
(Date_Format(receipt_voucher.Date,'%d-%m-%Y')) As Date,
(Date_Format (receipt_voucher.Entry_Date,'%d-%m-%Y %H:%i')) As Entry_Date,Year_Of_Passing,
DATEDIFF( receipt_voucher.Entry_Date  , receipt_voucher.Date) as datediff,
receipt_voucher.Voucher_No,receipt_voucher.Date  as receipt_date,
receipt_voucher.Date as entrydate,
Student_Name Student,student_course.Course_Name Course,receipt_voucher.Amount,receipt_voucher.Description Remark,
users.Users_Name CollectedBy,student.District_Id ,state_district.District_Name,batch.Batch_Name,Mode_Name,
receipt_voucher.To_Account_Name as To_Account_Name,0 as Date_Difference
From student 
inner join student_course on student_course.Student_Id=student.Student_Id
inner join batch on batch.Batch_Id=student_course.Batch_Id
inner join receipt_voucher on receipt_voucher.Student_Course_Id=student_course.Student_Course_Id
inner join users on users.Users_Id=receipt_voucher.User_Id
inner join state_district on state_district.State_District_Id=student.District_Id
inner join mode on mode.Mode_Id = receipt_voucher.Payment_Mode
where  student.DeleteStatus=false and receipt_voucher.DeleteStatus=false" ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
order by receipt_voucher.Date DESC"  );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Due_Report`(in Is_Date_Check_ Tinyint,
Fromdate_ date,Todate_ date,Course_Id_ int,Batch_Id_ int,SearchbyName_ varchar(50),User_Id_ int,teammember_ varchar(200))
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';  set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 if(SearchbyName_ !='') then
set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
SET SearchbyName_Value =   Concat( SearchbyName_Value," and ( student.Student_Name like '%",SearchbyName_ ,"%' or  replace(replace(student.Phone,'+',''),' ','') like '%",SearchbyName_ ,"%'
or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",SearchbyName_ ,"%' or  student.Email like '%",SearchbyName_ ,"%' or student.Alternative_Email like '%",SearchbyName_ ,"%' )") ;
end if;
SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
from user_sub where user_sub.Users_Id=", User_Id_, " ) or student.User_Id =" , User_Id_, ")");

if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Course_Id =",Course_Id_);
end if;

/*if teammember_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",teammember_);
end if;*/

if teammember_!=''   and   teammember_!='0'  then
    set SearchbyName_Value=concat(" and student.To_User_Id in(",teammember_,")");
end if;

if Is_Date_Check_=true then
set Search_Date_=concat( " and date(student_fees_installment_details.Instalment_Date) >= '", Fromdate_,"' and date(student_fees_installment_details.Instalment_Date) <= '", Todate_,"'" );
ELSE
set Search_Date_= " and 1 =1 ";
end if;
#set Search_Date_=concat( " and date(student_fees_installment_details.Instalment_Date) > '", Fromdate_,"'" );
SET @query = Concat(" select  student.Student_Id,Student_Name Student,student_course.Batch_Name Batch,Phone,Year_Of_Passing,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
sum(student_fees_installment_details.Balance_Amount) as Amount,
student_course.Course_Name Course,
#users.Users_Name teammember,
ToUserName  teammember,
student.District_Id ,state_district.District_Name
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student.User_Id
inner join state_district on state_district.State_District_Id=student.District_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
 ",SearchbyName_Value," ",Search_Date_," ",Department_String," where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18,19) and student_fees_installment_master.DeleteStatus=0 and student_fees_installment_details.DeleteStatus=0
group by student.Student_Id,Student_Name,student_course.Batch_Name,Phone,Year_Of_Passing,Start_Date,student_fees_installment_details.Instalment_Date,
student_course.Course_Name,ToUserName,student.District_Id ,state_district.District_Name
order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;
#and student_fees_installment_details.Instalment_Date < now()
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Instalment`( In Fees_Instalment_Name_ varchar(100))
Begin 
 set Fees_Instalment_Name_ = Concat( '%',Fees_Instalment_Name_ ,'%');
 SELECT Fees_Instalment_Id,
Student_Id,
Course_Id,
Fees_Type_Id,
Instalment_Date,
Amount,
Status From Fees_Instalment where Fees_Instalment_Name like Fees_Instalment_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Outstanding_Report`(in Is_Date_Check_ Tinyint,
Fromdate_ date,Todate_ date,Course_Id_ int,Batch_Id_ int,SearchbyName_ varchar(50),User_Id_ int,teammember_ varchar(200))
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(500);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value='';  set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 if(SearchbyName_ !='') then
set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
SET SearchbyName_Value =   Concat( SearchbyName_Value," and ( student.Student_Name like '%",SearchbyName_ ,"%' or  replace(replace(student.Phone,'+',''),' ','') like '%",SearchbyName_ ,"%'
or  replace(replace(student.Whatsapp,'+',''),' ','')  like '%",SearchbyName_ ,"%' or  student.Email like '%",SearchbyName_ ,"%' or student.Alternative_Email like '%",SearchbyName_ ,"%' )") ;
end if;
#if User_Type_=2 then
 #	SET Department_String =concat(Department_String," and student.User_Id =",User_Id_);
#else
SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
from user_sub where user_sub.Users_Id=", User_Id_, " ) or student.User_Id =" , User_Id_, ")");
#end if;   
 #SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
#  from user_sub where user_sub.Users_Id=", User_Id_, " ) or student.User_Id =" , User_Id_, ")");
if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Course_Id =",Course_Id_);
end if;

/*if teammember_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",teammember_);
end if;*/

if teammember_!=''   and   teammember_!='0'  then
    set SearchbyName_Value=concat(" and student.To_User_Id in(",teammember_,")");
end if;

set Search_Date_=concat( " and date(student_fees_installment_details.Instalment_Date) <= '", Todate_,"' " );
#if User_Id_>0 then
#	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",User_Id_);
#end if;
/*if Batch_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Id =",Batch_Id_);Batch_Name,
end if;*/
SET @query = Concat(" select  student.Student_Id,Student_Name Student,student_course.Batch_Name Batch,Phone,Year_Of_Passing,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')) As StartDate,
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) As DueDate,
(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
sum(student_fees_installment_details.Balance_Amount) as Amount,
student_course.Course_Name Course,ToUserName teammember ,
student.District_Id ,state_district.District_Name,Remark,batch.Batch_Name
From student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join batch on batch.Batch_Id=student_course.Batch_Id
#inner join users on users.Users_Id=student.User_Id
inner join state_district on state_district.State_District_Id=student.District_Id
inner join student_fees_installment_master on student_fees_installment_master.Student_Id= student_course.Student_Id  and student_course.Student_Course_Id=student_fees_installment_master.Student_Course_Id
inner join student_fees_installment_details on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
 ",SearchbyName_Value," ",Search_Date_," ",Department_String," where student_fees_installment_details.Balance_Amount>0 and student.DeleteStatus=0 and student.Status not in(18,23) and student_fees_installment_details.DeleteStatus=0 and student_fees_installment_master.DeleteStatus=0
group by student.Student_Id,Student_Name,student_course.Batch_Name ,Phone,Year_Of_Passing,
(Date_Format(student_course.Start_Date,'%d-%m-%Y')),
(Date_Format(student_fees_installment_details.Instalment_Date,'%d-%m-%Y')) ,
(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')),student_course.Course_Name,ToUserName,
student.District_Id ,state_district.District_Name,Remark,batch.Batch_Name  order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;
EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
#and student_fees_installment_details.Instalment_Date < now()
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Receipt`( In Fees_Receipt_Name_ varchar(100))
Begin 
 set Fees_Receipt_Name_ = Concat( '%',Fees_Receipt_Name_ ,'%');
 SELECT Fees_Receipt_Id,
Fees_Installment_Id,
Course_Id,
Course_Name,
Student_Id,
Fees_Type_Id,
Fees_Type_Name,
Amount,
Date From Fees_Receipt where Fees_Receipt_Name like Fees_Receipt_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Fees_Type`( In Fees_Type_Name_ varchar(100))
Begin 
 set Fees_Type_Name_ = Concat( '%',Fees_Type_Name_ ,'%');
 SELECT Fees_Type_Id,
Fees_Type_Name,
User_Id From Fees_Type where Fees_Type_Name like Fees_Type_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Followup_Type`( In Followup_Type_Name_ varchar(100))
Begin 
 set Followup_Type_Name_ = Concat( '%',Followup_Type_Name_ ,'%');
 SELECT Followup_Type_Id,
Followup_Type_Name,
User_Id From Followup_Type where Followup_Type_Name like Followup_Type_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Functionl_Area`( In Functionl_Area_Name_ varchar(100))
Begin 
 set Functionl_Area_Name_ = Concat( '%',Functionl_Area_Name_ ,'%');
 SELECT Functionl_Area_Id,
Functionl_Area_Name,
User_Id From Functionl_Area where Functionl_Area_Name like Functionl_Area_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Interview`(in Is_Date_ tinyint,From_Date_ datetime,To_Date_ datetime,Course_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if (Is_Date_>0) then
	set Search_Date_=concat( " and Student.Resume_Send_Date >= '", From_Date_ ,"' and Student.Resume_Send_Date <= '", To_Date_,"'");
end if;
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Course_Id = ",Course_Id_);
#SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Id =",Batch_Id_);
SET @query = Concat("select Student.Student_Id,Student_Name,0 Check_Box,Course_Name
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id
where Placed=0 and  student_course.DeleteStatus=0 
and Student.DeleteStatus=0 and Student.status not in(18,19)" ,SearchbyName_Value , " ",Search_Date_," 
order by Student.Student_Name asc ,Student.Student_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Interview_Mobile`(In Student_Id_ int, Pointer_Start_ int ,
 Pointer_Stop_ int,Page_Length_ int)
Begin 
 
SET @query = Concat("select * from (select Job_Title,Descritpion,Job_Posting_Id,
(Date_Format(applied_jobs.Interview_Date,'%d-%m-%Y')) As Last_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo,Interview_Attending_Rejecting
from job_posting inner join applied_jobs on applied_jobs.job_id =Job_Posting_Id
WHERE job_posting.DeleteStatus = false and Interview_Status=1 and  Student_Id =",Student_Id_," ) as lds 
order by  RowNo  " );
#LIMIT,Page_Length_
#  WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"

PREPARE QUERY FROM @query;
EXECUTE QUERY;
#insert into db_logs values(3,Student_Id_,'');
#insert into db_logs values(2,@query,'');
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Interview_Report`(in Is_Date_ tinyint,
From_Date_ datetime,To_Date_ datetime,Course_Id_ int, Employer_Details_Id_ int,User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';
set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 #if User_Type_=2 then
# 	SET Department_String =concat(Department_String," and Interview_master.User_Id =",User_Id_);
#else
	SET Department_String =concat(Department_String," and (Interview_master.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or Interview_master.User_Id =" , User_Id_, ")");
#end if; 
  #SET Department_String =concat(Department_String," and (Interview_master.User_Id in(select User_Selection_Id
  #from user_sub where user_sub.Users_Id=", User_Id_, " ) or Interview_master.User_Id =" , User_Id_, ")");
if (Is_Date_>0) then
	set Search_Date_=concat( " and Interview_master.Interview_Date >= '", From_Date_ ,"' and Interview_master.Interview_Date <= '", To_Date_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

#if User_Id_>0 then
#	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",User_Id_);
#end if;

if (Course_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Interview_master.Course_Id =",Course_Id_);
end if;
if (Employer_Details_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Interview_master.Employer_Details_Id =",Employer_Details_Id_);
end if;
SET @query = Concat("select (Date_Format(Interview_master.Interview_Date,'%d-%m-%Y')) As InterviewDate,
Student_Name Student,student.Student_Id,Course_Name Course,Company_Name Company,users.Users_Name User,
Interview_master.Description,student.District_Id ,state_district.District_Name,Student.Year_Of_Passing AS Year_Of_Passing
from Interview_master
inner join Interview_student on Interview_master.Interview_Master_Id=Interview_student.Interview_Master_Id
inner join Student on Student.Student_Id=Interview_student.Student_Id
inner join Course on Course.Course_Id=Interview_master.Course_Id
inner join employer_details on employer_details.Employer_Details_Id=Interview_master.Employer_Details_Id
inner join users on users.Users_Id=Interview_master.User_Id
inner join state_district on state_district.State_District_Id=student.District_Id
where Interview_master.DeleteStatus=0 and Student.DeleteStatus=0" ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
order by interview_master.Interview_Date desc, interview_master.Interview_Master_Id asc  " );
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Interview_Report_Tab`(in Is_Date_ tinyint,
From_Date_ datetime,To_Date_ datetime,User_Id_ int,Student_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);

	SET Department_String =concat(Department_String," and (Interview_master.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or Interview_master.User_Id =" , User_Id_, ")");
  
if (Student_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and interview_student.Student_Id =",Student_Id_);
end if;
SET @query = Concat("select (Date_Format(Interview_master.Interview_Date,'%d-%m-%Y')) As InterviewDate,
Company_Name Company,
Interview_master.Description
from Interview_master
inner join Interview_student on Interview_master.Interview_Master_Id=Interview_student.Interview_Master_Id
inner join Student on Student.Student_Id=Interview_student.Student_Id
inner join employer_details on employer_details.Employer_Details_Id=Interview_master.Employer_Details_Id
inner join users on users.Users_Id=Interview_master.User_Id
where Interview_master.DeleteStatus=0 and Student.DeleteStatus=0" ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
order by interview_master.Interview_Date desc, interview_master.Interview_Master_Id asc  " );
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Interview_Scheduled_Details`(in Job_id_ int,Company_Id_ int,Interview_Date_ date,Interview_Time_ time,course_id_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);declare Is_Date_ int;
set SearchbyName_Value=''; set Search_Date_='';
set Is_Date_=1;
#if Is_Date_>0 then
	set Search_Date_=concat( " and date(applied_jobs.Interview_Date) >= '", Interview_Date_ ,"' and  date(applied_jobs.Interview_Date) <= '", Interview_Date_,"'");
   # ELSE
	#set Search_Date_= "and 1 =1 ";
#end if;

if Job_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and applied_jobs.Job_Id =",Job_id_);
end if;

if Interview_Time_!=null or Interview_Time_!="00:00:00" then
	SET SearchbyName_Value =concat(SearchbyName_Value," and applied_jobs.Interview_Time ='", Interview_Time_ ,"'");
else
  SET SearchbyName_Value =  concat(SearchbyName_Value," and isnull (applied_jobs.Interview_Time)");
end if;

/*if Interview_Time_=null or Interview_Time_="00:00:00" then
	SET SearchbyName_Value =concat(SearchbyName_Value," and applied_jobs.Interview_Time ='", null ,"'");
end if;*/


if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Company_Id =",Company_Id_);
end if;

if course_id_>0  then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Course_Id =",course_id_);
end if;

SET @query = Concat(" select Student_Name,Phone,Batch_Name,users.Users_Name as Trainer,job_posting.Course_Name,Applied_Jobs_Id,student.Student_Id from student 
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student_course.Faculty_Id
inner join applied_jobs on applied_jobs.Student_Id=student.Student_Id
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id where student.DeleteStatus=0 and 
student_course.DeleteStatus=0 and Interview_Status=1 " ,Search_Date_ , " " ,SearchbyName_Value , " " );

PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Interview_Scheduled_Summary`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime, Company_id_ int,Course_Id_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
set Search_Date_=concat( " and date(applied_jobs.Interview_Date) >= '", Fromdate_ ,"' and  date(applied_jobs.Interview_Date) <= '", Todate_,"'");
    ELSE
set Search_Date_= "and 1 =1 ";
end if;
if Company_id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Company_Id =",Company_id_);
end if;
if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Course_Id =",Course_Id_);
end if;
SET @query = Concat("select * from(SELECT  DATE_FORMAT(Interview_Date, '%d-%m-%Y') AS Interview_Date ,DATE_FORMAT(Interview_Date, '%Y-%m-%d') AS Interview_Date_s,
Interview_Time,count(Student_Id) as Student_Count,Company_Id,Company_Name,Job_Id,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY applied_jobs.Job_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From applied_jobs
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id
where job_posting.DeleteStatus=false and  applied_jobs.DeleteStatus=0 and Interview_Status=1 " ,SearchbyName_Value , " ",Search_Date_,"
group by Interview_Date,Interview_Time,Company_Id,Company_Name,applied_jobs.Job_Id) as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );
PREPARE QUERY FROM @query;EXECUTE QUERY;
insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Interview_Student`(in Is_Date_ tinyint, Fromdate_ datetime,Todate_ datetime,
Course_Id_ int,Faculty_Id_ int,Employer_Details_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';

if Is_Date_>0 then
	set Search_Date_=concat( " and Interview_master.Date >= '", Fromdate_ ,"' and  Interview_master.Date <= '", Todate_,"'");
end if;
if Course_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Interview_master.Course_Id =",Course_Id_);
end if;
if Employer_Details_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Interview_master.Employer_Details_Id =",Employer_Details_Id_);
end if;

if Faculty_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Interview_master.User_Id =",Faculty_Id_);
end if;

SET @query = Concat("SELECT Interview_master.Interview_Master_Id,Employer_Details.Employer_Details_Id,
(Date_Format(Interview_master.Date,'%d-%m-%Y')) As Date,Interview_master.User_Id,
(Date_Format(Interview_master.Interview_Date,'%Y-%m-%d')) As Interview_Date,
users.Users_Name Faculty_Name,Interview_master.Course_Id,Course_Name,Interview_master.Description,
Company_Name
From Interview_master 
inner join Course on Course.Course_Id=Interview_master.Course_Id
inner join users on users.Users_Id=Interview_master.User_Id
inner join Employer_Details on Employer_Details.Employer_Details_Id=Interview_master.Employer_Details_Id
where  Interview_master.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_," 
order by Interview_master.Interview_Master_Id desc " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Jobposting_Detailed_Report`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Company_ int,Job_ int,
Student_Status_ int,Blacklist_Status_ int,Activate_Status_ int,Fees_Status_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(applied_jobs.Entry_Date) >= '", Fromdate_ ,"' and  date(applied_jobs.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= " and 1 =1 ";
end if;

/*if(Company_ !='') then
		SET SearchbyName_Value =Concat( SearchbyName_Value," and job_posting.Company_Name like '%",Company_ ,"%'") ;
end if;

if(Job_ !='') then
		SET SearchbyName_Value =Concat( SearchbyName_Value," and job_posting.Job_Title like '%",Job_ ,"%'") ;
end if;*/
if Company_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Company_Id =",Company_);
end if;

if Job_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Posting_Id =",Job_);
end if;

if Student_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Student_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Student_Status =",Student_Status_);
end if;

if Student_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Student_Status =",Student_Status_);
end if;


if Blacklist_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Blacklist_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Blacklist_Status =",Blacklist_Status_);
end if;

if Blacklist_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Blacklist_Status =",Blacklist_Status_);
end if;


if Activate_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Activate_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Activate_Status =",Activate_Status_);
end if;

if Activate_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Activate_Status =",Activate_Status_);
end if;


if Fees_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Fees_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Fees_Status =",Fees_Status_);
end if;

if Fees_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Fees_Status =",Fees_Status_);
end if;


SET @query = Concat("SELECT job_posting.Job_Title Job,Company_Name,(Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) As Applied_date,Student_Name,Year_Of_Passing,Interview_Status,
(Date_Format(Interview_Date,'%d-%m-%Y')) As Interview_Date,Interview_Description,Placement_Status,
(Date_Format(Placement_Date,'%d-%m-%Y')) As Placement_Date,Placement_Description,Resume_Status_Name,Student_Status,Blacklist_Status,Activate_Status,Fees_Status,Student.Student_Id
From student
inner join applied_jobs on Student.Student_Id=applied_jobs.Student_Id
inner join job_posting on applied_jobs.Job_Id=job_posting.Job_Posting_Id
where   Student.DeleteStatus=0 and Student.Registered=1 and applied_jobs.DeleteStatus =0 and job_posting.DeleteStatus=0
" ,SearchbyName_Value , " ",Search_Date_," 
order by Student.Student_Id ASC 
" );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Jobposting_Summary`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Job_id_ varchar(100),Company_id_ int,Course_Id_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(job_posting.Entry_Date) >= '", Fromdate_ ,"' and  date(job_posting.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

/*if(Job_Title_ !='') then
		SET SearchbyName_Value =Concat( SearchbyName_Value," and job_posting.Job_Title like '%",Job_Title_ ,"%'") ;
end if;*/

/*if(Company_Name_ !='') then
		SET SearchbyName_Value =Concat( SearchbyName_Value," and job_posting.Company_Name like '%",Company_Name_ ,"%'") ;
end if;
*/
if Company_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Company_Id =",Company_id_);
end if;

if Job_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Posting_Id =",Job_id_);
end if;
if Course_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Course_Id =",Course_Id_);
end if;

SET @query = Concat("select * from(SELECT Job_Title,Company_Name,Applied_Count,Reject_Count,Job_Posting_Id,  DATE_FORMAT(Last_Date, '%d-%m-%Y') AS Last_Date, 
 DATE_FORMAT(Entry_Date, '%d-%m-%Y') AS Entry_Date,No_Of_Vaccancy,Course_Name,Salary,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY job_posting.Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From job_posting
where job_posting.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_,") as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );

PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Job_Mobile`(In Student_Id_ int, Pointer_Start_ int ,
 Pointer_Stop_ int,Page_Length_ int)
Begin 
 
SET @query = Concat("select * from (select Job_Title,SUBSTRING(Descritpion,1,5) as Descritpion,Job_Posting_Id,
(Date_Format(job_posting.Last_Date,'%d-%m-%Y')) As Last_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from job_posting  inner join job_candidate on job_candidate.job_id =job_posting.Job_Posting_Id  and Candidate_Id =",Student_Id_,"
 and job_posting.Last_Date >= curDate() 
WHERE job_posting.DeleteStatus = false and Job_Posting_Id not in 
(select Job_Id from  applied_jobs where Student_Id =",Student_Id_,") ) as lds 
order by  RowNo  " );

#LIMIT,Page_Length_
#  WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"

PREPARE QUERY FROM @query;

EXECUTE QUERY;

 select  student_course.Course_Name,Duration,Batch_Complete_Status ,
(Date_Format(Batch_Complete_Date ,'%d-%m-%Y')) As Batch_Complete_Date,
(Date_Format(batch.Start_Date ,'%d-%m-%Y')) As Start_Date
 from student_course inner join batch on
batch.batch_id=student_course.batch_id  where Student_Id =Student_Id_ limit 1;


#SELECT  Student_Status ,Resume_Status_Id  ,Resume_Status_Name,Resume,Image_ResumeFilename
 # From student where Student_Id =Student_Id_ and DeleteStatus=false ;

#insert into db_logs values(3,Student_Id_,'');
#insert into db_logs values(2,@query,'');
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Job_Opening`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Job_id_ varchar(100),Company_id_ int,Employee_Status_Id_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(job_opening.Next_Followup_Date) >= '", Fromdate_ ,"' and  date(job_opening.Next_Followup_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

if Company_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_opening.Comapny_Id =",Company_id_);
end if;

if Job_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_opening.Job_Opening_Id =",Job_id_);
end if;
if Employee_Status_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_opening.Employee_Status_Id =",Employee_Status_Id_);
end if;

SET @query = Concat("select * from(SELECT Job_Opening_Id,Job_Title,Comapny_Id,Company_Name,Contact_No,No_of_Vacancy,Salary,Location,Employee_Status_Id,
Employee_Status_Name,To_Staff_Id,To_Staff_Name,Remark,Contact_Person,Email,Address,Website,Gender_Id,Gender_Name,Job_Opening_Description,By_User_Id,By_User_Name,
 DATE_FORMAT(Next_Followup_Date, '%d-%m-%Y') AS Next_Followup_Date, DATE_FORMAT(Next_Followup_Date, '%Y-%m-%d') AS Next_Followup_Date1, DATE_FORMAT(Entry_Date, '%d-%m-%Y') AS Entry_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY job_opening.Job_Opening_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo,Vacancy_Source_Id,Vacancy_Source_Name,Followup
From job_opening
where job_opening.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_,") as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );

PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Job_Posting`( In Job_Code_ varchar(100),Job_id_ int,Job_Location_ varchar(100),Company_id_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
Begin 
declare SearchbyName_Value varchar(4000);set SearchbyName_Value=""; 


if Company_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Company_Id =",Company_id_);
end if;

if Job_Code_ !='' then	
    SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Code like '%",Job_Code_ ,"%'");
end if;
/*if Job_Title_ !='' then	
    SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Title like '%",Job_Title_ ,"%'");
end if;*/
if Job_id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Posting_Id =",Job_id_);
end if;
if Job_Location_ !='' then	
    SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Location like '%",Job_Location_ ,"%'");
end if;
/*if Experience_>0 then
  SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Experience =",Experience_);
end if;*/
 SET @query = Concat("select * from(SELECT Job_Posting_Id,Job_Code,Job_Title,Job_Location,Company_Name,
Experience,Experience_Name,No_Of_Vaccancy,Salary,Company_Id,(Date_Format(job_posting.Entry_Date,'%d-%m-%Y')) As Entry_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY job_posting.Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
From job_posting 
where  job_posting.DeleteStatus=false " ,SearchbyName_Value ,") as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Job_Rejections`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime)
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(applied_jobs.Entry_Date) >= '", Fromdate_ ,"' and  date(applied_jobs.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= " and 1 =1 ";
end if;

SET @query = Concat("SELECT job_posting.Job_Title Job,Company_Name,(Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) As Reject_date,Student_Name,applied_jobs.Remark
From  applied_jobs
inner join student on Student.Student_Id=applied_jobs.Student_Id
inner join job_posting on applied_jobs.Job_Id=job_posting.Job_Posting_Id
where   Student.DeleteStatus=0 and Student.Registered=1 and applied_jobs.DeleteStatus =0 and job_posting.DeleteStatus=0 and Apply_Type=2
" ,SearchbyName_Value , " ",Search_Date_," 
order by Student.Student_Id ASC 
" );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Job_Typeahead`( In Job_Title_ varchar(100))
Begin
 set Job_Title_ = Concat( '%',Job_Title_ ,'%');
select  Job_Posting_Id,Job_Title
From job_posting
where DeleteStatus=false
order by Job_Posting_Id ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Lead_Report`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Enquiry_Source_ int,Login_User_Id_ int,User_Id_ varchar(200),status_ int,Course_Id_ int)
BEGIN 
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';
set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=Login_User_Id_);
 #if User_Type_=2 then
 	 #SET Department_String =concat(Department_String," and student.By_User_Id =",Login_User_Id_);
 #else
	SET Department_String =concat(Department_String," and (student.By_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.By_User_Id =" , Login_User_Id_, ")");
 #end if;   
if Is_Date_>0 then
	set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

/*if User_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.By_User_Id =",User_Id_);
end if;*/

if User_Id_!=''   and   User_Id_!='0'  then
    set SearchbyName_Value=concat(" and student.By_User_Id in(",User_Id_,")");
end if;


if status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status =",status_);
end if;

if Course_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Course_Id =",Course_Id_);
end if;


if Enquiry_Source_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiry_Source =",Enquiry_Source_);
end if;
/*student_course.Course_Name Course,*/
SET @query = Concat("SELECT student.Student_Id,Student_Name Student,student.Phone,student.Email,
(Date_Format(student.Entry_Date,'%d-%m-%Y')) As EnquiryDate,student.Course_Id,Year_Of_Passing,
Course_Name,
Status.Status_Name EnquiryStatus,Enquiry_Source.Enquiry_Source_Name EnquirySource,student.Registered,
Agent.Agent_Name Branch,student.Address1 as Location,student.District_Id ,state_district.District_Name,
(case when student.Registered_By>0 then Registered_By.Users_Name else users.Users_Name end) AS TeamMember,
student.Registered_By 
  
From student 

inner join users  on users.Users_Id=student.By_User_Id
/*inner join student_course on student_course.Student_Id=student.Student_Id*/
inner join Status on Status.Status_Id=student.Status
inner join Enquiry_Source on Enquiry_Source.Enquiry_Source_Id=student.Enquiry_Source
inner join Agent on Agent.Agent_Id=student.Agent_Id
inner join Course on Course.Course_Id=student.Course_Id
inner join state_district on state_district.State_District_Id=student.District_Id
left join users Registered_By on Registered_By.Users_Id=student.Registered_By
where  student.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_," ",Department_String,"
order by student.Student_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Mark_List`( In Mark_List_Name_ varchar(100))
Begin 
 set Mark_List_Name_ = Concat( '%',Mark_List_Name_ ,'%');
 SELECT Mark_List_Id,
Student_Id,
Course_Id,
Course_Name,
Subject_Id,
Subject_Name,
Minimum_Mark,
Maximum_Mark,
Mark_Obtained,
User_Id From Mark_List where Mark_List_Name like Mark_List_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Offered_Mobile`(In Student_Id_ int, Pointer_Start_ int ,
 Pointer_Stop_ int,Page_Length_ int)
Begin 
 
SET @query = Concat("select * from (select Job_Title,SUBSTRING(Descritpion,1,5) as Descritpion,Job_Posting_Id,
(Date_Format(job_posting.Entry_Date,'%d-%m-%Y')) As Last_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from job_posting inner join job_candidate on job_candidate.job_id =Job_Posting_Id
WHERE job_posting.DeleteStatus = false and Candidate_Id =",Student_Id_," ) as lds 
order by  RowNo  " );
#LIMIT,Page_Length_
#  WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"

PREPARE QUERY FROM @query;
EXECUTE QUERY;
#insert into db_logs values(3,Student_Id_,'');
#insert into db_logs values(2,@query,'');
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Part`( In Part_Name_ varchar(100))
Begin 
 set Part_Name_ = Concat( '%',Part_Name_ ,'%');
 SELECT Part_Id,
Part_Name,
User_Id From Part where Part_Name like Part_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Part_Subject_Typeahead`(In Course_Id_ int,Part_Id_ int,Subject_Name_ varchar(45))
BEGIN
	select Subject_Id,Subject_Name from subject where Subject_Id in( select distinct Subject_Id from course_subject where Course_Id=Course_Id_ and Part_Id= Part_Id_);

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Part_Typeahead`( In Part_Name_ varchar(100))
Begin
 set Part_Name_ = Concat( '%',Part_Name_ ,'%');
select  part.Part_Id,Part_Name
From part
where Part_Name like Part_Name_  and part.DeleteStatus=false
order by Part_Name asc   ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Period`( In Period_Name_ varchar(100))
Begin 
 set Period_Name_ = Concat( '%',Period_Name_ ,'%');
 SELECT Period_Id,
Period_Name,(Date_Format(Period_From,'%Y-%m-%d')) As Period_From,
(Date_Format(Period_To,'%Y-%m-%d')) As Period_To,Duration From Period where Period_Name like Period_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Placed`(in Is_Date_ tinyint,
From_Date_ datetime,To_Date_ datetime,Course_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if (Is_Date_>0) then
	set Search_Date_=concat( " and Student.Interview_Schedule_Date >= '", From_Date_ ,"' and Student.Interview_Schedule_Date <= '", To_Date_,"'");
end if;
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Course_Id =",Course_Id_);
#SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Batch_Id =",Batch_Id_);

SET @query = Concat("select Student.Student_Id,Student_Name,0 Check_Box,Course_Name
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id
where Interview_Schedule=1 and Placed = 0 and student_course.DeleteStatus=0 
and Student.DeleteStatus=0 and Student.status not in(18,19)" ,SearchbyName_Value , " ",Search_Date_," 
order by Student.Student_Name asc, Student.Student_Id ASC " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Placed_Mobile`(In Student_Id_ int, Pointer_Start_ int ,
 Pointer_Stop_ int,Page_Length_ int)
Begin 
 
SET @query = Concat("select * from (select Job_Title,Descritpion,Job_Posting_Id,
(Date_Format(applied_jobs.Placement_Date,'%d-%m-%Y')) As Last_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from job_posting inner join applied_jobs on applied_jobs.job_id =Job_Posting_Id
WHERE job_posting.DeleteStatus = false and Placement_Status=1 and  Student_Id =",Student_Id_," ) as lds 
order by  RowNo  " );
#LIMIT,Page_Length_
#  WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"

PREPARE QUERY FROM @query;
EXECUTE QUERY;
#insert into db_logs values(3,Student_Id_,'');
#insert into db_logs values(2,@query,'');
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Placed_Report`(in Is_Date_ tinyint,
From_Date_ datetime,To_Date_ datetime,Course_Id_ int, Employer_Details_Id_ int,User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 #if User_Type_=2 then
 	#SET Department_String =concat(Department_String," and Placed_master.User_Id =",User_Id_);
#else
	SET Department_String =concat(Department_String," and (Placed_master.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or Placed_master.User_Id =" , User_Id_, ")");
#end if; 

 #SET Department_String =concat(Department_String," and (Placed_master.User_Id in(select User_Selection_Id
 # from user_sub where user_sub.Users_Id=", User_Id_, " ) or Placed_master.User_Id =" , User_Id_, ")");
  
if (Is_Date_>0) then
	set Search_Date_=concat( " and placed_master.Placed_Date >= '", From_Date_ ,"' and placed_master.Placed_Date <= '", To_Date_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

#if User_Id_>0 then
#	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",User_Id_);
#end if;

if (Course_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and placed_master.Course_Id =",Course_Id_);
end if;
if (Employer_Details_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and placed_master.Employer_Details_Id =",Employer_Details_Id_);
end if;

SET @query = Concat("select (Date_Format(placed_master.Placed_Date,'%d-%m-%Y')) As PlacementDate,
Student_Name Student,student.Student_Id,Course_Name Course,Company_Name Company,Student.Year_Of_Passing,
users.Users_Name User,Placed_master.Description,student.District_Id ,state_district.District_Name
from placed_master
inner join placed_student on placed_master.Placed_Master_Id=placed_student.Placed_Master_Id
inner join Student on Student.Student_Id=placed_student.Student_Id
inner join Course on Course.Course_Id=Placed_master.Course_Id
inner join employer_details on employer_details.Employer_Details_Id=placed_master.Employer_Details_Id
inner join users on users.Users_Id=Placed_master.User_Id
inner join state_district on state_district.State_District_Id=student.District_Id
where placed_master.DeleteStatus=0 and Student.DeleteStatus=0" ,SearchbyName_Value , " ",Search_Date_,"  ",Department_String,"
order by placed_master.Placed_Date desc, placed_master.Placed_Master_Id asc  " );
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Placed_Report_Tab`(in Is_Date_ tinyint,
From_Date_ datetime,To_Date_ datetime,User_Id_ int,Student_Id_ int)
BEGIN
	declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
	declare Department_String varchar(2000);declare User_Type_ int;
	set SearchbyName_Value=''; set Search_Date_='';set Department_String='';
	set User_Type_=(select User_Type from users where Users_Id=User_Id_);

	SET Department_String =concat(Department_String," and (Placed_master.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or Placed_master.User_Id =" , User_Id_, ")");

if (Student_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and placed_student.Student_Id =",Student_Id_);
end if;

SET @query = Concat("select (Date_Format(placed_master.Placed_Date,'%d-%m-%Y')) As PlacementDate,
Company_Name Company,Placed_master.Description
from placed_master
inner join placed_student on placed_master.Placed_Master_Id=placed_student.Placed_Master_Id
inner join Student on Student.Student_Id=placed_student.Student_Id
inner join employer_details on employer_details.Employer_Details_Id=placed_master.Employer_Details_Id
inner join users on users.Users_Id=Placed_master.User_Id
where placed_master.DeleteStatus=0 and Student.DeleteStatus=0" ,SearchbyName_Value , " ",Search_Date_,"  ",Department_String,"
order by placed_master.Placed_Date desc, placed_master.Placed_Master_Id asc  " );
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Placed_Student`(in Is_Date_ tinyint, Fromdate_ datetime,Todate_ datetime,
Course_Id_ int,Faculty_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and Placed_master.Date >= '", Fromdate_ ,"' and  Placed_master.Date <= '", Todate_,"'");
end if;
if Course_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Placed_master.Course_Id =",Course_Id_);
end if;
#if Batch_Id_>0 then
#	SET SearchbyName_Value =concat(SearchbyName_Value," and Placed_master.Batch_Id =",Batch_Id_);
#end if;
if Faculty_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Placed_master.User_Id =",Faculty_Id_);
end if;

SET @query = Concat("SELECT Placed_master.Placed_Master_Id,Employer_Details.Employer_Details_Id,
(Date_Format(Placed_master.Date,'%d-%m-%Y')) As Date,Placed_master.User_Id,
(Date_Format(Placed_master.Placed_Date,'%Y-%m-%d')) As Placed_Date,
users.Users_Name Faculty_Name,Placed_master.Course_Id,Course_Name,Placed_master.Description,
Company_Name
From Placed_master 
inner join Course on Course.Course_Id=Placed_master.Course_Id
inner join users on users.Users_Id=Placed_master.User_Id
inner join Employer_Details on Employer_Details.Employer_Details_Id=Placed_master.Employer_Details_Id
where  Placed_master.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_," 
order by Placed_master.Placed_Master_Id desc " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Placement_Report_New`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime, Trainer_Id_ int,Course_Id_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare SearchbyName_Value_1_ varchar(2000);
declare Search_Date_ varchar(700);declare Search_Date_1_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';set Search_Date_1_='';set SearchbyName_Value_1_=''; 
if Is_Date_>0 then
set Search_Date_=concat( " and date(applied_jobs.Placement_Date) >= '", Fromdate_ ,"' and  date(applied_jobs.Placement_Date) <= '", Todate_,"'");
    ELSE
set Search_Date_= "and 1 =1 ";
end if;

if Is_Date_>0 then
set Search_Date_1_=concat( " and date(self_placement.Placed_Date) >= '", Fromdate_ ,"' and  date(self_placement.Placed_Date) <= '", Todate_,"'");
    ELSE
set Search_Date_1_= "and 1 =1 ";
end if;

if Trainer_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",Trainer_Id_);
end if;

if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Course_Id =",Course_Id_);
end if;

if Course_Id_>0 then
SET SearchbyName_Value_1_ =concat(SearchbyName_Value_1_," and student_course.Course_Id =",Course_Id_);
end if;
if Trainer_Id_>0 then
SET SearchbyName_Value_1_ =concat(SearchbyName_Value_1_," and student_course.Faculty_Id =",Trainer_Id_);
end if;

SET @query = Concat("select * from(SELECT Student_Name, Phone, Batch_Name, users.Users_Name AS Trainer, job_posting.Course_Name,
  DATE_FORMAT(Placement_Date, '%d-%m-%Y') AS Date_Of_Placement, job_posting.Company_Name, Job_Title, Salary,
 CAST(CAST(ROW_NUMBER() OVER (ORDER BY applied_jobs.Applied_Jobs_Id DESC) AS UNSIGNED) AS SIGNED) AS RowNo
  FROM student 
   INNER JOIN student_course ON student_course.Student_Id = student.Student_Id 
  INNER JOIN users ON users.Users_Id = student_course.Faculty_Id 
   INNER JOIN applied_jobs ON applied_jobs.Student_Id = student.Student_Id 
   INNER JOIN job_posting ON job_posting.Job_Posting_Id = applied_jobs.Job_Id 
    WHERE student.DeleteStatus = 0 AND student_course.DeleteStatus = 0 AND Placement_Status = 1 " ,SearchbyName_Value , " ",Search_Date_,"
    union
    select Student_Name, Phone, Batch_Name, users.Users_Name AS Trainer, student_course.Course_Name,
      DATE_FORMAT(self_placement.Placed_Date, '%d-%m-%Y') AS Date_Of_Placement, Company_Name,Designation Job_Title, 0 Salary,
 CAST(CAST(ROW_NUMBER() OVER (ORDER BY Self_Placement_Id DESC) AS UNSIGNED) AS SIGNED) AS RowNo
    from self_placement inner join student on self_placement.Student_Id=student.Student_Id inner join student_course 
    ON student_course.Student_Id = student.Student_Id 
  INNER JOIN users ON users.Users_Id = student_course.Faculty_Id 
    WHERE self_placement.DeleteStatus = 0 AND student_course.DeleteStatus = 0  " ,SearchbyName_Value_1_ , " ",Search_Date_1_," ) as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );

PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Placement_Report_New_old`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime, Trainer_Id_ int,Course_Id_ int,
Pointer_Start_ int , Pointer_Stop_ int,Page_Length_ int)
BEGIN
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
set Search_Date_=concat( " and date(applied_jobs.Placement_Date) >= '", Fromdate_ ,"' and  date(applied_jobs.Placement_Date) <= '", Todate_,"'");
    ELSE
set Search_Date_= "and 1 =1 ";
end if;

if Trainer_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student_course.Faculty_Id =",Trainer_Id_);
end if;

if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Course_Id =",Course_Id_);
end if;

SET @query = Concat("select * from(select Student_Name,Phone,Batch_Name,users.Users_Name as Trainer,job_posting.Course_Name,
 DATE_FORMAT(Placement_Date, '%d-%m-%Y') AS Date_Of_Placement ,job_posting.Company_Name,Job_Title,Salary,
 CAST(CAST(ROW_NUMBER()OVER(ORDER BY applied_jobs.Applied_Jobs_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from student
inner join student_course on student_course.Student_Id=student.Student_Id
inner join users on users.Users_Id=student_course.Faculty_Id
inner join applied_jobs on applied_jobs.Student_Id=student.Student_Id
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id where student.DeleteStatus=0 and student_course.DeleteStatus=0 and Placement_Status=1 " ,SearchbyName_Value , " ",Search_Date_,"
) as ids where RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"
order by  RowNo LIMIT ",Page_Length_ );

PREPARE QUERY FROM @query;EXECUTE QUERY;
insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Qualification`( In Qualification_Name_ varchar(100))
Begin 
 set Qualification_Name_ = Concat( '%',Qualification_Name_ ,'%');
 SELECT Qualification_Id,
Qualification_Name,
User_Id From Qualification where Qualification_Name like Qualification_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Question_Import_Master`( In Fromdate_ datetime,
Todate_ datetime,Course_Id_ int,Subject_Id_ int,Part_Id_ int)
Begin 
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if(Subject_Id_ >0) then
SET SearchbyName_Value =   Concat( " and question_import_master.Subject_Id=",Subject_Id_) ;
end if;
if(Course_Id_ >0) then
SET SearchbyName_Value =   Concat( " and question_import_master.Course_Id=",Course_Id_ ) ;
end if;
if(Part_Id_ >0) then
SET SearchbyName_Value =   Concat( " and question_import_master.Semester_Id=",Part_Id_ ) ;
end if;

set Search_Date_=concat( " and date(question_import_master.Date) >= '", Fromdate_ ,"' and  date(question_import_master.Date) <= '", Todate_,"'");
SET @query = Concat( "select Question_Import_Master_Id,(Date_Format(question_import_master.Date,'%d-%m-%Y')) As Date,
Course_Name,Semester_Name,Subject_Name,Course_Id,Semester_Id,Subject_Id
 from question_import_master
where question_import_master.DeleteStatus=0 ",SearchbyName_Value," ",Search_Date_,"
order by Question_Import_Master_Id  asc");
PREPARE QUERY FROM @query;
#select @query;

EXECUTE QUERY;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Registration_Report`(In Fromdate_ date,Todate_ date,
Search_By_ int,SearchbyName_ varchar(50),Status_Id_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,Course_Id_ int ,Enquiry_Source_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);declare Department_String varchar(2000);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare pos2to int; declare PageSize int;declare User_Type_ int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value=''; set Search_Date_='';
 set Department_String='';
 set User_Type_=(select User_Type from users where Users_Id=Login_User_Id_);
  #if User_Type_=2 then
  #	SET Department_String =concat(Department_String," and student.User_Id =",Login_User_Id_);
 #else
	SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.User_Id =" , Login_User_Id_, ")");
 #end if;   
 
  #SET Department_String =concat(Department_String," and (student.User_Id in(select User_Selection_Id
  #from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.User_Id =" , Login_User_Id_, ")");

if(SearchbyName_ !='') then
	if Search_By_=1 then
	SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
end if;
#if User_Type_=2 then
 	#SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",Login_User_Id_);
   /* else
    SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By in (select Users_Id from Users
    where Branch_Id in (select
distinct Branch_Id from user_department where User_Id =",Login_User_Id_," and VIew_All=1))");*/
#end if;
if By_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Registered_By =",By_User_);
end if;
if Status_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status =",Status_Id_);
end if;
if Enquiry_Source_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiry_Source =",Enquiry_Source_Id_);
end if;


if Course_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Course_Id =",Course_Id_);
end if;

if Is_Date_Check_=true then
	set Search_Date_=concat( SearchbyName_Value," and date(student.Registered_On) >= '", Fromdate_ ,"' and  date(student.Registered_On) <= '", Todate_,"'");
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat( "select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY student.Student_Id DESC)AS UNSIGNED)AS SIGNED) AS No,
(Date_Format(student.Registered_On,'%d-%m-%Y-%h:%i')) As RegisteredOn ,B.Users_Name RegisteredBy,student.Student_Name  Student,student.Student_Id,
student.Phone Mobile,student.Remark,Status.Status_Name Status,
 (Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As NextFollowupDate,T.Users_Name ToStaff,Year_Of_Passing,
 Users.Users_Name As CreatedBy,
 (Date_Format(student.Entry_Date,'%d-%m-%Y')) As Createdon,
 student.District_Id ,state_district.District_Name,Enquiry_Source_Name,CourseName
from student
inner join Users on Users.Users_Id=student.User_Id
inner join Status on Status.Status_Id=student.Status
inner join Users as T on T.Users_Id=student.To_User_Id
inner join Users as B on B.Users_Id=student.Registered_By
inner join state_district on state_district.State_District_Id=student.District_Id
where student.DeleteStatus=0    and student.Registered=1  ", SearchbyName_Value," ",Search_Date_,"",Department_String,"
)as lds )as ldtwo
order by tp ");

PREPARE QUERY FROM @query;EXECUTE QUERY;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Rejectedcount_Details`(In Job_Posting_Id_ int,Job_Title_ varchar(100))
BEGIN
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value='';
if Job_Posting_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and job_posting.Job_Posting_Id =",Job_Posting_Id_);
end if;
if(Job_Title_ !='') then
		SET SearchbyName_Value =Concat( SearchbyName_Value," and job_posting.Job_Title like '%",Job_Title_ ,"%'") ;
end if;
SET @query = Concat( "select (Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) Rejected_Date, Student_Name,applied_jobs.Remark Reason,
Job_Title,student.Phone Mobile,job_posting.Company_Name Company,student.Student_Id Student_Id,Job_Posting_Id
from student
inner join applied_jobs on applied_jobs.Student_Id=student.Student_Id
inner join job_posting on job_posting.Job_Posting_Id=applied_jobs.Job_Id
where student.DeleteStatus=0 and job_posting.Reject_Count>=1 and applied_jobs.Apply_Type=2 and job_posting.DeleteStatus=0  ",SearchbyName_Value," 
order by student.Student_Id asc ");
PREPARE QUERY FROM @query;
#select @query;
EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Rejected_Mobile`(In Student_Id_ int, Pointer_Start_ int ,
 Pointer_Stop_ int,Page_Length_ int)
Begin 
 
SET @query = Concat("select * from (select Job_Title,Descritpion,Job_Posting_Id,
(Date_Format(applied_jobs.Entry_Date,'%d-%m-%Y')) As Last_Date,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY Job_Posting_Id DESC )AS UNSIGNED)AS SIGNED)AS RowNo
from job_posting inner join applied_jobs on applied_jobs.job_id =Job_Posting_Id
WHERE job_posting.DeleteStatus = false and Apply_Type=2 and  Student_Id =",Student_Id_," ) as lds 
order by  RowNo  " );
#LIMIT,Page_Length_
#  WHERE RowNo >=",Pointer_Start_," AND RowNo<= ",Pointer_Stop_,"

PREPARE QUERY FROM @query;
EXECUTE QUERY;
#insert into db_logs values(3,Student_Id_,'');
#insert into db_logs values(2,@query,'');
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Settings`( In Settings_Name_ varchar(100))
Begin 
 set Settings_Name_ = Concat( '%',Settings_Name_ ,'%');
 SELECT Settings_Id,
Settings_Name,
Settings_Group From Settings where Settings_Name like Settings_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Specialization`( In Specialization_Name_ varchar(100))
Begin 
 set Specialization_Name_ = Concat( '%',Specialization_Name_ ,'%');
 SELECT Specialization_Id,
Specialization_Name,
User_Id From Specialization where Specialization_Name like Specialization_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_State`(in State_Name_ varchar(100))
BEGIN

 set State_Name_ = Concat( '%',State_Name_ ,'%');
 SELECT State.* From State 
 where State_Name like State_Name_ and State.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_State_District_Typeahead`(in District_Name_ varchar(100),State_Id_ int)
BEGIN
 set District_Name_ = Concat( '%',District_Name_ ,'%');
select state_district.State_District_Id,state_district.District_Name,State_Id
from state_district
where State_Id=State_Id_  and state_district.DeleteStatus=0
order by state_district.District_Name asc   ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Status`( In Status_Name_ varchar(100))
Begin 
 set Status_Name_ = Concat( '%',Status_Name_ ,'%');
 SELECT Status_Id,Status_Name,FollowUp,
User_Id From Status where Status_Name like Status_Name_ and Group_Id=3 and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Status_Typeahead`(IN Status_Name_ varchar(100),Group_Id_ int)
BEGIN
set Status_Name_ = Concat( '%',Status_Name_ ,'%');
select Status.Status_Id,Status_Name,FollowUp
from Status
where Status_Name like Status_Name_  and Status.DeleteStatus=false and Status.Group_Id=Group_Id_
 ORDER BY Status_Name Asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student`( In Fromdate_ date,Todate_ date,SearchbyName_ varchar(50),By_User_ int,Status_Id_ int,
Is_Date_Check_ Tinyint,Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,Register_Value int,
Qualification_Id_ int,Course_Id_ int)
Begin

declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(500);declare Duplicate_User_Type_ int;
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;declare  User_Type_ int;declare pos2to int; 
declare PageSize int;declare Search_By_Registered varchar(500);declare User_Status int;declare more_info int;declare IS_followup int default 1; 
declare closed_entries varchar(200);declare missedcount varchar(2000);declare Duplicate_Student_Name_ varchar(2000);
declare Duplicate_User_ varchar(2000);declare Duplicate_student_Id_ int;declare Duplicate_User_Id_ int;declare Duplicate_Found_ int default 0;
declare duplicate_data varchar(2000);

insert into data_log_ values(0,SearchbyName_,'');

set closed_entries='';set pos1frm=0;set pos1to=0;set pos2frm=0;set pos2to=0;set PageSize=25;set more_info=0;
 set SearchbyName_Value=''; set Search_Date_='';
# set User_Type_ = (select User_Type_Id from users where Users_Id = Login_User_Id_ and DeleteStatus=false);
 set User_Status= (select Working_Status from Users where Users_Id=Login_User_Id_ );
 if(SearchbyName_ !='') then
 set IS_followup=0;
 set Is_Date_Check_=false;
 set By_User_=0;set Status_Id_=0;set Register_Value=1;set Qualification_Id_=0;set Course_Id_=0;
#set SearchbyName_Value = replace(replace(SearchbyName_Value,'+',''),' ','');
set SearchbyName_Value = replace(SearchbyName_Value,' ','');
SET SearchbyName_Value =   Concat( SearchbyName_Value," and (student.Student_Name like '%",SearchbyName_ ,"%' or student.Phone like '%",SearchbyName_ ,"%'
or  replace(replace(student.Whatsapp,'+',''),' ','') like '%",SearchbyName_ ,"%' or student.Email like '%",SearchbyName_ ,"%' or student.Alternative_Email like '%",SearchbyName_ ,"%' )") ;
end if;
if Register_Value=2 then
Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Registered= ",1) ;
elseif Register_Value=3 then
    Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Registered= ",0) ;
end if;
  SET SearchbyName_Value =concat(SearchbyName_Value," and (student.To_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.To_User_Id =" , Login_User_Id_, ")");
 if Qualification_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Qualification_Id =",Qualification_Id_);
end if;
if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Course_Id =",Course_Id_);
end if;
if By_User_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;
if Status_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status =",Status_Id_);
    set Is_followup=(select FollowUp from status where status_id=status_id_);
	if Is_followup=1 then
		SET SearchbyName_Value =concat(SearchbyName_Value," and Status_FollowUp =1");
	end if;
#else
	#SET SearchbyName_Value =concat(SearchbyName_Value," and Status_FollowUp =1");
end if;
#insert into data_log_ values(0,Status_Id_,'');
if(TRIM(SearchbyName_) ='' and Status_Id_=0 ) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Status_FollowUp =1");
end if;
if(TRIM(SearchbyName_) !=''   or  Is_followup=0 ) then
	set Is_Date_Check_=false; set By_User_=0;set Status_Id_=0;set Register_Value=1;set Qualification_Id_=0;set Course_Id_=0;
end if;
if Is_Date_Check_=true then
set Search_Date_=concat( " and date(student.Next_FollowUp_Date) >= '", Fromdate_ ,"' and  
    date(student.Next_FollowUp_Date) <= '", Todate_,"'");
set Search_Date_union=concat( " and  date(student.Next_FollowUp_Date) < '", Fromdate_,"'");
ELSE
set Search_Date_= " and 1 =1 ";
end if;
 if(SearchbyName_ !='') then
Set Duplicate_student_Id_ = (select Student_Id from Student where  DeleteStatus=false  and  (student.Phone like concat('%',SearchbyName_,'%') or student.Mobile like concat('%',SearchbyName_,'%') or student.Whatsapp  like concat('%',SearchbyName_,'%')) limit 1);
 insert into db_logs values(0,Duplicate_student_Id_,'1');
set Duplicate_Found_ = -1;
    else
set Duplicate_Found_ = 0;
end if;
if Duplicate_student_Id_>0 then
set Duplicate_Student_Name_ = (select Student_Name from student where Student_Id = Duplicate_student_Id_ and DeleteStatus=false );
    set Duplicate_User_Id_ = (select User_Id from student where Student_Id = Duplicate_student_Id_ and DeleteStatus=false );
    set Duplicate_User_ = (select Users_Name from users where Users_Id = Duplicate_User_Id_ and DeleteStatus=false );
    set Duplicate_User_Type_ = (select User_Type from users where Users_Id = Login_User_Id_ and DeleteStatus=false );
    insert into db_logs values(0,Duplicate_User_Id_,Duplicate_User_Type_);
end if;
set UnionQuery="";
 if Duplicate_student_Id_>0  and  Duplicate_User_Id_!=Login_User_Id_  and  Duplicate_User_Type_!=1 then
select Duplicate_Student_Name_,Duplicate_User_Id_,Duplicate_User_,Duplicate_Found_;
 else
if User_Status=1 then
if Is_Date_Check_=true then
#inner join user_details on user_details.User_Details_Id=student.User_Id
#inner join user_details as B on B.User_Details_Id=student.By_User_Id
#B.User_Details_Name Registered_By_Name,
set UnionQuery=concat("  union select * from(select  CAST(CAST(2 AS UNSIGNED) AS SIGNED)   as tp,student.Student_Id,
student.Student_Name,student.Phone,student.Remark,(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
StatusName Status_Name,ToUserName Users_Name,student.Course_Id,CourseName Course_Name,QualificationName Qualification_Name,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY student.Student_Id DESC,Student.Next_FollowUp_Date desc)AS UNSIGNED)AS SIGNED)AS
RowNo,student.Registered,1 as User_Status,0 as more_info,Status_FollowUp FollowUp,Mail_Status,Status,Enquiry_Source_Name
from student where student.DeleteStatus=0
",SearchbyName_Value, " " ,Search_Date_union,"
)as lds WHERE RowNo >=",RowCount," AND RowNo<= ",RowCount2);
set missedcount=concat("
union
select 3 as tp,count(student.Student_Id) Student_Id,'','','',now(),'','',0,'','',1,1,1 ,1,1,0,0,''
from student
where student.DeleteStatus=0  ",SearchbyName_Value," and date(student.Next_FollowUp_Date) <'",Fromdate_,"'");
else
set missedcount=concat("
union
select 3 as tp,0 Student_Id,'','','',now(),'','',0,'','',1,1,1 ,1,1,0,0,''");
end if;
SET @query = Concat( "select * from (select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,student.Student_Id,
student.Student_Name,student.Phone,student.Remark,(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Next_FollowUp_Date,
StatusName Status_Name,ToUserName Users_Name,student.Course_Id,CourseName Course_Name,QualificationName Qualification_Name,
CAST(CAST(ROW_NUMBER()OVER(ORDER BY student.Student_Id DESC,Student.Next_FollowUp_Date desc)AS UNSIGNED)AS SIGNED)AS
RowNo,student.Registered,1 as User_Status,0 as more_info,Status_FollowUp FollowUp,Mail_Status,Status,Enquiry_Source_Name
from student
where student.DeleteStatus=0 ", SearchbyName_Value," ",Search_Date_," )as lds  WHERE RowNo >= ",Page_Index1_," AND RowNo<= ", Page_Index2_,UnionQuery,"
)as ldtwo order by tp, RowNo  LIMIT ",PageSize,") as t " ,missedcount,"
union
select 4 as tp,count(student.Student_Id) Student_Id,'','','',now(),'','',0,'','',1,1,1 ,1,1,0,0,''
from student 
inner join Users as T on T.Users_Id=student.To_User_Id where student.DeleteStatus=0 ",SearchbyName_Value, " " ,Search_Date_," order by tp" );
PREPARE QUERY FROM @query;

EXECUTE QUERY;

#select @query;
else
select 2 as User_Status;
end if;
insert into data_log_ values(0,@query,'');
end if;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Course`( In Student_Course_Name_ varchar(100))
Begin 
 set Student_Course_Name_ = Concat( '%',Student_Course_Name_ ,'%');
 SELECT Student_Course_Id,
Student_Id,
Entry_Date,
Course_Name_Details,
Course_Id,
Course_Name,
Start_Date,
End_Date,
Join_Date,
By_User_Id,
Status From Student_Course where Student_Course_Name like Student_Course_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Course_Subject`( In Student_Course_Subject_Name_ varchar(100))
Begin 
 set Student_Course_Subject_Name_ = Concat( '%',Student_Course_Subject_Name_ ,'%');
 SELECT Student_Course_Subject_Id,
Student_Id,
Course_Id,
Course_Name,
Subject_Id,
Subject_Name,
Minimum_Mark,
Maximum_Mark,
Online_Exam_Statusuu7ytrefsertytrewertrfs,
No_of_Question,
Exam_Duration,
Exam_Attended_Status From Student_Course_Subject where Student_Course_Subject_Name like Student_Course_Subject_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Data_Report`(In Fromdate_ date,Todate_ date,
Search_By_ int,SearchbyName_ varchar(50),Enquiry_Source_ int,Branch_ int,By_User_ int,Is_Date_Check_ Tinyint,
Page_Index1_ int,Page_Index2_ int,Login_User_Id_ int,RowCount int ,RowCount2 int,To_User_ int,Status_Id_ int,Register_Value int)
BEGIN
declare SearchbyName_Value varchar(2000);declare UnionQuery varchar(4000);declare Search_Date_ varchar(1000);
declare Search_Date_union varchar(500);declare pos1frm int;declare pos1to int;declare pos2frm int;
declare RoleId_ varchar(100);
declare pos2to int; declare PageSize int;
 set pos1frm=0;    set pos1to=0;    set pos2frm=0;    set pos2to=0;    set PageSize=10;
 set SearchbyName_Value='';
 set Search_Date_='';
 
# set RoleId_ =(select Role_String from users where users_Id = Login_User_Id_);
 
   SET SearchbyName_Value =concat(SearchbyName_Value," and (student.To_User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", Login_User_Id_, " ) or student.To_User_Id =" , Login_User_Id_, ")");
  
if(SearchbyName_ !='0') then
	if Search_By_=1 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Student_Name like '%",SearchbyName_ ,"%'") ;
	end if;
    if Search_By_=2 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Email like '%",SearchbyName_ ,"%'") ;
	end if;
    if Search_By_=3 then
		SET SearchbyName_Value =   Concat( SearchbyName_Value," and student.Phone like '%",SearchbyName_ ,"%'") ;
	end if;
end if;


if Enquiry_Source_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Enquiry_Source =",Enquiry_Source_);
end if;

if Register_Value=2 then
Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Registered= ",1) ;
    elseif Register_Value=3 then
    Set SearchbyName_Value= Concat( SearchbyName_Value," and student.Registered= ",0) ;
    end if;
if Status_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Status =",Status_Id_);
end if;
if Branch_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Agent_Id =",Branch_);
end if;
if By_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.To_User_Id =",By_User_);
end if;
if To_User_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",To_User_);
end if;

if Is_Date_Check_=true then
	set Search_Date_=concat( SearchbyName_Value," and date(student.Next_FollowUp_date) >= '", Fromdate_ ,"' and  date(student.Next_FollowUp_date) <= '", Todate_,"'");
	
ELSE
	set Search_Date_= "and 1 =1 ";
end if;
set UnionQuery="";
SET @query = Concat( "select * from (select * from(select CAST(CAST(1 AS UNSIGNED) AS SIGNED)as tp,CAST(CAST(ROW_NUMBER()
OVER(ORDER BY student.Student_Id DESC)AS UNSIGNED)AS SIGNED)AS 
No,student.Student_Id,(Date_Format(student.Entry_Date,'%d-%m-%Y   %h:%i')) As Created_On,Users.Users_Name As Created_By,student.Student_Name Student,
enquiry_source.Enquiry_Source_Name AS Enquiry_Source,student.Registered,
student.Phone Mobile,agent.Agent_Name Branch,(Date_Format(student.Next_FollowUp_Date,'%d-%m-%Y')) As Follow_Up_On,
B.Users_Name Registered_By,(Date_Format(student.Registered_On,'%d-%m-%Y   %h:%i')) 
As Registered_On ,T.Users_Name To_Staff,Status.Status_Name Status,
student.Remark,student.Email
from student 

	inner join Users  on Users.Users_Id=student.User_Id
	inner join Status on Status.Status_Id=student.Status
    inner join agent on agent.Agent_Id=student.Agent_Id
	inner join enquiry_source on enquiry_source.Enquiry_Source_Id= student.Enquiry_Source
	left join Users as B on B.Users_Id=student.Registered_By 
    inner join Users as T on T.Users_Id=student.To_User_Id 
	where student.DeleteStatus=0    and student.DeleteStatus=0  ",SearchbyName_Value," ",Search_Date_," 
	)as lds )as ldtwo
	order by tp ");	 
PREPARE QUERY FROM @query;
#select @query;
insert into data_log_ value(0,@query,'');
EXECUTE QUERY;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Followup`( In Student_Followup_Name_ varchar(100))
Begin 
 set Student_Followup_Name_ = Concat( '%',Student_Followup_Name_ ,'%');
 SELECT Student_Followup_Id,
Student_Id,
Entry_Date,
Next_FollowUp_Date,
FollowUp_Difference,
Status,
User_Id,
Remark,
Remark_Id,
FollowUp_Type,
FollowUP_Time,
Actual_FollowUp_Date From Student_Followup where Student_Followup_Name like Student_Followup_Name_ and DeleteStatus=false ;
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

SET @query = Concat("SELECT Users_Name,(Date_Format(Entry_Date,'%Y-%m-%d')) Entry_Date
 From import_students_master ",Search_Date_," 
 inner join users  on  users.Users_Id = import_students_master.By_User_Id 
 order by import_students_master.Entry_Date desc ");
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into db_logs values(1,@query,1,1);
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Student_Job_Report`(in Is_Date_ tinyint,Fromdate_ datetime,Todate_ datetime,Student_Status_ int,Student_Name_ varchar(250),
Offeredcount_ int,Blacklist_Status_ int,Activate_Status_ int,Fees_Status_ int,Search_Resume_Status_ varchar(100))
BEGIN 
declare SearchbyName_Value varchar(2000);
declare Search_Date_ varchar(700);
set SearchbyName_Value=''; set Search_Date_='';
if Is_Date_>0 then
	set Search_Date_=concat( " and date(student.Entry_Date) >= '", Fromdate_ ,"' and  date(student.Entry_Date) <= '", Todate_,"'");
    ELSE
	set Search_Date_= " and 1 =1 ";
end if;

if Student_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Student_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Student_Status =",Student_Status_);
end if;

if Student_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Student_Status =",Student_Status_);
end if;


if Blacklist_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Blacklist_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Blacklist_Status =",Blacklist_Status_);
end if;

if Blacklist_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Blacklist_Status =",Blacklist_Status_);
end if;


if Activate_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Activate_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Activate_Status =",Activate_Status_);
end if;

if Activate_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Activate_Status =",Activate_Status_);
end if;


if Fees_Status_ < 0 then
	set SearchbyName_Value= concat(SearchbyName_Value," and 1 =1 ");
end if;

if Fees_Status_ = 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Fees_Status =",Fees_Status_);
end if;

if Fees_Status_ = 1 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Fees_Status =",Fees_Status_);
end if;

/*if Search_Resume_Status_ > 0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and student.Resume_Status_Id =",Search_Resume_Status_);
end if;*/


if Search_Resume_Status_!=''   and   Search_Resume_Status_!='0'  then
    set SearchbyName_Value=concat(" and student.Resume_Status_Id in(",Search_Resume_Status_,")");
end if;


/*if(Student_Name_ !='') then
		SET SearchbyName_Value =Concat( SearchbyName_Value," and student.Student_Name like '%",Student_Name_ ,"%'") ;
end if;
*/
if(Student_Name_ !='') then
SET SearchbyName_Value =   Concat( SearchbyName_Value," and (student.Student_Name like '%",Student_Name_ ,"%' or replace(replace(student.Phone,'+',''),' ','') like '%",Student_Name_ ,"%'
or  replace(replace(student.Whatsapp,'+',''),' ','') like '%",Student_Name_ ,"%' or student.Email like '%",Student_Name_ ,"%' or student.Alternative_Email like '%",Student_Name_ ,"%' )") ;
end if;

if Offeredcount_ >= 0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and student.Offer =",Offeredcount_);
end if;

SET @query = Concat("SELECT Student_Name,Phone,Year_Of_Passing,student.Email Email,Student_Status,
Blacklist_Status,Activate_Status,Fees_Status,Offer,Applied,Rejected,Resume_Status_Name,
StatusName,ToUserName,ByUserName,Image_ResumeFilename,Resume,
student_course.Course_Name ,student.Student_Id
From student
inner join student_course on Student.Student_Id=student_course.Student_Id
#inner join applied_jobs on Student.Student_Id=applied_jobs.Student_Id
#inner join job_posting on applied_jobs.Job_Id=job_posting.Job_Posting_Id
where   Student.DeleteStatus=0 and Student.Registered=1 and student_course.DeleteStatus=0 " ,SearchbyName_Value , " ",Search_Date_," 
order by Student_Id ASC
" );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#insert into data_log_ values(0,@query,'');
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Study_Materials`( In Study_Materials_Name_ varchar(100))
Begin 
 set Study_Materials_Name_ = Concat( '%',Study_Materials_Name_ ,'%');
 SELECT Study_Materials_Id,
Course_Id,
Part_Id,
Subject_Id,
Course_Subject_Id,
Study_Materials_Name,
File_Name From Study_Materials where Study_Materials_Name like Study_Materials_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Subject`( In Subject_Name_ varchar(100))
Begin 
 set Subject_Name_ = Concat( '%',Subject_Name_ ,'%');
 SELECT Subject_Id,
Subject_Name,
Exam_status,
User_Id From Subject where Subject_Name like Subject_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Subject_Course_Typeahead`(in Subject_Name_ varchar(100),Course_Id_ int)
BEGIN
 set Subject_Name_ = Concat( '%',Subject_Name_ ,'%');
select course_subject.Subject_Id,Subject.Subject_Name,Minimum_Mark,Maximum_Mark
from course_subject
inner join Subject on Subject.Subject_Id=course_subject.Subject_Id
where Course_Id=Course_Id_ and Subject.Subject_Name like Subject_Name_ and course_subject.DeleteStatus=0
order by Subject.Subject_Name asc   ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Subject_Typeahead`( In Subject_Name_ varchar(100))
Begin
 set Subject_Name_ = Concat( '%',Subject_Name_ ,'%');
select  Subject.Subject_Id,Subject_Name
From Subject
where  Subject.DeleteStatus=false
order by Subject_Name asc  ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Syllabus_Coverage`( IN Is_Date_Check_ TINYINT, Fromdate_ DATETIME, Todate_ DATETIME,
    Batch_Id_ INT, Search_Staff_ INT,  Course_ INT,User_Id_ INT,  FollowUp_Branch_Id_ INT)
BEGIN
    DECLARE SearchbyName_Value VARCHAR(2000);
    DECLARE Search_Date_ VARCHAR(500);
    DECLARE Department_String VARCHAR(2000);
    DECLARE User_Type_ INT;
    SET SearchbyName_Value = '';
    SET Search_Date_ = '';
    SET Department_String = '';
    SET User_Type_ = (SELECT User_Type FROM users WHERE Users_Id = User_Id_);
    SET Department_String = CONCAT(
        Department_String,
        " AND (batch.Trainer_Id IN (SELECT User_Selection_Id FROM user_sub WHERE user_sub.Users_Id =",
        User_Id_,") OR batch.Trainer_Id =",User_Id_,")"
    );
    IF Search_Staff_ > 0 THEN
        SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Trainer_Id =", Search_Staff_);
    END IF;
    IF Batch_Id_ > 0 THEN
        SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Batch_Id =", Batch_Id_);
    END IF;

    IF FollowUp_Branch_Id_ > 0 THEN
        SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Branch_Id =", FollowUp_Branch_Id_);
    END IF;
    IF Course_ > 0 THEN
        SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Course_Id =", Course_);
    END IF;
    IF Is_Date_Check_ > 0 THEN
        SET Search_Date_ = CONCAT(" AND attendance_master.Date >= '",  Fromdate_, "' AND attendance_master.Date <= '",Todate_,"'");
    ELSE
        SET Search_Date_ = "AND 1 = 1";
    END IF;
    SET @query = CONCAT(
        "SELECT batch.Batch_Id, batch.Batch_Name, batch.Branch_Name, batch.Course_Name, Duration,
        (DATE_FORMAT(attendance_master.Date, '%d-%m-%Y')) AS Entry_Date, (DATE_FORMAT(batch.Start_Date, '%d-%m-%Y')) AS Start_Date,
        (DATE_FORMAT(batch.End_Date, '%d-%m-%Y')) AS End_Date, batch.Trainer_Name, attendance_subject.Subject_Id,
        batch.Batch_Complete_Status, course_subject.Subject_Name,
        CASE  WHEN batch.Batch_Complete_Status = 1 THEN 'Complete' ELSE 'Incomplete' END AS Batch_Complete_Status_Name
        FROM batch
        INNER JOIN attendance_master ON batch.Batch_Id = attendance_master.Batch_Id
        INNER JOIN attendance_subject ON attendance_subject.Attendance_Master_Id = attendance_master.Attendance_Master_Id
        INNER JOIN course_subject ON course_subject.Subject_Id = attendance_subject.Subject_Id ",
        SearchbyName_Value," ",Search_Date_," ",Department_String, "
        WHERE batch.DeleteStatus = 0
       ORDER BY batch.Batch_Id ASC;"
    );
    PREPARE QUERY FROM @query;
    EXECUTE QUERY;
    INSERT INTO data_log_ VALUES (0, @query, '');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Syllabus_Coverage_Old`(IN Is_Date_Check_ TINYINT,Fromdate_ DATETIME,Todate_ DATETIME,Batch_Id_ INT,Search_Staff_ INT,Course_ INT,
User_Id_ INT,FollowUp_Branch_Id_ int
)
BEGIN

  DECLARE SearchbyName_Value VARCHAR(2000);
  DECLARE Search_Date_ VARCHAR(500);
  DECLARE Department_String VARCHAR(2000);
  DECLARE User_Type_ INT;

  SET SearchbyName_Value = '';
  SET Search_Date_ = '';
  SET Department_String = '';

  SET User_Type_ = (SELECT User_Type FROM users WHERE Users_Id = User_Id_);
  SET Department_String =concat(Department_String," and (batch.Trainer_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or batch.Trainer_Id =" , User_Id_, ")");
  
  IF Search_Staff_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Trainer_Id =", Search_Staff_);
  END IF;

  IF Batch_Id_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Batch_Id =", Batch_Id_);
  END IF;
  
    IF FollowUp_Branch_Id_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Branch_Id =", FollowUp_Branch_Id_);
  END IF;

  IF Course_ > 0 THEN
    SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND batch.Course_Id =", Course_);
  END IF;


  IF Is_Date_Check_ > 0 THEN
    SET Search_Date_ = CONCAT(" AND attendance_master.Date >= '", Fromdate_, "' AND attendance_master.Date <= '", Todate_, "'");
  ELSE
    SET Search_Date_ = "AND 1 = 1";
  END IF;

# Batch_Id,Batch_Name,Branch_Name,Duration,Course_Name

SET @query = CONCAT(
    "SELECT batch.Batch_Id, Batch_Name, Branch_Name, Course_Name, Duration,
    (DATE_FORMAT(Date, '%d-%m-%Y')) AS Entry_Date, (DATE_FORMAT(Start_Date, '%d-%m-%Y')) AS Start_Date,
    (DATE_FORMAT(End_Date, '%d-%m-%Y')) AS End_Date, Trainer_Name, attendance_subject.Subject_Id,Batch_Complete_Status,
    course_subject.Subject_Name,
    CASE 
        WHEN Batch_Complete_Status = 1 THEN 'Complete'
        ELSE 'Incomplete'
    END AS Batch_Complete_Status_Name
    FROM batch
    INNER JOIN batch ON batch.Batch_Id = attendance_master.Batch_Id
    INNER JOIN attendance_subject ON attendance_subject.Attendance_Master_Id = attendance_master.Attendance_Master_Id
    INNER JOIN course_subject ON course_subject.Subject_Id = attendance_subject.Attendance_Subject_Id ", SearchbyName_Value, " ", Search_Date_, " ", Department_String, " 
    WHERE batch.DeleteStatus = 0
    GROUP BY batch.Batch_Id, batch.Batch_Name, Branch_Name, Duration, Course_Name, attendance_master.Date,
    batch.Start_Date, batch.End_Date, Trainer_Name, attendance_subject.Subject_Id, course_subject.Subject_Name
    ORDER BY batch.Batch_Id ASC;"
);


  PREPARE QUERY FROM @query;
  EXECUTE QUERY;
 INSERT INTO data_log_ VALUES (0, @query, '');
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Syllabus_Import`(In From_Date_ datetime,To_Date_ datetime,Is_Date_Check_ Tinyint)
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
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Team_Member_Typeahead`( In Users_Name_ varchar(100))
Begin
 set Users_Name_ = Concat( '%',Users_Name_ ,'%');
select  Users_Id,Users_Name From users where DeleteStatus=false and Working_Status=1
order by Users_Name ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Transaction`(in Course_Id_ int,Portion_Covered_ int)
BEGIN
select Student.Student_Id,Student_Name,0 Check_Box,Course_Name,Portion_Covered
from Student
inner join student_course on student_course.Student_Id=Student.Student_Id
where student_course.Course_Id=Course_Id_ and Portion_Covered >= Portion_Covered_ 
#and Resume_Send=0
and Placed=0
 and student_course.DeleteStatus=0 and Student.DeleteStatus=0 and Student.status not in(18) order by Student_Name asc;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Transaction_Report`(in Is_Date_ tinyint,
From_Date_ datetime,To_Date_ datetime,Course_Id_ int, Employer_Details_Id_ int,User_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';

set User_Type_=(select User_Type from users where Users_Id=User_Id_);
 #if User_Type_=2 then
 	#SET Department_String =concat(Department_String," and Transaction_master.User_Id =",User_Id_);
#else
	SET Department_String =concat(Department_String," and (Transaction_master.User_Id in(select User_Selection_Id
  from user_sub where user_sub.Users_Id=", User_Id_, " ) or Transaction_master.User_Id =" , User_Id_, ")");
#end if; 
  #SET Department_String =concat(Department_String," and (Transaction_master.User_Id in(select User_Selection_Id
 # from user_sub where user_sub.Users_Id=", User_Id_, " ) or Transaction_master.User_Id =" , User_Id_, ")");
if (Is_Date_>0) then
	set Search_Date_=concat( " and Transaction_master.Date >= '", From_Date_ ,"' and Transaction_master.Date <= '", To_Date_,"'");
    ELSE
	set Search_Date_= "and 1 =1 ";
end if;

#if User_Id_>0 then
#	SET SearchbyName_Value =concat(SearchbyName_Value," and student.User_Id =",User_Id_);
#end if;

if (Course_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Transaction_master.Course_Id =",Course_Id_);
end if;
if (Employer_Details_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Transaction_master.Employer_Details_Id =",Employer_Details_Id_);
end if;

SET @query = Concat("select (Date_Format(Transaction_master.Date,'%d-%m-%Y')) As Date,Year_Of_Passing,
Student_Name Student,student.Student_Id,Course_Name Course,users.Users_Name User,
Transaction_master.Portion_Covered PortionCovered,Company_Name Company,
Transaction_master.Description,student.District_Id ,state_district.District_Name
From Transaction_master 
inner join Transaction_student on Transaction_master.Transaction_Master_Id=Transaction_student.Transaction_Master_Id
inner join Student on Student.Student_Id=Transaction_student.Student_Id
inner join Course on Course.Course_Id=Transaction_master.Course_Id
inner join employer_details on employer_details.Employer_Details_Id=Transaction_master.Employer_Details_Id
inner join users on users.Users_Id=Transaction_master.User_Id
inner join state_district on state_district.State_District_Id=student.District_Id
where Transaction_master.DeleteStatus=0 and Student.DeleteStatus=0 " ,SearchbyName_Value , " ",Search_Date_," 
order by Transaction_master.Date desc, transaction_master.Transaction_Master_Id asc  " );
#order by Student.Student_Id desc
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;

End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Transaction_Report_Tab`(in Is_Date_ tinyint,
From_Date_ datetime,To_Date_ datetime,User_Id_ int,Student_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);
declare Department_String varchar(2000);declare User_Type_ int;
set SearchbyName_Value=''; set Search_Date_='';set Department_String='';

	set User_Type_=(select User_Type from users where Users_Id=User_Id_);
	SET Department_String =concat(Department_String," and (Transaction_master.User_Id in(select User_Selection_Id
	  from user_sub where user_sub.Users_Id=", User_Id_, " ) or Transaction_master.User_Id =" , User_Id_, ")");

if (Student_Id_>0) then
	SET SearchbyName_Value =concat(SearchbyName_Value," and transaction_student.Student_Id =",Student_Id_);
end if;

SET @query = Concat("select (Date_Format(Transaction_master.Date,'%d-%m-%Y')) As Date,
student.Student_Id,Company_Name Company,
Transaction_master.Description
From Transaction_master 
inner join Transaction_student on Transaction_master.Transaction_Master_Id=Transaction_student.Transaction_Master_Id
inner join Student on Student.Student_Id=Transaction_student.Student_Id
inner join employer_details on employer_details.Employer_Details_Id=Transaction_master.Employer_Details_Id
inner join users on users.Users_Id=Transaction_master.User_Id
where Transaction_master.DeleteStatus=0 and Student.DeleteStatus=0 " ,SearchbyName_Value , " ",Search_Date_," 
order by Transaction_master.Date desc, transaction_master.Transaction_Master_Id asc  " );
#order by Student.Student_Id desc
PREPARE QUERY FROM @query;EXECUTE QUERY;

#select @query;

End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Transaction_Student`(in Is_Date_ tinyint, Fromdate_ datetime,Todate_ datetime,
Course_Id_ int,Faculty_Id_ int,Employer_Details_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);declare Search_Date_ varchar(700);declare UserType_Id_ int;
set SearchbyName_Value=''; set Search_Date_='';
set UserType_Id_=(select User_Type from users where Users_Id=Employer_Details_Id_);
if Is_Date_>0 then
set Search_Date_=concat( " and Transaction_master.Date >= '", Fromdate_ ,"' and  Transaction_master.Date <= '", Todate_,"'");
end if;
if Course_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Transaction_master.Course_Id =",Course_Id_);
end if;
if Employer_Details_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Transaction_master.Employer_Details_Id =",Employer_Details_Id_);
end if;
if UserType_Id_=2 then
if Faculty_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Transaction_master.User_Id =",Faculty_Id_);
end if;
end if;
SET @query = Concat("SELECT Transaction_master.Transaction_Master_Id,Portion_Covered,Employer_Details.Employer_Details_Id,
(Date_Format(Transaction_master.Date,'%d-%m-%Y')) As Date,Transaction_master.User_Id,
users.Users_Name Faculty_Name,Transaction_master.Course_Id,Course_Name,Transaction_master.Description,
Company_Name
From Transaction_master
inner join Course on Course.Course_Id=Transaction_master.Course_Id
inner join users on users.Users_Id=Transaction_master.User_Id
inner join Employer_Details on Employer_Details.Employer_Details_Id=Transaction_master.Employer_Details_Id
where  Transaction_master.DeleteStatus=false " ,SearchbyName_Value , " ",Search_Date_,"
order by Transaction_master.Transaction_Master_Id desc " );
PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Typeahead_Loadfaculty`(IN Users_Name_ varchar(100))
BEGIN
set Users_Name_ = Concat( '%',Users_Name_ ,'%');
select Users.Users_Id,Users_Name,User_Role_Id
from Users
inner join user_role on user_role.User_Role_Id=Users.Role_Id
where User_Role_Id in (4,5) and Users.DeleteStatus=false and Working_Status=1
ORDER BY Users_Name Asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_University`( In University_Name_ varchar(100))
Begin 
 set University_Name_ = Concat( '%',University_Name_ ,'%');
 SELECT University_Id,
University_Name,
Address1,
Address2,
Address3,
Address4,
Pincode,
Phone,
Mobile,
Email,
User_Id From University where University_Name like University_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_University_Followup`( In University_Followup_Name_ varchar(100))
Begin 
 set University_Followup_Name_ = Concat( '%',University_Followup_Name_ ,'%');
 SELECT University_Followup_Id,
University_Id,
Entry_Date,
Next_FollowUp_Date,
FollowUp_Difference,
Status,
User_Id,
Remark,
Remark_Id,
FollowUp_Type,
FollowUP_Time,
Actual_FollowUp_Date,
Entry_Type From University_Followup where University_Followup_Name like University_Followup_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Users`( In Users_Name_ varchar(100), Agent_Id_ int)
Begin
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value=''; set Users_Name_ = Concat( '%',Users_Name_ ,'%');

 if Agent_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and users.Agent_Id =",Agent_Id_);
end if;

if Users_Name_!='' then
SET SearchbyName_Value =   Concat( SearchbyName_Value ," and users.Users_Name like '%",Users_Name_ ,"%'") ;
end if;

 SET @query = Concat("SELECT Users_Id,Users_Name,Users.Password,Working_Status,User_Type,Role_Id,User_Status_Name,User_Type_Name,
 Users.Address1, Users.Address2,Users.Address3,Users.Address4,Users.Pincode,FollowUp_Target,
 Users.Mobile,Users.Email,Agent.Agent_Id,Agent.Agent_Name,Registration_Target
From Users
inner join user_status on Users.Working_Status=user_status.User_Status_Id
inner join user_type on Users.User_Type=user_type.User_Type_Id
inner join Agent on Users.Agent_Id=Agent.Agent_Id
where Users.DeleteStatus=false ",SearchbyName_Value,"
order by Users_Id asc ");
PREPARE QUERY FROM @query;
 EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Users_Typeahead`(IN Users_Name_ varchar(100))
BEGIN
set Users_Name_ = Concat( '%',Users_Name_ ,'%');
select Users.Users_Id,Users_Name
from Users
where  Users.DeleteStatus=false and Users.Working_Status=1
 ORDER BY Users_Name Asc ;
END$$
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
order by Menu.Menu_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Role`( In User_Role_Name_ varchar(100))
Begin 
 set User_Role_Name_ = Concat( '%',User_Role_Name_ ,'%');
 SELECT User_Role_Id,
User_Role_Name,
Role_Under_Id From User_Role where User_Role_Name like User_Role_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_User_Type`( In User_Type_Name_ varchar(100))
Begin 
 set User_Type_Name_ = Concat( '%',User_Type_Name_ ,'%');
 SELECT User_Type_Id,
User_Type_Name From User_Type where User_Type_Name like User_Type_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Search_Vacancy_Source`( In Vacancy_Source_Name_ varchar(100))
Begin 
declare Status_Name_ varchar(100);
 set Status_Name_ = Concat( '%',Vacancy_Source_Name_ ,'%');
 SELECT Vacancy_Source_Id,Vacancy_Source_Name From Vacancy_Source where Vacancy_Source_Name like Status_Name_  and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Set_Notification_Status`( In Student_Id_ Int,Status_Id_ Int)
Begin
insert into db_logs values(0,Student_Id_,Status_Id_);
 update student set Student_Status=Status_Id_
   where Student_Id =Student_Id_ ;
   select Student_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Data_Dropdowns`()
BEGIN
select Status_Id,Status_Name from status where DeleteStatus=0;
select Enquiry_Source_Id,Enquiry_Source_Name from enquiry_source where DeleteStatus=0;
select Agent_Id,Agent_Name from agent where DeleteStatus=0;
select Users_Id,Users_Name from users where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Student_Login`( In Users_Name_ VARCHAR(50),
in Password_ VARCHAR(50))
BEGIN
SELECT 
Student_Id,Student_Name
From student 
 where 
 Phone =Users_Name_ and DOB=Password_ and DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Truncate_Table_For_Jobposting`()
BEGIN
TRUNCATE TABLE job_candidate;
TRUNCATE TABLE job_posting;
TRUNCATE TABLE candidate_job_apply;
TRUNCATE TABLE applied_jobs;
TRUNCATE TABLE student;
TRUNCATE TABLE student_course;
TRUNCATE TABLE receipt_voucher;
TRUNCATE TABLE student_fees_installment_master;
TRUNCATE TABLE student_fees_installment_details;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Update_Device_Id`(In Student_Id_ int,Device_Id_ text)
BEGIN
update student set Device_Id=Device_Id_ where Student_Id=Student_Id_ and  DeleteStatus=0;
select Student_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_Installment_Status`( In Student_Course_Id_ int,Receipt_Voucher_Id_ int)
Begin
declare Student_Fees_Installment_Details_Id_ decimal(18,0);declare Fees_Amount_ decimal(18,2);declare Amount_ decimal(18,2);declare fetch_status decimal(18,0);declare new_balance decimal(18,2) default 0;
declare feesreceipt decimal(18,2) default 0;declare feesstatus int default 0;

Declare Cur Cursor for select Student_Fees_Installment_Details_Id,Fees_Amount
from student_fees_installment_details 
inner join student_fees_installment_master on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_master.Student_Course_Id=Student_Course_Id_;

set feesreceipt=(select COALESCE(Sum(Amount),0) from receipt_voucher where  Student_Course_Id= Student_Course_Id_ and DeleteStatus=0);

set fetch_status=(select count(Student_Fees_Installment_Details_Id)
from student_fees_installment_details 
inner join student_fees_installment_master on student_fees_installment_details.Student_Fees_Installment_Master_Id=student_fees_installment_master.Student_Fees_Installment_Master_Id
where student_fees_installment_master.Student_Course_Id=Student_Course_Id_);

Open Cur;
FETCH Cur INTO Student_Fees_Installment_Details_Id_,Fees_Amount_;  
	While(fetch_status != 0)do
           
		   if(feesreceipt>=Fees_Amount_) then
					set feesstatus=1;
                    set feesreceipt=feesreceipt-Fees_Amount_;
                    set new_balance=0;
				else
					set feesstatus=0;
                    set new_balance=Fees_Amount_-feesreceipt;
                    set feesreceipt=0;
                end if;
                update student_fees_installment_details set Status=feesstatus,Balance_Amount=new_balance where Student_Fees_Installment_Details_Id=Student_Fees_Installment_Details_Id_;
		set fetch_status=fetch_status-1;
         if(fetch_status != 0)
			then
				FETCH Cur INTO Student_Fees_Installment_Details_Id_,Fees_Amount_;  
			end if;
	END WHILE;
Close Cur;
 end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Update_Password_Mobile`(In Student_Id_ int,
Password_ varchar(100))
BEGIN
update student set Password=Password_
where Student_Id=Student_Id_ and  DeleteStatus=0;
select Student_Id_ Student_Id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `update_Read_Status`(In login_user_ int,Notification_Id_ int)
BEGIN
update notification set Read_Status =1 where Notification_Id = Notification_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Update_Resume_Status`(In Resume_Status_Id_ int,Resume_Status_Name_ varchar(200),Student_Id_ int)
BEGIN
declare old_resume_status_id_ int;declare old_resume_status_name_ varchar(100);declare Change_status_ INT;declare new_resume_status_id_ int;
SET Change_status_ =0;
set old_resume_status_id_ = (select Resume_Status_Id from student  Where Student_Id=Student_Id_ and DeleteStatus=0);
set old_resume_status_name_ = (select Resume_Status_Name from student  Where Student_Id=Student_Id_ and DeleteStatus=0);
set new_resume_status_id_ =Resume_Status_Id_;

if(old_resume_status_id_ != new_resume_status_id_)
then SET Change_status_  =1;
end if;


UPDATE student set Resume_Status_Id = Resume_Status_Id_,Resume_Status_Name=Resume_Status_Name_
 Where Student_Id=Student_Id_ and DeleteStatus=0 ;
# select  Student_Id_,Change_status_;
 select Device_Id,Student_Name,Phone,Student_Id_,Change_status_,Resume_Status_Name_,Resume_Status_Id_ from student  Where Student_Id=Student_Id_ and DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `Upload_Resume`( In Docs_ Json,Document_value_ int)
Begin
DECLARE Student_Id_ int;
declare Resume_  varchar(4000);
declare Image_ResumeFilename_ varchar(4000);
declare Item_Images_Id_  int;
declare SlNo_  varchar(100);
Declare i int default 0;
declare Student_Name_  varchar(100);
declare To_User_ int;
declare To_User_Name_ varchar(100);
declare Notification_Type_Name_ varchar(100);
declare Notification_Id_ int;
declare Notification_Count_ int;
declare Entry_Type_ int;
declare Unread_Status int;


SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Student_Id')) INTO Student_Id_;
if( Document_value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Resume')) INTO Resume_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Image_ResumeFilename')) INTO Image_ResumeFilename_;
end if;

if(Student_Id_>0)
then
 
update student set Resume = Resume_,Image_ResumeFilename=Image_ResumeFilename_,Resume_Status_Id=1,Resume_Status_Name ='Non verified'
 where Student_Id = Student_Id_;
set Student_Name_ =(select  Student_Name from student where Student_Id=Student_Id_ and DeleteStatus=0 limit 1);
end if;

set To_User_=(select Users_Id from application_settings where DeleteStatus=0 );
set To_User_Name_=(select Users_Name from application_settings where DeleteStatus=0);
set Unread_Status=(select Read_Status from Notification where DeleteStatus=0 and Student_Id=Student_Id_ order by Notification_Id limit 1 );

if (To_User_>0)then
set Notification_Type_Name_ =(select Notification_Type_Name from Notification_Type where Notification_Type_Id=1);
set Entry_Type_ =1;
    if(Unread_Status = 0) then    
SET Notification_Id_ = (SELECT  COALESCE( MAX(Notification_Id ),0)+1 FROM Notification);
insert into Notification (Notification_Id,To_User,To_User_Name,Status_Id,Status_Name,View_Status,Remark,Entry_Date,Student_Id,Student_Name,DeleteStatus,
    Description,Entry_Type,Read_Status)
values(Notification_Id_,To_User_,To_User_Name_,0,'',1,'',now(),Student_Id_,Student_Name_,false,Notification_Type_Name_,Entry_Type_,0);

set Notification_Count_ = (SELECT  COALESCE( MAX(Notification_Count ),0)+1 FROM users where Users_Id = To_User_);    
update users set Notification_Count = Notification_Count_ where Users_Id=To_User_;              
end if;
end if;

select Student_Id_,Student_Name_,Entry_Type_,Notification_Type_Name_,Notification_Id_,To_User_,To_User_Name_;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `View_Job`( In Job_Posting_Id_ Int)
Begin 
 SELECT  Job_Code,Job_Title,Descritpion,Company_Name,Salary,
 (Date_Format(Last_Date,'%d-%m-%Y')) as Last_Date
  From job_posting where Job_Posting_Id =Job_Posting_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `View_Job_Interview`(In Job_Posting_Id_ int,Student_Id_ int)
Begin  
select Job_Posting_Id,Job_Code,Job_Title,Descritpion,(Date_Format(applied_jobs.Interview_Date,'%d-%m-%Y')) As Last_Date,
Company_Name,Salary,Interview_Attending_Rejecting,applied_jobs.Applied_Jobs_Id,Student_Id
from job_posting inner join applied_jobs on applied_jobs.job_id=Job_Posting_Id
WHERE job_posting.DeleteStatus = false and job_posting.Job_Posting_Id=Job_Posting_Id_ and Student_Id = Student_Id_;
End$$
DELIMITER ;
