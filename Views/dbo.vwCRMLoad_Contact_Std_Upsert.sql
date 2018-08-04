SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE VIEW [dbo].[vwCRMLoad_Contact_Std_Upsert] AS

SELECT new_ssbcrmsystemacctid, new_ssbcrmsystemcontactid, Prefix, FirstName, LastName, Suffix, address1_line1, address1_city,
	address1_stateorprovince, address1_postalcode, address1_country, telephone1, emailaddress1, LoadType
FROM [dbo].[vwCRMLoad_Contact_Std_Prep]
WHERE LoadType = 'Upsert'
AND  new_ssbcrmsystemcontactid NOT IN (
'CDED74E0-5D7A-495E-B0E4-5DA69DD9DC3D',
'DE66109C-5782-4EF4-9F4B-07B02573DA99'
)
AND new_ssbcrmsystemcontactid NOT IN 
(
SELECT  DISTINCT c1.new_SSBCRMSystemContactID 
FROM dbo.Contact c
INNER JOIN Jets_Reporting.prodcopy.Contact c1 ON c.crm_id = c1.contactid AND c1.statecode = 0
INNER JOIN Jets_Reporting.prodcopy.SystemUser su ON su.systemuserid = c1.modifiedby INNER JOIN dbo.Contact_CRMResults crm ON crm.CrmRecordId = c1.contactid
WHERE RTRIM(c.EmailPrimary) <> RTRIM(c1.emailaddress1)
AND c.EmailPrimary <> ''
)






GO
