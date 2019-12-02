use MLE;

CREATE TABLE [dbo].[Marked](
	[Id] int IDENTITY(1,1) NOT NULL,
	[ExampleId] int,
	[CategoryId] int,
	[Text] nvarchar(max)

	CONSTRAINT [PK_Marked] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Marked]  WITH CHECK ADD CONSTRAINT [FK_Marked_Example] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO

ALTER TABLE [dbo].[Marked]  WITH CHECK ADD CONSTRAINT [FK_Marked_Category] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO