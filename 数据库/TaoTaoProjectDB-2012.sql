USE [master]
GO
/****** Object:  Database [TaoTaoProjectDB]    Script Date: 2023/4/29 14:53:45 ******/
CREATE DATABASE [TaoTaoProjectDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TaoTaoProjectDB', FILENAME = N'G:\SQL2022\TaoTaoProjectDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TaoTaoProjectDB_log', FILENAME = N'G:\SQL2022\TaoTaoProjectDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TaoTaoProjectDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TaoTaoProjectDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TaoTaoProjectDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TaoTaoProjectDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TaoTaoProjectDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TaoTaoProjectDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET RECOVERY FULL 
GO
ALTER DATABASE [TaoTaoProjectDB] SET  MULTI_USER 
GO
ALTER DATABASE [TaoTaoProjectDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TaoTaoProjectDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TaoTaoProjectDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TaoTaoProjectDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'TaoTaoProjectDB', N'ON'
GO
USE [TaoTaoProjectDB]
GO
/****** Object:  Table [dbo].[address]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[address](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[address] [varchar](250) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[phone] [varchar](12) NOT NULL,
	[mark] [varchar](50) NULL,
	[createtime] [date] NULL,
	[uid] [int] NULL,
 CONSTRAINT [PK_address] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[admin]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[admin](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[pwd] [varchar](50) NOT NULL,
	[nickname] [varchar](50) NOT NULL,
	[power] [smallint] NOT NULL,
	[createtime] [date] NULL,
 CONSTRAINT [PK_admin] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[category]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[category](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[catename] [varchar](50) NULL,
 CONSTRAINT [PK_category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[comment]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[comment](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[detail] [varchar](50) NOT NULL,
	[uid] [int] NOT NULL,
	[shop_id] [int] NOT NULL,
	[createtime] [date] NULL,
 CONSTRAINT [PK_comment] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NULL,
	[order_num] [varchar](50) NULL,
	[sum_price] [decimal](8, 2) NULL,
	[mark] [varchar](50) NULL,
	[createtime] [date] NULL,
	[is_pay] [smallint] NULL,
	[state] [smallint] NULL,
	[pay_way] [varchar](20) NULL,
	[address_id] [int] NULL,
	[address] [varchar](250) NULL,
	[name] [varchar](50) NULL,
	[phone] [varchar](12) NULL,
 CONSTRAINT [PK_order] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[order_detail]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[order_detail](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[order_id] [int] NULL,
	[count] [int] NULL,
	[price] [decimal](8, 2) NULL,
	[sum_price] [decimal](8, 2) NULL,
	[shop_id] [int] NULL,
	[title] [varchar](255) NULL,
 CONSTRAINT [PK_order_detail] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[shop_car]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[shop_car](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[uid] [int] NULL,
	[shopid] [int] NULL,
	[shopNum] [int] NULL,
	[createtime] [date] NULL,
 CONSTRAINT [PK_shop_car] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[shopping]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[shopping](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [varchar](255) NOT NULL,
	[cid] [int] NULL,
	[price] [decimal](8, 2) NOT NULL,
	[sale_price] [decimal](8, 2) NULL,
	[number] [int] NOT NULL,
	[detail] [text] NOT NULL,
	[img] [varchar](255) NOT NULL,
	[shop_number] [varchar](255) NOT NULL,
 CONSTRAINT [PK_shopping] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user]    Script Date: 2023/4/29 14:53:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[pwd] [varchar](50) NOT NULL,
	[nickname] [varchar](50) NOT NULL,
	[sex] [smallint] NULL,
	[introduce] [varchar](50) NULL,
	[age] [int] NULL,
	[img] [varchar](200) NULL,
 CONSTRAINT [PK_user] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

SET IDENTITY_INSERT [dbo].[address] ON

INSERT INTO [dbo].[address] ([id], [address], [name], [phone], [mark], [createtime], [uid]) VALUES (1, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 3-201', N'Chen Mingfeng', N'18877881232', N'Home', CAST(N'2023-04-27' AS Date), 2)
INSERT INTO [dbo].[address] ([id], [address], [name], [phone], [mark], [createtime], [uid]) VALUES (3, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 5-201', N'Chen Mingming', N'18877881231', N'Company', CAST(N'2023-04-27' AS Date), 3)
INSERT INTO [dbo].[address] ([id], [address], [name], [phone], [mark], [createtime], [uid]) VALUES (4, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 3-201', N'Chen Yu', N'18877881231', N'Home Address', CAST(N'2023-04-29' AS Date), 4)
INSERT INTO [dbo].[address] ([id], [address], [name], [phone], [mark], [createtime], [uid]) VALUES (5, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 3-201', N'Wang Yu', N'18877881231', N'Home Address', CAST(N'2023-04-29' AS Date), 8)
INSERT INTO [dbo].[address] ([id], [address], [name], [phone], [mark], [createtime], [uid]) VALUES (6, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 3-201', N'Liu Xiaoxia', N'18877881231', N'Home Address', CAST(N'2023-04-29' AS Date), 11)
INSERT INTO [dbo].[address] ([id], [address], [name], [phone], [mark], [createtime], [uid]) VALUES (7, N'Guangdong Province, Shenzhen City, Nanshan District, Xinshan Road Community 3-201', N'Liu Lixia', N'18877881232', N'Company Address', CAST(N'2023-04-29' AS Date), 11)
SET IDENTITY_INSERT [dbo].[address] OFF
GO
SET IDENTITY_INSERT [dbo].[admin] ON

INSERT INTO [dbo].[admin] ([id], [username], [pwd], [nickname], [power], [createtime]) VALUES (1, N'admin', N'admin', N'Wang Fei', 1, CAST(N'2023-04-20' AS Date))
INSERT INTO [dbo].[admin] ([id], [username], [pwd], [nickname], [power], [createtime]) VALUES (3, N'admin2', N'admin2', N'Chen Xiao', 0, CAST(N'2023-04-20' AS Date))
INSERT INTO [dbo].[admin] ([id], [username], [pwd], [nickname], [power], [createtime]) VALUES (4, N'123', N'123', N'Minmin', 0, CAST(N'2023-04-12' AS Date))
SET IDENTITY_INSERT [dbo].[admin] OFF
GO
SET IDENTITY_INSERT [dbo].[category] ON

INSERT INTO [dbo].[category] ([id], [catename]) VALUES (1, N'Food')
INSERT INTO [dbo].[category] ([id], [catename]) VALUES (3, N'Digital')
INSERT INTO [dbo].[category] ([id], [catename]) VALUES (4, N'Specialty')
INSERT INTO [dbo].[category] ([id], [catename]) VALUES (5, N'Others')
INSERT INTO [dbo].[category] ([id], [catename]) VALUES (6, N'Snacks')
INSERT INTO [dbo].[category] ([id], [catename]) VALUES (7, N'Sports')
INSERT INTO [dbo].[category] ([id], [catename]) VALUES (8, N'Cosmetics')
SET IDENTITY_INSERT [dbo].[category] OFF
GO
SET IDENTITY_INSERT [dbo].[comment] ON

INSERT INTO [dbo].[comment] ([id], [detail], [uid], [shop_id], [createtime]) VALUES (3, N'This product is great!', 2, 2, CAST(N'2023-01-01' AS Date))
INSERT INTO [dbo].[comment] ([id], [detail], [uid], [shop_id], [createtime]) VALUES (6, N'I really like this piece of clothing!', 2, 11, CAST(N'2023-04-29' AS Date))
INSERT INTO [dbo].[comment] ([id], [detail], [uid], [shop_id], [createtime]) VALUES (7, N'I really like this food, hope to restock soon~', 4, 13, CAST(N'2023-04-29' AS Date))
SET IDENTITY_INSERT [dbo].[comment] OFF
GO
SET IDENTITY_INSERT [dbo].[order] ON 

INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (3, 2, N'o230428SS10', CAST(16.80 AS Decimal(8, 2)), N'Send by postal!', CAST(N'2023-04-28' AS Date), 1, 3, N'Alipay', 1, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (5, 2, N'o230428SS10', CAST(49.90 AS Decimal(8, 2)), N'Test order!', CAST(N'2023-04-28' AS Date), 1, 0, N'WeChat', 1, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (6, 2, N'o230429SS11', CAST(10088.80 AS Decimal(8, 2)), N'Send by SF Express!', CAST(N'2023-04-29' AS Date), 1, 2, N'Alipay', 1, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (7, 2, N'o230429SS11', CAST(19.90 AS Decimal(8, 2)), N'', CAST(N'2023-04-29' AS Date), 1, 0, N'Alipay', 1, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (8, 2, N'o230429SS11', CAST(10068.80 AS Decimal(8, 2)), N'Send by SF Express!', CAST(N'2023-04-29' AS Date), 1, 0, N'Alipay', 1, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (9, 2, N'o230429SS11', CAST(39.80 AS Decimal(8, 2)), N'I really like dried mango~', CAST(N'2023-04-29' AS Date), 1, 0, N'WeChat', 1, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (10, 4, N'o230429SS12', CAST(9.90 AS Decimal(8, 2)), N'Can you ship it after 2 days!', CAST(N'2023-04-29' AS Date), 1, 0, N'Alipay', 1, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (11, 2, N'o230429SS02', CAST(13999.00 AS Decimal(8, 2)), N'Test', CAST(N'2023-04-29' AS Date), 1, 0, N'Alipay', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (12, 2, N'o230429SS02', CAST(19.90 AS Decimal(8, 2)), N'', CAST(N'2023-04-29' AS Date), 1, 0, N'Alipay', NULL, NULL, NULL, NULL)
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (13, 2, N'o230429SS02', CAST(14008.90 AS Decimal(8, 2)), N'Ship as soon as possible, thank you~', CAST(N'2023-04-29' AS Date), 1, 1, N'Alipay', 1, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 3-201', N'Chen Mingfeng', N'18877881232')
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (14, 8, N'o230429SS02', CAST(7999.00 AS Decimal(8, 2)), N'I really like it~', CAST(N'2023-04-29' AS Date), 1, 0, N'WeChat', 5, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 3-201', N'Wang Yu', N'18877881231')
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (15, 11, N'o230429SS02', CAST(8068.80 AS Decimal(8, 2)), N'Please send by SF Express!', CAST(N'2023-04-29' AS Date), 1, 0, N'WeChat', 7, N'Guangdong Province, Shenzhen City, Nanshan District, Xinshan Road Community 3-201', N'Liu Lixia', N'18877881232')
INSERT INTO [dbo].[order] ([id], [uid], [order_num], [sum_price], [mark], [createtime], [is_pay], [state], [pay_way], [address_id], [address], [name], [phone]) VALUES (16, 11, N'o230429SS02', CAST(15998.00 AS Decimal(8, 2)), N'Please pack it well!', CAST(N'2023-04-29' AS Date), 1, 1, N'Bank Card', 6, N'Guangdong Province, Zhongshan City, Chaoyang District, Xinshan Road Community 3-201', N'Liu Xiaoxia', N'18877881231')
SET IDENTITY_INSERT [dbo].[order] OFF

GO
SET IDENTITY_INSERT [dbo].[order_detail] ON 

INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (1, 3, 1, CAST(6.90 AS Decimal(8, 2)), CAST(6.90 AS Decimal(8, 2)), 9, N'Bread')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (2, 3, 8, CAST(9.90 AS Decimal(8, 2)), CAST(79.20 AS Decimal(8, 2)), 13, N'Dali Garden Egg Yolk Pie')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (3, 5, 1, CAST(30.00 AS Decimal(8, 2)), CAST(30.00 AS Decimal(8, 2)), 11, N'Apple Pie Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (4, 5, 1, CAST(19.90 AS Decimal(8, 2)), CAST(19.90 AS Decimal(8, 2)), 12, N'Dried Mango Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (5, 6, 3, CAST(9.90 AS Decimal(8, 2)), CAST(29.70 AS Decimal(8, 2)), 13, N'Dali Garden Egg Yolk Pie')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (6, 6, 1, CAST(9999.00 AS Decimal(8, 2)), CAST(9999.00 AS Decimal(8, 2)), 8, N'Moisturizing Cream')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (7, 6, 1, CAST(49.90 AS Decimal(8, 2)), CAST(49.90 AS Decimal(8, 2)), 10, N'Osmanthus Cake Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (8, 6, 1, CAST(30.00 AS Decimal(8, 2)), CAST(30.00 AS Decimal(8, 2)), 11, N'Apple Pie Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (9, 7, 2, CAST(19.90 AS Decimal(8, 2)), CAST(39.80 AS Decimal(8, 2)), 12, N'Dried Mango Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (10, 8, 2, CAST(9999.00 AS Decimal(8, 2)), CAST(19998.00 AS Decimal(8, 2)), 8, N'Moisturizing Cream')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (11, 8, 3, CAST(49.90 AS Decimal(8, 2)), CAST(149.70 AS Decimal(8, 2)), 10, N'Osmanthus Cake Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (12, 8, 1, CAST(19.90 AS Decimal(8, 2)), CAST(19.90 AS Decimal(8, 2)), 12, N'Dried Mango Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (13, 9, 2, CAST(19.90 AS Decimal(8, 2)), CAST(39.80 AS Decimal(8, 2)), 12, N'Dried Mango Specialty')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (14, 10, 2, CAST(9.90 AS Decimal(8, 2)), CAST(19.80 AS Decimal(8, 2)), 13, N'Dali Garden Egg Yolk Pie')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (15, 11, 1, CAST(13999.00 AS Decimal(8, 2)), CAST(13999.00 AS Decimal(8, 2)), 16, N'Vidda Hisense R43 2023 Model 43-Inch Metal Eye Care Full Screen Ultra-thin TV Smart Screen Full HD Smart LCD TV Trade-in 43V1H-R')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (16, 12, 1, CAST(19.90 AS Decimal(8, 2)), CAST(19.90 AS Decimal(8, 2)), 12, N'Bestore Light Sweet Dried Mango Slices 80g')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (17, 13, 1, CAST(9.90 AS Decimal(8, 2)), CAST(9.90 AS Decimal(8, 2)), 13, N'Junchentang Japan Snacks Natural Flavor Finger Biscuits Grinding Biscuits Small Cookies Crisp Round Biscuits 85g')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (18, 13, 1, CAST(13999.00 AS Decimal(8, 2)), CAST(13999.00 AS Decimal(8, 2)), 16, N'Vidda Hisense R43 2023 Model 43-Inch Metal Eye Care Full Screen Ultra-thin TV Smart Screen Full HD Smart LCD TV Trade-in 43V1H-R')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (19, 14, 1, CAST(7999.00 AS Decimal(8, 2)), CAST(7999.00 AS Decimal(8, 2)), 15, N'Apple MacBook Air 13.3 M1 Chip (7-Core GPU) 8G 256G SSD Space Gray Laptop MGN63CH/A')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (20, 15, 1, CAST(19.90 AS Decimal(8, 2)), CAST(19.90 AS Decimal(8, 2)), 12, N'Bestore Light Sweet Dried Mango Slices 80g')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (21, 15, 1, CAST(49.90 AS Decimal(8, 2)), CAST(49.90 AS Decimal(8, 2)), 10, N'Jiuyiliang Traditional Handmade Quick-frozen Cake 700g')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (22, 15, 1, CAST(7999.00 AS Decimal(8, 2)), CAST(7999.00 AS Decimal(8, 2)), 15, N'Apple MacBook Air 13.3 M1 Chip (7-Core GPU) 8G 256G SSD Space Gray Laptop MGN63CH/A')
INSERT INTO [dbo].[order_detail] ([id], [order_id], [count], [price], [sum_price], [shop_id], [title]) VALUES (23, 16, 2, CAST(7999.00 AS Decimal(8, 2)), CAST(15998.00 AS Decimal(8, 2)), 15, N'Apple MacBook Air 13.3 M1 Chip (7-Core GPU) 8G 256G SSD Space Gray Laptop MGN63CH/A')
SET IDENTITY_INSERT [dbo].[order_detail] OFF

GO
SET IDENTITY_INSERT [dbo].[shop_car] ON 

INSERT [dbo].[shop_car] ([id], [uid], [shopid], [shopNum], [createtime]) VALUES (20, 8, 16, 2, CAST(N'2023-04-29' AS Date))
INSERT [dbo].[shop_car] ([id], [uid], [shopid], [shopNum], [createtime]) VALUES (21, 8, 5, 1, CAST(N'2023-04-29' AS Date))
SET IDENTITY_INSERT [dbo].[shop_car] OFF
GO
SET IDENTITY_INSERT [dbo].[shopping] ON 



INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (2, N'NEW BALANCE Official Men\'s Shoes 1080 v12 FreshFoam Comfortable Cushioning Breathable Professional Running Shoes Light Grey M1080Y12 Standard Width D 42.5 (27cm)', 8, CAST(129.00 AS Decimal(8, 2)), CAST(99.00 AS Decimal(8, 2)), 1000, N'<p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/61131/19/24190/23856/63ec732bF3e3d32d6/05ca8aba35053c18.png.avif"/></p><p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/33763/14/19595/93761/63ec732eF14b93525/469bc42d22e48462.png.avif"/><img src="https://img10.360buyimg.com/imgzone/jfs/t1/149904/29/28860/53726/63ec7331F063d0e42/a044dcb6d71161b5.png.avif"/></p>', N'/Content/image/day_1.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (3, N'CAMEL Yoga Set Women\'s Fitness Sportswear Five-piece Set YK2225L5493 Light Purple/Smoky Purple M', 8, CAST(199.00 AS Decimal(8, 2)), CAST(99.00 AS Decimal(8, 2)), 1000, N'<p><img src="https://img30.360buyimg.com/sku/jfs/t1/154913/7/2150/163530/5f856697Ecfebf739/038a28d50fd7b24b.jpg.avif"/></p><p><img src="https://img30.360buyimg.com/sku/jfs/t1/125518/13/14777/337747/5f856697E66bb27b4/806b47ea3762b82f.jpg.avif"/></p>', N'/Content/image/day_2.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (4, N'Warrior Men\'s Sports Shoes Spring/Summer Breathable Mesh Flywoven Lightweight Soft Sole Running Shoes Official', 8, CAST(129.00 AS Decimal(8, 2)), CAST(99.00 AS Decimal(8, 2)), 1000, N'<p><img src="http://img30.360buyimg.com/popWareDetail/jfs/t1/198739/12/21600/190678/62490c77Eada9aafa/87f6164549016fec.jpg.avif"/></p><p><img src="http://img30.360buyimg.com/popWareDetail/jfs/t1/188815/22/22473/151704/62490c77E97792c51/225001e91c57c8ea.jpg.avif"/></p>', N'/Content/image/day_3.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (5, N'YINGHU Fitness Running Sports Suit Men/Women Spring/Autumn Basketball Training Clothes Morning Run High Elastic Quick-drying Five-piece Set (Four-season Recommended) XL [130-145kg]', 8, CAST(199.00 AS Decimal(8, 2)), CAST(100.00 AS Decimal(8, 2)), 1000, N'<p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/20212/16/16401/265499/62a18a72E6bbba0b4/f184b87234824e73.jpg.avif"/></p><p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/184811/14/25509/206944/62a18a72E1fa63d02/3140a4a461f022f7.jpg.avif"/></p>', N'/Content/image/day_4.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (6, N'ROLEX Men\'s Watch Submariner Series Green Steel Automatic Mechanical m126610lv-0002', 8, CAST(12999.00 AS Decimal(8, 2)), CAST(9999.00 AS Decimal(8, 2)), 1000, N'<ul class="parameter2 p-parameter-list list-paddingleft-2" style="list-style-type: none;"><li><p>Product Name: ROLEX m126610lv-0002</p></li><li><p>Product ID: 10064188564511</p></li><li><p>Shop: &nbsp;<a href="https://mall.jd.com/index-12362353.html?from=pc" target="_blank" style="margin: 0px; padding: 0px; color: rgb(94, 105, 173); text-decoration-line: none;">Lishangwanglai Watch Store</a></p></li><li><p>Product Weight: 1.0kg</p></li><li><p>Model Number: m126610lv-0002</p></li><li><p>Case Material: Steel</p></li><li><p>Movement: Automatic Mechanical</p></li><li><p>Functions: Date Display, Luminous, Three Hands</p></li><li><p>Dial Shape: Round</p></li><li><p>Case Back: Solid</p></li><li><p>Band Material: Steel</p></li><li><p>Display Type: Pointer</p></li><li><p>Dial Color: Black</p></li><li><p>Crystal Material: Sapphire Crystal Glass</p></li><li><p>Case Diameter: 40-43mm</p></li><li><p>Buckle Type: Folding Clasp</p></li><li><p>Style: Sports</p></li><li><p>Water Resistance: 300m</p></li><li><p>Gender: Men</p></li><li><p>Case Material: Steel</p></li></ul><p><img src="http://img30.360buyimg.com/popWareDetail/jfs/t1/96493/35/33079/95903/635b77bbE773d4db1/17a36489eb21887f.jpg.avif"/></p><p>&nbsp;<img src="http://img30.360buyimg.com/popWareDetail/jfs/t1/89637/28/32763/81005/635b77bbEe2ac2743/2949e8df3600f751.jpg.avif"/><img src="http://img30.360buyimg.com/popWareDetail/jfs/t1/172848/22/29649/73648/635b77bbEd5bcd4da/26a42ef797a2202b.jpg.avif"/></p>', N'/Content/image/day_5.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (7, N'Swiss Certified Women\'s Fashion Watch Waterproof Luminous Automatic Mechanical Tungsten Steel Business Sports Goldshield Women\'s Watch White Face', 8, CAST(1299.00 AS Decimal(8, 2)), CAST(999.00 AS Decimal(8, 2)), 1000, N'<p><img src="http://img30.360buyimg.com/popWareDetail/jfs/t1/196877/21/3796/232075/611caaa8E43d8e400/c3d4835853a948ae.jpg.avif"/></p><p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/182721/11/19956/181587/611caa86E36131129/0bc9de26be2f6d84.jpg.avif"/></p>', N'/Content/image/day_6.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (8, N'HD Large Capacity Sports Water Bottle Black 1.7L', 4, CAST(19.00 AS Decimal(8, 2)), CAST(9.10 AS Decimal(8, 2)), 998, N'<ul class="p-parameter-list list-paddingleft-2" style="list-style-type: none;"><li><p>Brand: &nbsp;<a href="https://list.jd.com/list.html?cat=6196,6219,6850&ev=exbrand_368495" target="_blank" style="margin: 0px; padding: 0px; color: rgb(94, 105, 173); text-decoration-line: none;">HD</a></p></li><li><p>Product Name: HD Large Capacity Sports Water Bottle Black 1.7L</p></li><li><p>Product ID: 10052422060501</p></li><li><p>Shop: &nbsp;<a href="https://mall.jd.com/index-12057239.html?from=pc" target="_blank" style="margin: 0px; padding: 0px; color: rgb(94, 105, 173); text-decoration-line: none;">Ceguan Kitchen Store</a></p></li><li><p>Product Weight: 1.0kg</p></li><li><p>Model Number: Ceguan Water Bottle</p></li><li><p>Material: Modified PCT</p></li><li><p>Capacity: 1501-2000mL</p></li><li><p>Features: Straw</p></li><li><p>Applicable: Universal</p></li><li><p>Lid Style: Screw Cap</p></li><li><p>Additional Components: Handle</p></li><li><p>Body Style: Large Belly Cup</p></li><li><p>Liner Material: PC</p></li><li><p>Origin: Domestic</p></li></ul><p><img src="https://img20.360buyimg.com/imgzone/jfs/t1/188624/12/24718/216131/6283adb4Ea0940517/db811f2d5728180f.jpg.avif"/></p><p><img src="https://img30.360buyimg.com/imgzone/jfs/t1/84060/12/18704/88398/6283adb5E165d9f8f/a60cb795a5906234.jpg.avif"/></p>', N'/Content/image/day_7.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (9, N'Oushengsheng Milk Flavored Cookies 1000g', 1, CAST(9.90 AS Decimal(8, 2)), CAST(6.90 AS Decimal(8, 2)), 1000, N'<ul class="parameter2 p-parameter-list list-paddingleft-2" style="list-style-type: none;"><li><p>Product Name: Oushengsheng Milk Flavored Cookies 1000g</p></li><li><p>Product ID: 100024763230</p></li><li><p>Product Weight: 1.16kg</p></li><li><p>Place of Origin: Mainland China</p></li><li><p>Type: Crispy Cookies</p></li><li><p>Flavor: Milk</p></li><li><p>Packaging: Box</p></li><li><p>Total Net Weight: 501g-1kg</p></li><li><p>Origin: Domestic</p></li></ul><p><img src="https://img30.360buyimg.com/sku/jfs/t1/190170/10/17141/526040/610cb09dE1275952d/1915eb222adfe3eb.jpg.avif"/></p><p><img src="https://img30.360buyimg.com/sku/jfs/t1/186956/11/17019/237607/610cb09dE3718dd89/019a7a6bd32e39b5.jpg.avif"/></p>', N'/Content/image/day_9.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (10, N'Jiuyiliang Traditional Handmade Frozen Cake Glutinous Rice Cake Breakfast Semi-finished Dessert Cantonese White Sugar Osmanthus Cake 350g*2 bags', 4, CAST(59.50 AS Decimal(8, 2)), CAST(49.90 AS Decimal(8, 2)), 996, N'<p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/134053/11/25341/642260/621f38dfE84cb78a5/b5756b0dbcd1225e.jpg.avif"/></p><p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/136235/33/24223/523892/621f38dfEd70b1f21/8482f18c5eff62e0.jpg.avif"/></p>', N'/Content/image/33.png', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (11, N'Bimbo Stuffed Bread Nutritional Breakfast Snack Red Bean Paste Apple Pie Jam Western Pastry Apple Pie/100g', 4, CAST(69.00 AS Decimal(8, 2)), CAST(30.00 AS Decimal(8, 2)), 1000, N'<p>Brand: Bimbo</p><p>Product Name: Bimbo Stuffed Bread Nutritional Breakfast Snack Red Bean Paste Apple Pie Jam Western Pastry Apple Pie/100g</p><p>Product ID: 10026657906164</p><p>Shop: BIMBO Official Flagship Store</p><p>Weight: 100.00g</p><p>Packaging: Bag</p><p>Total Net Weight: ≤200g</p><p>Origin: Domestic</p><p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/216304/10/5842/571277/61a0832fE0ac26412/7ae1b4b18e672b3a.jpg.avif"/></p><p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/123004/24/25590/373385/6225bec3Ed64e42ac/3446e1d35784eda5.jpg.avif"/><img src="https://img10.360buyimg.com/imgzone/jfs/t1/156858/32/25457/637347/61a0832fE339637fb/33ac5241f68f63d3.jpg.avif"/></p>', N'/Content/image/11.png', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (12, N'Bestore Light Sweet Dried Mango Slices 80g', 4, CAST(29.00 AS Decimal(8, 2)), CAST(19.90 AS Decimal(8, 2)), 993, N'<ul class="parameter2 p-parameter-list list-paddingleft-2" style="list-style-type: none;"><li><p>Product Name: Bestore Dried Mango</p></li><li><p>Product ID: 100010183662</p></li><li><p>Weight: 90.00g</p></li><li><p>Place of Origin: Zhangzhou, Fujian Province</p></li><li><p>Processing Method: Dried Fruit</p></li><li><p>Packaging: Bag</p></li><li><p>Total Net Weight: ≤200g</p></li><li><p>Origin: Domestic</p></li></ul><p><img src="https://img30.360buyimg.com/sku/jfs/t1/87612/7/9365/597426/5e0d8ca0Ed4d131b9/15ef8da735492134.jpg.avif"/></p><p><img src="https://img30.360buyimg.com/sku/jfs/t1/84936/7/9334/512486/5e0d8ca0E62f61609/f30eef44766372c4.jpg.avif"/></p>', N'/Content/image/22.png', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (13, N'Junchentang Japanese Snacks Natural Flavor Finger Biscuits Teething Biscuits Small Cookies Crispy Round Biscuits 85g', 1, CAST(19.90 AS Decimal(8, 2)), CAST(9.90 AS Decimal(8, 2)), 997, N'<p style="margin-top: 1.12em; margin-bottom: 1.12em; padding: 0px; color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; white-space: normal; background-color: rgb(255, 255, 255);"><span style="margin: 0px; padding: 0px; color: rgb(255, 0, 0);"><span style="margin: 0px; padding: 0px; font-family: kaiti_gb2312;"><span style="margin: 0px; padding: 0px; font-size: 18px;"><strong style="margin: 0px; padding: 0px;">Shelf Life:</strong></span></span></span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Crispy Round Biscuits: 2023.9.2</span>,<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;"> Milk Biscuits 2023.11</span>,<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;"> Soda Cheese Biscuits: 2023.9.30</span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Crispy Sandwich Biscuits: Vanilla Wafers: 2023.7.28</span></p><p><span style="color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; background-color: rgb(255, 255, 255);">\\</span></p><p style="margin-top: 1.12em; margin-bottom: 1.12em; padding: 0px; color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; white-space: normal; background-color: rgb(255, 255, 255);"><span style="margin: 0px; padding: 0px; color: rgb(255, 0, 0);"><span style="margin: 0px; padding: 0px; font-family: kaiti_gb2312;"><span style="margin: 0px; padding: 0px; font-size: 18px;"><strong style="margin: 0px; padding: 0px;">Origin: Japan</strong></span></span></span></p><p><span style="color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; background-color: rgb(255, 255, 255);">\\</span></p><p style="margin-top: 1.12em; margin-bottom: 1.12em; padding: 0px; color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; white-space: normal; background-color: rgb(255, 255, 255);"><span style="margin: 0px; padding: 0px; color: rgb(255, 0, 0);"><span style="margin: 0px; padding: 0px; font-family: kaiti_gb2312;"><span style="margin: 0px; padding: 0px; font-size: 18px;"><strong style="margin: 0px; padding: 0px;">Specification:</strong></span></span></span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Crispy Round Biscuits 85g&nbsp;</span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Milk Biscuits 130g&nbsp;</span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Milk Flavored Mini Buns 90g&nbsp;</span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Finger Biscuits 132g&nbsp;</span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Soda Cheese Biscuits 75g&nbsp;</span>&nbsp;<span style="margin: 0px; padding: 0px; color: rgb(50, 59, 68); font-size: 12px;">Crispy Sandwich Biscuits 110g</span></p><p><span style="color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; background-color: rgb(255, 255, 255);">\\</span></p><p style="margin-top: 1.12em; margin-bottom: 1.12em; padding: 0px; color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; white-space: normal; background-color: rgb(255, 255, 255);"><span style="margin: 0px; padding: 0px; color: rgb(255, 0, 0);"><span style="margin: 0px; padding: 0px; font-family: kaiti_gb2312;"><span style="margin: 0px; padding: 0px; font-size: 18px;"><strong style="margin: 0px; padding: 0px;">Ingredients:</strong> See Chinese label</span></span></span></p><p><span style="color: rgb(117, 117, 117); font-family: pingfangSC; font-size: 14px; background-color: rgb(255, 255, 255);">\\</span></p><p>\</p><p style="margin-top: 1.12em; margin-bottom: 1.12em; padding: 0px;"><span style="margin: 0px; padding: 0px; color: rgb(255, 0, 0);"><span style="margin: 0px; padding: 0px; font-family: kaiti_gb2312;"><span style="margin: 0px; padding: 0px; font-size: 18px;"><strong style="margin: 0px; padding: 0px;">Introduction:</strong></span></span></span></p><p>\\</p><p style="margin-top: 1.12em; margin-bottom: 1.12em; padding: 0px;"><span style="margin: 0px; padding: 0px; color: rgb(0, 0, 0);"><span style="font-family:kaiti_gb2312"><span style="margin: 0px; padding: 0px; font-size: 18px;"><strong style="margin: 0px; padding: 0px;">Selected wheat, specially added calcium, crispy and delicious, low sugar and low oil, tasty and healthy,</strong></span></span>&nbsp;</span><strong style="margin: 0px; padding: 0px; color: rgb(0, 0, 0); font-size: 18px;"><strong style="margin: 0px; padding: 0px;"><span style="margin: 0px; padding: 0px; font-family: kaiti_gb2312;">Can be paired with milk for breakfast, convenient and quick. Enjoy a relaxing afternoon tea with a cup of coffee and a pack of biscuits in your leisure time. Take a pack with you when traveling, enjoy delicious snacks anytime, anywhere.</span></strong></strong></p><p><img src="https://img10.360buyimg.com/imgzone/jfs/t1/92017/20/38285/142203/644bfc82F5bdf25b6/ad4dd2a9250a3d98.jpg.avif"/><img src="https://img10.360buyimg.com/imgzone/jfs/t1/103926/5/38600/165766/644bfc92F763f267b/ae1e3e4b8e50190c.jpg.avif"/></p>', N'/Content/image/day_11.jpg', N'2001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (14, N'Coocaa Skyworth Computer Eight-core Host Office Desktop Computer Full Set (AMD Eight-core A9 8G 256G M.2 WiFi National Warranty) 23.8 inches', 3, CAST(8999.00 AS Decimal(8, 2)), CAST(6999.00 AS Decimal(8, 2)), 1000, N'<p><img src="https://img30.360buyimg.com/sku/jfs/t1/43004/4/19712/111791/632ee50eE4f195eb7/a6e22607f57aa547.jpg.avif"/></p><p><img src="https://img30.360buyimg.com/sku/jfs/t1/206715/27/26222/130615/632edc87Efc80396f/4a391bcea398407e.jpg.avif"/></p>', N'/Content/pic/0429135920.png', N'12001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (15, N'Apple MacBook Air 13.3 Eight-core M1 Chip (7-core GPU) 8G 256G SSD Space Gray Laptop MGN63CH/A', 3, CAST(9999.00 AS Decimal(8, 2)), CAST(7999.00 AS Decimal(8, 2)), 996, N'<p><img src="https://img11.360buyimg.com/cms/jfs/t1/72349/4/19166/1211113/629e6788E3cd28b6a/5a615371da6a820d.jpg.avif"/></p><p><img src="https://img11.360buyimg.com/cms/jfs/t1/211988/12/19452/942131/629e6788Eaa9b9cd0/dbaa7fcd80634702.jpg.avif"/></p>', N'/Content/pic/0429135836.png', N'12001010')
INSERT INTO [dbo].[shopping] ([id], [title], [cid], [price], [sale_price], [number], [detail], [img], [shop_number]) VALUES (16, N'Vidda Hisense R43 2023 Model 43-inch Metal Eye-care Full Screen Ultra-thin TV Smart Screen Full HD Smart LCD TV 43V1H-R', 3, CAST(14999.00 AS Decimal(8, 2)), CAST(13999.00 AS Decimal(8, 2)), 998, N'<p><img src="https://img30.360buyimg.com/sku/jfs/t1/107538/17/34383/75654/63be782bF41569536/78c9875d110d72dd.jpg.avif"/><img src="https://img30.360buyimg.com/sku/jfs/t1/118774/28/31786/120048/632c03a0E365b92ec/7b3d17f5ec310b7b.jpg.avif"/><img src="https://img30.360buyimg.com/sku/jfs/t1/222783/35/14608/237440/632c03a2Ee979bc41/1b7406b465cf0095.jpg.avif"/></p>', N'/Content/pic/0429133638.png', N'12001010')

SET IDENTITY_INSERT [dbo].[shopping] OFF

GO
SET IDENTITY_INSERT [dbo].[user] ON

INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (2, N'123', N'123', N'Chen Mingfeng', 1, N'Handsome guy!!', 23, N'/Content/pic/0427095647.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (3, N'1231', N'123', N'Chen Ming', 1, N'Handsome guy', 20, N'/assets/img/head.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (4, N'hello', N'hello', N'Chen Yu', 1, N'Handsome!', 33, N'/Content/pic/0429123938.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (5, N'123123', N'123123', N'Minmin!!', 1, N'Beautiful lady!!', 20, N'/assets/img/head.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (6, N'test', N'test', N'Minmin', 0, N'Beautiful lady', 22, N'/Content/pic/0411171619.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (7, N'1234', N'1234', N'Wang Feifei', NULL, NULL, NULL, N'/assets/img/head.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (8, N'zhangsan', N'123456', N'Zhang San', 1, N'Hahaha', 18, N'/Content/pic/0429140608.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (9, N'123456', N'123456', N'Wang Wu', NULL, NULL, NULL, N'/assets/img/head.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (10, N'test1', N'test1', N'Wang Wu', NULL, NULL, NULL, N'/assets/img/head.png')
INSERT INTO [dbo].[user] ([id], [username], [pwd], [nickname], [sex], [introduce], [age], [img]) VALUES (11, N'1234567', N'1234567', N'Liu Xiaoxia', 0, NULL, NULL, N'/assets/img/head.png')

SET IDENTITY_INSERT [dbo].[user] OFF

GO
ALTER TABLE [dbo].[address]  WITH CHECK ADD  CONSTRAINT [FK_address_user] FOREIGN KEY([uid])
REFERENCES [dbo].[user] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[address] CHECK CONSTRAINT [FK_address_user]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_shopping] FOREIGN KEY([shop_id])
REFERENCES [dbo].[shopping] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_shopping]
GO
ALTER TABLE [dbo].[comment]  WITH CHECK ADD  CONSTRAINT [FK_comment_user] FOREIGN KEY([uid])
REFERENCES [dbo].[user] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[comment] CHECK CONSTRAINT [FK_comment_user]
GO
ALTER TABLE [dbo].[order]  WITH CHECK ADD  CONSTRAINT [FK_order_user] FOREIGN KEY([uid])
REFERENCES [dbo].[user] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[order] CHECK CONSTRAINT [FK_order_user]
GO
ALTER TABLE [dbo].[order_detail]  WITH CHECK ADD  CONSTRAINT [FK_order_detail_order] FOREIGN KEY([order_id])
REFERENCES [dbo].[order] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[order_detail] CHECK CONSTRAINT [FK_order_detail_order]
GO
ALTER TABLE [dbo].[order_detail]  WITH CHECK ADD  CONSTRAINT [FK_order_detail_shopping] FOREIGN KEY([shop_id])
REFERENCES [dbo].[shopping] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[order_detail] CHECK CONSTRAINT [FK_order_detail_shopping]
GO
ALTER TABLE [dbo].[shop_car]  WITH CHECK ADD  CONSTRAINT [FK_shop_car_shopping] FOREIGN KEY([shopid])
REFERENCES [dbo].[shopping] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[shop_car] CHECK CONSTRAINT [FK_shop_car_shopping]
GO
ALTER TABLE [dbo].[shop_car]  WITH CHECK ADD  CONSTRAINT [FK_shop_car_user] FOREIGN KEY([uid])
REFERENCES [dbo].[user] ([id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[shop_car] CHECK CONSTRAINT [FK_shop_car_user]
GO
ALTER TABLE [dbo].[shopping]  WITH CHECK ADD  CONSTRAINT [FK_shopping_category] FOREIGN KEY([cid])
REFERENCES [dbo].[category] ([id])
GO
ALTER TABLE [dbo].[shopping] CHECK CONSTRAINT [FK_shopping_category]
GO
USE [master]
GO
ALTER DATABASE [TaoTaoProjectDB] SET  READ_WRITE 
GO
