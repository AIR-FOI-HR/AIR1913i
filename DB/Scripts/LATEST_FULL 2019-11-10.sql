USE [master]
GO
/****** Object:  Database [MLE]    Script Date: 10.11.2019. 08:47:00 ******/
CREATE DATABASE [MLE]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'MLE', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\MLE.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'MLE_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\MLE_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [MLE] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [MLE].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [MLE] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [MLE] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [MLE] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [MLE] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [MLE] SET ARITHABORT OFF 
GO
ALTER DATABASE [MLE] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [MLE] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [MLE] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [MLE] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [MLE] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [MLE] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [MLE] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [MLE] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [MLE] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [MLE] SET  ENABLE_BROKER 
GO
ALTER DATABASE [MLE] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [MLE] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [MLE] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [MLE] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [MLE] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [MLE] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [MLE] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [MLE] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [MLE] SET  MULTI_USER 
GO
ALTER DATABASE [MLE] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [MLE] SET DB_CHAINING OFF 
GO
ALTER DATABASE [MLE] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [MLE] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [MLE] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [MLE] SET QUERY_STORE = OFF
GO
USE [MLE]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[isActive] [bit] NULL,
	[Color] [nvarchar](70) NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Example]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Example](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Content] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[DateCreated] [datetime] NULL,
	[TimeSpent] [time](7) NULL,
	[ProjectId] [int] NULL,
	[StatusId] [int] NULL,
	[FileName] [nvarchar](max) NULL,
 CONSTRAINT [PK_Example] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExampleCategory]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExampleCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExampleId] [int] NULL,
	[CategoryId] [int] NULL,
 CONSTRAINT [PK_ExampleCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExampleType]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExampleType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExampleId] [int] NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_ExampleType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Marked]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Marked](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ExampleId] [int] NULL,
	[CategoryId] [int] NULL,
	[Text] [nvarchar](max) NULL,
 CONSTRAINT [PK_Marked] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Project]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Project](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[DateCreated] [datetime] NULL,
	[TimeSpent] [time](7) NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[StatusId] [int] NULL,
 CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Status]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Status](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[AdditionalKey] [int] NULL,
 CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[E-mail] [nvarchar](max) NULL,
	[Username] [nvarchar](max) NULL,
	[Password] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
	[IsActive] [bit] NULL,
	[DateCreated] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserExample]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserExample](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[ExampleId] [int] NULL,
 CONSTRAINT [PK_UserExample] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 10.11.2019. 08:47:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRole](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[RoleId] [int] NULL,
 CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Category] ON 

INSERT [dbo].[Category] ([Id], [Name], [Description], [isActive], [Color]) VALUES (1, N'Latin', N'Language', 1, N'#9dc1fa')
INSERT [dbo].[Category] ([Id], [Name], [Description], [isActive], [Color]) VALUES (2, N'English', N'Language', 1, N'#fa9d9d')
INSERT [dbo].[Category] ([Id], [Name], [Description], [isActive], [Color]) VALUES (3, N'Croatian', N'Language', 1, N'#ffd6b3')
INSERT [dbo].[Category] ([Id], [Name], [Description], [isActive], [Color]) VALUES (4, N'German', N'Language', 1, N'#b5ffcc')
SET IDENTITY_INSERT [dbo].[Category] OFF
SET IDENTITY_INSERT [dbo].[Example] ON 

INSERT [dbo].[Example] ([Id], [Name], [Content], [Description], [DateCreated], [TimeSpent], [ProjectId], [StatusId], [FileName]) VALUES (31, NULL, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mattis condimentum lectus vitae ornare. Nulla feugiat mi eget eleifend convallis. Phasellus ornare, magna vel hendrerit sagittis, sem neque viverra tortor, id mollis lorem nisl ac tellus. Quisque posuere urna sed massa molestie mollis. Suspendisse massa augue, placerat id pellentesque a, malesuada et dolor. Sed urna tellus, semper ut fringilla ut, elementum ut lacus. Nulla ac ullamcorper dui, in tristique nisi. Mauris consequat consectetur congue. Pellentesque vulputate ornare quam, ornare pharetra nibh placerat id.

Quisque libero magna, consectetur non sapien eu, tempor ultricies nunc. Mauris nec lorem dolor. Sed volutpat suscipit leo, nec lobortis metus sagittis in. Cras at eleifend lacus. Etiam eget ante nec dui tincidunt semper. Curabitur at maximus dolor. Proin auctor odio sapien, vitae aliquet risus gravida ac. Donec non hendrerit magna. Quisque ante augue, convallis at volutpat ut, dignissim in diam. Nam viverra, metus ut pellentesque dignissim, nibh augue condimentum mi, et gravida felis mauris eu massa. Proin nec urna et nunc cursus cursus at vel lorem. Donec eleifend bibendum enim ut dictum. Quisque malesuada urna ac erat porta, a congue nisl ultrices. Praesent vitae augue congue nulla mollis placerat vel varius lorem.

Vivamus ultrices libero dignissim accumsan pharetra. Sed vitae tincidunt magna, quis egestas tortor. Pellentesque at commodo felis, vitae mattis tortor. Maecenas rhoncus nulla eu erat tincidunt porta. Donec commodo nibh in massa imperdiet, feugiat ultricies eros finibus. Duis porta lobortis est, et hendrerit leo scelerisque ac. Suspendisse dictum neque neque, ut rutrum nibh mattis aliquet. Donec tristique blandit dui vel ornare. Quisque gravida, odio vitae tempus scelerisque, tortor elit auctor lacus, vitae finibus metus tellus vitae nibh.

Sed augue arcu, fringilla nec est sed, tempor cursus massa. Morbi scelerisque mauris leo, ut viverra lorem sodales eget. Nulla ut pharetra elit. Vivamus sodales a dolor nec hendrerit. Fusce et consectetur ante, vel auctor dolor. Phasellus vulputate eu orci ac placerat. Mauris consectetur tellus ut ligula dictum, in varius massa dapibus. Phasellus consectetur massa metus. Etiam viverra, ligula at tincidunt lacinia, purus elit gravida quam, id tempor dolor nisi vel neque. In mattis pharetra interdum.

Donec sit amet turpis eu est sagittis sagittis. Phasellus molestie justo eleifend, molestie sem et, mattis nibh. Morbi a sapien metus. Curabitur pellentesque enim porttitor velit lobortis, vitae venenatis metus pharetra. Aliquam erat volutpat. Phasellus pretium volutpat odio, at sollicitudin purus consectetur a. Mauris a tortor vel velit pulvinar ultrices. Mauris eu quam suscipit ipsum blandit varius id id augue. Phasellus risus felis, congue quis ligula lacinia, suscipit malesuada quam. Aliquam erat volutpat. Aenean enim ante, porta nec odio quis, faucibus tincidunt nisl. Donec dictum odio quis urna posuere accumsan. Pellentesque eleifend sodales augue ut aliquet. Etiam vel viverra nisl. Nunc ornare mi ac pulvinar porta.', N'Uploaded data to Database', CAST(N'2019-11-09T16:10:39.427' AS DateTime), NULL, NULL, 2, N'First Lorem.txt')
INSERT [dbo].[Example] ([Id], [Name], [Content], [Description], [DateCreated], [TimeSpent], [ProjectId], [StatusId], [FileName]) VALUES (32, NULL, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec mi sem, consequat quis feugiat quis, malesuada sit amet mauris. Integer porttitor elit ut ante bibendum convallis. Proin nisi mauris, bibendum et lobortis quis, cursus nec tellus. Nam auctor imperdiet tellus, eu facilisis ante. Morbi suscipit eget elit eu ornare. Suspendisse tempus, sem sit amet rutrum blandit, massa mi commodo nunc, non porta enim quam eu dolor. Nulla facilisi. Integer vestibulum feugiat dolor aliquam eleifend. Mauris lobortis lacinia suscipit. Fusce ullamcorper velit mauris, sed ultricies erat finibus et. Praesent et nisi nec odio tristique viverra. Nulla id mauris risus.

Maecenas dictum nibh a lacus porttitor fringilla. Aliquam erat volutpat. Quisque finibus augue augue, ut rutrum lacus elementum nec. Nunc gravida rhoncus dui, et laoreet sapien suscipit id. In euismod tempor mi, sed vulputate ligula ultricies vel. Pellentesque cursus rutrum interdum. Integer blandit tristique posuere. Cras convallis, est in scelerisque condimentum, diam neque vehicula felis, vitae varius est augue nec metus. Proin facilisis risus in tincidunt dapibus. Nam erat neque, tristique sit amet efficitur blandit, pharetra in ipsum. Integer euismod libero ac justo egestas sodales. Nulla diam quam, scelerisque hendrerit pulvinar eu, sagittis posuere lacus. Sed ut viverra libero. Nullam imperdiet orci at odio pretium lobortis. Nunc vitae libero risus.

Curabitur nec nunc sit amet odio porta blandit nec ac diam. Nullam sit amet erat dictum, gravida urna quis, ullamcorper tellus. Duis vulputate ipsum eu nulla scelerisque vehicula. Nullam a rutrum lacus, non venenatis ligula. Ut sed massa eu erat efficitur condimentum. Cras condimentum nulla eu nunc facilisis, nec eleifend velit ullamcorper. Fusce tempus iaculis diam, ut pellentesque lectus. Nunc accumsan elit in tortor molestie ullamcorper. Sed gravida feugiat libero, a cursus mauris luctus sit amet. Phasellus non neque euismod, sagittis est id, laoreet felis. Nam at lorem vitae orci consectetur efficitur. Aenean nec lectus vitae nibh finibus porta id id nisl. Integer ac convallis massa, sit amet porta enim. Phasellus sapien lectus, elementum quis massa eget, tincidunt aliquam tellus. Vivamus a arcu at ex tincidunt sodales.

Nullam nec mauris et velit congue condimentum a ut diam. Vivamus scelerisque dolor odio, vitae rhoncus mauris molestie vel. Donec scelerisque ex ac luctus vulputate. Vestibulum varius, quam ullamcorper elementum pulvinar, metus felis luctus sem, sed suscipit augue ex vel ipsum. Sed id euismod arcu. Donec quis eros a nunc posuere placerat. Phasellus mollis est eget metus euismod luctus. Aenean pharetra turpis in feugiat hendrerit. Fusce gravida dui eu lacus feugiat, et pharetra libero bibendum. Vestibulum ut nisi ut metus ullamcorper accumsan id vitae nunc. Vestibulum commodo tincidunt diam, in aliquam felis cursus ac. Donec nec fringilla dui.

Proin venenatis ullamcorper molestie. Curabitur porttitor ornare odio vel dignissim. Etiam orci nisl, cursus a vestibulum vitae, iaculis eu ante. In nisl ligula, molestie et aliquet in, vestibulum in metus. Fusce porttitor egestas velit eu eleifend. Sed cursus sodales felis. Mauris eu volutpat mauris. Ut a velit suscipit, posuere justo placerat, elementum leo. Sed in ipsum pretium metus posuere dapibus et id massa. Nunc at libero at lacus bibendum accumsan. Duis euismod euismod malesuada. Nulla aliquam eu nunc quis convallis.', N'Uploaded data to Database', CAST(N'2019-11-09T16:10:39.433' AS DateTime), NULL, NULL, 3, N'Second Lorem.txt')
INSERT [dbo].[Example] ([Id], [Name], [Content], [Description], [DateCreated], [TimeSpent], [ProjectId], [StatusId], [FileName]) VALUES (33, NULL, N'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis condimentum leo ac rutrum efficitur. Suspendisse vitae luctus turpis, non pharetra libero. Morbi tempor fringilla ultricies. Fusce elementum aliquet eros eget suscipit. Curabitur sagittis, mi tempor bibendum rutrum, diam nulla consectetur augue, a tempor quam est sit amet nunc. Nullam eu lobortis dui. Praesent a mi ante. In hac habitasse platea dictumst. Etiam venenatis aliquet semper. Vestibulum quis quam nisi.

Donec in tempor nisi, eu pellentesque lorem. Morbi vestibulum convallis pharetra. Suspendisse rhoncus nisi vel magna mattis interdum. Donec a metus non turpis eleifend tempor. Cras in consequat nisl. Morbi tristique leo non ipsum convallis porta. Vivamus imperdiet semper dapibus. In odio massa, mattis et ante sit amet, ullamcorper maximus dolor. Sed ac felis urna. Integer ut sollicitudin est, vitae finibus nulla. Nullam gravida ante vitae turpis viverra sodales. Fusce tristique elementum tellus, non cursus justo porta sed. Nulla ut ante a dui scelerisque consectetur. Proin finibus est eget libero commodo, vel pretium ipsum aliquet. Nunc in felis at orci lobortis condimentum non id sapien.

Phasellus quam sapien, placerat quis neque et, dignissim ultricies neque. Donec aliquam felis ac ante dignissim sagittis. Nunc malesuada purus vitae arcu bibendum, id cursus justo pulvinar. Nullam pharetra sed libero et sollicitudin. Sed vel nisi lorem. Mauris sagittis nibh ante, vitae tempus neque tincidunt eget. Aenean eu purus nisi.

Morbi orci odio, auctor sit amet facilisis in, pretium ut nulla. In et turpis ex. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi efficitur ex nec velit efficitur porta. Maecenas varius quis enim vel feugiat. Phasellus vel condimentum felis. Proin bibendum mattis libero, at gravida diam finibus sed.

Quisque viverra lacus et rutrum bibendum. Integer tempus ultricies mauris vel porta. Etiam tincidunt commodo felis, id congue orci vulputate vitae. Quisque sed mollis quam. Cras vitae enim a augue faucibus condimentum. Quisque ornare ultrices efficitur. Integer non vestibulum nisi, sed bibendum dolor. Integer urna risus, ultrices non mattis id, facilisis non magna. Aliquam erat volutpat. Donec facilisis auctor magna quis ullamcorper. Praesent eget nulla auctor libero pulvinar ultricies laoreet a quam. Cras commodo neque tortor, ut blandit mauris tincidunt at. Sed facilisis metus at leo volutpat consectetur. Donec ac nisi mattis, vestibulum enim finibus, tincidunt ipsum. Pellentesque rhoncus vulputate mauris, vel interdum eros ultrices eu.', N'Uploaded data to Database', CAST(N'2019-11-09T16:10:39.437' AS DateTime), NULL, NULL, 3, N'Third Lorem.txt')
SET IDENTITY_INSERT [dbo].[Example] OFF
SET IDENTITY_INSERT [dbo].[ExampleCategory] ON 

INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (21, 31, 1)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (22, 31, 2)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (23, 31, 3)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (24, 32, 1)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (25, 32, 2)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (26, 32, 3)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (27, 32, 4)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (28, 33, 1)
INSERT [dbo].[ExampleCategory] ([Id], [ExampleId], [CategoryId]) VALUES (29, 33, 4)
SET IDENTITY_INSERT [dbo].[ExampleCategory] OFF
SET IDENTITY_INSERT [dbo].[Marked] ON 

INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (91, 31, 2, N'haretra nibh placerat id.

Quisque libero magna, consectetur non sapien eu, tempor ultricies nunc. Mauris nec lorem dolor. Sed volutpat suscipit leo, nec lobortis metus sagittis in. Cras ')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (96, 31, 1, N'aesent vitae augue congue nulla mollis placerat vel varius lorem.

Vivamus ultrices libero dignissim accumsan pharetra. Sed v')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (97, 31, 3, N' placerat. Mauris consectetur tellus ut ligula dictum, in varius massa dapibus. Phasellus consectetur massa metus. Etiam viverra, ligula at tincidunt lacinia, purus elit gravida quam, id tempor dolor nisi vel neque. In mattis p')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (98, 32, 1, N't tellus, eu facilisis ante. Morbi suscipit eget elit eu ornare. Suspendisse tempus, sem sit amet rutrum blandit, massa mi commodo nunc, non porta enim quam eu dolor. Nulla facilisi. Integer vestibulum feugiat dolor aliquam eleifend. Mauris lobortis lacinia suscipit. Fusce ullamcorper velit mauris, sed ultricies erat finibus et. Praesent et nisi nec odio tristique viverra. Nulla id mauris risus.

Maecenas dictum nibh a lacus porttitor fringilla. Aliquam erat ')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (99, 32, 2, N'ec ac diam. Nullam sit amet erat dictum, gravida urna quis, ullamcorper tellus. Duis vulputate ipsum eu nulla scelerisque vehicula. Nullam a rutrum lacus, non venenatis ligula. Ut sed massa eu erat efficitur condimentum. Cras condimentum nulla eu nunc facilisis, nec eleifend velit ullamcorper. Fusce tempus iaculis di')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (100, 32, 4, N'hasellus mollis est eget metus euismod luctus. Aenean pharetra turpis in feugiat hendrerit. Fusce gravida')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (101, 32, 3, N'olutpat mau')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (102, 32, 4, N'titor ornare odio vel dignissim. Etiam orci nisl, cursus a vestibulum vitae, iaculis eu ante. In nisl ligula, molestie et aliquet in, vestibulum in metus. Fusce porttitor egestas velit eu eleifend. Sed cursus sodales f')
INSERT [dbo].[Marked] ([Id], [ExampleId], [CategoryId], [Text]) VALUES (103, 32, 3, N'cursus rutrum interdum. Integer blandit tristique posuere. Cras convallis, est in scelerisque condimentum, diam neque vehicula felis, vitae varius est augue nec metus. Proin facilisis risus in tincidunt dapibus. Nam erat neque, tristique sit amet efficitur blandit, pharetra in ipsum. Integer euismod libero ac justo egestas')
SET IDENTITY_INSERT [dbo].[Marked] OFF
SET IDENTITY_INSERT [dbo].[Project] ON 

INSERT [dbo].[Project] ([Id], [Name], [Description], [DateCreated], [TimeSpent], [Start_Date], [End_Date], [StatusId]) VALUES (2, N'MLE project', N'Web aplikacija za označavanje jezičnih primjera', CAST(N'2019-11-10T08:43:07.557' AS DateTime), CAST(N'00:00:00' AS Time), CAST(N'2019-11-10T08:40:00.000' AS DateTime), CAST(N'2019-11-10T08:43:07.557' AS DateTime), 3)
SET IDENTITY_INSERT [dbo].[Project] OFF
SET IDENTITY_INSERT [dbo].[Role] ON 

INSERT [dbo].[Role] ([Id], [Name], [Description]) VALUES (1, N'Administrator', N'Access to everything')
INSERT [dbo].[Role] ([Id], [Name], [Description]) VALUES (2, N'Client', N'Access to only his project files')
SET IDENTITY_INSERT [dbo].[Role] OFF
SET IDENTITY_INSERT [dbo].[Status] ON 

INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (1, N'Nije završen', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (2, N'Završen', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (3, N'U tijeku', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (4, N'Označen', 2)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (5, N'Neoznačen', 2)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (6, N'Prekinut', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (7, N'Pogreška', 1)
SET IDENTITY_INSERT [dbo].[Status] OFF
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([Id], [FirstName], [LastName], [E-mail], [Username], [Password], [Description], [IsActive], [DateCreated]) VALUES (1, N'Mihael', N'Lukaš', N'mihlukas@foi.hr', N'mihael', N'498b831ae484fa35fd5268595bb2e14a3f8434f7d24aea4ade0c87a96df2de4b', N'Owner', 1, CAST(N'2019-10-19T00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[User] OFF
SET IDENTITY_INSERT [dbo].[UserRole] ON 

INSERT [dbo].[UserRole] ([Id], [UserId], [RoleId]) VALUES (1, 1, 1)
SET IDENTITY_INSERT [dbo].[UserRole] OFF
ALTER TABLE [dbo].[Example]  WITH CHECK ADD  CONSTRAINT [FK_Example_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO
ALTER TABLE [dbo].[Example] CHECK CONSTRAINT [FK_Example_Project]
GO
ALTER TABLE [dbo].[Example]  WITH CHECK ADD  CONSTRAINT [FK_Example_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([Id])
GO
ALTER TABLE [dbo].[Example] CHECK CONSTRAINT [FK_Example_Status]
GO
ALTER TABLE [dbo].[ExampleCategory]  WITH CHECK ADD  CONSTRAINT [FK_Category_ExampleCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[ExampleCategory] CHECK CONSTRAINT [FK_Category_ExampleCategory]
GO
ALTER TABLE [dbo].[ExampleCategory]  WITH CHECK ADD  CONSTRAINT [FK_Example_ExampleCategory] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO
ALTER TABLE [dbo].[ExampleCategory] CHECK CONSTRAINT [FK_Example_ExampleCategory]
GO
ALTER TABLE [dbo].[ExampleType]  WITH CHECK ADD  CONSTRAINT [FK_ExampleType_Example] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO
ALTER TABLE [dbo].[ExampleType] CHECK CONSTRAINT [FK_ExampleType_Example]
GO
ALTER TABLE [dbo].[Marked]  WITH CHECK ADD  CONSTRAINT [FK_Marked_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO
ALTER TABLE [dbo].[Marked] CHECK CONSTRAINT [FK_Marked_Category]
GO
ALTER TABLE [dbo].[Marked]  WITH CHECK ADD  CONSTRAINT [FK_Marked_Example] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO
ALTER TABLE [dbo].[Marked] CHECK CONSTRAINT [FK_Marked_Example]
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_Project_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([Id])
GO
ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_Project_Status]
GO
ALTER TABLE [dbo].[UserExample]  WITH CHECK ADD  CONSTRAINT [FK_UserExample_Example] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO
ALTER TABLE [dbo].[UserExample] CHECK CONSTRAINT [FK_UserExample_Example]
GO
ALTER TABLE [dbo].[UserExample]  WITH CHECK ADD  CONSTRAINT [FK_UserExample_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[UserExample] CHECK CONSTRAINT [FK_UserExample_User]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_Role_UserRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_Role_UserRole]
GO
ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD  CONSTRAINT [FK_User_UserRole] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO
ALTER TABLE [dbo].[UserRole] CHECK CONSTRAINT [FK_User_UserRole]
GO
USE [master]
GO
ALTER DATABASE [MLE] SET  READ_WRITE 
GO
