CREATE DATABASE MLE;

USE [MLE];

CREATE TABLE [dbo].[User](
	[Id] int IDENTITY(1,1) NOT NULL,
	[FirstName] nvarchar(max),
	[LastName] nvarchar(max),
	[E-mail] nvarchar(max),
	[Username] nvarchar(max),
	[Password] nvarchar(max),
	[Description] nvarchar(max),
	[IsActive] bit,
	[DateCreated] datetime

	CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Role](
	[Id] int IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(max),
	[Description] nvarchar(max)

	CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[UserRole](
	[Id] int IDENTITY(1,1) NOT NULL,
	[UserId] int,
	[RoleId] int

	CONSTRAINT [PK_UserRole] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD CONSTRAINT [FK_User_UserRole] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserRole]  WITH CHECK ADD CONSTRAINT [FK_Role_UserRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([Id])
GO

CREATE TABLE [dbo].[Status](
	[Id] int IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(max),
	[AdditionalKey] int --0 - globalno ; 1 - za projekt ; 2 - za primjere 

	CONSTRAINT [PK_Status] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Project](
	[Id] int IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(max),
	[Description] nvarchar(max),
	[DateCreated] datetime,
	[TimeSpent] time,
	[Start_Date] datetime,
	[End_Date] datetime,
	[StatusId] int

	CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Project]  WITH CHECK ADD CONSTRAINT [FK_Project_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([Id])
GO

CREATE TABLE [dbo].[Example](
	[Id] int IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(max),
	[Content] nvarchar(max),
	[Description] nvarchar(max),
	[DateCreated] datetime,
	[TimeSpent] time,
	[ProjectId] int,
	[StatusId] int

	CONSTRAINT [PK_Example] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Example]  WITH CHECK ADD CONSTRAINT [FK_Example_Project] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[Example]  WITH CHECK ADD CONSTRAINT [FK_Example_Status] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([Id])
GO

CREATE TABLE [dbo].[UserExample](
	[Id] int IDENTITY(1,1) NOT NULL,
	[UserId] int,
	[ExampleId] int

	CONSTRAINT [PK_UserExample] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserExample]  WITH CHECK ADD CONSTRAINT [FK_UserExample_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserExample]  WITH CHECK ADD CONSTRAINT [FK_UserExample_Example] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO

CREATE TABLE [dbo].[Category](
	[Id] int IDENTITY(1,1) NOT NULL,
	[Name] nvarchar(max),
	[Description] nvarchar(max),
	[isActive] bit,
	[ExampleId] int

	CONSTRAINT [PK_Category] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Category]  WITH CHECK ADD CONSTRAINT [FK_Category_Example] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO