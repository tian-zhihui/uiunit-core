
SET NOCOUNT ON
GO

USE master
GO
if exists (select * from sysdatabases where name='EastWindProduction')
		drop database EastWindProduction
go

DECLARE @device_directory NVARCHAR(520)
SELECT @device_directory = SUBSTRING(filename, 1, CHARINDEX(N'master.mdf', LOWER(filename)) - 1)
FROM master.dbo.sysaltfiles WHERE dbid = 1 AND fileid = 1

EXECUTE (N'CREATE DATABASE EastWindProduction
  ON PRIMARY (NAME = N''EastWindProduction'', FILENAME = N''' + @device_directory + N'EastWindProduction.mdf'')
  LOG ON (NAME = N''EastWindProduction_log'',  FILENAME = N''' + @device_directory + N'EastWindProduction.ldf'')')
go

exec sp_dboption 'EastWindProduction','trunc. log on chkpt.','true'
exec sp_dboption 'EastWindProduction','select into/bulkcopy','true'
GO

set quoted_identifier on
GO

/* Set DATEFORMAT so that the date strings are interpreted correctly regardless of
   the default DATEFORMAT on the server.
*/
SET DATEFORMAT mdy
GO
use "EastWindProduction"
go



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Orders](
	[ID] [varchar](50) NOT NULL,
	[Customer] [nchar](5)NULL,
	[Employee] [int] NULL,
	[Order_Date] [datetime] NULL,
	[Required_Date] [datetime] NULL,
	[Shipped_Date] [datetime] NULL,
	[ShipVia] [smallint] NULL,
	[Freight] [money] NULL,
	[ShipName] [nvarchar](60) NULL,
	[ShipAddress] [nvarchar](60) NULL,
	[ShipCity] [nvarchar](15) NULL,
	[ShipRegion] [nvarchar](15) NULL,
	[ShipPostalCode] [nvarchar](10) NULL,
	[ShipCountry] [nvarchar](15) NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF

/****** Object:  Table [dbo].[Order Details]    Script Date: 08/09/2007 10:14:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Order Details](
	[ID] [varchar](50) NOT NULL,
	[ProductID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[Discount] [real] NOT NULL,
 CONSTRAINT [PK_Order Details] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[ProductID] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Order Details]  WITH CHECK ADD  CONSTRAINT [FK_Order Details_Orders] FOREIGN KEY([ID])
REFERENCES [dbo].[Orders] ([ID])
GO
ALTER TABLE [dbo].[Order Details] CHECK CONSTRAINT [FK_Order Details_Orders]