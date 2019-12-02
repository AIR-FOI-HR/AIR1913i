use mle;

alter table category
drop constraint FK_Category_Example;

alter table category
drop column ExampleId;

create table ExampleCategory(
	[Id] int IDENTITY(1,1) NOT NULL,
	[ExampleId] int,
	[CategoryId] int

	CONSTRAINT [PK_ExampleCategory] PRIMARY KEY CLUSTERED(
		Id ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].ExampleCategory  WITH CHECK ADD CONSTRAINT [FK_Example_ExampleCategory] FOREIGN KEY([ExampleId])
REFERENCES [dbo].[Example] ([Id])
GO

ALTER TABLE [dbo].ExampleCategory  WITH CHECK ADD CONSTRAINT [FK_Category_ExampleCategory] FOREIGN KEY([CategoryId])
REFERENCES [dbo].[Category] ([Id])
GO