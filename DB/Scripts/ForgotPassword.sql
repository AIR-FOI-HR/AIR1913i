USE [MLE]
GO

/****** Object:  Table [dbo].[ForgotPassword]    Script Date: 21.05.2020. 22:04:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ForgotPassword](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[DateTime] [datetime] NULL,
	[ValidUntil] [datetime] NULL,
	[IsValid] [bit] NULL,
	[IsUsed] [bit] NULL,
	[WrongEmail] [bit] NULL,
	[Description] [nvarchar](max) NULL,
	[InsertedEmail] [nvarchar](max) NULL,
	[GeneratedKey] [nvarchar](max) NULL,
 CONSTRAINT [PK_ForgotPassword] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ForgotPassword]  WITH CHECK ADD  CONSTRAINT [FK_ForgotPassword_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ForgotPassword] CHECK CONSTRAINT [FK_ForgotPassword_Users]
GO


