USE [MLE]
GO
SET IDENTITY_INSERT [dbo].[Status] ON 

INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (1, N'Nije završen', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (2, N'Završen', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (3, N'U tijeku', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (4, N'Označen', 2)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (5, N'Neoznačen', 2)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (6, N'Prekinut', 1)
INSERT [dbo].[Status] ([Id], [Name], [AdditionalKey]) VALUES (7, N'Pogreška', 1)
SET IDENTITY_INSERT [dbo].[Status] OFF
