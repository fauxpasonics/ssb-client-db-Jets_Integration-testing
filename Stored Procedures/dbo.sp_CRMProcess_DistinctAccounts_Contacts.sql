SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[sp_CRMProcess_DistinctAccounts_Contacts]
AS

-- Create Main Transaction Records Table
SELECT *
INTO #tmpTrans
FROM dbo.vwCRMProcess_CRMQualify_Transactions



CREATE INDEX idx_Trans_Acct_ID ON [#tmpTrans] ([SSB_CRMSYSTEM_ACCT_ID])
CREATE INDEX idx_Trans_Contact_ID ON [#tmpTrans] ([SSB_CRMSYSTEM_CONTACT_ID])


-- Create STH Table
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID
, b.SourceSystem
, COUNT(*) Count 
INTO #tmpSTHs
-- Select *
FROM stg.CRMProcess_SeasonTicketHolders_SSIDs a
INNER JOIN [dbo].[vwDimCustomer_ModAcctId] b ON b.SSID = a.SSID and b.SourceSystem = 'TM'
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, b.SourceSystem
-- DROP TABLE #tmpSTHs
-- SELECT * FROM #tmpSTHs

-- Bring in CRMRecords
SELECT b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, SourceSystem, COUNT(*) Count
INTO #tmpCRMRecords
-- Select *
FROM dbo.vwDimCustomer_ModAcctId b 
WHERE b.SourceSystem NOT LIKE 'Lead%' 
AND SourceSystem LIKE '%CRM%' --updateme
AND [b].[SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL
--AND b.SSID IN (SELECT contactid FROM ProdCopy.[vw_Contact])
GROUP BY b.SSB_CRMSYSTEM_ACCT_ID, b.SSB_CRMSYSTEM_CONTACT_ID, SourceSystem
--DROP TABLE [#tmpCRMRecords]
--SELECT * from #tmpCRMRecords

CREATE INDEX idx_CRM_Acct_ID ON [#tmpCRMRecords] ([SSB_CRMSYSTEM_ACCT_ID])
CREATE INDEX idx_CRM_Contact_ID ON [#tmpCRMRecords] ([SSB_CRMSYSTEM_CONTACT_ID])


-- distinct contacts
TRUNCATE TABLE [stg].[Distinct_Contacts]

INSERT INTO [stg].[Distinct_Contacts] ([SSB_CRMSYSTEM_CONTACT_ID])
SELECT DISTINCT [SSB_CRMSYSTEM_CONTACT_ID] FROM [#tmpTrans] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL
UNION SELECT DISTINCT [SSB_CRMSYSTEM_CONTACT_ID] FROM [#tmpSTHs] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL
UNION SELECT DISTINCT [SSB_CRMSYSTEM_CONTACT_ID] FROM [#tmpCRMRecords] WHERE [SSB_CRMSYSTEM_ACCT_ID] IS NOT NULL

UPDATE a
SET [MaxTransDate] = trans.[MaxTransDate]
, STH = CASE WHEN ISNULL(sth.[Count],0) > 0 THEN 1 ELSE 0 END
, CRM = CASE WHEN ISNULL(crm.[Count],0) > 0 THEN 1 ELSE 0 END	
FROM stg.[Distinct_Contacts] a
LEFT JOIN [#tmpTrans] trans ON [trans].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN [#tmpSTHs] sth ON [sth].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN [#tmpCRMRecords] crm ON [crm].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]


--for contacts
SELECT a.SSB_CRMSYSTEM_ACCT_ID
,a.SSB_CRMSYSTEM_CONTACT_ID
, a.MaxTransDate
, a.STH
, c.SeasonTicket_Years
, CRM
--, *
INTO #tmp_Results_Contact
FROM stg.Distinct_Contacts a 
LEFT JOIN dbo.CRMProcess_Contact_SeasonTicketHolders c ON c.SSB_CRMSYSTEM_CONTACT_ID = a.SSB_CRMSYSTEM_CONTACT_ID





TRUNCATE TABLE dbo.CRMProcess_DistinctContacts

INSERT INTO dbo.CRMProcess_DistinctContacts
SELECT *
, 0 
FROM #tmp_Results_Contact

UPDATE a
SET CRMLoadCriteriaMet = 1
FROM dbo.[CRMProcess_DistinctContacts] a 
WHERE MaxTransDate IS NOT NULL
OR CRM = 1
OR STH = 1
GO
