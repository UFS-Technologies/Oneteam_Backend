DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Accounts_Typeahead`( In Account_Group_Id_ varchar(100),Client_Accounts_Name_ varchar(100))
Begin 
	set Client_Accounts_Name_ = Concat( "'%",Client_Accounts_Name_ ,"%'");
Set @query=CONCAT("	SELECT Client_Accounts_Id Bank_Id,Client_Accounts_Name Bank_Name,Address1 Holder,Address2 Accno,Address3 Swift,Address4 Branch,PinCode Ifsc
	From Client_Accounts 
    where Account_Group_Id IN(",Account_Group_Id_,") and Client_Accounts_Name like ",  Client_Accounts_Name_," and DeleteStatus=false 
    ORDER BY Client_Accounts_Name Asc Limit 5 ");
     PREPARE QUERY FROM @query;EXECUTE QUERY;
  # select @query;
    
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Cancel_Production`(In Proforma_Invoice_Master_Id_ int)
BEGIN

update Proforma_Invoice_Master set Proforma_Status=5 where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;
insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,DeleteStatus)
values(1,curdate(),Proforma_Invoice_Master_Id_,'Cancel Production',5,'',False);
select Proforma_Invoice_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Clear_data`()
BEGIN
delete from Accounts;
delete from finishedgoods_purchase_details;
delete from finishedgoods_purchase_master;
delete from gate_pass_details;
delete from gate_pass_master;
delete from gate_pass_in_details;
delete from gate_pass_in_master;
delete from journal_entry;
delete from contra_entry;
delete from order_tracking_history;
delete from packing_details;
delete from packing_details_wastage;
delete from packing_master;
delete from packing_plan_details;
delete from packing_plan_master;
delete from packing_stock;
delete from pallets_details;
delete from pallets_master;
delete from pallets_stock;
delete from payment_voucher;
delete from production_details;
delete from production_details_process;
delete from  production_details_rawmaterial;
delete from production_details_wastage;
delete from production_master;
delete from proforma_invoice_details;
delete from proforma_invoice_master;
delete from proforma_pack_list;
delete from purchase_details;
delete from purchase_master;
delete from purchase_order_customer;
delete from purchase_order_customer_details;
delete from purchase_order_details;
delete from purchase_order_master;
delete from purchase_purchasereturn;
delete from purchase_return_details;
delete from purchase_return_master;
delete from purchaseorder_sales;
delete from receipt_voucher;
delete from salary_calculation_details;
delete from salary_calculation_master;
delete from sales_details;
delete from sales_master;
delete from sales_pack_list;
delete from sales_packing_list;
delete from shift_end_details;
delete from shift_end_details_wastage;
delete from shift_end_master;
delete from shift_start_details;
delete from shift_start_details_process;
delete from shift_start_details_rawmaterial;
delete from shift_start_details_wastage;
delete from shift_start_master;
delete from shipment_details;
delete from shipment_master;
delete from stock_add_details;
delete from stock_add_master;
delete from stock_transfer_details;
delete from stock_transfer_master;
delete from waste_in_details;
delete from waste_in_master;
delete from waste_out_details;
delete from waste_out_master;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Closed_Production`(In Production_Master_Id_ int,Production_Status_ int,User_Id_ int)
BEGIN
declare New_Status_ int;declare Shipment_Master_Id_ int;
declare Proforma_Invoice_Master_Id_ int;declare Purchase_Order_Master_Id_ int;
if Production_Status_=7 then
 set New_Status_=9;
 else set New_Status_=7;
end if;
set Proforma_Invoice_Master_Id_=(select Proforma_Invoice_Master_Id from production_master where Production_Master_Id=Production_Master_Id_);
set Shipment_Master_Id_=(select Shipment_Master_Id from proforma_invoice_master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);
set Purchase_Order_Master_Id_=(select Purchase_Order_Master_Id from shipment_master where Shipment_Master_Id=Shipment_Master_Id_);
update Production_Master set Production_Status=New_Status_ where Production_Master_Id=Production_Master_Id_;
  
update proforma_invoice_master set Proforma_Status=New_Status_ where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;
update purchase_order_master set Order_Status=New_Status_ where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;
if New_Status_=7 then
insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,curdate(),Production_Master_Id_,'Production Closed',New_Status_,'',Purchase_Order_Master_Id_,False);
else 
insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,curdate(),Production_Master_Id_,'Production Start',New_Status_,'',Purchase_Order_Master_Id_,False);
end if;
select Production_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Create_Production_Customer`(in Purchase_Order_Customer_Id_ int)
BEGIN
select  Purchase_Order_Customer_Id ,(Date_Format(purchase_order_customer.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
	Company_Id,User_Id Client_Accounts_Id,PONo,Currency,Shipment_Method_Id,Payment_Term,Delivery_Port,Shipmet_Plan_Id,No_of_Shipment,
    Description,Order_Status,TotalAmount,Client_Accounts_Name Customer,Purchase_Order_Master_Id,
    Client_Accounts.Address1,Address2,Address3,Address4,PinCode,GSTNo,Mobile
	From purchase_order_customer   
    inner join client_accounts on client_accounts.Client_Accounts_Id=purchase_order_customer.User_Id
	where purchase_order_customer.DeleteStatus=false and Purchase_Order_Customer_Id=Purchase_Order_Customer_Id_;
        
SELECT Purchase_Order_Status_Id,Purchase_Order_Status_Name From Purchase_Order_Status where DeleteStatus=false;

Select Shipment_Method_Id,Shipment_Method_Name from shipment_method where DeleteStatus=false;

Select * from company where DeleteStatus=false;

Select Shipment_Plan_Id,Shipment_Plan_Name from shipment_plan where DeleteStatus=false;

 SELECT
	Purchase_Order_Customer_Details_Id,Purchase_Order_Customer_Id,Item_Name,Packing_Size,Colour,Description,Unit_Price,Quantity,Amount
    from purchase_order_Customer_details where Purchase_Order_Customer_Id=Purchase_Order_Customer_Id_
    and DeleteStatus=false;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Account_Group`( In Account_Group_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
  if exists(select Account_Group_Id from Account_Group where  DeleteStatus=False and 
 Account_Group_Id =Account_Group_Id_ and Account_Group_Id  not in
(select Client_Accounts.Account_Group_Id  from Client_Accounts where DeleteStatus=False))
  then
 update Account_Group set DeleteStatus=true where Account_Group_Id =Account_Group_Id_ ;
set DeleteStatus_=1;
else
set DeleteStatus_=0;
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Check_In`(in Attendance_Master_Id_ int)
BEGIN
Update Attendance_Master set DeleteStatus=1 where Attendance_Master_Id=Attendance_Master_Id_;
Update Attendance_Details set DeleteStatus=1 where Attendance_Master_Id=Attendance_Master_Id_;
select Attendance_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Client_Accounts`( In Client_Accounts_Id_ Int)
Begin 
declare DeleteStatus_ bit;
if exists(select Client_Accounts_Id from Client_Accounts where  DeleteStatus=False and
Client_Accounts_Id =Client_Accounts_Id_  and Client_Accounts_Id  not in
(select ifnull(purchase_order_master.Client_Accounts_Id,0) Client_Accounts_Id  from purchase_order_master where DeleteStatus=False)
and Client_Accounts_Id  not in
(select ifnull(proforma_invoice_master.Client_Accounts_Id,0) Client_Accounts_Id  from proforma_invoice_master where DeleteStatus=False)
and Client_Accounts_Id  not in
(select ifnull(proforma_invoice_master.Bank_Id,0) Bank_Id  from proforma_invoice_master where DeleteStatus=False)
and Client_Accounts_Id  not in
(select ifnull(sales_master.Account_Party_Id,0) Account_Party_Id  from sales_master where DeleteStatus=False)
and Client_Accounts_Id  not in
(select ifnull(waste_in_master.Client_Accounts_Id,0) Client_Accounts_Id  from waste_in_master where DeleteStatus=False)
and Client_Accounts_Id  not in
(select ifnull(gate_pass_in_master.Employee_Id,0) Employee_Id  from gate_pass_in_master where DeleteStatus=False)
and Client_Accounts_Id  not in
(select ifnull(waste_out_master.Client_Accounts_Id,0) Client_Accounts_Id  from waste_out_master where DeleteStatus=False)
and Client_Accounts_Id  not in
(select ifnull(purchase_master.Account_Party_Id,0) Account_Party_Id  from purchase_master where DeleteStatus=False)
)
then
update Client_Accounts set DeleteStatus=True where Client_Accounts.Client_Accounts_Id=Client_Accounts_Id_;
set DeleteStatus_=true;
else
set DeleteStatus_=false;
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Contra_Entry`( In Contra_Entry_Id_ Int)
Begin 
 update Contra_Entry set DeleteStatus=true where Contra_Entry_Id =Contra_Entry_Id_ ;
  DELETE FROM Accounts WHERE Tran_Type='CE' AND Tran_Id=Contra_Entry_Id_;
 select Contra_Entry_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Damaged_Item`( In Damaged_Item_Id_ Int)
Begin 
 update Damaged_Item set DeleteStatus=true where Damaged_Item_Id =Damaged_Item_Id_ ;
   
 select Damaged_Item_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Employee_Details`( In Client_Accounts_Id_ Int)
Begin
declare DeleteStatus_ bit;
if exists(select Client_Accounts_Id from Client_Accounts where  DeleteStatus=False and
Client_Accounts_Id =Client_Accounts_Id_  and Client_Accounts_Id  not in
(select shift_end_details.Employee_Id  from shift_end_details where DeleteStatus=False)
and Client_Accounts_Id =Client_Accounts_Id_  and Client_Accounts_Id  not in
(select packing_details.Employee_Id  from packing_details where DeleteStatus=False)
)
then
update Client_Accounts set DeleteStatus=True where Client_Accounts.Client_Accounts_Id=Client_Accounts_Id_;
update Employee_Details set DeleteStatus=true where Client_Accounts_Id =Client_Accounts_Id_ ;
 set DeleteStatus_=true;
else
set DeleteStatus_=false;
end if;
select DeleteStatus_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Employee_Overtime_Master`(in Employee_Overtime_Master_Id_ int)
BEGIN

update employee_overtime_master set DeleteStatus=true where Employee_Overtime_Master_Id=Employee_Overtime_Master_Id_;
update employee_overtime_details set DeleteStatus=true where Employee_Overtime_Master_Id=Employee_Overtime_Master_Id_;

select Employee_Overtime_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Finishedgoods_Purchase_Order`( In FinishedGoods_Purchase_Master_Id_ Int)
Begin 
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);declare fetch_status decimal(18,0);
Declare Cur Cursor for select  FinishedGoods_Purchase_Details.StockId,WareHouse_Id,Quantity 
from FinishedGoods_Purchase_Details 
inner join FinishedGoods_Purchase_Master on FinishedGoods_Purchase_Details.FinishedGoods_Purchase_Master_Id=FinishedGoods_Purchase_Master.FinishedGoods_Purchase_Master_Id
where FinishedGoods_Purchase_Master.FinishedGoods_Purchase_Master_Id=FinishedGoods_Purchase_Master_Id_;
set fetch_status=(select Count(FinishedGoods_Purchase_Details_Id) from FinishedGoods_Purchase_Details where 
FinishedGoods_Purchase_Master_Id=FinishedGoods_Purchase_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
	While(fetch_status != 0)do
		update Stock_Details set Quantity=Quantity-Quantity_ 
		where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_;
		set fetch_status=fetch_status-1;
         if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
	END WHILE;
Close Cur;
delete from Accounts where Tran_Type='PU' and Tran_Id=FinishedGoods_Purchase_Master_Id_;
update FinishedGoods_Purchase_Details set DeleteStatus=true where FinishedGoods_Purchase_Details.FinishedGoods_Purchase_Master_Id =FinishedGoods_Purchase_Master_Id_ ;
 update FinishedGoods_Purchase_Master set DeleteStatus=true where FinishedGoods_Purchase_Master.FinishedGoods_Purchase_Master_Id =FinishedGoods_Purchase_Master_Id_ ;
 select FinishedGoods_Purchase_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Gate_Pass_In_Master`(In Gate_Pass_In_Master_Id_ int)
BEGIN
 update gate_pass_in_master set DeleteStatus=true where Gate_Pass_In_Master_Id =Gate_Pass_In_Master_Id_ ;
 update gate_pass_in_details set DeleteStatus=true where Gate_Pass_In_Master_Id =Gate_Pass_In_Master_Id_ ;
   select Gate_Pass_In_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Gate_Pass_Master`(In Gate_Pass_Master_Id_ int)
BEGIN
 update gate_pass_master set DeleteStatus=true where Gate_Pass_Master_Id =Gate_Pass_Master_Id_ ;
 update gate_pass_details set DeleteStatus=true where Gate_Pass_Master_Id =Gate_Pass_Master_Id_ ;
   select Gate_Pass_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_HSN`( In HSN_Id_ Int)
Begin
  declare DeleteStatus_ bit;
if exists(select HSN_Id from HSN where  DeleteStatus=False and HSN_Id =HSN_Id_
and HSN_Id  not in
(select proforma_invoice_details.HSN_Id  from proforma_invoice_details where DeleteStatus=False)
and HSN_Id  not in
(select purchase_details.HSN_Id  from purchase_details where DeleteStatus=False)
and HSN_Id  not in
(select purchase_order_details.HSN_Id  from purchase_order_details where DeleteStatus=False)
and HSN_Id  not in
(select purchase_return_details.HSN_Id  from purchase_return_details where DeleteStatus=False)
and HSN_Id  not in
(select Stock_Add_Details.HSN_Id  from Stock_Add_Details where DeleteStatus=False)
and HSN_Id  not in
(select sales_details.HSN_Id  from sales_details where DeleteStatus=False)
and HSN_Id  not in
(select stock_add_details.HSN_Id  from stock_add_details where DeleteStatus=False))
then
 update HSN set DeleteStatus=true where HSN_Id =HSN_Id_ ;
set DeleteStatus_=True;
else
set DeleteStatus_=False;  
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Item`( In Item_Id_ Int)
Begin
  declare DeleteStatus_ bit;
if exists(select Item_Id from Item where  DeleteStatus=False and
 Item_Id =Item_Id_ and Item_Id  not in
(select gate_pass_details.Item_Id  from gate_pass_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select gate_pass_in_details.Item_Id  from gate_pass_in_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select packing_details_wastage.Item_Id  from packing_details_wastage where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select packing_details_wastage.Item_Id  from packing_details_wastage where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select packing_master.Item_Id  from packing_master where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select packing_plan_details.Item_Id  from packing_plan_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select process_list.Item_Id  from process_list where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select production_details.Item_Id  from production_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select production_details_process.Item_Id  from production_details_process where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select production_details_rawmaterial.Item_Id  from production_details_rawmaterial where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select production_details_rawmaterial.Item_Id  from production_details_rawmaterial where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select production_details_wastage.Item_Id  from production_details_wastage where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select production_master.Item_Id  from production_master where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select proforma_invoice_details.Item_Id  from proforma_invoice_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select proforma_pack_list.ItemId  from proforma_pack_list where DeleteStatus=False and ItemId =Item_Id_)
and Item_Id  not in
(select purchase_details.ItemId  from purchase_details where DeleteStatus=False and ItemId =Item_Id_)
and Item_Id  not in
(select purchase_order_details.Item_Id  from purchase_order_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select purchase_return_details.Item_Id  from purchase_return_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select raw_material.Item_Id  from raw_material where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select sales_details.ItemId  from sales_details where DeleteStatus=False and ItemId =Item_Id_)
and Item_Id  not in
(select sales_pack_list.ItemId  from sales_pack_list where DeleteStatus=False and ItemId =Item_Id_)
and Item_Id  not in
(select sales_packing_list.ItemId  from sales_packing_list where DeleteStatus=False and ItemId =Item_Id_)
and Item_Id  not in
(select shift_end_details_wastage.Item_Id  from shift_end_details_wastage where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select shift_end_master.Item_Id  from shift_end_master where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select shipment_details.Item_Id  from shipment_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select stock_add_details.ItemId  from stock_add_details where DeleteStatus=False and ItemId =Item_Id_)
and Item_Id  not in
(select stock_transfer_details.Item_Id  from stock_transfer_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select waste_in_details.Item_Id  from waste_in_details where DeleteStatus=False and Item_Id =Item_Id_)
and Item_Id  not in
(select waste_out_details.Item_Id  from waste_out_details where DeleteStatus=False and Item_Id =Item_Id_))
then
update Item set DeleteStatus=True where Item.Item_Id=Item_Id_;
update process_list set DeleteStatus=True where Item_Id = Item_Id_;
update raw_material  set DeleteStatus=True where Item_Id = Item_Id_;
update wastage  set DeleteStatus=True where Item_Id = Item_Id_;
set DeleteStatus_=True;
else
set DeleteStatus_=False;
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Item_Group`( In Item_Group_Id_ Int)
Begin
  declare DeleteStatus_ bit;
if exists(select Item_Group_Id from Item_Group where  DeleteStatus=False and
 Item_Group_Id =Item_Group_Id_ and Item_Group_Id  not in
(select Item.Group_Id  from Item where DeleteStatus=False)
 and Item_Group_Id  not in
(select proforma_invoice_details.Group_Id  from proforma_invoice_details where DeleteStatus=False)
and Item_Group_Id  not in
(select purchase_details.Group_Id  from purchase_details where DeleteStatus=False)
and Item_Group_Id  not in
(select purchase_order_details.Group_Id  from purchase_order_details where DeleteStatus=False)
and Item_Group_Id  not in
(select purchase_return_details.Group_Id  from purchase_return_details where DeleteStatus=False)
and Item_Group_Id  not in
(select sales_details.Group_Id  from sales_details where DeleteStatus=False)
and Item_Group_Id  not in
(select stock_add_details.Group_Id  from stock_add_details where DeleteStatus=False))
then
 update Item_Group set DeleteStatus=true where Item_Group_Id =Item_Group_Id_ ;
set DeleteStatus_=True;
else
set DeleteStatus_=False;
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Journal_Entry`( In Journal_Entry_Id_ Int)
Begin 
 update Journal_Entry set DeleteStatus=true where Journal_Entry_Id =Journal_Entry_Id_ ;
  DELETE FROM Accounts WHERE Tran_Type='JE' AND Tran_Id=Journal_Entry_Id_;
 select Journal_Entry_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Packing`(In Packing_Master_Id_ int,Company_Id_ int)
BEGIN
declare Acceptable_Quantity_ decimal(18,3);declare WareHouse_Id_ int;declare Stock_Id_ int;

 call Update_StockFrom_Packing(Packing_Master_Id_,Company_Id_);
 set Acceptable_Quantity_=(select Acceptable_Quantity from packing_master where  Packing_Master_Id=Packing_Master_Id_);
  set WareHouse_Id_=(select WareHouse_Id_ from packing_master where  Packing_Master_Id=Packing_Master_Id_);
  	set Stock_Id_=(select Stock_Id from Packing_master where  Packing_Master_Id=Packing_Master_Id_);
update Stock_Details Set Quantity=Quantity-Acceptable_Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_;    
update packing_details set DeleteStatus=true where Packing_Master_Id=Packing_Master_Id_;
update packing_details_wastage set DeleteStatus=true where Packing_Master_Id=Packing_Master_Id_;
update packing_master set DeleteStatus=true where Packing_Master_Id=Packing_Master_Id_;
update packing_stock set DeleStatus=true where Packing_Id=Packing_Master_Id_;
update pallets_stock set DeleteStatus=true where Packing_Master_Id=Packing_Master_Id_;
select Packing_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Packing_Plan_Master`( In Packing_Plan_Master_Id_ Int,Company_Id_ int)
Begin 
call  Update_StockFrom_PackingPlan(Packing_Plan_Master_Id_,Company_Id_);
 update packing_plan_master set DeleteStatus=true where Packing_Plan_Master_Id =Packing_Plan_Master_Id_ ;
 update packing_plan_details set DeleteStatus=true where Packing_Plan_Master_Id =Packing_Plan_Master_Id_ ;
 select Packing_Plan_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Pallets_Transfer`(in Pallets_Master_Id_ int,Company_Id_ int,To_Company_Id_ int)
BEGIN
declare From_Warehouse_Id_ decimal(18,0);declare To_Warehouse_Id_ decimal(18,0);declare Stock_Id_ decimal(18,0);
declare Pallet_Id_ decimal(18,0);declare From_company_Id_ int;
set From_Warehouse_Id_=(select From_Warehouse_Id from pallets_master where Pallets_Master_Id=Pallets_Master_Id_);
set To_Warehouse_Id_=(select To_Warehouse_Id from pallets_master where Pallets_Master_Id=Pallets_Master_Id_);
set Stock_Id_=(select Stock_Id from pallets_master where Pallets_Master_Id=Pallets_Master_Id_);
set Pallet_Id_=(select Pallet_Id from pallets_master where Pallets_Master_Id=Pallets_Master_Id_);
set From_company_Id_=(select Company_Id from pallets_master where Pallets_Master_Id=Pallets_Master_Id_);
update Pallets_Stock set Warehouse_Id=From_Warehouse_Id_,Company_Id=From_company_Id_  where Stock_Id=Stock_Id_
 and Warehouse_Id=To_Warehouse_Id_ and Pallet_Id=Pallet_Id_ and DeleteStatus=0;
update Pallets_Master set DeleteStatus=true where Pallets_Master_Id=Pallets_Master_Id_;
select Pallets_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Payment_Voucher`( In Payment_Voucher_Id_ Int)
Begin 
 update Payment_Voucher set DeleteStatus=true where Payment_Voucher_Id =Payment_Voucher_Id_ ;
   DELETE FROM Accounts WHERE Tran_Type='PV' AND Tran_Id=Payment_Voucher_Id_;
 select Payment_Voucher_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Press_Details`( In Press_Details_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
if exists(select Press_Details_Id from press_details where  DeleteStatus=False and 
 Press_Details_Id =Press_Details_Id_ and Press_Details_Id  not in
(select packing_master.Press_Details_Id  from packing_master where DeleteStatus=False)
and Press_Details_Id  not in
(select shift_end_master.Press_Details_Id  from shift_end_master where DeleteStatus=False))
then
 update press_details set DeleteStatus=true where Press_Details_Id =Press_Details_Id_ ;
set DeleteStatus_=1;
else
set DeleteStatus_=0;  
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Process_Details`( In Process_Details_Id_ Int)
Begin 
 update process_details set DeleteStatus=true where Process_Details_Id =Process_Details_Id_ ;
 select Process_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Production`(in Production_Master_Id_ int)
BEGIN
declare DeleteStatus_ bit;
	if exists(select Production_Master_Id from Production_Master where  DeleteStatus=False and 
	Production_Master_Id =Production_Master_Id_ and Production_Master_Id  not in
	(select Production_Master_Id  from shift_end_master where DeleteStatus=False))
then
	#call Update_Stock_FromProduction_Rawmaterial(Production_Master_Id_, Company_Id_);  
	update proforma_invoice_details set Production_Master_Id=0  where Production_Master_Id=Production_Master_Id_;
	update production_master set DeleteStatus=true,Production_Status=5 where Production_Master_Id=Production_Master_Id_;
	update production_details_process set DeleteStatus=true where Production_Master_Id=Production_Master_Id_;
	update production_details_rawmaterial set DeleteStatus=true where Production_Master_Id=Production_Master_Id_;
	update production_details_wastage set DeleteStatus=true where Production_Master_Id=Production_Master_Id_;    
	select Production_Master_Id_;
set DeleteStatus_=1;
else
set DeleteStatus_=0;  
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Proforma_Invoice_Master`( In Proforma_Invoice_Master_Id_ Int)
Begin 
declare DeleteStatus_ int;  declare Production_Id_ int;  declare Sales_Id_ int; declare pocount int;declare Purchase_Order_Master_Id_ int;
declare Shipment_Master_Id_ int;
	set Production_Id_=(select count(Production_Master.Proforma_Invoice_Master_Id)  from Production_Master 
    where DeleteStatus=False and  Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_);
	set Sales_Id_=(select count(sales_master.Proforma_Invoice_Master_Id)  from sales_master 
    where DeleteStatus=False and Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_);
    set Purchase_Order_Master_Id_=(select Purchase_Order_Master_Id from Proforma_Invoice_Master
    where Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_ );
    set Shipment_Master_Id_=(select Shipment_Master_Id from Proforma_Invoice_Master where Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_);
    if Production_Id_=0 and Sales_Id_=0 then
		update Proforma_Invoice_Details set DeleteStatus=true where Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_ ;
        set pocount=(select count(Purchase_Order_Master_Id) from Shipment_Master where Purchase_Order_Master_Id=Purchase_Order_Master_Id_ 
        and Proforma_Invoice_Master_Id>0);
        if(pocount=1)then
			update purchase_order_master set Order_Status=1 where Purchase_Order_Master_Id=Purchase_Order_Master_Id_; 
        end if;        
		update Shipment_Master set Master_Status=0,Proforma_Invoice_Master_Id=0 where Shipment_Master_Id=Shipment_Master_Id_;        
		update Proforma_Invoice_Master set DeleteStatus=true ,Proforma_Status =2 where Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_ ;
		set DeleteStatus_=1;
	elseif Production_Id_ >0 and Sales_Id_ >0 then 
		set DeleteStatus_=-3;  
	elseif Production_Id_ >0 then 
		set DeleteStatus_=-2;  
	elseif Sales_Id_ >0 then 
		set DeleteStatus_=-1;  
   end if;
select DeleteStatus_ ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Purchase_Master`( In Purchase_Master_Id_ Int,Company_Id_ int)
Begin
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);declare fetch_status decimal(18,0);
Declare Cur Cursor for select  Purchase_Details.StockId,WareHouse_Id,Quantity
from Purchase_Details
where Purchase_Master_Id=Purchase_Master_Id_;
set fetch_status=(select Count(Purchase_Details_Id) from Purchase_Details where
Purchase_Master_Id=Purchase_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity-Quantity_
where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
set fetch_status=fetch_status-1;
         if(fetch_status != 0)
then
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
end if;
END WHILE;
Close Cur;
delete from Accounts where Tran_Type='PU' and Tran_Id=Purchase_Master_Id_;
update Purchase_Details set DeleteStatus=true where Purchase_Details.Purchase_Master_Id =Purchase_Master_Id_ ;
 update Purchase_Master set DeleteStatus=true where Purchase_Master.Purchase_Master_Id =Purchase_Master_Id_ ;
 select Purchase_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Purchase_Order_Customer`( In Purchase_Order_Customer_Id_ Int)
Begin 
declare DeleteStatus_ bit;
if exists(select Purchase_Order_Customer_Id from purchase_order_customer where  DeleteStatus=False and 
 Purchase_Order_Customer_Id =Purchase_Order_Customer_Id_ and Purchase_Order_Customer_Id  not in 
 (select Purchase_Order_Customer_Id  from purchase_order_master where DeleteStatus=False))
 then
	update purchase_order_customer set DeleteStatus=true where Purchase_Order_Customer_Id =Purchase_Order_Customer_Id_ ;    
	update purchase_order_customer_details set DeleteStatus=true where Purchase_Order_Customer_Id =Purchase_Order_Customer_Id_ ;      
set DeleteStatus_=1;
	else
	set DeleteStatus_=0;  
	end if;
	select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Purchase_Order_Master`( In Purchase_Order_Master_Id_ Int)
Begin 
  declare DeleteStatus_ tinyint;
if exists(select Purchase_Order_Master_Id from Purchase_Order_Master where Purchase_Order_Master_Id =Purchase_Order_Master_Id_ 
and Purchase_Order_Master_Id  not in (select Purchase_Order_Master_Id  from Shipment_Master where DeleteStatus=False and Proforma_Invoice_Master_Id=0))
then
	update Purchase_Order_Master set DeleteStatus=true, Order_Status=15  where Purchase_Order_Master_Id =Purchase_Order_Master_Id_ ;    
	update Purchase_Order_Details set DeleteStatus=true where Purchase_Order_Master_Id =Purchase_Order_Master_Id_ ;      
	update shipment_details set DeleteStatus='True' where Shipment_Master_Id  in
    (select Shipment_Master_Id from Shipment_Master where Purchase_Order_Master_Id=Purchase_Order_Master_Id_);              
	update Shipment_Master  set DeleteStatus='True' where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;     
	set DeleteStatus_=1;
	else
	set DeleteStatus_=0;  
	end if;
	select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Purchase_Order_Master1`( In Purchase_Master_Id_ Int,Company_Id_ int)
Begin
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);declare fetch_status decimal(18,0);
Declare Cur Cursor for select  purchase_master_order_details.StockId,WareHouse_Id,Quantity
from purchase_master_order_details
where Purchase_Master_Id=Purchase_Master_Id_;
set fetch_status=(select Count(Purchase_Details_Id) from purchase_master_order_details where
Purchase_Master_Id=Purchase_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity-Quantity_
where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
set fetch_status=fetch_status-1;
         if(fetch_status != 0)
then
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
end if;
END WHILE;
Close Cur;
delete from Accounts where Tran_Type='PU' and Tran_Id=Purchase_Master_Id_;
update purchase_master_order_details set DeleteStatus=true where purchase_master_order_details.Purchase_Master_Id =Purchase_Master_Id_ ;
 update purchase_master_order set DeleteStatus=true where purchase_master_order.Purchase_Master_Id =Purchase_Master_Id_ ;
 select Purchase_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Purchase_Order_Track_Master`( In Purchase_Order_Master_Id_ Int)
Begin 
  declare DeleteStatus_ tinyint;

	update purchase_order_track_master set DeleteStatus=true  where Purchase_Order_Track_Master_Id =Purchase_Order_Master_Id_ ;    
	update purchase_order_track_details set DeleteStatus=true where Purchase_Order_Track_Master_Id =Purchase_Order_Master_Id_ ;      
  
	set DeleteStatus_=1;
	select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Purchase_Return_Master`( In Purchase_Return_Master_Id_ Int,Company_Id_ int)
Begin 
declare StockId_ decimal(18,0);
declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select  purchase_return_details.Stock_Id,WareHouse_Id,Quantity 
from Purchase_Return_Details 
inner join Purchase_Return_Master on Purchase_Return_Details.Purchase_Return_Master_Id=Purchase_Return_Master.Purchase_Return_Master_Id
where Purchase_Return_Master.Purchase_Return_Master_Id=Purchase_Return_Master_Id_;
set fetch_status=(select Count(Purcahse_Return_Details_Id) from Purchase_Return_Details where 
Purchase_Return_Master_Id=Purchase_Return_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
	While(fetch_status != 0)do
		update Stock_Details set Quantity=Quantity+Quantity_ 
		where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_ ;
		set fetch_status=fetch_status-1;
         if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
	END WHILE;
Close Cur;
delete from Accounts where Tran_Type='PR' and Tran_Id=Purchase_Return_Master_Id_;
update purchase_return_details set DeleteStatus=true where purchase_return_details.Purchase_Return_Master_Id =Purchase_Return_Master_Id_ ;
 update Purchase_Return_Master set DeleteStatus=true where Purchase_Return_Master.Purchase_Return_Master_Id =Purchase_Return_Master_Id_ ; 
 
 select Purchase_Return_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Purchase_Type`( In Purchase_Type_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
  
 if exists(select Purchase_Type_Id from Purchase_Type where  DeleteStatus=False and 
 Purchase_Type_Id =Purchase_Type_Id_  and Purchase_Type_Id  not in
(select purchase_master.Purchase_Type_Id  from purchase_master where DeleteStatus=False))
then
update Purchase_Type set DeleteStatus=True where Purchase_Type_Id =Purchase_Type_Id_;
set DeleteStatus_=1;
else
set DeleteStatus_=0;
end if;
select DeleteStatus_;

End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Receipt_Voucher`( In Receipt_Voucher_Id_ Int)
Begin 
 update Receipt_Voucher set DeleteStatus=true where Receipt_Voucher_Id =Receipt_Voucher_Id_ ;
   DELETE FROM Accounts WHERE Tran_Type='RV' AND Tran_Id=Receipt_Voucher_Id_;
 select Receipt_Voucher_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Salary_Calculation_Master`( In Salary_Calculation_Master_Id_ Int)
Begin 
update Salary_Calculation_Details set DeleteStatus=true where Salary_Calculation_Master_Id =Salary_Calculation_Master_Id_ ;
 update Salary_Calculation_Master set DeleteStatus=true where Salary_Calculation_Master_Id =Salary_Calculation_Master_Id_ ;
 select Salary_Calculation_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Sale_Unit`( In Sale_Unit_Id_ Int)
Begin
  declare DeleteStatus_ bit;
if exists(select Sale_Unit_Id from Sale_Unit where  DeleteStatus=False and
 Sale_Unit_Id =Sale_Unit_Id_ and Sale_Unit_Id  not in
(select item.Unit_Id  from item where DeleteStatus=False)
and Sale_Unit_Id  not in
(select proforma_invoice_details.Unit_Id  from proforma_invoice_details where DeleteStatus=False)
and Sale_Unit_Id  not in
(select purchase_details.Unit_Id  from purchase_details where DeleteStatus=False)
and Sale_Unit_Id  not in
(select purchase_order_details.Unit_Id  from purchase_order_details where DeleteStatus=False)
and Sale_Unit_Id  not in
(select purchase_return_details.Unit_Id  from purchase_return_details where DeleteStatus=False)
and Sale_Unit_Id  not in
(select sales_details.Unit_Id  from sales_details where DeleteStatus=False)
and Sale_Unit_Id  not in
(select stock_add_details.Unit_Id  from stock_add_details where DeleteStatus=False))
then
update Sale_Unit set DeleteStatus=True where Sale_Unit_Id=Sale_Unit_Id_;
set DeleteStatus_=True;
else
set DeleteStatus_=False;  
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Sales_Master`( In Sales_Master_Id_ Int,Company_Id_ int)
Begin 
declare StockId_ decimal(18,0);
declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select  Sales_Details.Stock_Id,WareHouse_Id,Quantity 
from Sales_Details 
inner join Sales_Master on Sales_Details.Sales_Master_Id=Sales_Master.Sales_Master_Id
where Sales_Master.Sales_Master_Id=Sales_Master_Id_;
set fetch_status=(select Count(Sales_Details_Id) from Sales_Details where 
Sales_Master_Id=Sales_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
	While(fetch_status != 0)do
		update Stock_Details set Quantity=Quantity+Quantity_ 
		where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id=Company_Id_;
		set fetch_status=fetch_status-1;
         if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
	END WHILE;
Close Cur;
delete from Accounts where Tran_Type='SA' and Tran_Id=Sales_Master_Id_;
update Sales_Details set DeleteStatus=true where Sales_Details.Sales_Master_Id =Sales_Master_Id_ ;
 update Sales_Master set DeleteStatus=true where Sales_Master.Sales_Master_Id =Sales_Master_Id_ ;
 select Sales_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Shift_Details`( In Shift_Details_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
if exists(select Shift_Details_Id_ from shift_details where  DeleteStatus=False and 
 Shift_Details_Id =Shift_Details_Id_ and Shift_Details_Id  not in
 
(select shift_end_master.Shift_Details_Id  from shift_end_master where DeleteStatus=False)
and Shift_Details_Id  not in

(select packing_master.Shift_Details_Id  from packing_master where DeleteStatus=False))
then
 update shift_details set DeleteStatus=true where Shift_Details_Id =Shift_Details_Id_ ;
set DeleteStatus_=1;
else
set DeleteStatus_=0;  
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Shift_End`(In Shift_End_Master_Id_ int,Company_Id_ int)
BEGIN
  call Update_StockFrom_Shiftend(Shift_End_Master_Id_,Company_Id_);    
update shift_end_details_wastage set DeleteStatus=true where Shift_End_Master_Id=Shift_End_Master_Id_;
update shift_end_details set DeleteStatus=true where Shift_End_Master_Id=Shift_End_Master_Id_;
update shift_end_master set DeleteStatus=true where Shift_End_Master_Id=Shift_End_Master_Id_;
select Shift_End_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Shift_Start`(in Shift_Start_Master_Id_ int,Company_Id_ int)
BEGIN
declare DeleteStatus_ bit;
	if exists(select Shift_Start_Master_Id from shift_start_master where  DeleteStatus=False and 
	Shift_Start_Master_Id =Shift_Start_Master_Id_ and Shift_Start_Master_Id  not in
	(select Shift_Start_Master_Id  from Shift_End_Master where DeleteStatus=False))
then
 call Update_Stock_Fromshift_start_details_Raw(Shift_Start_Master_Id_,Company_Id_);
	update shift_start_master set DeleteStatus=true,Shift_Start_Status=8  where Shift_Start_Master_Id=Shift_Start_Master_Id_;
	update shift_start_details_process set DeleteStatus=true where Shift_Start_Master_Id=Shift_Start_Master_Id_;
	update shift_start_details_rawmaterial set DeleteStatus=true where Shift_Start_Master_Id=Shift_Start_Master_Id_;
	update shift_start_details_wastage set DeleteStatus=true where Shift_Start_Master_Id=Shift_Start_Master_Id_;
	select Shift_Start_Master_Id_;
set DeleteStatus_=1;
else
set DeleteStatus_=0;  
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Shipment_Method`( In Shipment_Method_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
if exists(select Shipment_Method_Id_ from shipment_method where  DeleteStatus=False and 
 Shipment_Method_Id =Shipment_Method_Id_ and Shipment_Method_Id  not in
 (select purchase_order_master.Shipment_Method_Id  from purchase_order_master where DeleteStatus=False))
then
 update shipment_method set DeleteStatus=true where  Shipment_Method_Id =Shipment_Method_Id_  ;
set DeleteStatus_=1;
else
set DeleteStatus_=0;  
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Shipment_Plan`( In Shipment_Plan_Id_ Int)
Begin 
 declare DeleteStatus_ bit;
  
 if exists(select Shipment_Plan_Id from shipment_plan where  DeleteStatus=False and 
 Shipment_Plan_Id =Shipment_Plan_Id_  and Shipment_Plan_Id  not in
(select purchase_order_master.Shipmet_Plan_Id  from purchase_order_master where DeleteStatus=False))
then
update shipment_plan set DeleteStatus=True where Shipment_Plan_Id = Shipment_Plan_Id_ ;
set DeleteStatus_=1;
else
set DeleteStatus_=0;
end if;
select DeleteStatus_;

End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Stock_Add_Master`( In  Stock_Add_Master_Id_ Int,Company_Id_ INT)
Begin
declare StockId_ decimal(18,0);
declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select  Stock_Add_Details.StockId,WareHouse_Id,Quantity
from Stock_Add_Details where Stock_Add_Master_Id=Stock_Add_Master_Id_;
set fetch_status=(select Count(Stock_Add_Details_Id) from Stock_Add_Details where
Stock_Add_Master_Id=Stock_Add_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity-Quantity_
where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
set fetch_status=fetch_status-1;
if(fetch_status != 0)
then
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
end if;
END WHILE;
Close Cur;
update Stock_Add_Details set DeleteStatus=true where Stock_Add_Master_Id =Stock_Add_Master_Id_ ;
 update Stock_Add_Master set DeleteStatus=true where Stock_Add_Master_Id =Stock_Add_Master_Id_ ;
 select Stock_Add_Master_Id_; 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Stock_Transfer_Master`(in Stock_transfer_Master_Id_ int,
From_Company_Id_ int,To_Company_Id_ int)
BEGIN
declare Stock_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);  declare fetch_status decimal(18,0);
declare From_Stock_Id_ int; declare To_Stock_Id_ int;
Declare Cur Cursor for select  Stock_Id,From_Stock_Id,To_Stock_Id,Quantity
from Stock_Transfer_Details 
where Stock_transfer_Master_Id=Stock_transfer_Master_Id_;
set fetch_status=(select Count(Stock_transfer_Details_Id) from Stock_Transfer_Details 
where Stock_transfer_Master_Id=Stock_transfer_Master_Id_);
Open Cur;
FETCH Cur INTO Stock_Id_,From_Stock_Id_,To_Stock_Id_,Quantity_;
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity+Quantity_ 
where Stock_Id=Stock_Id_ and WareHouse_Id=From_Stock_Id_ and Company_Id=From_Company_Id_;    
update Stock_Details set Quantity=Quantity-Quantity_ 
where Stock_Id=Stock_Id_ and WareHouse_Id=To_Stock_Id_ and Company_Id=To_Company_Id_;    
set fetch_status=fetch_status-1;     
END WHILE;
Close Cur;
update stock_transfer_master set DeleteStatus=true where Stock_transfer_Master_Id=Stock_transfer_Master_Id_;
update stock_transfer_details set DeleteStatus=true where Stock_transfer_Master_Id=Stock_transfer_Master_Id_;
select Stock_transfer_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_User_Details`( In User_Details_Id_ Int)
Begin 
update User_Menu_Selection set DeleteStatus=true where User_Id =User_Details_Id_ ;
 update User_Details set DeleteStatus=true where User_Details_Id =User_Details_Id_ ;
 select User_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Warehouse`( In WareHouse_Id_ Int)
Begin 
  declare DeleteStatus_ bit;
if exists(select WareHouse_Id from warehouse where  DeleteStatus=False and 
 WareHouse_Id =WareHouse_Id_ and WareHouse_Id  not in 
(select proforma_invoice_details.WareHouse_Id  from proforma_invoice_details where DeleteStatus=False)
and WareHouse_Id  not in
(select purchase_details.WareHouse_Id  from purchase_details where DeleteStatus=False)
and WareHouse_Id  not in
(select purchase_return_details.WareHouse_Id  from purchase_return_details where DeleteStatus=False)
and WareHouse_Id  not in
(select stock_add_details.WareHouse_Id  from stock_add_details where DeleteStatus=False)
and WareHouse_Id  not in
(select sales_details.WareHouse_Id  from sales_details where DeleteStatus=False))
then
update warehouse set DeleteStatus=True where  WareHouse_Id =WareHouse_Id_;
set DeleteStatus_=1;
else
set DeleteStatus_=0;
end if;
select DeleteStatus_;
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Waste_In_Master`( In Waste_In_Master_Id_ Int,Company_Id_ int)
Begin 
# call Update_StockFrom_Wastein(Waste_In_Master_Id_,Company_Id_);
#delete from Accounts where Tran_Type='PU' and Tran_Id=Purchase_Master_Id_;
update Waste_In_Details set DeleteStatus=true where Waste_In_Details.Waste_In_Master_Id=Waste_In_Master_Id_ ;
 update Waste_In_Master set DeleteStatus=true where Waste_In_Master.Waste_In_Master_Id=Waste_In_Master_Id_  ;
 select Waste_In_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Delete_Waste_Out_Master`(In Waste_Out_Master_Id_ int,Company_Id_ int)
BEGIN
call Update_StockFrom_Wasteout(Waste_Out_Master_Id_,Company_Id_);
 update waste_out_master set DeleteStatus=true where Waste_Out_Master_Id =Waste_Out_Master_Id_ ;
 update waste_out_details set DeleteStatus=true where Waste_Out_Master_Id =Waste_Out_Master_Id_ ;
   DELETE FROM Accounts WHERE Tran_Type='WO' AND Tran_Id=Waste_Out_Master_Id_;
   select Waste_Out_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Barcode_Typeahead`( In Barcode_ varchar(100),WareHouse_Id_ int)
Begin 
 set Barcode_ = Concat( '%',Barcode_ ,'%');
SELECT Stock.Stock_Id,ItemId,ItemName,stock_details.Quantity,Barcode
From Stock
inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
where stock_details.WareHouse_Id=WareHouse_Id_ and Barcode like Barcode_ and Quantity>0 and Stock.DeleteStatus=false
ORDER BY Barcode ASC LIMIT 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Bill_Type`(Group_Id_ INT)
BEGIN
SELECT Bill_Type_Id,
Bill_Type_Name From Bill_Type where Group_Id=Group_Id_
order by Bill_Type_Name asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Check_In`(in Attendance_Master_Id_ int)
BEGIN
select case when Attendance_Details.Is_Employee>0 then 1 else 0 end as Check_Box,client_accounts.Client_Accounts_Id Employee_Id,
client_accounts.Client_Accounts_Name,Process_Details_Name,
ifnull(Attendance_Details.Employee_InTime,'')Employee_InTime
#,case when Attendance_Details.Employee_InTime<>null then '' else Attendance_Details.Employee_InTime end Employee_InTime
#ifnull(Attendance_Details.Attendance_Details_Id,0) Attendance_Details_Id,ifnull(Attendance_Details.Attendance_Master_Id,0) Attendance_Master_Id,
from employee_details
inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
inner join client_accounts  on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id 
AND employee_details.DeleteStatus=0 and Process_Details.Process_Details_Id<>5
left join Attendance_Details on employee_details.Client_Accounts_Id=Attendance_Details.Employee_Id 
and  Attendance_Details.Attendance_Master_Id=Attendance_Master_Id_ 
order by client_accounts.Client_Accounts_Name asc;   
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Check_Out`(In Attendance_Master_Id_ int)
BEGIN
select client_accounts.Client_Accounts_Id Employee_Id,client_accounts.Client_Accounts_Name,
ifnull(Attendance_Details.Attendance_Details_Id,0) Attendance_Details_Id,
ifnull(Attendance_Details.Attendance_Master_Id,0) Attendance_Master_Id,
Employee_InTime,Employee_OutTime,
ifnull(Attendance_Details.Normal_Hrs,0) Normal_Hrs,ifnull(Attendance_Details.Normal_Rate,0)  Normal_Rate,ifnull(Attendance_Details.Normal_Total,0) Normal_Total,
ifnull(Attendance_Details.Ot_Hrs,0) Ot_Hrs,ifnull(Attendance_Details.Ot_Rate,0) Ot_Rate,ifnull(Attendance_Details.Ot_Total,0) Ot_Total,
ifnull(Attendance_Details.Loading_Hrs,0) Loading_Hrs,ifnull(Attendance_Details.Loading_Rate,0) Loading_Rate,ifnull(Attendance_Details.Loading_Total,0) Loading_Total,
ifnull(Attendance_Details.No_Of_Piece,0) No_Of_Piece,ifnull(Attendance_Details.Piece_Rate,0) Piece_Rate,ifnull(Attendance_Details.Piece_Total,0) Piece_Total,
ifnull(Attendance_Details.Punch_Status,0) Punch_Status,ifnull(Attendance_Details.Other_Work,0) Other_Work,
ifnull(Attendance_Details.Other_Start_Time,0) Other_Start_Time,ifnull(Attendance_Details.Other_End_Time,0) Other_End_Time,
ifnull(Attendance_Details.Other_Total_Hrs,0) Other_Total_Hrs,ifnull(Attendance_Details.Other_Rate,0) Other_Rate,ifnull(Attendance_Details.Other_Total,0) Other_Total,
ifnull(Attendance_Details.Total,0) Total,
case when Attendance_Details.Is_Employee>0 then 1 else 0 end as Check_Box,Process_Details_Name
from employee_details inner join Process_Details 
on employee_details.Process_Id=Process_Details.Process_Details_Id inner join client_accounts  
on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id AND employee_details.DeleteStatus=0 inner join Attendance_Details
on employee_details.Client_Accounts_Id=Attendance_Details.Employee_Id and  Attendance_Details.Attendance_Master_Id=Attendance_Master_Id_ 
order by client_accounts.Client_Accounts_Name asc;   
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Client_Accounts`( In Client_Accounts_Id_ Int)
Begin 
 SELECT 
Address1,Address2,
 Address3,Address4,Mobile
From Client_Accounts 
where Client_Accounts_Id =Client_Accounts_Id_ and Client_Accounts.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Client_Accounts_Employee`( In Client_Accounts_Id_ Int)
Begin 
 SELECT 
 
 Client_Accounts_Id ,Account_Group_Id ,Client_Accounts_Code ,Client_Accounts_Name ,Address1 ,Address2 ,Address3,Address4 ,PinCode , 
StateCode ,GSTNo ,PanNo ,State ,Country,Phone ,Mobile , Email,Opening_Balance ,Description1 ,UserId ,Opening_Type

From Client_Accounts 
where Client_Accounts_Id =Client_Accounts_Id_ and Client_Accounts.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Employee_Details`( In Client_Accounts_Id_ Int)
Begin 
 SELECT 
Employee_Details_Id,Employee_Details.Client_Accounts_Id,Working_Status,Level_Id,Designation_Id,Process_Id,Designation,Ot_Rate,Normal_Rate,
(Date_Format(DateOfBirth,'%Y-%m-%d')) As DateOfBirth ,(Date_Format(DateOfJoin,'%Y-%m-%d')) As DateOfJoin ,
(Date_Format(ReleiveDate,'%Y-%m-%d')) As ReleiveDate ,Loading_Rate,Adhar_Number,Pan_Card_Number,Bank_Account_Details
 From Employee_Details 
# inner join Client_Accounts UE on Employee_Details.Manager_Id=UE.Client_Accounts_Id
where Employee_Details.Client_Accounts_Id =Client_Accounts_Id_ and Employee_Details.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Employee_Overtime_Details`(in Employee_Overtime_Master_Id_ int )
BEGIN
select Employee_Id,Employee_Overtime_Master_Id,Start_Time,End_Time,Rate,Total_Hours,
Total,Description,Client_Accounts_Name
from employee_overtime_details
inner join client_accounts on client_accounts.Client_Accounts_Id=employee_overtime_details.Employee_Id
where Employee_Overtime_Master_Id=Employee_Overtime_Master_Id_ and employee_overtime_details.DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Finishedgoods_Purchase_Order`( In Purchase_Master_Id_ Int)
Begin 
 SELECT 

FinishedGoods_Purchase_Details_Id,FinishedGoods_Purchase_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,
WareHouse_Id,WareHouse_Name,MFCode,UPC,SaleRate,MRP,Unit_Price,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_Amount,TotalAmount,
Include_Tax,Is_Expiry,(Date_Format(FinishedGoods_Purchase_Details.Expiry_Date,'%Y-%m-%d')) As Expiry_Date
 
From FinishedGoods_Purchase_Details
 #inner join Client_Accounts on FinishedGoods_Purchase_Details.To_Employee_Id=Client_Accounts.Client_Accounts_Id,Client_Accounts.Client_Accounts_Name To_Stock_Name
 where FinishedGoods_Purchase_Master_Id =Purchase_Master_Id_ and FinishedGoods_Purchase_Details.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Gate_Pass_Details`(In Gate_Pass_Master_Id_ int )
BEGIN
select Gate_Pass_Details_Id,Gate_Pass_Master_Id ,Item_Id ,Item_Name ,Quantity ,
Weight,Total_Quantity,Size,
IFNULL(No_Of_Piece, 0) as No_Of_Piece, 
IFNULL(No_Of_Rejection, 0) as No_Of_Rejection,
IFNULL(No_Of_Return, 0) as No_Of_Return
from gate_pass_details
where Gate_Pass_Master_Id=Gate_Pass_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Gate_Pass_In_Details`(In Gate_Pass_In_Master_Id_ int )
BEGIN
select Gate_Pass_In_Details_Id,Gate_Pass_In_Master_Id ,Item_Id ,Item_Name ,Quantity ,
Weight,Total_Quantity,Size,
IFNULL(No_Of_Piece, 0) as No_Of_Piece, 
IFNULL(No_Of_Rejection, 0) as No_Of_Rejection,
IFNULL(No_Of_Return, 0) as No_Of_Return
from gate_pass_in_details
where Gate_Pass_In_Master_Id=Gate_Pass_In_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Item_Stock_Id`(in Item_Id_ int)
BEGIN
select Stock_Id 
from stock
where ItemId=Item_Id_ and DeleteStatus=false
limit  1;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Menu_Permission`(In User_Id_ int)
BEGIN
select
User_Menu_Selection.Menu_Id,
User_Menu_Selection.IsEdit Menu_Edit,
User_Menu_Selection.IsDelete Menu_Delete ,
User_Menu_Selection.IsSave Menu_Save,
User_Menu_Selection.IsView VIew_All ,
User_Menu_Selection.Menu_Status
from User_Menu_Selection
inner join Menu on User_Menu_Selection.Menu_Id=Menu.Menu_Id
Where
User_Id=User_Id_ 
and User_Menu_Selection.IsView=1
order by Menu_Order Asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Menu_Status`(in User_Id_ int , Menu_Id_ int)
BEGIN
declare Menu_Status int;
set Menu_Status=0;
if exists(select Menu_Id from user_menu_selection where  DeleteStatus=False and
Menu_Id =Menu_Id_  and User_Id=User_Id_) then
 set Menu_Status=1;
end if;
select Menu_Status;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Menu_User_Permission`()
BEGIN
select Menu_Id,Menu_Name,Menu_Order,IsEdit,IsSave,IsDelete,IsView,Menu_Status
from menu_user
where DeleteStatus=false and  Menu_Status=true
order by Menu_Order Asc;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Packing_details`(in Packing_Master_Id_ int)
Begin 
declare Production_No_ int;
set Production_No_=(select Production_No from packing_master where Packing_Master_Id=Packing_Master_Id_ and DeleteStatus=0);

select client_accounts.Client_Accounts_Id Employee_Id,client_accounts.Client_Accounts_Name,
	case when Packing_details.Is_Employee>0 then 1 else 0 end as Check_Box ,
    Process_Details_Id,Process_Details_Name
	/*Packing_details.Start_Time,Packing_details.End_Time,Packing_details.Working_Hours,Packing_details.Ot,
	Packing_details.Loading,Packing_details.Normal_Rate,Packing_details.Ot_Rate,Packing_details.Loading_Rate,
	Packing_details.Working_Total,Packing_details.Ot_Total,Packing_details.Loading_Total,
    in (select Packing_details.Employee_Id from Packing_details where Packing_details.Packing_Master_Id=Packing_Master_Id_ union select employee_details.Client_Accounts_Id from employee_details 
	inner join  Packing_master on Packing_master.Process_List_Id=employee_details.Process_Id and Packing_master.Packing_Master_Id=Packing_Master_Id_)*/	
from employee_details 
inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
inner join client_accounts  on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id and employee_details.DeleteStatus='False' 
and employee_details.Client_Accounts_Id  and employee_details.Client_Accounts_Id 
left join Packing_details on employee_details.Client_Accounts_Id=Packing_details.Employee_Id and  Packing_details.Packing_Master_Id=Packing_Master_Id_
order by client_accounts.Client_Accounts_Name asc ;

select Packing_Details_Wastage_Id,Packing_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Warehouse_Id,Warehouse_Name
from  Packing_details_wastage where  Packing_Master_Id=Packing_Master_Id_ and DeleteStatus=False;


    select ifnull(Count(Shift_Start_Master_Id),0) Shift_Start_Master_Id from shift_start_master 
    where Prodction_No=Production_No_ and  shift_start_master.DeleteStatus=False;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Packing_Plan_Master`( In Packing_Plan_Master_Id_ int)
Begin
 SELECT packing_plan_master.Packing_Plan_Master_Id ,Date ,User_Id ,Packing_Plan_No ,Description,packing_plan_details.Item_Id,Item_Name,Quantity,
 Warehouse_Id,Warehouse_Name,Stock_Id,ifnull(Purchase_Order_Master_Id,0)Purchase_Order_Master_Id
 From packing_plan_master
  inner join packing_plan_details on packing_plan_details.Packing_Plan_Master_Id=packing_plan_master.Packing_Plan_Master_Id
 where packing_plan_master.Packing_Plan_Master_Id =Packing_Plan_Master_Id_ and packing_plan_master.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Pallet_Details`( In Barcode_ varchar(100))
Begin
SELECT packing_master.Packing_Master_Id,packing_master.Production_No,packing_master.Item_Name,packing_master.Production_Master_Id,packing_master.Pallet_Id,packing_master.Total_Pallet_Quantity,production_master.Reference_Field,production_master.Proforma_Invoice_Master_Id
 From packing_master
 inner join production_master on production_master.Production_Master_Id = packing_master.Production_Master_Id
 where Barcode =Barcode_  and packing_master.DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Pallet_Details_Received`( In Barcode_ varchar(100))
Begin
SELECT packing_master.Packing_Master_Id,packing_master.Production_No,packing_master.Item_Name,packing_master.Production_Master_Id,packing_master.Pallet_Id,packing_master.Total_Pallet_Quantity,production_master.Reference_Field,production_master.Proforma_Invoice_Master_Id
 From packing_master
 inner join pallets_master on pallets_master.Packing_Master_Id = packing_master.Packing_Master_Id
 inner join production_master on production_master.Production_Master_Id = packing_master.Production_Master_Id
 where packing_master.Barcode =Barcode_ and pallets_master.Status_Id=1  and packing_master.DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Porforma_For_Sales`(in Proforma_Invoice_Master_Id_ int )
BEGIN
declare Company_Id_ int;
set Company_Id_= (select Company_Id from proforma_invoice_master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);

select proforma_invoice_master.Company_Id,proforma_invoice_master.BillType ,(Date_Format(proforma_invoice_master.Entry_Date,'%Y-%m-%d')) As Entry_Date,
PONo,PInvoice_No,Gross_Total GrossTotal,Total_Discount Discount,Net_Total NetTotal,TotalAmount,Total_CGST TotalCGST,TotalSGST,TotalIGST,TotalGST,
Roundoff,GrandTotal,Description Description1,Currency ,Client_Accounts.Client_Accounts_Id Account_Party_Id,ifnull(Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,
Proforma_Invoice_Master_Id,Pallet_Weight,Total_Weight,Net_Weight,Bank_Id,Bank.Client_Accounts_Name Bank_Name,
Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,Client_Accounts.Address2,Currency_Rate,
Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,client_accounts.GSTNo,client_accounts.PinCode,
(Date_Format(proforma_invoice_master.PO_Date,'%Y-%m-%d')) As PO_Date,PONo
from proforma_invoice_master 
inner join client_accounts on client_accounts.Client_Accounts_Id=proforma_invoice_master.Client_Accounts_Id
left JOIN Client_Accounts Bank ON proforma_invoice_master.Bank_Id=Bank.Client_Accounts_Id 
where proforma_invoice_master.DeleteStatus=0 and proforma_invoice_master.Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;

SELECT Proforma_Invoice_Details.Stock_Id,Proforma_Invoice_Details.Item_Id ItemId, Proforma_Invoice_Details.Item_Name ItemName,
Proforma_Invoice_Details.Barcode,Proforma_Invoice_Details.Unit_Id,Proforma_Invoice_Details.Unit_Name,Proforma_Invoice_Details.Group_Id,
Proforma_Invoice_Details.Group_Name,Proforma_Invoice_Details.HSN_Id,Proforma_Invoice_Details.HSN_CODE,Proforma_Invoice_Details.MRP,
Proforma_Invoice_Details.SaleRate,Proforma_Invoice_Details.Quantity,Amount,Proforma_Invoice_Details.Discount,Proforma_Invoice_Details.NetValue,
Proforma_Invoice_Details.CGST,CGST_AMT,Proforma_Invoice_Details.SGST,SGST_AMT,Proforma_Invoice_Details.IGST,IGST_AMT,Proforma_Invoice_Details.GST,GST_AMT,
Cesspers,CessAMT,Proforma_Invoice_Details.TotalAmount, Packing_Size,Colour,stock_details.WareHouse_Id,WareHouse_Name,MFCode,UPC,
Proforma_Invoice_Details.Weight,(Proforma_Invoice_Details.Quantity*Proforma_Invoice_Details.Weight)Total_Weight,Proforma_Invoice_Details.Description
 From Proforma_Invoice_Details 
 inner join Stock on Proforma_Invoice_Details.Stock_Id=stock.Stock_Id 
 inner join stock_details on stock.Stock_Id=stock_details.Stock_Id and stock_details.DeleteStatus=false
 inner join warehouse on stock_details.WareHouse_Id=warehouse.WareHouse_Id 
 where Proforma_Invoice_Details.DeleteStatus=false 
 and Proforma_Invoice_Details.Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and stock_details.company_Id= Company_Id_; 
 
SELECT Bill_Type_Id,Bill_Type_Name  From bill_type where Bill_Status=1 and DeleteStatus=false;
Select Company_Id,Company_Name from company where DeleteStatus=false;
select Container_Id,Container_Name from Container where DeleteStatus=false;
select Proforma_Pack_List_Id,Proforma_Invoice_Master_Id  ,ItemId ,ItemName ,Stock_Id ,Quantity,Weight ,Total_Weight,Description from
Proforma_Pack_List where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Porforma_From_Shipment`( In Proforma_Invoice_Master_Id_ int )
BEGIN
SELECT  Proforma_Invoice_Master_Id,(Date_Format(proforma_invoice_master.Entry_Date,'%d-%m-%Y')) As search_date,Shipment_Master_Id,
(Date_Format(proforma_invoice_master.Entry_Date,'%Y-%m-%d')) As Entry_Date,proforma_invoice_master.Client_Accounts_Id,
proforma_invoice_master.Company_Id,User_Id,PONo,PInvoice_No,BillType,Gross_Total,Total_Discount,Net_Total,TotalAmount,Total_CGST,TotalSGST,TotalIGST,
TotalGST,Roundoff,GrandTotal,Payment_Status,Description,Proforma_Status,Currency,Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,
Client_Accounts.Address2,Sales_Master_Id,proforma_invoice_master.Employee_Id,Employee.User_Details_Name as Employee_Name,Client_Accounts.Address3,
Client_Accounts.Address4,Client_Accounts.Mobile,Client_Accounts.GSTNo,Client_Accounts.PinCode,Order_Status.Order_Status_Id,Order_Status_Name,
(Date_Format(proforma_invoice_master.Valid_Date,'%Y-%m-%d')) As Valid_Date,Pallet_Weight,Total_Weight,Net_Weight,Product_Name,Customer_Code,
Delivery_Term,Delivery_Period,Container,Payment_term,Bank_Id,Bank.Client_Accounts_Name Bank_Name,Bank.Address1 Holder,Bank.Address2 Accno,Bank.Address3 Swift,
Bank.Address4 Branch,Bank.PinCode Ifsc,proforma_invoice_master.Reference_Number,Reference_Field,Currency_Rate,proforma_invoice_master.Purchase_Order_Master_Id,
CASE WHEN proforma_invoice_master.Production_Status =0 THEN 'Move To Production' ELSE  'Cancel Production' END Proforma_Caption,
CASE WHEN proforma_invoice_master.Sales_Master_Id >0 THEN 'View Sales Invoice' ELSE  'Make Sales Invoice' END Sales_Caption,
proforma_invoice_master.Proforma_Invoice_Master_Id,proforma_invoice_master.Sales_Master_Id,company.Company_Name ,company.Address1 Company_Address1,
company.Address2 Company_Address2,company.Address3 Company_Address3,company.Address4 Company_Address4,company.Mobile_Number,
company.Phone_Number,company.EMail,(Date_Format(proforma_invoice_master.PO_Date,'%Y-%m-%d'))As PO_Date
FROM proforma_invoice_master left JOIN user_details Employee 
ON proforma_invoice_master.Employee_Id=Employee.User_Details_Id INNER JOIN Client_Accounts 
ON proforma_invoice_master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id left JOIN Client_Accounts Bank 
ON proforma_invoice_master.Bank_Id=Bank.Client_Accounts_Id inner join Order_Status 
on Order_Status.Order_Status_Id=proforma_invoice_master.Proforma_Status inner join company 
ON proforma_invoice_master.Company_Id=company.Company_Id
WHERE proforma_invoice_master.DeleteStatus=false and proforma_invoice_master.Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;    
SELECT  Proforma_Invoice_Details_Id,Proforma_Invoice_Details.Proforma_Invoice_Master_Id, Proforma_Invoice_Details.Production_Master_Id,
Proforma_Invoice_Details.Stock_Id,Proforma_Invoice_Details.Item_Id, Proforma_Invoice_Details.Item_Name,Proforma_Invoice_Details.Barcode,
Proforma_Invoice_Details.Unit_Id,Proforma_Invoice_Details.Unit_Name,Proforma_Invoice_Details.Group_Id,Proforma_Invoice_Details.Group_Name,
Proforma_Invoice_Details.HSN_Id,Proforma_Invoice_Details.HSN_CODE,Proforma_Invoice_Details.MRP,Proforma_Invoice_Details.SaleRate,
Proforma_Invoice_Details.Quantity,Amount,Proforma_Invoice_Details.Discount,Proforma_Invoice_Details.Netvalue,Proforma_Invoice_Details.CGST,CGST_AMT,SGST,
SGST_AMT,IGST,IGST_AMT,GST,GST_AMT,Cesspers,CessAMT,Proforma_Invoice_Details.TotalAmount,Proforma_Invoice_Details.Produced_Quantity,
Proforma_Invoice_Details.Weight,(Proforma_Invoice_Details.Quantity*Proforma_Invoice_Details.Weight) Total_Weight,Proforma_Invoice_Details.Description,
CASE WHEN Proforma_Invoice_Details.Production_Master_Id > 0 THEN "View Production" ELSE "Start Production" END Production_Caption,
Proforma_Invoice_Details.Production_Master_Id From Proforma_Invoice_Details inner join Proforma_Invoice_Master 
on Proforma_Invoice_Master.Proforma_Invoice_Master_Id=Proforma_Invoice_Details.Proforma_Invoice_Master_Id
where Proforma_Invoice_Details.Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_ and Proforma_Invoice_Details.DeleteStatus=false;
SELECT Bill_Type_Id,Bill_Type_Name  From bill_type where Bill_Status=1 and DeleteStatus=false;
Select Company_Id,Company_Name from company where DeleteStatus=false;
select Proforma_Pack_List_Id,Proforma_Invoice_Master_Id  ,ItemId ,ItemName ,Stock_Id ,Quantity,Weight ,Total_Weight,Description from
Proforma_Pack_List where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Porforma_Typeahead`(in PInvoice_No_ varchar(500))
BEGIN
set PInvoice_No_ = Concat( '%',PInvoice_No_ ,'%');
select Proforma_Invoice_Master_Id,ifnull(proforma_invoice_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,PInvoice_No,PONo,Reference_Field,
proforma_invoice_master.Company_Id,Company_Name
from proforma_invoice_master inner join Company on Company.Company_Id=proforma_invoice_master.Company_Id
where PInvoice_No like PInvoice_No_ and Proforma_Status not in(3) and proforma_invoice_master.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Process_Employee`(in Process_Id_ int,Production_No_ int)
BEGIN
select client_accounts.Client_Accounts_Id Employee_Id,Client_Accounts_Name,Normal_Rate,Ot_Rate,Loading_Rate
from client_accounts 
inner join  employee_details on employee_details.Client_Accounts_Id=client_accounts.Client_Accounts_Id
where Process_Id=Process_Id_ and employee_details.DeleteStatus=false
 order by Client_Accounts_Name asc ;
 
 
    select sum(Acceptable) Produced
    from shift_end_master where  Production_No=Production_No_  and  DeleteStatus=False and Process_List_Id=Process_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Process_Employee_ForSalaryCalculation`(in FromDate_ datetime,
ToDate_ datetime)
BEGIN
select client_accounts.Client_Accounts_Name Employee_Name,Client_Accounts_Id Employee_Id,
ifnull(sum(Normal_Total),0) Normal_Total,ifnull(sum(Ot_Total),0)Ot_Total,ifnull(sum(Loading_Total),0)Loading_Total,
ifnull(sum(Piece_Total),0) Piece_Total,ifnull(sum(Other_Total),0) Other_Total,
(ifnull(sum(Normal_Total),0)+ifnull(sum(Ot_Total),0)+ifnull(sum(Loading_Total),0)+ifnull(sum(Piece_Total),0)+ifnull(sum(Other_Total),0))TotalAmount
#sum(Total) Total
 from attendance_details 
 inner join client_accounts on attendance_details.Employee_Id=client_accounts.Client_Accounts_Id
 inner join attendance_master on attendance_details.Attendance_Master_Id=attendance_master.Attendance_Master_Id
where attendance_master.Entry_Date between FromDate_ and ToDate_ and attendance_details.Is_Employee=1  and attendance_details.Punch_Status=1
group by client_accounts.Client_Accounts_Name,Employee_Id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Process_List`( In Item_Id_ int)
Begin 
 SELECT 
Process_List_Id ,Item_Id ,Process_Id ,Process_Time ,Stock_Add_Status ,Process_Details_Name
 From process_list 
  inner join process_details on process_details.Process_Details_Id = process_list.Process_Id
 where Item_Id =Item_Id_ and process_list.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_Details_From_PalletTypeahead`(In Production_No_ int )
Begin   
	select Production_Master_Id,Stock_Id,Item_Id,Item_Name,WareHouse_Id,WareHouse_Name,Production_No,Quantity ,
    Reference_Field,PInvoice_No,production_master.Company_Id,Company_Name
	from production_master 
	INNER JOIN Company ON production_master.Company_Id=Company.Company_Id 
    where Production_No=Production_No_  and  production_master.DeleteStatus=False;
    
    select Pallet_Id , ItemName,count(Pallets_Stock_Id)Quantity from Pallets_Stock inner join stock 
    on Pallets_Stock.Pallet_Id=stock.Stock_Id
    where Pallets_Stock.Production_No=Production_No_  and  Pallets_Stock.DeleteStatus=False
    group by Pallet_Id , stock.ItemName;    
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_Details_From_Typeahead`(In Production_No_ int )
Begin 										
	select Production_Master_Id,Stock_Id,Item_Id,Item_Name,WareHouse_Id,WareHouse_Name,Production_No,Quantity,Reference_Field,PInvoice_No,
    production_master.Company_Id,Company_Name,Weight,Batch_Weight,Weight_Item,ifnull(Purchase_Order_Master_Id,0)Purchase_Order_Master_Id
	from production_master inner join Company 
    on Company.Company_Id=production_master.Company_Id
    where Production_No=Production_No_ and production_master.DeleteStatus=False;
	select Production_Details_Wastage_Id,production_details_wastage.Production_Master_Id,Wastage_Id,production_details_wastage.Item_Id,
    production_details_wastage.Item_Stock_Id,production_details_wastage.Item_Name,production_details_wastage.Stock_Id,0 Quantitypers,
    production_details_wastage.Warehouse_Id,production_details_wastage.Warehouse_Name
	from production_details_wastage 
	inner join Production_Master on production_details_wastage.Production_Master_Id=production_master.Production_Master_Id
	where Production_No=Production_No_;    
    select ifnull(Count(Shift_Start_Master_Id),0) Shift_Start_Master_Id from shift_start_master 
    where Prodction_No=Production_No_ and  shift_start_master.DeleteStatus=False;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_Details_Process`(in Item_Id_ int)
BEGIN
select Process_List_Id,Item_Id,process_list.Process_Id,Process_Details_Name Process_Name
from process_list
inner join process_details on process_list.Process_Id=process_details.Process_Details_Id
where Item_Id=Item_Id_ and process_list.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_Details_RawMaterial`(in Item_Id_ int,Weight_per_Item_ int)
BEGIN
select  raw_material.Item_Id , raw_material.Item_Stock_Id , Stock_Id , raw_material.Warehouse_Id,raw_material.Warehouse_Name,
Quantity No_Quantity ,item.Item_Name,Raw_Material_Id,(Weight_per_Item_* Quantity) as Weight_Quantity
from raw_material
inner join item on item.Item_Id=raw_material.Item_Stock_Id
where raw_material.Item_Id=Item_Id_ and raw_material.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_Details_Wastage`(in Item_Id_ int,Quantity_ int)
BEGIN
select  wastage.Item_Id , Item_Stock_Id , wastage.Stock_Id , wastage.Warehouse_Id,wastage.Warehouse_Name,
Quantitypers  ,item.Item_Name,Wastage_Id,(Quantity_ * Quantitypers) as Total_Quantity
from wastage
inner join item on item.Item_Id=wastage.Item_Stock_Id
where wastage.Item_Id=Item_Id_ and wastage.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_From_Porforma`( In Production_Master_Id_ int)
BEGIN
declare Production_Quantity_ int;
set Production_Quantity_=(select Quantity from production_master where Production_Master_Id=Production_Master_Id_ and DeleteStatus=false);
SELECT Production_Master_Id ,(Date_Format(production_master.Date,'%Y-%m-%d')) As Date,production_master.Proforma_Invoice_Master_Id,
production_master.Proforma_Invoice_Details_Id,Production_No,(Date_Format(production_master.Date,'%d-%m-%Y')) As Search_Date, production_master.User_Id,
Stock_Id,Production_Status,Reference_Field,PInvoice_No,PONo,production_master.Weight,production_master.Batch_Weight,production_master.Weight_Item,
Item_Id,production_master.Item_Name,WareHouse_Id,WareHouse_Name,Quantity,(Date_Format(production_master.Expected_Production_Date,'%Y-%m-%d')) As Expected_Production_Date ,
CASE WHEN production_master.Production_Status =7 THEN "Stop Production" ELSE "ReStart Production" END Production_Caption, 
production_master.Production_Master_Id,Production_Status,production_master.Company_Id,production_master.Purchase_Order_Master_Id,
Company.Company_Name,Weight_Description,Average_Mat_Weight,
ifnull(ROUND(((production_master.Weight*Quantity)/Batch_Weight),2),0) Total_Batch_Weight 
From production_master 
inner join Company on Company.Company_Id=production_master.Company_Id
where production_master.DeleteStatus=false and production_master.Production_Master_Id=Production_Master_Id_;
select	Production_Details_Process_Id,Process_List_Id,Process_Id,Item_Id,Process_Name
from production_details_process
where Production_Master_Id=Production_Master_Id_ and DeleteStatus=false;
select Production_Details_RawMaterial_Id,Raw_Material_Id,production_details_rawmaterial.Item_Id,Item_Stock_Id,Stock_Id,No_Quantity,Weight_Quantity,
item.Item_Name,Warehouse_Id,Warehouse_Name, production_details_rawmaterial.Weight_Quantity
from production_details_rawmaterial 
inner join item on item.Item_Id=production_details_rawmaterial.Item_Stock_Id
where Production_Master_Id=Production_Master_Id_ and production_details_rawmaterial.DeleteStatus=false;
select Production_Details_Wastage_Id,Wastage_Id,production_details_wastage.Item_Id,Item_Stock_Id,Stock_Id,Quantitypers,item.Item_Name, 
Warehouse_Id,Warehouse_Name,(Production_Quantity_ * Quantitypers) as Total_Quantity
from production_details_wastage 
inner join item on item.Item_Id=production_details_wastage.Item_Stock_Id
where Production_Master_Id=Production_Master_Id_ and production_details_wastage.DeleteStatus=false;
select Company_Id,Company_Name from Company where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_From_Purchase_Customer`(In Purchase_Order_Master_Id_ int)
BEGIN
select  Purchase_Order_Master_Id ,(Date_Format(Purchase_Order_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
	Purchase_Order_Master.Client_Accounts_Id,Company_Id,User_Id,PONo,(Date_Format(Delivery_Date,'%Y-%m-%d')) As Delivery_Date ,
	Currency,Shipment_Method_Id,Price_Method,Payment_Term,Shipping_Port,Delivery_Port,Shipmet_Plan_Id,No_of_Shipment,Description,Order_Status,TotalAmount, 
	Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,Address2,Address3,Address4,PinCode,GSTNo,Mobile,
    Order_Status_Name,Purchase_Order_Customer_Id
	From Purchase_Order_Master 
    INNER JOIN Client_Accounts ON Purchase_Order_Master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id
    inner join order_status on Purchase_Order_Master.Order_Status=order_status.Order_Status_Id    
	where Purchase_Order_Master.DeleteStatus=false AND Purchase_Order_Master.Purchase_Order_Master_Id=Purchase_Order_Master_Id_ ;
    
    SELECT
	purchase_order_details.Purchase_Order_Details_Id,purchase_order_details.Purchase_Order_Master_Id,purchase_order_details.Stock_Id,purchase_order_details.Item_Id,
	purchase_order_details.Item_Name,purchase_order_details.Barcode,purchase_order_details.Packing_Size,purchase_order_details.Colour,
	purchase_order_details.Description,purchase_order_details.Unit_Id,purchase_order_details.Unit_Name,purchase_order_details.Group_Id,purchase_order_details.Group_Name,
	purchase_order_details.HSN_Id,purchase_order_details.HSN_Code,purchase_order_details.MFCode,purchase_order_details.UPC,purchase_order_details.Unit_Price,
	purchase_order_details.Quantity,purchase_order_details.Amount,Weight
	From purchase_order_details 
	where purchase_order_details.Purchase_Order_Master_Id =Purchase_Order_Master_Id_ and purchase_order_details.DeleteStatus=false ;

SELECT  Shipment_Master.Shipment_Master_Id,Purchase_Order_Master_Id,Shipment_No,Shipment_Status_Id,Delivery_Date,
	shipment_details.Item_Id,shipment_details.Item_Name,shipment_details.Stock_Id,shipment_details.Quantity,shipment_details.Weight,
	CASE WHEN Shipment_Master.Proforma_Invoice_Master_Id > 0 THEN "View Porforma" ELSE "Make Porforma"END Porforma_Caption, Shipment_Master.Proforma_Invoice_Master_Id
	from Shipment_Master 
    inner join shipment_details on shipment_details.Shipment_Master_Id=shipment_master.Shipment_Master_Id
	where shipment_master.Purchase_Order_Master_Id=Purchase_Order_Master_Id_ order by Shipment_Master_Id ;

SELECT Purchase_Order_Status_Id,Purchase_Order_Status_Name From Purchase_Order_Status where DeleteStatus=false;

Select Shipment_Method_Id,Shipment_Method_Name from shipment_method where DeleteStatus=false;

Select * from company where DeleteStatus=false;

Select Shipment_Plan_Id,Shipment_Plan_Name from shipment_plan where DeleteStatus=false;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_Item_Typeahead`(in Item_Name_ varchar(50),Production_Master_Id_ int)
BEGIN
set Item_Name_ = Concat( '%',Item_Name_ ,'%');
select Item_Id,Item_Name,Production_Master_Id,Stock_Id,WareHouse_Id,WareHouse_Name,Quantity
from production_master
where Item_Name like Item_Name_ and Production_Master_Id=Production_Master_Id_ and DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_production_Master`(in Production_Master_Id_ int)
BEGIN
declare Production_Quantity_ int;
set Production_Quantity_=(select Quantity from production_master where Production_Master_Id=Production_Master_Id_ and DeleteStatus=false);

select Production_Details_Process_Id,Process_List_Id,Process_Id,Item_Id,Process_Name
from production_details_process where Production_Master_Id=Production_Master_Id_ and DeleteStatus=false;

select Production_Details_RawMaterial_Id,Raw_Material_Id,production_details_rawmaterial.Item_Id,Item_Stock_Id,Stock_Id,No_Quantity,Weight_Quantity,
production_details_rawmaterial.Weight_Quantity,
item.Item_Name,production_details_rawmaterial.Warehouse_Id,production_details_rawmaterial.Warehouse_Name
from production_details_rawmaterial 
inner join item on item.Item_Id=production_details_rawmaterial.Item_Stock_Id
where Production_Master_Id=Production_Master_Id_ and production_details_rawmaterial.DeleteStatus=false;

select Production_Details_Wastage_Id,Wastage_Id,production_details_wastage.Item_Id,Item_Stock_Id,Stock_Id,Quantitypers,
item.Item_Name,(Production_Quantity_ * Quantitypers) as Total_Quantity, production_details_wastage.Warehouse_Id,production_details_wastage.Warehouse_Name

from production_details_wastage 
inner join item on item.Item_Id=production_details_wastage.Item_Stock_Id
where Production_Master_Id=Production_Master_Id_ and production_details_wastage.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_Process`(in Production_Master_Id_ int,Type_ int)
BEGIN
select Production_Master_Id,Process_Id,
Process_Name 
from production_details_process
#inner join process_list on process_list.Process_List_Id=production_details_process.Process_List_Id
inner join process_details on process_details.Process_Details_Id=production_details_process.Process_Id
where Production_Master_Id=Production_Master_Id_ and process_details.Process_Type=Type_ and production_details_process.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_RawMaterial_Typeahead`(in ItemName_ varchar(100))
BEGIN

	set ItemName_ = Concat( "'%",ItemName_ ,"%'");
select  raw_material.Item_Id , raw_material.Item_Stock_Id , Stock_Id , raw_material.Warehouse_Id,raw_material.Warehouse_Name,
Quantity No_Quantity ,item.Item_Name,Raw_Material_Id
from raw_material
inner join item on item.Item_Id=raw_material.Item_Stock_Id
where raw_material.Item_Name  LIKE ItemName_  and raw_material.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Production_To_Shift_Start`(in Shift_Start_Master_Id_ int )
BEGIN

		SELECT  Shift_Start_Master_Id ,(Date_Format(shift_start_master.Date,'%Y-%m-%d')) As Date ,Production_Master_Id,Prodction_No,Shift_Start_No,
		(Date_Format(shift_start_master.Date,'%d-%m-%Y')) As Search_Date, User_Id ,Stock_Id,Shift_End_Master_Id,PONo,
		Item_Id ,Item_Name,WareHouse_Id, WareHouse_Name ,Quantity,shift_start_master.Company_Id,COmpany_Name
		From shift_start_master 
        inner join  Company on shift_start_master.Company_Id=Company.Company_Id
		where shift_start_master.DeleteStatus=false ;

		select Shift_Start_Details_Process_Id,Shift_Start_Master_Id,Process_List_Id,Item_Id,Process_Id,Process_Name
		from shift_start_details_process where Shift_Start_Master_Id=Shift_Start_Master_Id and DeleteStatus=false;

		select Shift_Start_Details_RawMaterial_Id,Raw_Material_Id,shift_start_details_rawmaterial.Item_Id,Item_Stock_Id,Stock_Id,
		No_Quantity,Weight_Quantity,Item_Name
		from shift_start_details_rawmaterial 
		inner join item on item.Item_Id=shift_start_details_rawmaterial.Item_Stock_Id
		where Shift_Start_Master_Id=Shift_Start_Master_Id_ and shift_start_details_rawmaterial.DeleteStatus=false;

		select Shift_Start_Details_Wastage_Id,Wastage_Id,shift_start_details_wastage.Item_Id,Item_Stock_Id,Stock_Id,Quantitypers,Item_Name
		from shift_start_details_wastage 
		inner join item on item.Item_Id=shift_start_details_wastage.Item_Stock_Id
		where Shift_Start_Master_Id=Shift_Start_Master_Id_ and shift_start_details_wastage.DeleteStatus=false;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Proforma_For_Production`(in Proforma_Invoice_Details_Id_ int )
BEGIN
SELECT Proforma_Invoice_Details_Id,proforma_invoice_details.Proforma_Invoice_Master_Id,Stock_Id,proforma_invoice_details.Item_Id,
proforma_invoice_master.Purchase_Order_Master_Id,proforma_invoice_details.Item_Name,Barcode,proforma_invoice_details.Unit_Id,
proforma_invoice_details.Unit_Name,proforma_invoice_details.Group_Id,
proforma_invoice_details.Group_Name,proforma_invoice_details.HSN_Id,proforma_invoice_details.HSN_CODE,
proforma_invoice_details.MRP,proforma_invoice_details.SaleRate,proforma_invoice_details.Quantity,
proforma_invoice_details.Amount,proforma_invoice_details.Discount,proforma_invoice_details.Netvalue,
proforma_invoice_details.CGST,proforma_invoice_details.CGST_AMT,proforma_invoice_details.SGST,
proforma_invoice_details.SGST_AMT,proforma_invoice_details.IGST,proforma_invoice_details.IGST_AMT,
proforma_invoice_details.GST ,PONo,Produced_Quantity, 
Reference_Field,proforma_invoice_master.PInvoice_No,proforma_invoice_master.Company_Id,
Company.Company_Name,proforma_invoice_details.Weight,ifnull(Item.Batch_Weight,0) Batch_Weight,
ifnull(Item.Weight_Item,0) Weight_Item, 
ifnull(ROUND(((proforma_invoice_details.Weight*Quantity)/Batch_Weight),3),0) Total_Batch_Weight 
From proforma_invoice_details 
inner join proforma_invoice_master on proforma_invoice_master.Proforma_Invoice_Master_Id=proforma_invoice_details.Proforma_Invoice_Master_Id
inner join Company on Company.Company_Id=proforma_invoice_master.Company_Id
inner join item on item.Item_Id=proforma_invoice_details.Item_Id
where Proforma_Invoice_Details_Id =Proforma_Invoice_Details_Id_ and proforma_invoice_details.DeleteStatus=false ;
select Company_Id,Company_Name from Company where DeleteStatus=0;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Proforma_Invoice_Details`( In Proforma_Invoice_Master_Id_ int)
Begin 
 SELECT
 Proforma_Invoice_Details_Id,Proforma_Invoice_Details.Proforma_Invoice_Master_Id, Proforma_Invoice_Details.Production_Master_Id,Proforma_Invoice_Details.Stock_Id,
 Proforma_Invoice_Details.Item_Id, Proforma_Invoice_Details.Item_Name,Proforma_Invoice_Details.Barcode,Proforma_Invoice_Details.Unit_Id,
 Proforma_Invoice_Details.Unit_Name,Proforma_Invoice_Details.Group_Id,Proforma_Invoice_Details.Group_Name,Proforma_Invoice_Details.HSN_Id,
 Proforma_Invoice_Details.HSN_CODE,Proforma_Invoice_Details.MRP,Proforma_Invoice_Details.SaleRate,Proforma_Invoice_Details.Quantity,Amount,
 Proforma_Invoice_Details.Discount,Proforma_Invoice_Details.Netvalue,Proforma_Invoice_Details.CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,
 GST_AMT,Cesspers,CessAMT,Proforma_Invoice_Details.TotalAmount,Proforma_Invoice_Details.Produced_Quantity, Proforma_Invoice_Details.Weight,
 (Proforma_Invoice_Details.Quantity*Proforma_Invoice_Details.Weight) Total_Weight,Proforma_Invoice_Details.Description,
 CASE
    WHEN Proforma_Invoice_Details.Production_Master_Id > 0 THEN "View Production"
    ELSE "Start Production"
END Production_Caption, Proforma_Invoice_Details.Production_Master_Id
 From Proforma_Invoice_Details 
inner join Proforma_Invoice_Master on Proforma_Invoice_Master.Proforma_Invoice_Master_Id=Proforma_Invoice_Details.Proforma_Invoice_Master_Id
where Proforma_Invoice_Details.Proforma_Invoice_Master_Id =Proforma_Invoice_Master_Id_ and Proforma_Invoice_Details.DeleteStatus=false ;
 
 
select Proforma_Pack_List_Id,Proforma_Invoice_Master_Id  ,ItemId ,ItemName ,Stock_Id ,Quantity,Weight ,Total_Weight,Description,Package_No,No_Of_Pckgs,Total,Net_Weight,Gross_Weight,No_Of_Pcs,Product_Code from
Proforma_Pack_List where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and DeleteStatus=false;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Proforma_Item_Typeahead`(in Item_Name_ varchar(50),Proforma_Invoice_Master_Id_ int)
BEGIN
set Item_Name_ = Concat( '%',Item_Name_ ,'%');
select Item_Id,Item_Name,Proforma_Invoice_Master_Id,Stock_Id
from proforma_invoice_details
where Item_Name like Item_Name_ and Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Details`( In Purchase_Master_Id_ Int)
Begin 
 SELECT 

Purchase_Details_Id,Purchase_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,
Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,WareHouse_Id,WareHouse_Name,MFCode,UPC,SaleRate,MRP,
Unit_Price,Quantity,Amount,Product_Code,
IFNULL(Discount, 0) as Discount, 
NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_Amount,
TotalAmount,Include_Tax,Is_Expiry,(Date_Format(Purchase_Details.Expiry_Date,'%Y-%m-%d')) As Expiry_Date
 
From Purchase_Details
 #inner join Client_Accounts on Purchase_Details.To_Employee_Id=Client_Accounts.Client_Accounts_Id,Client_Accounts.Client_Accounts_Name To_Stock_Name
 where Purchase_Master_Id =Purchase_Master_Id_  and Purchase_Details.Category_Id=4 and  Purchase_Details.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Details_Click`(In Purchase_Master_Id_ INT)
BEGIN
SELECT Purchase_Master_Id as Purchase_Master_Order_Id ,Purchase_Type_Id , Account_Party_Id ,Client_Accounts_Name,
(Date_Format(purchase_master_order.Entry_Date,'%Y-%m-%d')) Entry_Date , PurchaseDate , InvoiceNo ,
GrossTotal , TotalDiscount ,NetTotal , TotalCGST ,TotalSGST ,TotalIGST , TotalGST , TotalAmount ,
Discount ,Roundoff ,Grand_Total ,Other_Charges , BillType , User_Id , Description,Company_Id ,
Group_Id
From purchase_master_order
INNER JOIN Client_Accounts ON purchase_master_order.Account_Party_Id=Client_Accounts.Client_Accounts_Id
 where Purchase_Master_Id=Purchase_Master_Id_ order by Purchase_Master_Id  asc;

select Purchase_Master_Id as Purchase_Master_Order_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,
Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,WareHouse_Id,WareHouse_Name,MFCode,
UPC,SaleRate,MRP,Unit_Price,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,
IGST,IGST_AMT,GST,GST_Amount,TotalAmount,Include_Tax,Product_Code,DeleteStatus,Category_Id,
Category_Name From purchase_master_order_details where Purchase_Master_Id=Purchase_Master_Id_ 
order by Purchase_Details_Id  asc;


END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Master`( In Purchase_Master_Id_ Int)
Begin 
SELECT Purchase_Master_Id ,   Purchase_Type_Id, Account_Party_Id ,Entry_Date ,  PurchaseDate ,  InvoiceNo ,GrossTotal ,TotalDiscount ,  NetTotal,
TotalCGST ,   TotalSGST ,  TotalIGST,TotalGST,  TotalAmount ,   Discount,Roundoff,Grand_Total ,   Other_Charges ,BillType ,  User_Id,  Description
From Purchase_Master where Purchase_Master_Id =Purchase_Master_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Order_Customer`( In Purchase_Order_Master_Id_ Int)
Begin 
 SELECT
Purchase_Order_Customer_Details_Id,Purchase_Order_Customer_Id,Item_Name,Packing_Size,Colour,Description,Unit_Price,Quantity,Amount
from purchase_order_Customer_details where Purchase_Order_Customer_Id=Purchase_Order_Master_Id_
and DeleteStatus=false;
select BL,BL_FileName,PackingList,PackingList_FileName,Invoice,Invoice_FileName from sales_master where Purchase_Order_Master_Id = Purchase_Order_Master_Id_ and DeleteStatus =0;    
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Order_Details`( In Purchase_Master_Id_ Int)
Begin 
 SELECT 

Purchase_Details_Id,Purchase_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,
Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,WareHouse_Id,WareHouse_Name,MFCode,UPC,SaleRate,MRP,
Unit_Price,Quantity,Amount,Product_Code,
IFNULL(Discount, 0) as Discount, 
NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_Amount,
TotalAmount,Include_Tax,Is_Expiry,(Date_Format(purchase_master_order_details.Expiry_Date,'%Y-%m-%d')) As Expiry_Date
 
From purchase_master_order_details
 #inner join Client_Accounts on Purchase_Details.To_Employee_Id=Client_Accounts.Client_Accounts_Id,Client_Accounts.Client_Accounts_Name To_Stock_Name
 where Purchase_Master_Id =Purchase_Master_Id_  and purchase_master_order_details.Category_Id=4 and  purchase_master_order_details.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Order_From_Proforma`(in Shipment_Master_Id_ int )
BEGIN
Select Purchase_Order_Master_Id from Shipment_Master where Shipment_Master_Id=Shipment_Master_Id_ ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Order_From_Proforma_Invoice`( In Purchase_Order_Master_Id_ Int)
Begin 
SELECT
	Purchase_Order_Master_Id ,Client_Accounts_Id, Company_Id ,User_Id,Entry_Date , PONo, Delivery_Date , Currency ,Shipment_Method_Id ,
	Price_Method ,Payment_Term,Shipping_Port ,Delivery_Port ,Shipmet_Plan_Id,No_of_Shipment, Description , Order_Status,TotalAmount
	From Purchase_Order_Master 
    where Purchase_Order_Master_Id =Purchase_Order_Master_Id_ and DeleteStatus=false ;
 SELECT
	purchase_order_details.Purchase_Order_Details_Id,purchase_order_details.Purchase_Order_Master_Id,purchase_order_details.Stock_Id,purchase_order_details.Item_Id,
	purchase_order_details.Item_Name,purchase_order_details.Barcode,purchase_order_details.Packing_Size,purchase_order_details.Colour,
	purchase_order_details.Description,purchase_order_details.Unit_Id,purchase_order_details.Unit_Name,purchase_order_details.Group_Id,purchase_order_details.Group_Name,
	purchase_order_details.HSN_Id,purchase_order_details.HSN_Code,purchase_order_details.MFCode,purchase_order_details.UPC,purchase_order_details.Unit_Price,
	purchase_order_details.Quantity,purchase_order_details.Amount,Weight
	From purchase_order_details 
	where purchase_order_details.Purchase_Order_Master_Id =Purchase_Order_Master_Id_ and purchase_order_details.DeleteStatus=false ;

SELECT  Shipment_Master.Shipment_Master_Id,Purchase_Order_Master_Id,Shipment_No,Shipment_Status_Id,Delivery_Date,
	shipment_details.Item_Id,shipment_details.Item_Name,shipment_details.Stock_Id,shipment_details.Quantity,shipment_details.Weight,
	CASE WHEN Shipment_Master.Proforma_Invoice_Master_Id > 0 THEN "View Porforma" ELSE "Make Porforma"END Porforma_Caption, Shipment_Master.Proforma_Invoice_Master_Id
	from Shipment_Master 
    inner join shipment_details on shipment_details.Shipment_Master_Id=shipment_master.Shipment_Master_Id
	where shipment_master.Purchase_Order_Master_Id=Purchase_Order_Master_Id_ order by Shipment_Master_Id ;
    
    SELECT  Purchase_Order_Master_Id ,(Date_Format(Purchase_Order_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
	Purchase_Order_Master.Client_Accounts_Id,Company_Id,User_Id,PONo,(Date_Format(Delivery_Date,'%Y-%m-%d')) As Delivery_Date ,
	Currency,Shipment_Method_Id,Price_Method,Payment_Term,Shipping_Port,Delivery_Port,Shipmet_Plan_Id,No_of_Shipment,Description,Order_Status,TotalAmount, 
	Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,Address2,Address3,Address4,PinCode,GSTNo,Mobile,
    Order_Status_Name
	From Purchase_Order_Master 
    INNER JOIN Client_Accounts ON Purchase_Order_Master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id
    inner join order_status on Purchase_Order_Master.Order_Status=order_status.Order_Status_Id    
	where Purchase_Order_Master_Id=Purchase_Order_Master_Id_ and Purchase_Order_Master.DeleteStatus=false;
        
SELECT Purchase_Order_Status_Id,Purchase_Order_Status_Name From Purchase_Order_Status where DeleteStatus=false;

Select Shipment_Method_Id,Shipment_Method_Name from shipment_method where DeleteStatus=false;

Select * from company where DeleteStatus=false;

Select Shipment_Plan_Id,Shipment_Plan_Name from shipment_plan where DeleteStatus=false;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Order_Master`( In Purchase_Order_Master_Id_ Int)
Begin 
SELECT
	Purchase_Order_Master_Id ,Client_Accounts_Id, Company_Id ,User_Id,Entry_Date , PONo, Delivery_Date , Currency ,Shipment_Method_Id ,
	Price_Method ,Payment_Term,Shipping_Port ,Delivery_Port ,Shipmet_Plan_Id,No_of_Shipment, Description , Order_Status,TotalAmount
	From Purchase_Order_Master where Purchase_Order_Master_Id =Purchase_Order_Master_Id_ and DeleteStatus=false ;
 SELECT
	purchase_order_details.Purchase_Order_Details_Id,purchase_order_details.Purchase_Order_Master_Id,purchase_order_details.Stock_Id,purchase_order_details.Item_Id,
	purchase_order_details.Item_Name,purchase_order_details.Barcode,purchase_order_details.Packing_Size,purchase_order_details.Colour,
	purchase_order_details.Description,purchase_order_details.Unit_Id,purchase_order_details.Unit_Name,purchase_order_details.Group_Id,purchase_order_details.Group_Name,
	purchase_order_details.HSN_Id,purchase_order_details.HSN_Code,purchase_order_details.MFCode,purchase_order_details.UPC,purchase_order_details.Unit_Price,
	purchase_order_details.Quantity,purchase_order_details.Amount,Weight
	From purchase_order_details 
	where purchase_order_details.Purchase_Order_Master_Id =Purchase_Order_Master_Id_ and purchase_order_details.DeleteStatus=false ;

SELECT  Shipment_Master.Shipment_Master_Id,Purchase_Order_Master_Id,Shipment_No,Shipment_Status_Id,Delivery_Date,
	shipment_details.Item_Id,shipment_details.Item_Name,shipment_details.Stock_Id,shipment_details.Quantity,
    shipment_details.Weight,shipment_details.Description,Barcode,Packing_Size,Colour,Unit_Id,Unit_Name,
            Group_Id,Group_Name,HSN_Id,HSN_Code,MFCode,UPC,Unit_Price,Amount,
	CASE WHEN Shipment_Master.Proforma_Invoice_Master_Id > 0 THEN "View Porforma" ELSE "Make Porforma"END Porforma_Caption, Shipment_Master.Proforma_Invoice_Master_Id
	from Shipment_Master 
    inner join shipment_details on shipment_details.Shipment_Master_Id=shipment_master.Shipment_Master_Id
	where shipment_master.Purchase_Order_Master_Id=Purchase_Order_Master_Id_ order by Shipment_Master_Id ;
    
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Order_Track_Customer`( In Purchase_Order_Master_Id_ Int)
Begin 
 SELECT
purchase_order_track_details.Purchase_Order_Track_Details_Id,purchase_order_track_details.Purchase_Order_Track_Master_Id,
	purchase_order_track_details.Item_Name,	purchase_order_track_details.Sale_Rate Unit_Price ,
	purchase_order_track_details.Quantity,purchase_order_track_details.Total Amount
	From purchase_order_track_details 
	where purchase_order_track_details.Purchase_Order_Track_Master_Id =Purchase_Order_Master_Id_ and purchase_order_track_details.DeleteStatus=false ;   
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Order_Track_Master`( In Purchase_Order_Master_Id_ Int)
Begin 
SELECT
	Purchase_Order_Track_Master_Id,Entry_Date,Customer_Name,Customer_Id,PONo,Po_Date,Invoice_No,Invoice_Date,Customer_Refno,Container_No,Port_Name,
    Eta_No,Track,Invoice_Amount,Payment_Status_Id,Payment_Status_Name,Order_Status_Id,Order_Status_Name,Description
	From purchase_order_track_master where Purchase_Order_Track_Master_Id =Purchase_Order_Master_Id_ and DeleteStatus=false ;
 SELECT
	purchase_order_track_details.Purchase_Order_Track_Details_Id,purchase_order_track_details.Purchase_Order_Track_Master_Id,
	purchase_order_track_details.Item_Name,	purchase_order_track_details.Sale_Rate Unit_Price ,
	purchase_order_track_details.Quantity,purchase_order_track_details.Total Amount
	From purchase_order_track_details 
	where purchase_order_track_details.Purchase_Order_Track_Master_Id =Purchase_Order_Master_Id_ and purchase_order_track_details.DeleteStatus=false ;
    
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Purchase_Return_Details`( In Purchase_Return_Master_Id_ int)
Begin 
 SELECT
 Purcahse_Return_Details_Id, Purchase_Return_Master_Id, Stock_Id,Item_Id ,Item_Name ,Barcode ,Packing_Size ,Colour ,Description ,Unit_Id ,Unit_Name ,Group_Id ,
Group_Name,HSN_Id ,HSN_Code ,WareHouse_Id,WareHouse_Name ,MFCode ,UPC ,Unit_Price ,Quantity,Amount ,Discount ,Netvalue ,CGST ,CGST_AMT ,SGST ,SGST_AMT ,IGST ,
IGST_AMT ,GST ,GST_AMT ,TotalAmount
 From purchase_return_details 
#inner join Sales_Master on Sales_Master.Sales_Master_Id=Sales_Details.Sales_Master_Id
where Purchase_Return_Master_Id =Purchase_Return_Master_Id_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Raw_Material`( In Item_Id_ int)
Begin 
 SELECT 
Raw_Material_Id ,raw_material.Item_Id ,raw_material.Item_Stock_Id ,raw_material.Item_Name,raw_material.Stock_Id ,raw_material.Quantity ,ItemName,raw_material.WareHouse_Id,raw_material.WareHouse_Name,raw_material.Product_Code
 From raw_material 
  inner join stock on stock.Stock_Id = raw_material.Stock_Id
 where Item_Id =Item_Id_ and raw_material.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_RawmaterialQty_Details`( In Stock_Id_ int,WareHouse_Id_ int,Quantity_ decimal(18,3))
Begin
 declare StkQty decimal(18,3) default 0;declare result int default 1;
 set StkQty=(SELECT Quantity from  stock_details where Stock_Id=Stock_Id_ and WareHouse_Id=WareHouse_Id_);
 if(Quantity_>StkQty)
then
set result=-1;
else
set result=1;
end if;
select result;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Salary_Calculation_Master`(in Salary_Calculation_Master_Id_ int)
Begin
select Salary_Calculation_Details.Is_Employee,Salary_Calculation_Details.Employee_Id,Salary_Calculation_Details.Employee_Name,
	Salary_Calculation_Details.Normal_Total,Salary_Calculation_Details.Ot_Total,Salary_Calculation_Details.Loading_Total,
    Salary_Calculation_Details.Piece_Total,Salary_Calculation_Details.Other_Total,
	Salary_Calculation_Details.TotalAmount,#client_accounts.Client_Accounts_Id Employee_Id,client_accounts.Client_Accounts_Name,
	case when Salary_Calculation_Details.Is_Employee>0 then 1 else 0 end as Check_Box
from Salary_Calculation_Details
where  DeleteStatus='False' and Salary_Calculation_Master_Id=Salary_Calculation_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Sales_Details`( In Sales_Master_Id_ decimal(18,0))
Begin
 SELECT
 Sales_Details_Id,Sales_Details.Sales_Master_Id,Sales_Details.Stock_Id,Sales_Details.ItemId,
 Sales_Details.ItemName,Sales_Details.Barcode,Packing_Size,Colour,Description,Sales_Details.Unit_Id,Sales_Details.Unit_Name,
 Sales_Details.Group_Id,Sales_Details.Group_Name,Sales_Details.HSN_Id,Sales_Details.HSN_CODE,Sales_Details.WareHouse_Id,WareHouse_Name,
 MFCode,UPC,Sales_Details.MRP,Sales_Details.SaleRate,Sales_Details.Quantity,Amount,ifnull(Sales_Details.Discount,0)Discount,Sales_Details.NetValue,
 Sales_Details.CGST,CGST_AMT,SGST,SGST_AMT,IGST,IFNULL(IGST_AMT, 0) as IGST_AMT,GST,GST_AMT,ifnull(Sales_Details.Cesspers,0)Cesspers,ifnull(Sales_Details.CessAMT,0)CessAMT,Sales_Details.TotalAmount,Weight,
 (Sales_Details.Quantity*Sales_Details.Weight)Total_Weight,ifnull(Sales_Details.Product_Code,'')Product_Code ,
 #(( stock_details.Quantity)+(Sales_Details.Quantity)) as currstock,
 0 as currstock,
 Packageno,Noofpcs,Noofpackage,Totalweight,Weightpcs,Netweight,Grossweight
 From Sales_Details 
 #inner join stock_details on Sales_Details.Stock_Id=stock_details.Stock_Id and Sales_Details.WareHouse_Id=stock_details.WareHouse_Id
where Sales_Details.Sales_Master_Id =Sales_Master_Id_ and Sales_Details.Category_Id=4 and Sales_Details.DeleteStatus=false ;

select Sales_Pack_List_Id,Sales_Master_Id,Stock_Id,ItemId,ItemName,Quantity,Weight,Total_Weight,Description
from Sales_Pack_List
where Sales_Master_Id=Sales_Master_Id_ and DeleteStatus=false;

select ItemId ,ItemName,Size ,Package_No ,No_Of_Pcs,No_Of_Pckgs ,Total,Weight,Net_Weight,Gross_Weight
from Sales_Packing_List
where Sales_Master_Id=Sales_Master_Id_ and DeleteStatus=false;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Sales_From_Porforma`( In Sales_Master_Id_ decimal(18,0))
BEGIN
SELECT Sales_Master_Id,(Date_Format(Sales_Master.Entry_Date,'%d-%m-%Y')) As search_date,
(Date_Format(Sales_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date,Sales_Master.PONo,ifnull(Sales_Master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,
Sales_Master_Id,(Date_Format(Sales_Master.PO_Date,'%Y-%m-%d')) As PO_Date,Account_Party_Id,Sales_Master.Company_Id,User_Id,GrossTotal,Invoice_No,GrandTotal,
TotalDiscount,NetTotal,TotalCGST,ToalSGST,TotalIGST,Cess,RoundOff,TotalAmount,TotalGST,Discount,Currency,Sales_Master.Description1,Bill_Type_Name,BillType,
Proforma_Invoice_Master_Id,Currency_Rate,Account_Party_Id,Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,Client_Accounts.Address2,
Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,client_accounts.GSTNo,client_accounts.PinCode,Pallet_Weight,Total_Weight,Net_Weight,
TypeofContainer,ContainerNo,Typeofpackage,Exporterref,Otherref,Precarriage,Vessalno,Contryoforgin,Contrydestination,PlaceofReceipt,Bank_Id,
Bank.Client_Accounts_Name Bank_Name,Portofloading,Portofdischarge,Finaldestination,Termsofdelivery,BI_No,ETA,Sales_Master.Status,Tracking_Id,Shipment_Status,
Product_Description,Total_Packing_packages,Total_Packing,Packing_NetWeight,Packing_GrossWeight,company.Company_Name,company.Address1 Company_Address1,
company.Address2 Company_Address2,company.Address3 Company_Address3,company.Address4 Company_Address4,company.Mobile_Number,company.GSTNO GST_No,company.IEC,
company.Phone_Number,company.EMail,company.RegNo
FROM Sales_Master
INNER JOIN Client_Accounts ON Sales_Master.Account_Party_Id=Client_Accounts.Client_Accounts_Id 
left JOIN Client_Accounts Bank ON Sales_Master.Bank_Id=Bank.Client_Accounts_Id 
inner join Bill_Type ON Sales_Master.BillType=Bill_Type.Bill_Type_Id
inner join company ON Sales_Master.Company_Id=company.Company_Id
WHERE Sales_Master.DeleteStatus =false and Sales_Master_Id=Sales_Master_Id_;

SELECT Sales_Details_Id,Sales_Details.Sales_Master_Id,Sales_Details.Stock_Id,Sales_Details.ItemId,
Sales_Details.ItemName,Sales_Details.Barcode,Packing_Size,Colour,Description,Sales_Details.Unit_Id,Sales_Details.Unit_Name,
Sales_Details.Group_Id,Sales_Details.Group_Name,Sales_Details.HSN_Id,Sales_Details.HSN_CODE,WareHouse_Id,WareHouse_Name,
MFCode,UPC,Sales_Details.MRP,Sales_Details.SaleRate,Sales_Details.Quantity,Amount,Sales_Details.Discount,Sales_Details.NetValue,
Sales_Details.CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_AMT,Cesspers,CessAMT,Sales_Details.TotalAmount,Weight,
(Sales_Details.Quantity*Sales_Details.Weight)Total_Weight,
Packageno,Noofpcs,Noofpackage,Totalweight,Weightpcs,Netweight,Grossweight ,Company_Id
From Sales_Details 
inner join Sales_Master ON Sales_Master.Sales_Master_Id=Sales_Details.Sales_Master_Id
where Sales_Details.Sales_Master_Id =Sales_Master_Id_ and Sales_Details.DeleteStatus=false;

SELECT Bill_Type_Id,Bill_Type_Name  From bill_type where DeleteStatus=false;
Select Company_Id,Company_Name from company where DeleteStatus=false;
select Container_Id,Container_Name from Container where DeleteStatus=false;
select Sales_Pack_List_Id,Sales_Master_Id,Stock_Id,ItemId,ItemName,Quantity,Weight,Total_Weight,Description
from Sales_Pack_List
where Sales_Master_Id=Sales_Master_Id_ and DeleteStatus=false;
select ItemId,ItemName,Size ,Package_No ,No_Of_Pcs,No_Of_Pckgs,Total,Weight,Net_Weight,Gross_Weight
from Sales_Packing_List
where Sales_Master_Id=Sales_Master_Id_ and DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Sales_Tracking`(in Purchase_Order_Master_Id_ int)
BEGIN
select (Date_Format(sales_master.Entry_Date,'%Y-%m-%d')) Entry_Date,
Invoice_No,ContainerNo,BI_No,ETA ,Tracking_Id,ifnull(BL,'') as BL,ifnull(BL_FileName,'') as BL_FileName,ifnull(PackingList,'') as PackingList,ifnull(PackingList_FileName,'') as PackingList_FileName,
ifnull(Invoice,'') as Invoice,ifnull(Invoice_FileName,'') as Invoice_FileName
from sales_master
inner join  purchase_order_master on sales_master.PONo=purchase_order_master.PONo
where purchase_order_master.Purchase_Order_Master_Id=Purchase_Order_Master_Id_ and sales_master.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shift_End_details`(in Shift_End_Master_Id_ int)
Begin
declare Production_No_ int;
set Production_No_=(select Production_No from shift_end_master where Shift_End_Master_Id=Shift_End_Master_Id_);

select client_accounts.Client_Accounts_Id Employee_Id,client_accounts.Client_Accounts_Name,
case when shift_end_details.Is_Employee>0 then 1 else 0 end as Check_Box,
    Process_Details_Id,Process_Details_Name
/*shift_end_details.Start_Time,shift_end_details.End_Time,shift_end_details.Working_Hours,shift_end_details.Ot,
shift_end_details.Loading,shift_end_details.Normal_Rate,shift_end_details.Ot_Rate,shift_end_details.Loading_Rate,
shift_end_details.Working_Total,shift_end_details.Ot_Total,shift_end_details.Loading_Total,
in (select shift_end_details.Employee_Id from shift_end_details where shift_end_details.Shift_End_Master_Id=Shift_End_Master_Id_
union select employee_details.Client_Accounts_Id from employee_details inner join  shift_end_master on
shift_end_master.Process_List_Id=employee_details.Process_Id and shift_end_master.Shift_End_Master_Id=Shift_End_Master_Id_ )
*/
from employee_details
inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
inner join client_accounts  on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id and employee_details.DeleteStatus='False'
and employee_details.Client_Accounts_Id 
left join shift_end_details on employee_details.Client_Accounts_Id=shift_end_details.Employee_Id and  shift_end_details.Shift_End_Master_Id=Shift_End_Master_Id_
order by client_accounts.Client_Accounts_Name asc;
 
select Shift_End_Details_Wastage_Id,Shift_End_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Warehouse_Id,Warehouse_Name
from  shift_end_details_wastage where  Shift_End_Master_Id=Shift_End_Master_Id_ and DeleteStatus=False;
   
    select Quantity    
from production_master where Production_No=Production_No_  and  DeleteStatus=False;
   
    select sum(Acceptable) Produced
    from shift_end_master where  Production_No=Production_No_  and  DeleteStatus=False;
 
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shift_End_From_Production`(in Production_Master_Id_ int )
BEGIN        
			SELECT  Item_Name,Item_Id,WareHouse_Id,WareHouse_Name,Production_No
			From production_master where production_master.DeleteStatus=false and Production_Master_Id=Production_Master_Id_;
            
            select Production_Details_Wastage_Id,Production_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,
			0 Quantitypers,Warehouse_Id,Warehouse_Name,DeleteStatus 
			from production_details_wastage where Production_Master_Id=Production_Master_Id_;

            
           /* 
            SELECT (Date_Format(shift_end_master.Date,'%Y-%m-%d')) As Date ,
			(Date_Format(shift_end_master.Date,'%d-%m-%Y')) As Search_Date,Shift_End_Master_Id,shift_end_master.Press_Details_Id,Production_No,Production_Master_Id,
			shift_end_master.Process_List_Id,shift_end_master.Shift_Details_Id,Shift_End_No,OutputNo,Acceptable,Damage,Wastage,
			shift_end_master.User_Id,shift_end_master.Stock_Id,shift_end_master.Item_Id,shift_end_master.Item_Name,shift_end_master.WareHouse_Id,shift_end_master.WareHouse_Name,
			Process_Details_Name Process_Name,Shift_Details_Name,Press_Details_Name 
			From shift_end_master 
			INNER JOIN process_details ON shift_end_master.Process_List_Id=process_details.Process_Details_Id
			INNER JOIN shift_details ON shift_end_master.Shift_Details_Id=shift_details.Shift_Details_Id
			INNER JOIN press_details ON shift_end_master.Press_Details_Id=press_details.Press_Details_Id
			where shift_end_master.DeleteStatus=false ;
                                         
            
            select  client_accounts.Client_Accounts_Name,Start_Time,End_Time,client_accounts.Client_Accounts_Id Employee_Id, 
			case when shift_end_details.Is_Employee>0 then 1 else 0 end as Check_Box 
			from employee_details inner join client_accounts  on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id
			inner join shift_end_master on shift_end_master.Process_List_Id=employee_details.Process_Id and shift_end_master.Shift_End_Master_Id=1
			left join shift_end_details on employee_details.Client_Accounts_Id=shift_end_details.Employee_Id
			and  shift_end_details.Shift_End_Master_Id=Shift_End_Master_Id_
			where employee_details.DeleteStatus='False' 
			order by client_accounts.Client_Accounts_Name asc ;        
			

			select Shift_End_Details_Wastage_Id,Shift_End_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Warehouse_Id,Warehouse_Name
			from  shift_end_details_wastage where  Shift_End_Master_Id=Shift_End_Master_Id_ and DeleteStatus=False;	*/		
            
			SELECT Press_Details_Id,Press_Details_Name,Status
			From press_details where DeleteStatus=false ;

			SELECT Shift_Details_Id,Shift_Details_Name,Status
			From shift_details where  DeleteStatus=false ;  
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shift_End_From_Shift_Start`(in Shift_End_Master_Id_ int )
BEGIN        
			SELECT (Date_Format(shift_end_master.Date,'%Y-%m-%d')) As Date ,
			(Date_Format(shift_end_master.Date,'%d-%m-%Y')) As Search_Date,Shift_End_Master_Id,shift_end_master.Press_Details_Id,Production_No,Production_Master_Id,
			shift_end_master.Process_List_Id,shift_end_master.Shift_Details_Id,Shift_End_No,OutputNo,Acceptable,Damage,Wastage,
			shift_end_master.User_Id,shift_end_master.Stock_Id,shift_end_master.Item_Id,shift_end_master.Item_Name,shift_end_master.WareHouse_Id,shift_end_master.WareHouse_Name,
			Process_Details_Name Process_Name,Shift_Details_Name,Press_Details_Name 
			From shift_end_master 
			INNER JOIN process_details ON shift_end_master.Process_List_Id=process_details.Process_Details_Id
			INNER JOIN shift_details ON shift_end_master.Shift_Details_Id=shift_details.Shift_Details_Id
			INNER JOIN press_details ON shift_end_master.Press_Details_Id=press_details.Press_Details_Id
			where shift_end_master.DeleteStatus=false ;
        
			select  client_accounts.Client_Accounts_Name,Start_Time,End_Time,client_accounts.Client_Accounts_Id Employee_Id, 
			case when shift_end_details.Is_Employee>0 then 1 else 0 end as Check_Box 
			from employee_details inner join client_accounts  on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id
			inner join shift_end_master on shift_end_master.Process_List_Id=employee_details.Process_Id and shift_end_master.Shift_End_Master_Id=1
			left join shift_end_details on employee_details.Client_Accounts_Id=shift_end_details.Employee_Id
			and  shift_end_details.Shift_End_Master_Id=Shift_End_Master_Id_
			where employee_details.DeleteStatus='False' 
			order by client_accounts.Client_Accounts_Name asc ;

			select Shift_End_Details_Wastage_Id,Shift_End_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Warehouse_Id,Warehouse_Name
			from  shift_end_details_wastage where  Shift_End_Master_Id=Shift_End_Master_Id_ and DeleteStatus=False;			
            
			SELECT Press_Details_Id,Press_Details_Name,Status
			From press_details where DeleteStatus=false ;

			SELECT Shift_Details_Id,Shift_Details_Name,Status
			From shift_details where  DeleteStatus=false ; 
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shift_Start`(in Shift_Start_Master_Id_ int)
BEGIN
select Shift_Start_Details_Process_Id,Shift_Start_Master_Id,Process_List_Id,Item_Id,Process_Id,Process_Name
from shift_start_details_process where Shift_Start_Master_Id=Shift_Start_Master_Id_ and DeleteStatus=false;

select Shift_Start_Details_RawMaterial_Id,Raw_Material_Id,shift_start_details_rawmaterial.Item_Id,Item_Stock_Id,Stock_Id,
No_Quantity,Weight_Quantity,item.Item_Name,shift_start_details_rawmaterial.Warehouse_Id,shift_start_details_rawmaterial.Warehouse_Name
from shift_start_details_rawmaterial 
inner join item on item.Item_Id=shift_start_details_rawmaterial.Item_Stock_Id
where Shift_Start_Master_Id=Shift_Start_Master_Id_ and shift_start_details_rawmaterial.DeleteStatus=false;

select Shift_Start_Details_Wastage_Id,Wastage_Id,shift_start_details_wastage.Item_Id,Item_Stock_Id,Stock_Id,Quantitypers,item.Item_Name,
shift_start_details_wastage.Warehouse_Id,shift_start_details_wastage.Warehouse_Name
from shift_start_details_wastage 
inner join item on item.Item_Id=shift_start_details_wastage.Item_Stock_Id
where Shift_Start_Master_Id=Shift_Start_Master_Id_ and shift_start_details_wastage.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shift_Start_From_Production`(in Production_Master_Id_ int )
BEGIN
declare Production_Quantity_ int;
SELECT  Production_Master_Id,Proforma_Invoice_Details_Id ,Proforma_Invoice_Master_Id,Date, User_Id,Stock_Id,Item_Id,PONo,
ifnull(Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,Item_Name,Quantity,Production_Status,Master_Status,PInvoice_No,Reference_Field,
production_master.Company_Id,Company_Name,WareHouse_Id,WareHouse_Name,Weight,Batch_Weight,Weight_Item
From production_master 
inner join Company on production_master.Company_Id=Company.Company_Id
where Production_Master_Id =Production_Master_Id_ and production_master.DeleteStatus=false ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shift_Start_To_Shift_End`(In Shift_Start_Master_Id_ int)
BEGIN
		select Shift_Start_Master_Id,Stock_Id,Item_Id,Item_Name,WareHouse_Id,WareHouse_Name ,Prodction_No  Production_No
		from shift_start_master where Shift_Start_Master_Id=Shift_Start_Master_Id_ and shift_start_master.DeleteStatus=false;

		select Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers, Warehouse_Id,Warehouse_Name
		from shift_start_details_wastage where Shift_Start_Master_Id=Shift_Start_Master_Id_ and shift_start_details_wastage.DeleteStatus=false;

		SELECT Press_Details_Id,Press_Details_Name,Status
		From press_details where DeleteStatus=false ;

		SELECT Shift_Details_Id,Shift_Details_Name,Status
		From shift_details where  DeleteStatus=false ;  

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shipment_Details_For_Performa_Invoice`(in Shipment_Master_Id_ int )
BEGIN
select  shipment_details.Stock_Id,shipment_details.Item_Id,shipment_details.Item_Name,shipment_details.Quantity,
shipment_details.Unit_Price SaleRate,shipment_details.Barcode,shipment_details.Group_Id,shipment_details.Group_Name,
shipment_details.Unit_Id,shipment_details.Unit_Name,shipment_details.HSN_Id,
shipment_details.HSN_Code HSN_CODE,
stock.MRP,stock.CGST,stock.SGST,stock.IGST,stock.GST,shipment_details.Weight,
cast((Shipment_Details.Quantity*Unit_Price) as decimal(18,2))Amount,0 as Discount,cast((((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST))as decimal(18,2)) Netvalue,cast((((Shipment_Details.Quantity*Unit_Price)-(((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST)))/2)as decimal(18,2))  CGST_AMT,
cast((((Shipment_Details.Quantity*Unit_Price)-(((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST)))/2)as decimal(18,2))SGST_AMT,0 IGST_AMT,
cast(((Shipment_Details.Quantity*Unit_Price)-(((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST)))as decimal(18,2)) GST_AMT,cast(((((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST)) *1/100) as decimal(18,2))CessAMT,1 Cesspers,
cast(((((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST))+((Shipment_Details.Quantity*Unit_Price)-(((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST)))+((((Shipment_Details.Quantity*Unit_Price)*100)/(100+GST)) *1/100))as decimal(18,2))TotalAmount  ,
(Shipment_Details.Quantity*shipment_details.Weight)Total_Weight,Shipment_Details.Description
from shipment_details
 #inner join shipment_details on shipment_details.Stock_Id =shipment_details.Stock_Id
inner join stock on shipment_details.Stock_Id=stock.Stock_Id
where shipment_details.Shipment_Master_Id =Shipment_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Shipment_Master_For_Performa_Invoice`(in Shipment_Master_Id_ int )
BEGIN
select client_accounts.Client_Accounts_Id,Client_Accounts_Name Customer,client_accounts.Client_Accounts_Code Customer_Code,
Address1,Address2,Address3,Address4,PinCode,StateCode,GSTNo,PanNo,State,Country,Phone,Mobile,Email,
Currency,purchase_order_master.Purchase_Order_Master_Id,PONo,purchase_order_master.Company_Id,purchase_order_master.Payment_Term Payment_term,
(Date_Format(Purchase_Order_Master.Entry_Date,'%Y-%m-%d')) As PO_Date,
(Date_Format(Purchase_Order_Master.Delivery_Date,'%Y-%m-%d')) As Valid_Date
from client_accounts 
inner join purchase_order_master on client_accounts.Client_Accounts_Id=purchase_order_master.Client_Accounts_Id
inner join shipment_master on purchase_order_master.Purchase_Order_Master_Id=shipment_master.Purchase_Order_Master_Id
where shipment_master.DeleteStatus=0 and shipment_master.Shipment_Master_Id=Shipment_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Add_Details`( In Stock_Add_Master_Id_ Int)
Begin 
 SELECT Stock_Add_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,
 Group_Id,Group_Name,HSN_Id,HSN_CODE,MFCode,UPC,MRP,SaleRate,PurchaseRate,Quantity,CGST,SGST,IGST,GST,
 Is_Expiry,WareHouse_Id,WareHouse_Name,Product_Code,
(Date_Format(Stock_Add_Details.Expiry_Date,'%Y-%m-%d')) as Expiry_Date
 From Stock_Add_Details 
 
 where Stock_Add_Master_Id =Stock_Add_Master_Id_ and Stock_Add_Details.DeleteStatus=false ;
 
 #inner join Client_Accounts on Stock_Add_Details.To_Employee_Id=Client_Accounts.Client_Accounts_Id    Client_Accounts.Client_Accounts_Name  
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_From_Warehouse`( In ItemName_ varchar(100),From_WareHouse_Id_ int,From_Company_Id_ int)
Begin 
set ItemName_ = Concat( '%',ItemName_ ,'%');
SELECT Stock.Stock_Id,ItemId,ItemName,stock_details.Quantity,Barcode,WareHouse_Id,SaleRate,Company_Id
From Stock inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
where stock_details.WareHouse_Id=From_WareHouse_Id_ and Company_Id=From_Company_Id_ and ItemName like ItemName_ and Stock.DeleteStatus=false
ORDER BY ItemName ASC LIMIT 5;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_From_Warehouse1`( In ItemName_ varchar(100),
From_WareHouse_Id_ int,From_Company_Id_ int)
Begin 
set ItemName_ = Concat( '%',ItemName_ ,'%');
SELECT Stock.Stock_Id,ItemId,ItemName,stock_details.Quantity
From Stock inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
where stock_details.WareHouse_Id=From_WareHouse_Id_ and Company_Id=From_Company_Id_ and ItemName like ItemName_ and Stock.DeleteStatus=false
ORDER BY ItemName ASC LIMIT 5;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Group_From_Warehouse`( In ItemName_ varchar(100),Group_Id_ int,WareHouse_Id_ int)
Begin 
 set ItemName_ = Concat( '%',ItemName_ ,'%');
SELECT Stock.Stock_Id,ItemId,ItemName,stock_details.Quantity,Barcode,WareHouse_Id,SaleRate
From Stock
inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
where stock_details.WareHouse_Id=WareHouse_Id_ and Group_Id=Group_Id_
and ItemName like ItemName_ and Quantity>0 and Stock.DeleteStatus=false
ORDER BY ItemName ASC LIMIT 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Item`( In ItemName_ varchar(100),WareHouse_Id_ int,Company_Id_ int)
Begin
declare Stock_Id_ int;
set ItemName_ = Concat( '%',ItemName_ ,'%');
SELECT Stock.Stock_Id,Stock.ItemId,Stock.ItemName,stock_details.Quantity
From stock_details
inner join Stock on stock_details.Stock_Id=Stock.Stock_Id
where Company_Id=Company_Id_ and WareHouse_Id=WareHouse_Id_
and ItemName like ItemName_ and Stock.DeleteStatus=false
ORDER BY ItemName ASC LIMIT 5;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Item_Typeahead`( In ItemName_ varchar(100),Item_Group_ int)
Begin 
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value="";
	set ItemName_ = Concat( "'%",ItemName_ ,"%'");
if Item_Group_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Stock.Group_Id =",Item_Group_);
end if;
 SET @query = Concat("SELECT Stock.Stock_Id,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,
 UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Is_Expiry,Expiry_Date,stock_details.WareHouse_Id,WareHouse_Name,stock_details.Quantity,Stock.Weight
From Stock
inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
inner join warehouse on stock_details.WareHouse_Id=warehouse.WareHouse_Id
where  ItemName like", ItemName_ ,"and Quantity>0 and Stock.DeleteStatus=false ",
 SearchbyName_Value,"
oRDER BY ItemName ASC LIMIT 5");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Item_Typeahead_PO`( In ItemName_ varchar(100),Item_Group_ int)
Begin 
declare SearchbyName_Value varchar(2000);
set SearchbyName_Value="";
	set ItemName_ = Concat( "'%",ItemName_ ,"%'");
if Item_Group_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Stock.Group_Id =",Item_Group_);
end if;
 SET @query = Concat("SELECT Stock.Stock_Id,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,
 UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Stock.Weight
From Stock
where  ItemName like", ItemName_ ," and Stock.DeleteStatus=false ",
 SearchbyName_Value,"
oRDER BY ItemName ASC LIMIT 5");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Item_Typeahead_PO_te`( In ItemName_ varchar(1000),Group_Id_ int)
Begin
set ItemName_ = Concat( '%',ItemName_ ,'%');
SELECT Stock.Stock_Id,Stock.ItemId,Stock.ItemName,Product_Code
From Stock
where  ItemName like ItemName_ and Stock.DeleteStatus=false and Group_Id= Group_Id_
ORDER BY ItemName ASC ;
#LIMIT 5;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Item_Typeahead_PO2`(ItemName_ varchar(1000))
Begin

set ItemName_ = Concat( '%',ItemName_ ,'%');
SELECT Stock.Stock_Id,Stock.ItemId,Stock.ItemName
From Stock
where  ItemName like ItemName_ and Stock.DeleteStatus=false
ORDER BY ItemName ASC LIMIT 5;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Quantity_Details`( In Stock_Id_ int,WareHouse_Id_ int,Company_Id_ int)
Begin 
SELECT Stock_Details_Id ,Stock_Id , WareHouse_Id ,Quantity ,Company_Id 
From stock_details 
where Stock_Id =Stock_Id_ and WareHouse_Id = WareHouse_Id_ and Company_Id=Company_Id_ and DeleteStatus=false  ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_To_Warehouse`( In ItemName_ varchar(100),To_WareHouse_Id_ int,To_Company_Id_ int)
Begin 
set ItemName_ = Concat( '%',ItemName_ ,'%');
SELECT Stock.Stock_Id,ItemId,ItemName,stock_details.Quantity,Barcode,WareHouse_Id,SaleRate
From Stock inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
where stock_details.WareHouse_Id=To_WareHouse_Id_ and Company_Id=To_Company_Id_ and ItemName like ItemName_ and Stock.DeleteStatus=false
ORDER BY ItemName ASC LIMIT 5;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Stock_Transfer_Details`( In Stock_transfer_Master_Id_ Int)
Begin 
 SELECT Stock_transfer_Details_Id,Stock_Transfer_Details.Stock_transfer_Master_Id,Stock_Transfer_Details.Stock_Id,Item_Id,
 Item_Name,Stock_Transfer_Details.Quantity,From_Stock_Id,From_Stock_Name,To_Stock_Id,To_Stock_Name,ifnull(Barcode,'') Barcode,From_Company_Id,To_Company_Id
 From Stock_Transfer_Details 
# inner join stock_details on stock_details.Stock_Id=Stock_Transfer_Details.Stock_Id   and WareHouse_Id=From_Stock_Id
inner join stock_transfer_master on stock_transfer_master.Stock_transfer_Master_Id=Stock_Transfer_Details.Stock_transfer_Master_Id
 where Stock_Transfer_Details.Stock_transfer_Master_Id =Stock_transfer_Master_Id_ and Stock_Transfer_Details.DeleteStatus=false  ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_User_Details_Edit`( In User_Details_Id_ Int)
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
  and User_Id =User_Details_Id_ where 
  Menu.DeleteStatus=false and   Menu.Menu_Status=true order by Menu_Id ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_User_Type`()
BEGIN
SELECT User_Type_Id,
User_Type_Name From User_Type 
order by User_Type_Name asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Warehouse_Company_Typeahead`(in Company_Id_ int,Warehouse_Name_ varchar(50))
BEGIN
	set Warehouse_Name_ = Concat( '%',Warehouse_Name_ ,'%');
	SELECT Company_Id,warehouse.WareHouse_Id,WareHouse_Name    
    from Company_Warehouse
    inner join warehouse on warehouse.WareHouse_Id=Company_Warehouse.WareHouse_Id
    where warehouse.DeleteStatus=false and Company_Warehouse.DeleteStatus=false
    and WareHouse_Name like Warehouse_Name_ and Company_Id=Company_Id_
    order by WareHouse_Name asc limit 5 ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Warehouse_Typeahead`(in Stock_Id_ int,Warehouse_Name_ varchar(50))
BEGIN
	set Warehouse_Name_ = Concat( '%',Warehouse_Name_ ,'%');
	SELECT Stock_Id,warehouse.WareHouse_Id,WareHouse_Name    
    from stock_details
    inner join warehouse on warehouse.WareHouse_Id=stock_details.WareHouse_Id
    where warehouse.DeleteStatus=false and stock_details.DeleteStatus=false
    and WareHouse_Name like Warehouse_Name_ and Stock_Id=Stock_Id_
    order by WareHouse_Name asc limit 5 ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Wastage`( In Item_Id_ int)
Begin 
 SELECT 
Wastage_Id ,wastage.Item_Id ,Item_Stock_Id, wastage.Item_Name ,wastage.Stock_Id ,Quantitypers ,ItemName,wastage.WareHouse_Id,wastage.WareHouse_Name,wastage.Product_Code
 From wastage 
  inner join stock on stock.Stock_Id = wastage.Stock_Id
 where Item_Id =Item_Id_ and wastage.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Waste_In_Master`( In Waste_In_Master_Id_ Int)
Begin 
	SELECT Waste_In_Master.Waste_In_Master_Id ,  Waste_In_Master.Client_Accounts_Id, Date ,User_Id ,  Company_Id ,  Waste_In_No ,Description ,
	waste_in_details.Waste_In_Details_Id,Waste_In_Details.Waste_In_Master_Id,Stock_Id,Item_Id,Item_Name,WareHouse_Id,WareHouse_Name,Quantity,
	client_accounts.Client_Accounts_Name
	From Waste_In_Master 
	inner join  Client_Accounts on client_accounts.Client_Accounts_Id=waste_in_master.Client_Accounts_Id
	inner join Waste_In_Details on waste_in_details.Waste_In_Master_Id=waste_in_master.Waste_In_Master_Id
	#inner join warehouse on warehouse.WareHouse_Id=waste_in_master.WareHouse_Id
	where Waste_In_Master.Waste_In_Master_Id =Waste_In_Master_Id_ and Waste_In_Master.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_Waste_Out_Details`(In Waste_Out_Master_Id_ int )
BEGIN
select Waste_Out_Details_Id,Waste_Out_Master_Id ,Item_Id ,Item_Name ,Quantity ,Stock_Id,
Warehouse_Id,Warehouse_Name,Rate,Amount

from waste_out_details
where Waste_Out_Master_Id=Waste_Out_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `HSN_Dropdown`()
BEGIN
SELECT 
HSN_Id,HSN_CODE,SGST,IGST,CGST,GST
From HSN
 where DeleteStatus=false
ORDER BY HSN_CODE ASC;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Item_Name_Change`( In Stock_Id_ int)
Begin
SELECT Stock_Id,ItemId,ItemName,Barcode,Group_Id,Group_Name,Unit_Id,
Unit_Name,HSN_Id,HSN_CODE,CGST,SGST,IGST,GST,SaleRate,MRP,MFCode,UPC,Packing_Size,Colour,Description,Weight From Stock
where  DeleteStatus=false
ORDER BY ItemName ASC LIMIT 5;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Item_Name_Changes`( In Stock_Id_ int)
Begin
SELECT Stock_Id,ItemId,ItemName,Barcode,Group_Id,Group_Name,Unit_Id,
Unit_Name,HSN_Id,HSN_CODE,CGST,SGST,IGST,GST,SaleRate,MRP,MFCode,UPC,Packing_Size,Colour,
Description,Weight From Stock
where Stock_Id=Stock_Id_ and DeleteStatus=false
ORDER BY ItemName ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Item_Stock_Name_Changes`( In Stock_Id_ int)
Begin
SELECT Stock.Stock_Id,ItemId,ItemName,Barcode,Group_Id,Group_Name,Unit_Id,
Unit_Name,HSN_Id,HSN_CODE,CGST,SGST,IGST,GST,SaleRate,MRP,MFCode,UPC,Packing_Size,Colour,
Description,Weight,stock_details.Quantity as Quantity From Stock
 inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
where Stock.Stock_Id=Stock_Id_ and Stock.DeleteStatus=false
ORDER BY ItemName ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Item_Typeahead`( In Item_Name_ varchar(100))
Begin 
 set Item_Name_ = Concat( '%',Item_Name_ ,'%');
 SELECT 
Item_Id,
Group_Id,
Group_Name,
Saleunit_Id,
Saleunit_Name,
Item_Code,
Item_Name,
Sales_Tax,
HSNMasterId,
CGST,
SGST,
IGST,
HSNCODE,
Country_Id,
Country_Name  
From Item 
where Item_Name like Item_Name_ and DeleteStatus=false 
 ORDER BY Item_Name Asc Limit 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ItemGroup_Typehead`( In Item_Group_Name_ varchar(100))
Begin 
 set Item_Group_Name_ = Concat( '%',Item_Group_Name_ ,'%');
 SELECT 
 Item_Group_Id,
Item_Group_Name From Item_Group where Item_Group_Name like Item_Group_Name_ and DeleteStatus=false 
 ORDER BY Item_Group_Name Asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Account_Group`(In Group_Name_ varchar(100))
Begin 
 set Group_Name_ = Concat( '%',Group_Name_ ,'%');
 SELECT Account_Group_Id,Group_Name
 From Account_Group where  
 Group_Name like Group_Name_ and DeleteStatus=false 
  ORDER BY Group_Name Asc Limit 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Bill_Type`(in Bill_Status_ int)
BEGIN
SELECT Bill_Type_Id,Bill_Type_Name
From bill_type
where DeleteStatus=false and Bill_Status=Bill_Status_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Category`()
BEGIN
select Category_Id,Category_Name
from category
where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Company`()
BEGIN
Select * from company where DeleteStatus=false;
Select * from item_group where DeleteStatus=false;
Select * from currency where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Container`()
BEGIN
select Container_Id,Container_Name
from Container
where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Country`()
BEGIN
select Country_Id,Country_Name,Weight
from Country where DeleteStatus=false=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Employee`()
BEGIN
select client_accounts.Client_Accounts_Id Employee_Id,Client_Accounts_Name,Normal_Rate,Ot_Rate,Loading_Rate,
Process_Details_Name,Process_Details_Id
from client_accounts 
inner join  employee_details on employee_details.Client_Accounts_Id=client_accounts.Client_Accounts_Id
inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
where  employee_details.DeleteStatus=false and Process_Details.Process_Details_Id<>5
 order by Client_Accounts_Name asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Employee_Packing`()
BEGIN
select client_accounts.Client_Accounts_Id Employee_Id,Client_Accounts_Name,Normal_Rate,Ot_Rate,Loading_Rate,
Process_Details_Name,Process_Details_Id
from client_accounts 
inner join  employee_details on employee_details.Client_Accounts_Id=client_accounts.Client_Accounts_Id
inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
where  employee_details.DeleteStatus=false #and Process_Details.Process_Details_Id<>5
 order by Client_Accounts_Name asc ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Item_Group`( )
Begin 
 SELECT 
 Item_Group_Id,
Item_Group_Name From Item_Group  where DeleteStatus=false 
 ORDER BY Item_Group_Name Asc ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Item_Wastage_ByItemname`(In Item_Name_ varchar(100))
Begin 
	set Item_Name_ = Concat( "'%",Item_Name ,"%'");
	Set @query=CONCAT("SELECT wastage.Wastage_Id,wastage.Item_Id,Item.Item_Name,Item_Stock_Id,Stock_Id,Quantitypers
	FROM wastage inner join Item on wastage.Item_Id=Item.Item_Id
	where wastage.DeleteStatus=false and Item_Name like ",  Item_Name_," 
	ORDER BY Item_Name Asc Limit 5 ");
	PREPARE QUERY FROM @query;EXECUTE QUERY;
	# select @query;    
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Order_Status`(In Order_Status_Name_ varchar(100),Group_Id_ int)
BEGIN

 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
	set Order_Status_Name_ = Concat( "'%",Order_Status_Name_ ,"%'");
if Group_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and order_status.Group_Id =",Group_Id_);
end if;
Set @query=CONCAT("	SELECT 	Order_Status_Id,	Order_Status_Name,Group_Id
	From order_status 
where order_status.DeleteStatus=false and Order_Status_Name like ",  Order_Status_Name_ ," " ,SearchbyName_Value, "
 order by Order_Status_Name  asc");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
# select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Pass_Type`()
BEGIN
select Pass_Type_Id,Pass_Type_Name
from Pass_Type;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_payment_Status`()
BEGIN
Select * from payment_Status where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Position`()
BEGIN
select Position_Id,Position_Name from Position
where DeleteStatus=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Process`()
BEGIN
SELECT Process_Details_Id,Process_Details_Name
From process_details
where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Purchase_Order_Status`()
BEGIN
SELECT Purchase_Order_Status_Id,Purchase_Order_Status_Name
From Purchase_Order_Status
where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Purchase_type`()
BEGIN
SELECT Purchase_Type_Id,Purchase_Type_Name
From purchase_type  where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Shipment_Method`()
BEGIN
Select Shipment_Method_Id,Shipment_Method_Name from shipment_method where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Shipment_Plan`()
BEGIN
Select Shipment_Plan_Id,Shipment_Plan_Name from shipment_plan where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Load_Warehouse`()
BEGIN
SELECT WareHouse_Id,WareHouse_Name
From warehouse  where DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Login_Check`( In User_Details_Name_ VARCHAR(50),Password_ VARCHAR(50))
BEGIN
SELECT User_Details_Id,User_Details_Name,User_Type
From User_Details where User_Details_Name =User_Details_Name_ and Password=Password_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Login_User_Check`( In User_Name_ VARCHAR(50),in Password_ VARCHAR(50))
BEGIN
SELECT 

Client_Accounts_Id,Client_Accounts_Name,User_Name
From client_accounts 
 where  User_Name =User_Name_ and Password=Password_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Move_To_Production`(In Proforma_Invoice_Master_Id_ int,Proforma_Status_ int,User_Id_ int)
BEGIN
declare Proforma_Status_temp_ int;declare Proforma_Status_Caption varchar(100);
declare Master_Status_ int;declare pocount int;declare Purchase_Order_Master_Id_ int;
set Purchase_Order_Master_Id_=(select Purchase_Order_Master_Id from shipment_master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and DeleteStatus=False);
if Proforma_Status_ !=3 then
   set Master_Status_=(select  Master_Status from Proforma_Invoice_Master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);
if Master_Status_=1 then
set Proforma_Invoice_Master_Id_=-1;
else
set Proforma_Status_temp_=3;
set Proforma_Status_Caption =(select  Order_Status_Name from order_status where Order_Status_Id=Proforma_Status_);
update Proforma_Invoice_Master set Proforma_Status=Proforma_Status_temp_ ,Production_Status=0 where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;
set pocount=(select count(Purchase_Order_Master_Id) from Shipment_Master where Purchase_Order_Master_Id in(select Purchase_Order_Master_Id
from shipment_master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and DeleteStatus=False) and Proforma_Invoice_Master_Id>0);
        if(pocount=1)then
update purchase_order_master set Order_Status=Proforma_Status_temp_ where Purchase_Order_Master_Id =Purchase_Order_Master_Id_;
#in(select Purchase_Order_Master_Id from shipment_master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ and DeleteStatus=False);
        end if;  
        insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,curdate(),Proforma_Invoice_Master_Id_,Proforma_Status_Caption,Proforma_Status_temp_,'',Purchase_Order_Master_Id_,False);        
end if;
else
set Proforma_Status_temp_=4;
        set Proforma_Status_Caption =(select  Order_Status_Name from order_status where Order_Status_Id=Proforma_Status_);
update Proforma_Invoice_Master set Proforma_Status=Proforma_Status_temp_,Production_Status=1
 where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;
update purchase_order_master set Order_Status=Proforma_Status_temp_ where Purchase_Order_Master_Id=(select Purchase_Order_Master_Id from Proforma_Invoice_Master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);
insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,curdate(),Proforma_Invoice_Master_Id_,Proforma_Status_Caption,Proforma_Status_temp_,'',Purchase_Order_Master_Id_,False);
end if;
select Proforma_Invoice_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `new_procedure1`()
BEGIN
select * from user;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Product_Code_Change`( In Product_Code_ varchar(100))
Begin
SELECT Stock.Stock_Id,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,
 UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Stock.Weight
 From Stock
 where Product_Code =Product_Code_ and Group_Id=2 and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Product_Code_Change_packinglist`( In Product_Code_ varchar(100))
Begin
SELECT Stock.Stock_Id,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,
 UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Stock.Weight
 From Stock
 where Product_Code =Product_Code_ and Group_Id=1 and DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Product_Code_Change_Wastage`( In Product_Code_ varchar(100))
Begin
SELECT Stock.Stock_Id,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,
 UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Stock.Weight,stock_details.Quantity
 From Stock
 inner join stock_details on stock_details.Stock_Id=Stock.Stock_Id
 where Product_Code =Product_Code_  and Stock.DeleteStatus=false ;
 
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Quantity_Available_Check`(In stockid_ int,company_id_ int,warehouseid_ int ,cur_quant_ decimal(18,2))
BEGIN
declare Available_Stock_Quantity_ decimal(18,2);declare Is_Available_ int;
set Available_Stock_Quantity_ = (select Quantity from stock_details where Stock_Id = stockid_ and WareHouse_Id = warehouseid_ and Company_Id = company_id_ and DeleteStatus=0);
if(Available_Stock_Quantity_ >= cur_quant_) then
	set Is_Available_ =  1;
else
	set Is_Available_ =  -1;
end if;
select Is_Available_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Account_Group`( In Account_Group_Id_ decimal,
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Attendance_Import`( In Attendance_Master_Id_ int, Employee_InUser_Id_ int,Attendance_Details json)
BEGIN
declare Attendance_Details_Id_ int;DECLARE Is_Employee_ varchar(25);declare Employee_Id_ int;DECLARE check_out_time_ varchar(100);
DECLARE Normal_Hrs_ decimal(18,2);DECLARE Normal_Rate_ decimal(18,2);DECLARE Normal_Total_ decimal(18,2);
DECLARE Ot_Hrs_ decimal(18,2);DECLARE Ot_Rate_ decimal(18,2);DECLARE Ot_Total_ decimal(18,2);
Declare Loading_Hrs_ decimal(18,2);Declare Loading_Rate_ decimal(18,2);declare Loading_Total_ decimal(18,2);
Declare No_Of_Piece_ decimal(18,2);Declare Piece_Rate_ decimal(18,2);Declare Piece_Total_ decimal(18,2);
DECLARE Punch_Status_ int;declare Other_Work_ varchar(4000);declare Other_Start_Time_ varchar(100);declare Other_End_Time_ varchar(100);
declare Other_Total_Hrs_ decimal(18,2); declare Other_Rate_ decimal(18,2);declare Other_Total_ decimal(18,2);DECLARE Total_ decimal(18,2);
declare Employee_Code_ varchar(100);declare Employee_Name_ varchar(100);declare Process_Details_Name_ varchar(200);declare Employee_InDate_ datetime;declare Employee_InTime_ varchar(100);
declare Employee_OutDate_ datetime;declare Employee_OutTime_ varchar(100);
DECLARE i int  DEFAULT 0;
 
		SET Attendance_Master_Id_ = (SELECT  COALESCE( MAX(Attendance_Master_Id ),0)+1 FROM attendance_master); 
		INSERT INTO attendance_master(Attendance_Master_Id,Entry_Date,Attendance_Status,Employee_OutDate,Employee_OutTime, Employee_OutUser_Id,DeleteStatus ) 
		values (Attendance_Master_Id_,now(),1 ,now() ,now() ,  Employee_InUser_Id_ ,false);
   
    WHILE i < JSON_LENGTH(Attendance_Details) DO
    
    
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_Code'))) INTO Employee_Code_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Client_Accounts_Name'))) INTO Employee_Name_;	
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Process_Details_Name'))) INTO Process_Details_Name_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,']. Employee_InDate'))) INTO  Employee_InDate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,']. Employee_InTime'))) INTO  Employee_InTime_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_OutDate'))) INTO Employee_OutDate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_OutTime'))) INTO Employee_OutTime_;
        
        SET Employee_Id_ = (SELECT Client_Accounts_Id FROM client_accounts where Client_Accounts_Code=Employee_Code_ and DeleteStatus=false);
    
    
    /*
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Attendance_Details_Id'))) INTO Attendance_Details_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_Id'))) INTO Employee_Id_;	
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_OutTime'))) INTO check_out_time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Normal_Hrs'))) INTO Normal_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Normal_Rate'))) INTO Normal_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Normal_Total'))) INTO Normal_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Ot_Hrs'))) INTO Ot_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Ot_Rate'))) INTO Ot_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Ot_Total'))) INTO Ot_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Loading_Hrs'))) INTO Loading_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Loading_Rate'))) INTO Loading_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Loading_Total'))) INTO Loading_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].No_Of_Piece'))) INTO No_Of_Piece_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Piece_Rate'))) INTO Piece_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Piece_Total'))) INTO Piece_Total_;        
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Work'))) INTO Other_Work_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Start_Time'))) INTO Other_Start_Time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_End_Time'))) INTO Other_End_Time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Total_Hrs'))) INTO Other_Total_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Rate'))) INTO Other_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Total'))) INTO Other_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Total'))) INTO Total_;
        
        */
        INSERT INTO Attendance_Details(Attendance_Master_Id,Is_Employee,Employee_Id,Employee_InDate,Employee_InTime ,Employee_OutDate,Employee_OutTime,Punch_Status,DeleteStatus,Employee_Code,Employee_Name) 
        
       values (Attendance_Master_Id_ ,1 ,Employee_Id_ ,Employee_InDate_ ,Employee_InTime_,Employee_OutDate_,Employee_OutTime_ ,0,false,Employee_Code_,Employee_Name_);  
		SELECT i + 1 INTO i;
	END WHILE; 
select Attendance_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Category_Dropdown`( In Category_Id_ int,Category_Name_ varchar(100),Packing_Master_Id_ int)
Begin 
update packing_master set Category_Id=Category_Id_,Category_Name=Category_Name_ where Packing_Master_Id=Packing_Master_Id_;
 select Packing_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Check_In`(  In Attendance_Master_Id_ int,Employee_InDate_ datetime,Employee_InTime_ varchar(100),
Attendance_Status_ int,Employee_InUser_Id_ int,Attendance_Details JSON)
BEGIN
DECLARE Is_Employee_ varchar(25);declare Employee_Id_ int;declare Check_InTime_ varchar(50);declare EntryDate_ datetime;
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
    START TRANSACTION; */ 
    set EntryDate_=now();
	if  Attendance_Master_Id_>0 THEN      
		delete from attendance_details where Attendance_Master_Id=Attendance_Master_Id_;
		UPDATE attendance_master set Employee_InDate=Employee_InDate_,Employee_InTime=Employee_InTime_,Employee_InUser_Id = Employee_InUser_Id_  
        Where Attendance_Master_Id=Attendance_Master_Id_ ;
	ELSE 
		SET Attendance_Master_Id_ = (SELECT COALESCE(MAX(Attendance_Master_Id ),0)+1 FROM attendance_master); 
		INSERT INTO attendance_master(Attendance_Master_Id,Entry_Date,Employee_InDate, Employee_InTime,Attendance_Status,Employee_InUser_Id, DeleteStatus ) 
		values (Attendance_Master_Id_,EntryDate_,Employee_InDate_, Employee_InTime_ ,0 ,Employee_InUser_Id_ , false);       
	End If ;    
    WHILE i < JSON_LENGTH(Attendance_Details) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Check_Box'))) INTO Is_Employee_;
        if(Is_Employee_='true'  or  Is_Employee_=1) 
			then set Is_Employee_=1;
			else set Is_Employee_=0;
		end if;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_Id'))) INTO Employee_Id_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_InTime'))) INTO Check_InTime_;
		INSERT INTO Attendance_Details(Attendance_Master_Id,Is_Employee,Employee_Id,Employee_InDate,Employee_InTime ,Punch_Status,DeleteStatus) 
       values (Attendance_Master_Id_ ,Is_Employee_ ,Employee_Id_ ,Employee_InDate_ ,Check_InTime_ ,0,false);     
		SELECT i + 1 INTO i;
	END WHILE;
#COMMIT;
select Attendance_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Check_Out`( In Attendance_Master_Id_ int,Employee_OutDate_ datetime,Employee_OutTime_ varchar(100),
Employee_OutUser_Id_ int,Attendance_Details JSON)
BEGIN
declare Attendance_Details_Id_ int;DECLARE Is_Employee_ varchar(25);declare Employee_Id_ int;DECLARE check_out_time_ varchar(100);
DECLARE Normal_Hrs_ decimal(18,2);DECLARE Normal_Rate_ decimal(18,2);DECLARE Normal_Total_ decimal(18,2);
DECLARE Ot_Hrs_ decimal(18,2);DECLARE Ot_Rate_ decimal(18,2);DECLARE Ot_Total_ decimal(18,2);
Declare Loading_Hrs_ decimal(18,2);Declare Loading_Rate_ decimal(18,2);declare Loading_Total_ decimal(18,2);
Declare No_Of_Piece_ decimal(18,2);Declare Piece_Rate_ decimal(18,2);Declare Piece_Total_ decimal(18,2);
DECLARE Punch_Status_ int;declare Other_Work_ varchar(4000);declare Other_Start_Time_ varchar(100);declare Other_End_Time_ varchar(100);
declare Other_Total_Hrs_ decimal(18,2); declare Other_Rate_ decimal(18,2);declare Other_Total_ decimal(18,2);DECLARE Total_ decimal(18,2);
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
    START TRANSACTION; */ 
	if  Attendance_Master_Id_>0 THEN      
		UPDATE attendance_master set Attendance_Status = 1 ,Employee_OutDate = Employee_OutDate_ ,Employee_OutTime = Employee_OutTime_ ,
        Employee_OutUser_Id=Employee_OutUser_Id_ Where Attendance_Master_Id=Attendance_Master_Id_ ;
	ELSE 
		SET Attendance_Master_Id_ = (SELECT  COALESCE( MAX(Attendance_Master_Id ),0)+1 FROM attendance_master); 
		INSERT INTO attendance_master(Attendance_Master_Id,Attendance_Status,Employee_OutDate,Employee_OutTime, Employee_OutUser_Id,DeleteStatus ) 
		values (Attendance_Master_Id_,1 ,Employee_OutDate_ ,Employee_OutTime_ ,  Employee_OutUser_Id_ ,false);       
	End If ;    
    WHILE i < JSON_LENGTH(Attendance_Details) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Check_Box'))) INTO Is_Employee_;
        if(Is_Employee_='true'  or  Is_Employee_=1) 
			then set Is_Employee_=1;
			else set Is_Employee_=0;
		end if;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Attendance_Details_Id'))) INTO Attendance_Details_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_Id'))) INTO Employee_Id_;	
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Employee_OutTime'))) INTO check_out_time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Normal_Hrs'))) INTO Normal_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Normal_Rate'))) INTO Normal_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Normal_Total'))) INTO Normal_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Ot_Hrs'))) INTO Ot_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Ot_Rate'))) INTO Ot_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Ot_Total'))) INTO Ot_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Loading_Hrs'))) INTO Loading_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Loading_Rate'))) INTO Loading_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Loading_Total'))) INTO Loading_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].No_Of_Piece'))) INTO No_Of_Piece_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Piece_Rate'))) INTO Piece_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Piece_Total'))) INTO Piece_Total_;        
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Work'))) INTO Other_Work_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Start_Time'))) INTO Other_Start_Time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_End_Time'))) INTO Other_End_Time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Total_Hrs'))) INTO Other_Total_Hrs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Rate'))) INTO Other_Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Other_Total'))) INTO Other_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Attendance_Details,CONCAT('$[',i,'].Total'))) INTO Total_;
        
        update Attendance_Details set Employee_Id=Employee_Id_,Employee_OutDate=Employee_OutDate_,Employee_OutTime=check_out_time_,
        Normal_Hrs=Normal_Hrs_,Normal_Rate=Normal_Rate_,Normal_Total=Normal_Total_,
        Ot_Hrs=Ot_Hrs_,Ot_Rate=Ot_Rate_,Ot_Total=Ot_Total_,
        Loading_Hrs=Loading_Hrs_,Loading_Rate=Loading_Rate_,Loading_Total=Loading_Total_,
        No_Of_Piece=No_Of_Piece_,Piece_Rate=Piece_Rate_,Piece_Total=Piece_Total_,
        Punch_Status=1,Other_Work=Other_Work_,Other_Start_Time=Other_Start_Time_,Other_End_Time=Other_End_Time_,
        Other_Total_Hrs=Other_Total_Hrs_,Other_Rate=Other_Rate_,Other_Total=Other_Total_,Total=Total_
        where Attendance_Details_Id=Attendance_Details_Id_;
		SELECT i + 1 INTO i;
	END WHILE;
#COMMIT;
select Attendance_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Client_Accounts`( In Client_Accounts_Id_ decimal,Account_Group_Id_ decimal,Client_Accounts_Code_ varchar(50),Client_Accounts_Name_ varchar(500),
User_Name_ varchar(50),Password_ varchar(50),Address1_ varchar(250),Address2_ varchar(250),Address3_ varchar(250),Address4_ varchar(250),PinCode_ varchar(50),StateCode_ varchar(50),GSTNo_ varchar(50) ,PanNo_ varchar(50),State_ varchar(1000),
Country_ varchar(1000),Phone_ varchar(50),Mobile_ varchar(50),Email_ varchar(200),Opening_Balance_ decimal,Description1_ varchar(1000),UserId_ decimal,Opening_Type_ int,Reference_Number_ int)
Begin 
declare Entry_Date_ datetime;declare Duplicate_Id int;declare Duplicate_Mobile_Id int;
set Entry_Date_=(SELECT CURRENT_DATE());
if  Client_Accounts_Id_>0 THEN 
	Set Duplicate_Id = (select Client_Accounts_Id from Client_Accounts where Client_Accounts_Id != Client_Accounts_Id_
	and Client_Accounts_Name=Client_Accounts_Name_ and DeleteStatus=0 limit 1);
    Set Duplicate_Mobile_Id = (select Client_Accounts_Id from Client_Accounts where Client_Accounts_Id != Client_Accounts_Id_
	and  (Phone like concat('%',Mobile_,'%') or Mobile like concat('%',Mobile_,'%') ) and DeleteStatus=0 limit 1);
	if(Duplicate_Id>0) then
		SET Client_Accounts_Id_ = -1;
	elseif(Duplicate_Mobile_Id>0) then  
		SET Client_Accounts_Id_ = -2;
	else 
		UPDATE Client_Accounts set Account_Group_Id = Account_Group_Id_ ,Client_Accounts_Code = Client_Accounts_Code_ ,Client_Accounts_Name = Client_Accounts_Name_ ,Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_ ,
		Address4 = Address4_ ,PinCode = PinCode_ ,StateCode=StateCode_,GSTNo =GSTNo_,PanNo =PanNo_,State = State_ ,Country = Country_ ,Phone = Phone_ ,Mobile = Mobile_ ,Email = Email_ ,Opening_Balance = Opening_Balance_ ,
		Description1 = Description1_ ,Reference_Number=Reference_Number_,Entry_Date = Entry_Date_ ,UserId = UserId_ ,Opening_Type=Opening_Type_ ,User_Name=User_Name_, Password=Password_ Where Client_Accounts_Id=Client_Accounts_Id_ ;
		end if;
ELSE 
	Set Duplicate_Id = (select Client_Accounts_Id from Client_Accounts where Client_Accounts_Name=Client_Accounts_Name_ and DeleteStatus=0 limit 1);
	  Set Duplicate_Mobile_Id = (select Client_Accounts_Id from Client_Accounts where  (Phone like concat('%',Mobile_,'%') or Mobile like concat('%',Mobile_,'%') ) and DeleteStatus=0 limit 1);
	
    if(Duplicate_Id>0) then
		SET Client_Accounts_Id_ = -1;  
	elseif(Duplicate_Mobile_Id>0) then  
		SET Client_Accounts_Id_ = -2;
	else 
		#SET Client_Accounts_Id_ = (SELECT  COALESCE( MAX(Client_Accounts_Id ),0)+1 FROM Client_Accounts); 
		INSERT INTO Client_Accounts(Client_Accounts_Id ,Account_Group_Id ,Client_Accounts_Code ,Client_Accounts_Name ,User_Name,Password,Address1 ,Address2 ,Address3 ,Address4 ,PinCode ,StateCode,GSTNo,PanNo, State ,Country ,Phone ,Mobile ,Email ,
		Opening_Balance ,Description1 ,Entry_Date ,UserId ,LedgerInclude ,CanDelete ,Commision ,Opening_Type,Reference_Number,DeleteStatus ) 
		values (Client_Accounts_Id_ ,Account_Group_Id_ ,Client_Accounts_Code_ ,Client_Accounts_Name_ ,User_Name_,Password_,Address1_ ,Address2_ ,Address3_ ,Address4_ ,PinCode_ ,StateCode_,GSTNo_,PanNo_, State_ ,Country_ ,Phone_ ,Mobile_ ,Email_ ,Opening_Balance_ ,
		Description1_ ,now() ,UserId_ ,'Y' ,'Y' ,0 ,Opening_Type_,Reference_Number_,false);
		set Client_Accounts_Id_=(SELECT LAST_INSERT_ID());
	End If ;
End If ;
select Client_Accounts_Id_;
#insert into db_logs values(1,Client_Accounts_Name,1,1);
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Contra_Entry`( In Contra_Entry_Id_ decimal,
Date_ datetime,
From_Account_Id_ decimal,
Amount_ decimal,
To_Account_Id_ decimal,
PaymentMode_ decimal,
User_Id_ decimal,
Payment_Status_ int,
Description_ varchar(1000))
Begin 
declare Voucher_No_ decimal(18,0);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;
set YearFrom=(select Account_Years.YearFrom from Account_Years where  
Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
set YearTo=(select Account_Years.YearTo from Account_Years where 
Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
Date_Format(Account_Years.YearTo,'%Y-%m-%d') and DeleteStatus=false);
if exists(select distinct Voucher_No from Contra_Entry)
then
set Voucher_No_=(SELECT COALESCE( MAX(Voucher_No ),0)+1 FROM Contra_Entry where 
Date_Format(Date,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and Date_Format(YearTo,'%Y-%m-%d'));  
else 
	if exists(select Contra_Voucher_No from General_Settings)
	then
set Voucher_No_=(select COALESCE(Contra_Voucher_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;   
    
end if;
 if  Contra_Entry_Id_>0
 THEN 
  set Voucher_No_=(select Voucher_No from Contra_Entry Where Contra_Entry_Id=Contra_Entry_Id_) ;
 DELETE FROM Accounts WHERE Tran_Type='CE' AND Tran_Id=Contra_Entry_Id_;
 UPDATE Contra_Entry set Date = Date_ ,Voucher_No = Voucher_No_ ,From_Account_Id = From_Account_Id_ ,
	Amount = Amount_ ,To_Account_Id = To_Account_Id_ ,PaymentMode = PaymentMode_ ,
	User_Id = User_Id_,Payment_Status=Payment_Status_ ,Description=Description_ Where Contra_Entry_Id=Contra_Entry_Id_ ;
 ELSE 
 SET Contra_Entry_Id_ = (SELECT  COALESCE( MAX(Contra_Entry_Id ),0)+1 FROM Contra_Entry); 
 INSERT INTO Contra_Entry(Contra_Entry_Id ,Date ,Voucher_No ,From_Account_Id ,Amount ,To_Account_Id ,
	PaymentMode ,User_Id ,Payment_Status,Description,DeleteStatus ) 
values (Contra_Entry_Id_ ,Date_ ,Voucher_No_ ,From_Account_Id_ ,Amount_ ,To_Account_Id_ ,PaymentMode_ ,
	User_Id_ ,Payment_Status_,Description_,false);
 End If ; 
   set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
 insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
	VoucherType,Description1,Status,DayBook,Payment_Status)
  values(Accounts_Id_,Date_,From_Account_Id_,0,Amount_,To_Account_Id_,'CE',Contra_Entry_Id_,
  Voucher_No_,3,Description_,'','',Payment_Status_); 

set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
 insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
	VoucherType,Description1,Status,DayBook,Payment_Status) 
  values(Accounts_Id_,Date_,To_Account_Id_,Amount_,0,From_Account_Id_,'CE',Contra_Entry_Id_,Voucher_No_ ,3,Description_,'','Y',Payment_Status_); 
    
 select Contra_Entry_Id_,Voucher_No_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Damaged_Item`( IN Damaged_Item_Id_ int,
Item_Id_ int, Product_Code_ varchar(50),Qty_ int, Rate_ int)
Begin 
  
 if  Damaged_Item_Id_>0
 THEN 
 UPDATE Damaged_Item set  Item_Id = Item_Id_ ,Product_Code = Product_Code ,
 Qty = Qty_ ,Rate = Rate_ 
 Where Damaged_Item_Id = Damaged_Item_Id_  ;
 ELSE 
 SET Damaged_Item_Id_ = (SELECT  COALESCE( MAX(Damaged_Item_Id ),0)+1 FROM Damaged_Item); 
 INSERT INTO Damaged_Item(Damaged_Item_Id ,Item_Id ,Product_Code ,Qty ,Rate,UserId ,DeleteStatus,Entry_Date )
 values (Damaged_Item_Id_  ,Item_Id_ ,Product_Code_ ,Qty_ ,Rate_,0,false,now());
 End If ; 
 select Damaged_Item_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Employee_Details`( IN Employee_Details_ JSON,
Client_Accounts_Id_ int)
Begin 
declare Employee_Details_Id_ int;Declare Level_Id_ int;Declare Client_Accounts_Id_JSON int;declare Working_Status_ int;
declare Designation_Id_ int;declare Process_Id_ int;declare DateOfBirth_ datetime;declare DateOfJoin_ datetime;
declare ReleiveDate_ datetime;declare Designation_ varchar(100);declare Ot_Rate_ int;declare Normal_Rate_ int;
declare Loading_Rate_ decimal(18,2);declare Adhar_Number_ varchar(100);declare Pan_Card_Number_ varchar(100);
declare Bank_Account_Details_ varchar(100);
 SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Employee_Details_Id')) INTO Employee_Details_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Client_Accounts_Id')) INTO Client_Accounts_Id_JSON;
	if (Client_Accounts_Id_JSON>0) then
		set Client_Accounts_Id_=Client_Accounts_Id_JSON;
	end if;
	SELECT JSON_UNQUOTE  (JSON_EXTRACT(Employee_Details_,'$.Working_Status')) INTO Working_Status_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Level_Id')) INTO Level_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Designation_Id')) INTO Designation_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Process_Id')) INTO Process_Id_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.DateOfBirth')) INTO DateOfBirth_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.DateOfJoin')) INTO DateOfJoin_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.ReleiveDate')) INTO ReleiveDate_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Designation')) INTO Designation_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Ot_Rate')) INTO Ot_Rate_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Normal_Rate')) INTO Normal_Rate_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Loading_Rate')) INTO Loading_Rate_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Adhar_Number')) INTO Adhar_Number_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Pan_Card_Number')) INTO Pan_Card_Number_;
	SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Details_,'$.Bank_Account_Details')) INTO Bank_Account_Details_;

 if  Employee_Details_Id_>0
 THEN 
 UPDATE Employee_Details set Client_Accounts_Id = Client_Accounts_Id_ ,Level_Id = Level_Id_ ,Designation_Id = Designation_Id_ ,
 DateOfBirth = DateOfBirth_ ,DateOfJoin = DateOfJoin_ ,ReleiveDate = ReleiveDate_ ,Working_Status = Working_Status_ ,Process_Id=Process_Id_ ,
 Designation=Designation_,Ot_Rate=Ot_Rate_,Normal_Rate=Normal_Rate_,Loading_Rate=Loading_Rate_,Bank_Account_Details=Bank_Account_Details_,
 Adhar_Number=Adhar_Number_,Pan_Card_Number=Pan_Card_Number_
 Where Employee_Details_Id=Employee_Details_Id_ ;
 ELSE 
 #SET Employee_Details_Id_ = (SELECT  COALESCE( MAX(Employee_Details_Id ),0)+1 FROM Employee_Details); 
 INSERT INTO Employee_Details(Employee_Details_Id ,Client_Accounts_Id ,Working_Status ,Level_Id ,Designation_Id,Process_Id ,DateOfBirth ,DateOfJoin ,ReleiveDate ,
 Designation,Ot_Rate,Normal_Rate,Loading_Rate,Adhar_Number,Pan_Card_Number,Bank_Account_Details,DeleteStatus )
 values (Employee_Details_Id_ ,Client_Accounts_Id_ ,Working_Status_,Level_Id_ ,Designation_Id_ ,Process_Id_ ,DateOfBirth_ ,DateOfJoin_ ,ReleiveDate_ ,
 Designation_,Ot_Rate_,Normal_Rate_,Loading_Rate_,Adhar_Number_,Pan_Card_Number_,Bank_Account_Details_,false);
 End If ;
 set Employee_Details_Id_ =(SELECT LAST_INSERT_ID());
 select Client_Accounts_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Employee_Master`(In Client_Accounts_ JSON,Employee_Details_ JSON)
BEGIN
 Declare Client_Accounts_Id_ int;Declare Account_Group_Id_ decimal ;Declare Client_Accounts_Code_ varchar(50) ; Declare Client_Accounts_Name_ varchar(500) ;
 Declare Address1_ varchar(250) ; Declare Address2_ varchar(250) ;Declare Address3_ varchar(250) ;Declare Address4_ varchar(250) ;
 Declare PinCode_ varchar(50) ;Declare StateCode_ varchar(50) ;Declare GSTNo_ varchar(50)  ;Declare PanNo_ varchar(50) ;
 Declare State_ varchar(1000) ;Declare Country_ varchar(1000) ;Declare Phone_ varchar(50) ;Declare Mobile_ varchar(50) ;
 Declare Email_ varchar(200) ;Declare Opening_Balance_ decimal ;Declare Description1_ varchar(1000) ;Declare UserId_ decimal ;Declare Opening_Type_ int ; 
 declare Reference_Number_ int; declare Duplicate_Id int;
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
    SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Client_Accounts_Id')) INTO Client_Accounts_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Account_Group_Id')) INTO Account_Group_Id_;
		SELECT JSON_UNQUOTE  (JSON_EXTRACT(Client_Accounts_, '$.Client_Accounts_Code')) INTO Client_Accounts_Code_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Client_Accounts_Name')) INTO Client_Accounts_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Address1')) INTO Address1_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Address2')) INTO Address2_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Address3')) INTO Address3_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Address4')) INTO Address4_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.PinCode')) INTO PinCode_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.StateCode')) INTO StateCode_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.GSTNo')) INTO GSTNo_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.PanNo')) INTO PanNo_;
    	SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.State')) INTO State_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Country')) INTO Country_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Phone')) INTO Phone_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Mobile')) INTO Mobile_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Email')) INTO Email_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Opening_Balance')) INTO Opening_Balance_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Description1')) INTO Description1_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.UserId')) INTO UserId_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Opening_Type')) INTO Opening_Type_;	
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Client_Accounts_, '$.Reference_Number')) INTO Reference_Number_;	
if(Client_Accounts_Id_>0)     then
Set Duplicate_Id = (select Client_Accounts_Id from Client_Accounts where Client_Accounts_Id != Client_Accounts_Id_  and Client_Accounts_Name =Client_Accounts_Name_ limit 1);
if(Duplicate_Id>0) then
SET Client_Accounts_Id_ = -1;  
else
		CALL Save_Client_Accounts(Client_Accounts_Id_, 2,Client_Accounts_Code_,Client_Accounts_Name_,'','',Address1_,Address2_,Address3_,Address4_,PinCode_,StateCode_, GSTNo_, PanNo_,  State_, Country_, 
        Phone_, Mobile_, Email_,Opening_Balance_, Description1_,UserId_,Opening_Type_,Reference_Number_);
end if;
else
Set Duplicate_Id = (select Client_Accounts_Id from Client_Accounts where  Client_Accounts_Name =Client_Accounts_Name_ 
and DeleteStatus=0 limit 1);
if(Duplicate_Id>0) then
SET Client_Accounts_Id_ = -1;  
else
CALL Save_Client_Accounts(Client_Accounts_Id_, 2,Client_Accounts_Code_,Client_Accounts_Name_,'','',Address1_,Address2_,Address3_,Address4_,PinCode_,StateCode_, GSTNo_, PanNo_,  State_, Country_, 
        Phone_, Mobile_, Email_,Opening_Balance_, Description1_,UserId_,Opening_Type_,Reference_Number_);
     if Client_Accounts_Id_=0 then
		set Client_Accounts_Id_=(SELECT LAST_INSERT_ID());
    end if;
end if;
end if; 
if(Client_Accounts_Id_>0) then
		Call Save_Employee_Details(Employee_Details_,Client_Accounts_Id_ );
end if;
 #Call Save_Employee_Location(Employee_Location_ ,Client_Accounts_Id_ );    
#commit;
    SELECT Client_Accounts_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Employee_Overtime_Master`( In Employee_Overtime_Master_Id_ int,Date_ Datetime,
Shift_Id_ int,User_Id_ int,Employee_Overtime_Details JSON)
BEGIN
	DECLARE Employee_Id_ int;DECLARE Start_Time_ varchar(100);DECLARE End_Time_ varchar(100);
   DECLARE Total_Hours_ decimal(18,2);DECLARE Rate_ decimal(18,2);DECLARE Total_ decimal(18,2);
   DECLARE Description_ varchar(4000);
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
	if  Employee_Overtime_Master_Id_>0
		THEN     
		delete from employee_overtime_details where Employee_Overtime_Master_Id=Employee_Overtime_Master_Id_;
		UPDATE employee_overtime_master set Date=Date_, Shift_Id=Shift_Id_, User_Id = User_Id_
        Where Employee_Overtime_Master_Id=Employee_Overtime_Master_Id_ ;
	ELSE 
		SET Employee_Overtime_Master_Id_ = (SELECT  COALESCE( MAX(Employee_Overtime_Master_Id ),0)+1 FROM employee_overtime_master); 
		INSERT INTO employee_overtime_master(Employee_Overtime_Master_Id,Date, Shift_Id,
        User_Id,DeleteStatus ) 
		values (Employee_Overtime_Master_Id_ ,Date_,Shift_Id_,
		User_Id_,false);           
	End If ;    
    WHILE i < JSON_LENGTH(Employee_Overtime_Details) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Overtime_Details,CONCAT('$[',i,'].Employee_Id'))) INTO Employee_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Overtime_Details,CONCAT('$[',i,'].Start_Time'))) INTO Start_Time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Overtime_Details,CONCAT('$[',i,'].End_Time'))) INTO End_Time_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Overtime_Details,CONCAT('$[',i,'].Total_Hours'))) INTO Total_Hours_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Overtime_Details,CONCAT('$[',i,'].Rate'))) INTO Rate_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Overtime_Details,CONCAT('$[',i,'].Total'))) INTO Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Employee_Overtime_Details,CONCAT('$[',i,'].Description'))) INTO Description_;
		INSERT INTO employee_overtime_details(Employee_Overtime_Master_Id,Employee_Id,Start_Time,End_Time ,
        Total_Hours,Rate,Total,Description,DeleteStatus ) 
		values (Employee_Overtime_Master_Id_  ,Employee_Id_ ,Start_Time_ ,End_Time_ ,
        Total_Hours_,Rate_,Total_,Description_,false);
		SELECT i + 1 INTO i;
	END WHILE;
#COMMIT;
select Employee_Overtime_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Finishedgoods_Purchase_Details`(In  FinishedGoods_Purchase_Details JSON,FinishedGoods_Purchase_Master_Id_ decimal(18,0))
Begin 

 Declare StockId_ int;Declare ItemId_ int; Declare Barcode_ varchar(50); Declare ItemName_ varchar(1000); 
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_CODE_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_  varchar(500);Declare SaleRate_ decimal(18,0);  Declare MRP_ decimal(18,0);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);
Declare Discount_ decimal(18,2);  Declare NetValue_ decimal(18,2);Declare CGST_ decimal(18,2); Declare CGST_AMT_ decimal(18,2); Declare SGST_ decimal(18,2); 
Declare SGST_AMT_ decimal(18,2); Declare IGST_ decimal(18,2); Declare IGST_AMT_ decimal(18,2); Declare GST_ decimal(18,2);Declare GST_Amount_ decimal(18,2);
Declare Total_Amount_ decimal(18,2);Declare Include_Tax_ decimal(18,2);  Declare WareHouse_Id_ int; Declare WareHouse_Name_ varchar(50); 
 Declare Is_Expiry_ varchar(100); Declare Expiry_Date_ datetime;DECLARE i int  DEFAULT 0;Declare TotalAmount_ decimal(18,2);
 
 #Declare Stock_Details_Id_ decimal(18,0);Declare GrossValue_ decimal(18,2);Declare isnull_ varchar(500);
	WHILE i < JSON_LENGTH(FinishedGoods_Purchase_Details) DO
    		SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].StockId'))) INTO StockId_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
            SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;      
            SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Description'))) INTO Description_;    
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].HSN_CODE'))) INTO HSN_CODE_;   
            SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].SaleRate'))) INTO SaleRate_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].MRP'))) INTO MRP_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_;            
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;   
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;   
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Discount'))) INTO Discount_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].NetValue'))) INTO NetValue_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].CGST_AMT'))) INTO CGST_AMT_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].SGST_AMT'))) INTO SGST_AMT_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].IGST_AMT'))) INTO IGST_AMT_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].GST_Amount'))) INTO GST_Amount_; 	
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Include_Tax'))) INTO Include_Tax_;  			
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Is_Expiry'))) INTO Is_Expiry_;         
              if(Is_Expiry_='true')
			   then 
			   set Is_Expiry_=1;
			   else set Is_Expiry_=0;
		   end if;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(FinishedGoods_Purchase_Details,CONCAT('$[',i,'].Expiry_Date'))) INTO Expiry_Date_;
       
set Barcode_=ifnull(Barcode_,0);
INSERT INTO FinishedGoods_Purchase_Details(FinishedGoods_Purchase_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,
WareHouse_Id,WareHouse_Name,MFCode,UPC,SaleRate,MRP,Unit_Price,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_Amount,TotalAmount,
Include_Tax,Is_Expiry,Expiry_Date,DeleteStatus ) 
values (FinishedGoods_Purchase_Master_Id_,StockId_,ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_,WareHouse_Id_,
WareHouse_Name_,MFCode_,UPC_,SaleRate_,MRP_,Unit_Price_,Quantity_,Amount_,Discount_,NetValue_,CGST_,CGST_AMT_,SGST_,SGST_AMT_,IGST_,IGST_AMT_,GST_,GST_Amount_,TotalAmount_,
Include_Tax_,Is_Expiry_,Expiry_Date_,false);
 		      
		SELECT i + 1 INTO i;
	END WHILE;  
 select FinishedGoods_Purchase_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Finishedgoods_Purchase_Order`( In FinishedGoods_Purchase_Master_Id_ int,Purchase_Type_Id_ int,Account_Party_Id_ decimal(18,0),Entry_Date_ datetime,
PurchaseDate_ datetime,InvoiceNo_ varchar(50),GrossTotal_ decimal(18,2),TotalDiscount_ decimal(18,2),NetTotal_  decimal(18,2),TotalCGST_ decimal(18,2),TotalSGST_ decimal(18,2),
TotalIGST_ decimal(18,2),TotalGST_ decimal(18,2),TotalAmount_ decimal(18,2),Discount_ decimal(18,2) ,Roundoff_ decimal(18,2),Grand_Total_ decimal(18,3),
Other_Charges_ decimal(18,2) ,BillType_ varchar(100),User_Id_ decimal(18,0),Description_ varchar(1000),FinishedGoods_Purchase_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;
declare Entry_Date_ datetime;declare Mode_ int;
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
set Entry_Date_=(SELECT CURRENT_DATE());
if  FinishedGoods_Purchase_Master_Id_>0  THEN 
  Delete From FinishedGoods_Purchase_Details Where FinishedGoods_Purchase_Master_Id=FinishedGoods_Purchase_Master_Id_;
  delete from Accounts where Tran_Id=FinishedGoods_Purchase_Master_Id_ and Tran_Type='PU';
UPDATE FinishedGoods_Purchase_Master set FinishedGoods_Purchase_Master_Id=FinishedGoods_Purchase_Master_Id_, Purchase_Type_Id=Purchase_Type_Id_,Account_Party_Id=Account_Party_Id_,Entry_Date=Entry_Date_,
PurchaseDate=PurchaseDate_,InvoiceNo = InvoiceNo_ ,GrossTotal=GrossTotal_,TotalDiscount=TotalDiscount_,NetTotal = NetTotal_ ,TotalCGST = TotalCGST_,TotalSGST=TotalSGST_,
TotalIGST=TotalIGST_,TotalGST=TotalGST_,TotalAmount=TotalAmount_,Discount=Discount_,Roundoff=Roundoff_,Grand_Total=Grand_Total_,Other_Charges=Other_Charges_,
BillType = BillType_ ,User_Id = User_Id_,Description=Description_
  Where FinishedGoods_Purchase_Master_Id=FinishedGoods_Purchase_Master_Id_ ;
ELSE 
	SET FinishedGoods_Purchase_Master_Id_ = (SELECT  COALESCE( MAX(FinishedGoods_Purchase_Master_Id ),0)+1 FROM FinishedGoods_Purchase_Master); 
INSERT INTO FinishedGoods_Purchase_Master(FinishedGoods_Purchase_Master_Id,Purchase_Type_Id,Account_Party_Id ,Entry_Date ,PurchaseDate ,InvoiceNo ,GrossTotal,TotalDiscount,NetTotal,TotalCGST ,
TotalSGST,TotalIGST,TotalGST ,TotalAmount,Discount,Roundoff,Grand_Total,Other_Charges,BillType ,User_Id ,Description,DeleteStatus) 
values (FinishedGoods_Purchase_Master_Id_,Purchase_Type_Id_,Account_Party_Id_ ,Entry_Date_ ,PurchaseDate_ ,InvoiceNo_ ,GrossTotal_,TotalDiscount_,NetTotal_,TotalCGST_,TotalSGST_,
TotalIGST_,TotalGST_,TotalAmount_,Discount_,Roundoff_,Grand_Total_,Other_Charges_,BillType_ ,User_Id_ ,Description_,false);
#delete from  db_logs;
#insert into db_logs values('',TotalGST_,1,1);
 
End If ;
  /*if FinishedGoods_Purchase_Master_Id_=0 then
			set FinishedGoods_Purchase_Master_Id_ =(SELECT LAST_INSERT_ID());
		end if;*/
        
        
 if(TotalAmount_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,Account_Party_Id_,0,TotalAmount_,6,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,6,TotalAmount_,0,Account_Party_Id_,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1); 
 end IF;
  if(TotalCGST_>0)
 then
	set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,6,0,TotalCGST_,25,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1); 
	set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,25,TotalCGST_,0,6,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1); 
 end IF;
 
  if(TotalSGST_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,6,0,TotalSGST_,18,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,18,TotalSGST_,0,6,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1); 
 end IF;
 
   if(TotalIGST_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,6,0,TotalIGST_,29,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,29,TotalIGST_,0,6,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_ ,5,Description_,'','',1); 
 end IF;
 
  /*if(Cess_>0)
 then
		set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
		VoucherType,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,6,0,Cess_,30,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_,5,Description_,'','Y',1); 
		set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
		VoucherType,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,30,Cess_,0,6,'PU',FinishedGoods_Purchase_Master_Id_, Voucher_No_ ,5,Description_,'','',1); 
 end IF;*/

   CALL Save_Finishedgoods_Purchase_Details(FinishedGoods_Purchase_Details ,FinishedGoods_Purchase_Master_Id_ );   
      
SELECT FinishedGoods_Purchase_Master_Id_,Voucher_No_;
#SELECT NetTotal_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Gate_Pass_Details`( In Gate_Pass_Details JSON,Gate_Pass_Master_Id_ int)
Begin 
DECLARE Item_Id_ int;DECLARE Item_Name_ varchar(1000);	DECLARE Quantity_ decimal(18,3);  
DECLARE Weight_ decimal(18,3);  DECLARE Total_Quantity_ decimal(18,3);  DECLARE Size_ varchar(100);  
DECLARE No_Of_Piece_ decimal(18,2);  DECLARE No_Of_Rejection_ decimal(18,2);  DECLARE No_Of_Return_ decimal(18,2);  
DECLARE i int  DEFAULT 0; 
	WHILE i < JSON_LENGTH(Gate_Pass_Details) DO	
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].Weight'))) INTO Weight_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].Total_Quantity'))) INTO Total_Quantity_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].Size'))) INTO Size_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].No_Of_Piece'))) INTO No_Of_Piece_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].No_Of_Rejection'))) INTO No_Of_Rejection_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_Details,CONCAT('$[',i,'].No_Of_Return'))) INTO No_Of_Return_;
		INSERT INTO gate_pass_details(Gate_Pass_Master_Id ,Item_Id ,Item_Name ,Quantity ,Weight,
        Total_Quantity,Size,No_Of_Piece,No_Of_Rejection,No_Of_Return,DeleteStatus ) 
		values (Gate_Pass_Master_Id_ ,Item_Id_ ,Item_Name_ ,Quantity_ ,Weight_,
        Total_Quantity_,Size_,No_Of_Piece_,No_Of_Rejection_,No_Of_Return_,false);
		SELECT i + 1 INTO i;
	END WHILE;
SELECT Gate_Pass_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Gate_Pass_In_Details`( In Gate_Pass_In_Details JSON,Gate_Pass_In_Master_Id_ int,Email_ varchar(100))
Begin 
DECLARE Item_Id_ int;DECLARE Item_Name_ varchar(1000);	DECLARE Quantity_ decimal(18,3);  
DECLARE Weight_ decimal(18,3);  DECLARE Total_Quantity_ decimal(18,3);  DECLARE Size_ varchar(100);  
DECLARE No_Of_Piece_ decimal(18,2);  DECLARE No_Of_Rejection_ decimal(18,2);  DECLARE No_Of_Return_ decimal(18,2);  
DECLARE i int  DEFAULT 0; 
		WHILE i < JSON_LENGTH(Gate_Pass_In_Details) DO	
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].Weight'))) INTO Weight_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].Total_Quantity'))) INTO Total_Quantity_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].Size'))) INTO Size_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].No_Of_Piece'))) INTO No_Of_Piece_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].No_Of_Rejection'))) INTO No_Of_Rejection_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Gate_Pass_In_Details,CONCAT('$[',i,'].No_Of_Return'))) INTO No_Of_Return_;
			INSERT INTO Gate_Pass_In_Details(Gate_Pass_In_Master_Id ,Item_Id ,Item_Name ,Quantity ,Weight,
			Total_Quantity,Size,No_Of_Piece,No_Of_Rejection,No_Of_Return,DeleteStatus ) 
			values (Gate_Pass_In_Master_Id_ ,Item_Id_ ,Item_Name_ ,Quantity_ ,Weight_,
			Total_Quantity_,Size_,No_Of_Piece_,No_Of_Rejection_,No_Of_Return_,false);
			SELECT i + 1 INTO i;
		END WHILE;

SELECT Gate_Pass_In_Master_Id_,Email_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Gate_Pass_In_Master`( In Gate_Pass_In_Master_Id_ int,Employee_Id_  int,Date_ datetime,
Vehicle_No_  Varchar(500),Pass_No_ int,  Pass_Type_ int,User_Id_ int,Description_ varchar(4000), 
Customer_Name_ varchar(500),Chellan_number_ varchar(100),Store_Number_ varchar(100),Invoice_Date_ datetime,
Invoice_Number_ varchar(100),Driver_Name_ varchar(100),Verified_By_ varchar(100),Company_Id_ int,
Arrival_Date_ datetime,Weighment_Slip_No_ varchar(100),Weighment_Quantity_ varchar(100),Gate_Pass_In_Details JSON)
Begin
declare pass_number_ int;declare Email_ varchar(100);
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
    
 if  Gate_Pass_In_Master_Id_>0 THEN
	Delete From Gate_Pass_In_Details Where Gate_Pass_In_Master_Id=Gate_Pass_In_Master_Id_;    
	UPDATE gate_pass_in_master set Employee_Id = Employee_Id_ ,Date=Date_, User_Id=User_Id_,
	Vehicle_No = Vehicle_No_ ,Pass_No=Pass_No_,Description=Description_,Customer_Name=Customer_Name_,
	Chellan_number = Chellan_number_ ,Store_Number=Store_Number_,Invoice_Date = Invoice_Date_ ,
	Invoice_Number=Invoice_Number_, Driver_Name=Driver_Name_,Verified_By=Verified_By_,
    Company_Id=Company_Id_,Arrival_Date=Arrival_Date_,Weighment_Slip_No=Weighment_Slip_No_,
    Weighment_Quantity=Weighment_Quantity_
	Where Gate_Pass_In_Master_Id=Gate_Pass_In_Master_Id_ ;
 ELSE
	SET Pass_No_ = (SELECT  COALESCE( MAX(Pass_No ),0)+1 FROM gate_pass_in_master where  DeleteStatus=false);
	SET Gate_Pass_In_Master_Id_ = (SELECT  COALESCE( MAX(Gate_Pass_In_Master_Id ),0)+1 FROM gate_pass_in_master);
	INSERT INTO gate_pass_in_master(Gate_Pass_In_Master_Id,Employee_Id,Date,Vehicle_No,Pass_No,User_Id,Description,
    Customer_Name,Chellan_number,Store_Number,Invoice_Date,Invoice_Number,Driver_Name,Verified_By,Company_Id,
    Arrival_Date,Weighment_Slip_No,Weighment_Quantity,DeleteStatus ) 
	values (Gate_Pass_In_Master_Id_,Employee_Id_,Date_,Vehicle_No_,Pass_No_,User_Id_,Description_,
    Customer_Name_,Chellan_number_,Store_Number_,Invoice_Date_,Invoice_Number_,Driver_Name_,Verified_By_,
    Company_Id_,Arrival_Date_,Weighment_Slip_No_,Weighment_Quantity_,False );
 End If ;
 set Email_=(select Email from client_accounts where Client_Accounts_Id=Employee_Id_ );
 
CALL Save_Gate_Pass_In_Details(Gate_Pass_In_Details ,Gate_Pass_In_Master_Id_,Email_ );
  
 select Gate_Pass_In_Master_Id_,Email_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Gate_Pass_Master`( In Gate_Pass_Master_Id_ int,Employee_Id_  int,Date_ datetime,
Vehicle_No_  Varchar(500),Pass_No_ int,  Pass_Type_ int,User_Id_ int,Description_ varchar(4000), 
Supplier_Name_ varchar(500),Invoice_Date_ datetime,Invoice_Number_ varchar(100),Remarks_ varchar(500),
Driver_Name_ varchar(100),Verified_By_ varchar(100),Eway_No_ varchar(100),Company_Id_ int,
Weighment_Slip_No_ varchar(100),Weighment_Quantity_ varchar(100),Gate_Pass_Details JSON)
Begin
declare pass_number_ int;
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
    
 if  Gate_Pass_Master_Id_>0
 THEN
	Delete From Gate_Pass_Details Where Gate_Pass_Master_Id=Gate_Pass_Master_Id_;    
		UPDATE Gate_Pass_Master set Employee_Id = Employee_Id_ ,Date=Date_, User_Id=User_Id_,
        Vehicle_No = Vehicle_No_ ,Pass_No=Pass_No_,Description=Description_,Supplier_Name=Supplier_Name_,
		Invoice_Date = Invoice_Date_ ,Invoice_Number=Invoice_Number_,Remarks=Remarks_,
        Driver_Name=Driver_Name_,Verified_By=Verified_By_,Eway_No=Eway_No_,Company_Id=Company_Id_,
        Weighment_Slip_No=Weighment_Slip_No_,
    Weighment_Quantity=Weighment_Quantity_
        Where Gate_Pass_Master_Id=Gate_Pass_Master_Id_ ;
 ELSE
		SET Pass_No_ = (SELECT  COALESCE( MAX(Pass_No ),0)+1 FROM Gate_Pass_Master where  DeleteStatus=false);
		SET Gate_Pass_Master_Id_ = (SELECT  COALESCE( MAX(Gate_Pass_Master_Id ),0)+1 FROM Gate_Pass_Master);
		INSERT INTO gate_pass_master(Gate_Pass_Master_Id,Employee_Id,Date,Vehicle_No,Pass_No,User_Id,Description,
        Supplier_Name,Invoice_Date,Invoice_Number,Remarks,Driver_Name,Verified_By,Eway_No,Company_Id,
        Weighment_Slip_No,Weighment_Quantity,DeleteStatus ) 
		values (Gate_Pass_Master_Id_,Employee_Id_,Date_,Vehicle_No_,Pass_No_,User_Id_,Description_,
        Supplier_Name_,Invoice_Date_,Invoice_Number_,Remarks_,Driver_Name_,Verified_By_,Eway_No_,Company_Id_,
        Weighment_Slip_No_,Weighment_Quantity_,False );
 End If ;
 
CALL Save_Gate_Pass_Details(Gate_Pass_Details ,Gate_Pass_Master_Id_ );
  
 select Gate_Pass_Master_Id_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_HSN`( In HSN_Id_ decimal,HSN_CODE_ varchar(50),CGST_ decimal(18,2),SGST_ decimal(18,2),IGST_ decimal(18,2),
GST_ decimal(18,2),Is_Check_ tinyint)
Begin 
declare Duplicate_Id int;
 if  HSN_Id_>0 THEN 
	Set Duplicate_Id = (select HSN_Id from HSN where HSN_Id != HSN_Id_ and HSN_CODE=HSN_CODE_ and DeleteStatus=0 limit 1);
if(Duplicate_Id>0) then
	SET HSN_Id_ = -1;  
else
	 UPDATE HSN set HSN_CODE = HSN_CODE_ ,CGST = CGST_ ,SGST = SGST_ ,IGST = IGST_ , GST=GST_
	 Where HSN_Id=HSN_Id_ ;
end if;
	 ELSE 
Set Duplicate_Id = (select HSN_Id from HSN where  HSN_CODE=HSN_CODE_ and DeleteStatus=0 limit 1);
if(Duplicate_Id>0) then
	SET HSN_Id_ = -1;  
else
	 SET HSN_Id_ = (SELECT  COALESCE( MAX(HSN_Id ),0)+1 FROM HSN); 
	 INSERT INTO HSN(HSN_Id ,HSN_CODE ,CGST ,SGST ,IGST, GST,DeleteStatus ) 
	 values (HSN_Id_ ,HSN_CODE_ ,CGST_ ,SGST_ ,IGST_,GST_ ,false);
 End If ;
 End If ;
 if(HSN_Id_ >0) then
if Is_Check_ = true then
	update Stock set  HSNCODE=HSN_CODE_,GST=GST_,CGST=CGST_,SGST=SGST_,IGST=IGST_ where HSNMasterId=HSN_Id_;
 end if;
  end if;
 select HSN_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Item`( In Item_Id_ int,Item_Name_ varchar(500),Group_Id_ int,Group_Name_ varchar(500),Unit_Id_ int,
Unit_Name_ varchar(500),HSN_Id_ int,Hsn_Code_ varchar(500),MFCode_ varchar(500),Weight_ int,Packing_Size_ varchar(500),Colour_ varchar(500),
UPC_ varchar(500),CGST_ decimal(18,2),SGST_  decimal(18,2),IGST_ decimal(18,2),GST_ decimal(18,2),CESS_ decimal(18,2),Batch_Weight_ int,
Quantity_Inshift_ decimal(18,2),Weight_Item_ decimal(18,2),Barcode_Item_ varchar(100),Product_Code_ varchar(100),Re_Order_Level_ decimal(18,3),
Process_Length_ int,Raw_Length_ int,Wastage_Length_ int,Process_List JSON,Raw_Materials JSON,Wasteage JSON)
Begin
#DECLARE Process_List_Id_ int;DECLARE Wastage_Id_ int;
    DECLARE Process_Id_ int; DECLARE Process_Time_ varchar(100);DECLARE Wasteage_Item_Stock_Id_ int; DECLARE Stock_Add_Status_ int;
    DECLARE Wasteage_Stock_Id_ int;DECLARE Quantitypers_ DECIMAL(18,2);Declare i int Default 0;declare Stock_Id_ int;
    DECLARE Raw_Material_Item_Stock_Id_ int;DECLARE Raw_Material_Stock_Id_ int; DECLARE Quantity_  DECIMAL(18,3);
    declare Raw_WareHouse_Id_ int;declare Raw_WareHouse_Name_ varchar(500); declare WareHouse_Id_ int;declare WareHouse_Name_ varchar(500);
    declare Wasteage_Item_Name_ varchar(500); declare Raw_Material_Item_Name_ varchar(500);declare Duplicate_Id int;declare Raw_Product_Code_ varchar(100);declare Wastage_Product_Code_ varchar(100);
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
    START TRANSACTION; */   
if  Item_Id_>0 THEN
	Set Duplicate_Id = (select Item_Id from item where Item_Id != Item_Id_ and Item_Name=Item_Name_ limit 1);
if(Duplicate_Id>0) then
	SET Item_Id_ = -1;  
else
	delete from Process_List where Item_Id=Item_Id_;
	delete from raw_material where Item_Id=Item_Id_;
	delete from wastage where Item_Id=Item_Id_;
	UPDATE item set Item_Id = Item_Id_ ,Item_Name = Item_Name_ ,Group_Id = Group_Id_ ,Group_Name = Group_Name_ ,
	Unit_Id = Unit_Id_,Unit_Name = Unit_Name_ ,HSN_Id = HSN_Id_ ,Hsn_Code = Hsn_Code_ ,MFCode = MFCode_ ,
	Weight = Weight_ ,Packing_Size = Packing_Size_ ,Colour = Colour_ ,UPC = UPC_  ,CGST = CGST_ ,SGST = SGST_ ,
	IGST = IGST_ ,GST = GST_ ,CESS = CESS_ ,Quantity_Inshift=Quantity_Inshift_,Batch_Weight=Batch_Weight_,
	Weight_Item=Weight_Item_,Barcode_Item=Barcode_Item_,Re_Order_Level=Re_Order_Level_,Product_Code=Product_Code_
	Where Item_Id = Item_Id_ ;
	if exists(select stock_Id from stock where DeleteStatus=False and ItemId = Item_Id_ and ItemName = Item_Name_) then
    set Stock_Id_=(select stock_Id from stock where DeleteStatus=False and ItemId = Item_Id_ and ItemName = Item_Name_ order by Stock_Id desc Limit 1 );
		Update stock set ItemName=Item_Name_,Packing_Size=Packing_Size_,Colour=Colour_,Weight=Weight_,
		Unit_Id=Unit_Id_,Unit_Name=Unit_Name_,Group_Id=Group_Id_,Group_Name=Group_Name_,HSN_Id=HSN_Id_,HSN_CODE=Hsn_Code_,
		MFCode=MFCode_,UPC=UPC_,CGST=CGST_,SGST=SGST_,GST=GST_,Barcode=Barcode_Item_,Product_Code=Product_Code_ Where Stock_Id = Stock_Id_ ;
	ELSE
		INSERT INTO stock(ItemId ,ItemName ,Barcode,Packing_Size,Colour ,Weight,Description,Unit_Id ,Unit_Name ,Group_Id ,Group_Name ,HSN_Id ,HSN_CODE ,
		MFCode,UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Is_Expiry,Expiry_Date,Product_Code,DeleteStatus)
		values (Item_Id_ ,Item_Name_ ,Barcode_Item_,Packing_Size_ ,Colour_ ,Weight_,'',Unit_Id_ ,Unit_Name_ ,Group_Id_ ,Group_Name_ ,HSN_Id_ ,Hsn_Code_ ,
		MFCode_ ,UPC_ ,0,0,0,CGST_ ,SGST_,IGST_,GST_ ,0,curdate(),Product_Code_,false);
	end if;
end if;
ELSE
Set Duplicate_Id = (select Item_Id from item where  Item_Name=Item_Name_ limit 1);
if(Duplicate_Id>0) then
	SET Item_Id_ = -1;  
else
	SET Item_Id_ = (SELECT  COALESCE( MAX(Item_Id ),0)+1 FROM item);
	INSERT INTO item(Item_Id ,Item_Name ,Group_Id ,Group_Name ,Unit_Id ,Unit_Name ,HSN_Id ,Hsn_Code ,
	MFCode ,Weight ,Packing_Size ,Colour ,UPC ,CGST ,SGST,IGST,GST ,CESS,Batch_Weight,Quantity_Inshift,
    Weight_Item,Barcode_Item,Product_Code,Re_Order_Level,DeleteStatus )
	values (Item_Id_ ,Item_Name_ ,Group_Id_ ,Group_Name_ ,Unit_Id_ ,Unit_Name_ ,HSN_Id_ ,Hsn_Code_ ,
	MFCode_ ,Weight_ ,Packing_Size_ ,Colour_ ,UPC_ ,CGST_ ,SGST_,IGST_,GST_ ,CESS_,Batch_Weight_,Quantity_Inshift_,
    Weight_Item_,Barcode_Item_,Product_Code_,Re_Order_Level_,false);
	INSERT INTO stock(ItemId ,ItemName ,Barcode,Packing_Size,Colour ,Weight,Description,Unit_Id ,Unit_Name ,Group_Id ,Group_Name ,HSN_Id ,HSN_CODE ,
	MFCode,UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Is_Expiry,Expiry_Date,DeleteStatus)
	values (Item_Id_ ,Item_Name_ ,Barcode_Item_,Packing_Size_ ,Colour_ ,Weight_,'',Unit_Id_ ,Unit_Name_ ,Group_Id_ ,Group_Name_ ,HSN_Id_ ,Hsn_Code_ ,
	MFCode_ ,UPC_ ,0,0,0,CGST_ ,SGST_,IGST_,GST_ ,0,curdate(),false);
End If ;
End If ;
if(Item_Id_>0) then
	if Process_Length_>0 then
		WHILE i < JSON_LENGTH(Process_List) DO
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Process_List,CONCAT('$[',i,'].Process_Id'))) INTO Process_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Process_List,CONCAT('$[',i,'].Process_Time'))) INTO Process_Time_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Process_List,CONCAT('$[',i,'].Stock_Add_Status'))) INTO Stock_Add_Status_;
			#SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Department,CONCAT('$[',i,']. Check_Box_VIew_All'))) INTO VIew_All_;
			#set VIew_All_1=VIew_All_;
			INSERT INTO Process_List(Item_Id,Process_Id,Process_Time,Stock_Add_Status,DeleteStatus )
			values (Item_Id_,Process_Id_,Process_Time_,Stock_Add_Status_,false);  
			SELECT i + 1 INTO i;
		END WHILE;  
	end if;
if Wastage_Length_>0 then
set i=0;
WHILE i < JSON_LENGTH(Wasteage) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Wasteage,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Wasteage_Item_Stock_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Wasteage,CONCAT('$[',i,'].Stock_Id'))) INTO Wasteage_Stock_Id_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Wasteage,CONCAT('$[',i,'].Item_Name'))) INTO Wasteage_Item_Name_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Wasteage,CONCAT('$[',i,'].Quantitypers'))) INTO Quantitypers_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Wasteage,CONCAT('$[',i,'].Product_Code'))) INTO Wastage_Product_Code_;/*
SELECT JSON_UNQUOTE (JSON_EXTRACT(Wasteage,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Wasteage,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;*/
INSERT INTO wastage(Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,WareHouse_Id,WareHouse_Name,Product_Code,DeleteStatus )
values (Item_Id_,Wasteage_Item_Stock_Id_,Wasteage_Item_Name_,Wasteage_Stock_Id_,Quantitypers_,WareHouse_Id_,WareHouse_Name_,Wastage_Product_Code_,false);
SELECT i + 1 INTO i;
END WHILE;  
   end if;
    if Raw_Length_>0 then
    set i=0;
    WHILE i < JSON_LENGTH(Raw_Materials) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Raw_Materials,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Raw_Material_Item_Stock_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Raw_Materials,CONCAT('$[',i,'].Stock_Id'))) INTO Raw_Material_Stock_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Raw_Materials,CONCAT('$[',i,'].Item_Name'))) INTO Raw_Material_Item_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Raw_Materials,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Raw_Materials,CONCAT('$[',i,'].Product_Code'))) INTO Raw_Product_Code_;/*
SELECT JSON_UNQUOTE (JSON_EXTRACT(Raw_Materials,CONCAT('$[',i,'].WareHouse_Id'))) INTO Raw_WareHouse_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Raw_Materials,CONCAT('$[',i,'].WareHouse_Name'))) INTO Raw_WareHouse_Name_;*/
INSERT INTO raw_material(Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantity,WareHouse_Id,WareHouse_Name,Product_Code,DeleteStatus )
values (Item_Id_,Raw_Material_Item_Stock_Id_,Raw_Material_Item_Name_,Raw_Material_Stock_Id_,Quantity_,Raw_WareHouse_Id_,Raw_WareHouse_Name_,Raw_Product_Code_,false);  
SELECT i + 1 INTO i;
END WHILE;
    end if;
    end if;
#COMMIT;
select Item_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Item_Group`( In Item_Group_Id_ decimal,
Item_Group_Code_ varchar(50),
Item_Group_Name_ varchar(100),
UnderGroupId_ decimal)
Begin 
declare Duplicate_Id int;
 if  Item_Group_Id_>0  THEN 
Set Duplicate_Id = (select Item_Group_Id from Item_Group where Item_Group_Id != Item_Group_Id_ 
and Item_Group_Name=Item_Group_Name_ and DeleteStatus=0 limit 1);
if(Duplicate_Id>0) then
	SET Item_Group_Id_ = -1;  
else
 UPDATE Item_Group set Item_Group_Id = Item_Group_Id_ ,
Item_Group_Code = Item_Group_Code_ ,
Item_Group_Name = Item_Group_Name_ ,
UnderGroupId = UnderGroupId_  Where Item_Group_Id=Item_Group_Id_ ;
end if;
 ELSE 
Set Duplicate_Id = (select Item_Group_Id from Item_Group where  Item_Group_Name=Item_Group_Name_ and DeleteStatus=0 limit 1);
if(Duplicate_Id>0) then
	SET Item_Group_Id_ = -1;  
else
 SET Item_Group_Id_ = (SELECT  COALESCE( MAX(Item_Group_Id ),0)+1 FROM Item_Group); 
 INSERT INTO Item_Group(Item_Group_Id ,
Item_Group_Code ,
Item_Group_Name ,
UnderGroupId ,
DeleteStatus ) values (Item_Group_Id_ ,
Item_Group_Code_ ,
Item_Group_Name_ ,
UnderGroupId_ ,
false);
 End If ;
 End If ;
 select Item_Group_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Journal_Entry`( In Journal_Entry_Id_ decimal,
Date_ datetime,
From_Account_Id_ decimal,
Amount_ decimal,
To_Account_Id_ decimal,
PaymentMode_ decimal,
User_Id_ decimal,
Payment_Status_ int,
Description_ varchar(1000))
Begin 
declare Voucher_No_ decimal(18,0);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;
set YearFrom=(select Account_Years.YearFrom from Account_Years where  
Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
set YearTo=(select Account_Years.YearTo from Account_Years where 
Date_Format(Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
if exists(select distinct Voucher_No from Journal_Entry)
then
set Voucher_No_=(SELECT COALESCE( MAX(Voucher_No ),0)+1 FROM Journal_Entry where 
Date_Format(Date,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and
 Date_Format(YearTo,'%Y-%m-%d')and DeleteStatus=false);  
else 
	if exists(select Journal_Voucher_No from General_Settings)
	then
set Voucher_No_=(select COALESCE(Journal_Voucher_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;   
end if;
 if  Journal_Entry_Id_>0
 THEN 
 set Voucher_No_=(select Voucher_No from Journal_Entry Where Journal_Entry_Id=Journal_Entry_Id_);
 DELETE FROM Accounts WHERE Tran_Type='JE' AND Tran_Id=Journal_Entry_Id_;
 UPDATE Journal_Entry set Date = Date_ , From_Account_Id = From_Account_Id_ ,
	Amount = Amount_ ,To_Account_Id = To_Account_Id_ ,PaymentMode = PaymentMode_ ,
	User_Id = User_Id_,Payment_Status=Payment_Status_,Description=Description_  Where Journal_Entry_Id=Journal_Entry_Id_ ;
 ELSE 
 SET Journal_Entry_Id_ = (SELECT  COALESCE( MAX(Journal_Entry_Id ),0)+1 FROM Journal_Entry); 
 INSERT INTO Journal_Entry(Journal_Entry_Id ,Date ,Voucher_No ,From_Account_Id ,Amount ,To_Account_Id ,
PaymentMode ,User_Id ,Payment_Status,Description,DeleteStatus ) 
values (Journal_Entry_Id_ ,Date_ ,Voucher_No_ ,From_Account_Id_ ,Amount_ ,To_Account_Id_ ,PaymentMode_ ,
User_Id_ ,Payment_Status_,Description_,false);
 End If ; 
  set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
 insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
 VoucherType,Description1,Status,DayBook,Payment_Status)
  values(Accounts_Id_,Date_,To_Account_Id_,0,Amount_,From_Account_Id_,'JE',Journal_Entry_Id_,
 Voucher_No_,4,Description_,'','Y',Payment_Status_); 
 
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
 insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
 VoucherType,Description1,Status,DayBook,Payment_Status) 
  values(Accounts_Id_,Date_,From_Account_Id_,Amount_,0,To_Account_Id_,'JE',Journal_Entry_Id_,
 Voucher_No_ ,4,Description_,'','',Payment_Status_); 
 select Journal_Entry_Id_,Voucher_No_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Packing`( In Packing_Master_Id_ int,Shift_Start_Master_Id_ int,Production_Master_Id_ int,Press_Details_Id_ int,Process_List_Id_ int,Shift_Details_Id_ int,
Date_ datetime,Production_No_ int,Packing_No_ varchar(100),Total_Items_Pallet_ varchar(100),Total_Pallet_Quantity_ decimal(18,2),Damage_ decimal(18,2),
Wastage_ decimal(18,2),User_Id_ int,Stock_Id_ int,Item_Id_ int,Item_Name_ varchar(500),Category_Id_ int,Category_Name_ varchar(100),WareHouse_Id_ int,WareHouse_Name_ varchar(500),Pallet_Id_ int,
Acceptable_Quantity_ int,Company_Id_ int,Purchase_Order_Master_Id_ int,Shift_Id_ int,Wastage_Length_ int,Packing_Details JSON,Packing_Details_Wastage_ JSON)
BEGIN
DECLARE Is_Employee_ varchar(25);DECLARE Employee_Id_ int;DECLARE Start_Time_ decimal(18,2);DECLARE End_Time_ decimal(18,2);
DECLARE Working_Hours_ decimal(18,2);DECLARE Ot_ decimal(18,2);DECLARE Loading_ decimal(18,2);DECLARE Normal_Rate_ decimal(18,2);
DECLARE Ot_Rate_ decimal(18,2);DECLARE Loading_Rate_ decimal(18,2);DECLARE Working_Total_ decimal(18,2);DECLARE Ot_Total_ decimal(18,2);
DECLARE Loading_Total_ decimal(18,2);declare Wastage_Id_ int;declare Item_Stock_Id_Wastage_ int;declare Item_Name_Wastage_ varchar(500);
declare Stock_Id_Wastage_ int;declare Stock_Add_Status_ int;DECLARE Quantitypers_ decimal(19,2);declare Warehouse_Id_Wastage_ int;
declare Warehouse_Name_Wastage_ varchar(500);declare Process_List_Id_Old_ int;declare Stock_Add_Status_Old_ int;
DECLARE Acceptable_Quantity_Old_ decimal(18,2);DECLARE Stock_Id_Old_ int;DECLARE WareHouse_Id_Old_ int;
declare Pallet_Id_Old int;Declare Stock_Id_Pallet int;declare Barcode_ int;declare Pack_Barcode_ int;declare Company_Id_Old_ int;declare Final_Barcode_ varchar(200);declare Company_Code_ varchar(100);
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
SELECT @p2 as MESSAGE_TEXT,@p1 as RETURNED_SQLSTATE;
ROLLBACK;
END;
START TRANSACTION; */
if  Packing_Master_Id_>0
THEN    
set Stock_Id_Old_=(select Stock_Id from Packing_master where  Packing_Master_Id=Packing_Master_Id_);
set WareHouse_Id_Old_=(select WareHouse_Id from Packing_master where  Packing_Master_Id=Packing_Master_Id_);
set Company_Id_Old_=(select Company_Id from Packing_master where  Packing_Master_Id=Packing_Master_Id_);

delete from Pallets_Stock where Packing_Master_Id=Packing_Master_Id_;
call Update_StockFrom_Packing(Packing_Master_Id_,Company_Id_);
set Acceptable_Quantity_Old_=(select Acceptable_Quantity from Packing_master where  Packing_Master_Id=Packing_Master_Id_);

/*set Process_List_Id_Old_=(select Process_List_Id from Packing_master where  Packing_Master_Id=Packing_Master_Id_);
set Stock_Add_Status_Old_=(select Stock_Add_Status from process_list where Item_Id=Item_Id_ and Process_Id=Process_List_Id_Old_ and DeleteStatus=false);
set Stock_Add_Status_=(select Stock_Add_Status from process_list where Item_Id=Item_Id_ and Process_Id=Process_List_Id_ and DeleteStatus=false);
set Pallet_Id_Old=(select Pallet_Id from Packing_master where  Packing_Master_Id=Packing_Master_Id_);
*/
if(Stock_Add_Status_Old_ =1 )then
update Stock_Details Set Quantity=Quantity-Acceptable_Quantity_Old_ where Stock_Id=Stock_Id_Old_ and WareHouse_Id = WareHouse_Id_Old_ and  Company_Id=Company_Id_Old_;    
#update Stock_Details Set Quantity=1111 where Stock_Id=Pallet_Id_Old and WareHouse_Id = WareHouse_Id_Old_;    
end if;
delete from Packing_details where Packing_Master_Id=Packing_Master_Id_;
delete from Packing_details_wastage where Packing_Master_Id=Packing_Master_Id_;
UPDATE Packing_master set Shift_Start_Master_Id=Shift_Start_Master_Id_,Production_Master_Id=Production_Master_Id_,Press_Details_Id = Press_Details_Id_ ,
Process_List_Id = Process_List_Id_ ,Shift_Details_Id = Shift_Details_Id_ ,Date = Date_ ,Production_No=Production_No_,Packing_No = Packing_No_ ,
Total_Items_Pallet = Total_Items_Pallet_ ,Total_Pallet_Quantity = Total_Pallet_Quantity_ ,Pallet_Id=Pallet_Id_,Damage = Damage_ ,Wastage = Wastage_ ,
User_Id = User_Id_,Stock_Id=Stock_Id_ , Item_Id=Item_Id_,Item_Name=Item_Name_,WareHouse_Id=WareHouse_Id_,WareHouse_Name=WareHouse_Name_ ,Category_Id=Category_Id_,Category_Name=Category_Name_,
Acceptable_Quantity=Acceptable_Quantity_,Company_Id=Company_Id_,Purchase_Order_Master_Id=Purchase_Order_Master_Id_ Where Packing_Master_Id=Packing_Master_Id_;

update stock Set Category_Id=Category_Id_,Category_Name=Category_Name_ where Stock_Id=Stock_Id_;

ELSE
SET Packing_Master_Id_ = (SELECT  COALESCE( MAX(Packing_Master_Id ),0)+1 FROM Packing_master);
SET Packing_No_ = (SELECT  COALESCE( MAX(Packing_No ),0)+1 FROM Packing_master); 

set Company_Code_= (SELECT Code FROM company where Company_Id=Company_Id_);
set Pack_Barcode_=(SELECT  COALESCE( MAX(Barcode ),0)+1 FROM  packing_master);
if (Pack_Barcode_=1) then
set Pack_Barcode_=(SELECT Barcode FROM General_Settings);
end if;
set Final_Barcode_ = concat(Company_Code_,Pack_Barcode_);

      
INSERT INTO Packing_master(Packing_Master_Id,Shift_Start_Master_Id, Production_Master_Id,Press_Details_Id, Process_List_Id,Shift_Details_Id, Date,
Production_No, Packing_No, Total_Items_Pallet,Total_Pallet_Quantity, Damage,Wastage, User_Id,Stock_Id,Item_Id,Item_Name,WareHouse_Id,WareHouse_Name,Pallet_Id,
 Master_Status,Acceptable_Quantity,Company_Id,Purchase_Order_Master_Id,Company_Code,Barcode_Digit,Barcode,Category_Id,Category_Name,DeleteStatus )
 
values (Packing_Master_Id_ ,Shift_Start_Master_Id_,Production_Master_Id_, Press_Details_Id_ , Process_List_Id_,Shift_Details_Id_ , Date_ , Production_No_ ,
Packing_No_,Total_Items_Pallet_,Total_Pallet_Quantity_,Damage_,Wastage_ ,User_Id_,Stock_Id_,Item_Id_,Item_Name_,WareHouse_Id_,WareHouse_Name_,Pallet_Id_,0,
Acceptable_Quantity_,Company_Id_,Purchase_Order_Master_Id_,Company_Code_,Pack_Barcode_,Final_Barcode_,Category_Id_,Category_Name_,false);      
update production_master set Packing_Master_Id=Packing_Master_Id_, Master_Status=1  where Production_Master_Id=Production_Master_Id_;
update purchase_order_master set Order_Status=20 where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;
update stock Set Category_Id=Category_Id_,Category_Name=Category_Name_ where Stock_Id=Stock_Id_;
#update shift_start_master set Master_Status=1, Packing_Master_Id=Packing_Master_Id_ where Shift_Start_Master_Id=Shift_Start_Master_Id_;        
Insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
Values(User_Id_,Date_,Packing_Master_Id_,'Packing',8,'',Purchase_Order_Master_Id_,False);        
End If ;
    if(Packing_Master_Id_>0)then
if(Shift_Id_>0) then
if exists(select distinct Stock_Details_Id from Stock_Details where Stock_Id = Stock_Id_ and WareHouse_Id = WareHouse_Id_
 and Company_Id=Company_Id_ )
then
update Stock_Details Set Quantity=Quantity+Acceptable_Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_
and Company_Id=Company_Id_ ;
else
INSERT INTO Stock_Details(Stock_Id ,WareHouse_Id ,Quantity ,Company_Id,DeleteStatus )
values (Stock_Id_ ,WareHouse_Id_ ,Acceptable_Quantity_ ,Company_Id_,false);
end if;
end if;  
WHILE i < JSON_LENGTH(Packing_Details) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Check_Box'))) INTO Is_Employee_;
if(Is_Employee_='true' or Is_Employee_=1) then
set Is_Employee_=1;
else
set Is_Employee_=0;
end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Employee_Id'))) INTO Employee_Id_;
/* SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Start_Time'))) INTO Start_Time_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].End_Time'))) INTO End_Time_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Working_Hours'))) INTO Working_Hours_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Ot'))) INTO Ot_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Loading'))) INTO Loading_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Normal_Rate'))) INTO Normal_Rate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Ot_Rate'))) INTO Ot_Rate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Loading_Rate'))) INTO Loading_Rate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Working_Total'))) INTO Working_Total_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Ot_Total'))) INTO Ot_Total_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details,CONCAT('$[',i,'].Loading_Total'))) INTO Loading_Total_;*/
INSERT INTO Packing_Details(Packing_Master_Id,Is_Employee,Employee_Id,Start_Time,End_Time ,Working_Hours,Ot,
        Loading,Normal_Rate,Ot_Rate,Loading_Rate,Working_Total,Ot_Total,Loading_Total,Description,DeleteStatus )
values (Packing_Master_Id_ ,Is_Employee_ ,Employee_Id_ ,Start_Time_ ,End_Time_ ,Working_Hours_,Ot_,
        Loading_,Normal_Rate_,Ot_Rate_,Loading_Rate_,Working_Total_,Ot_Total_,Loading_Total_,'',false);
    SELECT i + 1 INTO i;
END WHILE;
if Wastage_Length_>0 then
set i=0;
WHILE i < JSON_LENGTH(Packing_Details_Wastage_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details_Wastage_,CONCAT('$[',i,'].Wastage_Id'))) INTO Wastage_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details_Wastage_,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Item_Stock_Id_Wastage_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details_Wastage_,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_Wastage_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details_Wastage_,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_Wastage_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details_Wastage_,CONCAT('$[',i,'].Quantitypers'))) INTO Quantitypers_;        
/*SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details_Wastage_,CONCAT('$[',i,'].Warehouse_Id'))) INTO Warehouse_Id_Wastage_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Details_Wastage_,CONCAT('$[',i,'].Warehouse_Name'))) INTO Warehouse_Name_Wastage_;        
*/ INSERT INTO Packing_details_wastage(Packing_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Warehouse_Id,Warehouse_Name,DeleteStatus )
values (Packing_Master_Id_,Wastage_Id_,Item_Id_,Item_Stock_Id_Wastage_,Item_Name_Wastage_,Stock_Id_Wastage_,Quantitypers_,Warehouse_Id_Wastage_,Warehouse_Name_Wastage_,false);        
update Stock_Details Set Quantity=Quantity+Quantitypers_ where Stock_Id=Stock_Id_Wastage_
    and WareHouse_Id = WareHouse_Id_ and Company_Id=Company_Id_ ;          
SELECT i + 1 INTO i;
END WHILE;  
end if;
if(Total_Pallet_Quantity_>0)then
set i=0;
WHILE i < (Total_Pallet_Quantity_) DO
set Barcode_=(SELECT  COALESCE( MAX(Barcode ),0)+1 FROM General_Settings);
insert into pallets_stock values(0,Packing_Master_Id_,Packing_No_,Stock_Id_,WareHouse_Id_,Total_Pallet_Quantity_,Barcode_,Production_Master_Id_,Production_No_,Pallet_Id_,Company_Id_,false,1,'Pending');
update General_Settings set Barcode=Barcode_ ;
SELECT i + 1 INTO i;
END WHILE;  
end if;
/*update Stock_Details Set Stock_Details.Quantity=Stock_Details.Quantity-Total_Pallet_Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_;    
insert into Stock(ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Is_Expiry,Expiry_Date,Ref_Stock_Id,Ref_Quantity,DeleteStatus)
select ItemId,ItemName,Barcode_,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Is_Expiry,Expiry_Date,Stock_Id_,(Total_Items_Pallet_/Total_Pallet_Quantity_),DeleteStatus
from stock where Stock_Id=Pallet_Id_ ;
set Stock_Id_Pallet =(SELECT LAST_INSERT_ID());        
insert into stock_details values(0,Stock_Id_Pallet,WareHouse_Id_,Acceptable_Quantity_,false);
insert into Packing_Stock values(0,Packing_Master_Id_,Stock_Id_Pallet,false);
*/    
    end if;
#COMMIT;
select Packing_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Packing_Plan_Details`( In Packing_Plan_Details JSON,Packing_Plan_Master_Id_ int,Company_Id_ int)
Begin 
    DECLARE Item_Id_ decimal(18,0);DECLARE Item_Name_ varchar(5000);declare Stock_Id_ int;
	DECLARE Quantity_  decimal(18,2);  DECLARE Warehouse_Id_ decimal(18,0);DECLARE Warehouse_Name_ varchar(45);
 	DECLARE i int  DEFAULT 0;
	WHILE i < JSON_LENGTH(Packing_Plan_Details) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Plan_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Plan_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Plan_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Plan_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Plan_Details,CONCAT('$[',i,'].Warehouse_Id'))) INTO Warehouse_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Packing_Plan_Details,CONCAT('$[',i,'].Warehouse_Name'))) INTO Warehouse_Name_;
		
		INSERT INTO Packing_Plan_Details(Packing_Plan_Master_Id ,Item_Id ,Item_Name ,Quantity,Stock_Id,Warehouse_Id,Warehouse_Name,DeleteStatus ) 
		values (Packing_Plan_Master_Id_ ,Item_Id_ ,Item_Name_ ,Quantity_ ,Stock_Id_,Warehouse_Id_,Warehouse_Name_,false);

		update Stock_Details Set Quantity=Quantity-Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id=Warehouse_Id_ 
        and Company_Id=Company_Id_;
		SELECT i + 1 INTO i;
	END WHILE;  
SELECT Packing_Plan_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Packing_Plan_Master`( In Packing_Plan_Master_Id_ int,Date_ datetime,
User_Id_  int,Packing_Plan_No_ varchar(50),  Description_ varchar(4000), Porforma_Invoice_Master_Id_ int,
Company_Id_ int,Purchase_Order_Master_Id_ int,Packing_Plan_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;declare Place_Id_ int;
declare YearFrom datetime;declare YearTo datetime;declare billtypes_ varchar(100);
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
 if  Packing_Plan_Master_Id_>0
 THEN
 call Update_StockFrom_PackingPlan(Packing_Plan_Master_Id_,Company_Id_);
  Delete From packing_plan_details Where Packing_Plan_Master_Id=Packing_Plan_Master_Id_;  
 UPDATE packing_plan_master set Date = Date_ ,User_Id = User_Id_ ,Packing_Plan_No=Packing_Plan_No_,
 Porforma_Invoice_Master_Id=Porforma_Invoice_Master_Id_,Description=Description_,Company_Id=Company_Id_,Purchase_Order_Master_Id=Purchase_Order_Master_Id_
Where Packing_Plan_Master_Id=Packing_Plan_Master_Id ;
 ELSE
#SET Sales_Master_Id_ = (SELECT  COALESCE( MAX(Sales_Master_Id ),0)+1 FROM Sales_Master);
SET Packing_Plan_Master_Id_ = (SELECT  COALESCE( MAX(Packing_Plan_Master_Id ),0)+1 FROM Packing_Plan_Master);
SET Packing_Plan_No_ = (SELECT  COALESCE( MAX(Packing_Plan_No ),0)+1 FROM Packing_Plan_Master);
 INSERT INTO Packing_Plan_Master(Packing_Plan_Master_Id,Date,User_Id,Packing_Plan_No,Description,
 Porforma_Invoice_Master_Id,Company_Id,Purchase_Order_Master_Id,DeleteStatus )
values (Packing_Plan_Master_Id_,Date_,User_Id_,Packing_Plan_No_,Description_,Porforma_Invoice_Master_Id_,Company_Id_,Purchase_Order_Master_Id_,False );
        insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,Date_,Packing_Plan_Master_Id_,'Packing Plan',18,'',Purchase_Order_Master_Id_,False);
 End If ;
/*if Packing_Plan_Master_Id_=0 then
set Packing_Plan_Master_Id_ =(SELECT LAST_INSERT_ID());
end if;*/
CALL Save_Packing_Plan_Details(Packing_Plan_Details ,Packing_Plan_Master_Id_,Company_Id_);  
 select Packing_Plan_Master_Id_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Pallets_Received`(in Pallets_Master_Id_ int, Entry_Date_ datetime,User_Id_ int,
Production_Master_Id_ int, Production_No_ int,Stock_Id_ int, Item_Id_ int, Item_Name_ varchar(45),From_Warehouse_Id_ int,
From_Warehouse_Name_ varchar(45), Quantity_ int, To_Warehouse_Id_ int,To_Warehouse_Name_ varchar(45),
 Proforma_Invoice_Master_Id_ int,Reference_Field_ varchar(45), Pallet_Id_ int,Pallet_Name_ varchar(45),
 Available_Quantity_ decimal(18,0),Company_Id_ int,To_Company_Id_ int,Barcode_ varchar(200),Packing_Master_Id_ int)
BEGIN
declare  Purchase_Order_Master_Id_ int;
 if  Pallets_Master_Id_>0
 THEN
UPDATE Pallets_Master set Entry_Date = Entry_Date_ ,User_Id = User_Id_ ,Production_Master_Id = Production_Master_Id_ ,
Production_No = Production_No_ ,Item_Id = Item_Id_ ,Item_Name = Item_Name_ ,Company_Id=Company_Id_,To_Company_Id=To_Company_Id_,
From_Warehouse_Id = From_Warehouse_Id_,From_Warehouse_Name=From_Warehouse_Name_,Stock_Id=Stock_Id_,
    Quantity=Quantity_,To_Warehouse_Id=To_Warehouse_Id_,To_Warehouse_Name=To_Warehouse_Name_,
    Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_,Reference_Field=Reference_Field_,Pallet_Id=Pallet_Id_,
    Pallet_Name=Pallet_Name_,Available_Quantity=Available_Quantity_ ,Barcode=Barcode_,Packing_Master_Id=Packing_Master_Id_ where Pallets_Master_Id=Pallets_Master_Id_;    
  update Pallets_Stock set Warehouse_Id=To_Warehouse_Id_,Company_Id=To_Company_Id_ where Stock_Id=Stock_Id_
  and Warehouse_Id=From_Warehouse_Id_  and Pallet_Id=Pallet_Id_ and DeleteStatus=0;
 ELSE
 SET Pallets_Master_Id_ = (SELECT  COALESCE( MAX(Pallets_Master_Id ),0)+1 FROM Pallets_Master);
 insert into Pallets_Master(Pallets_Master_Id , Entry_Date ,User_Id , Production_Master_Id  ,Production_No  ,Stock_Id,Item_Id  ,Item_Name,
         From_Warehouse_Id , From_Warehouse_Name , Quantity  ,To_Warehouse_Id,To_Warehouse_Name,Proforma_Invoice_Master_Id,
         Reference_Field,Pallet_Id,Pallet_Name,Available_Quantity,Company_Id,To_Company_Id,Barcode,Status_Id,Status_Name,DeleteStatus,Packing_Master_Id )
values (Pallets_Master_Id_ , Entry_Date_ ,User_Id_ ,Production_Master_Id_ , Production_No_ ,Stock_Id_, Item_Id_ , Item_Name_ ,
         From_Warehouse_Id_ , From_Warehouse_Name_ , Quantity_ , To_Warehouse_Id_ , To_Warehouse_Name_ ,Proforma_Invoice_Master_Id_,
         Reference_Field_,Pallet_Id_,Pallet_Name_,Available_Quantity_,Company_Id_,To_Company_Id_,Barcode_,2,'Received',false,Packing_Master_Id_);
   # insert into db_logs values(Stock_Id_,From_Warehouse_Id_,Pallet_Id_,0)    ; 
  update Pallets_Stock set Warehouse_Id=To_Warehouse_Id_,Company_Id=To_Company_Id_,Status_Id=1,Status_Name='Pending'  where Stock_Id=Stock_Id_
  and Warehouse_Id=From_Warehouse_Id_  and Pallet_Id=Pallet_Id_ and DeleteStatus=0;
set Purchase_Order_Master_Id_=(select Purchase_Order_Master_Id from purchase_order_master where PONo=(select distinct PONo from
production_master where Production_Master_Id=Production_Master_Id_));
        insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,Entry_Date_,Pallets_Master_Id_,'Pallets Transfer',19,'',Purchase_Order_Master_Id_,False);
 End If ;
select Pallets_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Pallets_Transfer`(in Pallets_Master_Id_ int, Entry_Date_ datetime,User_Id_ int,
Production_Master_Id_ int, Production_No_ int,Stock_Id_ int, Item_Id_ int, Item_Name_ varchar(45),From_Warehouse_Id_ int,
From_Warehouse_Name_ varchar(45), Quantity_ int, To_Warehouse_Id_ int,To_Warehouse_Name_ varchar(45),
 Proforma_Invoice_Master_Id_ int,Reference_Field_ varchar(45), Pallet_Id_ int,Pallet_Name_ varchar(45),
 Available_Quantity_ decimal(18,0),Company_Id_ int,To_Company_Id_ int,Barcode_ varchar(200),Packing_Master_Id_ int)
BEGIN
declare  Purchase_Order_Master_Id_ int;
 if  Pallets_Master_Id_>0
 THEN
UPDATE Pallets_Master set Entry_Date = Entry_Date_ ,User_Id = User_Id_ ,Production_Master_Id = Production_Master_Id_ ,
Production_No = Production_No_ ,Item_Id = Item_Id_ ,Item_Name = Item_Name_ ,Company_Id=Company_Id_,To_Company_Id=To_Company_Id_,
From_Warehouse_Id = From_Warehouse_Id_,From_Warehouse_Name=From_Warehouse_Name_,Stock_Id=Stock_Id_,
    Quantity=Quantity_,To_Warehouse_Id=To_Warehouse_Id_,To_Warehouse_Name=To_Warehouse_Name_,
    Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_,Reference_Field=Reference_Field_,Pallet_Id=Pallet_Id_,
    Pallet_Name=Pallet_Name_,Available_Quantity=Available_Quantity_ ,Barcode=Barcode_,Packing_Master_Id=Packing_Master_Id_ where Pallets_Master_Id=Pallets_Master_Id_;    
  update Pallets_Stock set Warehouse_Id=To_Warehouse_Id_,Company_Id=To_Company_Id_ where Stock_Id=Stock_Id_
  and Warehouse_Id=From_Warehouse_Id_  and Pallet_Id=Pallet_Id_ and DeleteStatus=0;
 ELSE
 SET Pallets_Master_Id_ = (SELECT  COALESCE( MAX(Pallets_Master_Id ),0)+1 FROM Pallets_Master);
 insert into Pallets_Master(Pallets_Master_Id , Entry_Date ,User_Id , Production_Master_Id  ,Production_No  ,Stock_Id,Item_Id  ,Item_Name,
         From_Warehouse_Id , From_Warehouse_Name , Quantity  ,To_Warehouse_Id,To_Warehouse_Name,Proforma_Invoice_Master_Id,
         Reference_Field,Pallet_Id,Pallet_Name,Available_Quantity,Company_Id,To_Company_Id,Barcode,Status_Id,Status_Name,DeleteStatus,Packing_Master_Id )
values (Pallets_Master_Id_ , Entry_Date_ ,User_Id_ ,Production_Master_Id_ , Production_No_ ,Stock_Id_, Item_Id_ , Item_Name_ ,
         From_Warehouse_Id_ , From_Warehouse_Name_ , Quantity_ , To_Warehouse_Id_ , To_Warehouse_Name_ ,Proforma_Invoice_Master_Id_,
         Reference_Field_,Pallet_Id_,Pallet_Name_,Available_Quantity_,Company_Id_,To_Company_Id_,Barcode_,1,'Pending',false,Packing_Master_Id_);
   # insert into db_logs values(Stock_Id_,From_Warehouse_Id_,Pallet_Id_,0)    ; 
  update Pallets_Stock set Warehouse_Id=To_Warehouse_Id_,Company_Id=To_Company_Id_,Status_Id=1,Status_Name='Pending'  where Stock_Id=Stock_Id_
  and Warehouse_Id=From_Warehouse_Id_  and Pallet_Id=Pallet_Id_ and DeleteStatus=0;
set Purchase_Order_Master_Id_=(select Purchase_Order_Master_Id from purchase_order_master where PONo=(select distinct PONo from
production_master where Production_Master_Id=Production_Master_Id_));
        insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,Entry_Date_,Pallets_Master_Id_,'Pallets Transfer',19,'',Purchase_Order_Master_Id_,False);
 End If ;
select Pallets_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Press_Details`( In Press_Details_Id_ int,Press_Details_Name_ varchar(500),Status_ varchar(50),DeleteStatus_ tinyint)
Begin 
 if  Press_Details_Id_>0
 THEN 
 UPDATE press_details set Press_Details_Id = Press_Details_Id_ ,Press_Details_Name = Press_Details_Name_ ,Status=Status_
Where Press_Details_Id = Press_Details_Id_;
 ELSE 
 SET Press_Details_Id_ = (SELECT  COALESCE( MAX(Press_Details_Id ),0)+1 FROM press_details); 
 INSERT INTO press_details(Press_Details_Id,Press_Details_Name ,Status ,DeleteStatus ) 
 values (Press_Details_Id_ ,Press_Details_Name_ ,Status_ ,false);
 End If ;
 select Press_Details_Id_;
# insert into db_logs values(Email_,Status_,1,1);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Process_Details`( In Process_Details_Id_ int,Process_Details_Name_ varchar(500),Status_ varchar(500),DeleteStatus_ tinyint)
Begin 
 if  Process_Details_Id_>0
 THEN 
 UPDATE Process_Details set Process_Details_Id = Process_Details_Id_ ,Process_Details_Name = Process_Details_Name_ ,Status=Status_
Where Process_Details_Id = Process_Details_Id_;
 ELSE 
 SET Process_Details_Id_ = (SELECT  COALESCE( MAX(Process_Details_Id ),0)+1 FROM Process_Details); 
 INSERT INTO Process_Details(Process_Details_Id ,Process_Details_Name ,Status ,DeleteStatus ) 
 values (Process_Details_Id_ ,Process_Details_Name_ ,Status_ ,false);
 End If ;
 select Process_Details_Id_;
# insert into db_logs values(Email_,Status_,1,1);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Production`( In Production_Master_Id_ int,Proforma_Invoice_Master_Id_ int,Proforma_Invoice_Details_Id_ int,
Shift_End_Master_Id_ int,PONo_ varchar(100),Date_ Datetime,Production_No_ int,User_Id_ int,Stock_Id_ int,Item_Id_ int,Item_Name_ varchar(500),WareHouse_Id_ int,
WareHouse_Name_ varchar(500),Quantity_ decimal(18,3),Expected_Production_Date_ datetime,PInvoice_No_ int,Reference_Field_ varchar(100),Company_Id_ int,
Weight_ decimal(18,2),Batch_Weight_ decimal(18,2),Weight_Item_ decimal(18,2),Weight_Description_ varchar(4000),Average_Mat_Weight_ varchar(100),
Process_Length_ int,Raw_Length_ int,Wastage_Length_ int,Production_Status_ int,Purchase_Order_Master_Id_ int,
Production_Details_Process_ JSON,Production_Details_RawMaterial_ JSON,Production_Details_Wastage_ JSON)
Begin 
    DECLARE Process_List_Id_ int; DECLARE Process_Name_ varchar(100);DECLARE Process_Id_ int; DECLARE Raw_Material_Id_ int;	declare Item_Stock_Id_Raw_ int;
    DECLARE Stock_Id_Raw_ int;	declare No_Quantity_ decimal(18,3);DECLARE Weight_Quantity_ decimal(18,3);DECLARE Wastage_Id_ int; declare Item_Stock_Id_Wastage_ int; 
    DECLARE Stock_Id_Wastage_ int;DECLARE Quantitypers_ decimal(18,3);declare Total_Quantiry_ decimal(18,3);declare Production_status int; declare Item_Name_Raw_ varchar(500);
    declare Warehouse_Id_Raw_ int;declare Warehouse_Name_Raw_ varchar(500); declare Item_Name_Wastage_ varchar(500); declare Warehouse_Id_Wastage_ int; 
    declare Warehouse_Name_Wastage_ varchar(500);declare RawMaterial_StockId_ decimal(18,0);declare RawMaterial_WareHouse_Id_ decimal(18,0);declare RawMaterial_Quantity_ decimal(18,3);
    Declare i int Default 0;  declare fetch_status decimal(18,0);declare NewQty_ decimal(18,3);
	/*Declare Cur Cursor for select production_details_rawmaterial.Stock_Id,production_master.Warehouse_Id,
    round(production_details_rawmaterial.No_Quantity*production_master.Quantity,3)as Quantity
	from production_details_rawmaterial where production_details_rawmaterial.Production_Master_Id=Production_Master_Id_;*/
   /* DECLARE exit handler for sqlexception
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
    #insert into db_logs(id) values(Purchase_Order_Master_Id_);
	if  Production_Master_Id_>0
		THEN         
        set Production_status = (select count(Production_Master_Id)from production_master where DeleteStatus=0 
        and Master_Status=1 and Production_Master_Id=Production_Master_Id_);
		if(Production_status>0)then
			set Production_Master_Id_=-1 ;
		else 
			#call Update_Stock_FromProduction_Rawmaterial(Production_Master_Id_ );  
			delete from production_details_process where Production_Master_Id=Production_Master_Id_;
			delete from production_details_rawmaterial where Production_Master_Id=Production_Master_Id_;
			delete from production_details_wastage where Production_Master_Id=Production_Master_Id_;
			UPDATE production_master set Proforma_Invoice_Master_Id = Proforma_Invoice_Master_Id_,
            Proforma_Invoice_Details_Id = Proforma_Invoice_Details_Id_,	Shift_End_Master_Id=Shift_End_Master_Id_,
            Date = Date_,Expected_Production_Date=Expected_Production_Date_,Production_No = Production_No_,
            User_Id = User_Id_,Stock_Id = Stock_Id_,Item_Id = Item_Id_,Item_Name = Item_Name_,
            WareHouse_Id = WareHouse_Id_,WareHouse_Name = WareHouse_Name_,
            Quantity = Quantity_,Reference_Field=Reference_Field_,PInvoice_No=PInvoice_No_,Company_Id=Company_Id_,
            Batch_Weight=Batch_Weight_,Weight=Weight_,Weight_Item=Weight_Item_,
            Weight_Description=Weight_Description_,Average_Mat_Weight=Average_Mat_Weight_,Purchase_Order_Master_Id=Purchase_Order_Master_Id_
			Where Production_Master_Id = Production_Master_Id_ ;
        end if;
	ELSE 
		SET  Production_No_ = (SELECT  COALESCE( MAX(Production_No ),0)+1 FROM production_master); 
		SET Production_Master_Id_ = (SELECT  COALESCE( MAX(Production_Master_Id ),0)+1 FROM production_master); 
		INSERT INTO production_master(Production_Master_Id,Proforma_Invoice_Master_Id,Proforma_Invoice_Details_Id,Shift_End_Master_Id,Packing_Master_Id,
        PONo,Date,Production_No,User_Id,Stock_Id,Item_Id,Item_Name,WareHouse_Id,WareHouse_Name,Quantity,Production_Status,Master_Status,
        Expected_Production_Date,PInvoice_No,Reference_Field,Company_Id,Weight,Batch_Weight,Weight_Item,Weight_Description,Average_Mat_Weight,
        Purchase_Order_Master_Id,DeleteStatus) 
		values (Production_Master_Id_,Proforma_Invoice_Master_Id_,Proforma_Invoice_Details_Id,Shift_End_Master_Id_,0,PONo_,Date_,Production_No_,User_Id_,
        Stock_Id_,Item_Id_,Item_Name_,WareHouse_Id_ ,WareHouse_Name_ ,Quantity_,7,0,Expected_Production_Date_,PInvoice_No_,
        Reference_Field_,Company_Id_,Weight_,Batch_Weight_,Weight_Item_,Weight_Description_,Average_Mat_Weight_,Purchase_Order_Master_Id_,false);  		
		update Purchase_Order_Master set Order_Status= 7 where Purchase_Order_Master_Id=Purchase_Order_Master_Id_; 
		update Proforma_Invoice_Details set Master_Status=1,Production_Master_Id=Production_Master_Id_
		where Proforma_Invoice_Details_Id=Proforma_Invoice_Details_Id_;               
		update proforma_invoice_master set Master_Status=1,	Proforma_Status=7 where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;  
		insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
		values(User_Id_,Date_,Production_Master_Id_,'Production Start',6,'',Purchase_Order_Master_Id_,False);
	End If ;
if(Production_Master_Id_>0)then
	if Process_Length_>0 then
	WHILE i < JSON_LENGTH(Production_Details_Process_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Process_,CONCAT('$[',i,'].Process_List_Id'))) INTO Process_List_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Process_,CONCAT('$[',i,'].Process_Id'))) INTO Process_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Process_,CONCAT('$[',i,'].Process_Name'))) INTO Process_Name_;		
		#SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Department,CONCAT('$[',i,']. Check_Box_VIew_All'))) INTO VIew_All_;
		#set VIew_All_1=VIew_All_;
		INSERT INTO production_details_process(Production_Master_Id,Process_List_Id,Item_Id,Process_Id,Process_Name,DeleteStatus )
		values (Production_Master_Id_,Process_List_Id_,Item_Id_,Process_Id_,Process_Name_,false);               
		SELECT i + 1 INTO i;
	END WHILE;  
     end if;
    if Wastage_Length_>0 then
	set i=0;
	WHILE i < JSON_LENGTH(Production_Details_Wastage_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Wastage_,CONCAT('$[',i,'].Wastage_Id'))) INTO Wastage_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Wastage_,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Item_Stock_Id_Wastage_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Wastage_,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_Wastage_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Wastage_,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_Wastage_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Wastage_,CONCAT('$[',i,'].Quantitypers'))) INTO Quantitypers_;	     
         SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_Wastage_,CONCAT('$[',i,'].Total_Quantiry'))) INTO Total_Quantiry_;	  
		INSERT INTO production_details_wastage(Production_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Total_Quantiry,DeleteStatus )
		values (Production_Master_Id_,Wastage_Id_,Item_Id_,Item_Stock_Id_Wastage_,Item_Name_Wastage_,Stock_Id_Wastage_,Quantitypers_,Total_Quantiry_,false); 
		SELECT i + 1 INTO i;
	END WHILE;  
   end if;
    if Raw_Length_>0 then
    	set i=0;        
    WHILE i < JSON_LENGTH(Production_Details_RawMaterial_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_RawMaterial_,CONCAT('$[',i,'].Raw_Material_Id'))) INTO Raw_Material_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_RawMaterial_,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Item_Stock_Id_Raw_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_RawMaterial_,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_Raw_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_RawMaterial_,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_Raw_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_RawMaterial_,CONCAT('$[',i,'].No_Quantity'))) INTO No_Quantity_;	  
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_RawMaterial_,CONCAT('$[',i,'].Weight_Quantity'))) INTO Weight_Quantity_;/* 
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Production_Details_RawMaterial_,CONCAT('$[',i,'].Warehouse_Name'))) INTO Warehouse_Name_Raw_;     */
		INSERT INTO production_details_rawmaterial(Production_Master_Id,Raw_Material_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,No_Quantity,Warehouse_Id,Warehouse_Name,Weight_Quantity,DeleteStatus )
		values (Production_Master_Id_,Raw_Material_Id_,Item_Id_,Item_Stock_Id_Raw_,Item_Name_Raw_,Stock_Id_Raw_,No_Quantity_,Warehouse_Id_Raw_,Warehouse_Name_Raw_,Weight_Quantity_,false);  
		#set NewQty_=round((Quantity_*No_Quantity_),3);
      #  update Stock_Details Set Quantity=Quantity-NewQty_ where Stock_Id=Stock_Id_Raw_ and WareHouse_Id = WareHouse_Id_;
        SELECT i + 1 INTO i;
	END WHILE; 
    end if;
 end if; 
	#COMMIT;
	select Production_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Proforma_Invoice_Details`( In Proforma_Invoice_Details JSON,Proforma_Invoice_Master_Id_ int)
Begin 
	DECLARE Shipment_Details_Id_ int;  DECLARE Stock_Id_ int;DECLARE Item_Id_ decimal(18,0);DECLARE Item_Name_ varchar(1000);
	DECLARE Barcode_ VARCHAR(100);
    DECLARE Unit_Id_ int; DECLARE Unit_Name_ varchar(500);DECLARE Group_Id_ int; DECLARE Group_Name_ VARCHAR(500);
    DECLARE HSN_Id_ int; DECLARE HSN_CODE_ varchar(500);  DECLARE MRP_ decimal(18,2);DECLARE SaleRate_ decimal(18,2);
    DECLARE Quantity_ decimal(18,2);DECLARE Amount_ decimal(18,2);DECLARE Discount_ decimal(18,2);DECLARE NetValue_ decimal(18,2);
    DECLARE CGST_ decimal(18,2);DECLARE CGST_AMT_ decimal(18,2);DECLARE SGST_ decimal(18,2);DECLARE SGST_AMT_ decimal(18,2);
    DECLARE IGST_ decimal(18,2);DECLARE IGST_AMT_ decimal(18,2);DECLARE GST_ decimal(18,2);DECLARE GST_AMT_ decimal(18,2);
    DECLARE Cesspers_ decimal(18,2);DECLARE CessAMT_ decimal(18,2);DECLARE TotalAmount_ decimal(18,2); Declare Sales_Master_Id_ int;
    DECLARE Produced_Quantity_ decimal(18,2);declare Weight_ int;declare Description_ varchar(4000);
    
	#DECLARE PurchaseRate_ decimal(18,2);	DECLARE GrossValue_ decimal(18,2);    declare TaxAmount_ decimal(18,2);
    
	DECLARE i int  DEFAULT 0;
	WHILE i < JSON_LENGTH(Proforma_Invoice_Details) DO
    	SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Shipment_Details_Id'))) INTO Shipment_Details_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].HSN_CODE'))) INTO HSN_CODE_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].MRP'))) INTO MRP_;        
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].SaleRate'))) INTO SaleRate_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;  
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;    
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Discount'))) INTO Discount_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Netvalue'))) INTO NetValue_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_; 
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].CGST_AMT'))) INTO CGST_AMT_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;
	    SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].SGST_AMT'))) INTO SGST_AMT_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].IGST_AMT'))) INTO IGST_AMT_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].GST_AMT'))) INTO GST_AMT_;        
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Cesspers'))) INTO Cesspers_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].CessAMT'))) INTO CessAMT_;      		
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;        		
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Produced_Quantity'))) INTO Produced_Quantity_;  
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Weight'))) INTO Weight_;  
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Invoice_Details,CONCAT('$[',i,'].Description'))) INTO Description_;  
   
		INSERT INTO Proforma_Invoice_Details(Proforma_Invoice_Master_Id ,Shipment_Details_Id ,Production_Master_Id,Stock_Id,Item_Id ,Item_Name ,Barcode ,
        Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,MRP,SaleRate,Quantity,Amount,Discount,Netvalue,CGST,CGST_AMT,SGST,
        SGST_AMT,IGST,IGST_AMT,GST,GST_AMT,Cesspers,CessAMT,TotalAmount,Produced_Quantity,Master_Status,Weight,Description,DeleteStatus ) 
		values (Proforma_Invoice_Master_Id_ ,1 ,0,Stock_Id_,Item_Id_ ,Item_Name_ ,Barcode_ ,Unit_Id_,Unit_Name_,Group_Id_,
        Group_Name_,HSN_Id_,HSN_CODE_,MRP_,SaleRate_,Quantity_,Amount_,Discount_,NetValue_,CGST_,CGST_AMT_,SGST_,
        SGST_AMT_,IGST_,IGST_AMT_,GST_,GST_AMT_,Cesspers_,CessAMT_,TotalAmount_,0,0,Weight_,Description_,false);
        
		#update Stock_Details Set Quantity=Quantity-Quantity_ where Stock_Id=Stock_Id_;
		SELECT i + 1 INTO i;
	END WHILE;  
SELECT Proforma_Invoice_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Proforma_Invoice_Master`( In Proforma_Invoice_Master_Id_ int,Shipment_Master_Id_ int,Sales_Master_Id_ int,
Client_Accounts_Id_ int,Employee_Id_ int,Company_Id_ int,User_Id_ int,Entry_Date_ datetime,PONo_ varchar(100),PInvoice_No_ int,BillType_ int,
Gross_Total_ decimal(18,2),Total_Discount_ decimal(18,2),Net_Total_ decimal(18,2),TotalAmount_ decimal(18,2),Total_CGST_ decimal(18,2),
TotalSGST_ decimal(18,2),TotalIGST_ decimal(18,2),TotalGST_ decimal(18,2),Roundoff_ decimal(18,2),GrandTotal_ decimal(18,2),Payment_Status_ int,
Description_ varchar(4000),Proforma_Status_ int,Currency_ VARCHAR(100),Pallet_Weight_ int,Total_Weight_ int,Net_Weight_ int, Product_Name_ varchar(100),
Valid_Date_ datetime,Customer_Code_ varchar(100),Delivery_Term_ varchar(100),Delivery_Period_ varchar(100),Container_ varchar(100),Container_Id_ int,Payment_term_ varchar(100),
Bank_Id_ int,Currency_Rate_ decimal(18,2),PO_Date_ datetime,Purchase_Order_Master_Id_ int,Pack_Length_ int,Total_Packing_packages_ int,Total_Packing_ bigint,Packing_NetWeight_ decimal(18,2),
Packing_GrossWeight_ decimal(18,2),Expected_Date_ varchar(100), Proforma_Invoice_Details JSON,Proforma_Pack_List json)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;declare Place_Id_ int;declare Client_Accounts_Old_Id_ int;
declare YearFrom datetime;declare YearTo datetime;declare billtypes_ varchar(100); declare Production_Master_Status int;
Declare Order_Tracking_History_Id_ int;declare Reference_Number_ int;declare Reference_Field_ varchar(100);
DECLARE Stock_Id_ int;DECLARE Quantity_ int;DECLARE ItemId_ int;DECLARE ItemName_ varchar(100);declare Product_Code_ varchar(100);
DECLARE Weight_ int;DECLARE Total_Weight_1 int;DECLARE Description_1 varchar(4000);#declare Purchase_Order_Master_Id_ int;
declare Net_Weight_ decimal(18,2);declare Gross_Weight_ decimal(18,2);declare Size_ varchar(45);declare Package_No_ varchar(100);
declare No_Of_Pcs_ int;declare No_Of_Pckgs_ int;declare Total_ int;
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
set YearFrom=(select Account_Years.YearFrom from Account_Years where  
Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
set YearTo=(select Account_Years.YearTo from Account_Years where
Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
Date_Format(Account_Years.YearTo,'%Y-%m-%d'));  
if exists(select distinct PInvoice_No from proforma_invoice_master)
then
set Voucher_No_=(SELECT COALESCE( MAX(PInvoice_No ),0)+1 FROM proforma_invoice_master
where BillType=BillType_ and Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and Date_Format(YearTo,'%Y-%m-%d'));  
else
if exists(select Invoice_No from General_Settings)
then
set Voucher_No_=(select COALESCE(Invoice_No,0) from General_Settings);
else
set Voucher_No_=1;
end if;    
end if;  

 if Proforma_Invoice_Master_Id_>0
 THEN
 set billtypes_=( select BillType from proforma_invoice_master Where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_) ;
 if (billtypes_=BillType_ )then
 set Voucher_No_=( select PInvoice_No from proforma_invoice_master Where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_) ;
 end if;        
set Client_Accounts_Old_Id_=(select Client_Accounts_Id from proforma_invoice_master Where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);
if(Client_Accounts_Old_Id_<>Client_Accounts_Id_)then
set Reference_Number_=(SELECT COALESCE( MAX(Reference_Number ),0)+1 FROM proforma_invoice_master where Client_Accounts_Id=Client_Accounts_Id_);  
set Reference_Field_=concat(Customer_Code_,Reference_Number_);
else
set Reference_Field_=(select Reference_Field from proforma_invoice_master Where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);
set Reference_Number_=(SELECT Reference_Number FROM proforma_invoice_master where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);  
end if;
  set Production_Master_Status = (select count(Proforma_Invoice_Details_Id)from proforma_invoice_details where DeleteStatus=0 and Master_Status=1 and Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);
  if(Production_Master_Status>0)then
set Proforma_Invoice_Master_Id_=-1 ;
  else
delete from Proforma_Pack_List where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;
delete from proforma_invoice_details where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;
UPDATE proforma_invoice_master set Shipment_Master_Id=Shipment_Master_Id_,Sales_Master_Id=Sales_Master_Id_,Client_Accounts_Id=Client_Accounts_Id_,
        Employee_Id=Employee_Id_,Company_Id=Company_Id_,User_Id=User_Id_,Entry_Date=Entry_Date_,PONo=PONo_,PInvoice_No=Voucher_No_,BillType=BillType_,
        Gross_Total=Gross_Total_,Total_Discount=Total_Discount_,Net_Total=Net_Total_,TotalAmount=TotalAmount_,Total_CGST=Total_CGST_,TotalSGST=TotalSGST_,
        TotalIGST=TotalIGST_,TotalGST=TotalGST_,Roundoff=Roundoff_,GrandTotal=GrandTotal_,Payment_Status=Payment_Status_,Description=Description_,
        Proforma_Status=Proforma_Status_,Currency=Currency_,Pallet_Weight=Pallet_Weight_,Total_Weight=Total_Weight_,Net_Weight=Net_Weight_,
		Product_Name=Product_Name_,Valid_Date=Valid_Date_,Customer_Code=Customer_Code_,Delivery_Term=Delivery_Term_,Delivery_Period=Delivery_Period_,
        Container=Container_,Container_Id=Container_Id_,Payment_term=Payment_term_,Bank_Id=Bank_Id_,Reference_Number=Reference_Number_,Reference_Field=Reference_Field_,
        Purchase_Order_Master_Id=Purchase_Order_Master_Id_,Currency_Rate=Currency_Rate_,Total_Packing_packages=Total_Packing_packages_,Expected_Date=Expected_Date_,
    Total_Packing=Total_Packing_,Packing_NetWeight=Packing_NetWeight_,Packing_GrossWeight=Packing_GrossWeight_ Where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_ ;
  end if;
 ELSE
set Reference_Number_=(SELECT COALESCE( MAX(Reference_Number),0)+1 FROM proforma_invoice_master where Client_Accounts_Id=Client_Accounts_Id_);    
set Reference_Field_=concat(Customer_Code_,Reference_Number_);
    SET Proforma_Invoice_Master_Id_ = (SELECT  COALESCE( MAX(Proforma_Invoice_Master_Id),0)+1 FROM proforma_invoice_master);    
INSERT INTO proforma_invoice_master(Proforma_Invoice_Master_Id,Shipment_Master_Id,Sales_Master_Id,Client_Accounts_Id,Employee_Id,Company_Id,User_Id,
    Entry_Date,PONo,PInvoice_No, BillType,Gross_Total,Total_Discount,Net_Total, TotalAmount,Total_CGST,TotalSGST,TotalIGST,TotalGST,Roundoff,GrandTotal,
    Payment_Status,Description,Proforma_Status,Currency,Master_Status,Master_Status_Sale,Pallet_Weight,Total_Weight,Net_Weight,Product_Name,Valid_Date,
    Customer_Code ,Delivery_Term ,Delivery_Period ,Container ,Container_Id,Payment_term ,Bank_Id,Reference_Number,Reference_Field,Currency_Rate,PO_Date,Production_Status,
    Purchase_Order_Master_Id,Total_Packing_packages,Total_Packing,Packing_NetWeight,Packing_GrossWeight,Expected_Date,DeleteStatus)    
values (Proforma_Invoice_Master_Id_,Shipment_Master_Id_,0,Client_Accounts_Id_,Employee_Id_,Company_Id_,User_Id_,Entry_Date_,PONo_,Voucher_No_,BillType_,
    Gross_Total_,Total_Discount_,Net_Total_,TotalAmount_,Total_CGST_,TotalSGST_,0,TotalGST_,Roundoff_,GrandTotal_,4,Description_,3,Currency_,0,0,
    Pallet_Weight_,Total_Weight_,Net_Weight_,Product_Name_,Valid_Date_,Customer_Code_,Delivery_Term_,Delivery_Period_,Container_,Container_Id_,Payment_term_,Bank_Id_,
    Reference_Number_,Reference_Field_,Currency_Rate_,PO_Date_,0,Purchase_Order_Master_Id_,Total_Packing_packages_,Total_Packing_,Packing_NetWeight_,Packing_GrossWeight_,Expected_Date_,False );
UPDATE shipment_master set Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_, Master_Status=1 where Shipment_Master_Id=Shipment_Master_Id_;    
update Purchase_Order_Master set Order_Status=3 where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;
#(select Purchase_Order_Master_Id from Shipment_Master  where Shipment_Master_Id=Shipment_Master_Id_);
   insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
values(User_Id_,Entry_Date_,Proforma_Invoice_Master_Id_,'Proforma Invoice',3,'',Purchase_Order_Master_Id_,False);  
End If ;
  /*if Proforma_Invoice_Master_Id_=0 then
set Proforma_Invoice_Master_Id_ =(SELECT LAST_INSERT_ID());
end if;*/
if  Proforma_Invoice_Master_Id_>0  THEN
CALL Save_Proforma_Invoice_Details(Proforma_Invoice_Details ,Proforma_Invoice_Master_Id_); 
if Pack_Length_>0 then   
WHILE i < JSON_LENGTH(Proforma_Pack_List) DO
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Description'))) INTO Description_1;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Weight'))) INTO Weight_;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Total_Weight'))) INTO Total_Weight_1;
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;   

SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Package_No'))) INTO Package_No_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].No_Of_Pcs'))) INTO No_Of_Pcs_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].No_Of_Pckgs'))) INTO No_Of_Pckgs_; 
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Net_Weight'))) INTO Net_Weight_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Gross_Weight'))) INTO Gross_Weight_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Total'))) INTO Total_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Proforma_Pack_List,CONCAT('$[',i,'].Product_Code'))) INTO Product_Code_;
INSERT INTO Proforma_Pack_List(Proforma_Invoice_Master_Id  ,ItemId ,ItemName  ,Weight ,Description,
Package_No,
No_Of_Pckgs,
Total, 
Net_Weight,
Gross_Weight,No_Of_Pcs,Product_Code,
DeleteStatus )
values (Proforma_Invoice_Master_Id_  ,ItemId_ ,ItemName_  ,Weight_,Description_1,
Package_No_,
No_Of_Pckgs_,
Total_,
Net_Weight_,
Gross_Weight_,No_Of_Pcs_,Product_Code_,
false);
SELECT i + 1 INTO i;
        END WHILE;        
        end if;
end if;  
 select Proforma_Invoice_Master_Id_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Details`(In  Purchase_Details JSON,Purchase_Master_Id_ decimal(18,0),Company_Id_ int)
Begin
 Declare StockId_ int;Declare ItemId_ int; Declare Barcode_ varchar(50); Declare ItemName_ varchar(1000);
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_CODE_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_  varchar(500);Declare SaleRate_ decimal(18,0);  Declare MRP_ decimal(18,0);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);
Declare Discount_ decimal(18,2);  Declare NetValue_ decimal(18,2);Declare CGST_ decimal(18,2); Declare CGST_AMT_ decimal(18,2); Declare SGST_ decimal(18,2);
Declare SGST_AMT_ decimal(18,2); Declare IGST_ decimal(18,2); Declare IGST_AMT_ decimal(18,2); Declare GST_ decimal(18,2);Declare GST_Amount_ decimal(18,2);
Declare Total_Amount_ decimal(18,2);Declare Include_Tax_ decimal(18,2);  Declare WareHouse_Id_ int; Declare WareHouse_Name_ varchar(50);
Declare Is_Expiry_ varchar(100); Declare Expiry_Date_ datetime;DECLARE i int  DEFAULT 0;
Declare TotalAmount_ decimal(18,2);DECLARE Product_Code_ varchar(100);#declare GroupId_ int;
WHILE i < JSON_LENGTH(Purchase_Details) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].StockId'))) INTO StockId_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Product_Code'))) INTO Product_Code_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;      
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Description'))) INTO Description_;    
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].HSN_CODE'))) INTO HSN_CODE_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SaleRate'))) INTO SaleRate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].MRP'))) INTO MRP_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Discount'))) INTO Discount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].NetValue'))) INTO NetValue_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].CGST_AMT'))) INTO CGST_AMT_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SGST_AMT'))) INTO SGST_AMT_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].IGST_AMT'))) INTO IGST_AMT_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].GST_Amount'))) INTO GST_Amount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Include_Tax'))) INTO Include_Tax_;  
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Group_Id'))) INTO GroupId_; 
/*SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Is_Expiry'))) INTO Is_Expiry_;
        
 if(Is_Expiry_='true')
  then
  set Is_Expiry_=1;
  else set Is_Expiry_=0;
   end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Expiry_Date'))) INTO Expiry_Date_;      */
set Barcode_=ifnull(Barcode_,0);
#insert into Db_logs(Description,Description2,id) values(Barcode_,"",1);  
   
if exists(select Stock_Id from Stock where ItemId=ItemId_ and DeleteStatus=False)
then
set StockId_=(select Stock_Id from Stock where ItemId=ItemId_ and DeleteStatus=False order by Stock_Id desc Limit 1);                
update Stock set ItemId=ItemId_, BarCode=Barcode_, ItemName=ItemName_, Barcode=Barcode_,Group_Id=Group_Id_, Packing_Size=Packing_Size_,Colour=Colour_,
Description=Description_,Unit_Id=Unit_Id_,Unit_Name=Unit_Name_,Group_Name=Group_Name_,HSN_Id=HSN_Id_, HSN_CODE=HSN_CODE_,MFCode=MFCode_,UPC=UPC_,MRP=MRP_,
SaleRate=SaleRate_, PurchaseRate=Include_Tax_, CGST=CGST_, SGST=SGST_, IGST=IGST_, GST=GST_ ,Product_Code=Product_Code_               
where Stock_Id=StockId_;
else
insert into Stock(ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,MFCode,UPC,MRP,
SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Product_Code,DeleteStatus,Category_Id,Category_Name)
values(ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_,MFCode_,UPC_,MRP_,
SaleRate_,Include_Tax_,CGST_,SGST_,IGST_,GST_,Product_Code_,False,4,'First Sale');
set StockId_ =(SELECT LAST_INSERT_ID());
end if;            
INSERT INTO Purchase_Details(Purchase_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,
WareHouse_Id,WareHouse_Name,MFCode,UPC,SaleRate,MRP,Unit_Price,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_Amount,TotalAmount,
Include_Tax,Product_Code,DeleteStatus,Category_Id,Category_Name )
values (Purchase_Master_Id_,StockId_,ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_,WareHouse_Id_,
WareHouse_Name_,MFCode_,UPC_,SaleRate_,MRP_,Unit_Price_,Quantity_,Amount_,Discount_,NetValue_,CGST_,CGST_AMT_,SGST_,SGST_AMT_,IGST_,IGST_AMT_,GST_,GST_Amount_,TotalAmount_,
Include_Tax_,Product_Code_,false,4,'First Sale');
if exists(select Stock_Details_Id from Stock_Details where Stock_Id = StockId_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_)
then
update Stock_Details set Quantity = Quantity + Quantity_ where Stock_Id=StockId_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_;
else
INSERT INTO Stock_Details(Stock_Id ,WareHouse_Id ,Quantity ,Company_Id,DeleteStatus )
values (StockId_ ,WareHouse_Id_ ,Quantity_ ,Company_Id_,false);
end if;        
SELECT i + 1 INTO i;
END WHILE;  
 select Purchase_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Master`( In Purchase_Master_Id_ int,Purchase_Type_Id_ int,Account_Party_Id_ decimal(18,0),Entry_Date_ datetime,
PurchaseDate_ datetime,InvoiceNo_ varchar(50),GrossTotal_ decimal(18,2),TotalDiscount_ decimal(18,2),NetTotal_  decimal(18,2),TotalCGST_ decimal(18,2),TotalSGST_ decimal(18,2),
TotalIGST_ decimal(18,2),TotalGST_ decimal(18,2),TotalAmount_ decimal(18,2),Discount_ decimal(18,2) ,Roundoff_ decimal(18,2),Grand_Total_ decimal(18,3),
Other_Charges_ decimal(18,2) ,BillType_ int,User_Id_ decimal(18,0),Description_ varchar(1000),Company_Id_ int,Purchase_Details JSON,
Purchase_Master_Order_Id_ int,Group_Id_ INT)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;
declare Mode_ int;
DECLARe Duplicate_Purchase_Id int;
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

if  Purchase_Master_Id_>0  THEN
 SET Duplicate_Purchase_Id=(select Purchase_Master_Id from purchase_master where Purchase_Master_Id != Purchase_Master_Id_ and DeleteStatus=false and InvoiceNo =InvoiceNo_
AND Account_Party_Id=Account_Party_Id_ limit 1);
if Duplicate_Purchase_Id>0 then
set Purchase_Master_Id_=-1;
else
call Update_Stock_Purchase(Purchase_Master_Id_,Company_Id_);
  Delete From Purchase_Details Where Purchase_Master_Id=Purchase_Master_Id_;
  delete from Accounts where Tran_Id=Purchase_Master_Id_ and Tran_Type='PU';
UPDATE Purchase_Master set Purchase_Master_Id=Purchase_Master_Id_, Purchase_Type_Id=Purchase_Type_Id_,Account_Party_Id=Account_Party_Id_,Entry_Date=Entry_Date_,
PurchaseDate=PurchaseDate_,InvoiceNo = InvoiceNo_ ,GrossTotal=GrossTotal_,TotalDiscount=TotalDiscount_,NetTotal = NetTotal_ ,TotalCGST = TotalCGST_,TotalSGST=TotalSGST_,
TotalIGST=TotalIGST_,TotalGST=TotalGST_,TotalAmount=TotalAmount_,Discount=Discount_,Roundoff=Roundoff_,Grand_Total=Grand_Total_,Other_Charges=Other_Charges_,
BillType = BillType_ ,User_Id = User_Id_,Description=Description_,Company_Id=Company_Id_,
Purchase_Master_Order_Id=Purchase_Master_Order_Id_,Group_Id=Group_Id_
  Where Purchase_Master_Id=Purchase_Master_Id_ ;
  end if;
ELSE
 SET Duplicate_Purchase_Id=(select Purchase_Master_Id from purchase_master where  DeleteStatus=false and InvoiceNo =InvoiceNo_
AND Account_Party_Id=Account_Party_Id_ limit 1);
if Duplicate_Purchase_Id>0 then
set Purchase_Master_Id_=-1;
else
SET Purchase_Master_Id_ = (SELECT  COALESCE( MAX(Purchase_Master_Id ),0)+1 FROM Purchase_Master);
INSERT INTO Purchase_Master(Purchase_Master_Id,Purchase_Type_Id,Account_Party_Id ,Entry_Date ,PurchaseDate ,InvoiceNo ,GrossTotal,TotalDiscount,NetTotal,TotalCGST ,
TotalSGST,TotalIGST,TotalGST ,TotalAmount,Discount,Roundoff,Grand_Total,Other_Charges,BillType ,
User_Id ,Description,Company_Id,DeleteStatus,Purchase_Master_Order_Id,Group_Id )
values (Purchase_Master_Id_,Purchase_Type_Id_,Account_Party_Id_ ,Entry_Date_ ,PurchaseDate_ ,InvoiceNo_ ,GrossTotal_,TotalDiscount_,NetTotal_,TotalCGST_,TotalSGST_,
TotalIGST_,TotalGST_,TotalAmount_,Discount_,Roundoff_,Grand_Total_,Other_Charges_,BillType_ ,
User_Id_ ,Description_,Company_Id_,false,Purchase_Master_Order_Id_,Group_Id_);
#delete from  db_logs;
#insert into db_logs values('',TotalGST_,1,1);
 End If ;
End If ;
 /*if Purchase_Master_Id_=0 then
set Purchase_Master_Id_ =(SELECT LAST_INSERT_ID());
end if;*/      
 if(TotalAmount_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,Account_Party_Id_,0,TotalAmount_,6,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,TotalAmount_,0,Account_Party_Id_,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1);
 end IF;
  if(TotalCGST_>0)
 then
set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,TotalCGST_,25,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,25,TotalCGST_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1);
 end IF;
 
  if(TotalSGST_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,TotalSGST_,18,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,18,TotalSGST_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1);
 end IF;
 
   if(TotalIGST_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,TotalIGST_,29,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,29,TotalIGST_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Description_,'','',1);
 end IF; 
  /*if(Cess_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,Cess_,30,'PU',Purchase_Master_Id_, Voucher_No_,5,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,30,Cess_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Description_,'','',1);
 end IF;*/
CALL Save_Purchase_Details(Purchase_Details ,Purchase_Master_Id_ ,Company_Id_);       
SELECT Purchase_Master_Id_,Voucher_No_;
#SELECT NetTotal_;
#COMMIT;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Customer`( In Purchase_Order_Customer_Id_ int,Company_Id_ int,
User_Id_ int,Entry_Date_ datetime,Delivery_Date_ datetime,PONo_ varchar(100),Currency_ varchar(100),Shipment_Method_Id_ int,
Payment_Term_ varchar(500),Delivery_Port_ varchar(500),Shipmet_Plan_Id_ int,No_of_Shipment_ int,Description_ varchar(4000),
Order_Status_ int,TotalAmount_ decimal(18,2),Reference_Field_ varchar(100),Purchase_Order_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Description_Shipment_ varchar(4000);declare Accounts_Id_ decimal;declare YearFrom datetime;declare YearTo datetime;declare Mode_ int;
Declare Shipment_Details_Id_ int;Declare Shipment_Master_Id_ int; Declare Stock_Id_ int; Declare Item_Id_ int;Declare Item_Name_ varchar(500);
Declare Quantity_ decimal(18,2);Declare Status_ int; Declare Shipment_No_ int;Declare Shipment_Status_Id_ int;DECLARE i int  DEFAULT 0;declare Weight_ int;
DECLARE Shipment_Master_Id_Old_ int;DECLARE Shipment_Master_Id_temp_ int;declare Shipment_Master_Status int;declare Po_No_Master_ int  DEFAULT 0;
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
    START TRANSACTION;  */ 
	set YearFrom=(select Account_Years.YearFrom from Account_Years where  Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
	set YearTo=(select Account_Years.YearTo from Account_Years where Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
if(PONo_ = null   or   PONo_= "") then
if exists(select distinct PONo from Purchase_Order_Customer)
then
	if(PONo_ = null   or   PONo_ = "") then
		set PONo_=(SELECT COALESCE( MAX(Po_No_Master ),0)+1 FROM Purchase_Order_Customer
		where  Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and Date_Format(YearTo,'%Y-%m-%d'));  
        set Po_No_Master_=PONo_;
    end if;    
else 
	if exists(select PONo from General_Settings) then
		set PONo_=(select COALESCE(PONo,0) from General_Settings);
	else
		set PONo_=1;
	end if;    	
      set Po_No_Master_=PONo_;
end if;
end if;
set Entry_Date_=(SELECT CURRENT_DATE());
if  Purchase_Order_Customer_Id_>0  THEN 
/*set Shipment_Master_Status = (select count(Shipment_Master_Id)from Shipment_master where DeleteStatus=0 and Master_Status=1 and Purchase_Order_Customer_Id=Purchase_Order_Customer_Id_);
	if(Shipment_Master_Status>0)then
		set Purchase_Order_Customer_Id_=-1 ;
    else */
		Delete From purchase_order_customer_details Where Purchase_Order_Customer_Id=Purchase_Order_Customer_Id_;    
		UPDATE Purchase_Order_Customer set Purchase_Order_Customer_Id=Purchase_Order_Customer_Id_,User_Id=User_Id_,
		Entry_Date=Entry_Date_,PONo = PONo_ ,Currency=Currency_,Shipment_Method_Id=Shipment_Method_Id_,Delivery_Date=Delivery_Date_,
		Payment_Term = Payment_Term_,Delivery_Port=Delivery_Port_,Shipmet_Plan_Id=Shipmet_Plan_Id_,No_of_Shipment=No_of_Shipment_,
		Description=Description_,Order_Status=Order_Status_,TotalAmount=TotalAmount_,Reference_Field=Reference_Field_
	  Where Purchase_Order_Customer_Id=Purchase_Order_Customer_Id_ ;
     
ELSE 
	SET Purchase_Order_Customer_Id_ = (SELECT  COALESCE( MAX(Purchase_Order_Customer_Id ),0)+1 FROM Purchase_Order_Customer); 
	INSERT INTO Purchase_Order_Customer(Purchase_Order_Customer_Id,Purchase_Order_Master_Id,Company_Id ,User_Id,Entry_Date ,Delivery_Date,PONo  ,Currency ,Shipment_Method_Id,
	Payment_Term ,Delivery_Port,Shipmet_Plan_Id,No_of_Shipment,Description,Order_Status,TotalAmount,Master_Status,Po_No_Master,Reference_Field,DeleteStatus) 
	values (Purchase_Order_Customer_Id_,0,2 ,User_Id_,Entry_Date_ ,Delivery_Date_,PONo_  ,Currency_ ,Shipment_Method_Id_,
	Payment_Term_ ,Delivery_Port_,Shipmet_Plan_Id_,No_of_Shipment_,Description_,17,TotalAmount_,0,Po_No_Master_,Reference_Field_,false);
	/*insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,DeleteStatus)
	values(User_Id_,Entry_Date_,Purchase_Order_Master_Id_,'Purchase Order',1,'',false);*/
End If ;
	if  Purchase_Order_Customer_Id_>0  THEN 
		set Shipment_Master_Id_Old_=-2;
        
		CALL Save_Purchase_Order_Customer_Details(Purchase_Order_Details ,Purchase_Order_Customer_Id_ );
  end if;
	SELECT Purchase_Order_Customer_Id_; 
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Customer_Details`(In  Purchase_Order_Details JSON,Purchase_Order_Customer_Id_ decimal(18,0))
Begin 
 Declare Stock_Id_ int;Declare Item_Id_ int; Declare Barcode_ varchar(50); Declare Item_Name_ varchar(1000); 
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_Code_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_ varchar(500);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);Declare Weight_ int;DECLARE i int  DEFAULT 0;

	WHILE i < JSON_LENGTH(Purchase_Order_Details) DO
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;      
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Description'))) INTO Description_;    
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_;            
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;   
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_; 
/*       
set Barcode_=ifnull(Barcode_,0);
  insert into Db_logs(Description,Description2,id) values(Barcode_,"",1);
*/
INSERT INTO Purchase_Order_Customer_Details(Purchase_Order_Customer_Id,Item_Name,Packing_Size,Colour,Description,Unit_Price,Quantity,Amount,DeleteStatus ) 
values (Purchase_Order_Customer_Id_,Item_Name_,Packing_Size_,Colour_,Description_,Unit_Price_,Quantity_,Amount_,false); 	    
SELECT i + 1 INTO i;
END WHILE;  
select Purchase_Order_Customer_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Details`(In  Purchase_Order_Details JSON,Purchase_Order_Master_Id_ decimal(18,0))
Begin 
 Declare Stock_Id_ int;Declare Item_Id_ int; Declare Barcode_ varchar(50); Declare Item_Name_ varchar(1000); 
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_Code_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_ varchar(500);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);Declare Weight_ int;DECLARE i int  DEFAULT 0;

	WHILE i < JSON_LENGTH(Purchase_Order_Details) DO
    		SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;      
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Description'))) INTO Description_;    
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].HSN_Code'))) INTO HSN_Code_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_;            
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;   
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Weight'))) INTO Weight_; 
/*       
set Barcode_=ifnull(Barcode_,0);
  insert into Db_logs(Description,Description2,id) values(Barcode_,"",1);
*/
INSERT INTO Purchase_Order_Details(Purchase_Order_Master_Id,Stock_Id,Item_Id,Item_Name,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,
HSN_Id,HSN_Code,MFCode,UPC,Unit_Price,Quantity,Amount,Weight,DeleteStatus ) 
values (Purchase_Order_Master_Id_,Stock_Id_,Item_Id_,Item_Name_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,
HSN_Id_,HSN_Code_,MFCode_,UPC_,Unit_Price_,Quantity_,Amount_,Weight_,false); 	    
SELECT i + 1 INTO i;
END WHILE;  
select Purchase_Order_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Details1`(In  Purchase_Details JSON,Purchase_Master_Id_ decimal(18,0),Company_Id_ int)
Begin
 Declare StockId_ int;Declare ItemId_ int; Declare Barcode_ varchar(50); Declare ItemName_ varchar(1000);
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_CODE_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_  varchar(500);Declare SaleRate_ decimal(18,0);  Declare MRP_ decimal(18,0);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);
Declare Discount_ decimal(18,2);  Declare NetValue_ decimal(18,2);Declare CGST_ decimal(18,2); Declare CGST_AMT_ decimal(18,2); Declare SGST_ decimal(18,2);
Declare SGST_AMT_ decimal(18,2); Declare IGST_ decimal(18,2); Declare IGST_AMT_ decimal(18,2); Declare GST_ decimal(18,2);Declare GST_Amount_ decimal(18,2);
Declare Total_Amount_ decimal(18,2);Declare Include_Tax_ decimal(18,2);  Declare WareHouse_Id_ int; Declare WareHouse_Name_ varchar(50);
Declare Is_Expiry_ varchar(100); Declare Expiry_Date_ datetime;DECLARE i int  DEFAULT 0;Declare TotalAmount_ decimal(18,2);DECLARE Product_Code_ varchar(100);
WHILE i < JSON_LENGTH(Purchase_Details) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].StockId'))) INTO StockId_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Product_Code'))) INTO Product_Code_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;      
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Description'))) INTO Description_;    
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].HSN_CODE'))) INTO HSN_CODE_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SaleRate'))) INTO SaleRate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].MRP'))) INTO MRP_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Discount'))) INTO Discount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].NetValue'))) INTO NetValue_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].CGST_AMT'))) INTO CGST_AMT_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SGST_AMT'))) INTO SGST_AMT_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].IGST_AMT'))) INTO IGST_AMT_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].GST_Amount'))) INTO GST_Amount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Include_Tax'))) INTO Include_Tax_;  
/*SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Is_Expiry'))) INTO Is_Expiry_;        
 if(Is_Expiry_='true')
  then
  set Is_Expiry_=1;
  else set Is_Expiry_=0;
   end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Expiry_Date'))) INTO Expiry_Date_;      */
set Barcode_=ifnull(Barcode_,0);
#insert into Db_logs(Description,Description2,id) values(Barcode_,"",1);  
   
if exists(select Stock_Id from Stock where ItemId=ItemId_ and DeleteStatus=False)
then
set StockId_=(select Stock_Id from Stock where ItemId=ItemId_ and DeleteStatus=False order by Stock_Id desc Limit 1);                
update Stock set ItemId=ItemId_, BarCode=Barcode_, ItemName=ItemName_, Barcode=Barcode_,Group_Id=Group_Id_, Packing_Size=Packing_Size_,Colour=Colour_,
Description=Description_,Unit_Id=Unit_Id_,Unit_Name=Unit_Name_,Group_Name=Group_Name_,HSN_Id=HSN_Id_, HSN_CODE=HSN_CODE_,MFCode=MFCode_,UPC=UPC_,MRP=MRP_,
SaleRate=SaleRate_, PurchaseRate=Include_Tax_, CGST=CGST_, SGST=SGST_, IGST=IGST_, GST=GST_ ,Product_Code=Product_Code_               
where Stock_Id=StockId_;
else
insert into Stock(ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,MFCode,UPC,MRP,
SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Product_Code,DeleteStatus,Category_Id,Category_Name)
values(ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_,MFCode_,UPC_,MRP_,
SaleRate_,Include_Tax_,CGST_,SGST_,IGST_,GST_,Product_Code_,False,4,'First Sale');
set StockId_ =(SELECT LAST_INSERT_ID());
end if;            
INSERT INTO purchase_master_order_details(Purchase_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,
WareHouse_Id,WareHouse_Name,MFCode,UPC,SaleRate,MRP,Unit_Price,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_Amount,TotalAmount,
Include_Tax,Product_Code,DeleteStatus,Category_Id,Category_Name )
values (Purchase_Master_Id_,StockId_,ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_,WareHouse_Id_,
WareHouse_Name_,MFCode_,UPC_,SaleRate_,MRP_,Unit_Price_,Quantity_,Amount_,Discount_,NetValue_,CGST_,CGST_AMT_,SGST_,SGST_AMT_,IGST_,IGST_AMT_,GST_,GST_Amount_,TotalAmount_,
Include_Tax_,Product_Code_,false,4,'First Sale');
if exists(select Stock_Details_Id from Stock_Details where Stock_Id = StockId_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_)
then
update Stock_Details set Quantity = Quantity + Quantity_ where Stock_Id=StockId_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_;
else
INSERT INTO Stock_Details(Stock_Id ,WareHouse_Id ,Quantity ,Company_Id,DeleteStatus )
values (StockId_ ,WareHouse_Id_ ,Quantity_ ,Company_Id_,false);
end if;        
SELECT i + 1 INTO i;
END WHILE;  
 select Purchase_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Master`( In Purchase_Order_Master_Id_ int,Client_Accounts_Id_ int,
Purchase_Order_Customer_Id_ int,Company_Id_ int,User_Id_ int,Entry_Date_ datetime,PONo_ int,Delivery_Date_ datetime,Currency_ varchar(100),
Shipment_Method_Id_ int,Price_Method_ varchar(500),Payment_Term_ varchar(500),Shipping_Port_ varchar(500),Delivery_Port_ varchar(500),Shipmet_Plan_Id_ int,
No_of_Shipment_ int,Description_ varchar(4000),Order_Status_ int,TotalAmount_ decimal(18,2),Purchase_Order_Details JSON, Shipment_Plan JSON)
Begin
declare Voucher_No_ varchar(50);declare Description_Shipment_ varchar(4000);declare Accounts_Id_ decimal;declare YearFrom datetime;declare YearTo datetime;declare Mode_ int;
Declare Shipment_Details_Id_ int;Declare Shipment_Master_Id_ int; Declare Stock_Id_ int; Declare Item_Id_ int;Declare Item_Name_ varchar(500);
Declare Quantity_ decimal(18,2);Declare Status_ int; Declare Shipment_No_ int;Declare Shipment_Status_Id_ int;DECLARE i int  DEFAULT 0;declare Weight_ int;
DECLARE Shipment_Master_Id_Old_ int;DECLARE Shipment_Master_Id_temp_ int;
declare Shipment_Master_Status int;declare Po_No_Master_ int  DEFAULT 0;
Declare Barcode_ varchar(50); Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);
Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_Code_ varchar(50);Declare MFCode_ varchar(500);
Declare UPC_ varchar(500);Declare Unit_Price_ decimal(18,2);Declare Amount_ decimal(18,2);
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
    START TRANSACTION;   */
set YearFrom=(select Account_Years.YearFrom from Account_Years where  
Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
set YearTo=(select Account_Years.YearTo from Account_Years where
Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and
Date_Format(Account_Years.YearTo,'%Y-%m-%d')); 

	if exists(select distinct PONo from purchase_order_master)
	then    
        set PONo_=(SELECT COALESCE( MAX(PONo ),0)+1 FROM purchase_order_master
		where Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and Date_Format(YearTo,'%Y-%m-%d'));  
	else 
		if exists(select PONo from General_Settings)
		then
			set PONo_=(select COALESCE(PONo,0) from General_Settings);
		else
			set PONo_=1;
		end if;  
	end if;
#set Entry_Date_=(SELECT CURRENT_DATE());
if  Purchase_Order_Master_Id_>0  THEN 
set Shipment_Master_Status = (select count(Shipment_Master_Id)from Shipment_master where DeleteStatus=0 and Master_Status=1 
and Purchase_Order_Master_Id=Purchase_Order_Master_Id_);
	if(Shipment_Master_Status>0)then
		set Purchase_Order_Master_Id_=-1 ;
    else
		 delete from shipment_details where Shipment_Master_Id in (select Shipment_Master_Id from Shipment_Master where Purchase_Order_Master_Id=Purchase_Order_Master_Id_);              
         delete from Shipment_Master where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;            
		Delete From Purchase_Order_Details Where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;    
        set PONo_=(select PONo from Purchase_Order_Master where Purchase_Order_Master_Id=Purchase_Order_Master_Id_);
		UPDATE Purchase_Order_Master set  Client_Accounts_Id=Client_Accounts_Id_,Company_Id=Company_Id_,User_Id=User_Id_,
		Entry_Date=Entry_Date_,PONo = PONo_ ,Delivery_Date=Delivery_Date_,Currency=Currency_,Shipment_Method_Id=Shipment_Method_Id_,Price_Method = Price_Method_ ,
		Payment_Term = Payment_Term_,Shipping_Port=Shipping_Port_,Delivery_Port=Delivery_Port_,Shipmet_Plan_Id=Shipmet_Plan_Id_,No_of_Shipment=No_of_Shipment_,
		Description=Description_,Order_Status=Order_Status_,TotalAmount=TotalAmount_
	  Where Purchase_Order_Master_Id=Purchase_Order_Master_Id_ ;
      end if;
ELSE 
	SET Purchase_Order_Master_Id_ = (SELECT  COALESCE( MAX(Purchase_Order_Master_Id ),0)+1 FROM Purchase_Order_Master); 
	INSERT INTO Purchase_Order_Master(Purchase_Order_Master_Id,Client_Accounts_Id,Purchase_Order_Customer_Id,Company_Id ,User_Id,Entry_Date ,PONo ,Delivery_Date ,Currency ,Shipment_Method_Id,Price_Method,
	Payment_Term,Shipping_Port ,Delivery_Port,Shipmet_Plan_Id,No_of_Shipment,Description,Order_Status,TotalAmount,Master_Status,Po_No_Master,DeleteStatus) 
	values (Purchase_Order_Master_Id_,Client_Accounts_Id_,Purchase_Order_Customer_Id_,Company_Id_ ,User_Id_,Entry_Date_ ,PONo_ ,Delivery_Date_ ,Currency_ ,Shipment_Method_Id_,Price_Method_,
	Payment_Term_,Shipping_Port_ ,Delivery_Port_,Shipmet_Plan_Id_,No_of_Shipment_,Description_,1,TotalAmount_,0,Po_No_Master_,false);
	insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
	values(User_Id_,Entry_Date_,Purchase_Order_Master_Id_,'Purchase Order',1,'',Purchase_Order_Master_Id_,false);    
    update purchase_order_customer set Purchase_Order_Master_Id=Purchase_Order_Master_Id_,Order_Status=1 
    where Purchase_Order_Customer_Id=Purchase_Order_Customer_Id_;
End If ;
	if  Purchase_Order_Master_Id_>0  THEN 
		set Shipment_Master_Id_Old_=-2;
		WHILE i < JSON_LENGTH(Shipment_Plan) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Shipment_Master_Id'))) INTO Shipment_Master_Id_temp_;  
		if Shipment_Master_Id_Old_ <>Shipment_Master_Id_temp_  then
			if  Shipment_Master_Id_temp_>=0 then 
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Shipment_No'))) INTO Shipment_No_;
				SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Delivery_Date'))) INTO Delivery_Date_;
				SET Shipment_Master_Id_ = (SELECT  COALESCE( MAX(Shipment_Master_Id ),0)+1 FROM Shipment_Master); 
				INSERT INTO Shipment_Master(Shipment_Master_Id,Purchase_Order_Master_Id,Proforma_Invoice_Master_Id,Shipment_No,Shipment_Status_Id,Delivery_Date,Status,Master_Status,DeleteStatus) 
				values (Shipment_Master_Id_,Purchase_Order_Master_Id_,0,0,1,Delivery_Date_,2,0,false);
				#update Purchase_Order_Master set Order_Status=2 where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;
                    insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
					values(User_Id_,Delivery_Date_,Shipment_Master_Id_,'Shipment Master',2,'',Purchase_Order_Master_Id_,False);
            end if;
		else 
    		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;            
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;             
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Weight'))) INTO Weight_;               
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Description'))) INTO Description_Shipment_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Colour'))) INTO Colour_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].HSN_Code'))) INTO HSN_Code_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].UPC'))) INTO UPC_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_; 
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Shipment_Plan,CONCAT('$[',i,'].Amount'))) INTO Amount_; 
			INSERT INTO Shipment_Details(Shipment_Master_Id,Stock_Id,Item_Id,Item_Name,Quantity,Status,Produced_Quantity,
            Master_Status_Sale,Weight,Description,Barcode,Packing_Size,Colour,Unit_Id,Unit_Name,
            Group_Id,Group_Name,HSN_Id,HSN_Code,MFCode,UPC,Unit_Price,Amount,DeleteStatus) 
			values (Shipment_Master_Id_,Stock_Id_,Item_Id_,Item_Name_,Quantity_,1,0,0,Weight_,Description_Shipment_,
            Barcode_,Packing_Size_,Colour_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,
		HSN_Id_,HSN_Code_,MFCode_,UPC_,Unit_Price_,Amount_,  false); 
		end if;
		set  Shipment_Master_Id_Old_ = Shipment_Master_Id_temp_;
		SELECT i + 1 INTO i;
	END WHILE; 
		CALL Save_Purchase_Order_Details(Purchase_Order_Details ,Purchase_Order_Master_Id_ );
  end if;
	SELECT Purchase_Order_Master_Id_; 
 COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Master1`( In Purchase_Master_Id_ int,Purchase_Type_Id_ int,Account_Party_Id_ decimal(18,0),Entry_Date_ datetime,
PurchaseDate_ datetime,InvoiceNo_ varchar(50),GrossTotal_ decimal(18,2),TotalDiscount_ decimal(18,2),NetTotal_  decimal(18,2),TotalCGST_ decimal(18,2),TotalSGST_ decimal(18,2),
TotalIGST_ decimal(18,2),TotalGST_ decimal(18,2),TotalAmount_ decimal(18,2),Discount_ decimal(18,2) ,Roundoff_ decimal(18,2),Grand_Total_ decimal(18,3),
Other_Charges_ decimal(18,2) ,BillType_ int,User_Id_ decimal(18,0),Description_ varchar(1000),
Company_Id_ int,Purchase_Details JSON,Currency_Id_ int,Currency_Name_ varchar(100),GroupId_ INT)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;
declare Mode_ int;
DECLARe Duplicate_Purchase_Id int;
Declare StockId_ int;Declare ItemId_ int; Declare Barcode_ varchar(50); Declare ItemName_ varchar(1000);
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_CODE_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_  varchar(500);Declare SaleRate_ decimal(18,0);  Declare MRP_ decimal(18,0);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);
Declare Discount_ decimal(18,2) default 0;  Declare NetValue_ decimal(18,2);Declare CGST_ decimal(18,2); Declare CGST_AMT_ decimal(18,2); Declare SGST_ decimal(18,2);
Declare SGST_AMT_ decimal(18,2); Declare IGST_ decimal(18,2); Declare IGST_AMT_ decimal(18,2); Declare GST_ decimal(18,2);Declare GST_Amount_ decimal(18,2);
Declare Total_Amount_ decimal(18,2);Declare Include_Tax_ decimal(18,2);  Declare WareHouse_Id_ int; Declare WareHouse_Name_ varchar(50);
Declare Is_Expiry_ varchar(100); Declare Expiry_Date_ datetime;DECLARE i int  DEFAULT 0;Declare TotalAmount_ decimal(18,2);DECLARE Product_Code_ varchar(100);



if Purchase_Master_Id_>0 then
UPDATE purchase_master_order set Purchase_Master_Id=Purchase_Master_Id_, Purchase_Type_Id=Purchase_Type_Id_,Account_Party_Id=Account_Party_Id_,Entry_Date=Entry_Date_,
		PurchaseDate=PurchaseDate_,InvoiceNo = InvoiceNo_ ,GrossTotal=GrossTotal_,TotalDiscount=TotalDiscount_,NetTotal = NetTotal_ ,TotalCGST = TotalCGST_,TotalSGST=TotalSGST_,
		TotalIGST=TotalIGST_,TotalGST=TotalGST_,TotalAmount=TotalAmount_,Discount=Discount_,Roundoff=Roundoff_,Grand_Total=Grand_Total_,Other_Charges=Other_Charges_,
		BillType = BillType_ ,User_Id = User_Id_,Description=Description_,Company_Id=Company_Id_,
        Currency_Id=Currency_Id_,Currency_Name=Currency_Name_,Group_Id=GroupId_
		  Where Purchase_Master_Id=Purchase_Master_Id_ ;
else
SET Purchase_Master_Id_ = (SELECT  COALESCE( MAX(Purchase_Master_Id ),0)+1 FROM purchase_master_order);
INSERT INTO purchase_master_order(Purchase_Master_Id,Purchase_Type_Id,Account_Party_Id ,Entry_Date ,PurchaseDate ,InvoiceNo ,GrossTotal,TotalDiscount,NetTotal,TotalCGST ,
TotalSGST,TotalIGST,TotalGST ,TotalAmount,Discount,Roundoff,Grand_Total,Other_Charges,BillType ,
User_Id ,Description,Company_Id,DeleteStatus,Currency_Id,Currency_Name,Group_Id )
values (Purchase_Master_Id_,Purchase_Type_Id_,Account_Party_Id_ ,Entry_Date_ ,PurchaseDate_ ,InvoiceNo_ ,GrossTotal_,TotalDiscount_,NetTotal_,TotalCGST_,TotalSGST_,
TotalIGST_,TotalGST_,TotalAmount_,Discount_,Roundoff_,Grand_Total_,Other_Charges_,BillType_ ,
User_Id_ ,Description_,Company_Id_,false,Currency_Id_,Currency_Name_,GroupId_);
#delete from  db_logs;
#insert into db_logs values('',TotalGST_,1,1);
 End If ;

WHILE i < JSON_LENGTH(Purchase_Details) DO
#SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].StockId'))) INTO StockId_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Product_Code'))) INTO Product_Code_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;      
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Description'))) INTO Description_;    
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].HSN_CODE'))) INTO HSN_CODE_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SaleRate'))) INTO SaleRate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].MRP'))) INTO MRP_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_;            
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Discount'))) INTO Discount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].NetValue'))) INTO NetValue_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].CGST_AMT'))) INTO CGST_AMT_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].SGST_AMT'))) INTO SGST_AMT_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].IGST_AMT'))) INTO IGST_AMT_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].GST_Amount'))) INTO GST_Amount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Details,CONCAT('$[',i,'].Include_Tax'))) INTO Include_Tax_;  
set Barcode_=ifnull(Barcode_,0);
set StockId_ =(select Stock_Id from stock where ItemId=ItemId_ and DeleteStatus=0);
if(Discount_ = null  ) then 
 set Discount_ =0;
 end if;
#insert into data_log_ values(0,StockId_,Discount_);

if exists(select Purchase_Master_Id from purchase_master_order_details where  DeleteStatus=0 ) then
delete from purchase_master_order_details where Purchase_Master_Id = Purchase_Master_Id_;
#update purchase_master_order_details set DeleteStatus = true where Purchase_Master_Id = Purchase_Master_Id_;
end if;

INSERT INTO purchase_master_order_details(Purchase_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,
WareHouse_Id,WareHouse_Name,MFCode,UPC,SaleRate,MRP,Unit_Price,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_Amount,TotalAmount,
Include_Tax,Product_Code,DeleteStatus,Category_Id,Category_Name )
values (Purchase_Master_Id_,StockId_,ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_,WareHouse_Id_,
WareHouse_Name_,MFCode_,UPC_,SaleRate_,MRP_,Unit_Price_,Quantity_,Amount_,Discount_,NetValue_,CGST_,CGST_AMT_,SGST_,SGST_AMT_,IGST_,IGST_AMT_,GST_,GST_Amount_,TotalAmount_,
Include_Tax_,Product_Code_,false,4,'First Sale');       
SELECT i + 1 INTO i;
END WHILE;  
SELECT Purchase_Master_Id_,Voucher_No_;
#SELECT NetTotal_;
#COMMIT;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Master1_old`( In Purchase_Master_Id_ int,Purchase_Type_Id_ int,Account_Party_Id_ decimal(18,0),Entry_Date_ datetime,
PurchaseDate_ datetime,InvoiceNo_ varchar(50),GrossTotal_ decimal(18,2),TotalDiscount_ decimal(18,2),NetTotal_  decimal(18,2),TotalCGST_ decimal(18,2),TotalSGST_ decimal(18,2),
TotalIGST_ decimal(18,2),TotalGST_ decimal(18,2),TotalAmount_ decimal(18,2),Discount_ decimal(18,2) ,Roundoff_ decimal(18,2),Grand_Total_ decimal(18,3),
Other_Charges_ decimal(18,2) ,BillType_ int,User_Id_ decimal(18,0),Description_ varchar(1000),Company_Id_ int,Purchase_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;
declare Mode_ int;
DECLARe Duplicate_Purchase_Id int;
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
    
    insert into data_log_ values(0,Purchase_Master_Id_,"x");
	insert into data_log_ values(0,InvoiceNo_,"y");
	insert into data_log_ values(0,Account_Party_Id_,"z");

if  Purchase_Master_Id_>0  THEN
 SET Duplicate_Purchase_Id=(select Purchase_Master_Id from purchase_master_order where Purchase_Master_Id != Purchase_Master_Id_ and DeleteStatus=false and InvoiceNo =InvoiceNo_
AND Account_Party_Id=Account_Party_Id_ limit 1);
		if Duplicate_Purchase_Id>0 then
		set Purchase_Master_Id_=-1;
		else
		call Update_Stock_Purchase_Order(Purchase_Master_Id_,Company_Id_);
		  Delete From Purchase_Details Where Purchase_Master_Id=Purchase_Master_Id_;
		  delete from Accounts where Tran_Id=Purchase_Master_Id_ and Tran_Type='PU';
		UPDATE purchase_master_order set Purchase_Master_Id=Purchase_Master_Id_, Purchase_Type_Id=Purchase_Type_Id_,Account_Party_Id=Account_Party_Id_,Entry_Date=Entry_Date_,
		PurchaseDate=PurchaseDate_,InvoiceNo = InvoiceNo_ ,GrossTotal=GrossTotal_,TotalDiscount=TotalDiscount_,NetTotal = NetTotal_ ,TotalCGST = TotalCGST_,TotalSGST=TotalSGST_,
		TotalIGST=TotalIGST_,TotalGST=TotalGST_,TotalAmount=TotalAmount_,Discount=Discount_,Roundoff=Roundoff_,Grand_Total=Grand_Total_,Other_Charges=Other_Charges_,
		BillType = BillType_ ,User_Id = User_Id_,Description=Description_,Company_Id=Company_Id_
		  Where Purchase_Master_Id=Purchase_Master_Id_ ;
		  end if;
ELSE
 SET Duplicate_Purchase_Id=(select Purchase_Master_Id from purchase_master_order where  DeleteStatus=false and InvoiceNo =InvoiceNo_
AND Account_Party_Id=Account_Party_Id_ limit 1);
if Duplicate_Purchase_Id>0 then
set Purchase_Master_Id_=-1;
else
SET Purchase_Master_Id_ = (SELECT  COALESCE( MAX(Purchase_Master_Id ),0)+1 FROM Purchase_Master);
INSERT INTO purchase_master_order(Purchase_Master_Id,Purchase_Type_Id,Account_Party_Id ,Entry_Date ,PurchaseDate ,InvoiceNo ,GrossTotal,TotalDiscount,NetTotal,TotalCGST ,
TotalSGST,TotalIGST,TotalGST ,TotalAmount,Discount,Roundoff,Grand_Total,Other_Charges,BillType ,User_Id ,Description,Company_Id,DeleteStatus )
values (Purchase_Master_Id_,Purchase_Type_Id_,Account_Party_Id_ ,Entry_Date_ ,PurchaseDate_ ,InvoiceNo_ ,GrossTotal_,TotalDiscount_,NetTotal_,TotalCGST_,TotalSGST_,
TotalIGST_,TotalGST_,TotalAmount_,Discount_,Roundoff_,Grand_Total_,Other_Charges_,BillType_ ,User_Id_ ,Description_,Company_Id_,false);
#delete from  db_logs;
#insert into db_logs values('',TotalGST_,1,1);
 End If ;
End If ;
 /*if Purchase_Master_Id_=0 then
set Purchase_Master_Id_ =(SELECT LAST_INSERT_ID());
end if;*/      
 if(TotalAmount_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,Account_Party_Id_,0,TotalAmount_,6,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,TotalAmount_,0,Account_Party_Id_,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1);
 end IF;
  if(TotalCGST_>0)
 then
set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,TotalCGST_,25,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,25,TotalCGST_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1);
 end IF;
 
  if(TotalSGST_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,TotalSGST_,18,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,18,TotalSGST_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','',1);
 end IF;
 
   if(TotalIGST_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,TotalIGST_,29,'PU',Purchase_Master_Id_, Voucher_No_,5,Mode_,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,29,TotalIGST_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Description_,'','',1);
 end IF; 
  /*if(Cess_>0)
 then
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,6,0,Cess_,30,'PU',Purchase_Master_Id_, Voucher_No_,5,Description_,'','Y',1);
set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
VoucherType,Description1,Status,DayBook,Payment_Status)
values(Accounts_Id_,Entry_Date_,30,Cess_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Description_,'','',1);
 end IF;*/
CALL Save_Purchase_Order_Details1(Purchase_Details ,Purchase_Master_Id_ ,Company_Id_);       
SELECT Purchase_Master_Id_,Voucher_No_;
#SELECT NetTotal_;
#COMMIT;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Track_Details`(In  Purchase_Order_Details JSON,Purchase_Order_Master_Id_ decimal(18,0))
Begin 
 Declare Stock_Id_ int;Declare Item_Id_ int; Declare Barcode_ varchar(50); Declare Item_Name_ varchar(1000); 
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_Code_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_ varchar(500);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);Declare Weight_ int;DECLARE i int  DEFAULT 0;

	WHILE i < JSON_LENGTH(Purchase_Order_Details) DO
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_;            
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;   
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Order_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_; 
/*       
set Barcode_=ifnull(Barcode_,0);
  insert into Db_logs(Description,Description2,id) values(Barcode_,"",1);
*/
INSERT INTO purchase_order_track_details(Purchase_Order_Track_Master_Id,Item_Name,Quantity,Sale_Rate,Total,Deletestatus ) 
values (Purchase_Order_Master_Id_,Item_Name_,Quantity_,Unit_Price_,Amount_,false); 	    
SELECT i + 1 INTO i;
END WHILE;  
select Purchase_Order_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Order_Track_Master`( In Purchase_Order_Master_Id_ int,Client_Accounts_Id_ int,
Customer_Name_ varchar(100),PONo_ varchar(100),Po_Date_ datetime,Invoice_No_ varchar(100),Invoice_Date_ datetime,Customer_Refno_ varchar(100),
Container_No_ varchar(100),Port_Name_ varchar(100),Eta_No_ varchar(100),Track_ varchar(500),Invoice_Amount_ decimal(18,2),Payment_Status_Id_ int,Payment_Status_Name_ varchar(100),
Order_Status_Id_ int,Order_Status_Name_ varchar(100),Description_ text,Payment_Date_ datetime,
Purchase_Order_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Description_Shipment_ varchar(4000);declare Accounts_Id_ decimal;declare YearFrom datetime;declare YearTo datetime;declare Mode_ int;
Declare Shipment_Details_Id_ int;Declare Shipment_Master_Id_ int; Declare Stock_Id_ int; Declare Item_Id_ int;Declare Item_Name_ varchar(500);
Declare Quantity_ decimal(18,2);Declare Status_ int; Declare Shipment_No_ int;Declare Shipment_Status_Id_ int;DECLARE i int  DEFAULT 0;declare Weight_ int;
DECLARE Shipment_Master_Id_Old_ int;DECLARE Shipment_Master_Id_temp_ int;
declare Shipment_Master_Status int;declare Po_No_Master_ int  DEFAULT 0;
Declare Barcode_ varchar(50); Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);
Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_Code_ varchar(50);Declare MFCode_ varchar(500);
Declare UPC_ varchar(500);Declare Unit_Price_ decimal(18,2);Declare Amount_ decimal(18,2);
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
    START TRANSACTION;   */
 


#set Entry_Date_=(SELECT CURRENT_DATE());
if  Purchase_Order_Master_Id_>0  THEN           
		Delete From purchase_order_track_details Where Purchase_Order_Track_Master_Id=Purchase_Order_Master_Id_;    
        #set PONo_=(select PONo from Purchase_Order_Master where Purchase_Order_Master_Id=Purchase_Order_Master_Id_);
		UPDATE purchase_order_track_master set  
        Customer_Name=Customer_Name_,Customer_Id=Client_Accounts_Id_,PONo=PONo_,Po_Date=Po_Date_,Invoice_No=Invoice_No_,Invoice_Date=Invoice_Date_,Customer_Refno=Customer_Refno_,
        Container_No=Container_No_,Port_Name=Port_Name_,Eta_No=Eta_No_,Track=Track_,Invoice_Amount=Invoice_Amount_,Payment_Status_Id=Payment_Status_Id_,Payment_Status_Name=Payment_Status_Name_,
        Order_Status_Id=Order_Status_Id_,Order_Status_Name=Order_Status_Name_,Description=Description_,Payment_Date=Payment_Date_
	  Where Purchase_Order_Track_Master_Id=Purchase_Order_Master_Id_ ;

ELSE 
	SET Purchase_Order_Master_Id_ = (SELECT  COALESCE( MAX(Purchase_Order_Track_Master_Id ),0)+1 FROM purchase_order_track_master); 
	INSERT INTO purchase_order_track_master(Purchase_Order_Track_Master_Id,Entry_Date,Customer_Name,Customer_Id,PONo,Po_Date,Invoice_No,Invoice_Date,Customer_Refno,Container_No,Port_Name,
    Eta_No,Track,Invoice_Amount,Payment_Status_Id,Payment_Status_Name,Order_Status_Id,Order_Status_Name,Description,Payment_Date,Deletestatus) 
    
	values (Purchase_Order_Master_Id_,now(),Customer_Name_,Client_Accounts_Id_,PONo_,Po_Date_,Invoice_No_,Invoice_Date_,Customer_Refno_,Container_No_,Port_Name_,
    Eta_No_,Track_,Invoice_Amount_,Payment_Status_Id_,Payment_Status_Name_,Order_Status_Id_,Order_Status_Name_,Description_,Payment_Date_,false);
    
End If ;
	if  Purchase_Order_Master_Id_>0  THEN 
		CALL Save_Purchase_Order_Track_Details(Purchase_Order_Details ,Purchase_Order_Master_Id_ );
  end if;
	SELECT Purchase_Order_Master_Id_; 
 COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Return_Details`(In  Purchase_Return_Details JSON,Purchase_Return_Master_Id_ int)
Begin 

 Declare Stock_Id_ int;Declare Item_Id_ int; Declare Barcode_ varchar(50); Declare Item_Name_ varchar(1000); 
Declare Packing_Size_ varchar(500);Declare Colour_ varchar(500);Declare Description_ varchar(4000);Declare Unit_Id_ int;Declare Unit_Name_ varchar(500);
Declare Group_Id_ decimal(18,0); Declare Group_Name_ varchar(100); Declare HSN_Id_ decimal(18,0);Declare HSN_Code_ varchar(50);Declare MFCode_  varchar(500);
Declare UPC_ varchar(500);Declare Unit_Price_ decimal(18,2);Declare Quantity_ decimal(18,3);Declare Amount_ decimal(18,2);Declare Discount_ decimal(18,2); 
 Declare NetValue_ decimal(18,2);Declare CGST_ decimal(18,2); Declare CGST_AMT_ decimal(18,2); Declare SGST_ decimal(18,2); 
Declare SGST_AMT_ decimal(18,2); Declare IGST_ decimal(18,2); Declare IGST_AMT_ decimal(18,2); Declare GST_ decimal(18,2);Declare GST_AMT_ decimal(18,2);
Declare Total_Amount_ decimal(18,2); Declare WareHouse_Id_ int; Declare WareHouse_Name_ varchar(50); Declare TotalAmount_ decimal(18,2);
DECLARE i int  DEFAULT 0; 
 #Declare Stock_Details_Id_ decimal(18,0);Declare GrossValue_ decimal(18,2);Declare isnull_ varchar(500);
	WHILE i < JSON_LENGTH(Purchase_Return_Details) DO
    		SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;             
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;      
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Description'))) INTO Description_;    
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;                    
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].HSN_Code'))) INTO HSN_Code_;   
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;            
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Unit_Price'))) INTO Unit_Price_; 			           
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;   
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;   
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].Discount'))) INTO Discount_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].NetValue'))) INTO NetValue_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].CGST_AMT'))) INTO CGST_AMT_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].SGST_AMT'))) INTO SGST_AMT_;        
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].IGST_AMT'))) INTO IGST_AMT_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].GST_AMT'))) INTO GST_AMT_; 	
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Purchase_Return_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;		
INSERT INTO Purchase_Return_Details(Purchase_Return_Master_Id,Stock_Id,Item_Id,Item_Name,Barcode,Packing_Size,Colour,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_Code,
WareHouse_Id,WareHouse_Name,MFCode,UPC,Unit_Price,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_AMT,TotalAmount,DeleteStatus ) 
values (Purchase_Return_Master_Id_,Stock_Id_,Item_Id_,Item_Name_,Barcode_,Packing_Size_,Colour_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_Code_,
WareHouse_Id_,WareHouse_Name_,MFCode_,UPC_,Unit_Price_,Quantity_,Amount_,Discount_,NetValue_,CGST_,CGST_AMT_,SGST_,SGST_AMT_,IGST_,IGST_AMT_,GST_,GST_AMT_,TotalAmount_,false);
 		/*if exists(select Stock_Details_Id from Stock_Details where Stock_Id = Stock_Id_ and WareHouse_Id = WareHouse_Id_)
        then
			update Stock_Details set Quantity = Quantity + Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_ ;
        else
			INSERT INTO Stock_Details(Stock_Id ,WareHouse_Id ,Quantity ,DeleteStatus ) 
			values (Stock_Id_ ,WareHouse_Id_ ,Quantity_ ,false);
        end if;        */
		update Stock_Details Set Quantity=Quantity-Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_;
		SELECT i + 1 INTO i;
	END WHILE;  
 select Purchase_Return_Master_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Return_Master`( In Purchase_Return_Master_Id_ int,Client_Accounts_Id_ int,User_Id_ decimal(18,0),
Purchase_Type_Id_ int,Purchase_Date_ datetime,Entry_Date_ datetime,Invoice_No_ varchar(100),Gross_Total_ decimal(18,2),Total_Discount_ decimal(18,2),Net_Total_ decimal(18,2),
Total_CGST_ decimal(18,2),Total_SGST_ decimal(18,2),Total_IGST_ decimal(18,2),Total_GST_ decimal(18,2),Total_Amount_ decimal(18,2),Round_off_ decimal(18,2) ,Discount_ decimal(18,2),Grand_Total_ decimal(18,3),
Description_ varchar(4000),Bill_Type_ int,Company_Id_ Int,Purchase_Return_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;
declare Entry_Date_ datetime;declare Mode_ int;


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

set Entry_Date_=(SELECT CURRENT_DATE());

if  Purchase_Return_Master_Id_>0  THEN 
call Update_Stock_From_Purchase_Return(Purchase_Return_Master_Id_,Company_Id_);
  Delete From Purchase_Return_Details Where Purchase_Return_Master_Id=Purchase_Return_Master_Id_;
  delete from Accounts where Tran_Id=Purchase_Return_Master_Id_ and Tran_Type='PU';
UPDATE Purchase_Return_Master set Purchase_Return_Master_Id=Purchase_Return_Master_Id_,Client_Accounts_Id=Client_Accounts_Id_, User_Id=User_Id_,
Purchase_Type_Id=Purchase_Type_Id_,Purchase_Date=Purchase_Date_,Entry_Date=Entry_Date_,Invoice_No = Invoice_No_ ,Gross_Total=Gross_Total_,Total_Discount=Total_Discount_,
Net_Total = Net_Total_ ,Total_CGST = Total_CGST_,Total_SGST=Total_SGST_,Bill_Type=Bill_Type_,Company_Id=Company_Id_,
Total_IGST=Total_IGST_,Total_GST=Total_GST_,Total_Amount=Total_Amount_,Round_off=Round_off_,Discount=Discount_,Grand_Total=Grand_Total_,Description=Description_
  Where Purchase_Return_Master_Id=Purchase_Return_Master_Id_ ;
ELSE 
	SET Purchase_Return_Master_Id_ = (SELECT  COALESCE( MAX(Purchase_Return_Master_Id ),0)+1 FROM purchase_return_master); 
INSERT INTO purchase_return_master(Purchase_Return_Master_Id,Client_Accounts_Id,User_Id,Purchase_Type_Id,Purchase_Date,Entry_Date,Invoice_No,Gross_Total,Total_Discount,
Net_Total,Total_CGST,Total_SGST,Total_IGST,Total_GST,Total_Amount,Round_off,Discount,Grand_Total,Description,Bill_Type,Company_Id,DeleteStatus) 
values (Purchase_Return_Master_Id_,Client_Accounts_Id_,User_Id_,Purchase_Type_Id_,Purchase_Date_,Entry_Date_,Invoice_No_,Gross_Total_,Total_Discount_,
Net_Total_,Total_CGST_,Total_SGST_,Total_IGST_,Total_GST_,Total_Amount_,Round_off_,Discount_,Grand_Total_,Description_,Bill_Type_,Company_Id_,false);
#delete from  db_logs;
#insert into db_logs values('','',1,1);
 
End If ;
/*  if Purchase_Return_Master_Id_=0 then
			set Purchase_Return_Master_Id_ =(SELECT LAST_INSERT_ID());
		end if;             */
 if(Total_Amount_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,6,0,Total_Amount_,Client_Accounts_Id_,'PR',Purchase_Return_Master_Id_, Voucher_No_,5,Mode_,Description_,'','',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,Client_Accounts_Id_,Total_Amount_,0,6,'PR',Purchase_Return_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','Y',1); 
 end IF;
  if(Total_CGST_>0)
 then
	set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,25,0,Total_CGST_,6,'PR',Purchase_Return_Master_Id_, Voucher_No_,5,Mode_,Description_,'','',1); 
	set Accounts_Id_=(select COALESCE(MAX(Accounts_Id),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,6,Total_CGST_,0,25,'PR',Purchase_Return_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','Y',1); 
 end IF;
 
  if(Total_SGST_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,18,0,Total_SGST_,6,'PR',Purchase_Return_Master_Id_, Voucher_No_,5,Mode_,Description_,'','',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,6,Total_SGST_,0,18,'PR',Purchase_Return_Master_Id_, Voucher_No_ ,5,Mode_,Description_,'','Y',1); 
 end IF;
 
   if(Total_IGST_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,29,0,Total_IGST_,6,'PR',Purchase_Return_Master_Id_, Voucher_No_,5,Mode_,Description_,'','',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,6,Total_IGST_,0,29,'PR',Purchase_Return_Master_Id_, Voucher_No_ ,5,Description_,'','Y',1); 
 end IF;
 
  /*if(Cess_>0)
 then
		set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
		VoucherType,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Entry_Date_,6,0,Cess_,30,'PU',Purchase_Master_Id_, Voucher_No_,5,Description_,'','Y',1); 
		set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,
		VoucherType,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Entry_Date_,30,Cess_,0,6,'PU',Purchase_Master_Id_, Voucher_No_ ,5,Description_,'','',1); 
 end IF;*/ 

   CALL Save_Purchase_Return_Details(Purchase_Return_Details ,Purchase_Return_Master_Id_ );   
      
SELECT Purchase_Return_Master_Id_,Voucher_No_;
#SELECT NetTotal_;
# COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Purchase_Type`( In Purchase_Type_Id_ int,
Purchase_Type_Name_ varchar(500),Status_ varchar(50),Email_ varchar(50),DeleteStatus_ tinyint)
Begin 
 if  Purchase_Type_Id_>0
 THEN 
 UPDATE purchase_type set Purchase_Type_Id = Purchase_Type_Id_ ,Purchase_Type_Name = Purchase_Type_Name_ ,
Status = Status_ ,Email = Email_ Where Purchase_Type_Id = Purchase_Type_Id_  ;
 ELSE 
 SET Purchase_Type_Id_ = (SELECT  COALESCE( MAX(Purchase_Type_Id ),0)+1 FROM purchase_type); 
 INSERT INTO purchase_type(Purchase_Type_Id ,Purchase_Type_Name ,Status ,Email ,DeleteStatus ) 
 values (Purchase_Type_Id_ ,Purchase_Type_Name_ ,Status_ ,Email_ ,false);
 End If ;
 select Purchase_Type_Id_;
# insert into db_logs values(Email_,Status_,1,1);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Salary_Calculation_Master`( In Salary_Calculation_Master_Id_ int,Entry_Date_ datetime,From_Date_ datetime,
To_Date_ datetime,User_Id_ int,Total_ decimal(18,2),Salary_Calculation_Details JSON)
BEGIN
DECLARE Is_Employee_ varchar(25) default 1;DECLARE Employee_Id_ int;declare Employee_Name_ varchar(45);declare Normal_Total_ varchar(100);
declare Ot_Total_ varchar(100);declare Loading_Total_ varchar(100);declare Piece_Total_ varchar(100);declare Other_Total_ varchar(100);
declare TotalAmount_ varchar(100);declare Calculation_No_ int;
	DECLARE i int  DEFAULT 0;
	if  Salary_Calculation_Master_Id_>0
		THEN       
		delete from Salary_Calculation_details where Salary_Calculation_Master_Id=Salary_Calculation_Master_Id_;
		UPDATE Salary_Calculation_master set Entry_Date=Entry_Date_,From_Date=From_Date_,To_Date=To_Date_,Total=Total_,User_Id=User_Id_
        Where Salary_Calculation_Master_Id=Salary_Calculation_Master_Id_ ;
	ELSE 
		SET Salary_Calculation_Master_Id_ = (SELECT COALESCE( MAX(Salary_Calculation_Master_Id ),0)+1 FROM Salary_Calculation_master); 
        SET Calculation_No_ = (SELECT COALESCE( MAX(Calculation_No ),0)+1 FROM Salary_Calculation_master);         
		INSERT INTO Salary_Calculation_master(Salary_Calculation_Master_Id,Calculation_No, Entry_Date,From_Date, To_Date,User_Id,Total,DeleteStatus) 
		values (Salary_Calculation_Master_Id_ ,Calculation_No_,Entry_Date_, From_Date_ , To_Date_,User_Id_,Total_,false);      
  end if;      
    WHILE i < JSON_LENGTH(Salary_Calculation_Details) DO		
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].Employee_Id'))) INTO Employee_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].Employee_Name'))) INTO Employee_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].Normal_Total'))) INTO Normal_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].Ot_Total'))) INTO Ot_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].Loading_Total'))) INTO Loading_Total_;		
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].Piece_Total'))) INTO Piece_Total_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].Other_Total'))) INTO Other_Total_;		
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Salary_Calculation_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;        
		INSERT INTO Salary_Calculation_details(Salary_Calculation_Master_Id,Is_Employee,Employee_Id,Employee_Name,Normal_Total,
        Ot_Total,Loading_Total,Piece_Total,Other_Total,TotalAmount,DeleteStatus ) 
		values(Salary_Calculation_Master_Id_,Is_Employee_,Employee_Id_,Employee_Name_,Normal_Total_,Ot_Total_,Loading_Total_,
        Piece_Total_,Other_Total_,TotalAmount_,false);
		SELECT i + 1 INTO i;
	END WHILE;
select Salary_Calculation_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Sale_Unit`( In Sale_Unit_Id_ decimal,
Sale_Unit_Code_ varchar(50),
Sale_Unit_Name_ varchar(100))
Begin 
declare Duplicate_Id int;
 if  Sale_Unit_Id_>0 THEN 
 Set Duplicate_Id = (select Sale_Unit_Id from Sale_Unit where Sale_Unit_Id != Sale_Unit_Id_ and Sale_Unit_Name=Sale_Unit_Name_ and DeleteStatus=0 limit 1);
if(Duplicate_Id>0) then
	SET Sale_Unit_Id_ = -1;  
else
 UPDATE Sale_Unit set Sale_Unit_Id = Sale_Unit_Id_ ,
Sale_Unit_Code = Sale_Unit_Code_ ,
Sale_Unit_Name = Sale_Unit_Name_  Where Sale_Unit_Id=Sale_Unit_Id_ ;
end if;
 ELSE 
 Set Duplicate_Id = (select Sale_Unit_Id from Sale_Unit where Sale_Unit_Name=Sale_Unit_Name_ and DeleteStatus=0 limit 1);
if(Duplicate_Id>0) then
	SET Sale_Unit_Id_ = -1;  
else
 SET Sale_Unit_Id_ = (SELECT  COALESCE( MAX(Sale_Unit_Id ),0)+1 FROM Sale_Unit); 
 INSERT INTO Sale_Unit(Sale_Unit_Id ,
Sale_Unit_Code ,
Sale_Unit_Name ,
DeleteStatus ) values (Sale_Unit_Id_ ,
Sale_Unit_Code_ ,
Sale_Unit_Name_ ,
false);
 End If ;
 End If ;
 select Sale_Unit_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Sales_Details`( In Sales_Details JSON,Sales_Master_Id_ decimal(18,0),Company_Id_ int)
Begin 
    DECLARE Stock_Id_ decimal(18,0);DECLARE ItemId_ decimal(18,0);DECLARE ItemName_ varchar(1000);
	DECLARE Barcode_ VARCHAR(100);DECLARE Packing_Size_ varchar(500);DECLARE Colour_ varchar(500);DECLARE Description_ varchar(4500);
    DECLARE Group_Id_ decimal(18,0); DECLARE Group_Name_ VARCHAR(100);DECLARE HSN_Id_ decimal(18,0);DECLARE HSN_CODE_ varchar(50);
    DECLARE Unit_Id_ decimal(18,0);DECLARE Unit_Name_ VARCHAR(100); DECLARE WareHouse_Id_ decimal(18,0);DECLARE WareHouse_Name_ VARCHAR(100);
    DECLARE MFCode_ varchar(500); DECLARE UPC_ varchar(500);DECLARE MRP_ decimal(18,2);DECLARE SaleRate_ decimal(18,2);DECLARE Quantity_ decimal(18,3);
	DECLARE Amount_ decimal(18,3);DECLARE Discount_ decimal(18,3);declare NetValue_ decimal(18,2);
    DECLARE CGST_ decimal(18,2);DECLARE CGST_AMT_ decimal(18,2);DECLARE SGST_ decimal(18,2);DECLARE SGST_AMT_ decimal(18,2);DECLARE IGST_ decimal(18,2);
    DECLARE IGST_AMT_ decimal(18,2);DECLARE GST_ decimal(18,2);	DECLARE GST_AMT_ decimal(18,2);	DECLARE Cesspers_ decimal(18,2);
    DECLARE CessAMT_ decimal(18,2);      DECLARE TotalAmount_ decimal(18,2);       	declare Weight_ int;
    Declare  Packageno_ varchar(500); Declare Noofpcs_ varchar(500); Declare Noofpackage_ varchar(500); Declare Totalweight_ varchar(500);
Declare Weightpcs_ varchar(500); Declare Netweight_ varchar(500); Declare Grossweight_ varchar(500);declare Product_Code_ varchar(100);
    DECLARE i int  DEFAULT 0;
	WHILE i < JSON_LENGTH(Sales_Details) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;        
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Description'))) INTO Description_;		     
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;  
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;     
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].HSN_CODE'))) INTO HSN_CODE_;        
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].MRP'))) INTO MRP_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].SaleRate'))) INTO SaleRate_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;    
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Discount'))) INTO Discount_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].NetValue'))) INTO NetValue_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_;       
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].CGST_AMT'))) INTO CGST_AMT_;		  
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;  
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].SGST_AMT'))) INTO SGST_AMT_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].IGST_AMT'))) INTO IGST_AMT_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].GST_AMT'))) INTO GST_AMT_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Cesspers'))) INTO Cesspers_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].CessAMT'))) INTO CessAMT_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].TotalAmount'))) INTO TotalAmount_;  
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Weight'))) INTO Weight_; 
         SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Packageno'))) INTO Packageno_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Noofpcs'))) INTO Noofpcs_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Noofpackage'))) INTO Noofpackage_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Totalweight'))) INTO Totalweight_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Weightpcs'))) INTO Weightpcs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Netweight'))) INTO Netweight_;  
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Grossweight'))) INTO Grossweight_;  
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Details,CONCAT('$[',i,'].Product_Code'))) INTO Product_Code_; 
        
        if isnull(Product_Code_) then
        set Product_Code_='';
        end if;
        
        if isnull(Barcode_) then
        set Barcode_='';
        end if;
    
		INSERT INTO Sales_Details(Sales_Master_Id ,Stock_Id ,ItemId ,ItemName ,Barcode ,Packing_Size ,Colour , Description ,Unit_Id ,Unit_Name ,Group_Id ,Group_Name ,
        HSN_Id ,HSN_CODE, WareHouse_Id,WareHouse_Name,MFCode,UPC,MRP,SaleRate,Quantity,Amount,Discount,NetValue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,IGST_AMT,GST,GST_AMT,
        Cesspers,CessAMT,TotalAmount ,Weight,Packageno,Noofpcs,Noofpackage,Totalweight,Weightpcs,Netweight,Grossweight ,Product_Code,DeleteStatus,Category_Id,Category_Name ) 
		values (Sales_Master_Id_ ,Stock_Id_ ,ItemId_ ,ItemName_ ,Barcode_ ,Packing_Size_ ,Colour_ , Description_ ,Unit_Id_ ,Unit_Name_ ,Group_Id_ ,Group_Name_ ,
        HSN_Id_ ,HSN_CODE_, WareHouse_Id_ ,WareHouse_Name_ ,MFCode_ ,UPC_ ,MRP_ ,SaleRate_ ,Quantity_,Amount_,Discount_,NetValue_,CGST_,CGST_AMT_,SGST_,SGST_AMT_,IGST_,
        IGST_AMT_,GST_,GST_AMT_,Cesspers_,CessAMT_,TotalAmount_ ,Weight_,Packageno_,Noofpcs_,Noofpackage_,Totalweight_,Weightpcs_,Netweight_,Grossweight_,Product_Code_,false,4,'First Sale');

		update Stock_Details Set Quantity=Quantity-Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_;
		SELECT i + 1 INTO i;

	END WHILE;
  
SELECT Sales_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Sales_Master`( In Sales_Master_Id_ int,Purchase_Order_Master_Id_ int,Proforma_Invoice_Master_Id_ int,
Account_Party_Id_ decimal(18,0),Company_Id_ int,Entry_Date_ datetime,Invoice_No_ decimal(18,0),BillType_ int,User_Id_ decimal(18,0),GrossTotal_ decimal(18,0),
TotalDiscount_ decimal(18,2),NetTotal_ decimal(18,2),TotalCGST_ decimal(18,2),ToalSGST_ decimal(18,2),TotalIGST_ decimal(18,2),TotalGST_ decimal(18,2),
TotalAmount_ decimal(18,2), RoundOff_ decimal(18,2),Discount_ decimal(18,2),GrandTotal_ decimal(18,2),Description1_ varchar(500),Cess_ decimal(18,2),
Currency_ varchar(50),Pallet_Weight_ int,Total_Weight_ int,Net_Weight_ int,TypeofContainer_ Int,ContainerNo_ varchar(500),Typeofpackage_ varchar(500),
Exporterref_ varchar(500),Otherref_ varchar(500),Precarriage_ varchar(500),Vessalno_ varchar(500),Contryoforgin_ varchar(500),Contrydestination_ varchar(500),
PlaceofReceipt_ varchar(500),Portofloading_ varchar(500),Portofdischarge_ varchar(100),Finaldestination_ varchar(500),Termsofdelivery_ varchar(500),
Bank_Id_ int,Currency_Rate_ decimal(18,2),Product_Description_ varchar(500),Total_Packing_packages_ int,Total_Packing_ int,Packing_NetWeight_ decimal(18,2),
Packing_GrossWeight_ decimal(18,2),PO_Date_ Datetime,PONo_ varchar(100),Pack_Length_ int,Packing_Length_ int,Sales_Details JSON,Sales_Pack_List JSON,
 Sales_Packing_List JSON,Sales_Type_ int)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;declare Place_Id_ int;declare YearFrom datetime;declare YearTo datetime;
declare billtypes_ varchar(100);DECLARE Stock_Id_ int;DECLARE Quantity_ int;DECLARE ItemId_ int;DECLARE ItemName_ varchar(100);
DECLARE Weight_ int;DECLARE Total_Weight_1 int;DECLARE Description_1 varchar(4000);declare Purchase_Order_Master_ int;
declare ItemId_1 int;declare ItemName_1 varchar(100);declare Size_ varchar(45);declare Package_No_ varchar(100);
declare No_Of_Pcs_ int;declare No_Of_Pckgs_ int;declare Total_ int;declare Weight_1 decimal(18,2);
declare Net_Weight_ decimal(18,2);declare Gross_Weight_ decimal(18,2);
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
	set YearFrom=(select Account_Years.YearFrom from Account_Years where  
	Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
	set YearTo=(select Account_Years.YearTo from Account_Years where 
	Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and Date_Format(Account_Years.YearTo,'%Y-%m-%d'));    
if exists(select distinct Invoice_No from Sales_Master)
then
	set Voucher_No_=(SELECT COALESCE(MAX(Invoice_No ),0)+1 FROM Sales_Master
	where BillType=BillType_ and Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and Date_Format(YearTo,'%Y-%m-%d'));  
else 
	if exists(select Invoice_No from General_Settings)
	then
		set Voucher_No_=(select COALESCE(Invoice_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;    
end if;
 if  Sales_Master_Id_>0  THEN
	  call Update_Stock_FromSales(Sales_Master_Id_,Company_Id_);
	  Delete From Sales_Packing_List Where Sales_Master_Id=Sales_Master_Id_;
	  Delete From Sales_Pack_List Where Sales_Master_Id=Sales_Master_Id_;
	  Delete From Sales_Details Where Sales_Master_Id=Sales_Master_Id_;
	  delete from Accounts where Tran_Id=Sales_Master_Id_ and Tran_Type='SA';
	  set billtypes_=(select BillType from Sales_Master Where Sales_Master_Id=Sales_Master_Id_) ;
	  if (billtypes_=BillType_)then
		set Voucher_No_=(select Invoice_No from Sales_Master Where Sales_Master_Id=Sales_Master_Id_) ;
	  end if;
	UPDATE Sales_Master set Account_Party_Id=Account_Party_Id_,Purchase_Order_Master_Id=Purchase_Order_Master_Id_,Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_,
    Company_Id=Company_Id_,Entry_Date=Entry_Date_,Invoice_No=Voucher_No_,BillType=BillType_,User_Id=User_Id_,GrossTotal=GrossTotal_,
    TotalDiscount=TotalDiscount_,NetTotal=NetTotal_,TotalCGST=TotalCGST_,ToalSGST=ToalSGST_,TotalIGST=TotalIGST_,TotalGST=TotalGST_,
	TotalAmount = TotalAmount_ ,RoundOff = RoundOff_ ,Discount=Discount_,GrandTotal =GrandTotal_,Description1=Description1_,Cess = Cess_,Currency = Currency_,
    Pallet_Weight=Pallet_Weight_,Total_Weight=Total_Weight_,Net_Weight=Net_Weight_,Bank_Id=Bank_Id_,Currency_Rate=Currency_Rate_,TypeofContainer=TypeofContainer_,
    ContainerNo=ContainerNo_,Typeofpackage=Typeofpackage_,Exporterref=Exporterref_,Otherref=Otherref_,Precarriage=Precarriage_,Vessalno=Vessalno_,
    Contryoforgin=Contryoforgin_,Contrydestination=Contrydestination_,PlaceofReceipt=PlaceofReceipt_,Portofloading=Portofloading_,Portofdischarge=Portofdischarge_,
    Finaldestination=Finaldestination_,Termsofdelivery=Termsofdelivery_,Product_Description=Product_Description_,Total_Packing_packages=Total_Packing_packages_,
    Total_Packing=Total_Packing_,Packing_NetWeight=Packing_NetWeight_,Packing_GrossWeight=Packing_GrossWeight_,Sales_Type=Sales_Type_ Where Sales_Master_Id=Sales_Master_Id_;
 ELSE
SET Sales_Master_Id_ = (SELECT  COALESCE( MAX(Sales_Master_Id ),0)+1 FROM Sales_Master);
	INSERT INTO Sales_Master(Sales_Master_Id,Purchase_Order_Master_Id,Proforma_Invoice_Master_Id,Account_Party_Id,Company_Id,Entry_Date,Invoice_No,BillType,User_Id,GrossTotal,TotalDiscount,NetTotal,
	TotalCGST,ToalSGST,TotalIGST,TotalGST,TotalAmount,RoundOff,Discount, GrandTotal,Description1,Cess,Currency,Pallet_Weight,Total_Weight,Net_Weight,
    TypeofContainer,ContainerNo,Typeofpackage,Exporterref,Otherref,Precarriage,Vessalno,Contryoforgin,Contrydestination,PlaceofReceipt,
	Portofloading,Portofdischarge,Finaldestination,Termsofdelivery,BI_No,ETA,Status,Tracking_Id,Shipment_Status,Bank_Id,
	Currency_Rate,Product_Description,Total_Packing_packages,Total_Packing,Packing_NetWeight,Packing_GrossWeight,PO_Date,PONo,DeleteStatus,Sales_Type ) 
	values (Sales_Master_Id_,Purchase_Order_Master_Id_,Proforma_Invoice_Master_Id_,Account_Party_Id_,Company_Id_,Entry_Date_,Voucher_No_,BillType_,User_Id_,GrossTotal_,TotalDiscount_,NetTotal_,
	TotalCGST_,ToalSGST_,TotalIGST_,TotalGST_,TotalAmount_,RoundOff_,Discount_, GrandTotal_,Description1_,Cess_,Currency_,Pallet_Weight_,Total_Weight_,Net_Weight_,
    TypeofContainer_,ContainerNo_,Typeofpackage_,Exporterref_,Otherref_,Precarriage_,Vessalno_,Contryoforgin_,Contrydestination_,PlaceofReceipt_,
	Portofloading_,Portofdischarge_,Finaldestination_,Termsofdelivery_,'','','','',0,Bank_Id_,Currency_Rate_,Product_Description_,
	Total_Packing_packages_,Total_Packing_,Packing_NetWeight_,Packing_GrossWeight_,PO_Date_,PONo_,False,Sales_Type_);    
 /* if Sales_Master_Id_=0 then
			set Sales_Master_Id_ =(SELECT LAST_INSERT_ID());
 end if;*/
 update purchase_order_master set Order_Status=14 where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;
     update Proforma_Invoice_Master set Sales_Master_Id=Sales_Master_Id_ where Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_;
    /*set Purchase_Order_Master_=(select distinct Shipment_Master.Purchase_Order_Master_Id from Shipment_Master
			inner join Proforma_Invoice_Master on Proforma_Invoice_Master.Shipment_Master_Id=Shipment_Master.Shipment_Master_Id 
			inner join Sales_Master on Proforma_Invoice_Master.Proforma_Invoice_Master_Id=Sales_Master.Proforma_Invoice_Master_Id
			and  Sales_Master.Proforma_Invoice_Master_Id=Proforma_Invoice_Master_Id_);*/    
    insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
    values(User_Id_,Entry_Date_,Sales_Master_Id_,'Sales Master',14,'',Purchase_Order_Master_Id_,False);
 End If ;
if(GrandTotal_>0)
 then 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Description1,Status,DayBook,Payment_Status)
	values(Accounts_Id_,Entry_Date_,5,0,GrandTotal_,Account_Party_Id_,'SA',Sales_Master_Id_, Voucher_No_,5,Description1_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Description1,Status,DayBook,Payment_Status) 
	values(Accounts_Id_,Entry_Date_,Account_Party_Id_,GrandTotal_,0,5,'SA',Sales_Master_Id_, Voucher_No_ ,5,Description1_,'','',1); 
 end IF;
  if(TotalCGST_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Description1,Status,DayBook,Payment_Status)
	values(Accounts_Id_,Entry_Date_,25,0,TotalCGST_,5,'SA',Sales_Master_Id_, Voucher_No_,5,Description1_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Description1,Status,DayBook,Payment_Status) 
	values(Accounts_Id_,Entry_Date_,5,TotalCGST_,0,25,'SA',Sales_Master_Id_, Voucher_No_ ,5,Description1_,'','',1); 
 end IF; 
  if(ToalSGST_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Description1,Status,DayBook,Payment_Status)
	values(Accounts_Id_,Entry_Date_,18,0,ToalSGST_,6,'SA',Sales_Master_Id_, Voucher_No_,5,Description1_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Description1,Status,DayBook,Payment_Status) 
	values(Accounts_Id_,Entry_Date_,6,ToalSGST_,0,18,'SA',Sales_Master_Id_, Voucher_No_ ,5,Description1_,'','',1); 
 end IF;
  if(Cess_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Description1,Status,DayBook,Payment_Status)
	values(Accounts_Id_,Entry_Date_,32,0,Cess_,6,'SA',Sales_Master_Id_, Voucher_No_,5,Description1_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
	insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No,VoucherType,Description1,Status,DayBook,Payment_Status) 
	values(Accounts_Id_,Entry_Date_,6,Cess_,0,32,'SA',Sales_Master_Id_, Voucher_No_ ,5,Description1_,'','',1); 
 end IF;
CALL Save_Sales_Details(Sales_Details ,Sales_Master_Id_,Company_Id_ );
if Pack_Length_>0 then
	WHILE i < JSON_LENGTH(Sales_Pack_List) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Pack_List,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Pack_List,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Pack_List,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Pack_List,CONCAT('$[',i,'].Description'))) INTO Description_1;	
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Pack_List,CONCAT('$[',i,'].Weight'))) INTO Weight_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Pack_List,CONCAT('$[',i,'].Total_Weight'))) INTO Total_Weight_1;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Pack_List,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;
  		INSERT INTO Sales_Pack_List(Sales_Master_Id  ,ItemId ,ItemName ,Stock_Id ,Quantity,Weight ,Total_Weight,Description,DeleteStatus ) 
		values (Sales_Master_Id_  ,ItemId_ ,ItemName_ ,Stock_Id_ ,Quantity_,Weight_,Total_Weight_1,Description_1,false);
		SELECT i + 1 INTO i;
        END WHILE;
     end if;     
if Packing_Length_>0 then
        WHILE j < JSON_LENGTH(Sales_Packing_List) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].ItemId'))) INTO ItemId_1;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].ItemName'))) INTO ItemName_1;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].Size'))) INTO Size_;	
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].Package_No'))) INTO Package_No_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].No_Of_Pcs'))) INTO No_Of_Pcs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].No_Of_Pckgs'))) INTO No_Of_Pckgs_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].Total'))) INTO Total_;	
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].Weight'))) INTO Weight_1;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].Net_Weight'))) INTO Net_Weight_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Sales_Packing_List,CONCAT('$[',j,'].Gross_Weight'))) INTO Gross_Weight_;
		INSERT INTO Sales_Packing_List(Sales_Master_Id  ,ItemId ,ItemName,Size ,Package_No ,No_Of_Pcs,No_Of_Pckgs ,Total,Weight,Net_Weight,Gross_Weight,DeleteStatus ) 
		values (Sales_Master_Id_  ,ItemId_1 ,ItemName_1 ,Size_ ,Package_No_,No_Of_Pcs_,No_Of_Pckgs_,Total_,Weight_1,Net_Weight_,Gross_Weight_,false);
		SELECT j + 1 INTO j;
        END WHILE;
	end if;
 select Sales_Master_Id_;
 COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Shift_Details`( In Shift_Details_Id_ int,Shift_Details_Name_ varchar(500),Status_ varchar(50),DeleteStatus_ tinyint)
Begin 
 if  Shift_Details_Id_>0
 THEN 
 UPDATE shift_details set Shift_Details_Id = Shift_Details_Id_ ,Shift_Details_Name = Shift_Details_Name_ ,Status=Status_
Where Shift_Details_Id = Shift_Details_Id_;
 ELSE 
 SET Shift_Details_Id_ = (SELECT  COALESCE( MAX(Shift_Details_Id ),0)+1 FROM shift_details); 
 INSERT INTO shift_details(Shift_Details_Id,Shift_Details_Name ,Status ,DeleteStatus ) 
 values (Shift_Details_Id_ ,Shift_Details_Name_ ,Status_ ,false);
 End If ;
 select Shift_Details_Id_;
# insert into db_logs values(Email_,Status_,1,1);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Shift_End`( In Shift_End_Master_Id_ int,Shift_Start_Master_Id_ int,Production_Master_Id_ int,
Press_Details_Id_ int,Process_List_Id_ int,Shift_Details_Id_ int,Date_ datetime,Production_No_ int,Shift_End_No_ varchar(100),OutputNo_ varchar(100),
Acceptable_ decimal(18,2),Damage_ decimal(18,2),Wastage_ decimal(18,2),User_Id_ int,Stock_Id_ int,Batch_No_ varchar(100),Item_Id_ int,Item_Name_ varchar(500),WareHouse_Id_ int,
WareHouse_Name_ varchar(500),Production_Damage_ decimal(18,2),Company_Id_ int,Weight_ decimal(18,2),Batch_Weight_ decimal(18,2),Weight_Item_ decimal(18,2),
Weight_Description_ varchar(4000),Position_Id_ int,Purchase_Order_Master_Id_ int,Wastage_Length_ int,Shift_End_Details JSON,Shift_End_Details_Wastage_ JSON)
BEGIN
DECLARE Is_Employee_ varchar(25);DECLARE Employee_Id_ int;DECLARE Start_Time_ decimal(18,2);DECLARE End_Time_ decimal(18,2);  
DECLARE Working_Hours_ decimal(18,2);DECLARE Ot_ decimal(18,2);DECLARE Loading_ decimal(18,2);DECLARE Normal_Rate_ decimal(18,2);
DECLARE Ot_Rate_ decimal(18,2);DECLARE Loading_Rate_ decimal(18,2);DECLARE Working_Total_ decimal(18,2);DECLARE Ot_Total_ decimal(18,2);
DECLARE Loading_Total_ decimal(18,2);declare Wastage_Id_ int;declare Item_Stock_Id_Wastage_ int;declare Item_Name_Wastage_ varchar(500);
declare  Stock_Id_Wastage_ int;declare Stock_Add_Status_ int;DECLARE Quantitypers_ decimal(18,3);declare Warehouse_Id_Wastage_ int;
declare Warehouse_Name_Wastage_ varchar(500);declare Process_List_Id_Old_ int;declare Stock_Add_Status_Old_ int; DECLARE Acceptable_Old_ decimal(18,2);
DECLARE Stock_Id_Old_ int;DECLARE WareHouse_Id_Old_ int;DECLARE Proforma_Invoice_Details_Id_ int;DECLARE Production_Master_Id_Old_ int;DECLARE i int DEFAULT 0;
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
   
    /*set Production_Master_Id_Old_=(select Production_Master_Id from shift_end_master where  Shift_End_Master_Id=Shift_End_Master_Id_);    
    set Stock_Id_Old_=(select Stock_Id from shift_end_master where  Shift_End_Master_Id=Shift_End_Master_Id_);
    set WareHouse_Id_Old_=(select WareHouse_Id from shift_end_master where  Shift_End_Master_Id=Shift_End_Master_Id_);
    set Process_List_Id_Old_=(select Process_List_Id from shift_end_master where  Shift_End_Master_Id=Shift_End_Master_Id_);
    set Stock_Add_Status_Old_=(select Stock_Add_Status from process_list where Item_Id=Item_Id_ and Process_Id=Process_List_Id_Old_ and DeleteStatus=false);
    set Stock_Add_Status_=(select Stock_Add_Status from process_list where Item_Id=Item_Id_ and Process_Id=Process_List_Id_ and DeleteStatus=false);
    */
if  Shift_End_Master_Id_>0
THEN        
        call Update_StockFrom_Shiftend(Shift_End_Master_Id_,Company_Id_);        
       /* set Acceptable_Old_=(select Acceptable from shift_end_master where  Shift_End_Master_Id=Shift_End_Master_Id_);
         if(Stock_Add_Status_Old_ =1 )then
set Proforma_Invoice_Details_Id_=(select Proforma_Invoice_Details_Id from production_master where Production_Master_Id=Production_Master_Id_Old_);
update Stock_Details Set Quantity=Quantity-Acceptable_Old_ where Stock_Id=Stock_Id_Old_ and WareHouse_Id = WareHouse_Id_Old_;    
update proforma_invoice_details Set proforma_invoice_details.Produced_Quantity=proforma_invoice_details.Produced_Quantity-Acceptable_Old_  where Proforma_Invoice_Details_Id=Proforma_Invoice_Details_Id_;
         end if;*/
delete from shift_end_details where Shift_End_Master_Id=Shift_End_Master_Id_;
delete from shift_end_details_wastage where Shift_End_Master_Id=Shift_End_Master_Id_;
UPDATE shift_end_master set Shift_Start_Master_Id=Shift_Start_Master_Id_,Production_Master_Id=Production_Master_Id_,Press_Details_Id = Press_Details_Id_ ,
Process_List_Id = Process_List_Id_ ,Shift_Details_Id = Shift_Details_Id_ ,Date = Date_ ,Production_No=Production_No_,Shift_End_No = Shift_End_No_ ,
OutputNo = OutputNo_ ,Acceptable = Acceptable_ ,Damage = Damage_ ,Wastage = Wastage_ ,User_Id = User_Id_,Stock_Id=Stock_Id_ , Item_Id=Item_Id_,
Item_Name=Item_Name_,WareHouse_Id=WareHouse_Id_,WareHouse_Name=WareHouse_Name_  ,Production_Damage=Production_Damage_,Company_Id=Company_Id_,
Batch_Weight=Batch_Weight_,Weight=Weight_,Weight_Item=Weight_Item_,Weight_Description=Weight_Description_, Position_Id=Position_Id_,Batch_No=Batch_No_,
Purchase_Order_Master_Id=Purchase_Order_Master_Id_  Where Shift_End_Master_Id=Shift_End_Master_Id_ ;
ELSE
	SET Shift_End_Master_Id_ = (SELECT  COALESCE( MAX(Shift_End_Master_Id ),0)+1 FROM shift_end_master);
	SET Shift_End_No_ = (SELECT  COALESCE( MAX(Shift_End_No ),0)+1 FROM shift_end_master);        
	INSERT INTO shift_end_master(Shift_End_Master_Id,Shift_Start_Master_Id, Production_Master_Id,Press_Details_Id, Process_List_Id,Shift_Details_Id, Date, 
	Production_No, Shift_End_No, OutputNo,Acceptable, Damage,Wastage, User_Id,Stock_Id,Item_Id,Item_Name,WareHouse_Id,WareHouse_Name, Master_Status,
	Production_Damage,Company_Id,Weight,Batch_Weight,Weight_Item,Weight_Description,Position_Id,Purchase_Order_Master_Id,Batch_No,DeleteStatus )
	values (Shift_End_Master_Id_ ,0,Production_Master_Id_, Press_Details_Id_ , Process_List_Id_,Shift_Details_Id_ , Date_ , Production_No_ ,Shift_End_No_ , 
	OutputNo_,Acceptable_ , Damage_,Wastage_ , User_Id_,Stock_Id_,Item_Id_,Item_Name_,WareHouse_Id_,WareHouse_Name_,0,
	Production_Damage_,Company_Id_,Weight_,Batch_Weight_,Weight_Item_,Weight_Description_,Position_Id_,Purchase_Order_Master_Id_,Batch_No_,false);      
	update production_master set Shift_End_Master_Id=Shift_End_Master_Id_, Master_Status=1  where Production_Master_Id=Production_Master_Id_;   
	Insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
	Values(User_Id_,Date_,Shift_End_Master_Id_,'Shift End',8,'',Purchase_Order_Master_Id_,False);   
End If ;    
WHILE i < JSON_LENGTH(Shift_End_Details) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Check_Box'))) INTO Is_Employee_;
if(Is_Employee_='true'  or  Is_Employee_=1)
then set Is_Employee_=1;
else set Is_Employee_=0;
end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Employee_Id'))) INTO Employee_Id_;
/* SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Start_Time'))) INTO Start_Time_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].End_Time'))) INTO End_Time_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Working_Hours'))) INTO Working_Hours_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Ot'))) INTO Ot_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Loading'))) INTO Loading_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Normal_Rate'))) INTO Normal_Rate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Ot_Rate'))) INTO Ot_Rate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Loading_Rate'))) INTO Loading_Rate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Working_Total'))) INTO Working_Total_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Ot_Total'))) INTO Ot_Total_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details,CONCAT('$[',i,'].Loading_Total'))) INTO Loading_Total_; */
INSERT INTO shift_end_details(Shift_End_Master_Id,Is_Employee,Employee_Id,Start_Time,End_Time ,Working_Hours,Ot,
        Loading,Normal_Rate,Ot_Rate,Loading_Rate,Working_Total,Ot_Total,Loading_Total,Description,DeleteStatus )
values (Shift_End_Master_Id_ ,Is_Employee_ ,Employee_Id_ ,Start_Time_ ,End_Time_ ,Working_Hours_,Ot_,
        Loading_,Normal_Rate_,Ot_Rate_,Loading_Rate_,Working_Total_,Ot_Total_,Loading_Total_,'',false);
SELECT i + 1 INTO i;
END WHILE;
if Wastage_Length_>0 then
set i=0;
WHILE i < JSON_LENGTH(Shift_End_Details_Wastage_) DO
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details_Wastage_,CONCAT('$[',i,'].Wastage_Id'))) INTO Wastage_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details_Wastage_,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Item_Stock_Id_Wastage_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details_Wastage_,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_Wastage_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details_Wastage_,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_Wastage_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details_Wastage_,CONCAT('$[',i,'].Quantitypers'))) INTO Quantitypers_;        
/*SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details_Wastage_,CONCAT('$[',i,'].Warehouse_Id'))) INTO Warehouse_Id_Wastage_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_End_Details_Wastage_,CONCAT('$[',i,'].Warehouse_Name'))) INTO Warehouse_Name_Wastage_;        
*/
INSERT INTO shift_end_details_wastage(Shift_End_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Warehouse_Id,Warehouse_Name,DeleteStatus )
values (Shift_End_Master_Id_,Wastage_Id_,Item_Id_,Item_Stock_Id_Wastage_,Item_Name_Wastage_,Stock_Id_Wastage_,Quantitypers_,0,'',false);        
update Stock_Details Set Quantity=Quantity+Quantitypers_ where Stock_Id=Stock_Id_Wastage_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_;          
SELECT i + 1 INTO i;
END WHILE;  
end if;
 /*if(Stock_Add_Status_ =1 )then
set Proforma_Invoice_Details_Id_=(select Proforma_Invoice_Details_Id from production_master where Production_Master_Id=Production_Master_Id_);
update Stock_Details Set Stock_Details.Quantity=Stock_Details.Quantity+Acceptable_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_;    
update proforma_invoice_details Set proforma_invoice_details.Produced_Quantity=proforma_invoice_details.Produced_Quantity+Acceptable_
where Proforma_Invoice_Details_Id = Proforma_Invoice_Details_Id_;    
    end if;*/
COMMIT;
select Shift_End_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Shift_Start`( In Shift_Start_Master_Id_ int,Production_Master_Id_ int,Shift_End_Master_Id_ int,
Date_ Datetime,PONo_ int,Prodction_No_ int,User_Id_ int,Stock_Id_ int,Item_Id_ int,Item_Name_ varchar(500),WareHouse_Id_ int,WareHouse_Name_ varchar(500),
Quantity_ decimal(18,3),Shift_Start_Status_ int,Company_Id_ int,Weight_ decimal(18,2),Batch_Weight_ decimal(18,2),Weight_Item_ decimal(18,2),
Process_Id_Shift_ int,Shift_Details_Id_ int,Purchase_Order_Master_Id_ int,Process_Length_ int,Raw_Length_ int,Wastage_Length_ int,
Shift_Start_Details_Process_ JSON,Shift_Start_Details_RawMaterial_ JSON,Shift_Start_Details_Wastage_ JSON)
Begin 
    DECLARE Process_List_Id_ int;DECLARE Process_Name_ varchar(100);DECLARE Process_Id_ int;DECLARE Raw_Material_Id_ int;declare Item_Stock_Id_Raw_ int; 
    DECLARE Stock_Id_Raw_ int;declare No_Quantity_ decimal(18,3);DECLARE Weight_Quantity_ decimal(18,3);DECLARE Wastage_Id_ int; 
    declare Item_Stock_Id_Wastage_ int; DECLARE Stock_Id_Wastage_ int; DECLARE Quantitypers_ decimal(18,3);declare Shiftsatrt_status int;
    declare Item_Name_Wastage_ VARCHAR(500); declare Warehouse_Id_Wastage_ int; declare Warehouse_Name_Wastage_ varchar(500); 
    declare Item_Name_Raw_ VARCHAR(500);declare Warehouse_Id_Raw_ int;declare Shift_Start_No_ int;declare Warehouse_Name_Raw_ VARCHAR(500);
    declare NewQty_ decimal(18,3);Declare i int Default 0;
   /* DECLARE exit handler for sqlexception
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
	if  Shift_Start_Master_Id_>0
		THEN 
        set Shiftsatrt_status = (select count(Shift_Start_Master_Id)from shift_start_master 
        where DeleteStatus=0 and Master_Status=1 and Shift_Start_Master_Id=Shift_Start_Master_Id_);
	  if(Shiftsatrt_status>0)then
			set Shift_Start_Master_Id_=-1;
	  else 
       call Update_Stock_Fromshift_start_details_Raw(Shift_Start_Master_Id_,Company_Id_);
		delete from shift_start_details_process where Shift_Start_Master_Id=Shift_Start_Master_Id_;
		delete from shift_start_details_rawmaterial where Shift_Start_Master_Id=Shift_Start_Master_Id_;
		delete from shift_start_details_wastage where Shift_Start_Master_Id=Shift_Start_Master_Id_;
		UPDATE shift_start_master set Production_Master_Id=Production_Master_Id_, Company_Id=Company_Id_,  Date = Date_ ,PONo=PONo_,
		Prodction_No = Prodction_No_ ,User_Id = User_Id_,Stock_Id = Stock_Id_ ,Item_Id = Item_Id_ ,Item_Name = Item_Name_ ,
		Shift_End_Master_Id=Shift_End_Master_Id_,WareHouse_Id = WareHouse_Id_ ,WareHouse_Name = WareHouse_Name_ ,
        Quantity = Quantity_, Batch_Weight=Batch_Weight_,Weight=Weight_,Weight_Item=Weight_Item_,
        Process_Id=Process_Id_Shift_,Shift_Details_Id=Shift_Details_Id_,Purchase_Order_Master_Id=Purchase_Order_Master_Id_
        Where Shift_Start_Master_Id = Shift_Start_Master_Id_ ;
     end if;
	ELSE 
		#SET Prodction_No_ = (SELECT  COALESCE( MAX(Prodction_No ),0)+1 FROM shift_start_master); 
        SET Shift_Start_No_ = (SELECT  COALESCE( MAX(Shift_Start_No ),0)+1 FROM shift_start_master);         
		SET Shift_Start_Master_Id_ = (SELECT  COALESCE( MAX(Shift_Start_Master_Id ),0)+1 FROM shift_start_master); 
		INSERT INTO Shift_Start_Master(Shift_Start_Master_Id ,Production_Master_Id,Shift_End_Master_Id,Date ,PONo,Prodction_No ,
        Shift_Start_No,User_Id ,Stock_Id ,Item_Id ,Item_Name ,WareHouse_Id ,WareHouse_Name ,
        Quantity,Shift_Start_Status,Master_Status,Company_Id,
        Weight,Batch_Weight,Weight_Item,Process_Id,Shift_Details_Id,Purchase_Order_Master_Id,DeleteStatus ) 
		values (Shift_Start_Master_Id_ ,Production_Master_Id_,0,Date_ ,PONo_,Prodction_No_ ,Shift_Start_No_,User_Id_ ,
        Stock_Id_ ,Item_Id_ ,Item_Name_ ,WareHouse_Id_ ,WareHouse_Name_ ,Quantity_,7,0,Company_Id_,
        Weight_,Batch_Weight_,Weight_Item_,Process_Id_Shift_,Shift_Details_Id_,Purchase_Order_Master_Id_,false);
		/*update Purchase_Order_Master set Order_Status= 8 where Purchase_Order_Master_Id=(select distinct Purchase_Order_Master_Id from Shipment_Master
		inner join Proforma_Invoice_Master on Proforma_Invoice_Master.Shipment_Master_Id=Shipment_Master.Shipment_Master_Id 
		inner join production_master on Proforma_Invoice_Master.Proforma_Invoice_Master_Id=production_master.Proforma_Invoice_Master_Id 
		inner join Shift_Start_Master on production_master.Production_Master_Id=Shift_Start_Master.Production_Master_Id
		and Shift_Start_Master.Production_Master_Id=Production_Master_Id_);
		update Production_Master set Master_Status=1 ,Shift_Start_Master_Id=Shift_Start_Master_Id_ where Production_Master_Id=Production_Master_Id_;
		*/

        insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
		values(User_Id_,Date_,Shift_Start_Master_Id_,'Shift Start Master',7,'',Purchase_Order_Master_Id_,False);
End If ;
if(Shift_Start_Master_Id_>0)then
	if Process_Length_>0 then
	WHILE i < JSON_LENGTH(Shift_Start_Details_Process_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Process_,CONCAT('$[',i,'].Process_List_Id'))) INTO Process_List_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Process_,CONCAT('$[',i,'].Process_Id'))) INTO Process_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Process_,CONCAT('$[',i,'].Process_Name'))) INTO Process_Name_;		
		#SELECT JSON_UNQUOTE (JSON_EXTRACT(User_Department,CONCAT('$[',i,']. Check_Box_VIew_All'))) INTO VIew_All_;
		#set VIew_All_1=VIew_All_;
		INSERT INTO shift_start_details_process(Shift_Start_Master_Id,Process_List_Id,Item_Id,Process_Id,Process_Name,DeleteStatus )
		values (Shift_Start_Master_Id_,Process_List_Id_,Item_Id_,Process_Id_,Process_Name_,false);  
		SELECT i + 1 INTO i;
	END WHILE;  
	end if;
	if Wastage_Length_>0 then
	set i=0;
	WHILE i < JSON_LENGTH(Shift_Start_Details_Wastage_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Wastage_,CONCAT('$[',i,'].Wastage_Id'))) INTO Wastage_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Wastage_,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Item_Stock_Id_Wastage_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Wastage_,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_Wastage_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Wastage_,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_Wastage_;
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Wastage_,CONCAT('$[',i,'].Quantitypers'))) INTO Quantitypers_;	        
		#SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Wastage_,CONCAT('$[',i,'].Warehouse_Id'))) INTO Warehouse_Id_Wastage_;
        #SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_Wastage_,CONCAT('$[',i,'].Warehouse_Name'))) INTO Warehouse_Name_Wastage_;        
		INSERT INTO shift_start_details_wastage(Shift_Start_Master_Id,Wastage_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,Quantitypers,Warehouse_Id,Warehouse_Name,DeleteStatus )
		values (Shift_Start_Master_Id_,Wastage_Id_,Item_Id_,Item_Stock_Id_Wastage_,Item_Name_Wastage_,Stock_Id_Wastage_,Quantitypers_,Warehouse_Id_Wastage_,Warehouse_Name_Wastage_,false); 
		SELECT i + 1 INTO i;
	END WHILE;  
	end if;
	if Raw_Length_>0 then
    	set i=0;        
    WHILE i < JSON_LENGTH(Shift_Start_Details_RawMaterial_) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_RawMaterial_,CONCAT('$[',i,'].Raw_Material_Id'))) INTO Raw_Material_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_RawMaterial_,CONCAT('$[',i,'].Item_Stock_Id'))) INTO Item_Stock_Id_Raw_;        
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_RawMaterial_,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_Raw_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_RawMaterial_,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_Raw_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_RawMaterial_,CONCAT('$[',i,'].No_Quantity'))) INTO No_Quantity_;	        
		#SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_RawMaterial_,CONCAT('$[',i,'].Warehouse_Id'))) INTO Warehouse_Id_Raw_;
		#SELECT JSON_UNQUOTE (JSON_EXTRACT(Shift_Start_Details_RawMaterial_,CONCAT('$[',i,'].Warehouse_Name'))) INTO Warehouse_Name_Raw_;        
		INSERT INTO shift_start_details_rawmaterial(Shift_Start_Master_Id,Raw_Material_Id,Item_Id,Item_Stock_Id,Item_Name,Stock_Id,No_Quantity,Warehouse_Id,Warehouse_Name,DeleteStatus )
		values (Shift_Start_Master_Id_,Raw_Material_Id_,Item_Id_,Item_Stock_Id_Raw_,Item_Name_Raw_,Stock_Id_Raw_,No_Quantity_,Warehouse_Id_Raw_,Warehouse_Name_Raw_,false);  
		set NewQty_=round((No_Quantity_),3);
       update Stock_Details Set Quantity=Quantity-NewQty_ where Stock_Id=Stock_Id_Raw_ and WareHouse_Id = WareHouse_Id_ and Company_Id=Company_Id_;
       SELECT i + 1 INTO i;
	END WHILE; 
	end if;
end if;
	#COMMIT;
	select Shift_Start_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Shipment_Method`( In Shipment_Method_Id_ int,Shipment_Method_Name_ varchar(500),Status_ varchar(50),DeleteStatus_ tinyint)
Begin 
 if  Shipment_Method_Id_>0
 THEN 
 UPDATE shipment_method set Shipment_Method_Id = Shipment_Method_Id_ ,Shipment_Method_Name = Shipment_Method_Name_ ,Status=Status_
Where Shipment_Method_Id = Shipment_Method_Id_;
 ELSE 
 SET Shipment_Method_Id_ = (SELECT  COALESCE( MAX(Shipment_Method_Id ),0)+1 FROM shipment_method); 
 INSERT INTO shipment_method(Shipment_Method_Id,Shipment_Method_Name ,Status ,DeleteStatus ) 
 values (Shipment_Method_Id_ ,Shipment_Method_Name_ ,Status_ ,false);
 End If ;
 select Shipment_Method_Id_;
# insert into db_logs values(Email_,Status_,1,1);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Shipment_Plan`( In Shipment_Plan_Id_ int,Shipment_Plan_Name_ varchar(500),Status_ varchar(50),DeleteStatus_ tinyint)
Begin 
 if  Shipment_Plan_Id_>0
 THEN 
 UPDATE shipment_plan set Shipment_Plan_Id = Shipment_Plan_Id_ ,Shipment_Plan_Name = Shipment_Plan_Name_ ,
Status = Status_ Where Shipment_Plan_Id = Shipment_Plan_Id_   ;
 ELSE 
 SET Shipment_Plan_Id_ = (SELECT  COALESCE( MAX(Shipment_Plan_Id ),0)+1 FROM shipment_plan); 
 INSERT INTO shipment_plan(Shipment_Plan_Id ,Shipment_Plan_Name ,Status ,DeleteStatus ) 
 values (Shipment_Plan_Id_ ,Shipment_Plan_Name_ ,Status_ ,false);
 End If ;
 select Shipment_Plan_Id_;
 #insert into db_logs values(1,Shipment_Plan_Name_,1,1);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Shipping_List`(In Docs_ Json,Document_value_ int)
BEGIN
declare Purchase_Order_Master_Id_ int;declare Sales_Master_Id_ int;declare BI_No_ Varchar(500);declare ETA_ varchar(500);declare Status_ Varchar(500);declare Tracking_Id_ varchar(500);
declare BL_ Varchar(500);declare BL_FileName_ Varchar(500);declare PackingList_ Varchar(500);declare PackingList_FileName_ Varchar(500);declare Invoice_ Varchar(500);declare Invoice_FileName_ Varchar(500);
if( Document_value_>0) then
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Sales_Master_Id')) INTO Sales_Master_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.BI_No')) INTO BI_No_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.ETA')) INTO ETA_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Status')) INTO Status_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Tracking_Id')) INTO Tracking_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.BL')) INTO BL_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.BL_FileName')) INTO BL_FileName_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.PackingList')) INTO PackingList_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.PackingList_FileName')) INTO PackingList_FileName_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Invoice')) INTO Invoice_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Docs_,'$.Invoice_FileName')) INTO Invoice_FileName_;

	set Purchase_Order_Master_Id_=(select Purchase_Order_Master_Id from Sales_Master where Sales_Master_Id=Sales_Master_Id_); 

	update sales_master set BI_No=BI_No_,ETA=ETA_,Status=Status_,Tracking_Id=Tracking_Id_,Shipment_Status=1,Details_Date=now(),BL = BL_,BL_FileName = BL_FileName_,PackingList = PackingList_,
    PackingList_FileName = PackingList_FileName_,Invoice = Invoice_ , Invoice_FileName = Invoice_FileName_
    where Sales_Master_Id=Sales_Master_Id_;
	update purchase_order_master set Order_Status=15 where Purchase_Order_Master_Id=Purchase_Order_Master_Id_;
	insert into Order_Tracking_History(User_Id,Date,Master_Id,Order_Type,Order_Status,Description,PoMasterId,DeleteStatus)
	values(0,now(),Sales_Master_Id_,'Shipping List',15,'',Purchase_Order_Master_Id_,False);
end if;

select Sales_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Stock_Add_Details`( In Stock_Add_Details JSON , Stock_Add_Master_Id_ decimal(18,0) ,Company_Id_ int)
Begin  
DECLARE ItemId_ decimal(18,0); DECLARE Barcode_ varchar(1000); DECLARE Group_Id_ decimal(18,0); DECLARE Group_Name_ varchar(100);
DECLARE Unit_Id_ decimal(18,0); DECLARE Unit_Name_ varchar(100);DECLARE PurchaseRate_ decimal(18,2); DECLARE SaleRate_ decimal(18,2);
DECLARE MRP_ decimal(18,2);DECLARE HSN_Id_ int; DECLARE HSN_CODE_ varchar(50); DECLARE Quantity_ decimal(18,2); DECLARE CGST_ decimal(18,2);
DECLARE SGST_ decimal(18,2); DECLARE StockId_ decimal(18,0);   DECLARE IGST_ decimal(18,2);DECLARE Is_Expiry_ varchar(100);
DECLARE Expiry_Date_ datetime;DECLARE ItemName_ varchar(1000); DECLARE Packing_Size_ varchar(500);DECLARE Colour_ varchar(500);
DECLARE Description_ varchar(500);DECLARE MFCode_ varchar(500);DECLARE UPC_ varchar(500);DECLARE Unit_Price_ varchar(500);
DECLARE GST_ varchar(500);DECLARE WareHouse_Id_ int;DECLARE WareHouse_Name_ varchar(500);DECLARE Weight_ int;DECLARE Product_Code_ varchar(100);
DECLARE i int  DEFAULT 0;
WHILE i < JSON_LENGTH(Stock_Add_Details) DO    
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].ItemId'))) INTO ItemId_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Product_Code'))) INTO Product_Code_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].ItemName'))) INTO ItemName_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Packing_Size'))) INTO Packing_Size_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Colour'))) INTO Colour_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Weight'))) INTO Weight_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Description'))) INTO Description_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Unit_Id'))) INTO Unit_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Unit_Name'))) INTO Unit_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Group_Id'))) INTO Group_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Group_Name'))) INTO Group_Name_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].HSN_Id'))) INTO HSN_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].HSN_CODE'))) INTO HSN_CODE_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].MFCode'))) INTO MFCode_;        
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].UPC'))) INTO UPC_;      
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].GST'))) INTO GST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].StockId'))) INTO StockId_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].PurchaseRate'))) INTO PurchaseRate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].SaleRate'))) INTO SaleRate_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].MRP'))) INTO MRP_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].CGST'))) INTO CGST_;  
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].SGST'))) INTO SGST_;    
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].IGST'))) INTO IGST_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Is_Expiry'))) INTO Is_Expiry_;
if(Is_Expiry_='true')
  then
  set Is_Expiry_=1;
  else set Is_Expiry_=0;
  end if;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;
       #SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Add_Details,CONCAT('$[',i,'].Expiry_Date'))) INTO Expiry_Date_; 
if exists(select Stock_Id from Stock where ItemId=ItemId_ and DeleteStatus=False)
then
set StockId_=(select Stock_Id from Stock where ItemId=ItemId_ and DeleteStatus=False order by Stock_Id desc Limit 1);
update Stock set ItemId=ItemId_,BarCode=Barcode_,ItemName=ItemName_,Group_Id=Group_Id_,Group_Name=Group_Name_,Packing_Size=Packing_Size_,Colour=Colour_,Description =Description_, MFCode=MFCode_, UPC=UPC_,
Unit_Id=Unit_Id_,Unit_Name=Unit_Name_,PurchaseRate=PurchaseRate_,SaleRate=SaleRate_,MRP=MRP_, HSN_Id=HSN_Id_,HSN_CODE=HSN_CODE_,GST=GST_,CGST=CGST_,SGST=SGST_,IGST=IGST_,Product_Code=Product_Code_
where Stock_Id=StockId_;
else
insert into Stock(ItemId,ItemName,Barcode,Packing_Size,Colour,Weight,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE, MFCode,UPC,MRP,SaleRate,PurchaseRate,CGST,SGST,IGST,GST,Product_Code,DeleteStatus)
values(ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Weight_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_, MFCode_,UPC_,MRP_,SaleRate_,PurchaseRate_,CGST_,SGST_,IGST_,GST_,Product_Code_,False);
set StockId_ =(SELECT LAST_INSERT_ID());
end if;  
INSERT INTO Stock_Add_Details(Stock_Add_Master_Id,StockId,ItemId,ItemName,Barcode,Packing_Size,Colour,Weight,Description,Unit_Id,Unit_Name,Group_Id,Group_Name,HSN_Id,HSN_CODE,WareHouse_Id,WareHouse_Name,MFCode,UPC,MRP,SaleRate,PurchaseRate,Quantity,CGST,SGST,IGST,GST,Product_Code, DeleteStatus)
values (Stock_Add_Master_Id_,StockId_,ItemId_,ItemName_,Barcode_,Packing_Size_,Colour_,Weight_,Description_,Unit_Id_,Unit_Name_,Group_Id_,Group_Name_,HSN_Id_,HSN_CODE_,WareHouse_Id_,WareHouse_Name_,MFCode_,UPC_,MRP_,SaleRate_,PurchaseRate_,Quantity_,CGST_,SGST_,IGST_,GST_,Product_Code_,false);
if exists(select Stock_Details_Id from Stock_Details where Stock_Id = StockId_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_)
then        
update Stock_Details set Quantity = Quantity + Quantity_ where Stock_Id=StockId_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_;
else
INSERT INTO Stock_Details(Stock_Id,WareHouse_Id,Quantity,Company_Id,DeleteStatus )
values (StockId_,WareHouse_Id_,Quantity_,Company_Id_,false);
end if;
SELECT i + 1 INTO i;
END WHILE;    
SELECT Stock_Add_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Stock_Add_Master`( In Stock_Add_Master_Id_ int,
Entry_Date_ datetime,Description1_ varchar(1000),User_Id_ decimal(18,0),Purchase_Type_Id_ int,
Company_Id_ int,Stock_Add_Details JSON)
Begin
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
 if  Stock_Add_Master_Id_>0
THEN
     CALL Update_Stock (Stock_Add_Master_Id_,Company_Id_);
Delete From Stock_Add_Details Where  Stock_Add_Master_Id=Stock_Add_Master_Id_ ;
     UPDATE Stock_Add_Master set Entry_Date = Entry_Date_ ,Description1 = Description1_ ,User_Id = User_Id_ ,
     Purchase_Type_Id=Purchase_Type_Id_ ,Company_Id=Company_Id_
     Where Stock_Add_Master_Id=Stock_Add_Master_Id_ ;
ELSE
SET Stock_Add_Master_Id_ = (SELECT COALESCE( MAX(Stock_Add_Master_Id ),0)+1 FROM Stock_Add_Master);
INSERT INTO Stock_Add_Master(Stock_Add_Master_Id ,Entry_Date ,Description1 ,User_Id ,Purchase_Type_Id ,Company_Id,DeleteStatus )
values (Stock_Add_Master_Id_ ,Entry_Date_ ,Description1_ ,User_Id_ ,Purchase_Type_Id_,Company_Id_,false);
End If ;
/*if Stock_Add_Master_Id_=0 then
set Stock_Add_Master_Id_ =(SELECT LAST_INSERT_ID());
end if;*/
 CALL Save_Stock_Add_Details(Stock_Add_Details  , Stock_Add_Master_Id_ ,Company_Id_);
 select Stock_Add_Master_Id_;
 #Commit;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Stock_Transfer_Details`( In Stock_Transfer_Details JSON,Stock_transfer_Master_Id_ int,From_Company_Id_ int,To_Company_Id_ int)
Begin 
    DECLARE Stock_Id_ int;DECLARE Item_Id_ int;DECLARE Item_Name_ varchar(1000);DECLARE Quantity_ decimal(18,3);DECLARE Barcode_ Varchar(100);
    DECLARE From_Stock_Id_ int;DECLARE From_Stock_Name_ VARCHAR(100);DECLARE To_Stock_Id_ int;DECLARE To_Stock_Name_ varchar(4500);
   DECLARE i int  DEFAULT 0;
	WHILE i < JSON_LENGTH(Stock_Transfer_Details) DO
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].Barcode'))) INTO Barcode_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;         
        SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].From_Stock_Id'))) INTO From_Stock_Id_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].From_Stock_Name'))) INTO From_Stock_Name_;
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].To_Stock_Id'))) INTO To_Stock_Id_;		     
		SELECT JSON_UNQUOTE (JSON_EXTRACT(Stock_Transfer_Details,CONCAT('$[',i,'].To_Stock_Name'))) INTO To_Stock_Name_;    
		INSERT INTO Stock_Transfer_Details(Stock_transfer_Master_Id ,Stock_Id ,Item_Id ,Item_Name ,Barcode,Quantity ,From_Stock_Id ,From_Stock_Name , To_Stock_Id ,To_Stock_Name ,DeleteStatus ) 
		values (Stock_transfer_Master_Id_ ,Stock_Id_ ,Item_Id_ ,Item_Name_ ,Barcode_,Quantity_ ,From_Stock_Id_ ,From_Stock_Name_ , To_Stock_Id_ ,To_Stock_Name_ ,false);
		update Stock_Details Set Quantity=Quantity-Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = From_Stock_Id_ and Company_Id=From_Company_Id_;
        if exists(select Stock_Details_Id from Stock_Details where Stock_Id = Stock_Id_ and WareHouse_Id = To_Stock_Id_ and Company_Id=To_Company_Id_)
        then        
			update Stock_Details set Quantity = Quantity + Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = To_Stock_Id_ and Company_Id=To_Company_Id_;
        else
			INSERT INTO Stock_Details(Stock_Id,WareHouse_Id,Quantity,Company_Id,DeleteStatus) 
			values (Stock_Id_,To_Stock_Id_,Quantity_,To_Company_Id_,false);
        end if;
		SELECT i + 1 INTO i;
	END WHILE;  
SELECT Stock_transfer_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Stock_Transfer_Master`( In Stock_transfer_Master_Id_ int,
Entry_Date_ datetime,User_Id_  int,Description1_ varchar(2000),From_Company_Id_ int,To_Company_Id_ int,
 Stock_Transfer_Details JSON)
Begin
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
 if  Stock_transfer_Master_Id_>0
 THEN
call Update_Stock_From_Stock_Transfer(Stock_transfer_Master_Id_,From_Company_Id_,To_Company_Id_);
  Delete From Stock_Transfer_Details Where Stock_transfer_Master_Id=Stock_transfer_Master_Id_;
 # delete from Accounts where Tran_Id=Sales_Master_Id_ and Tran_Type='SA';
UPDATE Stock_Transfer_Master set Entry_Date=Entry_Date_,Description1=Description1_ , User_Id = User_Id_ ,
 From_Company_Id=From_Company_Id_ ,To_Company_Id=To_Company_Id_
 Where Stock_transfer_Master_Id=Stock_transfer_Master_Id_ ;
 ELSE
SET Stock_transfer_Master_Id_ = (SELECT  COALESCE( MAX(Stock_transfer_Master_Id ),0)+1 FROM Stock_Transfer_Master);
 INSERT INTO Stock_Transfer_Master(Stock_transfer_Master_Id,Entry_Date,Description1,User_Id,From_Company_Id,To_Company_Id,DeleteStatus ) 
values (Stock_transfer_Master_Id_,Entry_Date_,Description1_,User_Id_,From_Company_Id_,To_Company_Id_,False );
 End If ;
CALL Save_Stock_Transfer_Details(Stock_Transfer_Details ,Stock_transfer_Master_Id_,From_Company_Id_,To_Company_Id_ );  
 select Stock_transfer_Master_Id_;
  #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_User_Details`( In User_Details_Id_ decimal,User_Details_Name_ varchar(250),
Password_ varchar(250),Working_Status_ varchar(250),
User_Type_ int,Role_Id_ decimal,Address1_ varchar(250),Address2_ varchar(250),Address3_ varchar(250),
Address4_ varchar(250),Pincode_ varchar(250),Mobile_ varchar(250),Email_ varchar(250),
Employee_Id_ int,User_Menu_Selection JSON)
BEGIN

	DECLARE Menu_Id_ int;DECLARE IsEdit_ varchar(25);DECLARE IsSave_ varchar(25);
	DECLARE IsDelete_ varchar(25);DECLARE IsView_ varchar(25);	DECLARE Menu_Status_ varchar(25);
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
    
	if  User_Details_Id_>0
		THEN 
		delete from User_Menu_Selection where User_Id=User_Details_Id_;
		UPDATE User_Details set User_Details_Name = User_Details_Name_ ,Password = Password_ ,Working_Status = Working_Status_ ,
		User_Type = User_Type_ ,Role_Id = Role_Id_ ,Address1 = Address1_ ,Address2 = Address2_ ,Address3 = Address3_ ,
		Address4 = Address4_ ,Pincode = Pincode_ ,Mobile = Mobile_ ,Email = Email_,Employee_Id=Employee_Id_ 
		Where User_Details_Id=User_Details_Id_ ;
	ELSE 
		SET User_Details_Id_ = (SELECT  COALESCE( MAX(User_Details_Id ),0)+1 FROM User_Details); 
		INSERT INTO User_Details(User_Details_Id ,User_Details_Name ,Password ,Working_Status ,User_Type ,Role_Id ,
		Address1 ,Address2 ,Address3 ,Address4 ,Pincode ,Mobile ,Email ,Employee_Id,DeleteStatus ) 
		values (User_Details_Id_ ,User_Details_Name_ ,Password_ ,Working_Status_ ,User_Type_ ,
		Role_Id_ ,Address1_ ,Address2_ ,Address3_ ,Address4_ ,Pincode_ ,Mobile_ ,Email_ ,Employee_Id_,false);
	End If ;
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
  #COMMIT;
 select User_Details_Id_;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Warehouse`( In WareHouse_Id_ int,WareHouse_Name_ varchar(500),Status_ varchar(50),DeleteStatus_ tinyint)
Begin 
 if  WareHouse_Id_>0
 THEN 
 UPDATE warehouse set WareHouse_Id = WareHouse_Id_ ,WareHouse_Name = WareHouse_Name_ ,
Status = Status_ Where WareHouse_Id = WareHouse_Id_;
 ELSE 
 SET WareHouse_Id_ = (SELECT  COALESCE( MAX(WareHouse_Id ),0)+1 FROM warehouse); 
 INSERT INTO warehouse(WareHouse_Id ,WareHouse_Name ,Status ,DeleteStatus ) 
 values (WareHouse_Id_ ,WareHouse_Name_ ,Status_ ,false);
 End If ;
 select WareHouse_Id_;
 #insert into db_logs values(1,Shipment_Plan_Name_,1,1);
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Waste_In_Details`( In Waste_In_Details JSON,Waste_In_Master_Id_ int,Company_Id_ int)
Begin 
	DECLARE Item_Id_ int;DECLARE Item_Name_ varchar(1000);	DECLARE Quantity_ decimal(18,3);    	DECLARE i int  DEFAULT 0;
    DECLARE Stock_Id_ int; DECLARE WareHouse_Id_ int; DECLARE WareHouse_Name_ varchar(500);
    Declare Stock_Details_id_ int;
	
		WHILE i < JSON_LENGTH(Waste_In_Details) DO
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_In_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_In_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;            
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_In_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;            
            SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_In_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;            
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_In_Details,CONCAT('$[',i,'].WareHouse_Id'))) INTO WareHouse_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_In_Details,CONCAT('$[',i,'].WareHouse_Name'))) INTO WareHouse_Name_;            

			INSERT INTO Waste_In_Details(Waste_In_Master_Id ,Stock_Id,Item_Id ,Item_Name ,WareHouse_Id,WareHouse_Name,Quantity ,DeleteStatus ) 
			values (Waste_In_Master_Id_ ,Stock_Id_,Item_Id_ ,Item_Name_ ,WareHouse_Id_,WareHouse_Name_, Quantity_ ,false);			
            
           /* if exists(select Stock_Details_Id from Stock_Details where Stock_Id = Stock_Id_ and WareHouse_Id = WareHouse_Id_)
			then        
				update Stock_Details set Quantity = Quantity + Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_;
			else
				INSERT INTO Stock_Details(Stock_Id,WareHouse_Id,Quantity,DeleteStatus ) 
				values (Stock_Id_,WareHouse_Id_,Quantity_,false);
			end if;*/
            
		SELECT i + 1 INTO i;
		END WHILE;
  
SELECT Waste_In_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Waste_In_Master`( In Waste_In_Master_Id_ int,Client_Accounts_Id_ int,Date_ datetime,
User_Id_  int,Company_Id_ int,  Waste_In_No_ varchar(50),Description_ varchar(4000), Waste_In_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;declare billtypes_ varchar(100);

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
/*
	set YearFrom=(select Account_Years.YearFrom from Account_Years where  
	Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
	set YearTo=(select Account_Years.YearTo from Account_Years where 
	Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
    */
 /*   
if exists(select distinct Invoice_No from Sales_Master)
then
	set Voucher_No_=(SELECT COALESCE( MAX(Invoice_No ),0)+1 FROM Sales_Master
	where BillType=BillType_ and Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and Date_Format(YearTo,'%Y-%m-%d'));  
else 
	if exists(select Invoice_No from General_Settings)
	then
		set Voucher_No_=(select COALESCE(Invoice_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;    
end if;
*/
 if  Waste_In_Master_Id_>0
 THEN	
 #call Update_StockFrom_Wastein(Waste_In_Master_Id_,Company_Id_);
	Delete From Waste_In_Details Where Waste_In_Master_Id=Waste_In_Master_Id_;
		UPDATE Waste_In_Master set Client_Accounts_Id = Client_Accounts_Id_ ,Date=Date_, User_Id=User_Id_, Company_Id = Company_Id_ ,Waste_In_No=Waste_In_No_,Description=Description_
		Where Waste_In_Master_Id=Waste_In_Master_Id_ ;
 ELSE
	  SET Waste_In_Master_Id_ = (SELECT  COALESCE( MAX(Waste_In_Master_Id ),0)+1 FROM Waste_In_Master );
	  INSERT INTO Waste_In_Master(Waste_In_Master_Id,Client_Accounts_Id,Date,User_Id,Company_Id,Waste_In_No,Description,DeleteStatus ) 
	  values (Waste_In_Master_Id_,Client_Accounts_Id_,Date_,User_Id_,Company_Id_,Waste_In_No_,Description_,False );
 End If ; 
   /*if Waste_In_Master_Id_=0 then
			set Waste_In_Master_Id_ =(SELECT LAST_INSERT_ID());
		end if;*/
  
CALL Save_Waste_In_Details(Waste_In_Details ,Waste_In_Master_Id_,Company_Id_ );
  
 select Waste_In_Master_Id_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Waste_Out_Details`( In Waste_Out_Details JSON,Waste_Out_Master_Id_ int,Company_Id_ int)
Begin 
	DECLARE Item_Id_ int;DECLARE Item_Name_ varchar(1000);	Declare Stock_Id_ int;
    DECLARE Quantity_ decimal(18,3);   DECLARE i int  DEFAULT 0; declare Warehouse_Id_ int;
    declare Warehouse_Name_ Varchar(50);declare Rate_ decimal(18,2);declare Amount_ decimal(18,2);
		WHILE i < JSON_LENGTH(Waste_Out_Details) DO	
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Item_Id'))) INTO Item_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Item_Name'))) INTO Item_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Quantity'))) INTO Quantity_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Stock_Id'))) INTO Stock_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Warehouse_Id'))) INTO Warehouse_Id_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Warehouse_Name'))) INTO Warehouse_Name_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Rate'))) INTO Rate_;
			SELECT JSON_UNQUOTE (JSON_EXTRACT(Waste_Out_Details,CONCAT('$[',i,'].Amount'))) INTO Amount_;

			INSERT INTO Waste_Out_Details(Waste_Out_Master_Id ,Item_Id ,Item_Name ,Quantity ,Stock_Id,Warehouse_Id,Warehouse_Name,Rate,Amount,DeleteStatus ) 
			values (Waste_Out_Master_Id_ ,Item_Id_ ,Item_Name_ ,Quantity_ ,Stock_Id_,Warehouse_Id_,Warehouse_Name_,Rate_,Amount_,false);
			update Stock_Details set Quantity = Quantity - Quantity_ where Stock_Id=Stock_Id_ and WareHouse_Id = WareHouse_Id_ and Company_Id = Company_Id_  ;
						
		SELECT i + 1 INTO i;
		END WHILE;

SELECT Waste_Out_Master_Id_;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Save_Waste_Out_Master`( In Waste_Out_Master_Id_ int,Client_Accounts_Id_  int,Date_ datetime,
User_Id_  int,Company_Id_ int,  Waste_Out_No_ int,Weigh_Bridge_No_ varchar(50),Description_ varchar(4000), TotalAmount_ decimal(18,2),
Waste_Out_Details JSON)
Begin
declare Voucher_No_ varchar(50);declare Accounts_Id_ decimal;
declare YearFrom datetime;declare YearTo datetime;declare billtypes_ varchar(100);

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
/*
	set YearFrom=(select Account_Years.YearFrom from Account_Years where  
	Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
	set YearTo=(select Account_Years.YearTo from Account_Years where 
	Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(Account_Years.YearFrom,'%Y-%m-%d') and 
	Date_Format(Account_Years.YearTo,'%Y-%m-%d'));
    */
 /*   
if exists(select distinct Invoice_No from Sales_Master)
then
	set Voucher_No_=(SELECT COALESCE( MAX(Invoice_No ),0)+1 FROM Sales_Master
	where BillType=BillType_ and Date_Format(Entry_Date_,'%Y-%m-%d') between Date_Format(YearFrom,'%Y-%m-%d') and Date_Format(YearTo,'%Y-%m-%d'));  
else 
	if exists(select Invoice_No from General_Settings)
	then
		set Voucher_No_=(select COALESCE(Invoice_No,0) from General_Settings);
	else
		set Voucher_No_=1;
	end if;    
end if;
*/
 if  Waste_Out_Master_Id_>0
 THEN
 call Update_StockFrom_Wasteout(Waste_Out_Master_Id_,Company_Id_);
	Delete From Waste_Out_Details Where Waste_Out_Master_Id=Waste_Out_Master_Id_;    
  delete from Accounts where Tran_Id=Waste_Out_Master_Id_ and Tran_Type='WO';
		UPDATE Waste_Out_Master set Client_Accounts_Id = Client_Accounts_Id_ ,Date=Date_, User_Id=User_Id_, Company_Id = Company_Id_ ,Waste_Out_No=Waste_Out_No_,
		Weigh_Bridge_No=Weigh_Bridge_No_,Description=Description_,TotalAmount=TotalAmount_
		Where Waste_Out_Master_Id=Waste_Out_Master_Id_ ;
 ELSE
		SET Waste_Out_No_ = (SELECT  COALESCE( MAX(Waste_Out_No ),0)+1 FROM Waste_Out_Master where DeleteStatus=0);
		SET Waste_Out_Master_Id_ = (SELECT  COALESCE( MAX(Waste_Out_Master_Id ),0)+1 FROM Waste_Out_Master );
		INSERT INTO Waste_Out_Master(Waste_Out_Master_Id,Client_Accounts_Id,Date,User_Id,Company_Id,Waste_Out_No,Weigh_Bridge_No,Description,TotalAmount,DeleteStatus ) 
		values (Waste_Out_Master_Id_,Client_Accounts_Id_,Date_,User_Id_,Company_Id_,Waste_Out_No_,Weigh_Bridge_No_,Description_,TotalAmount_,False );
 End If ;
 
 if(TotalAmount_>0)
 then
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status)
		values(Accounts_Id_,Date_,Client_Accounts_Id_,0,TotalAmount_,6,'WO',Waste_Out_Master_Id_, 1,5,1,Description_,'','Y',1); 
	set Accounts_Id_=(select COALESCE( MAX(Accounts_Id ),0)+1 from Accounts);
		insert into Accounts(Accounts_Id,Entry_Date,Client_Id,Dr,Cr,X_Client_Id,Tran_Type,Tran_Id,Voucher_No, VoucherType,Mode,Description1,Status,DayBook,Payment_Status) 
		values(Accounts_Id_,Date_,6,TotalAmount_,0,Client_Accounts_Id_,'WO',Waste_Out_Master_Id_, 1 ,5,1,Description_,'','',1); 
 end IF;
CALL Save_Waste_Out_Details(Waste_Out_Details ,Waste_Out_Master_Id_,Company_Id_ );
  
 select Waste_Out_Master_Id_;
 #COMMIT;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Account_Group`( In Group_Name_ varchar(100))
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Account_Group_Typeahead`( In Group_Name_ varchar(100))
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_attendance_Report`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime)
Begin 
 declare Search_Date_ varchar(500);
 set Search_Date_="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and attendance_details.Employee_InDate >= '", From_Date_ ,"' and  attendance_details.Employee_OutDate <= '", To_Date_,"'");
end if;


SET @query = Concat("
		SELECT distinct (Date_Format(attendance_details.Employee_InDate,'%Y-%m-%d')) As Employee_InDate ,
        (Date_Format(attendance_details.Employee_InDate,'%d-%m-%Y')) As Search_Date ,
         Client_Accounts_Name,Employee_InTime,Employee_OutTime,Normal_Hrs,
        attendance_details.Normal_Rate,
        Normal_Total,Ot_Hrs,attendance_details.Ot_Rate,Ot_Total,Loading_Hrs,attendance_details.Loading_Rate,
        Loading_Total,No_Of_Piece,
        Piece_Rate,Piece_Total,Other_Work,Other_Start_Time,Other_End_Time,
        Other_Total_Hrs,Other_Rate,Other_Total,Total,Process_Details_Name
	    From attendance_details 
        inner join client_accounts on client_accounts.Client_Accounts_Id=attendance_details.Employee_Id
        inner join employee_details on employee_details.Client_Accounts_Id=client_accounts.Client_Accounts_Id
		inner join process_list on process_list.Process_Id=employee_details.Process_Id
         inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
		where attendance_details.DeleteStatus=false  ", Search_Date_ ," Order By  Attendance_Details_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Check_In`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and attendance_master.Employee_InDate >= '", From_Date_ ,"' and  attendance_master.Employee_InDate <= '", To_Date_,"'");
end if;
SET @query = Concat(" SELECT (Date_Format(attendance_master.Employee_InDate,'%Y-%m-%d')) As Employee_InDate ,
	(Date_Format(attendance_master.Employee_InDate,'%d-%m-%Y')) As Search_Date,
   Attendance_Master_Id, Employee_InTime,Attendance_Status,
    Employee_OutTime, Employee_InUser_Id, Employee_OutUser_Id
	From attendance_master
	where attendance_master.DeleteStatus=false ", Search_Date_ , " Order By  Attendance_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Check_In_Details`(In Is_Date_Check_ varchar(50),From_Date_ datetime,To_Date_ datetime)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and attendance_master.Employee_InDate >= '", From_Date_ ,"' and  attendance_master.Employee_InDate <= '", To_Date_,"'");
end if;
 SELECT client_accounts.Client_Accounts_Id Employee_Id,client_accounts.Client_Accounts_Name,
ifnull(Attendance_Details.Attendance_Details_Id,0) Attendance_Details_Id,
ifnull(Attendance_Details.Attendance_Master_Id,0) Attendance_Master_Id,
ifnull(Attendance_Details.Normal_Rate,0) Normal_Rate,
ifnull(Attendance_Details.Ot_Rate,0) Ot_Rate,
ifnull(Attendance_Details.Loading_Rate,0) Loading_Rate,
case when Attendance_Details.Is_Employee>0 then 1 else 0 end as Check_Box,Process_Details_Name,
 (Date_Format(Attendance_Details.Employee_InDate,'%Y-%m-%d')) As Employee_InDate,
	(Date_Format(Attendance_Details.Employee_InDate,'%d-%m-%Y')) As Search_Date,Employee_InTime
from employee_details
inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
inner join client_accounts  on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id 
inner join Attendance_Details on employee_details.Client_Accounts_Id=Attendance_Details.Employee_Id 
where attendance_details.DeleteStatus=false and attendance_details.Employee_InDate= From_Date_
and attendance_details.Punch_Status =0
 Order By  Client_Accounts_Name asc;
select Attendance_Master_Id, (Date_Format(Attendance_Master.Employee_InDate,'%Y-%m-%d')) As Employee_InDate,Employee_InTime from Attendance_Master
where Attendance_Master.DeleteStatus=false and Attendance_Status =0 and Attendance_Master.Employee_InDate =  From_Date_ 
Order By  Attendance_Master_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Check_In_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and attendance_master.Employee_InDate >= '", From_Date_ ,"' and  attendance_master.Employee_InDate <= '", To_Date_,"'");
end if;
SET @query = Concat(" SELECT (Date_Format(attendance_master.Employee_InDate,'%Y-%m-%d')) As Employee_InDate ,
	(Date_Format(attendance_master.Employee_InDate,'%d-%m-%Y')) As Search_Date,
   attendance_master.Attendance_Master_Id, attendance_master.Employee_InTime,Attendance_Status,
   client_accounts.Client_Accounts_Name as Client_Accounts_Name
    ,attendance_master.Employee_OutTime, Employee_InUser_Id, Employee_OutUser_Id
	From employee_details
    inner join  Process_Details on employee_details.Process_Id=Process_Details.Process_Details_Id
	inner join client_accounts  on client_accounts.Client_Accounts_Id = employee_details.Client_Accounts_Id
	left join Attendance_Details on employee_details.Client_Accounts_Id=Attendance_Details.Employee_Id  
	inner join attendance_master  on attendance_master.Attendance_Master_Id = attendance_details.Attendance_Master_Id 
	where attendance_master.DeleteStatus=false ", Search_Date_ , " Order By  Attendance_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Check_Out`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and attendance_master.Employee_OutDate >= '", From_Date_ ,"' and  attendance_master.Employee_OutDate <= '", To_Date_,"'");
end if;
SET @query = Concat(" SELECT (Date_Format(attendance_master.Employee_InDate,'%Y-%m-%d')) As Employee_InDate ,
	(Date_Format(attendance_master.Employee_OutDate,'%d-%m-%Y')) As Search_Date,
   Attendance_Master_Id, Employee_InTime,Attendance_Status,
	(Date_Format(attendance_master.Employee_OutDate,'%Y-%m-%d')) As Employee_OutDate ,
    Employee_OutTime, Employee_InUser_Id, Employee_OutUser_Id
	From attendance_master
	where attendance_master.DeleteStatus=false ", Search_Date_ , " Order By  Attendance_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Check_Out_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and attendance_details.Employee_OutDate >= '", From_Date_ ,"' and  attendance_details.Employee_OutDate <= '", To_Date_,"'");
end if;
SET @query = Concat("  SELECT Attendance_Details_Id,Attendance_Master_Id,Employee_Id,
(Date_Format(attendance_details.Employee_InDate,'%Y-%m-%d')) As Employee_InDate,client_accounts.Client_Accounts_Name as Employee_Name,
sum(Employee_InTime) as Employee_InTime,
(Date_Format(attendance_details.Employee_OutDate,'%Y-%m-%d')) As Employee_OutDate,
sum(Employee_OutTime) as Employee_OutTime,sum(Normal_Hrs) as Normal_Hrs,
sum(Normal_Rate) as Normal_Rate,sum(Normal_Total) as Normal_Total,sum(Ot_Hrs) as Ot_Hrs ,
sum(Ot_Rate) as Ot_Rate, sum(Ot_Total) as Ot_Total ,sum(Loading_Hrs) as Loading_Hrs ,
sum(Loading_Rate) as Loading_Rate, sum(Loading_Total ) as Loading_Total, sum(No_Of_Piece ) as No_Of_Piece,
sum(Piece_Rate ) as Piece_Rate, sum(Piece_Total ) as Piece_Total,sum(Punch_Status) as Punch_Status,
sum(Other_Work) as Other_Work ,sum(Other_Start_Time ) as Other_Start_Time,
sum(Other_End_Time) as Other_End_Time,sum(Other_Total_Hrs) as Other_Total_Hrs ,
sum(Other_Rate) as Other_Rate , sum(Other_Total) as Other_Total,Total 
	From attendance_details
    inner join client_accounts  on client_accounts.Client_Accounts_Id = attendance_details.Employee_Id
	where attendance_details.DeleteStatus=false ", Search_Date_ , " Group By client_accounts.Client_Accounts_Name
    Order By  Attendance_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Check_Out_Report_demo`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and attendance_master.Employee_OutDate >= '", From_Date_ ,"' and  attendance_master.Employee_OutDate <= '", To_Date_,"'");
end if;
SET @query = Concat("  SELECT Attendance_Details_Id,Attendance_Master_Id,Employee_Id,
(Date_Format(attendance_details.Employee_InDate,'%Y-%m-%d')) As Employee_InDate,client_accounts.Client_Accounts_Name,
sum(Employee_InTime) as Employee_InTime,
(Date_Format(attendance_details.Employee_OutDate,'%Y-%m-%d')) As Employee_OutDate,
sum(Employee_OutTime) as Employee_OutTime,sum(Normal_Hrs) as Normal_Hrs,
sum(Normal_Rate) as Normal_Rate,sum(Normal_Total) as Normal_Total,sum(Ot_Hrs) as Ot_Hrs ,
sum(Ot_Rate) as Ot_Rate, sum(Ot_Total) as Ot_Total ,sum(Loading_Hrs) as Loading_Hrs ,
sum(Loading_Rate) as Loading_Rate, sum(Loading_Total ) as Loading_Total, sum(No_Of_Piece ) as No_Of_Piece,
sum(Piece_Rate ) as Piece_Rate, sum(Piece_Total ) as Piece_Total,sum(Punch_Status) as Punch_Status,
sum(Other_Work) as Other_Work ,sum(Other_Start_Time ) as Other_Start_Time,
sum(Other_End_Time) as Other_End_Time,sum(Other_Total_Hrs) as Other_Total_Hrs ,
sum(Other_Rate) as Other_Rate , sum(Other_Total) as Other_Total,Total 
	From attendance_details
    inner join client_accounts  on client_accounts.Client_Accounts_Id = attendance_details.Employee_Id
	where attendance_details.DeleteStatus=false ", Search_Date_ , " Group By client_accounts.Client_Accounts_Name
    Order By  Attendance_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Client_Accounts`( In Client_Accounts_Name_ varchar(100),Account_Group_ int)
Begin 
declare SearchbyName_Value varchar(2000);
SET SearchbyName_Value ='';
if Client_Accounts_Name_!='' then
		SET SearchbyName_Value =   Concat( " and client_accounts.Client_Accounts_Name like '%",Client_Accounts_Name_ ,"%'") ;
	end if;
if Account_Group_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and client_accounts.Account_Group_Id =",Account_Group_);
end if;

SET @query = Concat("select Client_Accounts.Client_Accounts_Id,Client_Accounts.Client_Accounts_Code,
Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,
Client_Accounts.Address2,Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.PinCode,
Client_Accounts.StateCode,Client_Accounts.GSTNo,Client_Accounts.PanNo,
Client_Accounts.State,Client_Accounts.Country,Client_Accounts.Phone,
Client_Accounts.Mobile,Client_Accounts.Email,Client_Accounts.Opening_Balance,
Client_Accounts.Description1,Client_Accounts.UserId,Password,User_Name,Reference_Number,
Client_Accounts.LedgerInclude,Client_Accounts.CanDelete,Client_Accounts.Opening_Type
,Client_Accounts.Commision,
(Date_Format(Client_Accounts.Entry_Date,'%Y-%m-%d')) As Entry_Date,
Client_Accounts.Account_Group_Id ,Group_Name Account_Group_Name
From Client_Accounts
inner join Account_Group on Account_Group.Account_Group_Id=Client_Accounts.Account_Group_Id

where Client_Accounts.Client_Accounts_Id>35 and client_accounts.Account_Group_Id not in(1,2,3) and  Client_Accounts.DeleteStatus=false", SearchbyName_Value," Order by Client_Accounts_Id asc");
PREPARE QUERY FROM @query;EXECUTE QUERY;
 #select @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Company`( )
Begin 
 
 SELECT Company_Id,
Company_Name,Address1,
Address2,
Address3,
Address4,
Phone_Number,
Mobile_Number,
EMail,IEC,
Website,
Logo,Code,GSTNO,CINO,PANNO

#Description1,Description2,Description3,FAX,Bank,Account
From Company where  Is_Delete=false 

order by Company_Name asc;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Contra_Entry`( In From_Date_ datetime,
To_Date_ datetime,
From_Account_Id_ decimal(18,0),
To_Account_Id_ decimal(18,0),
Voucher_No_ decimal(18,0),
Is_Date_Check_ Tinyint)
Begin 
declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
 if Is_Date_Check_=true then
set Search_Date_=concat( " and Contra_Entry.Date >= '", From_Date_ ,"' and  Contra_Entry.Date <= '", To_Date_,"'");
end if;
if From_Account_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Contra_Entry.From_Account_Id =",From_Account_Id_);
end if;

if To_Account_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Contra_Entry.To_Account_Id =",To_Account_Id_);
end if;
if Voucher_No_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Contra_Entry.Voucher_No ,'')  =",Voucher_No_);
end if;
SET @query = Concat("
 SELECT Contra_Entry_Id,Contra_Entry.From_Account_Id,FromAcc.Client_Accounts_Name as FromAccount_Name,
(Date_Format(Contra_Entry.Date,'%Y-%m-%d')) As Date , (Date_Format(Contra_Entry.Date,'%d-%m-%Y')) As Search_Date, Amount,Contra_Entry.To_Account_Id,
ToAcc.Client_Accounts_Name as ToAccount_Name, Voucher_No,
Contra_Entry.User_Id,Contra_Entry.Description,Payment_Status,PaymentMode
 From Contra_Entry 
inner join Client_Accounts as FromAcc on FromAcc.Client_Accounts_Id=Contra_Entry.From_Account_Id
inner join Client_Accounts as ToAcc on ToAcc.Client_Accounts_Id=Contra_Entry.To_Account_Id

 where Contra_Entry.DeleteStatus=false", Search_Date_ ,SearchbyName_Value,"");
  PREPARE QUERY FROM @query;

EXECUTE QUERY;

 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Customer`( In Client_Accounts_Name_ varchar(100),Account_Group_ int)
Begin 
declare SearchbyName_Value varchar(2000);
SET SearchbyName_Value ='';
if Client_Accounts_Name_!='' then
		SET SearchbyName_Value =   Concat( " and client_accounts.Client_Accounts_Name like '%",Client_Accounts_Name_ ,"%'") ;
	end if;
if Account_Group_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and client_accounts.Account_Group_Id =",Account_Group_);
end if;

SET @query = Concat("select Client_Accounts.Client_Accounts_Id,Client_Accounts.Client_Accounts_Code,
Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,
Client_Accounts.Address2,Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.PinCode,
Client_Accounts.StateCode,Client_Accounts.GSTNo,Client_Accounts.PanNo,
Client_Accounts.State,Client_Accounts.Country,Client_Accounts.Phone,
Client_Accounts.Mobile,Client_Accounts.Email,Client_Accounts.Opening_Balance,
Client_Accounts.Description1,Client_Accounts.UserId,Password,User_Name,Reference_Number,
Client_Accounts.LedgerInclude,Client_Accounts.CanDelete,Client_Accounts.Opening_Type
,Client_Accounts.Commision,
(Date_Format(Client_Accounts.Entry_Date,'%Y-%m-%d')) As Entry_Date,
Client_Accounts.Account_Group_Id ,Group_Name Account_Group_Name
From Client_Accounts
inner join Account_Group on Account_Group.Account_Group_Id=Client_Accounts.Account_Group_Id

where Client_Accounts.Client_Accounts_Id>35 and  Client_Accounts.DeleteStatus=false", SearchbyName_Value," Order by Client_Accounts_Id asc");
PREPARE QUERY FROM @query;EXECUTE QUERY;
 #select @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Customer_Typeahead`( In Account_Group_Id_ varchar(100),Client_Accounts_Name_ varchar(100))
Begin 
	set Client_Accounts_Name_ = Concat( '%',Client_Accounts_Name_ ,'%');
	SELECT 
	Client_Accounts_Id,	Client_Accounts_Name,Address1,Address2,Address3,Address4,Mobile,GSTNo,Client_Accounts_Code
	From Client_Accounts where Account_Group_Id IN( Account_Group_Id_) and 
	Client_Accounts_Name like Client_Accounts_Name_ and DeleteStatus=false 
	ORDER BY Client_Accounts_Name Asc Limit 5 ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Damage`()
BEGIN
SELECT production_master.Item_Name,sum(production_master.Quantity)Quantity,
packing_master.Packing_Master_Id,
(sum(shift_end_master.Acceptable)-SUM(packing_master.Total_Pallet_Quantity))as Redytopack,
(sum(production_master.Quantity)-(sum(shift_end_master.Acceptable)-SUM(packing_master.Total_Pallet_Quantity)))Balance,
(sum(shift_end_master.Damage)) Damage
FROM production_master
left JOIN shift_end_master ON shift_end_master.Shift_End_Master_Id=production_master.Shift_End_Master_Id
and shift_end_master.Process_List_Id=4
left JOIN packing_master ON packing_master.Packing_Master_Id=production_master.Packing_Master_Id
WHERE production_master.DeleteStatus = false and shift_end_master.DeleteStatus = false 
and packing_master.DeleteStatus = false  
GROUP BY production_master.Item_Name,production_master.Quantity,packing_master.Packing_Master_Id ;
 
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Damaged_Item`( In Item_ int)
Begin 
 
declare SearchbyName_Value varchar(2000);
SET SearchbyName_Value ='';
 
if Item_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Damaged_Item.Item_Id =",Item_);
end if;
 
SET @query = Concat("select Damaged_Item.Damaged_Item_Id,Damaged_Item.Product_Code,
Damaged_Item.Damaged_Item_Id,Damaged_Item.Qty,
Damaged_Item.Rate,Item.Item_Name ,Damaged_Item.Item_Id,
(Date_Format(Damaged_Item.Entry_Date,'%Y-%m-%d')) As Entry_Date
 
From Damaged_Item
inner join Item on Item.Item_Id=Damaged_Item.Item_Id

where   Damaged_Item.DeleteStatus=false  ",SearchbyName_Value," Order by Damaged_Item_Id asc");
PREPARE QUERY FROM @query;EXECUTE QUERY;
 #select @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Dashboard`()
BEGIN
select count(Purchase_Order_Customer_Id) as Purchase_Order_Customer_Id from Purchase_Order_Customer where DeleteStatus=false;
select count(Purchase_Order_Master_Id) as Purchase_Order_Master_Id from purchase_order_master where DeleteStatus=false;
select count(Proforma_Invoice_Master_Id) Proforma_Invoice_Master_Id from Proforma_Invoice_Master where DeleteStatus=false;
select count(Pallets_Master_Id) Pallets_Master_Id from pallets_master where DeleteStatus=false;
select count(Gate_Pass_Master_Id) Gate_Pass_Master_Id from Gate_Pass_Master where DeleteStatus=false;
select count(Gate_Pass_In_Master_Id) Gate_Pass_In_Master_Id from Gate_Pass_In_Master where DeleteStatus=false;
select count(Waste_In_Master_Id) Waste_In_Master_Id from waste_in_master where DeleteStatus=false;
select count(Waste_Out_Master_Id) Waste_Out_Master_Id from Waste_Out_Master where DeleteStatus=false;
select count(Production_Master_Id) Production_Master_Id from production_master where DeleteStatus=false and Production_Status=7;
select count(Production_Master_Id) Production_Master_Id from production_master where DeleteStatus=false and Production_Status=9;
select count(Sales_Master_Id) Sales_Master_Id from sales_master where DeleteStatus=false;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Dashboard_Customer`(in Login_Id_ int)
BEGIN
select count(Purchase_Order_Customer_Id) as Purchase_Order_Master_Id 
from purchase_order_customer where DeleteStatus=false and User_Id=Login_Id_ and Purchase_Order_Master_Id>0;

select count(Purchase_Order_Customer_Id) as Purchase_Order_Master_Id 
from purchase_order_customer where DeleteStatus=false and User_Id=Login_Id_ and Purchase_Order_Master_Id=0;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Employee_Details`( In Client_Accounts_Name_ varchar(100))
Begin 
 set Client_Accounts_Name_ = Concat( '%',Client_Accounts_Name_ ,'%');
 SELECT Client_Accounts.Client_Accounts_Id,Client_Accounts_Name
 From Client_Accounts
inner join Employee_Details on Client_Accounts.Client_Accounts_Id=Employee_Details.Client_Accounts_Id
 where Client_Accounts_Name like Client_Accounts_Name_ and Client_Accounts.Account_Group_Id=2 and Client_Accounts.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Employee_Overtime_Master`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Shift_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and employee_overtime_master.Date >= '", From_Date_ ,"' and  employee_overtime_master.Date <= '", To_Date_,"'");
end if;
if Shift_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and employee_overtime_master.Shift_Id =",Shift_Id_);
end if;
SET @query = Concat(" SELECT (Date_Format(employee_overtime_master.Date,'%Y-%m-%d')) As Date ,
	(Date_Format(employee_overtime_master.Date,'%d-%m-%Y')) As Search_Date,Employee_Overtime_Master_Id,
    employee_overtime_master.Shift_Id,employee_overtime_master.User_Id,Shift_Details_Name
	From employee_overtime_master 
	INNER JOIN shift_details ON employee_overtime_master.Shift_Id=shift_details.Shift_Details_Id
	where employee_overtime_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " 
    Order By  Employee_Overtime_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Employee_Shift_Report`( In Is_Date_Check_ tinyint,From_Date_ datetime,To_Date_ datetime,
Employee_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and shift_end_master.Date >= '", From_Date_ ,"' and  shift_end_master.Date <= '", To_Date_,"'");
end if;
if Employee_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_details.Employee_Id =",Employee_Id_);
end if;
SET @query = Concat("SELECT shift_end_master.Shift_End_Master_Id,(Date_Format(shift_end_master.Date,'%d-%m-%Y')) As Search_Date,
Employee_Id,Client_Accounts_Name,Shift_Details_Name,Acceptable
	FROM shift_end_master
	INNER JOIN shift_end_details ON shift_end_master.Shift_End_Master_Id=shift_end_details.Shift_End_Master_Id 
	inner JOIN Client_Accounts  ON shift_end_details.Employee_Id=client_accounts.Client_Accounts_Id 
	inner JOIN shift_details  ON shift_end_master.Shift_Details_Id=shift_details.Shift_Details_Id 
	WHERE shift_end_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value," 
    order by shift_end_master.Shift_End_Master_Id  asc");

 PREPARE QUERY FROM @query;EXECUTE QUERY;
 # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Employee_Typeahead`(in Client_Accounts_Name_ varchar(100))
BEGIN
set Client_Accounts_Name_ = Concat( '%',Client_Accounts_Name_ ,'%');
	SELECT employee_details.Client_Accounts_Id,Ot_Rate,Normal_Rate,Loading_Rate,Client_Accounts_Name
    from employee_details
    inner join client_accounts on client_accounts.Client_Accounts_Id=employee_details.Client_Accounts_Id    
    where 	Client_Accounts_Name like Client_Accounts_Name_ and employee_details.DeleteStatus=false 
	ORDER BY Client_Accounts_Name Asc Limit 5 ;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Employee_Work_Summary_Report`( In Is_Date_Check_ tinyint,From_Date_ datetime,To_Date_ datetime,
Employee_Id_ int)
Begin
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
set Search_Date_=concat( " and shift_end_master.Date >= '", From_Date_ ,"' and  shift_end_master.Date <= '", To_Date_,"'");
end if;
if Employee_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_details.Employee_Id =",Employee_Id_);
end if;
SET @query = Concat("SELECT shift_end_master.Shift_End_Master_Id,
(Date_Format(shift_end_master.Date,'%d-%m-%Y')) As Search_Date,Employee_Id,Client_Accounts_Name,
Start_Time,End_Time,Loading,Normal_Rate,Ot_Rate,Loading_Rate,
Sum((Start_Time)*Normal_Rate) Normal_Amount,Sum((End_Time)*Ot_Rate) Ot_Amount,
Sum((Loading)*Loading_Rate) Loading_Amount,
Sum(((Start_Time)*Normal_Rate)*((End_Time)*Ot_Rate)*((Loading)*Loading_Rate)) Total_Amount
FROM shift_end_master
INNER JOIN shift_end_details ON shift_end_master.Shift_End_Master_Id=shift_end_details.Shift_End_Master_Id
inner JOIN Client_Accounts  ON shift_end_details.Employee_Id=client_accounts.Client_Accounts_Id
WHERE shift_end_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"
    order by shift_end_master.Shift_End_Master_Id  asc");

 PREPARE QUERY FROM @query;EXECUTE QUERY;
 # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Finishedgoods_Purchase_Order`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),Invoice_No_ varchar(50),Purchase_Type_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and FinishedGoods_Purchase_Master.PurchaseDate >= '", From_Date_ ,"' and  FinishedGoods_Purchase_Master.PurchaseDate <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and FinishedGoods_Purchase_Master.Account_Party_Id =",Account_Party_Id_);
end if;
if Invoice_No_!='' then
	SET SearchbyName_Value =concat(SearchbyName_Value," and FinishedGoods_Purchase_Master.InvoiceNo like '%",Invoice_No_ ,"%' ");
end if;
/*
if Purchase_Type_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and FinishedGoods_Purchase_Master.Purchase_Type_Id =",Purchase_Type_);
end if;*/
SET @query = Concat("
	SELECT  FinishedGoods_Purchase_Master_Id ,(Date_Format(FinishedGoods_Purchase_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,Account_Party_Id,Purchase_Type_Id,
	(Date_Format(PurchaseDate,'%d-%m-%Y')) As Search_Date, (Date_Format(PurchaseDate,'%Y-%m-%d')) As PurchaseDate ,Grand_Total,
	InvoiceNo ,GrossTotal,TotalDiscount, NetTotal ,TotalCGST,TotalSGST,TotalIGST,TotalGST,TotalAmount,Discount,Roundoff,Other_Charges,BillType,User_Id,Description,
	Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,Address2,Address3,Address4,PinCode,GSTNo,Mobile
	From FinishedGoods_Purchase_Master 
	INNER JOIN Client_Accounts ON FinishedGoods_Purchase_Master.Account_Party_Id=Client_Accounts.Client_Accounts_Id
	where  Purchase_Type_Id =", Purchase_Type_," and   FinishedGoods_Purchase_Master.DeleteStatus=false ",
    Search_Date_ ,SearchbyName_Value , " order by FinishedGoods_Purchase_Master_Id asc ");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Finishedgoods_Purchase_Order_Report`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),Invoice_No_ varchar(50),Purchase_Type_ int,Item_Id_ Int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and FinishedGoods_Purchase_Master.PurchaseDate >= '", From_Date_ ,"' and  FinishedGoods_Purchase_Master.PurchaseDate <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and FinishedGoods_Purchase_Master.Account_Party_Id =",Account_Party_Id_);
end if;
if Invoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( FinishedGoods_Purchase_Master.InvoiceNo ,'')  =",Invoice_No_);
end if;

if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and finishedgoods_purchase_details.ItemId =",Item_Id_);
end if;
SET @query = Concat("
	SELECT  FinishedGoods_Purchase_Master.FinishedGoods_Purchase_Master_Id ,(Date_Format(PurchaseDate,'%d-%m-%Y')) As Search_date, 
    InvoiceNo ,Client_Accounts.Client_Accounts_Name,ItemName,WareHouse_Name,Quantity,
    finishedgoods_purchase_details.TotalAmount,Grand_Total
	From FinishedGoods_Purchase_Master 
	INNER JOIN finishedgoods_purchase_details ON FinishedGoods_Purchase_Master.FinishedGoods_Purchase_Master_Id=finishedgoods_purchase_details.FinishedGoods_Purchase_Master_Id
	INNER JOIN Client_Accounts ON FinishedGoods_Purchase_Master.Account_Party_Id=Client_Accounts.Client_Accounts_Id
	where  Purchase_Type_Id =", Purchase_Type_," and   FinishedGoods_Purchase_Master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value , " order by FinishedGoods_Purchase_Master_Id asc ");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Gate_Pass_In_Master`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int,Pass_No_ varchar(50))
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and gate_pass_in_master.Date >= '", From_Date_ ,"' and  gate_pass_in_master.Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and gate_pass_in_master.Employee_Id =",Client_Accounts_Id_);
end if;
if Pass_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and  gate_pass_in_master.Pass_No  =",Pass_No_);
end if;
SET @query = Concat(" SELECT (Date_Format(gate_pass_in_master.Date,'%Y-%m-%d')) As Date,
(Date_Format(gate_pass_in_master.Date,'%d-%m-%Y')) As Search_Date,
Gate_Pass_In_Master_Id,Employee_Id,Client_Accounts_Name,Vehicle_No,Pass_No,User_Id,Description,Customer_Name,
Chellan_number,Store_Number,(Date_Format(gate_pass_in_master.Invoice_Date,'%Y-%m-%d')) As Invoice_Date ,
(Date_Format(gate_pass_in_master.Invoice_Date,'%d-%m-%Y')) As Invoice_Search_Date ,
Invoice_Number,Driver_Name,Verified_By,gate_pass_in_master.Company_Id,company.Company_Name,Company.Address1,
company.Address2,Company.Address3,company.Address4,Company.Mobile_Number,  Weighment_Slip_No,Weighment_Quantity,
(Date_Format(gate_pass_in_master.Arrival_Date,'%Y-%m-%d')) As Arrival_Date ,
(Date_Format(gate_pass_in_master.Arrival_Date,'%d-%m-%Y')) As Arrival_Search_Date 
From gate_pass_in_master 
INNER JOIN Client_Accounts ON gate_pass_in_master.Employee_Id=Client_Accounts.Client_Accounts_Id
INNER JOIN Company ON gate_pass_in_master.Company_Id=Company.Company_Id
where gate_pass_in_master.DeleteStatus=false ",
Search_Date_ ,SearchbyName_Value, " order by Gate_Pass_In_Master_Id asc ");
PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Gate_Pass_Master`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int,Pass_No_ varchar(50))
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and gate_pass_master.Date >= '", From_Date_ ,"' and  gate_pass_master.Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and gate_pass_master.Employee_Id =",Client_Accounts_Id_);
end if;
if Pass_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and  gate_pass_master.Pass_No =",Pass_No_);
end if;
SET @query = Concat(" SELECT (Date_Format(gate_pass_master.Date,'%Y-%m-%d')) As Date ,(Date_Format(gate_pass_master.Date,'%d-%m-%Y')) As Search_Date,
Gate_Pass_Master_Id,Employee_Id,Vehicle_No,Pass_No,User_Id,Description,Supplier_Name,
(Date_Format(gate_pass_master.Invoice_Date,'%Y-%m-%d')) As Invoice_Date,Invoice_Number,Remarks,Driver_Name,
Verified_By,Eway_No,gate_pass_master.Company_Id,company.Company_Name,Company.Address1,
company.Address2,Company.Address3,company.Address4,Company.Mobile_Number,
  Weighment_Slip_No,Weighment_Quantity
From gate_pass_master 
INNER JOIN Company ON gate_pass_master.Company_Id=Company.Company_Id
where gate_pass_master.DeleteStatus=false ",
Search_Date_ ,SearchbyName_Value, " order by Gate_Pass_Master_Id asc ");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Group_Accounts_Typeahead`( In Group_Name_ varchar(100))
Begin 
set Group_Name_ = Concat( '%',Group_Name_ ,'%');
SELECT Account_Group_Id,Group_Name
FROM Account_Group 
where Group_Name LIKE Group_Name_ and Account_Group_Id Not in('1,2,3') and DeleteStatus=False
order by Group_Name asc Limit 5 ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_HSN`(IN HSN_CODE_ varchar(100))
Begin 
 set HSN_CODE_ = Concat( '%',HSN_CODE_ ,'%');
 SELECT HSN_Id,HSN_CODE,CGST,SGST,IGST,GST From HSN where HSN_CODE like HSN_CODE_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Invoice_Report`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),Invoice_No_ decimal(18,0),
PONo_ varchar(50))
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Sales_Master.Entry_Date >= '", From_Date_ ,"' and  Sales_Master.Entry_Date <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Sales_Master.Account_Party_Id =",Account_Party_Id_);
end if;
if Invoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Sales_Master.Invoice_No ,'')  =",Invoice_No_);
end if;
if PONo_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Sales_Master.PONo ,'')  =",PONo_);
end if;
SET @query = Concat("SELECT Sales_Master_Id,(Date_Format(Sales_Master.PO_Date,'%d-%m-%Y')) As Search_Date,
Sales_Master_Id,(Date_Format(Sales_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date,Sales_Master.PONo,
Sales_Master_Id,(Date_Format(Sales_Master.PO_Date,'%Y-%m-%d')) As PO_Date,Account_Party_Id,
(Date_Format(Sales_Master.Entry_Date,'%d-%m-%Y')) As Entry_Search_Date,
Invoice_No,GrandTotal,Client_Accounts.Client_Accounts_Name as Customer
FROM Sales_Master
INNER JOIN Client_Accounts ON Sales_Master.Account_Party_Id=Client_Accounts.Client_Accounts_Id 
WHERE Sales_Master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value," Order by Sales_Master_Id asc");
PREPARE QUERY FROM @query;EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Item`( In Item_Name_ varchar(100),Group_Id_ int)
Begin 
declare SearchbyName_Value varchar(2000);
SET SearchbyName_Value ='';
if Item_Name_!='' then
		SET SearchbyName_Value =   Concat(SearchbyName_Value, " and Item.Item_Name like '%",Item_Name_ ,"%'") ;
	end if;
if Group_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Item.Group_Id =",Group_Id_);
end if;
SET @query = Concat("SELECT Item_Id ,Item_Name ,Group_Id ,Group_Name ,Unit_Id ,Unit_Name ,HSN_Id ,Hsn_Code ,
MFCode ,Weight ,Packing_Size ,Colour ,UPC ,CGST ,SGST,IGST,GST ,CESS,Batch_Weight,Quantity_Inshift,Weight_Item,
Barcode_Item,Re_Order_Level,Product_Code
 From Item 
where Item.DeleteStatus=false", SearchbyName_Value,"");
PREPARE QUERY FROM @query;EXECUTE QUERY;
 #select @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Item_Count_Report`()
BEGIN
    /*DECLARE SearchbyName_Value VARCHAR(2000);
    SET SearchbyName_Value = '';

    IF Item_Name_ != '' THEN
        SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND packing_master.Item_Name LIKE '%", Item_Name_ , "%'");
    END IF;

    IF Group_Id_ > 0 THEN
        SET SearchbyName_Value = CONCAT(SearchbyName_Value, " AND stock.Group_Id =", Group_Id_);
    END IF;*/

    SET @query = CONCAT("SELECT production_master.Item_Name,sum(production_master.Quantity)Quantity,
    (sum(shift_end_master.Acceptable)-SUM(packing_master.Total_Pallet_Quantity))as Redytopack,
(sum(production_master.Quantity)-(sum(shift_end_master.Acceptable)-SUM(packing_master.Total_Pallet_Quantity)))Balance
FROM production_master
left JOIN shift_end_master ON shift_end_master.Shift_End_Master_Id=production_master.Shift_End_Master_Id
and shift_end_master.Process_List_Id=4
left JOIN packing_master ON packing_master.Packing_Master_Id=production_master.Packing_Master_Id
WHERE production_master.DeleteStatus = false and shift_end_master.DeleteStatus = false 
and packing_master.DeleteStatus = false  
GROUP BY production_master.Item_Name,production_master.Quantity 
 ");
    PREPARE QUERY FROM @query;
    EXECUTE QUERY;
    # SELECT @query;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Item_Group`( In Item_Group_Name_ varchar(100))
Begin 
 set Item_Group_Name_ = Concat( '%',Item_Group_Name_ ,'%');
 SELECT Item_Group_Id,
Item_Group_Code,
Item_Group_Name,
UnderGroupId From Item_Group where Item_Group_Name like Item_Group_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Item_Production_Report`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),Invoice_No_ varchar(50),Purchase_Type_ int,
Item_Id_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and packing_master.Date >= '", From_Date_ ,"' and  packing_master.Date <= '", To_Date_,"'");
end if;

if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and packing_master.Item_Id =",Item_Id_);
end if;
SET @query = Concat("
	SELECT  Item_Name,Acceptable_Quantity,WareHouse_Name,Damage,Total_Pallet_Quantity,Packing_No,(Date_Format(packing_master.Date,'%d-%m-%Y')) As Search_date
	From packing_master 
	where   packing_master.DeleteStatus=false 
    ", Search_Date_ ,SearchbyName_Value , " order by packing_master.Packing_Master_Id asc ");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Item_Purchase`( In Group_Id_ int,Item_Name_ varchar(100))
Begin 
 set Item_Name_ = Concat( '%',Item_Name_ ,'%');
 SELECT 
Item_Id ,Item_Name ,Group_Id ,Group_Name ,Unit_Id ,Unit_Name ,HSN_Id ,Hsn_Code ,
MFCode ,Weight ,Packing_Size ,Colour ,UPC ,CGST ,SGST,IGST,GST ,CESS,Barcode_Item 
 From Item 
 where  Group_Id IN( Group_Id_) and  Item_Name like Item_Name_ and DeleteStatus=false limit 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Item_Typeahead`(in ItemName_ varchar(50),Group_Id_ int)
BEGIN
declare SearchbyName_Value varchar(2000);set SearchbyName_Value="";
	set ItemName_ = Concat( "'%",ItemName_ ,"%'");
if Group_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and item.Group_Id =",Group_Id_);
end if;
 SET @query = Concat("select Item_Id,Item_Name
from item where Item_Name  like", ItemName_ ," and item.DeleteStatus=false ",
 SearchbyName_Value,"
oRDER BY Item_Name ASC LIMIT 5");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Journal_Entry`( In From_Date_ datetime,
To_Date_ datetime,
From_Account_Id_ decimal(18,0),
To_Account_Id_ decimal(18,0),
Voucher_No_ decimal(18,0),
Is_Date_Check_ Tinyint
)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
 if Is_Date_Check_=true then
set Search_Date_=concat( " and Journal_Entry.Date >= '", From_Date_ ,"' and  Journal_Entry.Date <= '", To_Date_,"'");
end if;
if From_Account_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Journal_Entry.From_Account_Id =",From_Account_Id_);
end if;

if To_Account_Id_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Journal_Entry.To_Account_Id =",To_Account_Id_);
end if;
if Voucher_No_>0 then
SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Journal_Entry.Voucher_No ,'')  =",Voucher_No_);
end if;

SET @query = Concat("
 SELECT Journal_Entry_Id,Journal_Entry.From_Account_Id,FromAcc.Client_Accounts_Name as FromAccount_Name,
(Date_Format(Journal_Entry.Date,'%Y-%m-%d')) As Date ,
 (Date_Format(Journal_Entry.Date,'%d-%m-%Y')) As Search_Date, Amount,Journal_Entry.To_Account_Id,
ToAcc.Client_Accounts_Name as ToAccount_Name,Concat( Journal_Entry.Voucher_No ,'') Voucher_No,
Journal_Entry.User_Id,Journal_Entry.Description,Payment_Status,PaymentMode,FromAcc.Address1 From_Detail,ToAcc.Address1 To_Detail
 From Journal_Entry 
inner join Client_Accounts as FromAcc on FromAcc.Client_Accounts_Id=Journal_Entry.From_Account_Id
inner join Client_Accounts as ToAcc on ToAcc.Client_Accounts_Id=Journal_Entry.To_Account_Id

 where Journal_Entry.DeleteStatus=false", Search_Date_ ,SearchbyName_Value,"");
  PREPARE QUERY FROM @query;

EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Order_Tracking`( In Production_Master_Id_ decimal(18,0))
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";

if Production_Master_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and order_tracking_history.PoMasterId =",Production_Master_Id_);
end if;

SET @query = Concat("SELECT Order_Tracking_History_Id,User_Id,(Date_Format(order_tracking_history.Date,'%d-%m-%Y'))  as Search_Date,
	(Date_Format(order_tracking_history.Date,'%Y-%m-%d'))  as Date,Master_Id,Order_Type,Order_Status,Description,
    PoMasterId    ,Order_Status_Name,User_Details_Name
    FROM order_tracking_history
	INNER JOIN user_details ON order_tracking_history.User_Id=user_details.User_Details_Id 
    inner join Order_Status on Order_Status.Order_Status_Id=order_tracking_history.Order_Status
	WHERE  order_tracking_history.DeleteStatus =false" ,SearchbyName_Value,"");
 PREPARE QUERY FROM @query;EXECUTE QUERY;
 # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Order_Tracking_User`( In  From_Date_ datetime,
To_Date_ datetime, Is_Date_Check_ Tinyint,Production_Master_Id_ decimal(18,0))
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";

 if Is_Date_Check_=true then
	set Search_Date_=concat( " and order_tracking_history.Date >= '", From_Date_ ,"' and  order_tracking_history.Date <= '", To_Date_,"'");
end if;
if Production_Master_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and order_tracking_history.PoMasterId =",Production_Master_Id_);
end if;

SET @query = Concat("SELECT Order_Tracking_History_Id,User_Id,(Date_Format(order_tracking_history.Date,'%d-%m-%Y'))  as Search_Date,
	(Date_Format(order_tracking_history.Date,'%Y-%m-%d'))  as Date,Master_Id,Order_Type,Order_Status,Description,
    PoMasterId,Order_Status_Name,User_Details_Name
    FROM order_tracking_history
	INNER JOIN user_details ON order_tracking_history.User_Id=user_details.User_Details_Id 
    inner join Order_Status on Order_Status.Order_Status_Id=order_tracking_history.Order_Status
	WHERE  order_tracking_history.DeleteStatus =false" , Search_Date_ ,SearchbyName_Value ,"");
 PREPARE QUERY FROM @query;EXECUTE QUERY;
 # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Packing`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Production_No_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Packing_master.Date >= '", From_Date_ ,"' and  Packing_master.Date <= '", To_Date_,"'");
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Packing_master.Production_No =",Production_No_);
end if;
SET @query = Concat(" SELECT (Date_Format(Packing_master.Date,'%Y-%m-%d')) As Date ,(Date_Format(Packing_master.Date,'%d-%m-%Y')) As Search_Date,
Packing_master.Packing_Master_Id,Packing_master.Press_Details_Id,Packing_master.Production_No,Packing_master.Production_Master_Id,
	Packing_master.Process_List_Id,Packing_master.Shift_Details_Id,Packing_No,Total_Items_Pallet,Total_Pallet_Quantity,Damage,Wastage,
	Packing_master.User_Id,Packing_master.Stock_Id,Packing_master.Item_Id,Packing_master.Item_Name,Packing_master.WareHouse_Id,
    Packing_master.WareHouse_Name,Process_Details_Name Process_Name,Shift_Details_Name ,Pallet_Id,Stock.ItemName Pallet_Name,
    Packing_master.Acceptable_Quantity,Reference_Field,PInvoice_No,Packing_master.Company_Id,Company.Company_Name,Packing_master.Category_Id,Packing_master.Category_Name,
    ifnull(Packing_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id
	From Packing_master 
	inner join Company on Company.Company_Id=Packing_master.Company_Id
	INNER JOIN production_master ON packing_master.Production_Master_Id=production_master.Production_Master_Id
	INNER JOIN process_details ON Packing_master.Process_List_Id=process_details.Process_Details_Id
	INNER JOIN Stock ON Packing_master.Pallet_Id=Stock.Stock_Id
	INNER JOIN shift_details ON Packing_master.Shift_Details_Id=shift_details.Shift_Details_Id
	where Packing_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value,"Order By  Packing_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Packing_Plan_Master`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,Packing_Plan_No_ varchar(50))
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and packing_plan_master.Date >= '", From_Date_ ,"' and  packing_plan_master.Date <= '", To_Date_,"'");
end if;
if Packing_Plan_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and packing_plan_master.Packing_Plan_No =",Packing_Plan_No_);
end if;
SET @query = Concat("SELECT Packing_Plan_Master_Id,(Date_Format(packing_plan_master.Date,'%d-%m-%Y')) As search_date,
(Date_Format(packing_plan_master.Date,'%Y-%m-%d')) As Date,packing_plan_master.User_Id,Packing_Plan_No, packing_plan_master.Description,
packing_plan_master.Porforma_Invoice_Master_Id,ifnull(packing_plan_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,
PInvoice_No,PONo,Reference_Field,packing_plan_master.Company_Id,Company_Name
FROM packing_plan_master
inner join Company on Company.Company_Id=packing_plan_master.Company_Id
inner join proforma_invoice_master on packing_plan_master.Porforma_Invoice_Master_Id=proforma_invoice_master.Proforma_Invoice_Master_Id
WHERE packing_plan_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"");
  PREPARE QUERY FROM @query;EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Packing_Plan_Master_Report`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,PI_No_ varchar(50))
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and packing_plan_master.Date >= '", From_Date_ ,"' and  packing_plan_master.Date <= '", To_Date_,"'");
end if;
if PI_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and proforma_invoice_master.PInvoice_No =",PI_No_);
end if;

SET @query = Concat("SELECT Packing_Plan_Master_Id,(Date_Format(packing_plan_master.Date,'%d-%m-%Y')) As search_date,
PInvoice_No,PONo,Reference_Field
FROM packing_plan_master
inner join proforma_invoice_master on packing_plan_master.Porforma_Invoice_Master_Id=proforma_invoice_master.Proforma_Invoice_Master_Id
WHERE packing_plan_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"");

  PREPARE QUERY FROM @query;EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Packing_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Production_No_ int,Item_Id_ int,WareHouse_Id_ int,Pallet_Id_ int,Company_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Packing_master.Date >= '", From_Date_ ,"' and  Packing_master.Date <= '", To_Date_,"'");
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Packing_master.Production_No =",Production_No_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Packing_master.Item_Id =",Item_Id_);
end if;
if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Packing_master.Company_Id =",Company_Id_);
end if;
if WareHouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Packing_master.WareHouse_Id =",WareHouse_Id_);
end if;
if Pallet_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Packing_master.Pallet_Id =",Pallet_Id_);
end if;
SET @query = Concat(" SELECT (Date_Format(Packing_master.Date,'%Y-%m-%d')) As Date ,
	(Date_Format(Packing_master.Date,'%d-%m-%Y')) As Search_Date,Packing_master.Packing_Master_Id,Packing_master.Press_Details_Id,Packing_master.Production_No,Packing_master.Production_Master_Id,
	Packing_master.Process_List_Id,Packing_master.Shift_Details_Id,Packing_No,Total_Items_Pallet,Total_Pallet_Quantity,Damage,Wastage,
	Packing_master.User_Id,Packing_master.Stock_Id,Packing_master.Item_Id,Packing_master.Item_Name,Packing_master.WareHouse_Id,Packing_master.WareHouse_Name,
	Process_Details_Name Process_Name,Shift_Details_Name ,Pallet_Id,Stock.ItemName Pallet_Name,Packing_master.Acceptable_Quantity,
    Reference_Field,PInvoice_No
	From Packing_master 
	INNER JOIN production_master ON packing_master.Production_Master_Id=production_master.Production_Master_Id
	INNER JOIN process_details ON Packing_master.Process_List_Id=process_details.Process_Details_Id
	INNER JOIN Stock ON Packing_master.Pallet_Id=Stock.Stock_Id
	INNER JOIN shift_details ON Packing_master.Shift_Details_Id=shift_details.Shift_Details_Id
	where Packing_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value ," Order By  Packing_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Packing_Wastage_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Production_No_ int,Item_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Packing_master.Date >= '", From_Date_ ,"' and  Packing_master.Date <= '", To_Date_,"'");
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Packing_master.Production_No =",Production_No_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and packing_details_wastage.Item_Stock_Id =",Item_Id_);
end if;
SET @query = Concat(" SELECT (Date_Format(Packing_master.Date,'%Y-%m-%d')) As Date ,
	(Date_Format(Packing_master.Date,'%d-%m-%Y')) As Search_Date,Packing_master.Packing_Master_Id,Packing_master.Production_No,
    packing_details_wastage.Item_Stock_Id,packing_details_wastage.Item_Name,packing_details_wastage.Quantitypers
	From Packing_master 
	INNER JOIN packing_details_wastage ON packing_master.Packing_Master_Id=packing_details_wastage.Packing_Master_Id
    
	where Packing_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value,"
    Order By  Packing_master.Packing_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Pallets_Received`( In FromDate_ datetime,
 ToDate_ datetime,Is_Date_Check_ tinyint)
Begin 
declare Search_Date_ varchar(500);
set Search_Date_="";
 if Is_Date_Check_=true then
set Search_Date_=concat( " and Pallets_Master.Entry_Date >= '", FromDate_ ,"' and  
Pallets_Master.Entry_Date <= '", ToDate_,"'");
end if;
SET @query = Concat("SELECT Pallets_Master.Pallets_Master_Id,(Date_Format(Pallets_Master.Entry_Date,'%Y-%m-%d')) as Entry_Date, 
(Date_Format(Pallets_Master.Entry_Date,'%d-%m-%Y')) As Search_Date, Pallets_Master.Stock_Id,
Pallets_Master.User_Id , Pallets_Master.Production_Master_Id  ,Pallets_Master.Production_No  ,
Pallets_Master.Item_Id  ,Pallets_Master.Item_Name,Pallets_Master.From_Warehouse_Id , Pallets_Master.From_Warehouse_Name , 
Pallets_Master.Quantity  ,Pallets_Master.To_Warehouse_Id,Pallets_Master.To_Warehouse_Name,Pallets_Master.Reference_Field,PInvoice_No,
Available_Quantity,Pallets_Master.Proforma_Invoice_Master_Id,Pallet_Id,Pallet_Name,
Pallets_Master.Company_Id,Pallets_Master.To_Company_Id,Com.Company_Name,To_Comp.Company_Name To_Company_Name,Barcode,pallets_master.Packing_Master_Id
From Pallets_Master 
	INNER JOIN Company Com ON Pallets_Master.Company_Id=Com.Company_Id   
	INNER JOIN Company To_Comp ON Pallets_Master.To_Company_Id=To_Comp.Company_Id   
	INNER JOIN production_master ON Pallets_Master.Production_Master_Id=production_master.Production_Master_Id   
where Pallets_Master.DeleteStatus=false and Pallets_Master.Status_Id=2 ", Search_Date_ ,"order by Pallets_Master_Id asc");
 
	PREPARE QUERY FROM @query;EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Pallets_Transfer`( In FromDate_ datetime,
 ToDate_ datetime,Is_Date_Check_ tinyint)
Begin 
declare Search_Date_ varchar(500);
set Search_Date_="";
 if Is_Date_Check_=true then
set Search_Date_=concat( " and Pallets_Master.Entry_Date >= '", FromDate_ ,"' and  
Pallets_Master.Entry_Date <= '", ToDate_,"'");
end if;
SET @query = Concat("SELECT Pallets_Master.Pallets_Master_Id,(Date_Format(Pallets_Master.Entry_Date,'%Y-%m-%d')) as Entry_Date, 
(Date_Format(Pallets_Master.Entry_Date,'%d-%m-%Y')) As Search_Date, Pallets_Master.Stock_Id,
Pallets_Master.User_Id , Pallets_Master.Production_Master_Id  ,Pallets_Master.Production_No  ,
Pallets_Master.Item_Id  ,Pallets_Master.Item_Name,Pallets_Master.From_Warehouse_Id , Pallets_Master.From_Warehouse_Name , 
Pallets_Master.Quantity  ,Pallets_Master.To_Warehouse_Id,Pallets_Master.To_Warehouse_Name,Pallets_Master.Reference_Field,PInvoice_No,
Available_Quantity,Pallets_Master.Proforma_Invoice_Master_Id,Pallet_Id,Pallet_Name,
Pallets_Master.Company_Id,Pallets_Master.To_Company_Id,Com.Company_Name,To_Comp.Company_Name To_Company_Name,Barcode,pallets_master.Packing_Master_Id
From Pallets_Master 
	INNER JOIN Company Com ON Pallets_Master.Company_Id=Com.Company_Id   
	INNER JOIN Company To_Comp ON Pallets_Master.To_Company_Id=To_Comp.Company_Id   
	INNER JOIN production_master ON Pallets_Master.Production_Master_Id=production_master.Production_Master_Id   
where Pallets_Master.DeleteStatus=false and Pallets_Master.Status_Id=1 ", Search_Date_ ,"order by Pallets_Master_Id asc");
 
	PREPARE QUERY FROM @query;EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Pallets_Transfer_Report`( In FromDate_ datetime,
 ToDate_ datetime,Is_Date_Check_ tinyint,Ref_No_ int,Pallet_Id_ int,Production_No_ int)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
 if Is_Date_Check_=true then
	set Search_Date_=concat( " and Pallets_Master.Entry_Date >= '", FromDate_ ,"' and  Pallets_Master.Entry_Date <= '", ToDate_,"'");
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Pallets_Master.Production_No =",Production_No_);
end if;
if Ref_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Pallets_Master.Proforma_Invoice_Master_Id =",Ref_No_);
end if;
if Pallet_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Pallets_Master.Pallet_Id =",Pallet_Id_);
end if;
SET @query = Concat("SELECT Pallets_Master.Pallets_Master_Id,(Date_Format(Pallets_Master.Entry_Date,'%Y-%m-%d')) as Entry_Date, 
(Date_Format(Pallets_Master.Entry_Date,'%d-%m-%Y')) As Search_Date,Pallets_Master.Production_No  ,
Pallets_Master.Item_Id  ,Pallets_Master.Item_Name,Pallets_Master.From_Warehouse_Id , Pallets_Master.From_Warehouse_Name , 
Pallets_Master.Quantity  ,Pallets_Master.To_Warehouse_Id,Pallets_Master.To_Warehouse_Name,Pallets_Master.Reference_Field,PInvoice_No,
Available_Quantity,Pallets_Master.Proforma_Invoice_Master_Id,Pallet_Id,Pallet_Name
From Pallets_Master 
	INNER JOIN production_master ON Pallets_Master.Production_Master_Id=production_master.Production_Master_Id   
where Pallets_Master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value ," order by Pallets_Master_Id asc");
 
	PREPARE QUERY FROM @query;EXECUTE QUERY;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Pono_Client_Typeahead`(in PONo_ varchar(50),Client_Id_ int)
BEGIN

set PONo_ = Concat( '%',PONo_ ,'%');
select Purchase_Order_Master_Id,PONo
from purchase_order_master where PONo like PONo_ and Client_Accounts_Id=Client_Id_ and DeleteStatus=false;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Pono_Typeahead`(in PONo_ varchar(50))
BEGIN

set PONo_ = Concat( '%',PONo_ ,'%');
select Purchase_Order_Master_Id,PONo
from purchase_order_master where PONo like PONo_ and DeleteStatus=false;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Press_Details`(IN Press_Details_Name_ varchar(500))
Begin 
 set Press_Details_Name_ = Concat( '%',Press_Details_Name_ ,'%');
 SELECT Press_Details_Id,Press_Details_Name,Status
 From press_details where Press_Details_Name like Press_Details_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Process_Details`(IN Process_Details_Name_ varchar(500))
Begin 
 set Process_Details_Name_ = Concat( '%',Process_Details_Name_ ,'%');
 SELECT Process_Details_Id,Process_Details_Name,Status
 From process_details where Process_Details_Name like Process_Details_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production`( In Is_Date_Check_ varchar(50),From_Date_ datetime,To_Date_ datetime,PO_No_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and production_master.Date >= '", From_Date_ ,"' and  production_master.Date <= '", To_Date_,"'");
end if;
if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.PONo =",PO_No_);
end if;
/*if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( production_master.Prodction_No ,'')  =",PO_No_);
end if;*/
SET @query = Concat("SELECT (Date_Format(production_master.Expected_Production_Date,'%Y-%m-%d')) As Expected_Production_Date ,Production_Master_Id ,
(Date_Format(production_master.Date,'%Y-%m-%d')) As Date ,production_master.Proforma_Invoice_Master_Id,Proforma_Invoice_Details_Id,Production_No,
production_master.PONo,(Date_Format(production_master.Date,'%d-%m-%Y')) As Search_Date, production_master.User_Id ,Stock_Id,Shift_End_Master_Id,
Production_Status,Item_Id ,Item_Name,WareHouse_Id, WareHouse_Name ,Quantity, Order_Status_Name, Reference_Field,PInvoice_No,Company.Company_Name,
production_master.Company_Id,Weight,Batch_Weight,Weight_Item,Weight_Description,Round(((Weight*Quantity)/Batch_Weight),3) Total_Batch_Weight,
Average_Mat_Weight,CASE WHEN production_master.Production_Status =7 THEN 'Stop Production' ELSE  'Start Production' END Production_Caption, 
production_master.Production_Master_Id,production_master.Production_Status,ifnull(production_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id
From production_master 
inner join Company on Company.Company_Id=production_master.Company_Id
inner join order_status on production_master.Production_Status=order_status.Order_Status_Id
where production_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " Order By  Production_Master_Id asc");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_Complete_Report`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,PO_No_ int,Item_Id_ int,WareHouse_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
 set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and production_master.Date >= '", From_Date_ ,"' and  production_master.Date <= '", To_Date_,"'");
end if;
if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.PONo =",PO_No_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.Item_Id =",Item_Id_);
end if;
if WareHouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.WareHouse_Id =",WareHouse_Id_);
end if;

SET @query = Concat("
		SELECT (Date_Format(production_master.Expected_Production_Date,'%Y-%m-%d')) As Expected_Production_Date ,
		Production_Master_Id ,(Date_Format(production_master.Date,'%Y-%m-%d')) As Date ,production_master.Proforma_Invoice_Master_Id,Proforma_Invoice_Details_Id,Production_No,
        production_master.PONo,		(Date_Format(production_master.Date,'%d-%m-%Y')) As Search_Date, production_master.User_Id ,Stock_Id,Shift_End_Master_Id,Production_Status,
		Item_Id ,Item_Name,WareHouse_Id, WareHouse_Name ,Quantity, Order_Status_Name, Reference_Field,PInvoice_No
	From production_master 
        inner join order_status on production_master.Production_Status=order_status.Order_Status_Id
		where production_master.DeleteStatus=false and production_master.Production_Status=9 ", Search_Date_ ,SearchbyName_Value, " Order By  Production_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_Completed_List`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),PONo_ varchar(100),PInvoice_No_ decimal(18,0),User_Type_ int,Employee_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Proforma_Invoice_Master.Entry_Date >= '", From_Date_ ,"' and  Proforma_Invoice_Master.Entry_Date <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Proforma_Invoice_Master.Client_Accounts_Id =",Account_Party_Id_);
end if;
if PONo_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.PONo ,'')  =",PONo_);
end if;

if PInvoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.PInvoice_No ,'')  =",PInvoice_No_);
end if;
if User_Type_=2 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.Employee_Id ,'')  =",Employee_Id_);
end if;

SET @query = Concat("SELECT Proforma_Invoice_Master_Id,(Date_Format(proforma_invoice_master.Entry_Date,'%d-%m-%Y')) As search_date,
	Shipment_Master_Id,(Date_Format(proforma_invoice_master.Entry_Date,'%Y-%m-%d')) As Entry_Date,proforma_invoice_master.Client_Accounts_Id,Company_Id,User_Id,PONo,PInvoice_No,BillType,
    Gross_Total,Total_Discount,Net_Total,TotalAmount,Total_CGST,TotalSGST,TotalIGST,TotalGST,Roundoff,GrandTotal,Payment_Status,Description,Proforma_Status,Currency ,
	Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,Client_Accounts.Address2,proforma_invoice_master.Employee_Id,Employee.User_Details_Name as Employee_Name,
    Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,Client_Accounts.GSTNo,Client_Accounts.PinCode,Order_Status.Order_Status_Id,
    Order_Status_Name,Reference_Field,proforma_invoice_master.PONo
	
    FROM proforma_invoice_master
	INNER JOIN Client_Accounts ON proforma_invoice_master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id 
	INNER JOIN user_details  Employee ON proforma_invoice_master.Employee_Id=Employee.User_Details_Id 
    inner join Order_Status on Order_Status.Order_Status_Id=proforma_invoice_master.Proforma_Status
	WHERE Proforma_Status =9 and proforma_invoice_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"");

 PREPARE QUERY FROM @query;
 EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_List`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),PONo_ varchar(100),PInvoice_No_ decimal(18,0),User_Type_ int,Employee_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Proforma_Invoice_Master.Entry_Date >= '", From_Date_ ,"' and  Proforma_Invoice_Master.Entry_Date <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Proforma_Invoice_Master.Client_Accounts_Id =",Account_Party_Id_);
end if;
if PONo_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.PONo ,'')  =",PONo_);
end if;

if PInvoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.PInvoice_No ,'')  =",PInvoice_No_);
end if;
if User_Type_=2 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.Employee_Id ,'')  =",Employee_Id_);
end if;

SET @query = Concat("SELECT Proforma_Invoice_Master_Id,(Date_Format(proforma_invoice_master.Entry_Date,'%d-%m-%Y')) As search_date,
	Shipment_Master_Id,(Date_Format(proforma_invoice_master.Entry_Date,'%Y-%m-%d')) As Entry_Date,proforma_invoice_master.Client_Accounts_Id,Company_Id,User_Id,PONo,PInvoice_No,BillType,
    Gross_Total,Total_Discount,Net_Total,TotalAmount,Total_CGST,TotalSGST,TotalIGST,TotalGST,Roundoff,GrandTotal,Payment_Status,Description,Proforma_Status,Currency ,
	Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,Client_Accounts.Address2,proforma_invoice_master.Employee_Id,Employee.User_Details_Name as Employee_Name,
    Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,Client_Accounts.GSTNo,Client_Accounts.PinCode,Order_Status.Order_Status_Id,
    Order_Status_Name,Reference_Field,proforma_invoice_master.PONo,	ifnull(proforma_invoice_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id
    FROM proforma_invoice_master
	INNER JOIN Client_Accounts ON proforma_invoice_master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id 
	INNER JOIN user_details  Employee ON proforma_invoice_master.Employee_Id=Employee.User_Details_Id 
    inner join Order_Status on Order_Status.Order_Status_Id=proforma_invoice_master.Proforma_Status
	WHERE Proforma_Status not in(3,9) and proforma_invoice_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"");

 PREPARE QUERY FROM @query;EXECUTE QUERY;
 # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_Master_Typeahead`(In Production_Number_ varchar(50))
BEGIN
set Production_Number_ = Concat( '%',Production_Number_ ,'%');
select Production_Master_Id,Prodction_No,Item.Item_Name,production_master.Item_Id
from production_master
inner join Item on Item.Item_Id=production_master.Item_Id
where Prodction_No like Production_Number_ and production_master.DeleteStatus=false;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_No_Typeahead`(In Production_No_ int )
Begin 
	select Production_No,Item_Name,Production_Master_Id,ifnull(Purchase_Order_Master_Id,0)Purchase_Order_Master_Id from production_master     
	where Production_No=(case when Production_No_>0 then Production_No_ else Production_No end)         
	and production_master.Production_Status <>9 and DeleteStatus=False;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_Raw_Report`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,PO_No_ int,Item_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
 set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and production_master.Date >= '", From_Date_ ,"' and  production_master.Date <= '", To_Date_,"'");
end if;
if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.Production_No =",PO_No_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_details_rawmaterial.Item_Stock_Id =",Item_Id_);
end if;

SET @query = Concat("SELECT production_master.Production_Master_Id ,(Date_Format(production_master.Date,'%d-%m-%Y')) As Date ,
        Production_No, production_master.PONo,production_details_rawmaterial.Item_Name,production_details_rawmaterial.Item_Id,
        No_Quantity
	From production_master 
        inner join production_details_rawmaterial on production_master.Production_Master_Id=production_details_rawmaterial.Production_Master_Id
		where production_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " Order By  production_master.Production_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_Ref_Typeahead`(in Proforma_Id_ int,Production_No_ int )
Begin 
	select Production_Master_Id,Production_No,Item_Name
    from production_master     
	where Production_No=(case when Production_No_>0 then Production_No_ else Production_No end)  
	#and production_master.Production_Status <>9 
    and Proforma_Invoice_Master_Id=Proforma_Id_ and production_master.DeleteStatus=False;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_Report`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,PO_No_ int,Item_Id_ int,WareHouse_Id_ int,Company_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
 set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and production_master.Date >= '", From_Date_ ,"' and  production_master.Date <= '", To_Date_,"'");
end if;
if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.PONo =",PO_No_);
end if;
if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.Company_Id =",Company_Id_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.Item_Id =",Item_Id_);
end if;
if WareHouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.WareHouse_Id =",WareHouse_Id_);
end if;

SET @query = Concat("
		SELECT (Date_Format(production_master.Expected_Production_Date,'%Y-%m-%d')) As Expected_Production_Date ,
		Production_Master_Id ,(Date_Format(production_master.Date,'%Y-%m-%d')) As Date ,production_master.Proforma_Invoice_Master_Id,Proforma_Invoice_Details_Id,Production_No,
        production_master.PONo,		(Date_Format(production_master.Date,'%d-%m-%Y')) As Search_Date, production_master.User_Id ,Stock_Id,Shift_End_Master_Id,Production_Status,
		Item_Id ,Item_Name,WareHouse_Id, WareHouse_Name ,Quantity, Order_Status_Name, Reference_Field,PInvoice_No,
        production_master.Company_Id,Company_Name
	From production_master 
        inner join order_status on production_master.Production_Status=order_status.Order_Status_Id
        inner join company on company.Company_Id=production_master.Company_Id
      
		where production_master.DeleteStatus=false and
        production_master.Production_Status=7 ", Search_Date_ ,SearchbyName_Value , " Order By  Production_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Production_Wastage_Report`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,PO_No_ int,Item_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
 set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and production_master.Date >= '", From_Date_ ,"' and  production_master.Date <= '", To_Date_,"'");
end if;
if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_master.Production_No =",PO_No_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and production_details_wastage.Item_Stock_Id =",Item_Id_);
end if;

SET @query = Concat("SELECT production_master.Production_Master_Id ,(Date_Format(production_master.Date,'%d-%m-%Y')) As Date ,
        Production_No, production_master.PONo,production_details_wastage.Item_Name,production_details_wastage.Item_Id,
        Quantitypers
	From production_master 
        inner join production_details_wastage on production_master.Production_Master_Id=production_details_wastage.Production_Master_Id
		where production_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " Order By  production_master.Production_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Proforma_Invoice_Master`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),PONo_ varchar(100),PInvoice_No_ decimal(18,0))
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Proforma_Invoice_Master.Entry_Date >= '", From_Date_ ,"' and  Proforma_Invoice_Master.Entry_Date <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Proforma_Invoice_Master.Client_Accounts_Id =",Account_Party_Id_);
end if;
if PONo_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.PONo ,'')  =",PONo_);
end if;
if PInvoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Proforma_Invoice_Master.PInvoice_No ,'')  =",PInvoice_No_);
end if;
SET @query = Concat("SELECT Proforma_Invoice_Master_Id,(Date_Format(proforma_invoice_master.Entry_Date,'%d-%m-%Y'))As search_date,Shipment_Master_Id,
(Date_Format(proforma_invoice_master.Entry_Date,'%Y-%m-%d'))As Entry_Date,(Date_Format(proforma_invoice_master.PO_Date,'%Y-%m-%d'))As PO_Date,(Date_Format(proforma_invoice_master.Expected_Date,'%Y-%m-%d'))As Expected_Date,
proforma_invoice_master.Client_Accounts_Id,proforma_invoice_master.Company_Id,User_Id,PONo,PInvoice_No,BillType,Gross_Total,Total_Discount,Net_Total,
TotalAmount,Total_CGST,TotalSGST,TotalIGST,TotalGST,Roundoff,GrandTotal,Payment_Status,Description,Proforma_Status,Currency,
Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,Client_Accounts.Address2,Sales_Master_Id,proforma_invoice_master.Employee_Id,
Employee.User_Details_Name as Employee_Name,Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,Client_Accounts.GSTNo,
Client_Accounts.PinCode,Order_Status.Order_Status_Id,Order_Status_Name,(Date_Format(proforma_invoice_master.Valid_Date,'%Y-%m-%d'))As Valid_Date,
Pallet_Weight,Total_Weight,Net_Weight,Product_Name,Customer_Code,Delivery_Term,Delivery_Period,Container,Container_Id,Payment_term ,
Bank_Id,Bank.Client_Accounts_Name Bank_Name,Bank.Address1 Holder,Bank.Address2 Accno,Bank.Address3 Swift,Bank.Address4 Branch,Bank.PinCode Ifsc,
proforma_invoice_master.Reference_Number,Reference_Field,Currency_Rate,ifnull(proforma_invoice_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,
CASE WHEN proforma_invoice_master.Production_Status=0 THEN 'Move To Production' Else 'Cancel Production' END Proforma_Caption,
proforma_invoice_master.Proforma_Invoice_Master_Id,proforma_invoice_master.Proforma_Status,
CASE WHEN proforma_invoice_master.Sales_Master_Id >0 THEN 'View Sales Invoice' ELSE 'Make Sales Invoice' END Sales_Caption, 
proforma_invoice_master.Proforma_Invoice_Master_Id,proforma_invoice_master.Sales_Master_Id,
company.Company_Name ,company.Address1 Company_Address1,company.Address2 Company_Address2,company.Address3 Company_Address3,
company.Address4 Company_Address4,company.Mobile_Number,company.Phone_Number,company.EMail,Total_Packing_packages,Total_Packing,Packing_NetWeight,Packing_GrossWeight
FROM proforma_invoice_master INNER JOIN Client_Accounts 
ON proforma_invoice_master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id Left JOIN Client_Accounts Bank 
ON proforma_invoice_master.Bank_Id=Bank.Client_Accounts_Id left JOIN user_details Employee 
ON proforma_invoice_master.Employee_Id=Employee.User_Details_Id inner join Order_Status 
on Order_Status.Order_Status_Id=proforma_invoice_master.Proforma_Status inner join company 
ON proforma_invoice_master.Company_Id=company.Company_Id
WHERE proforma_invoice_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value , " order by Proforma_Invoice_Master_Id asc");
 PREPARE QUERY FROM @query;EXECUTE QUERY;
 # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Details`( In Purchase_Details_Name_ varchar(100))
Begin 
 set Purchase_Details_Name_ = Concat( '%',Purchase_Details_Name_ ,'%');
 SELECT Purchase_Details_Id,Purchase_Master_Id,StockId,ItemId,Barcode,ItemName,Packing_Size,Colour,Description,UnitId,UnitName,GroupId,GroupName,
HSN_Id,HSN_CODE,MFCode,UPC,SaleRate,MRP,Unit_Price,Quantity,Amount,Discount,Netvalue,CGST,CGST_AMT,SGST,SGST_AMT,IGST,TGST_AMT,GST,GST_Amount,
Include_Tax,WareHouse_Id,WareHouse_Name,Is_Expiry,Expiry_Date
 From Purchase_Details where Purchase_Details_Name like Purchase_Details_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Master`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),Invoice_No_ varchar(50),Purchase_Type_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Purchase_Master.PurchaseDate >= '", From_Date_ ,"' and  Purchase_Master.PurchaseDate <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Purchase_Master.Account_Party_Id =",Account_Party_Id_);
end if;
if Invoice_No_!='' then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Purchase_Master.InvoiceNo like '%",Invoice_No_ ,"%' ");
end if;
/*
if Purchase_Type_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Purchase_Master.Purchase_Type_Id =",Purchase_Type_);
end if;*/
SET @query = Concat("
	SELECT  Purchase_Master_Id ,(Date_Format(Purchase_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,Account_Party_Id,Purchase_Type_Id,
	(Date_Format(PurchaseDate,'%d-%m-%Y')) As Search_Date, (Date_Format(PurchaseDate,'%Y-%m-%d')) As PurchaseDate ,Grand_Total,
	InvoiceNo ,GrossTotal,TotalDiscount, NetTotal ,TotalCGST,TotalSGST,TotalIGST,TotalGST,TotalAmount,Discount,Roundoff,Other_Charges,BillType,User_Id,Description,
	Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,Address2,Address3,Address4,PinCode,GSTNo,Mobile,Purchase_Master.Company_Id,Group_Id
	From Purchase_Master 
	INNER JOIN Client_Accounts ON Purchase_Master.Account_Party_Id=Client_Accounts.Client_Accounts_Id
	where  Purchase_Type_Id =", Purchase_Type_," and   Purchase_Master.DeleteStatus=false ", Search_Date_ ,
    SearchbyName_Value, " order by Purchase_Master_Id asc ");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
  # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Master_Order`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),Invoice_No_ varchar(50),Purchase_Type_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and purchase_master_order.PurchaseDate >= '", From_Date_ ,"' and  purchase_master_order.PurchaseDate <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_master_order.Account_Party_Id =",Account_Party_Id_);
end if;
if Invoice_No_!='' then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_master_order.InvoiceNo like '%",Invoice_No_ ,"%' ");
end if;
/*
if Purchase_Type_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Purchase_Master.Purchase_Type_Id =",Purchase_Type_);
end if;*/
SET @query = Concat("
	SELECT  Purchase_Master_Id ,(Date_Format(purchase_master_order.Entry_Date,'%Y-%m-%d')) As Entry_Date ,Account_Party_Id,Purchase_Type_Id,
	(Date_Format(PurchaseDate,'%d-%m-%Y')) As Search_Date, (Date_Format(PurchaseDate,'%Y-%m-%d')) As PurchaseDate ,Grand_Total,
	InvoiceNo ,GrossTotal,TotalDiscount, NetTotal ,TotalCGST,TotalSGST,TotalIGST,TotalGST,TotalAmount,Discount,Roundoff,Other_Charges,BillType,User_Id,Description,
	Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,Address2,Address3,Address4,PinCode,GSTNo,Mobile,purchase_master_order.Company_Id,
    Currency_Id,Currency_Name,Group_Id
	From purchase_master_order 
	INNER JOIN Client_Accounts ON purchase_master_order.Account_Party_Id=Client_Accounts.Client_Accounts_Id
	where  Purchase_Type_Id =", Purchase_Type_," and   purchase_master_order.DeleteStatus=false ", Search_Date_ ,
    SearchbyName_Value, " order by Purchase_Master_Id asc ");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
  # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Master_Report`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Account_Party_Id_ decimal(18,0),Invoice_No_ varchar(50),Purchase_Type_ int,
Item_Id_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Purchase_Master.PurchaseDate >= '", From_Date_ ,"' and  Purchase_Master.PurchaseDate <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Purchase_Master.Account_Party_Id =",Account_Party_Id_);
end if;
if Invoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Purchase_Master.InvoiceNo ,'')  =",Invoice_No_);
end if;

if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_details.ItemId =",Item_Id_);
end if;
SET @query = Concat("
	SELECT  Purchase_Master.Purchase_Master_Id ,(Date_Format(Purchase_Master.Entry_Date,'%d-%m-%Y')) As Search_date ,
    Account_Party_Id,Client_Accounts.Client_Accounts_Name,InvoiceNo,purchase_details.TotalAmount,ItemName,
    WareHouse_Name,Quantity
	From Purchase_Master 
	INNER JOIN purchase_details ON purchase_details.Purchase_Master_Id=Purchase_Master.Purchase_Master_Id
	INNER JOIN Client_Accounts ON Purchase_Master.Account_Party_Id=Client_Accounts.Client_Accounts_Id
	where  Purchase_Type_Id =", Purchase_Type_," and   Purchase_Master.DeleteStatus=false 
    ", Search_Date_ ,SearchbyName_Value , " order by Purchase_Master.Purchase_Master_Id asc ");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Order_Customer`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,PONo_ varchar(100),Client_Id_ int,Order_Status_ int,Reference_Field_ varchar(50))
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and purchase_order_customer.Entry_Date >= '", From_Date_ ,"' and  purchase_order_customer.Entry_Date <= '", To_Date_,"'");
end if;
if PONo_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( purchase_order_customer.PONo ,'')  =",PONo_);
end if;
if Client_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_order_customer.User_Id =",Client_Id_);
end if;
if Order_Status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_order_customer.Order_Status =",Order_Status_);
end if;

if Reference_Field_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( purchase_order_customer.Reference_Field ,'')  =",Reference_Field_);
end if;
SET @query = Concat("SELECT  Purchase_Order_Customer_Id ,(Date_Format(purchase_order_customer.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
	Company_Id,User_Id,PONo,Currency,Shipment_Method_Id,Payment_Term,Delivery_Port,Shipmet_Plan_Id,No_of_Shipment,
    Description,Order_Status,TotalAmount,Client_Accounts_Name,Purchase_Order_Master_Id,Order_Status_Name,
    (Date_Format(purchase_order_customer.Delivery_Date,'%Y-%m-%d')) As Delivery_Date ,
    CASE WHEN purchase_order_customer.Purchase_Order_Master_Id >0 THEN 'View Purchase Order' ELSE  'Make Purchase Order'
    END Purchase_Option,Purchase_Order_Master_Id,purchase_order_customer.Reference_Field,
    (Date_Format(purchase_order_customer.Entry_Date,'%d-%m-%Y')) As Search_Date 
	From purchase_order_customer   
    inner join client_accounts on client_accounts.Client_Accounts_Id=purchase_order_customer.User_Id
    inner join order_status on purchase_order_customer.Order_Status=order_status.Order_Status_Id    
	where purchase_order_customer.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value,"  order by Purchase_Order_Customer_Id  asc");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Order_Master`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int,PONo_ varchar(100),Order_Status_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Purchase_Order_Master.Entry_Date >= '", From_Date_ ,"' and  Purchase_Order_Master.Entry_Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Purchase_Order_Master.Client_Accounts_Id =",Client_Accounts_Id_);
end if;
if PONo_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Purchase_Order_Master.PONo ,'')  =",PONo_);
end if;
if Order_Status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Purchase_Order_Master.Order_Status =",Order_Status_);
end if;

SET @query = Concat("SELECT  Purchase_Order_Master_Id ,(Date_Format(Purchase_Order_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
	(Date_Format(Purchase_Order_Master.Entry_Date,'%d-%m-%Y')) Search_Date,
    Purchase_Order_Master.Client_Accounts_Id,Company_Id,User_Id,PONo,(Date_Format(Delivery_Date,'%Y-%m-%d')) As Delivery_Date ,
	Currency,Shipment_Method_Id,Price_Method,Payment_Term,Shipping_Port,Delivery_Port,Shipmet_Plan_Id,No_of_Shipment,Description,Order_Status,TotalAmount, 
	Client_Accounts.Client_Accounts_Name,Client_Accounts.Address1,Address2,Address3,Address4,PinCode,GSTNo,Mobile,
    Order_Status_Name,Purchase_Order_Customer_Id
	From Purchase_Order_Master 
    INNER JOIN Client_Accounts ON Purchase_Order_Master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id
    inner join order_status on Purchase_Order_Master.Order_Status=order_status.Order_Status_Id    
	where Purchase_Order_Master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " 
    order by Purchase_Order_Master_Id  asc");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
# select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Order_Track_Customer`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,PONo_ varchar(100),Client_Id_ int,Order_Status_ int,Reference_Field_ varchar(50))
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";

SET @query = Concat("SELECT  Purchase_Order_Track_Master_Id Purchase_Order_Customer_Id,(Date_Format(purchase_order_track_master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
	(Date_Format(purchase_order_track_master.Entry_Date,'%d-%m-%Y')) Search_Date,
    purchase_order_track_master.Customer_Id Client_Accounts_Id,PONo,Description,purchase_order_track_master.Order_Status_Name,Invoice_Amount , 
	Client_Accounts.Client_Accounts_Name,Description,purchase_order_track_master.Order_Status_Id,purchase_order_track_master.Order_Status_Name,Payment_Status_Id,Payment_Status_Name,Track,Eta_No,Port_Name,Container_No,Customer_Refno,
    Invoice_No
    ,(Date_Format(purchase_order_track_master.Po_Date,'%Y-%m-%d')) As Po_Date,(Date_Format(purchase_order_track_master.Invoice_Date,'%Y-%m-%d')) As Invoice_Date,(Date_Format(purchase_order_track_master.Payment_Date,'%Y-%m-%d')) As Payment_Date
	From purchase_order_track_master 
    INNER JOIN Client_Accounts ON purchase_order_track_master.Customer_Id=Client_Accounts.Client_Accounts_Id
    inner join order_status on purchase_order_track_master.Order_Status_Id=order_status.Order_Status_Id    
	where purchase_order_track_master.DeleteStatus=false and purchase_order_track_master.Customer_Id=", Client_Id_ ,"
    order by Purchase_Order_Track_Master_Id  asc");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Order_Track_Master`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int,PONo_ varchar(100),Order_Status_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and date(purchase_order_track_master.Entry_Date) >= '", From_Date_ ,"' and  date(purchase_order_track_master.Entry_Date) <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_order_track_master.Customer_Id =",Client_Accounts_Id_);
end if;
if PONo_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( purchase_order_track_master.PONo ,'')  =",PONo_);
end if;
if Order_Status_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_order_track_master.Order_Status =",Order_Status_);
end if;

SET @query = Concat("SELECT  Purchase_Order_Track_Master_Id ,(Date_Format(purchase_order_track_master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
	(Date_Format(purchase_order_track_master.Entry_Date,'%d-%m-%Y')) Search_Date,
    purchase_order_track_master.Customer_Id Client_Accounts_Id,PONo,Description,purchase_order_track_master.Order_Status_Name,Invoice_Amount , 
	Client_Accounts.Client_Accounts_Name,Description,purchase_order_track_master.Order_Status_Id,purchase_order_track_master.Order_Status_Name,Payment_Status_Id,Payment_Status_Name,Track,Eta_No,Port_Name,Container_No,Customer_Refno,Invoice_Date,
    Invoice_No,Po_Date,Payment_Date
	From purchase_order_track_master 
    INNER JOIN Client_Accounts ON purchase_order_track_master.Customer_Id=Client_Accounts.Client_Accounts_Id
    inner join order_status on purchase_order_track_master.Order_Status_Id=order_status.Order_Status_Id    
	where purchase_order_track_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " 
    order by Purchase_Order_Track_Master_Id  asc");
  PREPARE QUERY FROM @query; EXECUTE QUERY; 
  
 # insert into db_logs values('',@query,'',0);
# select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Return_Master`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int,Invoice_No_ varchar(100))
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and purchase_return_master.Entry_Date >= '", From_Date_ ,"' and  purchase_return_master.Entry_Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and purchase_return_master.Client_Accounts_Id =",Client_Accounts_Id_);
end if;
if Invoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( purchase_return_master.Invoice_No ,'')  =",Invoice_No_);
end if;
SET @query = Concat("SELECT Purchase_Return_Master_Id,(Date_Format(purchase_return_master.Entry_Date,'%d-%m-%Y')) As Search_Date,
 (Date_Format(purchase_return_master.Entry_Date,'%Y-%m-%d')) As Entry_Date,(Date_Format(purchase_return_master.Purchase_Date,'%Y-%m-%d')) As Purchase_Date,
 purchase_return_master.Client_Accounts_Id,User_Id,User_Id,Purchase_Type_Id, Invoice_No,
Gross_Total,Total_Discount,Net_Total,Total_CGST,Total_SGST,Total_IGST,Total_GST,Total_Amount,Round_off,Discount,Grand_Total,Description,
Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,purchase_return_master.Bill_Type,purchase_return_master.Company_Id,
Client_Accounts.Address2,Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,GSTNo,PinCode
FROM purchase_return_master
 INNER JOIN Client_Accounts ON purchase_return_master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id 

WHERE purchase_return_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"");

  PREPARE QUERY FROM @query;EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Purchase_Type`(IN Purchase_Type_Name_ varchar(500))
Begin 
 set Purchase_Type_Name_ = Concat( '%',Purchase_Type_Name_ ,'%');
 SELECT Purchase_Type_Id,Purchase_Type_Name,Status,Email
 From purchase_type where Purchase_Type_Name like Purchase_Type_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Ref_No_Typeahead`(In Ref_No_ varchar(50) )
Begin 
 set Ref_No_ = Concat( '%',Ref_No_ ,'%');
SELECT Reference_Field,Proforma_Invoice_Master_Id
From proforma_invoice_master
where Reference_Field like Ref_No_  and proforma_invoice_master.DeleteStatus=false
ORDER BY Reference_Field ASC LIMIT 5;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Salary_Calculation_Master`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Salary_Calculation_Master.Entry_Date >= '", From_Date_ ,"' and  Salary_Calculation_Master.Entry_Date <= '", To_Date_,"'");
end if;
/*if Process_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Salary_Calculation_Master.Process_Id =",Process_Id_);
end if;*/
SET @query = Concat(" SELECT (Date_Format(Salary_Calculation_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date ,
 (Date_Format(Salary_Calculation_Master.From_Date,'%Y-%m-%d')) As From_Date,(Date_Format(Salary_Calculation_Master.To_Date,'%Y-%m-%d')) As To_Date,
	(Date_Format(Salary_Calculation_Master.Entry_Date,'%d-%m-%Y')) As Search_Date,User_Id,Total,Calculation_No,Salary_Calculation_Master_Id
    From Salary_Calculation_Master 
	where Salary_Calculation_Master.DeleteStatus=false ", Search_Date_ , " Order By  Salary_Calculation_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Salary_Calculation_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Calculation_No_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat("and Salary_Calculation_Master.From_Date >= '",From_Date_ ,"'and Salary_Calculation_Master.To_Date <='",To_Date_,"'");
end if;
if Calculation_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Salary_Calculation_Master.Calculation_No =",Calculation_No_);
end if;
SET @query = Concat("SELECT (Date_Format(Salary_Calculation_Master.Entry_Date,'%d-%m-%Y')) As Search_Date,
Calculation_No,Employee_Name,Normal_Total,Ot_Total,Loading_Total,Piece_Total,Other_Total,TotalAmount  
From Salary_Calculation_Master INNER JOIN salary_calculation_details
ON Salary_Calculation_Master.Salary_Calculation_Master_Id=salary_calculation_details.Salary_Calculation_Master_Id 

where Salary_Calculation_Master.DeleteStatus=false ",Search_Date_,SearchbyName_Value," Order By  
Salary_Calculation_Master.Salary_Calculation_Master_Id asc");
PREPARE QUERY FROM @query; EXECUTE QUERY;      
#select @query;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Sale_Unit`( In Sale_Unit_Name_ varchar(100))
Begin 
 set Sale_Unit_Name_ = Concat( '%',Sale_Unit_Name_ ,'%');
 SELECT Sale_Unit_Id,
Sale_Unit_Code,
Sale_Unit_Name From Sale_Unit where Sale_Unit_Name like Sale_Unit_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Sales_Master`( In Is_Date_Check_ tinyint,From_Date_ datetime,To_Date_ datetime,
Account_Party_Id_ decimal(18,0),Invoice_No_ decimal(18,0),BillType_ int,Sales_Type int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Sales_Master.Entry_Date >= '", From_Date_ ,"' and  Sales_Master.Entry_Date <= '", To_Date_,"'");
end if;
if Account_Party_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Sales_Master.Account_Party_Id =",Account_Party_Id_);
end if;
if Invoice_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( Sales_Master.Invoice_No ,'')  =",Invoice_No_);
end if;
if BillType_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Sales_Master.BillType =",BillType_);
end if;
if Sales_Type>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Sales_Master.Sales_Type =",Sales_Type);
end if;
SET @query = Concat("SELECT Sales_Master_Id,(Date_Format(Sales_Master.Entry_Date,'%d-%m-%Y')) As search_date,
Sales_Master_Id,(Date_Format(Sales_Master.Entry_Date,'%Y-%m-%d')) As Entry_Date,(Date_Format(Sales_Master.Entry_Date,'%d-%m-%Y')) As Search_Date,
Sales_Master.PONo,ifnull(Sales_Master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,Sales_Master_Id,
(Date_Format(Sales_Master.PO_Date,'%Y-%m-%d')) As PO_Date,Account_Party_Id,Sales_Master.Company_Id,User_Id,GrossTotal, 
Invoice_No,GrandTotal,TotalDiscount,NetTotal,TotalCGST,ToalSGST,TotalIGST,Cess,RoundOff,TotalAmount,TotalGST,ifnull(Sales_Master.Discount,0)Discount,Currency,
Sales_Master.Description1,Bill_Type_Name,BillType,Proforma_Invoice_Master_Id,Currency_Rate,Account_Party_Id,Client_Accounts.Client_Accounts_Name as Customer,
Client_Accounts.Address1,Client_Accounts.Address2,Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,client_accounts.GSTNo,
client_accounts.PinCode,Pallet_Weight,Total_Weight,Net_Weight,TypeofContainer,ContainerNo,Typeofpackage,Exporterref,Otherref,Precarriage,
Vessalno,Contryoforgin,Contrydestination,PlaceofReceipt,Bank_Id,Bank.Client_Accounts_Name Bank_Name,Bank.Address1 Holder,Bank.Address2 Accno,
Bank.Address3 Swift,Bank.Address4 Branch,Bank.PinCode Ifsc,Portofloading,Portofdischarge,Finaldestination,Termsofdelivery,BI_No,ETA,Sales_Master.Status,
Tracking_Id,Shipment_Status,Product_Description,Total_Packing_packages,Total_Packing,Packing_NetWeight,Packing_GrossWeight,
company.Company_Name ,company.Address1 Company_Address1,company.Address2 Company_Address2,company.Address3 Company_Address3,
company.Address4 Company_Address4,company.Mobile_Number,company.GSTNO GST_No,company.IEC,company.Phone_Number,company.EMail,company.RegNo,
BL,BL_FileName,PackingList,PackingList_FileName,Invoice,Invoice_FileName
FROM Sales_Master
INNER JOIN Client_Accounts ON Sales_Master.Account_Party_Id=Client_Accounts.Client_Accounts_Id 
left JOIN Client_Accounts Bank ON Sales_Master.Bank_Id=Bank.Client_Accounts_Id 
inner join Bill_Type ON Sales_Master.BillType=Bill_Type.Bill_Type_Id
inner join company ON Sales_Master.Company_Id=company.Company_Id
WHERE Sales_Master.DeleteStatus =false ", Search_Date_ ,SearchbyName_Value," Order by Sales_Master_Id asc");
PREPARE QUERY FROM @query;EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Shift_Details`(IN Shift_Details_Name_ varchar(500))
Begin 
 set Shift_Details_Name_ = Concat( '%',Shift_Details_Name_ ,'%');
 SELECT Shift_Details_Id,Shift_Details_Name,Status
 From shift_details where Shift_Details_Name like Shift_Details_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Shift_End`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Production_No_ int,Process_Id_ int,Item_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and shift_end_master.Date >= '", From_Date_ ,"' and  shift_end_master.Date <= '", To_Date_,"'");
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.Production_No =",Production_No_);
end if;
if Process_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.Process_List_Id =",Process_Id_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.Item_Id =",Item_Id_);
end if;
SET @query = Concat(" SELECT (Date_Format(shift_end_master.Date,'%Y-%m-%d')) As Date,(Date_Format(shift_end_master.Date,'%d-%m-%Y')) As Search_Date,
shift_end_master.Shift_End_Master_Id,shift_end_master.Press_Details_Id,shift_end_master.Production_No,shift_end_master.Production_Master_Id,
ifnull(shift_end_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id,
shift_end_master.Process_List_Id,shift_end_master.Shift_Details_Id,Shift_End_No,OutputNo,Acceptable,Damage,Wastage,shift_end_master.User_Id,
shift_end_master.Stock_Id,shift_end_master.Item_Id,shift_end_master.Item_Name,shift_end_master.WareHouse_Id,shift_end_master.WareHouse_Name,
Process_Details_Name Process_Name,Shift_Details_Name,Press_Details_Name ,Production_Damage,Reference_Field,PInvoice_No,shift_end_master.Company_Id,
Company.Company_Name,shift_end_master.Weight_Description,shift_end_master.Weight,shift_end_master.Batch_Weight,shift_end_master.Weight_Item,Position_Id,Batch_No
From shift_end_master 
inner join Company on Company.Company_Id=shift_end_master.Company_Id
INNER JOIN production_master ON shift_end_master.Production_Master_Id=production_master.Production_Master_Id
INNER JOIN process_details ON shift_end_master.Process_List_Id=process_details.Process_Details_Id
INNER JOIN shift_details ON shift_end_master.Shift_Details_Id=shift_details.Shift_Details_Id
INNER JOIN press_details ON shift_end_master.Press_Details_Id=press_details.Press_Details_Id
where shift_end_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " Order By  Shift_End_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Shift_End_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Production_No_ int,WareHouse_Id_ int,Item_Id_ int,Company_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and shift_end_master.Date >= '", From_Date_ ,"' and  shift_end_master.Date <= '", To_Date_,"'");
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.Production_No =",Production_No_);
end if;
if WareHouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.WareHouse_Id =",WareHouse_Id_);
end if;
if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.Company_Id =",Company_Id_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.Item_Id =",Item_Id_);
end if;
SET @query = Concat(" SELECT (Date_Format(shift_end_master.Date,'%Y-%m-%d')) As Date ,
	(Date_Format(shift_end_master.Date,'%d-%m-%Y')) As Search_Date,shift_end_master.Shift_End_Master_Id,shift_end_master.Press_Details_Id,shift_end_master.Production_No,shift_end_master.Production_Master_Id,
	shift_end_master.Process_List_Id,shift_end_master.Shift_Details_Id,Shift_End_No,OutputNo,Acceptable,Damage,Wastage,
	shift_end_master.User_Id,shift_end_master.Stock_Id,shift_end_master.Item_Id,shift_end_master.Item_Name,shift_end_master.WareHouse_Id,shift_end_master.WareHouse_Name,
	Process_Details_Name Process_Name,Shift_Details_Name,Press_Details_Name ,Production_Damage,Reference_Field,PInvoice_No
	From shift_end_master 
	INNER JOIN production_master ON shift_end_master.Production_Master_Id=production_master.Production_Master_Id
	INNER JOIN process_details ON shift_end_master.Process_List_Id=process_details.Process_Details_Id
	INNER JOIN shift_details ON shift_end_master.Shift_Details_Id=shift_details.Shift_Details_Id
	INNER JOIN press_details ON shift_end_master.Press_Details_Id=press_details.Press_Details_Id
	where shift_end_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, " Order By  Shift_End_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Shift_Start`( In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,PO_No_ int)
Begin 
 declare Search_Date_ varchar(500);
declare SearchbyName_Value varchar(2000);
set Search_Date_="";
set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and shift_start_master.Date >= '", From_Date_ ,"' and  shift_start_master.Date <= '", To_Date_,"'");
end if;
if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_start_master.Prodction_No =",PO_No_);
end if;
/*if PO_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Concat( production_master.Prodction_No ,'')  =",PO_No_);
end if;*/
SET @query = Concat("SELECT 
 Shift_Start_Master_Id ,(Date_Format(shift_start_master.Date,'%Y-%m-%d')) As Date ,shift_start_master.Production_Master_Id,shift_start_master.PONo,
 shift_start_master.Prodction_No,Shift_Start_No,(Date_Format(shift_start_master.Date,'%d-%m-%Y')) As Search_Date, shift_start_master.User_Id ,
 shift_start_master.Stock_Id,shift_start_master.Shift_End_Master_Id,shift_start_master.Item_Id ,shift_start_master.Item_Name,shift_start_master.WareHouse_Id,
 shift_start_master.WareHouse_Name,shift_start_master.Quantity,PInvoice_No,Reference_Field,shift_start_master.Company_Id,Company_Name,
 shift_start_master.Weight,shift_start_master.Batch_Weight,shift_start_master.Weight_Item,shift_start_master.Process_Id,
 Process_Details_Name Process_Name,shift_start_master.Shift_Details_Id,ifnull(shift_start_master.Purchase_Order_Master_Id,0)Purchase_Order_Master_Id
From shift_start_master 
inner join Company on shift_start_master.Company_Id=Company.Company_Id
INNER JOIN process_details ON shift_start_master.Process_Id=process_details.Process_Details_Id
inner join production_master on production_master.Production_Master_Id=shift_start_master.Production_Master_Id
where shift_start_master.DeleteStatus=false ",
 Search_Date_ ,SearchbyName_Value,"");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Shift_wastage_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Production_No_ int,Item_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and shift_end_master.Date >= '", From_Date_ ,"' and  shift_end_master.Date <= '", To_Date_,"'");
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_master.Production_No =",Production_No_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_end_details_wastage.Item_Stock_Id =",Item_Id_);
end if;
SET @query = Concat(" SELECT (Date_Format(shift_end_master.Date,'%d-%m-%Y')) As Search_Date,
	shift_end_master.Shift_End_Master_Id,shift_end_master.Production_No,shift_end_details_wastage.Item_Name,
    shift_end_details_wastage.Quantitypers
	From shift_end_master 
	INNER JOIN shift_end_details_wastage ON shift_end_master.Shift_End_Master_Id=shift_end_details_wastage.Shift_End_Master_Id
	where shift_end_master.DeleteStatus=false ", Search_Date_ ,SearchbyName_Value, "
    Order By  shift_end_master.Shift_End_Master_Id asc");
   PREPARE QUERY FROM @query; EXECUTE QUERY;      
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Shipment_Method`(IN Shipment_Method_Name_ varchar(500))
Begin 
 set Shipment_Method_Name_ = Concat( '%',Shipment_Method_Name_ ,'%');
 SELECT Shipment_Method_Id,Shipment_Method_Name,Status
 From shipment_method where Shipment_Method_Name like Shipment_Method_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Shipment_Plan`( In Shipment_Plan_Name_ varchar(100))
Begin 
 set Shipment_Plan_Name_ = Concat( '%',Shipment_Plan_Name_ ,'%');
 SELECT Shipment_Plan_Id,Shipment_Plan_Name,Status
 From shipment_plan where Shipment_Plan_Name like Shipment_Plan_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Stock_Add_Master`( In FromDate_ datetime,
 ToDate_ datetime,Is_Date_Check_ tinyint)
Begin 
declare Search_Date_ varchar(500);
set Search_Date_="";
 if Is_Date_Check_=true then
set Search_Date_=concat( " and Stock_Add_Master.Entry_Date >= '", FromDate_ ,"' and  
Stock_Add_Master.Entry_Date <= '", ToDate_,"'");
end if;
SET @query = Concat("SELECT Stock_Add_Master.Stock_Add_Master_Id,
(Date_Format(Stock_Add_Master.Entry_Date,'%Y-%m-%d')) as Entry_Date,
 (Date_Format(Stock_Add_Master.Entry_Date,'%d-%m-%Y')) As Search_Date, Stock_Add_Master.Description1,
User_Id,User_Details.User_Details_Name,Stock_Add_Master.Purchase_Type_Id,Stock_Add_Master.Company_Id
From Stock_Add_Master 

inner join User_Details on Stock_Add_Master.User_Id=User_Details.User_Details_Id
where Stock_Add_Master.DeleteStatus=false ", Search_Date_ ,"
 group by Stock_Add_Master.Stock_Add_Master_Id");
 
	PREPARE QUERY FROM @query;EXECUTE QUERY;
# select @query;
#sum(Quantity)TotalQuantity,cast(sum(SaleRate* Quantity)as decimal(18,2))TotalAmount,
#inner join Stock_Add_Details on Stock_Add_Master.Stock_Add_Master_Id=Stock_Add_Details.Stock_Add_Master_Id 
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Stock_Add_Report`( In FromDate_ datetime,
 ToDate_ datetime,Is_Date_Check_ tinyint,Item_Id_ int,Warehouse_Id_ int,Company_Id_ int)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
 if Is_Date_Check_=true then
set Search_Date_=concat( " and Stock_Add_Master.Entry_Date >= '", FromDate_ ,"' and  Stock_Add_Master.Entry_Date <= '", ToDate_,"'");
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_add_details.ItemId =",Item_Id_);
end if;
if Warehouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_add_details.WareHouse_Id =",Warehouse_Id_);
end if;
if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Stock_Add_Master.Company_Id =",Company_Id_);
end if;

SET @query = Concat("SELECT Stock_Add_Master.Stock_Add_Master_Id,(Date_Format(Stock_Add_Master.Entry_Date,'%d-%m-%Y')) As Search_Date,
ItemName,ItemId,WareHouse_Id,WareHouse_Name,Quantity,Stock_Add_Master.Company_Id
From Stock_Add_Master 
inner join stock_add_details on Stock_Add_Master.Stock_Add_Master_Id=stock_add_details.Stock_Add_Master_Id
where Stock_Add_Master.DeleteStatus=false ", Search_Date_ , SearchbyName_Value ,"
 Order by Stock_Add_Master.Stock_Add_Master_Id");
 
	PREPARE QUERY FROM @query;EXECUTE QUERY;
# select @query;
#sum(Quantity)TotalQuantity,cast(sum(SaleRate* Quantity)as decimal(18,2))TotalAmount,
#inner join Stock_Add_Details on Stock_Add_Master.Stock_Add_Master_Id=Stock_Add_Details.Stock_Add_Master_Id 
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Stock_Report`( In ItemId_ int,WareHouse_Id_ int,Company_Id_ int,Item_Group_Id_ int)
Begin 
declare SearchbyName_Value varchar(2000);set SearchbyName_Value="";

if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_details.Company_Id =",Company_Id_);
end if;
if ItemId_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock.ItemId =",ItemId_);
end if;
if Item_Group_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock.Group_Id =",Item_Group_Id_);
end if;
if WareHouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_details.WareHouse_Id =",WareHouse_Id_);
end if;
SET @query = Concat("SELECT ItemName,Group_Name,stock_details.Quantity,WareHouse_Name,Barcode
		FROM stock
		INNER JOIN stock_details ON stock_details.Stock_Id=stock.Stock_Id  
		INNER JOIN warehouse ON stock_details.WareHouse_Id=warehouse.WareHouse_Id  
		WHERE stock.DeleteStatus =false" ,SearchbyName_Value,"");
  PREPARE QUERY FROM @query;EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Stock_Transfer_Master`( In FromDate_ datetime,
 ToDate_ datetime,Is_Date_Check_ tinyint)
Begin 
declare Search_Date_ varchar(500);
set Search_Date_="";
 if Is_Date_Check_=true then
set Search_Date_=concat( " and Stock_Transfer_Master.Entry_Date >= '", FromDate_ ,"' and  
Stock_Transfer_Master.Entry_Date <= '", ToDate_,"'");
end if;
SET @query = Concat("SELECT Stock_Transfer_Master.Stock_transfer_Master_Id,
(Date_Format(Stock_Transfer_Master.Entry_Date,'%Y-%m-%d')) as Entry_Date, (Date_Format(Stock_Transfer_Master.Entry_Date,'%d-%m-%Y')) As Search_Date, 
Stock_Transfer_Master.Description1,User_Id,User_Details.User_Details_Name,From_Company_Id,To_Company_Id
From Stock_Transfer_Master 
	INNER JOIN Company From_Comp ON Stock_Transfer_Master.From_Company_Id=From_Comp.Company_Id 
	INNER JOIN Company To_Comp ON Stock_Transfer_Master.To_Company_Id=To_Comp.Company_Id 
inner join User_Details on Stock_Transfer_Master.User_Id=User_Details.User_Details_Id
where Stock_Transfer_Master.DeleteStatus=false ", Search_Date_ ,"order by Stock_transfer_Master_Id asc");
 
	PREPARE QUERY FROM @query;EXECUTE QUERY;
# select @query;
#sum(Quantity)TotalQuantity,cast(sum(SaleRate* Quantity)as decimal(18,2))TotalAmount,
#inner join Stock_Add_Details on Stock_Add_Master.Stock_Add_Master_Id=Stock_Add_Details.Stock_Add_Master_Id 
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Stock_Transfer_Report`( In FromDate_ datetime,
 ToDate_ datetime,Is_Date_Check_ tinyint,Item_Id_ int,To_Warehouse_Id_ int,From_Warehouse_Id_ int,
 From_Company_Id_ int,To_Company_Id_ int)
Begin 
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
 if Is_Date_Check_=true then
	set Search_Date_=concat( " and Stock_Transfer_Master.Entry_Date >= '", FromDate_ ,"' and  Stock_Transfer_Master.Entry_Date <= '", ToDate_,"'");
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_transfer_details.Item_Id =",Item_Id_);
end if;
if To_Warehouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_transfer_details.From_Stock_Id =",To_Warehouse_Id_);
end if;
if From_Warehouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_transfer_details.To_Stock_Id =",From_Warehouse_Id_);
end if;
if From_Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_transfer_master.From_Company_Id =",From_Company_Id_);
end if;
if To_Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and stock_transfer_master.To_Company_Id =",To_Company_Id_);
end if;
SET @query = Concat("SELECT Stock_Transfer_Master.Stock_transfer_Master_Id,(Date_Format(Stock_Transfer_Master.Entry_Date,'%d-%m-%Y')) As Search_Date, 
From_Stock_Id,From_Stock_Name,To_Stock_Id,To_Stock_Name,Item_Name,Item_Id,Quantity
From Stock_Transfer_Master 
inner join stock_transfer_details on Stock_Transfer_Master.Stock_transfer_Master_Id=stock_transfer_details.Stock_transfer_Master_Id
where Stock_Transfer_Master.DeleteStatus=false ", Search_Date_ , SearchbyName_Value,"
order by Stock_Transfer_Master.Stock_transfer_Master_Id asc");
 
	PREPARE QUERY FROM @query;EXECUTE QUERY;
# select @query;
#sum(Quantity)TotalQuantity,cast(sum(SaleRate* Quantity)as decimal(18,2))TotalAmount,
#inner join Stock_Add_Details on Stock_Add_Master.Stock_Add_Master_Id=Stock_Add_Details.Stock_Add_Master_Id 
end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Stock_Use_Report`(in Is_Date_Check_ tinyint,From_Date_ datetime,
To_Date_ datetime,Item_Id_ int,Production_No_ int)
BEGIN
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and shift_start_master.Date >= '", From_Date_ ,"' and  shift_start_master.Date <= '", To_Date_,"'");
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_start_details_rawmaterial.Item_Stock_Id =",Item_Id_);
end if;
if Production_No_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and shift_start_master.Prodction_No =",Production_No_);
end if;
SET @query = Concat("select shift_start_details_rawmaterial.Item_Name,No_Quantity,
Count(Shift_Start_Details_RawMaterial_Id) Shift_Start_Details_RawMaterial_Id
FROM shift_start_details_rawmaterial
inner join shift_start_master on shift_start_master.Shift_Start_Master_Id=shift_start_details_rawmaterial.Shift_Start_Master_Id
	WHERE shift_start_master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value , " 
     group by  shift_start_details_rawmaterial.Item_Name,No_Quantity");

   PREPARE QUERY FROM @query;EXECUTE QUERY;
#select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_User_Details`( In User_Details_Name_ varchar(100))
Begin 
 set User_Details_Name_ = Concat( '%',User_Details_Name_ ,'%');
 SELECT User_Details_Id,User_Details_Name,Password,Working_Status,User_Type,Role_Id,User_Details.Address1,
 User_Details.Address2,
User_Details.Address3,User_Details.Address4,User_Details.Pincode,User_Details.Mobile,User_Details.Email,
User_Details.Employee_Id
From User_Details 
where User_Details_Name like User_Details_Name_ and User_Details.DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_User_Menu_Selection`( )
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
	where  DeleteStatus=false and Menu_Status=true
order by Menu.Menu_Id asc;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_User_Typeahead`(in User_Details_Name_ varchar(1000) )
Begin 
set User_Details_Name_ = Concat( '%',User_Details_Name_ ,'%');
	SELECT User_Details_Id,User_Details_Name  From User_Details 
    where User_Details_Name like  User_Details_Name_  and DeleteStatus=false 
    ORDER BY User_Details_Name Asc Limit 5 ;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Warehouse`( In WareHouse_Name_ varchar(100))
Begin 
 set WareHouse_Name_ = Concat( '%',WareHouse_Name_ ,'%');
 SELECT WareHouse_Id,WareHouse_Name,Status
 From warehouse where WareHouse_Name like WareHouse_Name_ and DeleteStatus=false ;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Warehouse_Typeahead`(WareHouse_Name_ varchar(1000) )
Begin 
	set WareHouse_Name_ = Concat( "'%",WareHouse_Name_ ,"%'");
	Set @query=CONCAT("	SELECT WareHouse_Id,WareHouse_Name, Status From warehouse 
    where WareHouse_Name like ",  WareHouse_Name_,"  and DeleteStatus=false 
    ORDER BY WareHouse_Name Asc Limit 5 ");
    PREPARE QUERY FROM @query;EXECUTE QUERY;
	#select @query;    
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Waste_In_Master`( In Is_Date_Check_ tinyint,From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Waste_In_Master.Date >= '", From_Date_ ,"' and  Waste_In_Master.Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Waste_In_Master.Client_Accounts_Id =",Client_Accounts_Id_);
end if;

SET @query = Concat("SELECT Waste_In_Master_Id,(Date_Format(Waste_In_Master.Date,'%d-%m-%Y')) As Search_Date,
		(Date_Format(Waste_In_Master.Date,'%Y-%m-%d')) As Date,Waste_In_Master.Client_Accounts_Id,Company_Id,User_Id,Waste_In_No,Description,
		Client_Accounts.Client_Accounts_Name as Customer,Client_Accounts.Address1,
		Client_Accounts.Address2,Client_Accounts.Address3,Client_Accounts.Address4,Client_Accounts.Mobile,GSTNo,PinCode
		FROM Waste_In_Master
		INNER JOIN Client_Accounts ON Waste_In_Master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id  
		WHERE Waste_In_Master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"");

  PREPARE QUERY FROM @query;EXECUTE QUERY;
  #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Waste_In_Master_Report`( In Is_Date_Check_ tinyint,
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int,Company_Id_ int, Warehouse_Id_ int,Item_Id_ int)
Begin 
 declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
	set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and Waste_In_Master.Date >= '", From_Date_ ,"' and  Waste_In_Master.Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Waste_In_Master.Client_Accounts_Id =",Client_Accounts_Id_);
end if;
if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and Waste_In_Master.Company_Id =",Company_Id_);
end if;
if Warehouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and waste_in_details.WareHouse_Id =",Warehouse_Id_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and waste_in_details.Item_Id =",Item_Id_);
end if;

SET @query = Concat("SELECT Client_Accounts.Client_Accounts_Name as Customer,Item_Name,sum(Quantity) Quantity,
		Company_Name,WareHouse_Name
		FROM Waste_In_Master
		INNER JOIN waste_in_details ON Waste_In_Master.Waste_In_Master_Id=waste_in_details.Waste_In_Master_Id  
		INNER JOIN Client_Accounts ON Waste_In_Master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id  
		INNER JOIN Company ON Waste_In_Master.Company_Id=Company.Company_Id
		WHERE Waste_In_Master.DeleteStatus =false", Search_Date_ ,SearchbyName_Value,"
        group by  Waste_In_Master.Client_Accounts_Id,Item_Id,Item_Name ");

  PREPARE QUERY FROM @query;EXECUTE QUERY;
 # select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Waste_Out_Master`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and waste_out_master.Date >= '", From_Date_ ,"' and  waste_out_master.Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and waste_out_master.Client_Accounts_Id =",Client_Accounts_Id_);
end if;
SET @query = Concat(" SELECT (Date_Format(waste_out_master.Date,'%Y-%m-%d')) As Date ,
 (Date_Format(Date,'%d-%m-%Y')) As Search_Date,Waste_Out_Master_Id,waste_out_master.Client_Accounts_Id,User_Id,
 Company_Id,Waste_Out_No,Weigh_Bridge_No,Description,TotalAmount,Client_Accounts_Name
From waste_out_master 
 INNER JOIN Client_Accounts ON waste_out_master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id
where waste_out_master.DeleteStatus=false ",
 Search_Date_ ,SearchbyName_Value,"");
   PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Search_Waste_Out_Master_Report`(In Is_Date_Check_ varchar(50),
From_Date_ datetime,To_Date_ datetime,Client_Accounts_Id_ int,Company_Id_ int, Warehouse_Id_ int,Item_Id_ int)
BEGIN
declare Search_Date_ varchar(500);declare SearchbyName_Value varchar(2000);
set Search_Date_="";set SearchbyName_Value="";
if Is_Date_Check_=true then
	set Search_Date_=concat( " and waste_out_master.Date >= '", From_Date_ ,"' and  waste_out_master.Date <= '", To_Date_,"'");
end if;
if Client_Accounts_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and waste_out_master.Client_Accounts_Id =",Client_Accounts_Id_);
end if;
if Company_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and waste_out_master.Company_Id =",Company_Id_);
end if;
if Warehouse_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and waste_out_details.Warehouse_Id =",Warehouse_Id_);
end if;
if Item_Id_>0 then
	SET SearchbyName_Value =concat(SearchbyName_Value," and waste_out_details.Item_Id =",Item_Id_);
end if;
SET @query = Concat(" SELECT Client_Accounts_Name,Item_Name,sum(Quantity) Quantity,
Company_Name,Warehouse_Name
From waste_out_master 
 INNER JOIN waste_out_details ON waste_out_master.Waste_Out_Master_Id=waste_out_details.Waste_Out_Master_Id
 INNER JOIN Client_Accounts ON waste_out_master.Client_Accounts_Id=Client_Accounts.Client_Accounts_Id
 INNER JOIN Company ON waste_out_master.Company_Id=Company.Company_Id
where waste_out_master.DeleteStatus=false ",
 Search_Date_ ,SearchbyName_Value, " group by waste_out_master.Client_Accounts_Id,Item_Id,Item_Name ");
 PREPARE QUERY FROM @query; EXECUTE QUERY; 
 #select @query;
 End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Truncate_table`( )
Begin 
 truncate proforma_invoice_master;truncate production_details_process;truncate production_details_rawmaterial;
 truncate production_details_wastage;truncate production_master;truncate proforma_invoice_details;truncate purchase_order_details; 
 truncate purchase_order_master;truncate shift_end_master;truncate shift_end_details_wastage;truncate shift_start_details;truncate shift_start_details_process;
 truncate shift_start_details_wastage;truncate shift_start_master;truncate shipment_details;truncate shipment_master;truncate shift_start_details_rawmaterial;
 end$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock`(In Stock_Add_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);
declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select  Stock_Add_Details.StockId,WareHouse_Id,Quantity from Stock_Add_Details
where Stock_Add_Master_Id=Stock_Add_Master_Id_;
set fetch_status=(select Count(Stock_Add_Details_Id) from Stock_Add_Details where
Stock_Add_Master_Id=Stock_Add_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity-Quantity_
where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
set fetch_status=fetch_status-1;
     if(fetch_status != 0)
then
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_From_Purchase_Return`(In Purchase_Return_Master_Id_ int,Company_Id_ int)
BEGIN
declare Stock_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);  declare fetch_status decimal(18,0);
declare WareHouse_Id_ int; 
Declare Cur Cursor for select  Stock_Id,WareHouse_Id,Quantity from Purchase_Return_Details 
where Purchase_Return_Master_Id=Purchase_Return_Master_Id_;
set fetch_status=(select Count(Purcahse_Return_Details_Id) from Purchase_Return_Details where 
Purchase_Return_Master_Id=Purchase_Return_Master_Id_);
Open Cur;
FETCH Cur INTO Stock_Id_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity+Quantity_ 
	where Stock_Id=Stock_Id_ and WareHouse_Id=WareHouse_Id_ and Company_Id=Company_Id_;        
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO Stock_Id_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_From_Stock_Transfer`(In Stock_transfer_Master_Id_ decimal(18,0),From_Company_Id_ int,To_Company_Id_ int)
BEGIN
declare Stock_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);  declare fetch_status decimal(18,0);
declare From_Stock_Id_ int; declare To_Stock_Id_ int;
Declare Cur Cursor for select  Stock_Id,From_Stock_Id,To_Stock_Id,Quantity from Stock_Transfer_Details 
where Stock_transfer_Master_Id=Stock_transfer_Master_Id_;
set fetch_status=(select Count(Stock_transfer_Details_Id) from Stock_Transfer_Details where 
Stock_transfer_Master_Id=Stock_transfer_Master_Id_);
Open Cur;
FETCH Cur INTO Stock_Id_,From_Stock_Id_,To_Stock_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity+Quantity_ 
	where Stock_Id=Stock_Id_ and WareHouse_Id=From_Stock_Id_ and Company_Id=From_Company_Id_;    
    update Stock_Details set Quantity=Quantity-Quantity_ 
	where Stock_Id=Stock_Id_ and WareHouse_Id=To_Stock_Id_ and Company_Id=To_Company_Id_;    
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO Stock_Id_,From_Stock_Id_,To_Stock_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_FromProduction_Rawmaterial`(In Production_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,3);declare fetch_status decimal(18,0);
Declare Cur Cursor for select production_details_rawmaterial.Stock_Id,production_master.Warehouse_Id,
round(production_details_rawmaterial.No_Quantity*production_master.Quantity,3) as Qty
from production_details_rawmaterial inner join production_master
on production_details_rawmaterial.Production_Master_Id=production_master.Production_Master_Id 
where production_details_rawmaterial.Production_Master_Id=Production_Master_Id_;

set fetch_status=(select Count(Production_Details_RawMaterial_Id) from production_details_rawmaterial 
where Production_Master_Id=Production_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity+Quantity_ where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id=Company_Id_;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_FromSales`(In Sales_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);
declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select Stock_Id,WareHouse_Id,Quantity from Sales_Details INNER JOIN Sales_Master
ON Sales_Details.Sales_Master_Id=Sales_Master.Sales_Master_Id
where Sales_Details.Sales_Master_Id=Sales_Master_Id_;
set fetch_status=(select Count(Sales_Details_Id) from Sales_Details where Sales_Master_Id=Sales_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity+Quantity_ where Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id=Company_Id_;
set fetch_status=fetch_status-1;
END WHILE;
Close Cur;
DELETE FROM Sales_Details WHERE Sales_Master_Id = Sales_Master_Id_;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_Fromshift_start_details_Raw`(In Shift_Start_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,3);declare fetch_status decimal(18,0);
Declare Cur Cursor for select shift_start_details_rawmaterial.Stock_Id,shift_start_master.WareHouse_Id,
round(shift_start_details_rawmaterial.No_Quantity,3) as Qty
from shift_start_details_rawmaterial inner join shift_start_master
on shift_start_details_rawmaterial.Shift_Start_Master_Id=shift_start_master.Shift_Start_Master_Id 
where shift_start_details_rawmaterial.Shift_Start_Master_Id=Shift_Start_Master_Id_;

set fetch_status=(select Count(Shift_Start_Details_RawMaterial_Id) from shift_start_details_rawmaterial 
where Shift_Start_Master_Id=Shift_Start_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity+Quantity_ where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id=Company_Id_;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_Fromshift_start_details_wastage`(In Shift_Start_Master_Id_ decimal(18,0))
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,3);declare fetch_status decimal(18,0);
Declare Cur Cursor for select shift_start_details_rawmaterial.Stock_Id,shift_start_master.WareHouse_Id,
round(shift_start_details_rawmaterial.No_Quantity,3) as Qty
from shift_start_details_rawmaterial inner join shift_start_master
on shift_start_details_rawmaterial.Shift_Start_Master_Id=shift_start_master.Shift_Start_Master_Id 
where shift_start_details_rawmaterial.Shift_Start_Master_Id=Shift_Start_Master_Id_;

set fetch_status=(select Count(Shift_Start_Details_RawMaterial_Id) from shift_start_details_rawmaterial 
where Shift_Start_Master_Id=Shift_Start_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity+Quantity_ where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_Purchase`(In Purchase_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);
declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select  Purchase_Details.StockId,WareHouse_Id,Quantity from Purchase_Details
where Purchase_Master_Id=Purchase_Master_Id_;
set fetch_status=(select Count(Purchase_Details_Id) from Purchase_Details where
Purchase_Master_Id=Purchase_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity-Quantity_
where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
set fetch_status=fetch_status-1;
     if(fetch_status != 0)
then
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Stock_Purchase_Order`(In Purchase_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);
declare WareHouse_Id_ decimal(18,0);
declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select  purchase_master_order_details.StockId,WareHouse_Id,Quantity from purchase_master_order_details
where Purchase_Master_Id=Purchase_Master_Id_;
set fetch_status=(select Count(Purchase_Details_Id) from purchase_master_order_details where
Purchase_Master_Id=Purchase_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
update Stock_Details set Quantity=Quantity-Quantity_
where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
set fetch_status=fetch_status-1;
     if(fetch_status != 0)
then
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_StockFrom_Packing`(In Packing_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);declare Quantity_ decimal(18,2);declare fetch_status decimal(18,0);
Declare Cur Cursor for select  packing_details_wastage.Stock_Id,packing_master.WareHouse_Id,
packing_details_wastage.Quantitypers 
from packing_details_wastage 
inner join packing_master on packing_master.Packing_Master_Id=packing_details_wastage.Packing_Master_Id
where packing_details_wastage.Packing_Master_Id=Packing_Master_Id_;
set fetch_status=(select Count(Packing_Details_Wastage_Id)
 from Packing_details_wastage 
 where Packing_Master_Id=Packing_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity-Quantity_ 
	where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_StockFrom_PackingPlan`(In Packing_Plan_Master_Id_ int,Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);declare Quantity_ decimal(18,2);
declare fetch_status decimal(18,0);
Declare Cur Cursor for select packing_plan_details.Stock_Id,packing_plan_details.Warehouse_Id,
packing_plan_details.Quantity 
from packing_plan_details
where packing_plan_details.Packing_Plan_Master_Id =Packing_Plan_Master_Id_;
set fetch_status=(select Count(Packing_Plan_Master_Id)
 from packing_plan_details 
 where Packing_Plan_Master_Id=Packing_Plan_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity+Quantity_ 
	where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id =Company_Id_;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_StockFrom_Shiftend`(In Shift_End_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);declare Quantity_ decimal(18,2);declare fetch_status decimal(18,0);
Declare Cur Cursor for select shift_end_details_wastage.Stock_Id,shift_end_master.Warehouse_Id,shift_end_details_wastage.Quantitypers 
from shift_end_details_wastage inner join shift_end_master
on shift_end_details_wastage.Shift_End_Master_Id=shift_end_master.Shift_End_Master_Id
where shift_end_details_wastage.Shift_End_Master_Id =Shift_End_Master_Id_;
set fetch_status=(select Count(Shift_End_Details_Wastage_Id)
 from shift_end_details_wastage 
 where Shift_End_Master_Id=Shift_End_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity-Quantity_ 
	where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_StockFrom_Wastein`(In Waste_In_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);declare Quantity_ decimal(18,2);declare fetch_status decimal(18,0);
Declare Cur Cursor for select Waste_In_Details.Stock_Id,Waste_In_Details.Warehouse_Id,Waste_In_Details.Quantity 
from Waste_In_Details 
where Waste_In_Details.Waste_In_Master_Id =Waste_In_Master_Id_ and DeleteStatus=0;
set fetch_status=(select Count(Waste_In_Details_Id)
 from Waste_In_Details 
 where Waste_In_Master_Id=Waste_In_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity-Quantity_ 
	where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_ ;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_StockFrom_Wasteout`(In Waste_Out_Master_Id_ decimal(18,0),Company_Id_ int)
BEGIN
declare StockId_ decimal(18,0);declare WareHouse_Id_ decimal(18,0);declare Quantity_ decimal(18,2);declare fetch_status decimal(18,0);
Declare Cur Cursor for select Waste_Out_Details.Stock_Id,Waste_Out_Details.Warehouse_Id,Waste_Out_Details.Quantity 
from Waste_Out_Details 
where Waste_Out_Details.Waste_Out_Master_Id =Waste_Out_Master_Id_ and DeleteStatus=0;
set fetch_status=(select Count(Waste_Out_Details_Id)
 from Waste_Out_Details 
 where Waste_Out_Master_Id=Waste_Out_Master_Id_);
Open Cur;
FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
While(fetch_status != 0)do
	update Stock_Details set Quantity=Quantity+Quantity_ 
	where Stock_Details.Stock_Id=StockId_ and WareHouse_Id=WareHouse_Id_ and Company_Id = Company_Id_;
	set fetch_status=fetch_status-1;
     if(fetch_status != 0)
			then
				FETCH Cur INTO StockId_,WareHouse_Id_,Quantity_;  
			end if;
END WHILE;
Close Cur;
End$$
DELIMITER ;
