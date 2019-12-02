use mle;

CREATE TABLE [dbo].[ExampleType](
	[Id] int IDENTITY(1,1) NOT NULL,
	[ExampleId] int,
	[Name] nvarchar(max),

	CONSTRAINT [PK_ExampleType] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ExampleType]  WITH CHECK ADD CONSTRAINT [FK_ExampleType_Example] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO

ALTER TABLE [dbo].[Example]
ADD [FileName] nvarchar(max)

INSERT INTO [dbo].[Role]([Name], [Description])
VALUES ('Administrator', 'Access to everything')

INSERT INTO [dbo].[Role]([Name], [Description])
VALUES ('Client', 'Access to only his project files')

INSERT INTO [dbo].[UserRole]([UserId], [RoleId])
VALUES (1, 1) -- moj UserId mi je 1 u bazi