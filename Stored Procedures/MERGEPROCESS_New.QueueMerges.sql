SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 
CREATE PROC [MERGEPROCESS_New].[QueueMerges] --jets
--Exec  [MERGEPROCESS_New].[QueueMerges] 'jets'
    @Client VARCHAR(100) 
AS
--Declare @Client VARCHAR(100) ='Raiders'
--DECLARE @Account VARCHAR(100) = (SELECT CASE WHEN @client = 'Predators' THEN 'CRM_Account' ELSE CONCAT(@client,' CRM Account' ) END);
DECLARE @Contact VARCHAR(100) = (SELECT CASE WHEN @client = 'jets' THEN 'CRM_Contact' ELSE CONCAT(@client,' CRM Contact' ) END ); --updateme
--WITH only2Acct as
TRUNCATE TABLE MERGEPROCESS_New.Queue 
INSERT INTO MERGEPROCESS_New.Queue

 
SELECT PK_MergeID, b.[ObjectType],  MAX(CASE WHEN xRank =1 THEN CAST(c.ID AS VARCHAR(100)) END) AS Winner, MAX(CASE WHEN xRank =2 THEN CAST(c.ID AS VARCHAR(100)) END) AS Loser  
FROM mergeprocess_new.tmp_dimcust a 
JOIN MERGEPROCESS_New.DetectedMerges b ON a.SSB_CRMSYSTEM_Contact_ID = b.SSBID AND SourceSystem = @Contact
JOIN MERGEPROCESS_New.vwMergeContactRanks c ON a.SSID = CAST(c.ID AS VARCHAR(100))
WHERE ((AutoMerge = 1 and NumRecords = 2) OR Approved = 1)
    AND b.[ObjectType] = 'Contact'
    AND MergeComplete = 0 
GROUP BY PK_MergeID,b.[ObjectType]
HAVING MAX(CASE WHEN xRank =1 THEN CAST(c.ID AS VARCHAR(100)) END) IS NOT NULL AND  MAX(CASE WHEN xRank =2 THEN CAST(c.ID AS VARCHAR(100)) END) IS NOT NULL
 
 
 
GO
