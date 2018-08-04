CREATE TABLE [dbo].[Contact_Custom]
(
[SSB_CRMSYSTEM_ACCT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SSB_CRMSYSTEM_CONTACT_ID] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[new_ssbcrmsystemssidwinner] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TM_Ids] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DimCustIDs] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AccountID] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_ssbcrmsystemssidwinnersourcesystem] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SSBCRMSystemDimCustomerIDs] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SSBSSIDWinnerSourceSystem] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SSBCRMSystemAcctID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_SSBCRMSystemContactID] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[mobilephone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[telephone2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_telephone1_stripped] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_telephone2_stripped] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_mobilephone_stripped] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[new_total_STH_spend] [decimal] (18, 6) NULL,
[new_STH_Flag] [bit] NULL,
[new_total_group_spend] [decimal] (18, 6) NULL,
[new_broker_flag] [bit] NULL,
[new_last_email_open_date] [date] NULL,
[new_STH_since_date] [date] NULL,
[new_STH_tenure] [int] NULL,
[new_loyalty_points_balance] [bigint] NULL,
[new_silverpop_opt_ins] [bit] NULL,
[new_PSL_holder] [bit] NULL
)
GO
ALTER TABLE [dbo].[Contact_Custom] ADD CONSTRAINT [PK_Contact_Custom] PRIMARY KEY CLUSTERED  ([SSB_CRMSYSTEM_CONTACT_ID])
GO
