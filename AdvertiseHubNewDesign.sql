/* TABLE STRUCTURE */

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AccountAdvertise]') AND type in (N'U'))
DROP TABLE [dbo].[AccountAdvertise]
GO

CREATE TABLE [dbo].[AccountAdvertise](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[AdvertiseID] [int] NOT NULL,
	[OnlineAdvertiseID] [varchar](500) NOT NULL,
	[OnlineAdvertiseDate] [datetime] NULL,
	[Ref] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_AccountAdvertise] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO








--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OnlineAdvertise]') AND type in (N'U'))
--DROP TABLE [dbo].[OnlineAdvertise]
--GO

--CREATE TABLE [dbo].[OnlineAdvertise](
--	[ID] [int] IDENTITY(1,1) NOT NULL,
--	[AccountAdvertiseID] [int] NOT NULL,
--	[OnlineAdvertiseID] [varchar](500) NOT NULL,
--	[OnlineAdvertiseDate] [datetime] NOT NULL,
--	[Ref] [nvarchar](max) NULL,
-- CONSTRAINT [PK_OnlineAdvertise] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
--GO



ALTER TABLE [dbo].[AccountAdvertise]  WITH CHECK ADD  CONSTRAINT [FK_AccountAdvertise_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AccountAdvertise] CHECK CONSTRAINT [FK_AccountAdvertise_Account]
GO

ALTER TABLE [dbo].[AccountAdvertise]  WITH CHECK ADD  CONSTRAINT [FK_AccountAdvertise_Advertise] FOREIGN KEY([AdvertiseID])
REFERENCES [dbo].[AutoPostAdPostData] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AccountAdvertise] CHECK CONSTRAINT [FK_AccountAdvertise_Advertise]
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AdvertiseChannel]') AND type in (N'U'))
DROP TABLE [dbo].[AdvertiseChannel]
GO

CREATE TABLE [dbo].[AdvertiseChannel](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](2000) NOT NULL,
 CONSTRAINT [PK_AdvertiseChannel] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

insert into AdvertiseChannel values ('Gumtree','Gumtree');
Go

insert into AdvertiseChannel values ('Yeeyi','Yeeyi');
Go

IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='Account' AND C.Name='ChannelID')
	ALTER TABLE dbo.Account ADD
		ChannelID int not NULL CONSTRAINT DF_Account_ChannelID DEFAULT 1
GO


ALTER TABLE [dbo].[Account]  WITH NOCHECK ADD  CONSTRAINT [FK_Account_AdvertiseChannel] FOREIGN KEY([ChannelID])
REFERENCES [dbo].[AdvertiseChannel] ([ID])

ALTER TABLE [dbo].[Account] 
    CHECK CONSTRAINT [FK_Account_AdvertiseChannel]
GO




IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='Account' AND C.Name='RefBinary')
	ALTER TABLE dbo.Account ADD
		RefBinary varbinary(max) not NULL CONSTRAINT DF_Account_RefBinary DEFAULT CAST('' as varbinary(max))
GO





--ALTER TABLE [dbo].[OnlineAdvertise]  WITH CHECK ADD  CONSTRAINT [FK_OnlineAdvertise_AccountAdvertise] FOREIGN KEY([AccountAdvertiseID])
--REFERENCES [dbo].[AccountAdvertise] ([ID])
--ON UPDATE CASCADE
--ON DELETE CASCADE
--GO
--ALTER TABLE [dbo].[OnlineAdvertise] CHECK CONSTRAINT [FK_OnlineAdvertise_AccountAdvertise]
--GO











/* DATA */

insert into AdvertiseChannel values ('Gumtree','Gumtree');
insert into AdvertiseChannel values ('Yeeyi','Yeeyi');

update Account
set
ChannelID=1
where ID<>45















/* TEMP SQL */


select * from AutoPostAdPostData
where SKU='Item_Jim_TestChinese' or SKU like '%yeeyi%'

select * from AccountAdvertise

select * from Account

update AutoPostAdPostData
set
AccountID=45,
Status='A'
where SKU='Item_Jim_TestChinese'

insert into AccountAdvertise
select 
45 as accountid,
25606 as advertiseid,
'3844856' as OnlineAdvertiseID,
GETDATE() as OnlineAdvertiseDate,
'{ForumID:89}'

--INSERT INTO Account VALUES(N'jim0519',N'Shishiliu-0310',N'FLam',N'',N'__auc=88e9e0d51613fc48da33a0bda11; _ga=GA1.2.1654584168.1517193302; __cfduid=d59910b6c5ff1475151da947079fcd4ef1536324042; __utma=243803021.1654584168.1517193302.1536794082.1536794082.1; __utmz=243803021.1536794082.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __zlcmid=pGhm7rHvyHCfZ0; _gid=GA1.2.946434977.1541905101; zQwY_3815_saltkey=bEBEq46m; zQwY_3815_lastvisit=1541974708; zQwY_3815_visitedfid=142; zQwY_3815_auth=c20bqmjtK%2FfPQUczw6xSBGGsLlDMgGBjxp5mwPh%2FIokm2a9JNZy6th8rFr2o2cQA3l2knB5OuNDUZ8pNKkHiVg2dHc6x; zQwY_3815_testkey=testvalue; zQwY_3815_cookie_uid=3390233; zQwY_3815_cookie_username=jim0519; zQwY_3815_cookie_email=gdutjim%40gmail.com; zQwY_3815_home_readfeed=1541982238; zQwY_3815_home_diymode=1; zQwY_3815_viewid=tid_4286844; PHPSESSID=ul6r3j9n8r14avd3a2c3jcj1o4; zQwY_3815_sid=A38bgG; zQwY_3815_lip=121.211.67.28%2C1542080742; zQwY_3815_st_p=3390233%7C1542087863%7C9e858bb8bf4c6e9b5e9584fbdb7152aa; zQwY_3815_ulastactivity=d51fzwGsrpW5%2BD81zhpPqVFXCKt%2BEXnDPWONkfnveVqvJvLIae4O; zQwY_3815_lastact=1542087863%09home.php%09spacecp',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36');--First Name: Hey, Last Name: Zo, Gender: Male, DOB 1988-05-11, Question: what city were you born in? Answer: Mel

update AccountAdvertise
set Ref='{ForumID:142,BumpUpTimesLeft:23,ReturnMessage:"Done, only 23 left."}'
where ID=1


insert into AutoPostAdPostData
select 
'Item_Jim_TestChinese' as SKU,
100 as Price,
'亿忆网标题测试' Title,
16 CategoryID,
-1 InventoryQty,
3 AddressID,
1 AccountID,
1 CustomFieldGroupID,
'' BusinessLogoPath,
'Bulleen Thompsons Rd明亮宽敞单间出租，房间四四方方很正形，12平方大房，配有queen大床和床垫，入墙衣柜，崭新三菱空调，崭新地毯，干净整洁，窗外风景舒适怡人，花园环境优雅整齐，unit小区安静安全，房东友善好相处。房子有冰箱洗衣机微波炉，Telstra cable网络，一应俱全，拎包入住。
交通方面，步行三分钟到达公交站，属zone1和zone2交界，15分钟左右到city qv，去Westfield box hill都非常方便。开车出门拐个弯就到city方向和boxhill方向高速口，5分钟到Woolworths和coles，10分钟到boxhill或者Westfield，房子后面走3分钟到公园。
租赁对象要求单人入住，不接受couple，不能养宠物，干净整洁，无恶习，严禁抽烟，讲道理性格正常就好，男女不限。
$160/week,水电煤网share bill。房子condition请看配图，看房请短信0422325094，谢谢。' Description,
'' ImagesPath,
'' CustomID,
'D' Status,
0 Postage,
'' Notes,
1 AdTypeID,
1 ScheduleRuleID








insert into AutoPostAdPostData
select 
'Item_Jim_Yeeyi_Lego71016' as SKU,
320 as Price,
'The Kwik E Mart LEGO 71016全新未拆封 320刀' Title,
16 CategoryID,
-1 InventoryQty,
3 AddressID,
45 AccountID,
1 CustomFieldGroupID,
'' BusinessLogoPath,
'The Kwik E Mart LEGO 71016全新未拆封，box完好无损， 320刀出，现金交易，有意者请联系0422325094 Jim' Description,
'' ImagesPath,
'' CustomID,
'A' Status,
0 Postage,
'' Notes,
1 AdTypeID,
1 ScheduleRuleID












--calculate divider and interval
declare @maxBumpupTime int=32


select A.TotalMin,B.IntervalMin,floor(A.TotalMin/B.IntervalMin) Divider
from
(
select DATEDIFF(MINUTE,TimeRangeFrom,TimeRangeTo) TotalMin
from scheduleruleline
where ScheduleRuleID=3
) A
cross join
(
select 
ceiling(convert(decimal(18,2),DATEDIFF(MINUTE,TimeRangeFrom,TimeRangeTo))/(@maxBumpupTime/C.AdNum)) IntervalMin
from scheduleruleline
cross join 
	(
		select count(1) AdNum
		from AutoPostAdPostData
		where ScheduleRuleID=3
	) C
where ScheduleRuleID=3
) B








--calculate actual bumpup times for existing ads in one account
declare @accountID int=45


select SUM(AdNum*IntervalDay) ActualTotalBumpupTimes
from
(
	select COUNT(1) as AdNum,ScheduleRuleID
	from AutoPostAdPostData AD
	where Status='A'
	and AccountID=@accountID
	group by ScheduleRuleID
) SA
inner join ScheduleRule SR on SA.ScheduleRuleID=SR.ID





--Get time parts
select B.*, A.LastSuccessTime from
(
select top 1 RL.TimeRangeFrom,RL.TimeRangeTo,R.IntervalDay,R.LastSuccessTime
from ScheduleRuleLine RL 
inner join ScheduleRule R on RL.ScheduleRuleID=R.ID
where ScheduleRuleID=7
) A
cross apply dbo.fn_SplitDayRangeEqualParts(A.TimeRangeFrom,A.TimeRangeTo,A.IntervalDay) B