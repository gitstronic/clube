USE [SecullumClubeNet_Clube]
GO

ALTER TABLE [dbo].[recibos] DROP CONSTRAINT [FK_recibos_contas_correntes1]
GO

ALTER TABLE [dbo].[recibos] DROP CONSTRAINT [FK_recibos_contas_correntes]
GO

/****** Object:  Table [dbo].[recibos]    Script Date: 09/08/2017 16:54:57 ******/
DROP TABLE [dbo].[recibos]
GO

/****** Object:  Table [dbo].[recibos]    Script Date: 09/08/2017 16:54:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[recibos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[valor] [money] NOT NULL,
	[conta_origem] [int] NOT NULL,
	[conta_destino] [int] NOT NULL,
	[data_operacao] [datetime] NOT NULL,
 CONSTRAINT [pk_recibos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[recibos]  WITH CHECK ADD  CONSTRAINT [FK_recibos_contas_correntes] FOREIGN KEY([conta_origem])
REFERENCES [dbo].[contas_correntes] ([id])
GO

ALTER TABLE [dbo].[recibos] CHECK CONSTRAINT [FK_recibos_contas_correntes]
GO

ALTER TABLE [dbo].[recibos]  WITH CHECK ADD  CONSTRAINT [FK_recibos_contas_correntes1] FOREIGN KEY([conta_destino])
REFERENCES [dbo].[contas_correntes] ([id])
GO

ALTER TABLE [dbo].[recibos] CHECK CONSTRAINT [FK_recibos_contas_correntes1]
GO


