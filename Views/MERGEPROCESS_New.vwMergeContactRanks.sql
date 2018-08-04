SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


 
CREATE VIEW [MERGEPROCESS_New].[vwMergeContactRanks]
 
AS
 
SELECT a.SSBID
    , c.contactid ID
    --Add in custom ranking here
    ,ROW_NUMBER() OVER(PARTITION BY SSBID ORDER BY ISNULL(su.isdisabled,0) ASC,
CASE WHEN c.owneridname IN ('STR STR', 'Thomas Griffin', 'Jared George', 'Phil Mayer', 'SSB Admin') THEN 2 ELSE 1 END, 
c.str_lastactivitydate,
CONVERT(DATE,c.createdon) ASC, 
CONVERT(DATE,c.modifiedon) DESC) xRank
FROM MERGEPROCESS_New.DetectedMerges a
JOIN Jets.dbo.vwDimCustomer_ModAcctId b 
    ON a.SSBID = b.SSB_CRMSYSTEM_CONTACT_ID AND b.SourceSystem = 'CRM_Contact' --updateme for source system --TCF 09112017
    AND a.[ObjectType] = 'Contact'
JOIN Jets_Reporting.prodcopy.contact c
    ON b.SSID = CAST(c.contactid AS NVARCHAR(100))
	AND c.statecode = 0
    --AND c.statuscodename = 'Active'
JOIN Jets_Reporting.prodcopy.SystemUser (NOLOCK) su ON c.ownerid = su.systemuserid
WHERE MergeComplete = 0;
 


GO
