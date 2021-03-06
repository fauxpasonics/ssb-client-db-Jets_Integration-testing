SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE VIEW [dbo].[vwCRMLoad_Contact_Custom_Update]
AS

SELECT  z.[crm_id] contactid
, b.[new_ssbcrmsystemssidwinnersourcesystem]		   --, c.new_SSBSSIDWinnerSourceSystem
, b.new_ssbcrmsystemssidwinner						   --, c.new_ssbcrmsystemssidwinner
--, TM_Ids [new_ssbcrmsystemarchticsids]			   --
, DimCustIDs new_ssbcrmsystemdimcustomerids			   --, c.new_SSBCRMSystemDimCustomerIDs
--,c.tbi_ssbcrmsystemdimcustomerids					   --
--, b.AccountId [new_ssbcrmsystemarchticsids]		   --
, b.AccountId [str_number]							   --, c.str_number												--updateme for STR clients
, b.mobilephone										   --, c.mobilephone
, b.telephone2										   --, c.telephone2
, b.new_telephone1_stripped							   --, c.new_telephone1_stripped
, b.new_telephone2_stripped							   --, c.new_telephone2_stripped
, b.new_mobilephone_stripped						   --, c.new_mobilephone_stripped
----, z.EmailPrimary as emailaddress1					   
----, ISNULL(b.new_isprimary, 0) new_isprimary		   
----,c.new_ticketaccount--,
---- SELECT *
 --SELECT COUNT(*) 
FROM dbo.[Contact_Custom] b 
INNER JOIN dbo.Contact z ON b.SSB_CRMSYSTEM_CONTACT_ID = z.[SSB_CRMSYSTEM_CONTACT_ID]
LEFT JOIN  prodcopy.vw_contact c ON z.[crm_id] = c.contactID
LEFT JOIN dbo.vw_KeyAccounts k ON k.ssid = CAST(c.contactid AS NVARCHAR(100))
--INNER JOIN dbo.CRMLoad_Contact_ProcessLoad_Criteria pl ON b.SSB_CRMSYSTEM_CONTACT_ID = pl.SSB_CRMSYSTEM_CONTACT_ID
WHERE z.[SSB_CRMSYSTEM_CONTACT_ID] <> z.[crm_id] AND k.ssid IS NULL

AND  (1=2
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.new_ssbcrmsystemssidwinner AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_ssbcrmsystemssidwinner AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.DimCustIDs AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_ssbcrmsystemdimcustomerids AS VARCHAR(MAX)))),'')) 
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.AccountId AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.str_number AS VARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.[new_ssbcrmsystemssidwinnersourcesystem] AS VARCHAR(100)))),'') )  
	<> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_SSBSSIDWinnerSourceSystem AS VARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.mobilephone AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.mobilephone AS VARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.telephone2 AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.telephone2 AS VARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.new_telephone1_stripped AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_telephone1_stripped AS VARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.new_telephone2_stripped AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_telephone2_stripped AS VARCHAR(MAX)))),''))
	OR HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(b.new_mobilephone_stripped AS VARCHAR(100)))),'') )  <> HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(CAST(c.new_mobilephone_stripped AS VARCHAR(MAX)))),''))
	)
	AND z.crm_id NOT IN (
'D360DBF9-4D1C-E611-80DF-5065F38B5751',
'F67B7F1A-1022-E611-8152-5065F38A5BD1',
'FF7C7F1A-1022-E611-8152-5065F38A5BD1',
'6C3ECC5A-C8A2-E611-80F5-5065F38B31C1',
'1BC3D5EE-EF2B-E611-80E5-5065F38BA161',
'E37B7F1A-1022-E611-8152-5065F38A5BD1',
'1F24F954-D0EF-E611-8102-5065F38A0A31',
'2124F954-D0EF-E611-8102-5065F38A0A31',
'B9385EE7-0F22-E611-8152-5065F38A5BD1',
'68A5D3FF-4D1C-E611-80DF-5065F38B5751',
'DD7B7F1A-1022-E611-8152-5065F38A5BD1',
'2A7E5BE3-E017-E611-80E1-C4346BDC5151',
'05E4C9B2-E017-E611-80E1-C4346BDC5151',
'9e4f6b6d-2018-e611-80e1-5065f38ba161',
'C8A9D6C0-2718-E611-80E1-5065F38BA161',
'58DC6970-DB17-E611-80E1-C4346BDC5151',
'13365EE7-0F22-E611-8152-5065F38A5BD1',
'AD7C4EFE-C117-E611-80E1-5065F38BA161',
'297C7F1A-1022-E611-8152-5065F38A5BD1',
'2E5188AA-531C-E611-80E1-5065F38BA161',
'497D7F1A-1022-E611-8152-5065F38A5BD1',
'0F464732-501C-E611-80E1-C4346BDC5151',
'487C7F1A-1022-E611-8152-5065F38A5BD1',
'DCCD99D1-FE17-E611-80E1-5065F38BA161',
'AA7B7F1A-1022-E611-8152-5065F38A5BD1',
'68385EE7-0F22-E611-8152-5065F38A5BD1',
'CBCC5F10-E017-E611-80E1-C4346BDC5151',
'2580A2B4-C517-E611-80E1-5065F38BA161',
'6311330E-C617-E611-80E1-5065F38BA161',
'1DAF8DA4-531C-E611-80E1-5065F38BA161',
'677C7F1A-1022-E611-8152-5065F38A5BD1',
'9D7B7F1A-1022-E611-8152-5065F38A5BD1',
'357C7F1A-1022-E611-8152-5065F38A5BD1',
'CA7B7F1A-1022-E611-8152-5065F38A5BD1',
'728B707A-DF17-E611-80E1-C4346BDC5151',
'E9FBD102-C317-E611-80E1-5065F38BA161',
'9010BBD1-CD17-E611-80E1-5065F38BA161',
'D2C27014-CC17-E611-80E1-5065F38BA161')




GO
