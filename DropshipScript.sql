IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eBayItem]') AND type in (N'U'))
DROP TABLE [dbo].[eBayItem]
GO
CREATE TABLE [dbo].[eBayItem](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SKU] [varchar](500) NOT NULL,
	[BuyItNowPrice] [decimal](18, 2) NOT NULL,
	[Title] [varchar](500) NOT NULL,
	[Description] [varchar](4000) NOT NULL,
	[ImagesURL] [varchar](4000) NOT NULL,
	[CategoryID] INT NOT NULL,
	[InventoryQty] INT NOT NULL,
 CONSTRAINT [PK_eBayItem] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO