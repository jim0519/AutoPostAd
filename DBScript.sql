SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AutoPostAdHeader]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AutoPostAdHeader](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](100) NOT NULL,
	[PostDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AutoPostAdHeader] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AutoPostAdLine]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[AutoPostAdLine](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[HeaderID] [int] NOT NULL,
	[ExternalID] [varchar](50) NOT NULL,
	[Status] [varchar](10) NOT NULL,
	[PostDate] [datetime] NOT NULL,
 CONSTRAINT [PK_AutoPostAdLine] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdLine_AutoPostAdHeader]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdLine]'))
ALTER TABLE [dbo].[AutoPostAdLine]  WITH CHECK ADD  CONSTRAINT [FK_AutoPostAdLine_AutoPostAdHeader] FOREIGN KEY([HeaderID])
REFERENCES [dbo].[AutoPostAdHeader] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdLine_AutoPostAdHeader]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdLine]'))
ALTER TABLE [dbo].[AutoPostAdLine] CHECK CONSTRAINT [FK_AutoPostAdLine_AutoPostAdHeader]
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AutoPostAdPostData]') AND type in (N'U'))
DROP TABLE [dbo].[AutoPostAdPostData]
GO
CREATE TABLE [dbo].[AutoPostAdPostData](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SKU] [varchar](500) NOT NULL,
	[Price] [decimal](18, 2) NOT NULL,
	[Title] [varchar](500) NOT NULL,
	[Description] [varchar](4000) NOT NULL,
	[ImagesPath] [varchar](4000) NOT NULL,
	[CategoryID] INT NOT NULL,
 CONSTRAINT [PK_AutoPostAdPostData] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_AutoPostAdPostData_CategoryID] ON [AutoPostAdPostData] ([CategoryID] ASC)
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProductCategory]') AND type in (N'U'))
DROP TABLE [dbo].[ProductCategory]
GO
CREATE TABLE [dbo].[ProductCategory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [varchar](50) NOT NULL,
	[CategoryName] [varchar](100) NOT NULL,
	[ParentCategoryID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ProductCategory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IX_ProductCategory_CategoryID] ON [dbo].[ProductCategory] 
(
	[CategoryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdPostData_ProductCategory]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdPostData]'))
ALTER TABLE [dbo].[AutoPostAdPostData]  WITH CHECK ADD  CONSTRAINT [FK_AutoPostAdPostData_ProductCategory] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[ProductCategory] ([ID])
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AutoPostAdResult]') AND type in (N'U'))
DROP TABLE [dbo].[AutoPostAdResult]
GO
CREATE TABLE [dbo].[AutoPostAdResult](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AutoPostAdDataID] INT NOT NULL,
	[PostDate] [datetime] NOT NULL,
	[AdID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_AutoPostAdResult] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE NONCLUSTERED INDEX [IX_AutoPostAdResult_AutoPostAdDataID] ON [AutoPostAdResult] ([AutoPostAdDataID] ASC)
GO

--CREATE UNIQUE NONCLUSTERED INDEX [IX_AutoPostAdPostData_SKU] ON [dbo].[AutoPostAdPostData] 
--(
--	[SKU] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdResult_AutoPostAdPostData]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdResult]'))
ALTER TABLE [dbo].[AutoPostAdResult]  WITH CHECK ADD  CONSTRAINT [FK_AutoPostAdResult_AutoPostAdPostData] FOREIGN KEY([AutoPostAdDataID])
REFERENCES [dbo].[AutoPostAdPostData] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO


--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AutoPostAdLocation]') AND type in (N'U'))
--DROP TABLE [dbo].[AutoPostAdLocation]
--GO
--CREATE TABLE [dbo].[AutoPostAdLocation](
--	[ID] [int] IDENTITY(1,1) NOT NULL,
--	[SKU] [varchar](50) NOT NULL,
--	[PostDate] [datetime] NOT NULL,
--	[AdID] [varchar](50) NOT NULL,
-- CONSTRAINT [PK_AutoPostAdLocation] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Template]') AND type in (N'U'))
DROP TABLE [dbo].[Template]
GO
CREATE TABLE [dbo].[Template](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TemplateName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Template] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TemplateField]') AND type in (N'U'))
DROP TABLE [dbo].[TemplateField]
GO
CREATE TABLE [dbo].[TemplateField](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TemplateID] [INT] NOT NULL,
	[DataFieldID] [INT] NOT NULL,
	[Order] [INT] NOT NULL,
	[DefaultValue] [varchar](100) NOT NULL,
	[TemplateFieldName] [varchar](50) NOT NULL,
	[TemplateFieldType] [INT] NOT NULL,
	[IsRequireInput] [bit] NOT NULL,
 CONSTRAINT [PK_TemplateField] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DataField]') AND type in (N'U'))
DROP TABLE [dbo].[DataField]
GO
CREATE TABLE [dbo].[DataField](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DataFieldName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_DataField] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TemplateField_Template]') AND parent_object_id = OBJECT_ID(N'[dbo].[TemplateField]'))
ALTER TABLE [dbo].[TemplateField]  WITH CHECK ADD CONSTRAINT [FK_TemplateField_Template] FOREIGN KEY([TemplateID])
REFERENCES [dbo].[Template] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TemplateField_DataField]') AND parent_object_id = OBJECT_ID(N'[dbo].[TemplateField]'))
ALTER TABLE [dbo].[TemplateField]  WITH CHECK ADD CONSTRAINT [FK_TemplateField_DataField] FOREIGN KEY([DataFieldID])
REFERENCES [dbo].[DataField] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO


IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='ProductCategory' AND C.Name='TemplateID')
	ALTER TABLE dbo.ProductCategory ADD
		TemplateID INT NOT NULL CONSTRAINT DF_ProductCategory_TemplateID DEFAULT 1
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_ProductCategory_TemplateID')
	ALTER TABLE dbo.ProductCategory
		DROP CONSTRAINT DF_ProductCategory_TemplateID
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ProductCategory_Template]') AND parent_object_id = OBJECT_ID(N'[dbo].[ProductCategory]'))
ALTER TABLE [dbo].[ProductCategory]  WITH CHECK ADD CONSTRAINT [FK_ProductCategory_Template] FOREIGN KEY([TemplateID])
REFERENCES [dbo].[Template] ([ID])
GO



--Add category type
IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='ProductCategory' AND C.Name='CategoryTypeID')
	ALTER TABLE dbo.ProductCategory ADD
		CategoryTypeID INT NOT NULL CONSTRAINT DF_ProductCategory_CategoryTypeID DEFAULT 1
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_ProductCategory_CategoryTypeID')
	ALTER TABLE dbo.ProductCategory
		DROP CONSTRAINT DF_ProductCategory_CategoryTypeID
GO

--Add Inventory
IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='AutoPostAdPostData' AND C.Name='InventoryQty')
	ALTER TABLE dbo.AutoPostAdPostData ADD
		InventoryQty INT NOT NULL CONSTRAINT DF_AutoPostAdPostData_InventoryQty DEFAULT -1
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_AutoPostAdPostData_InventoryQty')
	ALTER TABLE dbo.AutoPostAdPostData
		DROP CONSTRAINT DF_AutoPostAdPostData_InventoryQty
GO


--Add Website Type if necessary
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WebsiteType]') AND type in (N'U'))
--DROP TABLE [dbo].[WebsiteType]
--GO
--CREATE TABLE [dbo].[WebsiteType](
--	[ID] [int] IDENTITY(1,1) NOT NULL,
--	[WebsiteName] [varchar](50) NOT NULL,
-- CONSTRAINT [PK_WebsiteType] PRIMARY KEY CLUSTERED 
--(
--	[ID] ASC
--)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
--) ON [PRIMARY]

--GO


--create address and account tables

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address]') AND type in (N'U'))
DROP TABLE [dbo].[Address]
GO
CREATE TABLE [dbo].[Address](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AddressName] [varchar](100) NOT NULL,
	[PostCode] [varchar](100) NOT NULL,
	[GeoLatitude] [varchar](100) NOT NULL,
	[GeoLongitude] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Account]') AND type in (N'U'))
DROP TABLE [dbo].[Account]
GO
CREATE TABLE [dbo].[Account](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[FirstName] [varchar](100) NOT NULL,
	[LastName] [varchar](100) NOT NULL,
	[Cookie] [varchar](4000) NOT NULL,
	[PhoneNumber] [varchar](100) NOT NULL,
	[Status][varchar](1) NOT NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--insert initial data in address and account tables

INSERT INTO [Address] VALUES(N'Bulleen VIC 3105',N'3105',N'-37.7660476',N'145.08793379999997');
INSERT INTO [Address] VALUES(N'Melbourne VIC',N'Melbourne',N'-37.814107',N'144.96327999999994');
INSERT INTO [Address] VALUES(N'Sydney NSW',N'Sydney',N'-33.8674869',N'151.20699020000006');
INSERT INTO [Address] VALUES(N'Brisbane QLD',N'Brisbane',N'-27.4710107',N'153.02344889999995');

INSERT INTO Account VALUES(N'DealSplash@yahoo.com.au',N'DropShipGumtree0310',N'Jim',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=2xSCR7QndutN2IeiwSDEjN0OYBgjJXvZVNmLtfPqNXMPdgIpvJU9kOykULEPyStP70Ik0uTsnBIoNVW1OugtudAa8vHOiZ9WVpZEOA; up=%7B%22ln%22%3A%22828635235%22%2C%22sps%22%3A%2225%22%2C%22ls%22%3A%22l%3D3008844%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lsh%22%3A%22l%3D3003435%26k%3D1033276080%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D3003435%26k%3D1033276080%26c%3D18442%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22rva%22%3A%221030197992%2C1011421636%2C1031563905%2C1012170503%2C1031806806%2C1032183621%2C1032476596%2C1032102054%22%2C%22lbh%22%3A%22l%3D3008844%26c%3D18442%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; WT_FPC=id=2e2a618a97e0106cb8d1385813970515:lv=1386101323426:ss=1386101039413; __utma=160852194.1144282824.1385850022.1386132373.1386137040.22; __utmz=160852194.1385964643.9.2.utmcsr=help.gumtree.com.au|utmccn=(referral)|utmcmd=referral|utmcct=/knowledgebase.php; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.5.10.1386137040; sid2=1f8b0800000000000000333430303132313631b274303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d82c2c3fc2b2d4dfdf3dddcc3cb92022bd2c3a3f283f4017819391677000000; WTln=937505',N'',N'A');
INSERT INTO Account VALUES(N'Sam20131128@yahoo.com.au',N'EndofLeaese20131128',N'Sam',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=po6Y0dQ5d4p3Ej7ODwIXMPGjqFy0CHnF7xMbiRFxHUDgveuGq8vevexxJzs7FzLxRx6EdROQWAJEEoQ9s2VpAko6-ogXCe1wDTLL-4Y; up=%7B%22ln%22%3A%22642081158%22%7D; __utma=160852194.1601188904.1385718542.1385718542.1385718542.1; __utmb=160852194.1.10.1385718542; __utmz=160852194.1385718542.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b08000000000000003334303031323031363775303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d02322cdc3d1c1d2b83f59c537daa4abdcdcb4b8dbdf401c86f449f77000000; WTln=419304',N'',N'A');



--add field addressID and accountID in AutoPostAdPostData

IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='AutoPostAdPostData' AND C.Name='AddressID')
	ALTER TABLE dbo.AutoPostAdPostData ADD
		AddressID INT NOT NULL CONSTRAINT DF_AutoPostAdPostData_AddressID DEFAULT 1
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_AutoPostAdPostData_AddressID')
	ALTER TABLE dbo.AutoPostAdPostData
		DROP CONSTRAINT DF_AutoPostAdPostData_AddressID
GO


IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='AutoPostAdPostData' AND C.Name='AccountID')
	ALTER TABLE dbo.AutoPostAdPostData ADD
		AccountID INT NOT NULL CONSTRAINT DF_AutoPostAdPostData_AccountID DEFAULT 1
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_AutoPostAdPostData_AccountID')
	ALTER TABLE dbo.AutoPostAdPostData
		DROP CONSTRAINT DF_AutoPostAdPostData_AccountID
GO

--establish foreign key relationship

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdPostData_Address]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdPostData]'))
ALTER TABLE [dbo].[AutoPostAdPostData]  WITH CHECK ADD  CONSTRAINT [FK_AutoPostAdPostData_Address] FOREIGN KEY([AddressID])
REFERENCES [dbo].[Address] ([ID])
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdPostData_Account]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdPostData]'))
ALTER TABLE [dbo].[AutoPostAdPostData]  WITH CHECK ADD  CONSTRAINT [FK_AutoPostAdPostData_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([ID])
GO

UPDATE DataField SET DataFieldName=N'AddressName' WHERE DataFieldName='Address';
UPDATE DataField SET DataFieldName=N'FirstName' WHERE DataFieldName='Name';
UPDATE TemplateField SET TemplateFieldType=0 WHERE DataFieldID BETWEEN 10 AND 15

UPDATE AutoPostAdPostData SET AccountID=2 WHERE SKU LIKE '%sam%'
UPDATE AutoPostAdPostData SET AddressID=2 WHERE SKU LIKE '%sam%' AND SKU LIKE '%Melbourne%'
UPDATE AutoPostAdPostData SET AddressID=3 WHERE SKU LIKE '%sam%' AND SKU LIKE '%Sydney%'
UPDATE AutoPostAdPostData SET AddressID=4 WHERE SKU LIKE '%sam%' AND SKU LIKE '%Brisbane%'


UPDATE ProductCategory SET TemplateID=2 WHERE ID=154





IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomFieldGroup]') AND type in (N'U'))
DROP TABLE [dbo].[CustomFieldGroup]
GO
CREATE TABLE [dbo].[CustomFieldGroup](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](100) NOT NULL,
 CONSTRAINT [PK_CustomFieldGroup] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomFieldLine]') AND type in (N'U'))
DROP TABLE [dbo].[CustomFieldLine]
GO
CREATE TABLE [dbo].[CustomFieldLine](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldGroupID] [int] NOT NULL,
	[FieldName] [varchar](100) NOT NULL,
	[FieldValue] [varchar](4000) NOT NULL,
 CONSTRAINT [PK_CustomFieldLine] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_CustomFieldLine_CustomFieldGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldLine]'))
ALTER TABLE [dbo].[CustomFieldLine]  WITH CHECK ADD CONSTRAINT [FK_CustomFieldLine_CustomFieldGroup] FOREIGN KEY([CustomFieldGroupID])
REFERENCES [dbo].[CustomFieldGroup] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO


IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='AutoPostAdPostData' AND C.Name='CustomFieldGroupID')
	ALTER TABLE dbo.AutoPostAdPostData ADD
		CustomFieldGroupID INT NOT NULL CONSTRAINT DF_AutoPostAdPostData_CustomFieldGroupID DEFAULT 1
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_AutoPostAdPostData_CustomFieldGroupID')
	ALTER TABLE dbo.AutoPostAdPostData
		DROP CONSTRAINT DF_AutoPostAdPostData_CustomFieldGroupID
GO

INSERT INTO CustomFieldGroup VALUES(N'No Custom')


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdPostData_CustomFieldGroup]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdPostData]'))
ALTER TABLE [dbo].[AutoPostAdPostData]  WITH CHECK ADD  CONSTRAINT [FK_AutoPostAdPostData_CustomFieldGroup] FOREIGN KEY([CustomFieldGroupID])
REFERENCES [dbo].[CustomFieldGroup] ([ID])
GO



IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='AutoPostAdPostData' AND C.Name='BusinessLogoPath')
	ALTER TABLE dbo.AutoPostAdPostData ADD
		BusinessLogoPath varchar(4000) NOT NULL CONSTRAINT DF_AutoPostAdPostData_BusinessLogoPath DEFAULT ''
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_AutoPostAdPostData_BusinessLogoPath')
	ALTER TABLE dbo.AutoPostAdPostData
		DROP CONSTRAINT DF_AutoPostAdPostData_BusinessLogoPath
GO

INSERT INTO DataField VALUES(N'BusinessLogoURL');
UPDATE TemplateField SET DataFieldID=16 WHERE ID=37




SET ANSI_PADDING OFF
GO



--ScheduleTask
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScheduleTask]') AND type in (N'U'))
DROP TABLE [dbo].[ScheduleTask]
GO
CREATE TABLE [dbo].[ScheduleTask](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Seconds] [int] NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[StopOnError] [bit] NOT NULL,
	[LastStartTime] [datetime] NULL,
	[LastEndTime] [datetime] NULL,
	[LastSuccessTime] [datetime] NULL,

 CONSTRAINT [PK_ScheduleTask] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO




--Schedule Rule
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScheduleRule]') AND type in (N'U'))
DROP TABLE [dbo].[ScheduleRule]
GO
CREATE TABLE [dbo].[ScheduleRule](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](4000) NOT NULL,
	[Description] [varchar](MAX) NOT NULL,
	[IntervalDay] [int] NOT NULL,
	[LastSuccessTime] datetime not null,
	[Status] [varchar](4000) not null,
	[CreateTime] datetime not null,
	[CreateBy] [varchar](4000) not null,
	[EditTime] datetime not null,
	[EditBy] [varchar](4000) not null,

 CONSTRAINT [PK_ScheduleRule] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ScheduleRuleLine]') AND type in (N'U'))
DROP TABLE [dbo].[ScheduleRuleLine]
GO
CREATE TABLE [dbo].[ScheduleRuleLine](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ScheduleRuleID] [int] NOT NULL,
	[TimeRangeFrom] datetime NOT NULL,
	[TimeRangeTo] datetime NOT NULL,
	[CreateTime] datetime not null,
	[CreateBy] [varchar](4000) not null,
	[EditTime] datetime not null,
	[EditBy] [varchar](4000) not null,

 CONSTRAINT [PK_ScheduleRuleLine] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ScheduleRuleLine_ScheduleRule]') AND parent_object_id = OBJECT_ID(N'[dbo].[ScheduleRuleLine]'))
ALTER TABLE [dbo].[ScheduleRuleLine]  WITH CHECK ADD CONSTRAINT [FK_ScheduleRuleLine_ScheduleRule] FOREIGN KEY([ScheduleRuleID])
REFERENCES [dbo].[ScheduleRule] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO








insert into ScheduleRule
select '3 Times a day' as Name,
'3 Times a day' as Description,
1 as IntervalDay,
GETDATE() as LastSuccessTime,
'A' as Status,
GETDATE() as CreateTime,
'System' as CreateBy,
GETDATE() as EditTime,
'System' as EditBy




insert into ScheduleRuleLine
select 1 as ScheduleRuleID,
'20160201 09:00:00:000' as TimeRangeFrom,
'20160201 10:00:00:000' as TimeRangeTo,
GETDATE() as CreateTime,
'System' as CreateBy,
GETDATE() as EditTime,
'System' as EditBy


insert into ScheduleRuleLine
select 1 as ScheduleRuleID,
'20160201 12:00:00:000' as TimeRangeFrom,
'20160201 13:00:00:000' as TimeRangeTo,
GETDATE() as CreateTime,
'System' as CreateBy,
GETDATE() as EditTime,
'System' as EditBy

insert into ScheduleRuleLine
select 1 as ScheduleRuleID,
'20160201 17:00:00:000' as TimeRangeFrom,
'20160201 18:00:00:000' as TimeRangeTo,
GETDATE() as CreateTime,
'System' as CreateBy,
GETDATE() as EditTime,
'System' as EditBy


IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='AutoPostAdPostData' AND C.Name='ScheduleRuleID')
	ALTER TABLE dbo.AutoPostAdPostData ADD
		ScheduleRuleID int NOT NULL CONSTRAINT DF_AutoPostAdPostData_ScheduleRuleID DEFAULT 1
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_AutoPostAdPostData_ScheduleRuleID')
	ALTER TABLE dbo.AutoPostAdPostData
		DROP CONSTRAINT DF_AutoPostAdPostData_ScheduleRuleID
GO


IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AutoPostAdPostData_ScheduleRule]') AND parent_object_id = OBJECT_ID(N'[dbo].[AutoPostAdPostData]'))
ALTER TABLE [dbo].[AutoPostAdPostData]  WITH CHECK ADD CONSTRAINT [FK_AutoPostAdPostData_ScheduleRule] FOREIGN KEY([ScheduleRuleID])
REFERENCES [dbo].[ScheduleRule] ([ID])






--Change IP Address

IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='Account' AND C.Name='IPAddress')
	ALTER TABLE dbo.Account ADD
		IPAddress varchar(500) NOT NULL CONSTRAINT DF_Account_IPAddress DEFAULT ''
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_Account_IPAddress')
	ALTER TABLE dbo.Account
		DROP CONSTRAINT DF_Account_IPAddress
GO

--Netmask
IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='Account' AND C.Name='Netmask')
	ALTER TABLE dbo.Account ADD
		Netmask varchar(500) NOT NULL CONSTRAINT DF_Account_Netmask DEFAULT ''
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_Account_Netmask')
	ALTER TABLE dbo.Account
		DROP CONSTRAINT DF_Account_Netmask
GO

--Gateway
IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='Account' AND C.Name='Gateway')
	ALTER TABLE dbo.Account ADD
		Gateway varchar(500) NOT NULL CONSTRAINT DF_Account_Gateway DEFAULT ''
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_Account_Gateway')
	ALTER TABLE dbo.Account
		DROP CONSTRAINT DF_Account_Gateway
GO

--UserAgent
IF NOT EXISTS (SELECT * FROM SysObjects O INNER JOIN SysColumns C ON O.ID=C.ID WHERE
 ObjectProperty(O.ID,'IsUserTable')=1 AND O.Name='Account' AND C.Name='UserAgent')
	ALTER TABLE dbo.Account ADD
		UserAgent varchar(500) NOT NULL CONSTRAINT DF_Account_UserAgent DEFAULT ''
GO
		
IF EXISTS (SELECT [name] FROM sysobjects WHERE [name] = 'DF_Account_UserAgent')
	ALTER TABLE dbo.Account
		DROP CONSTRAINT DF_Account_UserAgent
GO


--Receive gumtree email





--Data Insert

--Template
INSERT INTO Template VALUES(N'Default Product Ad');
INSERT INTO Template VALUES(N'Business Service Ad');
INSERT INTO Template VALUES(N'Alvin Removal Service Ad');
INSERT INTO Template VALUES(N'Job');
INSERT INTO Template VALUES(N'Community');
INSERT INTO Template VALUES(N'Cars, Vans & Utes');
INSERT INTO Template VALUES(N'Ticket');
INSERT INTO Template VALUES(N'Kayaks & Paddle');

--DataField
INSERT INTO DataField VALUES(N'');
INSERT INTO DataField VALUES(N'Price');
INSERT INTO DataField VALUES(N'Title');
INSERT INTO DataField VALUES(N'Description');
INSERT INTO DataField VALUES(N'WebsiteCategoryID');
INSERT INTO DataField VALUES(N'VerificationCode');
INSERT INTO DataField VALUES(N'Token');
INSERT INTO DataField VALUES(N'WebsiteParentCategoryID');
INSERT INTO DataField VALUES(N'ImagesList');
INSERT INTO DataField VALUES(N'Name');
INSERT INTO DataField VALUES(N'PhoneNumber');
INSERT INTO DataField VALUES(N'Address');
INSERT INTO DataField VALUES(N'GeoLatitude');
INSERT INTO DataField VALUES(N'GeoLongitude');
INSERT INTO DataField VALUES(N'PostCode');






--TemplateField

--Template 1
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,5/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,8/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,6/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,2/*DataFieldID*/,7/*Order*/,N''/*DefaultValue*/,N'price.amount'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'FIXED'/*DefaultValue*/,N'price.type'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,9/*Order*/,N'new'/*DefaultValue*/,N'condition'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,3/*DataFieldID*/,10/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,4/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N''/*DefaultValue*/,N'file'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,13/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,9/*DataFieldID*/,14/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,10/*DataFieldID*/,15/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,11/*DataFieldID*/,16/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,3/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,17/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,12/*DataFieldID*/,18/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,13/*DataFieldID*/,19/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,14/*DataFieldID*/,20/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,15/*DataFieldID*/,21/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,22/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,23/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,24/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,6/*DataFieldID*/,25/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,7/*DataFieldID*/,26/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(1/*TemplateID*/,1/*DataFieldID*/,27/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
--Template 1

--Template 2 For Sam Cleaning
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,5/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,8/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,6/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,3/*DataFieldID*/,7/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'We offer our service All over Sydney,NSW /Brisbane AND gold coast'/*DefaultValue*/,N'slogan'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,9/*Order*/,N''/*DefaultValue*/,N'file'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,10/*Order*/,N''/*DefaultValue*/,N'businesslogourl'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'accreditation'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N''/*DefaultValue*/,N'abn'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,13/*Order*/,N''/*DefaultValue*/,N'expertise1'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,14/*Order*/,N''/*DefaultValue*/,N'expertise2'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,15/*Order*/,N''/*DefaultValue*/,N'expertise3'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,16/*Order*/,N''/*DefaultValue*/,N'expertise4'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,17/*Order*/,N''/*DefaultValue*/,N'expertise5'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,4/*DataFieldID*/,18/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,19/*Order*/,N''/*DefaultValue*/,N'file'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,20/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,9/*DataFieldID*/,24/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,25/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,12/*DataFieldID*/,26/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,13/*DataFieldID*/,27/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,14/*DataFieldID*/,28/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,15/*DataFieldID*/,29/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,30/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,31/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,32/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,33/*Order*/,N'9:00am'/*DefaultValue*/,N'openhrs_mon_from'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,34/*Order*/,N'5:00pm'/*DefaultValue*/,N'openhrs_mon_to'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,35/*Order*/,N'9:00am'/*DefaultValue*/,N'openhrs_tue_from'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,36/*Order*/,N'5:00pm'/*DefaultValue*/,N'openhrs_tue_to'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,37/*Order*/,N'9:00am'/*DefaultValue*/,N'openhrs_wed_from'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,38/*Order*/,N'5:00pm'/*DefaultValue*/,N'openhrs_wed_to'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,39/*Order*/,N'9:00am'/*DefaultValue*/,N'openhrs_thu_from'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,40/*Order*/,N'5:00pm'/*DefaultValue*/,N'openhrs_thu_to'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,41/*Order*/,N'9:00am'/*DefaultValue*/,N'openhrs_fri_from'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,42/*Order*/,N'5:00pm'/*DefaultValue*/,N'openhrs_fri_to'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,43/*Order*/,N'10:00am'/*DefaultValue*/,N'openhrs_sat_from'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,44/*Order*/,N'4:00pm'/*DefaultValue*/,N'openhrs_sat_to'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,45/*Order*/,N'10:00am'/*DefaultValue*/,N'openhrs_sun_from'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,46/*Order*/,N'4:00pm'/*DefaultValue*/,N'openhrs_sun_to'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,47/*Order*/,N''/*DefaultValue*/,N'addworkhrs'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,10/*DataFieldID*/,48/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,11/*DataFieldID*/,49/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,3/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,50/*Order*/,N''/*DefaultValue*/,N'website'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,6/*DataFieldID*/,51/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,7/*DataFieldID*/,52/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(2/*TemplateID*/,1/*DataFieldID*/,53/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);

--Template 2 For Sam Cleaning


--Template 4 For Job

INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,5/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,8/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,6/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,7/*Order*/,N'private'/*DefaultValue*/,N'advertisedby'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'parttime'/*DefaultValue*/,N'jobtype'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,3/*DataFieldID*/,9/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,4/*DataFieldID*/,10/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'file'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,9/*DataFieldID*/,13/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,10/*DataFieldID*/,14/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,11/*DataFieldID*/,15/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,16/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,12/*DataFieldID*/,17/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,13/*DataFieldID*/,18/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,14/*DataFieldID*/,19/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,15/*DataFieldID*/,20/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,21/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,22/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,23/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,6/*DataFieldID*/,24/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,7/*DataFieldID*/,25/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,26/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);

INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,27/*Order*/,N'hourlyrate'/*DefaultValue*/,N'salarytype'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,28/*Order*/,N'15'/*DefaultValue*/,N'minimumsalary'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,29/*Order*/,N'30'/*DefaultValue*/,N'maximumsalary'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,30/*Order*/,N''/*DefaultValue*/,N'salarydetail'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(4/*TemplateID*/,1/*DataFieldID*/,31/*Order*/,N''/*DefaultValue*/,N'companyLogoUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
--Description--Html:
--<p>Mr.Sam restaurant at Sydney looking for delivery driver to deliver food in Sydney city area , multiple drop off spots but short delivery distance. if you are looking for part time job , this is the best opportunity </p><p>All delivery stuff provided, but applicant need to own a vehicle ( car / bike / motor ) anything , no experiences required , above expectation salary .</p><p>Anyone keen to work are welcomed to apply via email * EMAIL ONLY *</p><p>samthedeliveryexperts@gmail.com</p>

--Template 4 For Job


--Template 5 For Community

INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,5/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,8/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,6/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,3/*DataFieldID*/,7/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,4/*DataFieldID*/,8/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,9/*Order*/,N''/*DefaultValue*/,N'file'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,10/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,9/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,10/*DataFieldID*/,12/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,11/*DataFieldID*/,13/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,3/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,14/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,12/*DataFieldID*/,15/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,13/*DataFieldID*/,16/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,14/*DataFieldID*/,17/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,15/*DataFieldID*/,18/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,19/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,20/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,21/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,6/*DataFieldID*/,22/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,7/*DataFieldID*/,23/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(5/*TemplateID*/,1/*DataFieldID*/,24/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);

--Template 5 For Community


--Template 6 For Cars, Vans & Utes

INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,5/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,8/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,6/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,2/*DataFieldID*/,7/*Order*/,N''/*DefaultValue*/,N'price.amount'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'NEGOTIABLE'/*DefaultValue*/,N'price.type'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,9/*Order*/,N'ownr'/*DefaultValue*/,N'forsaleby_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,10/*Order*/,N'mazda'/*DefaultValue*/,N'carmake_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,11/*Order*/,N'mazda_323'/*DefaultValue*/,N'carmodel_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N'sedan'/*DefaultValue*/,N'carbodytype_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,13/*Order*/,N'1998'/*DefaultValue*/,N'caryear_i'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,14/*Order*/,N'93500'/*DefaultValue*/,N'carmileageinkms_i'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,15/*Order*/,N'm'/*DefaultValue*/,N'cartransmission_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,16/*Order*/,N'fwd'/*DefaultValue*/,N'drivetrain_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,17/*Order*/,N'leaded'/*DefaultValue*/,N'fueltype_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,18/*Order*/,N'blue'/*DefaultValue*/,N'colour_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,19/*Order*/,N'y'/*DefaultValue*/,N'airconditioning_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,20/*Order*/,N''/*DefaultValue*/,N'licencenumber_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,21/*Order*/,N''/*DefaultValue*/,N'stocknumber_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,22/*Order*/,N'y'/*DefaultValue*/,N'registered_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,23/*Order*/,N'OSQ319'/*DefaultValue*/,N'registrationnumber_s'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,24/*Order*/,N'2015-03-01T00:00:00Z'/*DefaultValue*/,N'registrationexpiry_tdt'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,25/*Order*/,N'01/03/2015'/*DefaultValue*/,N'registrationexpiry'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,3/*DataFieldID*/,26/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,4/*DataFieldID*/,27/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,28/*Order*/,N''/*DefaultValue*/,N'file'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,29/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,9/*DataFieldID*/,30/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,10/*DataFieldID*/,31/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,11/*DataFieldID*/,32/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,3/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,33/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,12/*DataFieldID*/,34/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,13/*DataFieldID*/,35/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,14/*DataFieldID*/,36/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,15/*DataFieldID*/,37/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,38/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,39/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,40/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,6/*DataFieldID*/,41/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,7/*DataFieldID*/,42/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(6/*TemplateID*/,1/*DataFieldID*/,43/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);

--Template 5 For Community


--Template 6
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,5/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,8/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,6/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,2/*DataFieldID*/,7/*Order*/,N''/*DefaultValue*/,N'price.amount'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'FIXED'/*DefaultValue*/,N'price.type'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,9/*Order*/,N'new'/*DefaultValue*/,N'condition'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,3/*DataFieldID*/,10/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,4/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N''/*DefaultValue*/,N'file'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,13/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,9/*DataFieldID*/,14/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,10/*DataFieldID*/,15/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,11/*DataFieldID*/,16/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,3/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,17/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,12/*DataFieldID*/,18/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,13/*DataFieldID*/,19/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,14/*DataFieldID*/,20/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,15/*DataFieldID*/,21/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,3/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,22/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,23/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,24/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,6/*DataFieldID*/,25/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,7/*DataFieldID*/,26/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,27/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,28/*Order*/,N'/2016-01-07T00:00:00Z,2016-07-07T00:00:00Z'/*DefaultValue*/,N'attributeMap[other_events_tickets.event_mtdtcsv]'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,29/*Order*/,N'/07/01/2016'/*DefaultValue*/,N'dateRangeMap[other_events_tickets.event.eventstartdate]'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(7/*TemplateID*/,1/*DataFieldID*/,30/*Order*/,N'/07/07/2016'/*DefaultValue*/,N'dateRangeMap[other_events_tickets.event.eventenddate]'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
--Template 6



INSERT INTO Template VALUES(N'Property for Rent');

INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'greyimport'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,5/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,8/*DataFieldID*/,6/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,7/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'false'/*DefaultValue*/,N'isBusinessServicesCategory'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,2/*DataFieldID*/,9/*Order*/,N''/*DefaultValue*/,N'price.amount'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,10/*Order*/,N'FIXED'/*DefaultValue*/,N'price.type'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'minimumOfferPrice'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N'apt'/*DefaultValue*/,N'dwellingtype'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,13/*Order*/,N'agncy'/*DefaultValue*/,N'forrentby'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,14/*Order*/,N'2016-11-18T00:00:00Z'/*DefaultValue*/,N'availabilitystartdate_tdt'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,15/*Order*/,N'18/11/2016'/*DefaultValue*/,N'datesMap[rentals.availabilitystartdate]'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,16/*Order*/,N'1b'/*DefaultValue*/,N'numberbedrooms'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,17/*Order*/,N'1b'/*DefaultValue*/,N'numberbathrooms'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,18/*Order*/,N'covrd'/*DefaultValue*/,N'parking'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,19/*Order*/,N'n'/*DefaultValue*/,N'smoking'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,20/*Order*/,N'n'/*DefaultValue*/,N'furnished'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,21/*Order*/,N'n'/*DefaultValue*/,N'petsallowed'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,3/*DataFieldID*/,22/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,4/*DataFieldID*/,23/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,24/*Order*/,N''/*DefaultValue*/,N'files'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,25/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,9/*DataFieldID*/,26/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,27/*Order*/,N''/*DefaultValue*/,N'contactTitle'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,10/*DataFieldID*/,28/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,11/*DataFieldID*/,29/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,30/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,12/*DataFieldID*/,31/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,13/*DataFieldID*/,32/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,14/*DataFieldID*/,33/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,15/*DataFieldID*/,34/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,35/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,36/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,37/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,6/*DataFieldID*/,38/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,7/*DataFieldID*/,39/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(11/*TemplateID*/,1/*DataFieldID*/,40/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);




INSERT INTO Template VALUES(N'Property for Sale');

INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'greyimport'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,5/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,8/*DataFieldID*/,6/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,7/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'false'/*DefaultValue*/,N'isBusinessServicesCategory'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,2/*DataFieldID*/,9/*Order*/,N''/*DefaultValue*/,N'price.amount'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,10/*Order*/,N'FIXED'/*DefaultValue*/,N'price.type'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'minimumOfferPrice'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N'apt'/*DefaultValue*/,N'dwellingtype'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,13/*Order*/,N'agncy'/*DefaultValue*/,N'dwellingforsaleby'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,14/*Order*/,N'2016-11-20T00:00:00Z'/*DefaultValue*/,N'availabilitystartdate_tdt'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,15/*Order*/,N'20/11/2016'/*DefaultValue*/,N'datesMap[property_for_sale.availabilitystartdate]'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,16/*Order*/,N'2b'/*DefaultValue*/,N'numberbedrooms'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,17/*Order*/,N'1b'/*DefaultValue*/,N'numberbathrooms'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,18/*Order*/,N''/*DefaultValue*/,N'areainmeters'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,19/*Order*/,N'covrd'/*DefaultValue*/,N'parking'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,3/*DataFieldID*/,20/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,4/*DataFieldID*/,21/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,22/*Order*/,N''/*DefaultValue*/,N'files'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,23/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,9/*DataFieldID*/,24/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,10/*DataFieldID*/,25/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,11/*DataFieldID*/,26/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,27/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,12/*DataFieldID*/,28/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,13/*DataFieldID*/,29/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,14/*DataFieldID*/,30/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,15/*DataFieldID*/,31/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,32/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,33/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,34/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,6/*DataFieldID*/,35/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,7/*DataFieldID*/,36/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(12/*TemplateID*/,1/*DataFieldID*/,37/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);




INSERT INTO Template VALUES(N'Office Space & Commercial');


INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,1/*Order*/,N''/*DefaultValue*/,N'adId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,2/*Order*/,N'false'/*DefaultValue*/,N'repost'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,3/*Order*/,N''/*DefaultValue*/,N'greyimport'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,4/*Order*/,N''/*DefaultValue*/,N'galleryImageIndex'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,5/*DataFieldID*/,5/*Order*/,N''/*DefaultValue*/,N'categoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,8/*DataFieldID*/,6/*Order*/,N''/*DefaultValue*/,N'level2CategoryId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,7/*Order*/,N'OFFER'/*DefaultValue*/,N'adType'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,8/*Order*/,N'false'/*DefaultValue*/,N'isBusinessServicesCategory'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,2/*DataFieldID*/,9/*Order*/,N''/*DefaultValue*/,N'price.amount'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,10/*Order*/,N'FIXED'/*DefaultValue*/,N'price.type'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,11/*Order*/,N''/*DefaultValue*/,N'minimumOfferPrice'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,12/*Order*/,N'ownr'/*DefaultValue*/,N'forrentby'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
--INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,13/*Order*/,N'agncy'/*DefaultValue*/,N'dwellingforsaleby'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,14/*Order*/,N'2017-06-09T00:00:00Z'/*DefaultValue*/,N'availabilitystartdate_tdt'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,15/*Order*/,N'09/06/2017'/*DefaultValue*/,N'datesMap[office_space_commercial.availabilitystartdate]'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,16/*Order*/,N'stret'/*DefaultValue*/,N'parking'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,17/*Order*/,N'240'/*DefaultValue*/,N'areainmeters'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
--INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,18/*Order*/,N''/*DefaultValue*/,N'areainmeters'/*TemplateFieldName*/,1/*TemplateFieldType*/,0/*IsRequireInput*/);
--INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,19/*Order*/,N'covrd'/*DefaultValue*/,N'parking'/*TemplateFieldName*/,1/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,3/*DataFieldID*/,20/*Order*/,N''/*DefaultValue*/,N'title'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,4/*DataFieldID*/,21/*Order*/,N''/*DefaultValue*/,N'description'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,22/*Order*/,N''/*DefaultValue*/,N'files'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,23/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,9/*DataFieldID*/,24/*Order*/,N''/*DefaultValue*/,N'images'/*TemplateFieldName*/,2/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,10/*DataFieldID*/,25/*Order*/,N''/*DefaultValue*/,N'name'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,11/*DataFieldID*/,26/*Order*/,N''/*DefaultValue*/,N'phoneNumber'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,27/*Order*/,N'0'/*DefaultValue*/,N'locationId'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,12/*DataFieldID*/,28/*Order*/,N''/*DefaultValue*/,N'mapAddress'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,13/*DataFieldID*/,29/*Order*/,N''/*DefaultValue*/,N'geocodeLat'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,14/*DataFieldID*/,30/*Order*/,N''/*DefaultValue*/,N'geocodeLng'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,15/*DataFieldID*/,31/*Order*/,N''/*DefaultValue*/,N'geocodeLocality'/*TemplateFieldName*/,0/*TemplateFieldType*/,1/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,32/*Order*/,N'OK'/*DefaultValue*/,N'geocodeConfidence'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,33/*Order*/,N'false'/*DefaultValue*/,N'unacceptableGeocode'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,34/*Order*/,N'on'/*DefaultValue*/,N'_showLocationOnMap'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,6/*DataFieldID*/,35/*Order*/,N''/*DefaultValue*/,N'bbUserInput'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,7/*DataFieldID*/,36/*Order*/,N''/*DefaultValue*/,N'bbToken'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);
INSERT INTO TemplateField  VALUES(13/*TemplateID*/,1/*DataFieldID*/,37/*Order*/,N'/bb-image.html'/*DefaultValue*/,N'bbImageBaseUrl'/*TemplateFieldName*/,0/*TemplateFieldType*/,0/*IsRequireInput*/);



--ProductCategory
INSERT INTO ProductCategory VALUES(N'18359',N'Health & Beauty',N'9303',2)
INSERT INTO ProductCategory VALUES(N'18359',N'Health & Beauty',N'9303',2)


--Account 
INSERT INTO Account VALUES(N'Alvin20131214@yahoo.com.au',N'AlRemoval1981827',N'Alvin',N'',N'WTln=21381; bs=%7B%22st%22%3A%7B%22F%22%3A%5B%22POST_AD_FORM%22%5D%7D%7D; __utmc=160852194; machId=s1PQFTaIFYh7g6JrxCreKh5zVIBCFm2Qt70px9vUPW8iAE8YOFpX5sVuGZhpCIYHvE8BUDHE4ROoH5xHGYhZeb5v6hzpX0UYT_VwWw; up=%7B%22ln%22%3A%2250186503%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D0%26k%3Dgdutjim%2540gmail.com%26p%3D2%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __utma=160852194.757704069.1386625329.1386970831.1386976002.26; __utmz=160852194.1386625329.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.48.9.1386980964249; sid2=1f8b08000000000000003334303031363033323770303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d4a4d4bc2cd8acaf4f32383524a72f54a429dfd03dcf501cdfadee277000000',N'0433767824',N'A');
INSERT INTO Account VALUES(N'Alvin20131214@yahoo.com.au',N'AlRemoval1981827',N'Alvin',N'',N'WTln=21381; bs=%7B%22st%22%3A%7B%22F%22%3A%5B%22POST_AD_FORM%22%5D%7D%7D; __utmc=160852194; machId=s1PQFTaIFYh7g6JrxCreKh5zVIBCFm2Qt70px9vUPW8iAE8YOFpX5sVuGZhpCIYHvE8BUDHE4ROoH5xHGYhZeb5v6hzpX0UYT_VwWw; up=%7B%22ln%22%3A%2250186503%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D0%26k%3Dgdutjim%2540gmail.com%26p%3D2%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __utma=160852194.757704069.1386625329.1386970831.1386976002.26; __utmz=160852194.1386625329.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.48.9.1386980964249; sid2=1f8b08000000000000003334303031363033323770303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d4a4d4bc2cd8acaf4f32383524a72f54a429dfd03dcf501cdfadee277000000',N'0433767522',N'A');
INSERT INTO Account VALUES(N'Alvin20131214@yahoo.com.au',N'AlRemoval1981827',N'Alvin',N'',N'WTln=21381; bs=%7B%22st%22%3A%7B%22F%22%3A%5B%22POST_AD_FORM%22%5D%7D%7D; __utmc=160852194; machId=s1PQFTaIFYh7g6JrxCreKh5zVIBCFm2Qt70px9vUPW8iAE8YOFpX5sVuGZhpCIYHvE8BUDHE4ROoH5xHGYhZeb5v6hzpX0UYT_VwWw; up=%7B%22ln%22%3A%2250186503%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D0%26k%3Dgdutjim%2540gmail.com%26p%3D2%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __utma=160852194.757704069.1386625329.1386970831.1386976002.26; __utmz=160852194.1386625329.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.48.9.1386980964249; sid2=1f8b08000000000000003334303031363033323770303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d4a4d4bc2cd8acaf4f32383524a72f54a429dfd03dcf501cdfadee277000000',N'0430087428',N'A');
INSERT INTO Account VALUES(N'Alvin20131214@yahoo.com.au',N'AlRemoval1981827',N'angela',N'',N'WTln=21381; bs=%7B%22st%22%3A%7B%22F%22%3A%5B%22POST_AD_FORM%22%5D%7D%7D; __utmc=160852194; machId=s1PQFTaIFYh7g6JrxCreKh5zVIBCFm2Qt70px9vUPW8iAE8YOFpX5sVuGZhpCIYHvE8BUDHE4ROoH5xHGYhZeb5v6hzpX0UYT_VwWw; up=%7B%22ln%22%3A%2250186503%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D0%26k%3Dgdutjim%2540gmail.com%26p%3D2%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __utma=160852194.757704069.1386625329.1386970831.1386976002.26; __utmz=160852194.1386625329.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.48.9.1386980964249; sid2=1f8b08000000000000003334303031363033323770303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d4a4d4bc2cd8acaf4f32383524a72f54a429dfd03dcf501cdfadee277000000',N'0426151678',N'A');
--INSERT INTO Account VALUES(N'bright0827@yahoo.com',N'1981827',N'Alvin',N'',N'',N'0433767824',N'A');
--INSERT INTO Account VALUES(N'tl1981827@hotmail.com',N'1981827',N'Alvin',N'',N'',N'0433767824',N'A');
--INSERT INTO Account VALUES(N'alremoval@hotmail.com',N'1981827',N'Alvin',N'',N'',N'0433767824',N'A');
INSERT INTO Account VALUES(N'NorthySydneyMassage@yahoo.com.au',N'JudyKevin20140112',N'Judy',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=jl0iYhacPQZIcsxOxNRhiVrzrg25gGnB35KuS2rWSXp6a8umY6gLIKlIBhzFjdCvxUrCbwafdK68Z4_xJ4GIKIdXWYmIalplyfiAN3w; up=%7B%22ln%22%3A%22220776953%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D0%26k%3D1036143676%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22rva%22%3A%22%22%7D; __utma=160852194.1284182981.1388445840.1389525804.1389527956.48; __utmz=160852194.1388445840.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1284182981.1388445840; wl=%7B%22l%22%3A%22%22%7D; __gads=ID=e3446971a7830df6:T=1389140591:S=ALNI_Ma2Ok-neLgw4ZQf58gv2a5iXvWnjw; __utmb=160852194.4.10.1389527956; sid2=1f8b08000000000000003334303031b13036353076303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d0cbc4acb9d2c4bdcbcb30a1203038ddc1d931323920c00458ab9a377000000; ForceBackend=Resp',N'0450053883',N'A');
INSERT INTO Account VALUES(N'michaelle.parker@gmail.com',N'Vhsb1234',N'Anna',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=igjpM9KGQAMyEcPHuuyp-x2jLuh_8aSCzA94XFYmFl7DGw8qwgcH3rOg1Lu4rYvQTEfWeWJ8xzxdkMj8TrzvBcZt5mNCp8penGwCOg; up=%7B%22ln%22%3A%22110693678%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.300979980.1389585453; __utma=160852194.300979980.1389585453.1390206688.1390211045.41; __utmz=160852194.1389585453.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=bda8b8fb7cfd3b0d:T=1389588013:S=ALNI_MZj_IvfGkZOPPkYgCKdG793yl-5UQ; wl=%7B%22l%22%3A%22%22%7D; svid=411902123137905749; __utmb=160852194.19.10.1390211045; sid2=1f8b08000000000000003334303031353132b13477303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d520d02f3cd23237c0a3372d2c23df212430d7d9c8df5000bf6eb1777000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'victoria.miller1952@gmail.com',N'Vhsb1234',N'Kate',N'',N'machId=fwf40BACVu2uG2U3487LYEfKtkJvV9PlY37AokQ_i6P5XqGFcZNAZxv1w1I8UsKzf-oKsmuHyaYDm_PmToFCS5BcnS82AS4rm9M58w; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22678074459%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __gads=ID=5d982b31bcba602c:T=1390478279:S=ALNI_MZj6yjzjSvVZ0epsSTybF7iUpvz6Q; __utma=160852194.103221914.1390478285.1390478285.1390478285.1; __utmb=160852194.2.10.1390478285; __utmc=160852194; __utmz=160852194.1390478285.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.103221914.1390478285; sid2=1f8b080000000000000033343030313533b3343674303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d2292c30afd130b0ab3fdcaf383fdcc72b2229c530c0c00be1e42ad77000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'gdutjim@gmail.com',N'Shishiliu-0310',N'Jim',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=fwf40BACVu2uG2U3487LYEfKtkJvV9PlY37AokQ_i6P5XqGFcZNAZxv1w1I8UsKzf-oKsmuHyaYDm_PmToFCS5BcnS82AS4rm9M58w; up=%7B%22ln%22%3A%22678074459%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __gads=ID=5d982b31bcba602c:T=1390478279:S=ALNI_MZj6yjzjSvVZ0epsSTybF7iUpvz6Q; __utma=160852194.103221914.1390478285.1390512100.1390520183.3; __utmb=160852194.9.10.1390520183; __utmz=160852194.1390478285.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.103221914.1390478285; wl=%7B%22l%22%3A%22%22%7D; sid2=1f8b08000000000000003334303034313037323370303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d9cc383fd522c1d73c3537c2b0b0d5cbd7caa225dfc0d01e36b012577000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'victoria.young22@outlook.com',N'Vic22isme',N'Liliana',N'',N'machId=t1zKZngqHMsNw9F0N4-g1mvZR8jOhNwdQJ0FsdLdI2qT1K-hyC-J6VOg7n9-9_EJnZCMMQkJasbbzvI_IFIFbjYkhlhKAPcg7cRwyw; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22129794452%22%7D; _ga=GA1.3.1380255156.1390561352; __utma=160852194.1380255156.1390561352.1390561352.1390561352.1; __utmb=160852194.2.10.1390561352; __utmc=160852194; __utmz=160852194.1390561352.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b08000000000000003334303031353736313076303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dc24b320b4a8d3c92cd3d329c4ccafd9dd323c3834df400e163875b77000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'kayla.cox32@outlook.com',N'Kayis32now',N'Eleasa',N'',N'machId=Z0PRBxYIZuiS9IVGg9YUSMgEJrUrwKAwirVt_ELib9UH-N5LICa3gButMfwBBDbhkkgHw9Bnic4s8YTGi1NE1ttD6Vr8qsEXPFE; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22133860227%22%7D; _ga=GA1.3.767273536.1390643606; __utma=160852194.767273536.1390643606.1390643606.1390643606.1; __utmb=160852194.2.10.1390643606; __utmc=160852194; __utmz=160852194.1390643606.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b0800000000000000333430303135b734373576303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dbc9d8d5d328b834b8a2b43f20b4dc31d2d3cc3334af4010b668fdd77000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'lydiahamilton22@yahoo.com',N'Sweetandsalty1',N'Eleasa',N'',N'machId=19ZytmYqEua2JMKRnFereOQAVnGhFw0egLNK643cJHKLs5DWzB9exYuIk2KR1nwOOMYGgaqWJMi1MK778-R37EI8FtGPOQntrKtG2w; up=%7B%22ln%22%3A%22998218156%22%7D; __utma=160852194.1306160357.1390711554.1390711554.1390711554.1; __utmb=160852194.6.10.1390711554; __utmz=160852194.1390711554.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1306160357.1390711554; svid=412402139003773714; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b08000000000000003334303031b530363334743032d73335d0b330d13334357770f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dbc8bc32cc233f553f5fd03234bcd2c5c0bd37dcd520d01ce6bb56d76000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'Julia.Russel@live.com',N'Manvs3ild',N'Julia',N'',N'machId=F0ihgRCRZckFRcbksMvFODjg8jgadvPA8how1fZVje-8ra96R5lqfwZEfWhX_B2dso2Dnpcmg8O300W2hRydf0fsYSsZOdz9cycm; up=%7B%22ln%22%3A%22359137176%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lsh%22%3A%22l%3D0%26c%3D18347%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18347%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%7D; _ga=GA1.3.1364112268.1390728522; __utma=160852194.1364112268.1390728522.1391564066.1391574750.58; __utmz=160852194.1390728523.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=b5825e1fc36aa2f6:T=1390728943:S=ALNI_MYQaYDIbPiuk1CHNv3PbN_APsVtHQ; svid=411602139849160612; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.2.10.1391574750; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b0800000000000000333430303133b5303334703032d73335d0b330d13334357770f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d12dd937dcb4b2b72a22ab29c4242cb7c3df232324c0d003b0e4e6276000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'AndersenMowingRemoval@yahoo.com.au',N'SydneyRemoval20140208',N'Andersen',N'',N'machId=F0ihgRCRZckFRcbksMvFODjg8jgadvPA8how1fZVje-8ra96R5lqfwZEfWhX_B2dso2Dnpcmg8O300W2hRydf0fsYSsZOdz9cycm; up=%7B%22ln%22%3A%22359137176%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lsh%22%3A%22l%3D0%26c%3D18347%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18347%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%7D; _ga=GA1.3.1364112268.1390728522; __utma=160852194.1364112268.1390728522.1391754086.1391807323.74; __utmz=160852194.1390728523.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=b5825e1fc36aa2f6:T=1390728943:S=ALNI_MYQaYDIbPiuk1CHNv3PbN_APsVtHQ; svid=411602139849160612; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.30.10.1391807323; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b08000000000000003334303031333737303770303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dfcbcb20c3d439293dc5c83b22b2d5d83022a73dcf40c018401fc0c77000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'AdamZhouPaPi@yahoo.com.au',N'Automotive20140212',N'Adam',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=F0ihgRCRZckFRcbksMvFODjg8jgadvPA8how1fZVje-8ra96R5lqfwZEfWhX_B2dso2Dnpcmg8O300W2hRydf0fsYSsZOdz9cycm; up=%7B%22ln%22%3A%22359137176%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lsh%22%3A%22l%3D0%26c%3D18347%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18347%26r%3D0%26sv%3DLIST%26at%3DOFFER%26sf%3Ddate%22%7D; _ga=GA1.3.1364112268.1390728522; __utma=160852194.1364112268.1390728522.1392187485.1392200049.108; __utmz=160852194.1390728523.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=b5825e1fc36aa2f6:T=1390728943:S=ALNI_MYQaYDIbPiuk1CHNv3PbN_APsVtHQ; svid=411602139849160612; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.2.10.1392200049; sid2=1f8b08000000000000003334303031373431323076303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dca9d7da22acaaa9cf48c4a8d92fc8dcd7c2a23abcc0d007835133477000000; ForceBackend=Resp',N'0431648898',N'A');
INSERT INTO Account VALUES(N'rebecca.eriksson88@outlook.com',N'Manvs3ild987',N'Rebecca',N'',N'imp=5; ForceBackend=Resp; machId=Msd6MpYBHKTXBY36hCrC3ef6OWxLwet53s3h777w4eB7QP_4C405_RYkOpNuN7P2LVd6R0cbNECWLEsJxcXGfciE_MvomQyt0syA; up=%7B%22ln%22%3A%22157992337%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __utma=160852194.2096233708.1393215132.1393707726.1393716939.33; __utmz=160852194.1393215132.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.2096233708.1393215132; __gads=ID=f9dab48ce268cfc3:T=1393323071:S=ALNI_MZA8CWE0SNvYWlHFtyYADRNUcuuLQ; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.7.10.1393716939; svid=412202189393463510; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b080000000000000033343030b13031363436713032d73335d0b330d13334357770f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dfcd34393d39d0d328ab3fd8c8b5d8253f37392cdf2f501edb8ac7c76000000',N'',N'A');
INSERT INTO Account VALUES(N'Jacky.lee70@outlook.com',N'You3e6unt',N'Jacky',N'',N'imp=1; ForceBackend=Resp; machId=Msd6MpYBHKTXBY36hCrC3ef6OWxLwet53s3h777w4eB7QP_4C405_RYkOpNuN7P2LVd6R0cbNECWLEsJxcXGfciE_MvomQyt0syA; up=%7B%22ln%22%3A%22157992337%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __utma=160852194.2096233708.1393215132.1393825629.1393838152.44; __utmz=160852194.1393215132.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.2096233708.1393215132; __gads=ID=f9dab48ce268cfc3:T=1393323071:S=ALNI_MZA8CWE0SNvYWlHFtyYADRNUcuuLQ; wl=%7B%22l%22%3A%22%22%7D; svid=412202189393463510; __utmb=160852194.7.10.1393838152; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b080000000000000033343030b1303533333275303430d63332d33333d23332b07470f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351ddc3d8cdd42abc20bf383f473332b5202824cf29c7c0c01074a01bb77000000',N'',N'A');
INSERT INTO Account VALUES(N'KenCheng20140507@yahoo.com.au',N'CarDetail20140507',N'Cheng',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; __utma=160852194.761582855.1399463920.1399463920.1399463920.1; __utmb=160852194.3.9.1399464720488; __utmz=160852194.1396348423.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); machId=p5CAJkI3bsMwKYHpJfy0zPY1GEc2g8_SFcY_vjaiwJAg5oJ0UR5tKIjN4Ue_Cd_5nL3e0b2bF8hbPdGiRb4psiebMkd3Ax92e44K; up=%7B%22ln%22%3A%22176730480%22%7D; _ga=GA1.3.761582855.1399463920; __gads=ID=dc3450aa5e439e17:T=1399464732:S=ALNI_MZFPN17eWBxctWf3mMxRJLJFq8jew; sid2=1f8b08000000000000003334303035b2343535b770303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dca5d5c731cd37332720cd32c92924afcc27ccdcbfc0d0034775e3877000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'SamCleaning20140609@yahoo.com.au',N'FuckingSamNew0609',N'Sam',N'',N'__utma=160852194.761582855.1399463920.1402285134.1402289423.160; __utmz=160852194.1396348423.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); machId=p5CAJkI3bsMwKYHpJfy0zPY1GEc2g8_SFcY_vjaiwJAg5oJ0UR5tKIjN4Ue_Cd_5nL3e0b2bF8hbPdGiRb4psiebMkd3Ax92e44K; up=%7B%22ln%22%3A%22176730480%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.761582855.1399463920; __gads=ID=dc3450aa5e439e17:T=1399464732:S=ALNI_MZFPN17eWBxctWf3mMxRJLJFq8jew; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.25.9.1402292065743; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b08000000000000003334303035b13433363071303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d72ab7cb3dc0c2b4d93724b523c5d9cd332c273b3f4f500d7dc638677000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'SamIndiClean@yahoo.com.au',N'20140609SecondAcc',N'Sammy',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; __utma=160852194.761582855.1399463920.1402285134.1402289423.160; __utmz=160852194.1396348423.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); machId=p5CAJkI3bsMwKYHpJfy0zPY1GEc2g8_SFcY_vjaiwJAg5oJ0UR5tKIjN4Ue_Cd_5nL3e0b2bF8hbPdGiRb4psiebMkd3Ax92e44K; up=%7B%22ln%22%3A%22176730480%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.761582855.1399463920; __gads=ID=dc3450aa5e439e17:T=1399464732:S=ALNI_MZFPN17eWBxctWf3mMxRJLJFq8jew; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.46.8.1402293869925; sid2=1f8b08000000000000003334303035b13433333774303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351dd29dcd0bbc328dd393734ccc3312935333b3bd0acb0d00d5b6a65077000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'SydBrisGoldSam@yahoo.com.au',N'Winsor50George',N'Sammy',N'',N'machId=44ZL1ta7OI9neV_rclYCnk-VSP_B2aF7FvT23hOhF7zvwn3YdHLsVGya-zOhYgyJ3NDQTayOX1aAzNHv3j2117kMCBffAKKh2Jk4; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22980031386%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.19066647.1405754678; _dc=1; __gads=ID=0fef29d4acd91940:T=1405754673:S=ALNI_MZQeb_VMGTkG7fzGVZlYD_tYNgk9g; __utma=160852194.19066647.1405754678.1405754678.1405754678.1; __utmb=160852194.3.10.1405754678; __utmc=160852194; __utmz=160852194.1405754678.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b0800000000000000333430303537363630b470303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d0a43c3cc924afd5d0d2d438b5df48d1db3430ac2f2f40149251dd877000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'KenMelCleaning@yahoo.com.au',N'AlvinKen20140719',N'Keane',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b08000000000000003334303035373636b43077303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d1223b3cd9d322cdc8a4ab39ccd42b30343cb9dfc92f500a0ff126677000000; machId=44ZL1ta7OI9neV_rclYCnk-VSP_B2aF7FvT23hOhF7zvwn3YdHLsVGya-zOhYgyJ3NDQTayOX1aAzNHv3j2117kMCBffAKKh2Jk4; up=%7B%22ln%22%3A%22980031386%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.19066647.1405754678; __gads=ID=0fef29d4acd91940:T=1405754673:S=ALNI_MZQeb_VMGTkG7fzGVZlYD_tYNgk9g; __utma=160852194.19066647.1405754678.1405754678.1405754678.1; __utmb=160852194.24.9.1405756873447; __utmz=160852194.1405754678.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); wl=%7B%22l%22%3A%22%22%7D; ForceBackend=Resp',N'0404603839',N'A');
INSERT INTO Account VALUES(N'DarylLeung20140902@yahoo.com.au',N'Kuaikuai0511',N'Daryl',N'',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=80z58_imDEonOXpBUds6iRTT4V0CRccJ5ld6W0mX-I4QBw4t_QI-m0234SGcc1JUN8LVQJVXElj45JfpBFujyhQcF5zgtuPIWqsz; up=%7B%22ln%22%3A%22824954696%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.31584076.1409615795; _gat=1; __utma=160852194.31584076.1409615795.1409623143.1409631852.3; __utmb=160852194.6.10.1409631852; __utmz=160852194.1409615795.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=0c7468fd7fae2b6d:T=1409615794:S=ALNI_MZ8EgNh5kxRm3uUFv4ZCOOa7s52Yg; crtg_rta=; sid2=1f8b08000000000000003334303033343337333571303434d0333431d63334b6d433367270f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351ddc3cf20b720db2d28d024d9c0222c24a4afd8a0c33f40028187f1078000000; ForceBackend=Resp',N'0404038999',N'A');
INSERT INTO Account VALUES(N'SumitKumar19800614@yahoo.com.au',N'Assignment20141021',N'Timmy',N'',N'machId=Y8l6hBIVKqkwR-zedrIBgO51NiVCy3s3DE8-ZpaPK6Jp3z9t_jkl0ri7HHJf2rV12wTYTC65TUBbmgLWlvgSwPMN6uifXRjNWYkw; up=%7B%22ln%22%3A%22848464182%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.737166614.1411857221; __utma=160852194.737166614.1411857221.1413868893.1413884528.94; __utmz=160852194.1411857221.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmb=160852194.7.9.1413886039521; __gads=ID=813a3750f9486102:T=1413861301:S=ALNI_MZ7xKaUnYvKbfmtxDo68YnXcS8Ryg; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; _gat=1; __utmt_siteTracker=1; sid2=1f8b08000000000000003334303033333735333372303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351db273020d2d7d0b4d3c8df4f332028ad2cc2dd22b33f501fdbf1af977000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'TimmyKumar19800617@Yahoo.com.au',N'Assignment20141021',N'Timmy',N'',N'machId=c0aB93yPUaUgA38qjore6TsBATUWffZyKOGGzXznIAKVb8IILHcGbNmOx4XZUTfYEAmr_kfRowbj5HsD4st9187IP_altXHuuf_P6A; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22846064278%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; __gads=ID=255fbc9dc4139dac:T=1414108396:S=ALNI_MZ-6HUIxG3amEoeq3JfeLsiufsifw; _ga=GA1.3.2061423035.1414108397; _gat=1; __utma=160852194.2061423035.1414108397.1414108398.1414108398.1; __utmb=160852194.3.10.1414108398; __utmc=160852194; __utmz=160852194.1414108398.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt_siteTracker=1; sid2=1f8b08000000000000003334303033373034303671303434d0333431d63334b6d433367270f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d325303cab2f20a4b5c8d12a3cc53f45212cdfdb33d0c00b100924078000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'AssignmentAgain@Yahoo.com.au',N'MelAssignment',N'Alan',N'',N'machId=V9NKh3ymKwdCH5LHBmcIAohNBrZ4VX77mjyPjp4biTFedhuXOJDeC59z6K8gh15T1t-OEmLDGD-q9bhVm8NKaCDyxJeST1sCefbN; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22472255251%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.632941616.1415568778; _gat=1; __utma=160852194.632941616.1415568778.1415568779.1415568779.1; __utmb=160852194.3.10.1415568779; __utmc=160852194; __utmz=160852194.1415568779.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt_siteTracker=1; __gads=ID=d45fe0e8fe0d8b82:T=1415568777:S=ALNI_Mag6H_4XYmymWAibSmfhYlvdom67Q; crtg_rta=; sid2=1f8b080000000000000033343030b3b03034343477303434d0333431d63334b6d433367270f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d728ad22db273fd033c025d2b9c722cfc7c4cd3cb420c01944194d678000000; ForceBackend=Resp',N'',N'A');
INSERT INTO Account VALUES(N'JunNingz@yahoo.com.au',N'NewGoodArtist',N'Junning',N'',N'ki_t=1419713448560%3B1421273336237%3B1421273448190%3B3%3B60; ki_r=; _ga=GA1.3.168158771.1421198558; __utma=160852194.168158771.1421198558.1421212212.1421270750.4; __utmb=160852194.24.10.1421270750; __utmz=160852194.1421198559.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); machId=2oaqJIA7AyzD5xEl2ZazWm7r69Ak5FiqNCub54hny-3uOzGs8-b0MCWflF7uaivGPIPkp9Q-ssCefn7NkwiErVtkBKHIGy0cS0E; up=%7B%22ln%22%3A%22723796098%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1421200678057r0.7354215482576429; crtg_rta=; __gads=ID=0a7aa5bde88ff17f:T=1421200683:S=ALNI_MYMxjLd37gfLILR7UDHqhFOhdD2cw; __utmt_siteTracker=1; _gat=1; bs=%7B%22st%22%3A%7B%7D%7D; optimizelyBuckets=%7B%7D; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1421200678057r0.7354215482576429%26t%3D1421273449416%26f%3D2324230357%2C2339700074%26g%3D2231701336%22%5D; __utmc=160852194; _gali=my-nav; sid2=1f8b080000000000000033343030b7343632373570303434d0333431d63334b6d433367270f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d4a028bb2dd4b0233f44b028c733c8c9d4baa92bd420d0074f32a8a78000000',N'',N'A');
INSERT INTO Account VALUES(N'ZhangJunNing0904@yahoo.com.au',N'KeyBoard20150122',N'Jimmy',N'',N'machId=XpEqIK6saOO0KFUk9-VQQ9hMXMmaXsY6Z1zA3yY3etpHV2CGWUnL2GU3_R-XkJALM_5pJj07CSr68TIcNDG5iPwfa5bh-QIxML5TeA; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22223126666%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1421878323246r0.18369427129024218; optimizelyBuckets=%7B%7D; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1421878323246r0.18369427129024218%26t%3D1421878367492%26f%3D2324230357%26g%3D2231701336%22%5D; __utma=160852194.894961725.1421878325.1421878325.1421878325.1; __utmb=160852194.3.10.1421878325; __utmc=160852194; __utmz=160852194.1421878325.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt_siteTracker=1; _ga=GA1.3.894961725.1421878325; _gat=1; __gads=ID=bec0e36003aa3a75:T=1421878328:S=ALNI_Mbq3QevRIS54PdSbqJvnLsW4fkDJA; _gali=my-nav; sid2=1f8b0800000000000000333430b030303336363377303434d0333431d63334b6d433367270f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d3c93a2720b93c312234cb21d8bfc52cbd3fd8c33f3f50024e26a7078000000; ki_t=1421878336721%3B1421878336721%3B1421878353353%3B1%3B2; ki_r=',N'',N'A');
INSERT INTO Account VALUES(N'BarryQin19841121@yahoo.com.au',N'SellKeyboard20150123',N'Barry',N'',N'ki_t=1421878336721%3B1421963209777%3B1421964299249%3B2%3B29; ki_r=; machId=XpEqIK6saOO0KFUk9-VQQ9hMXMmaXsY6Z1zA3yY3etpHV2CGWUnL2GU3_R-XkJALM_5pJj07CSr68TIcNDG5iPwfa5bh-QIxML5TeA; up=%7B%22ln%22%3A%22223126666%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18552%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1421878323246r0.18369427129024218; optimizelyBuckets=%7B%7D; __utma=160852194.894961725.1421878325.1421906427.1421963200.8; __utmz=160852194.1421878325.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.894961725.1421878325; __gads=ID=bec0e36003aa3a75:T=1421878328:S=ALNI_Mbq3QevRIS54PdSbqJvnLsW4fkDJA; __utmb=160852194.33.9.1421964254784; crtg_rta=; __utmt_siteTracker=1; _gat=1; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1421878323246r0.18369427129024218%26t%3D1421964411880%26f%3D2324230357%26g%3D2231701336%22%5D; _gali=my-nav; wl=%7B%22l%22%3A%22%22%7D; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b0800000000000000333430b030b030b430b774303434d0333431d63334b6d433367270f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d4c4b730a3382cb130b2b7d9d3c73ca032c4b5d92cc0d0046417d1f78000000',N'0401727019',N'A');
INSERT INTO Account VALUES(N'LegoHi1900@hotmail.com',N'Everyday20150127',N'Jim',N'',N'machId=XpEqIK6saOO0KFUk9-VQQ9hMXMmaXsY6Z1zA3yY3etpHV2CGWUnL2GU3_R-XkJALM_5pJj07CSr68TIcNDG5iPwfa5bh-QIxML5TeA; up=%7B%22ln%22%3A%22223126666%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18552%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1421878323246r0.18369427129024218; optimizelyBuckets=%7B%7D; __utma=160852194.894961725.1421878325.1422336334.1422350174.26; __utmz=160852194.1421878325.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.894961725.1421878325; __gads=ID=bec0e36003aa3a75:T=1421878328:S=ALNI_Mbq3QevRIS54PdSbqJvnLsW4fkDJA; wl=%7B%22l%22%3A%22%22%7D; __utmb=160852194.3.10.1422350174; __utmt_siteTracker=1; _gat=1; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; _gali=my-nav; sid2=1f8b0800000000000000333430b030343537353672303434d0333437d533b3d033367170f0cdafcaccc949d437d53350d048cecf2d482cc94cca49b556f00df67455b0d433b05608cfcc4bc92f2f56f00b5130d33304f2fdc3cd4cac15428a325352f34a403a351d82f472fc7c023cbd1dfdcd22abb22d03cd2272520bf4004c5017fe77000000; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1421878323246r0.18369427129024218%26t%3D1422350224482%26f%3D2324230357%26g%3D2231701336%22%5D',N'',N'A');
INSERT INTO Account VALUES(N'ozplaza.living',N'',N'Fung',N'',N'AgAAAA**AQAAAA**aAAAAA**uhaEUw**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wNloCiC5OAqQudj6x9nY+seQ**7CoBAA**AAMAAA**cwbc57I3jaRKg9pEY9wrxBkmIAijpSOGYuBlT9NqFYqTkoE2d7gsy9+tZvdUNfjCV2mhEpG3Cd9JzlSK/EaNzdw4EENie37+E3m+cqVVOCl2ngujbZZ3giBn14u6pkyzqN6SkVQMhWUbSw3CnQm9i0GDs7R/TnsjSygNh//YJ+iwN3TMdgjra//9ccxPgMhePY1Q4iM60LIwr3/LyGdW6i2Ncf0WB7ubXmIXQBh5GV3kxzGCIlKhgQMxBsU1nxaGF3/fs7Qy+/GzYYlxhF0RhlD9bnQwRl4AV6/eaPfZmBDMWeMsRJPdR4L3GIqR3LcQYlzZtobkoSxUAgEt2VM0JqJ2jKOFZhOnnqtVccgWF6MDWNEBjMRYLgkHzdIAFu4+5clhfqq/zsDoJ64MBdlTqXar/hfYFkB3HhStQVtdDwqEq0p7G8ryM+ufhgIJny9gCEUuNqGqHJleVtmub4LpZ+00piSXbL4gVSncosWw8Je8hwPMJGlJxdOn5gUyPOc5UGpJRvGOZVoaXa7cup7rLrUTctSkoTL9uMYFaj3ocSU39uUC9RQjaFGF7Jl9CpsbU851yA97NDunpuEGzb+tytDZS8GLfWr4VBZjxjNk4DU1cOlf+B09KIKHizKIEq7+jau4Lx76+ZO77uAPUtoq3OSeL4ldUrD1Z42jm8THt9s+89NWe8e3QUbR2CldHbEgBUN5JsJxWpzT6KXoWEA16kbeUUCdU/TuNvVdSY9yFEcaR8LMYcZEGS3b2niCwMiL',N'',N'A');
INSERT INTO Account VALUES(N'crazy-victor',N'',N'Victor',N'',N'AgAAAA**AQAAAA**aAAAAA**NjGdVA**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6wJmIWpDJmGpAWdj6x9nY+seQ**fAYBAA**AAMAAA**VyjlsYnQvWCX6Ac/ZgVwc1ecmqHuLeR10qtnJPcH9NHLEVOdHbzYpdvjX9NjTDbTOA34KMivSCxK3PZauTwxI8NXWT7tKRcicpNV6UgECgUsVnlodKwCH1tNNV5BPPBKsg6vEUFstMeRbuv5A+j2RQBuYm2Ddc+EyaGPI7ScI4qJk57ED85x8q8WJCRUlydVhhF+sisguh1eEVSPnu5A5lSav7TtSI9CUanUfruobBWOzj+GsPd7YVYkbXQflvUFge/U/YpfqBM99lID7r9mbTsabZBT0OXeFAobWfGjXVysZk1RlHr7sh5jbeeZRRvXiGwG5+lJuYvIioOJ7IL0e4kySrMR3V6VR4TrFx/xll3D+IpghD/3HLLEq/pClYYnPnzlEkMqqPwnFdgcLyMXicdtDF+iyLkK/UumxPAQNVHTPqR+k78Z4hcpAudd74BLx5RsLleDLbypyWD76wraO60EAHIemuAjR5bnrjB1Vf0W5RyKzAbYQBG7B44ygUPqw575FPEnqtoRyw9ZhmOUIsleiRluLdUIc8cbEHzQimNxhfDnx05wJ5j/PK/KvIZZDo/81hTr7D+/cJTlyTGB6LM9CRgHB9ieY/L/3xk6pXkRvztGdBJjidkzNCzyzAi22BtkKMcFGUr/rae7e89VC7Fw4U9WrFnwJ1aHAtZ4ncqw+HtEAM1aurz2bYPvIJF9+0DSOuy0AhuwMg+LJjDoNdzRHjBiMGfW/HGt9N3VD7w0GfpW4EudB6E7taNnMY19',N'',N'A');
INSERT INTO Account VALUES(N'crazy-mall',N'',N'Jing',N'',N'AgAAAA**AQAAAA**aAAAAA**KGibVA**nY+sHZ2PrBmdj6wVnY+sEZ2PrA2dj6AFk4WjDpiBoA6dj6x9nY+seQ**fAYBAA**AAMAAA**FUq6vGZAH5ojYHRQoIO7+ma0TixoXM2RvTrWldG1OhXwbnqKAZ19wz/dbG/b3NV7upfFn/Q/ON06rdXXxugW23PkW97mS1Oht+XrLOjICHKq6tJ3/uo/vMfkQPodG39YAJocS4MqZ72it383OPwGAbEvt3U1Y2ymbgJnMO83qdS6THSBEVvj23mnmPhHvjURMKvlr+s3sSz3cr9U6ml5OmKzgVTsYj40m8mr9LbNQIOUUs8OVz+zrcvyENEum9XAl2t+cxVKGw0yX08QXjlxgEWj6EXhLyPJ/WC/d1arFR2QElYlI5Qfbsri7CJ4xybzENbCKY6zh/uwbx0YZ/PrDUHac2DsFb2EFMjmpYNyERs6IP3qLPFk37giJJ7CUq2SvAEjMav812OGGYvlBhMvnYOf7wpzgIHbksJJghEBE8hr4kl0+wWDraUT/MO8/CQrU/Mry3lTMMbVU0PZCOKk6CRtwmD1nAUEuedq7V4lCd8N8XdBs0o3YxM3aCrOZc12+67IfV4q0/8ZUUGFrk6hEC8jMniuqmeC/6ks3UCChjEaa7UPUlbHQ9OKDw6jUefvVImDwl0nFt31Xcv6o3u/mNhN0esMBn08esNTL1ZNWPmLm9LbtTkNajbr5STa7xy3rgAw+RNsTcVzp9vIlPxD/AS3BWSDn8pOwxRU+y7Z8bEXRbk3PQ3BBEXdecSnbbSVkkkFjMS+4xSdrVXwZkwk4KV4zu64yhUUDrmk7ksdTqFz9uD03v2eG3qMkbszTk8U',N'',N'A');
INSERT INTO Account VALUES(N'woolworths20150303@yahoo.com.au',N'EDR220Coupon',N'Barry',N'',N'machId=UhEJ1m4PQoExOBVRY8R6E9Udmz9FLXkvX_OU6Zi2dv1Nsf5lisw5ZD6weNV4p7FwVVQrc3LmDo6eRPNp_Wrzvop26YmZdgcEPCpP; up=%7B%22ln%22%3A%22410345678%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1425348438371r0.11008294244977545; __utma=160852194.699440131.1425348440.1425348440.1425348440.1; __utmb=160852194.15.10.1425348440; __utmz=160852194.1425348440.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt_siteTracker=1; _ga=GA1.3.699440131.1425348440; __gads=ID=89c3d833a9cb1e2c:T=1425348439:S=ALNI_MbP9q_pV_5UyoLyNfWRIQdPkBIpeg; _gat=1; bs=%7B%22st%22%3A%7B%7D%7D; optimizelyBuckets=%7B%7D; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1425348438371r0.11008294244977545%26wxhr%3Dtrue%26t%3D1425350914973%26f%3D2502310383%2C2519860106%26g%3D2231701336%22%5D; __utmc=160852194; _gali=my-nav; sid2=1f8b080000000000000005c13b0e02211000d0ab4ca9cdec0cf25169b0519bd586045bb3904896405cfc249edef798686bc48ef4c6b12064699059a250e4dcd87eb994fba0906015728deddbe1e241235b08d7a0a505bfe498ea6b30481696cf9e19690d25cf094e699a9b13e946f5a08e4ff28f9efa3b8e389df90f59a058c377000000; ki_t=1425350759287%3B1425350759287%3B1425350837944%3B1%3B3; ki_r=',N'0401727019',N'A');
INSERT INTO Account VALUES(N'DonotBlockBrowser@yahoo.com.au',N'Whyyoudothat20150306',N'Anonymous',N'',N'machId=3hbzQa65Lqty1JUoZdIqTgN3qJb6kr33w96X8_vvireE4lhK3hL8Pom03M3yLLXmtaWA5RUzaoDqi1OKcJuwZYg6HqNYYM4aarczFQ; optimizelyEndUserId=oeu1425346974378r0.9542106199078262; __gads=ID=50d74657c8919317:T=1425346974:S=ALNI_MbVweTVLq4PnjNLaYxjdklE5lcVUQ; wl=%7B%22l%22%3A%22%22%7D; __uvt=; uvts=2llfszORm7Pt8kIU; ki_u=04ce89aa-a45e-7a43-0802-1e7f; bs=%7B%22st%22%3A%7B%7D%7D; svid=270602735730121500; up=%7B%22ln%22%3A%22208201836%22%2C%22ls%22%3A%22l%3D3008844%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D3008844%26k%3D1072473197%26c%3D18643%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D3001317%26k%3Dorange%2520removal%26c%3D9303%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D3001610%26k%3D1072308174%26c%3D18442%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D3008844%26k%3D1072473197%26c%3D18643%26r%3D0%26sv%3DLIST%26sf%3Ddate%7Cl%3D3008844%26k%3D1072660598%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22rva%22%3A%22%22%7D; __utmt_siteTracker=1; _gat=1; sid2=1f8b08000000000000002dcbbb0ac2301400d05fb96305b9cd3b8a4bea03855a152c668e9a626c34a55504bfdec5b31f4ac8446b39e5dc5046900a8d940a64921853a56f88d1e5120964363cafe933c0ae06857406766f951841d175d15b7f2ec32b975c235790959bbada8e2186d6c3da5fda3482c5ad4f0f9f0b8a0419d30cb582a36b5c1ffecb1ce6fd8a169da8ea76c94f77df0cdabdc90f07228bcf9f000000; optimizelySegments=%7B%222228232520%22%3A%22gc%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyBuckets=%7B%222519860106%22%3A%222500580267%22%7D; _ga=GA1.3.95856023.1425346975; __utma=160852194.95856023.1425346975.1425614802.1425618699.11; __utmb=160852194.3.10.1425618699; __utmc=160852194; __utmz=160852194.1425346975.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); crtg_rta=; ki_t=1425346976585%3B1425610307899%3B1425618721887%3B4%3B173; ki_r=; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1425346974378r0.9542106199078262%26wxhr%3Dtrue%26t%3D1425618725715%26f%3D2502310383%2C2519860106%26g%3D2231701336%22%5D; _gali=my-nav',N'',N'A');
INSERT INTO Account VALUES(N'NewDropshipDealSplash@yahoo.com.au',N'Gumtree20150311',N'Jim',N'Chrome;James Phone Number',N'machId=3hbzQa65Lqty1JUoZdIqTgN3qJb6kr33w96X8_vvireE4lhK3hL8Pom03M3yLLXmtaWA5RUzaoDqi1OKcJuwZYg6HqNYYM4aarczFQ; optimizelyEndUserId=oeu1425346974378r0.9542106199078262; __gads=ID=50d74657c8919317:T=1425346974:S=ALNI_MbVweTVLq4PnjNLaYxjdklE5lcVUQ; wl=%7B%22l%22%3A%22%22%7D; __uvt=; uvts=2llfszORm7Pt8kIU; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22676071172%22%7D; __utmt_siteTracker=1; _gat=1; sid2=1f8b08000000000000002dcb410b82301400e0bff28e0af1b6b7a933ba181515a61d1276d65c389ccd3448faf55dfaee1f719ea631978a32c1250a5a63249024cfb2c27fad73358b9143a0edb3f59f19ca0a12a40de8ab4ea210b6e3e88c364d6edf2c960a6502417eaa8acb0a9ced0d1ccdbdf721ecbac90f8645841c8550025502b7fa514ff6bfb2a9dc4faf86ce03e903b1a5a4b95d3afa01e89b47339e000000; optimizelySegments=%7B%222228232520%22%3A%22gc%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyBuckets=%7B%7D; _ga=GA1.3.1234086533.1426048132; crtg_rta=criteo160600%3D1%3Bcriteo300600%3D1%3Bcriteo160600sub%3D1%3Bcriteo300250%3D1%3Bcriteo72890bsub%3D1%3Bcriteo32050sub%3D1%3Bcriteo300250m%3D1%3B; __utma=160852194.1234086533.1426048132.1426048132.1426048132.1; __utmb=160852194.5.10.1426048132; __utmc=160852194; __utmz=160852194.1426048132.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); ki_t=1426048135392%3B1426048135392%3B1426048580011%3B1%3B5; ki_r=; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1425346974378r0.9542106199078262%26wxhr%3Dtrue%26t%3D1426048591668%26f%3D2502310383%2C2519860106%26g%3D2231701336%22%5D; _gali=my-nav',N'',N'A');
INSERT INTO Account VALUES(N'MuffinLamGoodGirl@yahoo.com.au',N'GumtreeAwesone20150409',N'Jim',N'IESelfComputer;JamesPhoneNumber',N'ki_t=1428304566730%3B1428541783306%3B1428579609709%3B4%3B38; ki_r=; __utmc=160852194; bs=%7B%22st%22%3A%7B%7D%7D; machId=G0CwAIg8TYCZ9QiqRXhwMImw4BjwN8mECGHn4XeEG-TnHoh2p9jk90ub61aIBs2q2hCiR25IG0q6FLXxcqiyo1Btzt4Ienf3CJw; up=%7B%22ln%22%3A%22750968369%22%2C%22rva%22%3A%22%22%2C%22ls%22%3A%22l%3D0%26k%3D1075701881%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22sps%22%3A%2225%22%2C%22lsh%22%3A%22l%3D0%26k%3D1075701881%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1426588664889r0.17271047694665215; __utma=160852194.1592752467.1426588666.1428572409.1428579057.64; __utmz=160852194.1426588666.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1592752467.1426588666; __gads=ID=d44ddafa1ceaf5c8:T=1426588667:S=ALNI_MY6YJsJzJ5Pr3q5HmTHg3YsMEUw1Q; optimizelyBuckets=%7B%222765991275%22%3A%222782920578%22%2C%222781650267%22%3A%222759350517%22%7D; crtg_rta=; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1426588664889r0.17271047694665215%26wxhr%3Dtrue%26t%3D1428580109338%26f%3D2765991275%2C2781650267%26g%3D2231701336%22%5D; _gali=my-nav; _gat=1; __utmb=160852194.19.9.1428579578756; sid2=1f8b08000000000000000dc3dd0ac2201400e057399775a3e738dd326f6c040b467fb0905d46f3429409361af4f4f5c147885a545acbca0a814c4864b4fb578db5e7fc0d293db962081b17e629af6fb80c503332e0aeae96068612263f2fbc6168a07cf6440cb79042f4d0f957cc96d4a3bd8fb77ee978bf1e6239b5421ee907c1634cf877000000; svid=172902781945866923',N'',N'A');
INSERT INTO Account VALUES(N'StupidKylieHaskett@yahoo.com.au',N'MassageTable20150410',N'Jim',N'IESelfComputer;JamesPhoneNumber',N'machId=3hbzQa65Lqty1JUoZdIqTgN3qJb6kr33w96X8_vvireE4lhK3hL8Pom03M3yLLXmtaWA5RUzaoDqi1OKcJuwZYg6HqNYYM4aarczFQ; optimizelyEndUserId=oeu1425346974378r0.9542106199078262; __gads=ID=50d74657c8919317:T=1425346974:S=ALNI_MbVweTVLq4PnjNLaYxjdklE5lcVUQ; wl=%7B%22l%22%3A%22%22%7D; up=%7B%22ln%22%3A%22988326751%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; svid=172902786074150410; bs=%7B%22st%22%3A%7B%7D%7D; __utmt_siteTracker=1; _gat=1; optimizelySegments=%7B%222228232520%22%3A%22opera%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyBuckets=%7B%222765991275%22%3A%222782920578%22%2C%222781650267%22%3A%222751180756%22%7D; __utma=160852194.413027459.1428643560.1428643564.1428643564.1; __utmb=160852194.31.9.1428644707462; __utmc=160852194; __utmz=160852194.1428643564.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); crtg_rta=; optimizelyPendingLogEvents=%5B%5D; _ga=GA1.3.413027459.1428643560; ki_t=1428643570992%3B1428643570992%3B1428645933005%3B1%3B20; ki_r=; sid2=1f8b08000000000000000dc7390e83301000c0af6c499af57a316077ce03382410494b142b7183918d387e0fc51423890cabaae4c23213b22294fa5654d6b68b8b9330a809b2979fbf614fd00c50223da08b2ead41304ac65c6b185d4c3ecce2ae54d6b89336fc4c47df3ceb7fc7fe77bc37bc00bbbdee856c000000',N'',N'A');
INSERT INTO Account VALUES(N'OnlyDropship20150424@yahoo.com.au',N'LovelyMuffinDog1105',N'Jim',N'IESelfComputer;JamesPhoneNumber',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=UxW4tOY0Yyp13Po5bfUQergqQLz4rb6bh1VTP9eHmOXZ4xUVWWh1mNiuqmkm9E8Abv9rybRcArzAuKQBrD0cZEEw1SbEpaJcewNk; up=%7B%22ln%22%3A%22100539440%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1429852865285r0.0010896374853553436; optimizelyBuckets=%7B%222765991275%22%3A%222789150071%22%7D; __gads=ID=f4320600b60f2108:T=1429852867:S=ALNI_MYwm_FOH1q2naEIQB_Sij5lnonivg; __utma=160852194.1076521745.1429852867.1429852867.1429860804.2; __utmz=160852194.1429852867.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1076521745.1429852867; sid2=1f8b08000000000000000dc3b10ac2301000d05fb95197eb5d48d3d62c810aa2a28204a3a3b61962620355acf8f5fae031512305c95a1921088524e4fabfac8cd9e56f48e95a9448307361e8f3f484bd0585acc11d9c921aec187a3fbc8a0a49c3f85e3023cd2185e861e5bb98cde6b39dee97f6715ac65bb7f6edd19e43433fd329a14077000000; svid=172902781945866923; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1429852865285r0.0010896374853553436%26wxhr%3Dtrue%26t%3D1429871853775%26f%3D2765991275%26g%3D2231701336%22%5D; _gali=welcome-username; ki_t=1429852874881%3B1429852874881%3B1429860806567%3B1%3B10; ki_r=',N'',N'A');
INSERT INTO Account VALUES(N'BinXu20150425@yahoo.com.au',N'EarnMoney1217',N'Jim',N'IESelfComputer;JamesPhoneNumber',N'ki_t=1429911850774%3B1429911850774%3B1429911985966%3B1%3B10; ki_r=; machId=uo8KR-YuDoX60LpK2jtFvNLfdaPzdv1MQ-pMIEA7O9cx_gXNx4mrQRml6D6EfJDbPVmzNcCR0A1H9TW829hm6LyrjSK1AeCUjN0; up=%7B%22ln%22%3A%22588563194%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22search%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1429911841005r0.8203974013640419; optimizelyBuckets=%7B%222765991275%22%3A%222778450831%22%7D; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1429911841005r0.8203974013640419%26wxhr%3Dtrue%26t%3D1429912044385%26f%3D2765991275%26g%3D2231701336%22%5D; _ga=GA1.3.1393629010.1429911841; _gat=1; __gads=ID=2945a0713517a294:T=1429911844:S=ALNI_Mb3z_e2rqRHRcjzrojFKYLhgBOPvA; __utma=160852194.1393629010.1429911841.1429911842.1429911842.1; __utmb=160852194.14.9.1429911955119; __utmz=160852194.1429911842.1.1.utmcsr=bing|utmccn=(organic)|utmcmd=organic|utmctr=gumtree%20australia; __utmt_siteTracker=1; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; sid2=1f8b08000000000000000dc3b10ac2301000d05fb95197cb5d48da68966c22343a18888ed266080d4d4945c1afd7078f890e4a6a63b49392502a4236ffba77ced76f2ee5293412ec625ea6fad9e012a043b610afb1531642cb535a5ea247b2d0de4766a43d943c2738a571ae6e53a1b0f78ff5dcee6110c36df523f30fb1d6af5c77000000; _gali=my-nav; svid=172902781945866923',N'',N'A');
INSERT INTO Account VALUES(N'BiYuJiang20150426@yahoo.com.au',N'MyFirstLove',N'Jim',N'IESelfComputer;JamesPhoneNumber',N'ki_t=1430088872421%3B1430088872421%3B1430089005037%3B1%3B5; ki_r=; machId=Nx6S186mV6U4XyBbnnE4xrOfeLB83C8prHrID1o0mAEhJ9-1-qNMKBzEPgMTrO6eZaYN5WV7AJLYON5ZHVuREFGjMgBhRp3nwis; up=%7B%22ln%22%3A%22222394744%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1430088856529r0.022743119063455996; optimizelyBuckets=%7B%7D; __gads=ID=ddc1db4b5ef76317:T=1430088856:S=ALNI_MZHOm2btuiNhVtGSzUdASgihk3mXA; _ga=GA1.3.2146347373.1430088857; _gat=1; __utma=160852194.2146347373.1430088857.1430088858.1430088858.1; __utmb=160852194.8.8.1430088860975; __utmz=160852194.1430088858.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt_siteTracker=1; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; optimizelyPendingLogEvents=%5B%22n%3Dengagement%26u%3Doeu1430088856529r0.022743119063455996%26wxhr%3Dtrue%26t%3D1430089016292%26f%3D2765991275%26g%3D2231701336%22%5D; _gali=my-nav; sid2=1f8b08000000000000000dc3410bc2201400e0bff28e7571efa99b2e2fde0641052119bb8d1492c9241b0dfaf5f5c14788bd945a086d3947c62532d2ffadb2f654be29e7a96919c2cea72594ed0d67071d2303fee23b69c0d514e2b2368aa181fa391031dc434e7384213ee662c5f474ab1bc7fb751ae256c3eba86e3dfd00a8e398f577000000',N'',N'A');
INSERT INTO Account VALUES(N'ZhouXiaoYou20150430@Yahoo.com.au',N'MySecondLove',N'Jim',N'IESelfComputer;JamesPhoneNumber',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=Uo8SwJa8HQRtr0XG6IHLVDJUNGdkS0p14D21CrLyWsONA6TkgRhSOw551VwPC7bN9SJBmzzo4urR5VcpE7ZMntlreTd8uvc2N9k; up=%7B%22ln%22%3A%2269725118%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1430348121469r0.561818698900139; optimizelyBuckets=%7B%7D; _ga=GA1.3.1115989551.1430348122; _gat=1; __gads=ID=cb70934bdc7d76c6:T=1430348125:S=ALNI_MZL880I7TQEUJ8WetStpyqn2SoIHw; __utma=160852194.1115989551.1430348122.1430348127.1430348127.1; __utmb=160852194.8.10.1430348127; __utmz=160852194.1430348127.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __utmt_siteTracker=1; _gali=my-nav; sid2=1f8b08000000000000000dc34b0ac2301000d0abcc5237d3999826d56c02828aa0415ae8ba9f2c424203f18ba7d7078f89b6b251c4da0a4128242137ffb5b6f692bf21a5a1aa9160d58765ceef3b5c3b50c8067ad72b69a02b61f6cba3d24806ca6bc78cb48614a287a39f62b6786be5733c7c36ce89328ced794fa7c83f7f50e99d77000000; ki_t=1430348127575%3B1430348127575%3B1430349118826%3B1%3B8; ki_r=',N'',N'A');
INSERT INTO Account VALUES(N'LiangZhangTing20150501@yahoo.com.au',N'MyFourthLove',N'Jim',N'IESelfComputer;JamesPhoneNumber',N'ki_t=1430355549105%3B1430435139783%3B1430436304861%3B2%3B68; ki_r=; machId=lxlxoqomIgKoCxt2kCRL9bsGr_OPtIFksJlG5M73-3NOi2bb3mxs5-b8WPAgdmcZ-JpgRQhhSMc7H6JQ0l_vMPoHSdIRKXDrO40_tQ; up=%7B%22ln%22%3A%22198017037%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1430355543137r0.4864442881783772; optimizelyBuckets=%7B%7D; __utma=160852194.1322245880.1430355544.1430358380.1430435134.4; __utmz=160852194.1430355544.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1322245880.1430355544; __gads=ID=0174e2e66d40790c:T=1430355543:S=ALNI_MZk9JHjwbUpfKU6923008x49NMQ_w; svid=111702799868234653; crtg_rta=; __utmb=160852194.24.9.1430436333100; _gat=1; __utmt_siteTracker=1; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; optimizelyPendingLogEvents=%5B%5D; _gali=my-nav; sid2=1f8b08000000000000000dc3bd0ac2301000e057b95197eb5d4893c62c01075db44b21e22626424c48a0f507faf4fac1c744461aadd4e0842014929087ff5e3b776a6b2ae5d6f548b0f1a986f65de03c8142b6e047afa485694e21d657a7912ccc9f1d33d2164aca110ef19e9bd3be5e8fe1ad73b83c239a653fae0f453fb681aa2977000000',N'',N'A');
INSERT INTO Account VALUES(N'JiangDuanYing20150501@yahoo.com.au',N'MyFifthLove',N'Jimmy',N'IESelfComputer;JamesPhoneNumber',N'ki_t=1430355549105%3B1430435139783%3B1430436304861%3B2%3B68; ki_r=; machId=lxlxoqomIgKoCxt2kCRL9bsGr_OPtIFksJlG5M73-3NOi2bb3mxs5-b8WPAgdmcZ-JpgRQhhSMc7H6JQ0l_vMPoHSdIRKXDrO40_tQ; up=%7B%22ln%22%3A%22198017037%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelySegments=%7B%222228232520%22%3A%22ie%22%2C%222242430639%22%3A%22none%22%2C%222247230845%22%3A%22direct%22%2C%222248430589%22%3A%22false%22%7D; optimizelyEndUserId=oeu1430355543137r0.4864442881783772; optimizelyBuckets=%7B%7D; __utma=160852194.1322245880.1430355544.1430358380.1430435134.4; __utmz=160852194.1430355544.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1322245880.1430355544; __gads=ID=0174e2e66d40790c:T=1430355543:S=ALNI_MZk9JHjwbUpfKU6923008x49NMQ_w; svid=111702799868234653; crtg_rta=; __utmb=160852194.24.9.1430436333100; _gat=1; __utmt_siteTracker=1; bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; optimizelyPendingLogEvents=%5B%5D; _gali=my-nav; sid2=1f8b08000000000000000dc3bd0ac2301000e057b95197eb5d4893c62c01075db44b21e22626424c48a0f507faf4fac1c744461aadd4e0842014929087ff5e3b776a6b2ae5d6f548b0f1a986f65de03c8142b6e047afa485694e21d657a7912ccc9f1d33d2164aca110ef19e9bd3be5e8fe1ad73b83c239a653fae0f453fb681aa2977000000',N'',N'A');
INSERT INTO Account VALUES(N'LeiXi2003@yahoo.com.au',N'MySixthLove20150501',N'Jimmy',N'SafariSelfComputer;JamesPhoneNumber',N'uvts=30N5NYFnNlGfV6vm; __uvt=; _gali=my-nav; __utma=160852194.128165491.1430458065.1430482921.1430487245.5; __utmb=160852194.1.10.1430487245; __utmc=160852194; __utmz=160852194.1430458065.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.128165491.1430458065; optimizelyBuckets=%7B%7D; optimizelySegments=%7B%222228232520%22%3A%22safari%22%2C%222248430589%22%3A%22false%22%2C%222247230845%22%3A%22direct%22%2C%222242430639%22%3A%22none%22%7D; up=%7B%22ln%22%3A%22801168770%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18558%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000003dcc410b82301880e1bff21d15e2735b6e165d160606e63c24ed6c356b38367181d0afcf5387f7f8bc94903d278472211923c8728274b7c60b299bf0b5cef519470289b6fe199608aa0381f400bad5224fe1384dce6873afed27e3db1c79810c92fadc35970d383b1aa8cc630c29dccc1c6df0eb8c6201d77ee867fb17d2abd7c9ab4189766158c6aad426bef107464029c19d000000; wl=%7B%22l%22%3A%22%22%7D; __gads=ID=9cec9dd972fd27d6:T=1430458064:S=ALNI_MZEzMPCfZciWS3weuI21157Evr92w; optimizelyEndUserId=oeu1430458062363r0.8629176039248705; bs=%7B%22st%22%3A%7B%7D%7D; machId=Wtmo0Zw0f6fCC5oY6GcN9UaDL-yGXLsggxrZGig8hXby_W5XROzM8b41hQ1jhqT5ysE0Lbc3jS_wbDcQiFNawahw5C-6OanTrew',N'',N'A');
INSERT INTO Account VALUES(N'ShufangDryClean20160203@yahoo.com.au',N'SuperTight',N'ShuFang',N'SafariSelfComputer;JamesPhoneNumber',N'',N'',N'A');
INSERT INTO Account VALUES(N'ALRemoval20160208@yahoo.com.au',N'NoAssignmentAd',N'Alec',N'IESelfComputer;0490484049;223.27.24.231',N'',N'',N'A');
INSERT INTO Account VALUES(N'XiaoLiuRemoval20160215@yahoo.com.au',N'EverydayRunning',N'Shawn',N'IESelfComputer;0468799585;111.67.21.208',N'',N'',N'A');
INSERT INTO Account VALUES(N'JessicaCleaning20160315@yahoo.com.au',N'PhoneInvestigate0314',N'Jessica',N'IESelfComputer;0468799585;111.67.21.208',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=5sHygVqidSnR1-4THKQUcXslvq6neULT8W-jwpBbE_WnFnyXzBjqx09SAzVFA8grXPeC_u25BlUO5XalgOCEl9GlrQNm9D7HwXZPyg; up=%7B%22ln%22%3A%22464224803%22%2C%22ls%22%3A%22l%3D3001578%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1458003802844r0.3500718907505654; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; _ga=GA1.3.1254535062.1458003808; __gads=ID=2e4350be541d7528:T=1458003807:S=ALNI_Mbf38ZW3Ta8AJBJYvyoOEnehTiuHA; __utma=160852194.1254535062.1458003808.1458014361.1458018417.4; __utmz=160852194.1458003809.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); crtg_rta=cto_puma_m_320120%3D1%3B; sid2=1f8b080000000000000005c1c10ac2300c00d05fc9512f5992eaaaf6d2c37028e81486dd555cc1babab22a0a7ebdef31b168d22b515644a16854842c6b6b0fe91762bc164b2498b930f6e9fb82630b252a03ae71e5c2409b43efc777a1910ce4cf8619690e310c1e6a7f1b92bd3c7767cef7ea5177a77d951ada4e93e63fd62df10f75000000; _gali=welcome-username; ki_t=1458003812027%3B1458003812027%3B1458018420735%3B1%3B16; ki_r=; sc=kUkBHuRF1v4zO1KxbIyd; JSESSIONID=81DD715293B241C5488F5D7C1CA7344D.1411538080',N'',N'A');
INSERT INTO Account VALUES(N'AlvinMaRemoval20160316@yahoo.com.au',N'EURGBPNeedToBeGood',N'Jonh',N'IESelfComputer;0433767522;223.27.31.7',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=JgAj94YDJ87ALw7VuZKvyGCJwC3B8lKAi1_fJvIaVbDOCU6A7iFdoV9MwMNFc78119cKVpOoLDoo5TAHRREMaH1TvkXHT-U4HY0; up=%7B%22ln%22%3A%22282588277%22%2C%22ls%22%3A%22l%3D3001716%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1458101492154r0.5311758367210201; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; _ga=GA1.3.647210687.1458101492; __gads=ID=0d0b61711eb02619:T=1458101493:S=ALNI_MbdM0rP-mzrnObSQVfpG9F9ICjJuA; __utma=160852194.647210687.1458101492.1458102124.1458173209.3; __utmz=160852194.1458101494.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b080000000000000005c14b0ac2301000d0abcc52379399c43460362948eb077513c85ada404363036df1777adf6362692469a39d940aa541c5689cbb965fcaf92134126c429afaf25ee0e6a1426521dc43b5b3e0e7d4c7691506c9c2fcda33236d21a731421bbbb1b8e3d09cbf833fa4b5a6cba73b79d1f093fff4759efc73000000; crtg_rta=cto_puma_m_320120%3D1%3B; __utmb=160852194.2.9.1458174832311; _gali=welcome-username; sc=i8W7xRmhiGRlcM1ToDwK; ki_t=1458101495523%3B1458173212410%3B1458173212410%3B2%3B12; ki_r=; JSESSIONID=DF3D9FF4D405B03F0120DE7BA6179EC5.1411538100; ki_s=150252%3A0.0.0.0.0',N'',N'A');
INSERT INTO Account VALUES(N'EmiTakei20160322@yahoo.com.au',N'TheyAreCouple',N'David',N'GoogleChrome;0490484049;223.27.31.82',N'machId=vsfb0kifD6LxJj-2F32lhBOzw5XnuYKoRjDAdLvdhlbjMVna-YWf8ZLVf909OffR-V05xvCsWbkDQKcOlGsOVKks2Z2ah86ec3DqurE; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22395188873%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1458614940793r0.04678579938746008; __gads=ID=f8b467466a1c1767:T=1458614939:S=ALNI_MY8D3kpk9_xZJRBhsfzByBOrvdpNA; sc=ZlRwN4AXCc7G3DW8eye6; sid2=1f8b08000000000000002dcd410b82301880e1bff21d15e2d36dba195dcca012350f89a3a3e5c4e1726281d1afcf43c7f7f0f0129f5021388d684c29432a90115c232eec571bd37821fae0483db67679c1a5028e6c07b2943c70613f4d464975cff4db0bd94a3938d9b92af20d183d2838a9c7605d38f4b37d2a2fd8a28f94af9748c0b5e99a59ff559c2ee978b41fdbd55a2541d9def2de24e407159e3a529c000000; __utmt_siteTracker=1; _gat=1; JSESSIONID=3E0E193603C0F7676C81A354B3A1BBC7.1411548100; tod=%7B%22tod_sp%22%3A%22%2Fp-post-ad2.html%22%7D; ad_auto_renew=%7B%22ad_auto_renew%22%3A%221107873832%22%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.1546016612.1458614942.1458614943.1458614943.1; __utmb=160852194.11.10.1458614943; __utmc=160852194; __utmz=160852194.1458614943.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1546016612.1458614942; crtg_rta=cto_puma_m_320120%3D1%3B; ki_t=1458614943938%3B1458614943938%3B1458615980971%3B1%3B11; ki_r=; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'223.27.31.82',N'255.255.252.0',N'223.27.28.1',N'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36');
INSERT INTO Account VALUES(N'TakeiEmi20160324@yahoo.com.au',N'WujingSaigo',N'Saigo',N'GoogleChrome;0490484049;223.27.31.82',N'machId=vsfb0kifD6LxJj-2F32lhBOzw5XnuYKoRjDAdLvdhlbjMVna-YWf8ZLVf909OffR-V05xvCsWbkDQKcOlGsOVKks2Z2ah86ec3DqurE; optimizelyEndUserId=oeu1458614940793r0.04678579938746008; __gads=ID=f8b467466a1c1767:T=1458614939:S=ALNI_MY8D3kpk9_xZJRBhsfzByBOrvdpNA; ki_s=150252%3A0.0.0.0.0; sid2=1f8b08000000000000002dcdd10a82301400d05fb98f0a31ddae4ea5976550915941e2e8516bda7035b3a2e8ebf3a10f381cea531625c8910bc690b0882025311322b75f6d4ce585c40747eadbd9be1fb02d80139c82dc491eb830eb7ba3a4aa33fdf4421c2907275b15f9660246770a96ead45917e697c15e951724c4278c8f4b1cc1a16aaa41ff9528d507d360fd2ae32cdd1f9bba6def0ba43fa5dafee49c000000; up=%7B%22ln%22%3A%22395188873%22%2C%22ls%22%3A%22l%3D3001713%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; bs=%7B%22st%22%3A%7B%7D%7D; sc=xkI6AsjJbOdiMQ4CWt7V; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.1304628131.1458782075.1459037364.1459207114.6; __utmb=160852194.2.10.1459207114; __utmc=160852194; __utmz=160852194.1458782079.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); crtg_rta=cto_puma_m_320120%3D1%3B; _ga=GA1.3.1304628131.1458782075; ki_t=1458782078426%3B1459207120496%3B1459207131404%3B4%3B56; ki_r=; optimizelyPendingLogEvents=%5B%5D; _gali=my-nav',N'',N'A',N'223.27.31.82',N'255.255.252.0',N'223.27.28.1',N'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.87 Safari/537.36');
INSERT INTO Account VALUES(N'GeneralUse20160401@yahoo.com.au',N'Aligadogosaimasu',N'Hana',N'GoogleChrome;111.67.23.217',N'machId=34kY4h62YWHdJsIkp9m0QsCsMLDiIR4hvww402_dahIu-elA_iUnQwi4t6XYSDbQ-of5KLnYp8hJPBcMHWhb2c9-t7vfYQ4qixw; up=%7B%22ln%22%3A%22273290599%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1459502332692r0.40823183632688553; __utmt_siteTracker=1; _gat=1; __gads=ID=00da315e580cbb9a:T=1459502333:S=ALNI_Mb3poSuYqwvf5tsY_Ae9moRoNnnqQ; sc=KQ0XMV1YmKq3RkxO69YM; sid2=1f8b08000000000000002dcddd0a82301800d057f92e1562dbb7e94cbab1120accca946697ab160de70f16443d7d5df40087830cf954c68c6382884446840bc2314a92bcff58e7340d09034fd9eedabf1eb0ad40123103b55332f0613e0cce2873ceec93862222428297adab7c3301671b032b73697a1f96f7b16f0d0d62c20897bf009141a96f7ab47f9674554d0ffbb428da777aac0bad166179625fe2fc68649e000000; JSESSIONID=CAC3780EE583356B07A5152E02B73F9B.1411548080; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.2064583380.1459502334.1459502334.1459502334.1; __utmb=160852194.12.10.1459502334; __utmc=160852194; __utmz=160852194.1459502334.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.2064583380.1459502334; crtg_rta=cto_puma_m_320120%3D1%3B; ki_t=1459502340287%3B1459502340287%3B1459502538026%3B1%3B12; ki_r=; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'111.67.23.217',N'255.255.252.0',N'111.67.23.254',N'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.110 Safari/537.36');
INSERT INTO Account VALUES(N'SzetoChiWah20160408@yahoo.com.au',N'Situzihua19961218',N'ChiWah',N'GoogleChrome;223.27.29.35',N'machId=8hKzM5Y5AEEq7tpCnIWJMNc9q1zlzkyd1dK4sBM0oqud7b6gghdDJgeByN-sIrdY0GkFkQqsNEgp3TygviH_cQxxQTYBBuHuE2Tu; bs=%7B%22st%22%3A%7B%7D%7D; up=%7B%22ln%22%3A%22396802022%22%2C%22ls%22%3A%22l%3D0%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1460110288705r0.8160800068777638; _gat=1; __gads=ID=4cd96268c1664b08:T=1460110289:S=ALNI_MbyGlCOZlgNJ8BvB6qGuG2m8n_Ftw; __utmt_siteTracker=1; sc=9ZYwrLKVYtvwHHgWiCD5; sid2=1f8b08000000000000002dcdcf0a82301c00e057f91d0d627f756374997428502b6830f0a6b570389b582af4f475e8013e3e4a28539c4bc234631c318998423cd3ba8a1f1f4283334420b1fe798feb0b4e0604e23bb0672bd20de4e3189c756de1df38e312710149713455b985e07b070777ebe306f6dd14078753850862e2b750cae0da3c9ac9ff995e4a2bcd1ceb919baece2fcb3aa8b9c55f668814999d000000; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.496956546.1460110289.1460110291.1460110291.1; __utmb=160852194.10.9.1460110380758; __utmc=160852194; __utmz=160852194.1460110291.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.496956546.1460110289; crtg_rta=cto_puma_m_320120%3D1%3B; ki_t=1460110292271%3B1460110292271%3B1460110834560%3B1%3B9; ki_r=; optimizelyPendingLogEvents=%5B%5D; _gali=my-nav',N'',N'A',N'223.27.29.35',N'255.255.254.0',N'223.27.28.1',N'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36');
INSERT INTO Account VALUES(N'Gamecube20160412@yahoo.com',N'ThatWasCool',N'Palmer',N'GoogleChrome;223.27.25.133',N'machId=Q1sK9aSuAIKyi5MU3jcHKu7LcIaL4w-9NCxV_MEFZ-Sd3YidJqiWDPfR1t3Me19GJDtkwzIK48hKLxSSj0dPOKl0qkRten1pJJE; optimizelyEndUserId=oeu1461042527089r0.6455694973922521; __gads=ID=c64c559ee4ef646e:T=1461042530:S=ALNI_MZg-jn-0gs6Ag7VU65cA1ONKWwAFA; sid2=1f8b08000000000000002dcdbb0e82301400d05fb92324e6d207141a971a0689880e92544794a20dd512d410f97a1dfc80934309653225440ac5184796224b9072ae54e567eb5c13254820d0f6d1fae909bb1a04f225e8bd167108ab6170469b73695f51c253e40282b2a8abed029ced0daccda5f721e4b7d1df4d144b24c8c4afa194c1a1e99ad1fe99ca3fd37b3ab9fe9875465e67df669bc2902ff044f8839e000000; ki_s=157611%3A0.0.0.0.0; up=%7B%22ln%22%3A%22869263287%22%2C%22ls%22%3A%22l%3D3003644%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%2C%22lbh%22%3A%22l%3D0%26c%3D18442%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; bs=%7B%22st%22%3A%7B%7D%7D; __utmt_siteTracker=1; _gat=1; sc=8XnKkFHn3MNYS3VXu0f9; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; __utma=160852194.507978570.1461042528.1462013230.1462180674.8; __utmb=160852194.4.10.1462180674; __utmc=160852194; __utmz=160852194.1461042529.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.507978570.1461042528; crtg_rta=cto_puma_m_320120%3D1%3B; ki_t=1461042534119%3B1462180675131%3B1462180738986%3B8%3B159; ki_r=; optimizelyPendingLogEvents=%5B%5D; _gali=my-nav',N'',N'A',N'223.27.25.133',N'255.255.252.0',N'223.27.25.254',N'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36');
INSERT INTO Account VALUES(N'kenzedellot914@yahoo.com',N'UpToYourChoice',N'MT',N'IESelfComputer;43.229.61.57;BinaryLane',N'ki_t=1460546748469%3B1460589989245%3B1460602242299%3B2%3B19; ki_r=; OX_plg=pm; ki_s=157611%3A0.0.0.0.0; sc=Hq6dJgDMYw3HFWBuC2pV; machId=ygBRJrYyb4JZPFS4mJKP7d8Wc0BU3vEOV0KCVq9z47rJse62Olnt4fxm05YdFIinpsT-Vuib-3Y7YTlYHUHkc_2UZiKnaVstWC8; up=%7B%22ln%22%3A%22696436982%22%2C%22ls%22%3A%22l%3D3003784%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1460546709080r0.6580222952643232; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __gads=ID=77b5b46da98f742d:T=1460546712:S=ALNI_MawPBFggxvtKhxgBzwcqFYZG9eINw; _ga=GA1.3.928192468.1460546712; __utma=160852194.928192468.1460546712.1460589964.1460602238.3; __utmz=160852194.1460546714.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b080000000000000005c14b0ac2301000d0abcc523793c9b7a9d96455515041ab59171b24363658ab82a7f73d4e5cd496481aaf240a51a3e1a82bef77e59772ee9846824548635fbe2fd8b760503a0887609483764a7d1c67562139983e2bce919690d310611daf43f1fc617533bfefb7937a1eedb6bf9c37d8b03f5f9535fa74000000; crtg_rta=cto_puma_m_320120%3D1%3B; bs=%7B%22st%22%3A%7B%7D%7D; _gat=1; __utmb=160852194.1.10.1460602238; __utmc=160852194; __utmt_siteTracker=1',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.61.57',N'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko');
INSERT INTO Account VALUES(N'Soya0419@yahoo.com',N'JapaneseRestaurant',N'Low',N'GoogleChrome;43.229.62.128;BinaryLane',N'ki_t=1460546748469%3B1460589989245%3B1460602242299%3B2%3B19; ki_r=; OX_plg=pm; ki_s=157611%3A0.0.0.0.0; sc=Hq6dJgDMYw3HFWBuC2pV; machId=ygBRJrYyb4JZPFS4mJKP7d8Wc0BU3vEOV0KCVq9z47rJse62Olnt4fxm05YdFIinpsT-Vuib-3Y7YTlYHUHkc_2UZiKnaVstWC8; up=%7B%22ln%22%3A%22696436982%22%2C%22ls%22%3A%22l%3D3003784%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1460546709080r0.6580222952643232; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __gads=ID=77b5b46da98f742d:T=1460546712:S=ALNI_MawPBFggxvtKhxgBzwcqFYZG9eINw; _ga=GA1.3.928192468.1460546712; __utma=160852194.928192468.1460546712.1460589964.1460602238.3; __utmz=160852194.1460546714.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b080000000000000005c14b0ac2301000d0abcc523793c9b7a9d96455515041ab59171b24363658ab82a7f73d4e5cd496481aaf240a51a3e1a82bef77e59772ee9846824548635fbe2fd8b760503a0887609483764a7d1c67562139983e2bce919690d310611daf43f1fc617533bfefb7937a1eedb6bf9c37d8b03f5f9535fa74000000; crtg_rta=cto_puma_m_320120%3D1%3B; bs=%7B%22st%22%3A%7B%7D%7D; _gat=1; __utmb=160852194.1.10.1460602238; __utmc=160852194; __utmt_siteTracker=1',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.62.159',N'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko');
INSERT INTO Account VALUES(N'JadeLover428@yahoo.com',N'CameraFoucus',N'Jade',N'GoogleChrome;223.27.29.208;Web24',N'ki_t=1460546748469%3B1460589989245%3B1460602242299%3B2%3B19; ki_r=; OX_plg=pm; ki_s=157611%3A0.0.0.0.0; sc=Hq6dJgDMYw3HFWBuC2pV; machId=ygBRJrYyb4JZPFS4mJKP7d8Wc0BU3vEOV0KCVq9z47rJse62Olnt4fxm05YdFIinpsT-Vuib-3Y7YTlYHUHkc_2UZiKnaVstWC8; up=%7B%22ln%22%3A%22696436982%22%2C%22ls%22%3A%22l%3D3003784%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1460546709080r0.6580222952643232; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __gads=ID=77b5b46da98f742d:T=1460546712:S=ALNI_MawPBFggxvtKhxgBzwcqFYZG9eINw; _ga=GA1.3.928192468.1460546712; __utma=160852194.928192468.1460546712.1460589964.1460602238.3; __utmz=160852194.1460546714.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b080000000000000005c14b0ac2301000d0abcc523793c9b7a9d96455515041ab59171b24363658ab82a7f73d4e5cd496481aaf240a51a3e1a82bef77e59772ee9846824548635fbe2fd8b760503a0887609483764a7d1c67562139983e2bce919690d310611daf43f1fc617533bfefb7937a1eedb6bf9c37d8b03f5f9535fa74000000; crtg_rta=cto_puma_m_320120%3D1%3B; bs=%7B%22st%22%3A%7B%7D%7D; _gat=1; __utmb=160852194.1.10.1460602238; __utmc=160852194; __utmt_siteTracker=1',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.70',N'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko');
INSERT INTO Account VALUES(N'StingyLady503@yahoo.com',N'NeedtoBeStrong',N'Vic',N'IESelfComputer;43.229.60.134;BinaryLane',N'bs=%7B%22st%22%3A%7B%7D%7D; __utmc=160852194; machId=Cs8KRbwGc6Y66RjAeRjPAb2NsUjBUdIUrEEeokjit5ct_sAagRfnpNPULU61DY8l8E669vju62fFL2U0iGzgB-JsXnzkUtbroiQvNQ; up=%7B%22ln%22%3A%22682501607%22%2C%22ls%22%3A%22l%3D3003788%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; _ga=GA1.3.752928458.1462254521; optimizelyEndUserId=oeu1462254520662r0.4800261927619539; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; __gads=ID=064d7c526d6885e5:T=1462254523:S=ALNI_MaQuDdnCHkZqEol9ja5w08Ev3sbug; __utma=160852194.752928458.1462254521.1462314838.1462321730.3; __utmb=160852194.2.10.1462321730; __utmz=160852194.1462254525.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); sid2=1f8b080000000000000005c1b10e83201000d05fb9b15dce3b419a9605d3c1c1521713d2d154060291548c267e7ddf6362c10d134b2305d6f51d15210b698ccd674869aa1a24b8b8b0ccf928f01e41a1d0e006a7a486710db35fb6ea86a461dd1fcc485748217ae8fc3766230efbb15de95d3bc55f79a6d7d0bb93ff9f55b56875000000; crtg_rta=cto_puma_m_320120%3D1%3B; _gat=1; __utmt_siteTracker=1; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username; ki_t=1462254535671%3B1462321731973%3B1462321939853%3B2%3B19; ki_r=; sc=lpvOdTKmA2WtAsYltnzW; JSESSIONID=CF949DF07DB964329E4B88121AEA90D1.141898080',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.60.134',N'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko');
INSERT INTO Account VALUES(N'HongsuYu604@yahoo.com',N'StillKawaii',N'Su',N'IESelfComputer;103.16.130.47;BinaryLane3',N'ki_t=1465004540459%3B1465955368945%3B1465955368945%3B6%3B103; ki_r=; sc=9erFyBByKT5QC0OeKUwy; machId=M4R5VBa6fMy_rJ5_oZxChZdY0bEH1fEO6JsI2B2Ngdr40j5rKgiBO97hmYRqu9WD5KltiddycC6wPJhp0PLfaojDOrsOqTqpEO0; up=%7B%22ln%22%3A%22101240110%22%2C%22ls%22%3A%22l%3D3004024%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; optimizelyEndUserId=oeu1465004530695r0.6584840131626419; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22ie%22%7D; optimizelyBuckets=%7B%7D; _ga=GA1.3.1400410534.1465004531; __utma=160852194.1400410534.1465004531.1465864829.1465955353.10; __utmb=160852194.2.9.1465955359282; __utmz=160852194.1465004533.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); __gads=ID=e264a4a29215d82f:T=1465000933:S=ALNI_MZXLNf2K5XgRDQo4FnGdjEQS5oRpA; sid2=1f8b080000000000000005c1b10e82301000d05fb95197eb9dad6db04b078518032c249d453ad4369400d1c4aff73d26968a4da58d6392c81a59122ae35c5b7e31e7a73823c1c1c7792adf0dba01344a0bbef75a5918d63885791706c9c2fab930231d21c714a009af541cd77b372e6d737d54e57e4afc1e6f752ffee3aa1ac575000000; crtg_rta=cto_puma_m_320120%3D1%3B; _gat=1; __utmt_siteTracker=1; _gali=welcome-username; bs=%7B%22st%22%3A%7B%7D%7D; optimizelyPendingLogEvents=%5B%5D; __utmc=160852194',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko');
INSERT INTO Account VALUES(N'TellyZhang605@yahoo.com',N'NoChanceAlreadyMarried',N'Telly',N'GoogleChrome;103.16.131.54;BinaryLane3',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'CathayRipOff616@yahoo.com',N'Lostmy50Dollars',N'KO',N'IESelfComputer;103.230.156.35;BinaryLane4',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'MyTarget3200617@yahoo.com',N'YiQieShunLi',N'Target',N'GoogleChrome;103.230.157.31;BinaryLane4',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'CannotUnderstand628@yahoo.com',N'WhyOthersNoAffect',N'CU',N'GoogleChrome;43.229.60.134;BinaryLane2',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'MaiBaiFen628@yahoo.com',N'QiShiSellMilk',N'MBF',N'GoogleChrome;223.27.25.133;Web24vmh19010',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'ColdSunnyMel75@yahoo.com',N'DoYouStillReturn',N'GS',N'IESelfComputer;103.16.129.196;BinaryLane5',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'Kirishima707@yahoo.com',N'HopeItsGood',N'JP',N'GoogleChrome;103.16.129.40;BinaryLane5',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'XiaoLiuDaShengYi720@yahoo.com',N'XiWangNengCheng',N'NL',N'GoogleChrome;103.230.156.3;BinaryLane7',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'DoNotWantToBuy721@yahoo.com',N'Fake95Off',N'WF',N'IESelfComputer;103.230.158.102;BinaryLane2',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'MalaysiaGirl816@yahoo.com',N'HowCanIGetNumber',N'MG',N'Safari;103.230.159.64;BinaryLane2',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
--INSERT INTO Account VALUES(N'BedsAndFurniture824@yahoo.com',N'NotAGoodGirlBeAware',N'BAF',N'Safari;103.16.128.56;BinaryLane7',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'LoveUSu826@yahoo.com',N'ShuangYuZuo',N'SU',N'IESelfComputer;103.16.128.83;BinaryLane8',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'LinPerthMow901@yahoo.com',N'PostponeSoLong',N'LPM',N'GoogleChrome;103.16.130.77;BinaryLane8',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'MelNewSer923@yahoo.com',N'AddRamFaster',N'NS',N'IESelfComputer;103.236.162.31;BinaryLane9',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'DSIPCustom924@yahoo.com',N'DoNotHoldInCustom',N'DSIP',N'GoogleChrome;103.236.163.8;BinaryLane9',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'LikeOrNotWhatever1021@yahoo.com',N'ShuangYu229',N'LBY',N'Safari;103.16.128.56;BinaryLane7',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'CheapFilght1021@yahoo.com',N'GuoTaiGoodDeal',N'Gloria',N'IESelfComputer;103.236.162.50;BinaryLane10',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'SultanaCranberry1021@yahoo.com',N'IsItOrganic',N'Sultana',N'GoogleChrome;103.236.163.19;BinaryLane10',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'MostDeliciousNoodle1121@yahoo.com',N'LongTimeNoSee',N'LaksaKing',N'IESelfComputer;103.236.162.93;BinaryLane11',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'ClaytonSwimmingPool1121@yahoo.com',N'AccessNoFee',N'CSP',N'GoogleChrome;103.236.163.16;BinaryLane11',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'MarjorieWei170104@yahoo.com',N'ThePerfectFace',N'MW',N'IESelfComputer;103.230.158.102;CrazyMall;BinaryLine2',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'IrisGuo17104@yahoo.com',N'DonotAcceptMe',N'IG',N'GoogleChrome;223.27.29.35;vmh19122',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'MuHouPlayer1714@yahoo.com',N'GiveMeBack75',N'WJ',N'IESelfComputer;223.27.24.231;vmh19010',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'WantToBeWithPaMa17402@yahoo.com',N'NeedLoseWeight',N'GD',N'Opera;223.27.31.82;vmh18983',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'YuiWuMa0421@yahoo.com',N'BuBingWanSui',N'Yui',N'IESelfComputer;103.236.163.54;BinaryLane10',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'HuanLeSong516@yahoo.com',N'PaoNiuMiJi',N'ROC',N'IESelfComputer;112.213.32.114;BinaryLane',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'NewFisY71027010@yahoo.com',N'OzPlaza15Off',N'ROC',N'Safari;103.236.162.60;BinaryLane9;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'HouseSoHigh71027030@yahoo.com',N'PawPatrolDogs',N'ROC',N'FireFox;103.230.158.102;BinaryLane2;FixAdID;EmailPWD:PawPatrolDogs;GumtreePWD:PawPatrolDogs7030',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'NiuNiu71027080@yandex.com',N'GongShiFuQi17',N'Ralph',N'Safari;103.16.128.83;BinaryLane8;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'SydneyBASJun71020160@yandex.com',N'NikiXi2017',N'Ralph',N'Chrome;103.236.162.31;BinaryLane9;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'DoNotKnowGift71020170@yahoo.com',N'HopeCanDoLonger1007',N'Ralph',N'Safari;103.236.163.95;BinaryLane11;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'DoubleCriteria71020101@yandex.com',N'WhySoBianTai1010',N'Ralph',N'Safari;111.67.21.208;vmh19029;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'ReallyUseHuman71020132@yandex.com',N'KingsGroveDup1023',N'Ralph',N'Safari;223.27.31.7;vmh19126;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'OZCMReturn71022150@yandex.com',N'NeverGiveUp1205',N'Ralph',N'IESelfComputer;103.230.158.102;BinaryLane2;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'BeiShanCanLe126@mail.com',N'QiuFangGuo0126',N'Ralph',N'FireFox;110.232.112.4;BinaryLane;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'Hope600Grant0208@mail.com',N'MustGrant-0208',N'Ralph',N'IESelfComputer;111.67.23.217;vmh19029;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'GuDingJianCha209@mail.com',N'NiMaBi-209',N'Ralph',N'Safari;103.16.129.196;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'WhySoStubbon214@fastmail.com',N'QiuFangGuo-0214',N'Ralph',N'Safari;223.27.31.7;vmh19126;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'HaoShouQi218@mail.com',N'BanZeZhiShu-0218',N'Ralph',N'Chrome;110.232.112.4;BinaryLane;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'DiaoNiGanShu221@mail.com',N'TianSuanDel-2102',N'Ralph',N'FireFox;103.230.156.113;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'XunXinChuLu18221@mail.com',N'ZheBuXing-212',N'Ralph',N'Safari;103.230.156.114;BinaryLane4;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'BuTongShuiYin2062@mail.com',N'KanNiShiBie-26',N'Ralph',N'Chrome;223.27.31.9;vmh19126;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');
INSERT INTO Account VALUES(N'bellamyilove3091@mail.com',N'KongNiChiWa-319',N'Ralph',N'Safari;103.230.156.113;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Bella, Last Name: My, Gender: Female, DOB 1993-4-7, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'WoKanNiShanMar29@mail.com',N'JianDaoJia-329',N'Ralph',N'IESelfComputer;103.230.156.78;BinaryLane4;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Ni, Last Name: Zai, Gender: Male, DOB 1958-5-7, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'chirstinali47@fastmail.com',N'SuddenNoInterest-47',N'Ralph',N'IESelfComputer;103.230.156.113;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--Name: LingLingLi, Tel: +61422325094
INSERT INTO Account VALUES(N'WeiNanMarjorie105@mail.com',N'ShiJieZhenXiao-510',N'Ralph',N'IESelfComputer;103.230.156.102;BinaryLane7;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Nan, Last Name: Ge, Gender: Female, DOB 1993-03-10, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'DouZhengDaoDi18511@mail.com',N'ZheJianGe-115',N'Ralph',N'FireFox;103.230.156.146;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Dou, Last Name: Zheng, Gender: Female, DOB 1996-09-11, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'ShenSiZhe18518@mail.com',N'Palace-185',N'Ralph',N'FireFox;45.124.53.59;BinaryLane11;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: ShenSi, Last Name: Zhe, Gender: Male, DOB 1990-08-09, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'ZheCiPuJie5002@mail.com',N'BeiFeiIPMa-2018',N'Ralph',N'FireFox;45.124.53.97;BinaryLane9;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Pu, Last Name: Jie, Gender: Male, DOB 1984-08-04, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'KaWaiiGhostBB18520@mail.com',N'BHNorthPpt-520',N'Ralph',N'FireFox;103.230.156.171;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Ghost, Last Name: BB, Gender: Male, DOB 1989-09-17, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'GoodAgentWu20@mail.com',N'GiveMeDiJia20-05',N'Ralph',N'FireFox;110.232.113.213;BinaryLane;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Tong, Last Name: Wu, Gender: Male, DOB 1982-04-14, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'ItaFoo2105@mail.com',N'NanRuHuaSeng-521',N'Ralph',N'Safari;103.230.156.173;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Ita, Last Name: Foo, Gender: Male, DOB 1991-10-24, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'BuYaoJin5042@mail.com',N'GumTPuJie-1-8',N'Ralph',N'Safari;112.213.33.40;BinaryLane;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: You, Last Name: Lai, Gender: Male, DOB 1996-12-16, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'HaiTaoShenQi607@mail.com',N'WoYaoShi-6-7',N'Ralph',N'IESelfComputer;103.230.157.22;BinaryLane5;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Dai, Last Name: Gou, Gender: Male, DOB 1992-09-19, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'AuctionFailSH@mail.com',N'ChiLunXian6-8',N'Ralph',N'FireFox;110.232.113.69;BinaryLane2;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Auc, Last Name: Tion, Gender: Male, DOB 1983-10-22, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'MeetYouUp126@mail.com',N'MeetNewGirl6-12',N'Ralph',N'Chrome;103.236.163.27;BinaryLane11;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: No, Last Name: Phone, Gender: Male, DOB 1991-10-12, Question: what city were you born in? Answer: Mel
INSERT INTO Account VALUES(N'BBKuaHana@mail.com',N'SitInCorner12_6',N'Ralph',N'FireFox;110.232.114.95;BinaryLane;FixAdID',N'machId=mlegUlacEUwTKFOMHVWaO0082VsEosLL14g75vsOQZJX8BzOe_Udai-WuqtUOY39egby_e1c1Gt8uZhyteCDjjG44Y2MPBmBbpk; optimizelyEndUserId=oeu1465091934497r0.7910611764425166; __gads=ID=d852791feb9af98f:T=1465088339:S=ALNI_MYazhFxiLNYd7qpkK_10jnr5_hh9g; up=%7B%22ln%22%3A%22434908037%22%2C%22ls%22%3A%22l%3D3003924%26r%3D0%26sv%3DLIST%26sf%3Ddate%22%7D; sid2=1f8b08000000000000002dcbb10e82301000d05fb9111273b45c5b242c356a34415c68c28c5ab5a15a821a91afd7c1f10d8f334e2295b922cd192157c889a3145a576172deb789440651e3eea7f07ec0de80422ae067250a18958861d1f7de36f650ba672229435210955b53ed66e05d6761638f5d8861791dc2cd269223c3346302e702eaf6dc0eeebfb419e5a54ed7ab5c4d86572f9a027d3c7e011ad38b4aa2000000; bs=%7B%22st%22%3A%7B%7D%7D; optimizelySegments=%7B%222153921328%22%3A%22none%22%2C%222154850398%22%3A%22direct%22%2C%222179050143%22%3A%22false%22%2C%222181970141%22%3A%22gc%22%7D; optimizelyBuckets=%7B%7D; crtg_rta=cto_puma_m_320120%3D1%3B; __utmt_siteTracker=1; __utma=160852194.1004030289.1465091938.1465863304.1465992229.8; __utmb=160852194.1.10.1465992229; __utmc=160852194; __utmz=160852194.1465091938.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); _ga=GA1.3.1004030289.1465091938; _gat=1; ki_t=1465091943544%3B1465992255554%3B1465992255554%3B6%3B56; ki_r=; sc=1po5MBFHsULLxqdA6FnJ; optimizelyPendingLogEvents=%5B%5D; _gali=welcome-username',N'',N'A',N'255.255.255.0',N'43.229.61.1',N'43.229.63.89',N'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36');--First Name: Sit, Last Name: Corner, Gender: Male, DOB 1979-09-23, Question: what city were you born in? Answer: Mel



--Address 
INSERT INTO [Address] VALUES(N'George Street, Oakleigh VIC 3166',N'George Street',N'-37.9032563',N'145.1019966');
INSERT INTO [Address] VALUES(N'St Kilda Road, St Kilda VIC 3182',N'St Kilda Road',N'-37.8545963',N'144.98204439999995');
INSERT INTO [Address] VALUES(N'Bentleigh VIC',N'Bentleigh',N'-37.918018',N'145.03573600000004');
INSERT INTO [Address] VALUES(N'Clayton VIC 3168',N'Clayton',N'-37.92621200000001',N'145.119553');
INSERT INTO [Address] VALUES(N'Mount Waverley VIC 3149',N'Mount Waverley',N'-37.8759216',N'145.1293048');
INSERT INTO [Address] VALUES(N'Caulfield VIC 3162',N'Caulfield',N'-37.88291359999999',N'145.02281990000006');
INSERT INTO [Address] VALUES(N'Prahran VIC',N'Prahran',N'-37.851524',N'144.99348399999997');
INSERT INTO [Address] VALUES(N'Westmead NSW 2145',N'Westmead',N'-33.8076889',N'150.98727680000002');
INSERT INTO [Address] VALUES(N'Ryde NSW',N'Ryde',N'-33.8134146',N'151.10579489999998');
INSERT INTO [Address] VALUES(N'Parramatta NSW',N'Parramatta',N'-33.8151285',N'151.00315490000003');
INSERT INTO [Address] VALUES(N'Homebush NSW 2140',N'Homebush',N'-33.8672238',N'151.08470899999997');
INSERT INTO [Address] VALUES(N'North Sydney NSW',N'North Sydney',N'-33.8386344',N'151.20711419999998');
INSERT INTO [Address] VALUES(N'Waverton NSW 2060',N'Waverton',N'-33.8377116',N'151.19698240000002');
INSERT INTO [Address] VALUES(N'Frankston VIC',N'Frankston',N'-38.1413993',N'145.12246389999996');

INSERT INTO [Address] VALUES(N'Narre Warren VIC 3805',N'Narre Warren',N'-38.02711499999999',N'145.30304');
INSERT INTO [Address] VALUES(N'Cranbourne VIC 3977',N'Cranbourne',N'-38.10834740000001',N'145.28442470000004');
INSERT INTO [Address] VALUES(N'Hallam VIC 3803',N'Hallam',N'-38.018261',N'145.27078200000005');

INSERT INTO [Address] VALUES(N'Mitcham VIC 3132',N'Mitcham',N'-37.81776',N'145.192001');
INSERT INTO [Address] VALUES(N'Ringwood VIC 3134',N'Ringwood',N'-37.81426200000001',N'145.22738600000002');
INSERT INTO [Address] VALUES(N'Endeavour Hills VIC 3802',N'Endeavour Hills',N'-37.9758866',N'145.2577854');

INSERT INTO [Address] VALUES(N'Wheelers Hill VIC 3150',N'Wheelers Hill',N'-37.910314',N'145.1885049');
INSERT INTO [Address] VALUES(N'Springvale VIC 3171',N'Springvale',N'-37.9519166',N'145.15211420000003');
INSERT INTO [Address] VALUES(N'Mount Waverley VIC 3149',N'Mount Waverley',N'-37.8759216',N'145.1293048');
INSERT INTO [Address] VALUES(N'Glen Waverley VIC',N'Glen Waverley',N'-37.8785429',N'145.16481199999998');

INSERT INTO [Address] VALUES(N'51 Queen Street, Melbourne VIC 3000',N'51',N'-37.817738',N'144.96161400000005');

INSERT INTO [Address] VALUES(N'Marsfield NSW 2122',N'Marsfield',N'-33.7783143',N'151.10714870000004');
INSERT INTO [Address] VALUES(N'7 Engel Avenue, Marsfield NSW 2122',N'7',N'-33.779423',N'151.100866');

INSERT INTO [Address] VALUES(N'Footscray VIC',N'Footscray',N'-37.799736',N'144.89973399999997');

INSERT INTO [Address] VALUES(N'Monash University Clayton Campus, Wellington Road, Clayton VIC 3800',N'Monash University Clayton Campus',N'-37.9152113',N'145.134682');
INSERT INTO [Address] VALUES(N'Dandenong VIC 3175',N'Dandenong',N'-37.9874598',N'145.21486119999997');

INSERT INTO [Address] VALUES(N'Werribee VIC',N'Werribee',N'-37.9029061',N'144.65847469999994');
INSERT INTO [Address] VALUES(N'Sunbury VIC 3429',N'Sunbury',N'-37.5794919',N'144.72889810000004');

INSERT INTO [Address] VALUES(N'Mentone VIC',N'Mentone',N'-37.981903',N'145.06472800000006');
INSERT INTO [Address] VALUES(N'Richmond VIC',N'Richmond',N'-37.818635',N'145.00147040000002');
INSERT INTO [Address] VALUES(N'Camberwell VIC 3124',N'Camberwell',N'-37.8425667',N'145.06936259999998');
INSERT INTO [Address] VALUES(N'Brighton VIC 3186',N'Brighton',N'-37.9056598',N'145.00431170000002');

INSERT INTO [Address] VALUES(N'Welshpool WA 6106',N'Welshpool',N'-31.9939922',N'115.92111999999997');

INSERT INTO [Address] VALUES(N'Chatswood NSW 2067',N'Chatswood',N'-33.796076',N'151.1831019');
INSERT INTO [Address] VALUES(N'Rhodes NSW',N'Rhodes',N'-33.8308619',N'151.08753430000001');

INSERT INTO [Address] VALUES(N'Gold Coast QLD',N'Gold Coast',N'-28.0172605',N'153.4256987');

INSERT INTO [Address] VALUES(N'Box Hill VIC 3128',N'Box Hill',N'-37.8190302',N'145.12354319999997');
INSERT INTO [Address] VALUES(N'Oakleigh VIC 3166',N'Oakleigh',N'-37.89846',N'145.08837900000003');
INSERT INTO [Address] VALUES(N'Burwood VIC 3125',N'Burwood',N'-37.85014049999999',N'145.11903129999996');
INSERT INTO [Address] VALUES(N'10 Eucalyptus Street, Constitution Hill NSW 2145',N'10',N'-33.791572',N'150.972752');
INSERT INTO [Address] VALUES(N'Mulgrave VIC',N'Mulgrave',N'-37.9215364',N'145.15844270000002');
INSERT INTO [Address] VALUES(N'Bayswater North VIC 3153',N'Bayswater North',N'-37.8242081',N'145.296783');
INSERT INTO [Address] VALUES(N'9A King St, Rockdale NSW 2216',N'Rockdale',N'-33.952679',N'151.13861999999995');
INSERT INTO [Address] VALUES(N'King St, Rockdale NSW 2216',N'Rockdale',N'-33.9529921',N'151.13991710000005')
INSERT INTO [Address] VALUES(N'surry hills, sydney',N'Surry Hills',N'-33.8906466',N'151.21292540000002')
INSERT INTO [Address] VALUES(N'Bondi Sydney NSW 2026',N'Bondi Beach',N'-33.8908435',N'151.27429059999997')
INSERT INTO [Address] VALUES(N'Double Bay 2028',N'Double Bay',N'-33.8776567',N'151.24293750000004')
INSERT INTO [Address] VALUES(N'Newtown, NSW',N'Newtown',N'-33.8965493',N'151.17996319999997')
INSERT INTO [Address] VALUES(N'Zetland, New South Wales, Australia',N'Zetland',N'-33.905553',N'151.20650669999998')
INSERT INTO [Address] VALUES(N'Mosman, New South Wales, Australia',N'Mosman',N'-33.8292248',N'151.24406010000007')
INSERT INTO [Address] VALUES(N'Wolli Creek, New South Wales, Australia',N'Wolli Creek',N'-33.9316729',N'151.15388459999997')
INSERT INTO [Address] VALUES(N'North Sydney, New South Wales, Australia',N'North Sydney',N'-33.83965',N'151.20541000000003')
INSERT INTO [Address] VALUES(N'Kingsgrove, New South Wales, Australia',N'Kingsgrove',N'-33.9391',N'151.10138000000006')
INSERT INTO [Address] VALUES(N'Perth, Western Australia, Australia',N'Perth',N'-31.9505269',N'115.86045719999993')
INSERT INTO [Address] VALUES(N'Welshpool, Western Australia, Australia',N'Welshpool',N'-31.994',N'115.95600000000002')
INSERT INTO [Address] VALUES(N'Punchbowl, NSW, 2196, Australia',N'Punchbowl',N'-33.933333',N'151.04999999999995')
INSERT INTO [Address] VALUES(N'Chipping Norton, NSW, 2170, Australia',N'Chipping Norton',N'-33.9250331',N'150.96328229999995')
INSERT INTO [Address] VALUES(N'Saint Kilda, Victoria, Australia',N'Saint Kilda',N'-37.864',N'144.98199999999997')
INSERT INTO [Address] VALUES(N'Kings Park, New South Wales, Australia',N'Kings Park',N'-33.737',N'150.90100000000007')
INSERT INTO [Address] VALUES(N'Hurstville, New South Wales, Australia',N'Hurstville',N'-33.96666699999999',N'151.10000000000002')
INSERT INTO [Address] VALUES(N'Campsie, New South Wales, Australia',N'Campsie',N'-33.91461',N'151.10183000000006')
INSERT INTO [Address] VALUES(N'Avalon, Victoria, Australia',N'Avalon',N'-38.0568548',N'144.4225874')
INSERT INTO [Address] VALUES(N'Morley, Western Australia, Australia',N'Morley',N'-31.887',N'115.90699999999993')
INSERT INTO [Address] VALUES(N'Wareemba, New South Wales, Australia',N'Wareemba',N'-33.8574937',N'151.13230939999994')
INSERT INTO [Address] VALUES(N'Inner West, Sydney, NSW, Australia',N'Sydney',N'-33.8584827',N'151.12866859999997')
INSERT INTO [Address] VALUES(N'Auburn, New South Wales, Australia',N'Auburn',N'-33.86563',N'151.0236')
INSERT INTO [Address] VALUES(N'11/21 Woniora Ave, Wahroonga NSW 2076',N'Wahroonga',N'-33.7136595',N'151.11468420000006');
INSERT INTO [Address] VALUES(N'A5108/1A Morton St, Parramatta NSW 2150',N'Parramatta',N'-33.8142611',N'151.0161008');
INSERT INTO [Address] VALUES(N'Concord, New South Wales, Australia',N'Concord',N'-33.85985',N'151.10190999999998');
INSERT INTO [Address] VALUES(N'Meadowbank, New South Wales, Australia',N'Meadowbank',N'-33.81692',N'151.08332999999993');
INSERT INTO [Address] VALUES(N'Canterbury, New South Wales, Australia',N'Canterbury',N'-33.9126',N'151.11799999999994');

INSERT INTO [Address] VALUES(N'Redfern, New South Wales, Australia',N'Redfern',N'-33.89333999999999',N'151.20461');
INSERT INTO [Address] VALUES(N'Randwick, New South Wales, Australia',N'Randwick',N'-33.91643',N'151.23653000000002');
INSERT INTO [Address] VALUES(N'Alexandria, New South Wales, Australia',N'Alexandria',N'-33.90166',N'151.20006999999998');
INSERT INTO [Address] VALUES(N'Maroubra, New South Wales, Australia',N'Maroubra',N'-33.9495',N'151.2437');
--INSERT INTO [Address] VALUES(N'Parramatta, New South Wales, Australia',N'Parramatta',N'-33.815',N'151.00111100000004');
INSERT INTO [Address] VALUES(N'Arncliffe, New South Wales, Australia',N'Arncliffe',N'-33.9363231',N'151.14323250000007');
INSERT INTO [Address] VALUES(N'Neutral Bay, New South Wales, Australia',N'Neutral Bay',N'-33.83450000000001',N'151.21839999999997');
INSERT INTO [Address] VALUES(N'Waterloo, New South Wales, Australia',N'Waterloo',N'-33.9004',N'151.20664');
INSERT INTO [Address] VALUES(N'Kingsford, New South Wales, Australia',N'Kingsford',N'-33.92457',N'151.22765000000004');
INSERT INTO [Address] VALUES(N'Leichhardt, New South Wales, Australia',N'Leichhardt',N'-33.8847',N'151.15729999999996');
INSERT INTO [Address] VALUES(N'Bankstown, New South Wales, Australia',N'Bankstown',N'-33.91817',N'151.03496999999993');
INSERT INTO [Address] VALUES(N'Pyrmont, New South Wales, Australia',N'Pyrmont',N'-33.8737167',N'151.19569179999996');
INSERT INTO [Address] VALUES(N'Potts Point, New South Wales, Australia',N'Potts Point',N'-33.86795',N'151.22411');
INSERT INTO [Address] VALUES(N'Marrickville, New South Wales, Australia',N'Marrickville',N'-33.9051',N'151.15509999999995');
INSERT INTO [Address] VALUES(N'Ultimo, New South Wales, Australia',N'Ultimo',N'-33.88223',N'151.19696');
INSERT INTO [Address] VALUES(N'Kensington, New South Wales, Australia',N'Kensington',N'-33.90888899999999',N'151.22333300000002');
INSERT INTO [Address] VALUES(N'Chippendale, New South Wales, Australia',N'Chippendale',N'-33.8863',N'151.19990000000007');
INSERT INTO [Address] VALUES(N'Paddington, New South Wales, Australia',N'Paddington',N'-33.88477',N'151.22621000000004');
INSERT INTO [Address] VALUES(N'Fairfield, New South Wales, Australia',N'Fairfield',N'-33.87028',N'150.95622000000003');
INSERT INTO [Address] VALUES(N'Wetherill Park, New South Wales, Australia',N'Wetherill Park',N'-33.84975000000001',N'150.91101000000003');
INSERT INTO [Address] VALUES(N'Liverpool, New South Wales, Australia',N'Liverpool',N'-33.92092',N'150.92314');
INSERT INTO [Address] VALUES(N'Burwood, New South Wales, Australia',N'Burwood',N'-33.8772',N'151.10490000000004');
INSERT INTO [Address] VALUES(N'Perth, WA, Australia',N'Perth',N'-31.9505269',N'115.86045719999993')
INSERT INTO [Address] VALUES(N'Thomastown, Victoria, Australia',N'Thomastown',N'-37.682',N'145.014')
INSERT INTO [Address] VALUES(N'Yass, New South Wales, Australia',N'Yass',N'-34.8261106',N'148.91431820000003')
INSERT INTO [Address] VALUES(N'Gungahlin, ACT, 2912, Australia',N'Gungahlin',N'-35.188067',N'149.13575070000002')

INSERT INTO [Address] VALUES(N'Oakleigh South, Victoria, Australia',N'Oakleigh South',N'-37.917',N'145.09000000000003')
INSERT INTO [Address] VALUES(N'Clayton South, Victoria, Australia',N'Clayton South',N'-37.947',N'145.12300000000005')
INSERT INTO [Address] VALUES(N'Notting Hill, Victoria, Australia',N'Notting Hill',N'-37.9048347',N'145.14586110000005')
INSERT INTO [Address] VALUES(N'Heidelberg West, Victoria, Australia',N'Heidelberg West',N'-37.744',N'145.04700000000003')

INSERT INTO [Address] VALUES(N'Campbellfield, Victoria, Australia',N'Campbellfield',N'-37.673',N'144.957')
INSERT INTO [Address] VALUES(N'Gold Coast, Queensland, Australia',N'Gold Coast',N'-28.016667',N'153.39999999999998')
INSERT INTO [Address] VALUES(N'Preston, Victoria, Australia',N'Preston',N'-37.74299999999999',N'145.00800000000004')

INSERT INTO [Address] VALUES(N'449 North Rd, Ormond, Victoria, Australia',N'Ormond',N'-37.903437',N'145.037604')
INSERT INTO [Address] VALUES(N'Malvern East, Victoria, Australia',N'Malvern East',N'-37.878',N'145.05999999999995')
INSERT INTO [Address] VALUES(N'Hoppers Crossing, Victoria, Australia',N'Hoppers Crossing',N'-37.869',N'144.69299999999998')
INSERT INTO [Address] VALUES(N'Canberra, Australian Capital Territory, Australia',N'Canberra',N'-35.2809368',N'149.13000920000002');
INSERT INTO [Address] VALUES(N'Blacktown, New South Wales, Australia',N'Blacktown',N'-33.771',N'150.9063');
INSERT INTO [Address] VALUES(N'Castle Hill, New South Wales, Australia',N'Castle Hill',N'-33.72925',N'151.00401999999997');
INSERT INTO [Address] VALUES(N'Adelaide, South Australia, Australia',N'Adelaide',N'-34.9284989',N'138.60074559999998');
INSERT INTO [Address] VALUES(N'Sunnybank, Queensland, Australia',N'Sunnybank',N'-27.579',N'153.05899999999997');
INSERT INTO [Address] VALUES(N'Carina Heights, Queensland, Australia',N'Carina Heights',N'-27.507',N'153.09299999999996');
INSERT INTO [Address] VALUES(N'Carlton VIC, Australia',N'Carlton',N'-37.8001',N'144.96709999999996');
INSERT INTO [Address] VALUES(N'541 Warrigal Road, Ashwood VIC, Australia',N'Ashwood',N'-37.865551',N'145.09312599999998');
INSERT INTO [Address] VALUES(N'Slacks Creek QLD, Australia',N'Slacks Creek',N'-27.64215769999999',N'153.12663440000006');
INSERT INTO [Address] VALUES(N'Lidcombe NSW, Australia',N'Lidcombe',N'-33.86462',N'151.04562999999996');
INSERT INTO [Address] VALUES(N'Burwood NSW, Australia',N'Burwood',N'-33.8772',N'151.10490000000004');
INSERT INTO [Address] VALUES(N'Sunshine VIC, Australia',N'Sunshine',N'-37.781',N'144.832');
INSERT INTO [Address] VALUES(N'Doncaster VIC, Australia',N'Doncaster',N'-37.787',N'145.12400000000002');
INSERT INTO [Address] VALUES(N'Mordialloc VIC, Australia',N'Mordialloc',N'-37.999',N'145.09199999999998');
INSERT INTO [Address] VALUES(N'Moorabbin VIC, Australia',N'Moorabbin',N'-37.941',N'145.058');
INSERT INTO [Address] VALUES(N'St Peters NSW, Australia',N'Saint Peters',N'-33.90951',N'151.17723');
INSERT INTO [Address] VALUES(N'Bentleigh East VIC, Australia',N'Bentleigh East',N'-37.921',N'145.067');

--CustomFieldGroup
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Used, Negotiable Product');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Removal Service');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Jew');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Used, Free Product');
INSERT INTO [CustomFieldGroup] VALUES(N'North Sydney Massage');
INSERT INTO [CustomFieldGroup] VALUES(N'Ado Warehouse Ad 1');
INSERT INTO [CustomFieldGroup] VALUES(N'Ado Warehouse Ad 2');
INSERT INTO [CustomFieldGroup] VALUES(N'Ado Warehouse Ad 3');
INSERT INTO [CustomFieldGroup] VALUES(N'Ado Warehouse Ad 4');
INSERT INTO [CustomFieldGroup] VALUES(N'Ado CS Ad 1');
INSERT INTO [CustomFieldGroup] VALUES(N'Wen Massage Ad');
INSERT INTO [CustomFieldGroup] VALUES(N'Adam Automotive');
INSERT INTO [CustomFieldGroup] VALUES(N'Andersen Removal');
INSERT INTO [CustomFieldGroup] VALUES(N'Wen Massage Job');
INSERT INTO [CustomFieldGroup] VALUES(N'Ado Private Parttime Job');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Negotiable Car');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Removal Service 2');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Removal Service 3');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Removal Service 4');
INSERT INTO [CustomFieldGroup] VALUES(N'Alvin Removal Service 5');
INSERT INTO [CustomFieldGroup] VALUES(N'Ken Cleaning Service');
INSERT INTO [CustomFieldGroup] VALUES(N'Kenny Cleaning Service');

INSERT INTO [CustomFieldGroup] VALUES(N'Sam Cleaning Service 1');
INSERT INTO [CustomFieldGroup] VALUES(N'Sam Cleaning Service 2');

INSERT INTO [CustomFieldGroup] VALUES(N'Sumit Assignment');

INSERT INTO [CustomFieldGroup] VALUES(N'Liu Cleaning Service');
INSERT INTO [CustomFieldGroup] VALUES(N'ShuFang Clothes Alteration Service');

INSERT INTO [CustomFieldGroup] VALUES(N'XiaoLiu Removal Service 1');
INSERT INTO [CustomFieldGroup] VALUES(N'XiaoLiu Removal Service 2');
INSERT INTO [CustomFieldGroup] VALUES(N'XiaoLiu Removal Service 3');
INSERT INTO [CustomFieldGroup] VALUES(N'XiaoLiu Removal Service 4');
INSERT INTO [CustomFieldGroup] VALUES(N'XiaoLiu Removal Service 5');


--CustomFieldLine
INSERT INTO [CustomFieldLine] VALUES(2,N'condition',N'used');
INSERT INTO [CustomFieldLine] VALUES(2,N'price.type',N'NEGOTIABLE');

INSERT INTO [CustomFieldLine] VALUES(3,N'slogan',N'melbourne cheap removal, junk removal');
INSERT INTO [CustomFieldLine] VALUES(3,N'expertise1',N'house moving, office moving');
INSERT INTO [CustomFieldLine] VALUES(3,N'expertise2',N'delivery & pick up');
INSERT INTO [CustomFieldLine] VALUES(3,N'expertise3',N'junk removal, rubbish removal, waste removal');
INSERT INTO [CustomFieldLine] VALUES(3,N'expertise4',N'professional cleaning services');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_mon_from',N'7:00am');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_mon_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_tue_from',N'7:00am');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_tue_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_wed_from',N'7:00am');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_wed_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_thu_from',N'7:00am');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_thu_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_fri_from',N'7:00am');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_fri_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_sat_from',N'7:00am');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_sat_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_sun_from',N'7:00am');
INSERT INTO [CustomFieldLine] VALUES(3,N'openhrs_sun_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(3,N'website',N'http://www.melbournecheapremoval.com');


INSERT INTO [CustomFieldLine] VALUES(19,N'slogan',N'top priority is the customer''s satisfaction');
INSERT INTO [CustomFieldLine] VALUES(20,N'slogan',N'We aim at making trustworthy relations');
INSERT INTO [CustomFieldLine] VALUES(21,N'slogan',N'Our services includes furniture/junk removals');
INSERT INTO [CustomFieldLine] VALUES(22,N'slogan',N'Our ultimate aim is to satisfy our clients');



INSERT INTO [CustomFieldLine] VALUES(4,N'price.type',N'NEGOTIABLE');


INSERT INTO [CustomFieldLine] VALUES(5,N'condition',N'used');
INSERT INTO [CustomFieldLine] VALUES(5,N'price.type',N'GIVE_AWAY');
INSERT INTO [CustomFieldLine] VALUES(5,N'price.amount',N'BLANK');



INSERT INTO [CustomFieldLine] VALUES(6,N'slogan',N'Welcome To North Sydney Massage');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_mon_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_mon_to',N'7:30pm');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_tue_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_tue_to',N'7:30pm');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_wed_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_wed_to',N'7:30pm');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_thu_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_thu_to',N'7:30pm');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_fri_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_fri_to',N'7:30pm');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_sat_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_sat_to',N'7:30pm');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_sun_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(6,N'openhrs_sun_to',N'7:30pm');
INSERT INTO [CustomFieldLine] VALUES(6,N'abn',N'84905523119');
INSERT INTO [CustomFieldLine] VALUES(6,N'accreditation',N'ASSOCIATION OF MASSAGE THERAPISTS');
INSERT INTO [CustomFieldLine] VALUES(6,N'expertise1',N'Full Body Massage');
INSERT INTO [CustomFieldLine] VALUES(6,N'expertise2',N'Oil Massage');
INSERT INTO [CustomFieldLine] VALUES(6,N'expertise3',N'Therapy Massage');

INSERT INTO [CustomFieldLine] VALUES(6,N'name',N'Daryl');
INSERT INTO [CustomFieldLine] VALUES(6,N'phoneNumber',N'0404038999');


INSERT INTO [CustomFieldLine] VALUES(7,N'name',N'Kate');
INSERT INTO [CustomFieldLine] VALUES(8,N'name',N'Michael');
INSERT INTO [CustomFieldLine] VALUES(9,N'name',N'Peter');
INSERT INTO [CustomFieldLine] VALUES(10,N'name',N'Jennet');

INSERT INTO [CustomFieldLine] VALUES(12,N'name',N'Liliana');


INSERT INTO [CustomFieldLine] VALUES(13,N'slogan',N'Chinese & Thai style full body oil massage');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_mon_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_mon_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_tue_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_tue_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_wed_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_wed_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_thu_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_thu_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_fri_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_fri_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_sat_from',N'10:30am');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_sat_to',N'8:30pm');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_sun_from',N'10:30am');
INSERT INTO [CustomFieldLine] VALUES(13,N'openhrs_sun_to',N'8:30pm');
INSERT INTO [CustomFieldLine] VALUES(13,N'abn',N'21760059742');
INSERT INTO [CustomFieldLine] VALUES(13,N'name',N'Wen');
INSERT INTO [CustomFieldLine] VALUES(13,N'phoneNumber',N'0425198508');
INSERT INTO [CustomFieldLine] VALUES(13,N'accreditation',N'Whole Body Massage Certification By Discover Massage Australia');



INSERT INTO [CustomFieldLine] VALUES(8,N'expertise1',N'Eastwood, Marsfield, Macquarie Park, Carlingford, Epping, Ermington, Pennant Hills, Cherrybrook');
INSERT INTO [CustomFieldLine] VALUES(8,N'expertise2',N'Parramatta, Wentworthville, Westmead, Merrylands, Auburn, Blacktown, Mt Druitt, St Marys, Penrith');
INSERT INTO [CustomFieldLine] VALUES(8,N'expertise3',N'Ryde, Silverwater, Concord, Auburn, Lidcombe, Strathfield, Regents Park, Bankstown, Lakemba, Campsie');
INSERT INTO [CustomFieldLine] VALUES(8,N'expertise4',N'Bankstown, Revesby, Hurstville, Rockdale, Kogarah, Sutherland, Cronulla, Ashfield, Five Dock');
INSERT INTO [CustomFieldLine] VALUES(8,N'expertise5',N'North Sydney, Mosman, Dee Why, Chatswood, Killara, Pymble, Manly, Narrabeen, Mona Vale, Lane Cove');
INSERT INTO [CustomFieldLine] VALUES(8,N'abn',N'85050095380');
INSERT INTO [CustomFieldLine] VALUES(8,N'slogan',N'Regular and Reliable');


INSERT INTO [CustomFieldLine] VALUES(9,N'expertise1',N'Eastwood, Marsfield, Macquarie Park, Carlingford, Epping, Ermington, Pennant Hills, Cherrybrook');
INSERT INTO [CustomFieldLine] VALUES(9,N'expertise2',N'Parramatta, Wentworthville, Westmead, Merrylands, Auburn, Blacktown, Mt Druitt, St Marys, Penrith');
INSERT INTO [CustomFieldLine] VALUES(9,N'expertise3',N'Ryde, Silverwater, Concord, Auburn, Lidcombe, Strathfield, Regents Park, Bankstown, Lakemba, Campsie');
INSERT INTO [CustomFieldLine] VALUES(9,N'expertise4',N'Bankstown, Revesby, Hurstville, Rockdale, Kogarah, Sutherland, Cronulla, Ashfield, Five Dock');
INSERT INTO [CustomFieldLine] VALUES(9,N'expertise5',N'North Sydney, Mosman, Dee Why, Chatswood, Killara, Pymble, Manly, Narrabeen, Mona Vale, Lane Cove');
INSERT INTO [CustomFieldLine] VALUES(9,N'abn',N'85050095380');
INSERT INTO [CustomFieldLine] VALUES(9,N'slogan',N'100% satisfaction is our guarantee.');
INSERT INTO [CustomFieldLine] VALUES(9,N'accreditation',N'Transport NSW authorized Private Hire Vehicle Driver GU3751');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_mon_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_mon_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_tue_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_tue_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_wed_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_wed_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_thu_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_thu_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_fri_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_fri_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_sat_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_sat_to',N'9:00pm');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_sun_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(9,N'openhrs_sun_to',N'9:00pm');


INSERT INTO [CustomFieldLine] VALUES(10,N'advertisedby',N'agency');
INSERT INTO [CustomFieldLine] VALUES(10,N'jobtype',N'parttime');
INSERT INTO [CustomFieldLine] VALUES(10,N'name',N'Seven');
INSERT INTO [CustomFieldLine] VALUES(10,N'phoneNumber',N'0450631202');
INSERT INTO [CustomFieldLine] VALUES(10,N'name',N'Adam');
INSERT INTO [CustomFieldLine] VALUES(10,N'phoneNumber',N'0431648898');


INSERT INTO [CustomFieldLine] VALUES(14,N'slogan',N'To be present better and save money');
INSERT INTO [CustomFieldLine] VALUES(14,N'name',N'Ivan');
INSERT INTO [CustomFieldLine] VALUES(14,N'phoneNumber',N'0434198526');
INSERT INTO [CustomFieldLine] VALUES(14,N'name',N'Adam');
INSERT INTO [CustomFieldLine] VALUES(14,N'phoneNumber',N'0431648898');



INSERT INTO [CustomFieldLine] VALUES(15,N'slogan',N'Honest and Reliable');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_mon_from',N'9:00am');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_mon_to',N'10:00pm');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_tue_from',N'9:00am');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_tue_to',N'10:00pm');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_wed_from',N'9:00am');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_wed_to',N'10:00pm');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_thu_from',N'9:00am');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_thu_to',N'10:00pm');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_fri_from',N'9:00am');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_fri_to',N'10:00pm');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_sat_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_sat_to',N'10:00pm');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_sun_from',N'10:00am');
INSERT INTO [CustomFieldLine] VALUES(15,N'openhrs_sun_to',N'10:00pm');
INSERT INTO [CustomFieldLine] VALUES(15,N'abn',N'85050095380');
INSERT INTO [CustomFieldLine] VALUES(15,N'accreditation',N'Transport NSW authorized Private Vehicle and Bus Driver GU3751');


INSERT INTO [CustomFieldLine] VALUES(16,N'jobtype',N'fulltime');
INSERT INTO [CustomFieldLine] VALUES(16,N'name',N'Wen');
INSERT INTO [CustomFieldLine] VALUES(16,N'phoneNumber',N'0425198902');

INSERT INTO [CustomFieldLine] VALUES(17,N'advertisedby',N'private');
INSERT INTO [CustomFieldLine] VALUES(17,N'jobtype',N'parttime');

INSERT INTO [CustomFieldLine] VALUES(18,N'price.amount',N'BLANK');



INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_mon_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_mon_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_tue_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_tue_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_wed_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_wed_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_thu_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_thu_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_fri_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_fri_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_sat_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_sat_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_sun_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(19,N'openhrs_sun_to',N'11:00pm');

INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_mon_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_mon_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_tue_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_tue_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_wed_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_wed_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_thu_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_thu_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_fri_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_fri_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_sat_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_sat_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_sun_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(20,N'openhrs_sun_to',N'11:00pm');

INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_mon_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_mon_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_tue_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_tue_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_wed_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_wed_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_thu_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_thu_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_fri_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_fri_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_sat_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_sat_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_sun_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(21,N'openhrs_sun_to',N'11:00pm');

INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_mon_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_mon_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_tue_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_tue_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_wed_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_wed_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_thu_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_thu_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_fri_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_fri_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_sat_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_sat_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_sun_from',N'8:00am');
INSERT INTO [CustomFieldLine] VALUES(22,N'openhrs_sun_to',N'11:00pm');


INSERT INTO [CustomFieldLine] VALUES(23,N'slogan',N'TOP QUALITY DEEP PROFESSIONAL END OF LEASE CLEAN');
INSERT INTO [CustomFieldLine] VALUES(23,N'name',N'Tom');
INSERT INTO [CustomFieldLine] VALUES(23,N'phoneNumber',N'0430282812');

INSERT INTO [CustomFieldLine] VALUES(24,N'slogan',N'TOP QUALITY DEEP PROFESSIONAL END OF LEASE CLEAN');
--INSERT INTO [CustomFieldLine] VALUES(24,N'name',N'Tom');
--INSERT INTO [CustomFieldLine] VALUES(24,N'phoneNumber',N'0430282812');

INSERT INTO [CustomFieldLine] VALUES(25,N'slogan',N'We offer our service All over Sydney,NSW /Brisbane AND gold coast');
INSERT INTO [CustomFieldLine] VALUES(26,N'slogan',N'Excellent Cleaning Serivce Guarantee');



INSERT INTO [CustomFieldLine] VALUES(27,N'slogan',N'Affordable..Quick Assignment Help');
INSERT INTO [CustomFieldLine] VALUES(27,N'expertise1',N'Finance, Accounting, Corporate Law, Business Law,  HR, MYOB, Perdisco, Quickbooks');
INSERT INTO [CustomFieldLine] VALUES(27,N'expertise2',N'Management, Marketing, Business, Business Services, OB, MBA');
INSERT INTO [CustomFieldLine] VALUES(27,N'expertise3',N'Project Management, Data Analysis, Business Analysis, IT, C++ C#, Matlab, Statistics');
INSERT INTO [CustomFieldLine] VALUES(27,N'expertise4',N'Social Science, Essay, Nursing, Children Services, Hospitality');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_mon_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_mon_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_tue_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_tue_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_wed_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_wed_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_thu_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_thu_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_fri_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_fri_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_sat_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_sat_to',N'11:00pm');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_sun_from',N'6:00am');
INSERT INTO [CustomFieldLine] VALUES(27,N'openhrs_sun_to',N'11:00pm');



INSERT INTO [CustomFieldLine] VALUES(28,N'slogan',N'TOP QUALITY DEEP PROFESSIONAL END OF LEASE CLEAN');
INSERT INTO [CustomFieldLine] VALUES(23,N'name',N'Dave');
INSERT INTO [CustomFieldLine] VALUES(23,N'phoneNumber',N'0433181088');


INSERT INTO [CustomFieldLine] VALUES(29,N'slogan',N'All clothing alterations');
INSERT INTO [CustomFieldLine] VALUES(29,N'name',N'ShuFang');
INSERT INTO [CustomFieldLine] VALUES(29,N'phoneNumber',N'0449850688');


INSERT INTO [CustomFieldLine] VALUES(30,N'slogan',N'Melbourne Cheap Removals help you to move');
INSERT INTO [CustomFieldLine] VALUES(30,N'name',N'Liu');
INSERT INTO [CustomFieldLine] VALUES(30,N'phoneNumber',N'0426246275');

INSERT INTO [CustomFieldLine] VALUES(31,N'slogan',N'Specialize in relocation and are available 7 days a week');
INSERT INTO [CustomFieldLine] VALUES(31,N'name',N'XiaoLiu');
INSERT INTO [CustomFieldLine] VALUES(31,N'phoneNumber',N'0426246275');

INSERT INTO [CustomFieldLine] VALUES(32,N'slogan',N'Reliable and Professional');
INSERT INTO [CustomFieldLine] VALUES(32,N'name',N'XiaoLiu');
INSERT INTO [CustomFieldLine] VALUES(32,N'phoneNumber',N'0426688464');

INSERT INTO [CustomFieldLine] VALUES(33,N'slogan',N'AVAILABLE ANYTIME');
INSERT INTO [CustomFieldLine] VALUES(33,N'name',N'Fifi');
INSERT INTO [CustomFieldLine] VALUES(33,N'phoneNumber',N'0426246275');

INSERT INTO [CustomFieldLine] VALUES(34,N'slogan',N'Good reputation in the Industry');
INSERT INTO [CustomFieldLine] VALUES(34,N'name',N'Fifi');
INSERT INTO [CustomFieldLine] VALUES(34,N'phoneNumber',N'0470325128');
















--New Gumtree Category on 20160524

--Electronics & Computer
INSERT INTO [ProductCategory] VALUES('21121','Tablets & eBooks','20045',1,1,'A')

--Audio
INSERT INTO [ProductCategory] VALUES('21106','Audio','20045',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21104','Headphones & Earphones','21106',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21118','Home Theatre Systems','21106',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21101','Radios & Receivers','21106',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21102','Speakers','21106',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21105','Stereo Systems','21106',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21103','iPods & MP3 Players','21106',1,1,'A')
update [ProductCategory] set CategoryName='Other Audio', ParentCategoryID='21106' where ID=73 and CategoryID='18625'

--Cameras
update [ProductCategory] set CategoryName='Digital Compact Cameras' where ID=304 and CategoryID='18621'
INSERT INTO [ProductCategory] VALUES('21107','Digital SLR','18394',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21109','GoPro & Action Cameras','18394',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21108','Lenses','18394',1,1,'A')


--Computers & Software
update [ProductCategory] set CategoryName='Computer Accessories' where ID=293 and CategoryID='18554'
update [ProductCategory] set CategoryName='Computer Speakers' where ID=295 and CategoryID='18557'
INSERT INTO [ProductCategory] VALUES('21112','Hard Drives & USB Sticks','18309',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21110','Modems & Routers','18309',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21111','Monitors','18309',1,1,'A')
update [ProductCategory] set CategoryName='Printers & Scanners' where ID=292 and CategoryID='18555'


--Phones
INSERT INTO [ProductCategory] VALUES('21113','Android Phones','18313',1,1,'A')
update [ProductCategory] set CategoryName='Phone Accessories' where ID=297 and CategoryID='18598'
update [ProductCategory] set CategoryName='iPhone' where ID=296 and CategoryID='18597'


--TV & DVD players
INSERT INTO [ProductCategory] VALUES('21127','TV & DVD players','20045',1,1,'A')
update [ProductCategory] set  CategoryName='Other TV & DVD Players',ParentCategoryID='21127' where ID=75 and CategoryID='18316'
INSERT INTO [ProductCategory] VALUES('21117','DVD Players','21127',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21118','Home Theatre Systems','21127',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21116','TV Accessories','21127',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21115','TVs','21127',1,1,'A')


--Tablets & eBooks
INSERT INTO [ProductCategory] VALUES('21123','Android Tablets','21121',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21124','Kindle & eBooks','21121',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21125','Tablet Accessories','21121',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21122','iPads','21121',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21126','Other Tablets','21121',1,1,'A')


--Video Games & Consoles
update [ProductCategory] set CategoryName='Console Accessories' where ID=303 and CategoryID='18616'
update [ProductCategory] set CategoryName='Playstation' where ID=301 and CategoryID='18617'
INSERT INTO [ProductCategory] VALUES('21120','Wii','18459',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21119','Xbox','18459',1,1,'A')


--Kitchen & Dining
INSERT INTO [ProductCategory] VALUES('21028','Kitchen & Dining','18397',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21029','Cooking Accessories','21028',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21031','Cutlery','21028',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21032','Dinnerware','21028',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21030','Pots & Pans','21028',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21033','Other Kitchen & Dining','21028',1,1,'A')


--Lighting
INSERT INTO [ProductCategory] VALUES('21027','Lighting','18397',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21023','Ceiling Lights','21027',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21024','Floor Lamps','21027',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21025','Outdoor Lighting','21027',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21026','Table & Desk Lamps','21027',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21023','Ceiling Lights','21027',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21023','Ceiling Lights','21027',1,1,'A')
update [ProductCategory] set  CategoryName='Other Lighting',ParentCategoryID='21027' where ID=230 and CategoryID='20085'


--Appliances
INSERT INTO [ProductCategory] VALUES('21002','Blenders, Juicers & Food processors','20088',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21000','Coffee Machines','20088',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21003','Microwaves','20088',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21001','Sewing Machines','20088',1,1,'A')


--Furniture
INSERT INTO [ProductCategory] VALUES('21005','Armchairs','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21010','Bedside Tables','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21013','Bookcases & Shelves','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21011','Buffets & Side Tables','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21014','Cabinets','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21009','Coffee Tables','20073',1,1,'A')
update [ProductCategory] set CategoryName='Dining Chairs' where ID=207 and CategoryID='20075'
update [ProductCategory] set CategoryName='Dining Tables' where ID=204 and CategoryID='20080'
INSERT INTO [ProductCategory] VALUES('21015','Dressers & Drawers','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21012','Entertainment & TV Units','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21006','Office Chairs','20073',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21007','Stools & Bar stools','20073',1,1,'A')


--Garden
INSERT INTO [ProductCategory] VALUES('21016','Lounging & Relaxing Furniture','18398',1,1,'A')
update [ProductCategory] set CategoryName='Outdoor Dining Furniture' where ID=225 and CategoryID='20070'
INSERT INTO [ProductCategory] VALUES('21017','Parasols & Gazebos','18398',1,1,'A')
update [ProductCategory] set CategoryName='Plants' where ID=223 and CategoryID='20102'
INSERT INTO [ProductCategory] VALUES('21018','Pots & Garden Beds','18398',1,1,'A')
update [ProductCategory] set CategoryName='Sheds & Storage' where ID=228 and CategoryID='20072'


--Home Decor
INSERT INTO [ProductCategory] VALUES('21021','Clocks','20082',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21022','Decorative Accessories','20082',1,1,'A')
update [ProductCategory] set CategoryName='Manchester & Textiles' where ID=231 and CategoryID='20083'
INSERT INTO [ProductCategory] VALUES('21019','Picture Frames','20082',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21020','Vases & Bowls','20082',1,1,'A')


--Tools & DIY
INSERT INTO [ProductCategory] VALUES('21034','Garden Tools','18430',1,1,'A')


--Cars & Vehicles
INSERT INTO [ProductCategory] VALUES('21129','Construction Vehicles & Equipment','9299',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21133','Farming Vehicles & Equipment','9299',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21140','Trucks','9299',1,1,'A')


--Construction Vehicles & Equipment
INSERT INTO [ProductCategory] VALUES('21131','Construction Equipment','21129',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21130','Construction Vehicles','21129',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21132','Other Construction Vehicles & Equipment','21129',1,1,'A')


--Farming Vehicles & Equipment
INSERT INTO [ProductCategory] VALUES('21135','Farming Equipment','21133',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21134','Farming Vehicles','21133',1,1,'A')
INSERT INTO [ProductCategory] VALUES('21136','Other Farming Vehicles & Equipment','21133',1,1,'A')


--Motorcycles & Scooters
update [ProductCategory] set CategoryName='Quads, Karts & Other' where ID=198 and CategoryID='18630'


--Parts & Accessories
INSERT INTO [ProductCategory] VALUES('20104','Caravan & Campervan Accessories','18323',1,1,'A')
update [ProductCategory] set  CategoryName='Motorcycle & Scooter Accessories',ParentCategoryID='18323' where ID=195 and CategoryID='18627'
update [ProductCategory] set  CategoryName='Motorcycle & Scooter Parts',ParentCategoryID='18323' where ID=196 and CategoryID='18628'


--Trucks
update [ProductCategory] set  CategoryName='Truck Parts',ParentCategoryID='21140' where ID=192 and CategoryID='18481'
INSERT INTO [ProductCategory] VALUES('21128','Trucks','21140',1,1,'A')