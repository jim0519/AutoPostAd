insert into ProductCategory
select CategoryID,CategoryName,ParentCategoryID from AutoPostAd.dbo.ProductCategory


insert into ProductCategory
select * from ImportedCategory

insert into AutoPostAdPostData
select 
sku,
price,
left(product_name,65) as product_name,
left([description],4000) as [description],
isnull(ImagesPath,'') as ImagesPath,
productcategory.ID as categoryid,
-1 as InventoryQty,
1,
1,
1,
'' as BusinessLogoPath
from ImportedAdData
inner join productcategory on ImportedAdData.CategoryID=productcategory.CategoryID and CategoryTypeID=1

select * from productcategory where ID=136

update ImportedAdData set ImagesPath='' where ImagesPath is null

select 
convert(sku,)
 from ImportedAdData where len(product_name)>65
 
 
insert into AutoPostAdPostData
select * from ImportedAdData

select * from productcategory where categoryname like '%brakes%'

select * from productcategory where categoryid='18442'

select * from productcategory where ID=212

select * from productcategory where categoryID=parentCategoryID

select * from AutoPostAdPostData where sku='261212187563'

select * from ImportedAdData

select * from V_GumtreeAutoPostAdPostData where description like '%NOTE: We offer paypal payment to secure your purchase, please leave your email or contact me with my email%'

delete from ImportedAdData where sku is null

select ''''+sku+''',',price from AutoPostAdPostData order by sku

select sku,price,title from AutoPostAdPostData order by sku

select * from AutoPostAdPostData A inner join AutoPostAdResult B on A.SKU=B.SKU

select * from AutoPostAdPostDataBackup

select * into AutoPostAdPostDataBackup from AutoPostAdPostData

--insert into AutoPostAdPostData
--select 
--SKU,
--Price,
--Title,
--[Description],
--ImagesPath,
--CategoryID
--from AutoPostAdPostDataBackup A 

select * from AutoPostAdResult A
inner join AutoPostAdPostData B on A.AutoPostAdDataID=B.ID

select * from Template

select * from DataField

select * from TemplateField

select * from [V_ProductCategory] where RootCategoryID=13

select * from productcategory where parentcategoryid='18357'

select * from productcategory where categoryID='18442'

--update productcategory set productcategory.CategoryName=A.CategoryName,productcategory.ParentCategoryID=A.ParentCategoryID 
--from (select * from AutoPostAd.dbo.productcategory) A where productcategory.CategoryID=A.CategoryID

update ImportedAdData set description='IKEA beddinge sofa bed ONLY mattress with top. Due to substituting the sofa mattress with another, need to sell the original one. Best for temporary sleeping for your casual guest.

Pick up and cash only.'


EXEC
sp_configure 'show advanced options', 1
GO

-- To update the currently configured value for advanced options.
RECONFIGURE
GO
-- To enable the feature.
EXEC
sp_configure 'xp_cmdshell', 1
GO

-- To update the currently configured value for this feature.
RECONFIGURE

GO




exec xp_cmdshell 'bcp "select * from AutoPostAdDealSplash.dbo.ProductCategory as Record FOR XML AUTO,TYPE, ELEMENTS ,ROOT(''ProductCategories'')" queryout "C:\AutoPostAdDatas.XML" -c -T'


delete from AutoPostAdResult where ID in( 
select R.ID from AutoPostAdPostData D
inner join AutoPostAdResult R on D.ID=R.AutoPostAdDataID
--where SKU not like '%Sam_%'
)

select * from V_ProductCategory where categoryID='18403'

select * from WaitForInsertDropShipData where title like '%boat%'

select * from AutoPostAdPostData 
inner join AutoPostAdResult

update WaitForInsertDropShipData set AddedPrice=A.CorrectPrice
from (
select 
--(case when round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)<=100 then ceiling((round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)+5)*1.035)-0.05
--when round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)>100 and round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)<=200 then ceiling((round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)+10)*1.035)-0.05
--when round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)>200 and round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)<=300 then ceiling((round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)+20)*1.035)-0.05
--else ceiling((round(WaitForInsertDropShipData.Price,2)+round(WaitForInsertDropShipData.Delivery,2)+30)*1.035)-0.05 end) as AddedPrice,
(case when OrigPrice<=100 then ceiling((OrigPrice+5)*1.035)-0.05
when OrigPrice>100 and OrigPrice<=200 then ceiling((OrigPrice+10)*1.035)-0.05
when OrigPrice>200 and OrigPrice<=300 then ceiling((OrigPrice+20)*1.035)-0.05
else ceiling((OrigPrice+30)*1.035)-0.05 end) as CorrectPrice,
* from WaitForInsertDropShipData
) A where WaitForInsertDropShipData.SKU=A.SKU

update WaitForInsertDropShipData set AddedPrice=121.95 where SKU='BS-86202-GC'
update AutoPostAdPostData set Price=121.95 where SKU='BS-86202-GC'

select * from AutoPostAdPostData where description like '%We offer paypal payment to secure your purchase%'

update AutoPostAdPostData set Price=A.AddedPrice
from (select SKU collate Chinese_PRC_CI_AS as SKUChi,* from WaitForInsertDropShipData) A
where A.SKUChi=AutoPostAdPostData.SKU

select * from AutoPostAdPostData 
inner join (select SKU collate Chinese_PRC_CI_AS as SKUChi,* from WaitForInsertDropShipData) A on A.SKUChi=AutoPostAdPostData.SKU

select A.*,Cats.* from (
select D.* from AutoPostAdPostData D
inner join V_ProductCategory Cats on D.CategoryID=Cats.ID
where Cats.CategoryTypeID=2 or Cats.CategoryTypeID=3
) A
inner join V_ProductCategory Cats on A.CategoryID=Cats.ID
--inner join AutoPostAdResult R2 on A.ID=R2.AutoPostAdDataID
left join (
select D.* from AutoPostAdPostData D
inner join V_ProductCategory Cats on D.CategoryID=Cats.ID
inner join AutoPostAdResult R on D.ID=R.AutoPostAdDataID
where Cats.CategoryTypeID=2 or Cats.CategoryTypeID=3
) B on A.SKU=B.SKU

where B.SKU is null

select * from [10.1.9.24].WmsInterfacePlatform.dbo.Product


select count(*) from TestProductCategory

select *,1 as CategoryTypeID into TestProductCategory from ProductCategory

insert into TestProductCategory
select top 33 category_ID,category_name,category_parent_ID,1,2 from TesteBayCategory

select T.* from ProductCategory T
left join V_ProductCategory V on T.ID=V.ID
where V.ID is null

select * from V_ProductCategory where CategoryID='18444' and CategoryTypeID=3

select * from tempData
inner join V_ProductCategory VCat on VCat.CategoryID=tempData.ProductCategoryID and (case tempData.ProductCategoryType when 'eBayCategory' then 2 when 'QsCategory' then 3 end)=VCat.CategoryTypeID

select distinct LocalData.Price,RemoteData.Price,* from
(select SKU collate Latin1_General_CI_AS as SKULatin,* from AutoPostAdPostData ) LocalData
inner join [10.1.9.24].AutoPostAd.dbo.AutoPostAdPostData RemoteData on  LocalData.SKULatin=RemoteData.SKU

select * from [10.1.9.24].AutoPostAd.dbo.AutoPostAdPostData

select * from AutoPostAdPostData where title like '%2 x PU Leather Bar Stool - Black%'

select * from AutoPostAdPostData where SKU='SB-K2008-OB'

select * from WaitForInsertDropShipData where SKU='BA-TW-T710N-BLACK-X2'

select * from DropshipInventory

select * from DropShipImportedData

select * from (
select D.* from AutoPostAdPostData D
inner join V_ProductCategory Cats on D.CategoryID=Cats.ID
where Cats.CategoryTypeID in (2,3)
) A
left join (
select distinct D.* from AutoPostAdPostData D
inner join V_ProductCategory Cats on D.CategoryID=Cats.ID
inner join DropshipInventory I on D.SKU=I.SKU 
where Cats.CategoryTypeID in (2,3) and I.SKU is null
) B on A.SKU=B.SKU
where B.SKU is null

select  D.SKU,count(D.SKU) Num from AutoPostAdPostData D
inner join V_ProductCategory Cats on D.CategoryID=Cats.ID
inner join DropshipInventory I on D.SKU=I.SKU 
where Cats.CategoryTypeID in (2,3)
group by D.SKU
having count(D.SKU)>1


select DropShipImportedDataWithCatOrig.ProductCategoryID,Cats.ID,* from  V_DropShipImportedDataWithCatEnhanced DropShipImportedDataWithCatOrig
left join V_ProductCategory Cats on DropShipImportedDataWithCatOrig.ProductCategoryID=Cats.CategoryID 
and DropShipImportedDataWithCatOrig.CategoryTypeID=Cats.CategoryTypeID
where Cats.ID is null

insert into AutoPostAdPostData
select InsertData.* from
(
select 
QSData.SKU,
QSData.Price,
QSData.Title,
RemoteData.Description,
QSData.ImagesPath,
RemoteData.CategoryID,
-1 as InventoryQty,
1 as AddressID,
1 as AccountID,
1 as CustomFieldGroupID
from V_QSAutoPostAdPostData QSData
inner join (select SKU collate Chinese_PRC_CI_AS as SKUChi,* from [10.1.9.24].AutoPostAd.dbo.AutoPostAdPostData) RemoteData on QSData.SKU=RemoteData.SKUChi
) InsertData
left join
V_GumtreeAutoPostAdPostData GumtreeAdData on InsertData.SKU=GumtreeAdData.SKU
where GumtreeAdData.SKU is null

--delete from DropshipInventory

--insert into ProductCategory
--select * from TesteBayCategory

--insert into ProductCategory
--select * from TestQSCategory



--Select no post result Ad Data
select * from (
	select D.* from V_QSAutoPostAdPostData D
	left join AutoPostAdResult R on D.ID=R.AutoPostAdDataID
	where R.ID is null
) A
left join 
V_ProductCategory Cats on A.CategoryID=Cats.ID

--Fix QS Category and add Category in SKU Category mapping table
declare @CategoryID varchar(100),
@OrigID int,
@DestID int
set @OrigID=18706
set @CategoryID='8398'
select @DestID=ID from V_ProductCategory where CategoryID=@CategoryID and CategoryTypeID=3

--select @DestID

select * from V_ProductCategory where CategoryID=@CategoryID and CategoryTypeID=3

insert into SKUCategory
select D.SKU,@DestID as Category from AutoPostAdPostData D
where D.CategoryID=@OrigID

update AutoPostAdPostData set CategoryID=@DestID
where AutoPostAdPostData.CategoryID=@OrigID


--Replace gumtree drop ship description

declare @oldAppendix varchar(4000),@newAppendix varchar(4000);
set @oldAppendix='NOTE: The Price is including postage.';
set @newAppendix='Order & Delivery
The postage flat rate is $9.95, we only delivery the items Australian wide with Australian post, tracking number can be provided upon request. The item will be shipped within 2 days after payment confirmed. NO PICK UP AVAILABLE, NO EXCEPTION.

You will need to leave your full name(first name and last name), full address(Suite No., Street, Suburb, Post Code, State) and your contact number by replying so that we can arrange shipment ASAP.

Warranty & Returns Policies
This item comes with a 1 year manufacturers warranty against defects or DOA(Dead on Arrival Products).

Payment Info
We accept payment via bank deposite or paypal. Payment information is as below:

Bank Deposite/Transfer
BSB:063 103
Account Number:1034 9412
Account Holder:JING XU

Paypal
gdutjim@gmail.com

ABN Info:
My ABN number is 44120517460'


--select * from 
--(
update AutoPostAdPostData set description=A.DescriptionAfterAddNewAppendix from(
select 
--*
ID,
charindex(@oldAppendix,description)-1 as ReplaceStringBeginIndex,
left(description,charindex(@oldAppendix,description)-1) as DescriptionAfterDeleteOldAppendix,
left(description,charindex(@oldAppendix,description)-1)+@newAppendix as DescriptionAfterAddNewAppendix,
description
--right()
from V_GumtreeAutoPostAdPostData where description like '%'+@oldAppendix+'%'
) A where A.ID=AutoPostAdPostData.ID
--) ReplacedInfo
--where len(DescriptionAfterAddNewAppendix)>4000


--Update the title or price different between gumtree and quick sale

update AutoPostAdPostData set Title=A.MTitle
from
(
select GumtreeData.Title as MTitle,QSData.* from V_GumtreeAutoPostAdPostData GumtreeData
inner join V_QSAutoPostAdPostData QSData on GumtreeData.SKU=QSData.SKU
where GumtreeData.title<>left(QSData.title,65)
) A
where AutoPostAdPostData.ID=A.ID


--Insert back to WaitForInsertDropShipData after manually input data to AutoPostAdPostData
Insert into WaitForInsertDropShipData
select 
GD.SKU,
GD.Title,
GD.Description,
ID.OrigTotalPrice as OrigPrice,
GD.Price as AddedPrice,
C.CategoryID as ProductCategoryID,
1 as CategoryTypeID,
C.ID as ProductCategoryIdentityID,
GD.ImagesPath

from V_GumtreeAutoPostAdPostData GD
inner join 
(select SKU collate Chinese_PRC_CI_AS as SKUChi,SKU, max(round(price,2)) as Price,max(round(delivery,2)) as Delivery,max(round(price,2))+max(round(delivery,2)) as OrigTotalPrice
from DropShipImportedData group by SKU) ID on GD.SKU=ID.SKUChi
inner join V_ProductCategory C on C.ID=GD.CategoryID
left join (select SKU collate Chinese_PRC_CI_AS as SKUChi,* from WaitForInsertDropShipData) WD on GD.SKU=WD.SKUChi
where WD.SKU is null and GD.ID>=1805
--Insert back to WaitForInsertDropShipData after manually input data to AutoPostAdPostData


--insert to gumtree data with category according to quick sale data

select * from V_GumtreeAutoPostAdPostData where Title like '%5 Star Chef %'

select * from V_ProductCategory where categoryID='10046'

select * from V_ProductCategory  where id=216

select * from V_ProductCategory where categoryname like '%Small Appliance%'

select * 
from V_QSAutoPostAdPostData QSData
left join V_GumtreeAutoPostAdPostData GumtreeData on GumtreeData.SKU=QSData.SKU
where GumtreeData.SKU is null

insert into AutoPostAdPostData
select 
QSData.SKU,
QSData.Price,
QSData.Title,
QSData.Description,
QSData.ImagesPath,
212,
QSData.InventoryQty,
1,
1
from V_QSAutoPostAdPostData QSData
left join V_GumtreeAutoPostAdPostData GumtreeData on GumtreeData.SKU=QSData.SKU
where QSData.ID in (862,928,1232,929)
and GumtreeData.SKU is null

--insert to gumtree data with category according to quick sale data








--insert drop ship item gumtree ad data
--insert into AutoPostAdPostData
select 
LocalData.ID,
LocalData.SKU,
LocalData.Price,
LEFT(LocalData.Title,65) as Title,
RemoteData.Description+ CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) +'NOTE: We offer paypal payment to secure your purchase, please leave your email or contact me with my email address QuickSaleJim@yahoo.com.au , I will guide you to my online store to see more details and purchase. I am sorry that we DO NOT Offer pick up option now, we will delivery the items Australian wide. Thank you.' as Description,
Replace(RemoteData.ImagesPath,'C:\gumtree\','F:\Jim\Own\LearningDoc\TempProject\AutoPostAd\QuickSale\AdImages\') as ImagesPath,
RemoteData.CategoryID
from 
(select SKU collate Latin1_General_CI_AS as SKULatin,* from AutoPostAdPostData ) LocalData
inner join [10.1.9.24].AutoPostAd.dbo.AutoPostAdPostData RemoteData on  LocalData.SKULatin=RemoteData.SKU
inner join V_ProductCategory Cats on LocalData.CategoryID=Cats.ID
where Cats.CategoryTypeID=2 or Cats.CategoryTypeID=3
and LocalData.SKU in ('BABY-PP-WHITE-8','BABY-PP-NT-8','GUNSAFE-3G-DX','TM-NRS-M-WH','AC-WM102-6-GD-SB','RS-OD-SP-4309B',
'CT-IN-213-1','CT-IN-739A','BW-PAB-67442','BW-RAB-67430-NE','BW-PAB-67450AU','MATTRESS-22-D','DESK-140M-BK-AB','PET-CAT-HSCT011-GR',
'AQUA-CUV-136','IG-XG-SF44','BABY-BSG-001','GUNSAFE-CKIT')


--Check if there is similar ads already listed(prevent from deleting by gumtree)
select * from V_GumtreeAutoPostAdPostData GumtreeData
left join AutoPostAdResult Result on GumtreeData.ID=Result.AutoPostAdDataID 
where title like '%Office Study Computer%'

--ImportXMLFile

DECLARE @XmlFile XML

SELECT @XmlFile = BulkColumn
FROM  OPENROWSET(BULK 'D:\eBayCategory2.xml', SINGLE_BLOB) x;


SELECT
    CategoryID = C.value('CategoryID[1]', 'varchar(50)'),
    CategoryName = C.value('CategoryName[1]', 'varchar(100)'),
    CategoryParentID =C.value('CategoryParentID[1]', 'varchar(50)'),
    CategoryLevel=C.value('CategoryLevel[1]', 'varchar(50)'),
    BestOfferEnabled=isnull(C.value('BestOfferEnabled[1]', 'varchar(50)'),'false'),
    AutoPayEnabled=isnull(C.value('AutoPayEnabled[1]', 'varchar(50)'),'false'),
    LeafCategory=isnull(C.value('LeafCategory[1]', 'varchar(50)'),'false')
Into eBayCategory
FROM
 @XmlFile.nodes('/ArrayOfCategoryType/CategoryType') AS XTbl(C)
 
 
DECLARE @QSCategoryXmlFile XML

SELECT @QSCategoryXmlFile = BulkColumn
FROM  OPENROWSET(BULK 'E:\QuickSaleCategory.xml', SINGLE_BLOB) x;

SELECT
    CategoryID = C.value('CategoryNum[1]', 'varchar(50)'),
    CategoryName = C.value('CategoryName[1]', 'varchar(100)'),
    CategoryParentID =case when C.value('CategoryParentNum[1]', 'varchar(50)')=0 then C.value('CategoryNum[1]', 'varchar(50)') else C.value('CategoryParentNum[1]', 'varchar(50)') end,
	CategoryLevel=C.value('CategoryLevel[1]', 'varchar(50)'),
	LeafCategory=C.value('LeafCategory[1]', 'varchar(50)'),
	IsClassifiedCat=C.value('IsClassifiedCat[1]', 'varchar(50)')
--Into QSCategory
FROM
 @QSCategoryXmlFile.nodes('/GetCategoryResponse/CategoryArray/Category') AS XTbl(C)
 --where C.value('CategoryParentNum[1]', 'varchar(50)')<>-1 and 
 --C.value('CategoryParentNum[1]', 'varchar(50)')=0
 


--delete 

--select Import drop ship data with category
DECLARE @ImagesPathXmlFile XML

SELECT @ImagesPathXmlFile = BulkColumn
FROM  OPENROWSET(BULK 'F:\Jim\Own\LearningDoc\TempProject\AutoPostAd\QuickSale\DownloadProductFromDropshipZone\ProductImagesPath.xml', SINGLE_BLOB) x;

--insert into WaitForInsertDropShipData
select distinct
DropShipImportedDataWithCatOrig.SKU,
DropShipImportedDataWithCatOrig.Title,
DropShipImportedDataWithCatOrig.Description,
round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2) as OrigPrice,
(case when round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)<=100 then ceiling((round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)+5)*1.035)-0.05
when round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)>100 and round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)<=200 then ceiling((round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)+10)*1.035)-0.05
when round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)>200 and round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)<=300 then ceiling((round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)+20)*1.035)-0.05
else ceiling((round(DropShipImportedDataWithCatOrig.Price,2)+round(DropShipImportedDataWithCatOrig.Delivery,2)+30)*1.035)-0.05 end) as AddedPrice,
--AvailableQty.QTY as AvailableQty,
DropShipImportedDataWithCatOrig.CategoryID as ProductCategoryID,
DropShipImportedDataWithCatOrig.CategoryTypeID,
Cats.ID as ProductCategoryIdentityID,
ProductImagesPath.ImagesPath
--into WaitForInsertDropShipData
from V_DropShipImportedDataWithCatEnhanced DropShipImportedDataWithCatOrig
inner join V_ProductCategory Cats on DropShipImportedDataWithCatOrig.CategoryIdentityID=Cats.ID 
--and DropShipImportedDataWithCatOrig.CategoryTypeID=Cats.CategoryTypeID

--inner join 
--(
--	select SKU collate Latin1_General_CI_AS as SKU,
--	QTY from [10.1.1.9].FLUX_CS.dbo.TMP_V_INV_QTY
--)AvailableQty on AvailableQty.SKU=DropShipImportedDataWithCatOrig.SKU

inner join (SELECT
    SKU = C.value('SKU[1]', 'varchar(100)'),
    ImagesPath = C.value('ImagesPath[1]', 'varchar(4000)')
--Into eBayCategory
FROM
 @ImagesPathXmlFile.nodes('/ArrayOfProductImage/ProductImage') AS XTbl(C)) ProductImagesPath on ProductImagesPath.SKU=DropShipImportedDataWithCatOrig.SKU

left join
(
select DropShipImportedDataWithCat.* from 
V_DropShipImportedDataWithCatEnhanced DropShipImportedDataWithCat
inner join V_ProductCategory VCat on VCat.ID=DropShipImportedDataWithCat.CategoryIdentityID
) DropShipImportedDataWithCatDesc on DropShipImportedDataWithCatOrig.SKU=DropShipImportedDataWithCatDesc.SKU
left join 
(
	select SKU collate Latin1_General_CI_AS as SKULatin
	from AutoPostAdPostData
) ExistSKU on ExistSKU.SKULatin=DropShipImportedDataWithCatOrig.SKU
where 
DropShipImportedDataWithCatDesc.SKU is not null and
ExistSKU.SKULatin is null and
AvailableQty.QTY>=10
 

--Insert Dropship Data to AutoPostAdPostData
insert into AutoPostAdPostData
select 
WaitForInsertDropShipData.SKU,
AddedPrice,
Title,
left([description],4000) as [description],
ImagesPath,
ProductCategoryIdentityID,
-1,
1,
1,
1
from WaitForInsertDropShipData
left join 
(select D.SKU collate Latin1_General_CI_AS as SKU from AutoPostAdPostData D
inner join V_ProductCategory Cats on D.CategoryID=Cats.ID
where Cats.CategoryTypeID in (2,3)
) ExistSKU on WaitForInsertDropShipData.SKU=ExistSKU.SKU
where ExistSKU.SKU is null





--Update SKU Inventory
update AutoPostAdPostData set InventoryQty=A.Qty from
(
select distinct D.SKU,D.CategoryID,I.Qty from AutoPostAdPostData D
inner join V_ProductCategory Cats on D.CategoryID=Cats.ID
inner join DropshipInventory I on D.SKU=I.SKU 
--where Cats.CategoryTypeID in (2,3)
) A where A.SKU=AutoPostAdPostData.SKU and A.CategoryID=AutoPostAdPostData.CategoryID



 
 --Available quantity
 --See TMP_V_INV_QTY in 10.1.1.9 Flux_CS
 
 select * from [10.1.1.9].FLUX_CS.dbo.TMP_V_INV_QTY where SKU='CIM-IM-50'
 
 
--home ip
update Account 
set Cookie=N'WTln=30818; imp=1; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b08000000000000003334303031363033323770303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d4a4d4bc2cd8acaf4f32383524a72f54a429dfd03dcf501cdfadee277000000; machId=TwwYgqiqeaRWNPhqrI02POwup11rtunJp7AJK3RIsJ_IjgyuI1T3McV_wAtz9qRBUHeSCqjh1BV45hMz4pmlQQjtURzq_q-6ietz; up=%7B%22ln%22%3A%22887770784%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D0%26k%3D1034395534%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22rva%22%3A%22%22%7D; __utma=160852194.483518509.1386999727.1387324026.1387329454.17; __utmz=160852194.1386999727.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.3.10.1387329454; svid=410802083194069979'
where id in (3,4,5)


--gumtree vpn
update Account 
set Cookie=N'machId=L8ECVQauJgPcOizvD-VfCywZ5A59iCNELvNt4u_VdfzFHLXh--ePlwevtEgaKbdIPkLQ3QkAxvG0BgMF3vXV--OEUPKpbEuCgy3zFw; up=%7B%22ln%22%3A%22113297733%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __utma=160852194.2052173047.1386985012.1386985012.1386992605.2; __utmz=160852194.1386985012.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); svid=410602076992995550; wl=%7B%22l%22%3A%22%22%7D; bs=%7B%22st%22%3A%7B%7D%7D; __utmb=160852194.7.10.1386992605; __utmc=160852194; sid2=1f8b08000000000000003334303031363033323770303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351db2c32a722d4b8c7342b3cb0dcc7d73020a2a2cd2730d0141c4314d77000000; WTln=303186; imp=1'
where id=3



--Update 2014 new price

select 
(case when A.RevisedTotalPrice<=100 then ceiling((A.RevisedTotalPrice+5)*1.035)-0.05
when A.RevisedTotalPrice>100 and A.RevisedTotalPrice<=200 then ceiling((A.RevisedTotalPrice+10)*1.035)-0.05
when A.RevisedTotalPrice>200 and A.RevisedTotalPrice<=300 then ceiling((A.RevisedTotalPrice+20)*1.035)-0.05
else ceiling((A.RevisedTotalPrice+30)*1.035)-0.05 end) as RevisedAddedPrice,
* from V_GumtreeAutoPostAdPostData GD
inner join 
(
select R.RevisedPrice+ID.Delivery as RevisedTotalPrice,D.* from (select SKU collate Chinese_PRC_CI_AS as SKUChi,* from WaitForInsertDropShipData) D
inner join RevisePriceSKU R on D.SKUChi=R.SKU
inner join (select distinct SKU,Title,Delivery, SKU collate Chinese_PRC_CI_AS as SKUChi from DropShipImportedData) ID on ID.SKUChi=R.SKU
where R.RevisedPrice+ID.Delivery>D.OrigPrice
) A on GD.SKU=A.SKUChi
inner join AutoPostAdResult R on GD.ID=R.AutoPostAdDataID



select 
L.SKU,
H.Stop,H.SOReference4,H.C_Address1,H.C_City,H.C_ZIP,H.ConsigneeName,H.C_Tel1,* from DOC_Order_Header H
inner join Doc_Order_Details L on H.OrderNo=L.OrderNo
--where SOReference3 like '%jayjaysauctions04@gmail.com%' or SOReference3 like '%jkpatel09@gmail.com%'
--where SOReference3 like '%gamegirl%'
where SOReference3 like '%gdutjim%'
--where ConsigneeName='Jignesh Patel'
--where ordertype like '%WIP%'
order by OrderTime Desc


--check the largest drop ship seller
select count(SOReference3) Num, SOReference3
from DOC_Order_Header
group by SOReference3
order by Num Desc

-- check the cheapest price in the channel
select 
max(cast(isnull(H.Stop,'0') as float)) MaxPrice,min(cast(isnull(H.Stop,'0') as float)) MinPrice,L.SKU from DOC_Order_Header H
inner join Doc_Order_Details L on H.OrderNo=L.OrderNo
where OrderType in ('DSOL','EOPL','MAGENTO','WIPQS')
and L.SKU='PET-CAT-HSCT018-BE'
group by L.SKU

select L.SKU,
H.Stop,H.SOReference4,H.C_Address1,H.C_City,H.C_ZIP,H.ConsigneeName,H.C_Tel1,*
from DOC_Order_Header H
inner join Doc_Order_Details L on H.OrderNo=L.OrderNo
where L.SKU='BS-86202-WB'
and cast(isnull(H.Stop,'0') as float)=104.08

--Update DOC_Order_Header Set ConsigneeName='Temo Zorella',ConsigneeName_E='Temo Zorella',C_Tel1='0425288030'
--where OrderNo='SO1401090387'





select * from 
(
	select GT.* from
	(
		select *
		from AutoPostAdPostData 
		where AdTypeID=4
	) DS
	inner join 
	(
		select * 
		from 
		AutoPostAdPostData 
		where AdTypeID=1
	) GT on DS.SKU=GT.SKU

) GTDropship 
--where Title like '%case%'
where GTDropship.CategoryID=0




insert into AutoPostAdPostData
select 
DS.SKU,
DS.Price,
DS.Title,
DS.CategoryID,
DS.InventoryQty,
DS.AddressID,
DS.AccountID,
DS.CustomFieldGroupID,
DS.BusinessLogoPath,
DS.Description,
DS.ImagesPath,
'' as CustomID,
'A' as Status,
DS.Postage,
DS.Notes,
3 as AdTypeID
from
(
select * 
from AutoPostAdPostData 
where AdTypeID=4 and Status=1
) DS
left join
(
select *
from AutoPostAdPostData
where AdTypeID=3
) QS on Ds.SKU=QS.SKU
where QS.ID is null