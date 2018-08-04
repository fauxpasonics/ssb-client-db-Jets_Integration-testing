SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE VIEW [dbo].[vwCRMLoad_Contact_Std_Update] AS
--updateme - Hashes
SELECT a.new_ssbcrmsystemacctid
, a.new_ssbcrmsystemcontactid
, a.Prefix														 -- , b.Salutation
, a.FirstName													 -- , b.FirstName
, a.LastName													 -- , b.LastName
, a.Suffix														 -- , b.Suffix
, a.address1_line1												 -- , b.address1_line1
, a.address1_city												 -- , b.address1_city
, a.address1_stateorprovince									 -- , b.address1_stateorprovince
, a.address1_postalcode											 -- , b.address1_postalcode
, a.address1_country											 -- , b.address1_country
, a.emailaddress1												 -- , b.emailaddress1
, a.telephone1													 -- , b.telephone1
, a.middlename													 -- , b.middlename
, a.contactid													  
, LoadType
--, b.FirstName, b.LastName, b.Suffix, b.address1_line1, b.address1_city, b.address1_stateorprovince, b.address1_postalcode, b.address1_country, b.emailaddress1
--, b.telephone1
--,HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.FirstName))),'') )				, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.FirstName))),'')) 
--	, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.LastName))),'') )		, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.LastName))),'')) 
--	, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.Suffix))),'') )			, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.Suffix))),'')) 
--	, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.address1_line1))),'') )  , HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.address1_line1))),'')) 
--	, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(REPLACE(REPLACE(REPLACE(REPLACE(a.telephone1,')',''),'(',''),'-',''),' ','')))),'') )  , HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.telephone1))),'')) 
--	, HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(a.emailaddress1))),'') )  , HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.emailaddress1))),'')) 

FROM [dbo].[vwCRMLoad_Contact_Std_Prep] a
JOIN prodcopy.vw_contact b ON a.contactid = b.contactID
LEFT JOIN dbo.vw_KeyAccounts k ON k.SSID = CAST(b.contactid AS NVARCHAR(100))
WHERE 1=1 AND LoadType = 'Update'
AND k.ssid IS NULL
--AND (
--a.Hash_FirstName !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.FirstName))),'')) 
--OR a.Hash_lastname !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.lastname))),'')) 
--OR a.Hash_suffix !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.suffix))),'')) 
--OR a.Hash_Address1_Line1 !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.address1_line1))),'')) 
--OR a.Hash_Telephone1 !=  HASHBYTES('SHA2_256',ISNULL(LTRIM(RTRIM(Lower(b.telephone1))),'')) 
--)
AND ( 
 ISNULL(a.Prefix,'') != ISNULL(b.salutation,'')
OR ISNULL(a.FirstName,'') != ISNULL(b.FirstName,'')
OR ISNULL(a.LastName,'') != ISNULL(b.LastName,'')
OR ISNULL(a.Suffix,'') != ISNULL(b.Suffix,'')
OR ISNULL(a.address1_line1,'') != ISNULL(b.address1_line1,'')
OR ISNULL(a.address1_city,'') != ISNULL(b.address1_city,'')
OR ISNULL(a.address1_stateorprovince,'') != ISNULL(b.address1_stateorprovince,'')
OR ISNULL(a.address1_postalcode,'') != ISNULL(b.address1_postalcode,'')
OR ISNULL(a.address1_country,'') != ISNULL(b.address1_country,'')
OR ISNULL(a.telephone1,'') != ISNULL(b.telephone1,'')
OR ISNULL(a.emailaddress1,'') != ISNULL(b.emailaddress1,'')
OR ISNULL(a.middlename,'') != ISNULL(b.middlename,'')
)

AND a.contactid NOT IN (
'984ec20e-c317-e611-80e1-5065f38ba161',
'448034e2-ca17-e611-80e1-5065f38ba161',
'862bee70-511c-e611-8152-5065f38a5bd1',
'40d9f920-cc17-e611-80e1-5065f38ba161',
'0b7a7573-c23c-e711-8134-e0071b6a7021',
'a9c4d4e8-2918-e611-80e1-c4346bdc5151',
'969ddacf-4d1c-e611-80df-5065f38b5751',
'a03846ae-c717-e611-80e1-5065f38ba161',
'0e8734fd-ff17-e611-80e1-5065f38ba161',
'd000d40d-df17-e611-80e1-c4346bdc5151',
'7230f911-c017-e611-80e1-5065f38ba161',
'ecea5616-c517-e611-80e1-5065f38ba161',
'917c4efe-c117-e611-80e1-5065f38ba161',
'2d2f0557-cc17-e611-80e1-5065f38ba161',
'28416f04-e017-e611-80e1-c4346bdc5151',
'0489f0ce-c217-e611-80e1-5065f38ba161',
'49631177-0018-e611-80e1-5065f38ba161',
'a7cc487e-cb17-e611-80e1-5065f38ba161',
'91f54331-2018-e611-80e1-5065f38ba161',
'b24e9396-2718-e611-80e1-5065f38ba161',
'14d34e1d-0118-e611-80e1-5065f38ba161',
'c8fdfb0b-cd17-e611-80e1-5065f38ba161',
'b977513c-c617-e611-80e1-5065f38ba161',
'52b84942-c617-e611-80e1-5065f38ba161',
'3fcf99d9-bf17-e611-80e1-5065f38ba161',
'3ad3885a-dd17-e611-80e1-c4346bdc5151',
'7c783e9c-c717-e611-80e1-5065f38ba161',
'02f5aa93-cd17-e611-80e1-5065f38ba161',
'20d7419f-dd17-e611-80e1-c4346bdc5151',
'9d9c8642-541c-e611-80e1-c4346bdc5151',
'498b31eb-ff17-e611-80e1-5065f38ba161',
'0647bc45-ce17-e611-80e1-5065f38ba161',
'0d125816-e017-e611-80e1-c4346bdc5151',
'0767701b-db17-e611-80e1-c4346bdc5151',
'8865891b-ca17-e611-80e1-5065f38ba161',
'579e96ba-0018-e611-80e1-5065f38ba161',
'09aaa135-c517-e611-80e1-5065f38ba161',
'8839ae49-6c1c-e611-80e1-5065f38ba161',
'bcf0000c-c017-e611-80e1-5065f38ba161',
'64be75fc-fe17-e611-80e1-5065f38ba161',
'73a8d8ed-c917-e611-80e1-5065f38ba161',
'58449353-ff17-e611-80e1-5065f38ba161',
'311ff553-0118-e611-80e1-5065f38ba161',
'10543c52-c117-e611-80e1-5065f38ba161',
'00fabebf-c817-e611-80e1-5065f38ba161',
'076c208e-ce17-e611-80e1-5065f38ba161',
'1e1095ce-ca17-e611-80e1-5065f38ba161',
'04a40225-e217-e611-80e1-c4346bdc5151',
'c2ceb05c-c517-e611-80e1-5065f38ba161',
'4d788dfc-cd17-e611-80e1-5065f38ba161',
'451d41d9-c617-e611-80e1-5065f38ba161',
'a7a77f61-df17-e611-80e1-c4346bdc5151',
'e4f2f22d-cb17-e611-80e1-5065f38ba161',
'6d5bdd75-e117-e611-80e1-c4346bdc5151',
'e0ccb2c2-c917-e611-80e1-5065f38ba161',
'4791ba40-e017-e611-80e1-c4346bdc5151',
'41211d2f-df17-e611-80e1-c4346bdc5151',
'49dee0e7-c317-e611-80e1-5065f38ba161',
'de684fcf-dc17-e611-80e1-c4346bdc5151',
'20a40225-e217-e611-80e1-c4346bdc5151',
'6e24a37e-c617-e611-80e1-5065f38ba161',
'0e3d2c28-c117-e611-80e1-5065f38ba161',
'f7b70bd5-cb17-e611-80e1-5065f38ba161',
'40e4f800-de17-e611-80e1-c4346bdc5151',
'a1318440-c317-e611-80e1-5065f38ba161',
'946d4f19-c717-e611-80e1-5065f38ba161',
'38f10566-c917-e611-80e1-5065f38ba161',
'193fdfbe-bf17-e611-80e1-5065f38ba161',
'6a44af86-ca17-e611-80e1-5065f38ba161',
'55ebab90-2918-e611-80e1-c4346bdc5151',
'3787670a-e017-e611-80e1-c4346bdc5151',
'f72af1ba-ff17-e611-80e1-5065f38ba161',
'0c19464d-e017-e611-80e1-c4346bdc5151',
'1c03fa4d-c917-e611-80e1-5065f38ba161',
'3671e6c6-ff17-e611-80e1-5065f38ba161',
'7ea9d8ed-c917-e611-80e1-5065f38ba161',
'17692b0c-c817-e611-80e1-5065f38ba161',
'1f508984-2918-e611-80e1-c4346bdc5151',
'eb907972-c917-e611-80e1-5065f38ba161',
'903088e7-c917-e611-80e1-5065f38ba161',
'90069090-c017-e611-80e1-5065f38ba161',
'666e208e-ce17-e611-80e1-5065f38ba161',
'9afd77c3-c117-e611-80e1-5065f38ba161',
'98fab543-6c1c-e611-80e1-5065f38ba161',
'4a5a2761-2018-e611-80e1-5065f38ba161',
'0b406f04-e017-e611-80e1-c4346bdc5151',
'e96cdd55-dc17-e611-80e1-c4346bdc5151',
'7b6c0884-2718-e611-80e1-5065f38ba161',
'7b55a4b0-531c-e611-80e1-5065f38ba161',
'66e0711b-ff17-e611-80e1-5065f38ba161',
'2a332a63-cd17-e611-80e1-5065f38ba161',
'09b6e4f0-c217-e611-80e1-5065f38ba161',
'7cab2d47-cb17-e611-80e1-5065f38ba161',
'7b2097b9-c417-e611-80e1-5065f38ba161',
'd44e4923-bf17-e611-80e1-5065f38ba161',
'bc1acb54-c217-e611-80e1-5065f38ba161',
'dc5579d5-ca17-e611-80e1-5065f38ba161',
'b04bd1f3-c317-e611-80e1-5065f38ba161',
'8471efc6-c617-e611-80e1-5065f38ba161',
'd4e17e48-541c-e611-80e1-c4346bdc5151',
'2d391436-c917-e611-80e1-5065f38ba161',
'b147dc24-c017-e611-80e1-5065f38ba161',
'e67c7f1a-1022-e611-8152-5065f38a5bd1',
'2080f16d-dd17-e611-80e1-c4346bdc5151',
'df0ebbd1-cd17-e611-80e1-5065f38ba161',
'12b32032-de17-e611-80e1-c4346bdc5151',
'd100014f-e217-e611-80e1-c4346bdc5151',
'465b8fbf-c417-e611-80e1-5065f38ba161',
'eff0e171-2c18-e611-80e1-5065f38ba161',
'c0b997c6-bf17-e611-80e1-5065f38ba161',
'effab543-6c1c-e611-80e1-5065f38ba161',
'd9152393-dc17-e611-80e1-c4346bdc5151',
'551cc4ff-c317-e611-80e1-5065f38ba161',
'd0ae5154-ca17-e611-80e1-5065f38ba161',
'015c9062-c317-e611-80e1-5065f38ba161',
'059934b2-e117-e611-80e1-c4346bdc5151',
'27ce99b8-db17-e611-80e1-c4346bdc5151',
'2a7d6da8-0018-e611-80e1-5065f38ba161',
'121df719-4d1c-e611-80df-5065f38b5751',
'9a5b9acb-1f18-e611-80e1-5065f38ba161',
'a619c234-0018-e611-80e1-5065f38ba161',
'255d2761-2018-e611-80e1-5065f38ba161',
'08e3257e-2c18-e611-80e1-5065f38ba161',
'bdabfad2-2018-e611-80e1-5065f38ba161',
'04508984-2918-e611-80e1-c4346bdc5151',
'e88e31eb-ff17-e611-80e1-5065f38ba161',
'330a5ad8-3584-e711-8139-e0071b6a7021',
'a41a41d9-c617-e611-80e1-5065f38ba161',
'819ddacf-4d1c-e611-80df-5065f38b5751',
'1dead0f3-c917-e611-80e1-5065f38ba161',
'dae3b6ca-e017-e611-80e1-c4346bdc5151',
'2c581b99-dc17-e611-80e1-c4346bdc5151',
'62f4aa93-cd17-e611-80e1-5065f38ba161',
'0a16189a-ce17-e611-80e1-5065f38ba161',
'5c9f4eec-c117-e611-80e1-5065f38ba161',
'1c58b8af-0118-e611-80e1-5065f38ba161',
'9ea87f61-df17-e611-80e1-c4346bdc5151',
'0de5cf1c-c517-e611-80e1-5065f38ba161',
'3c8b6097-2918-e611-80e1-c4346bdc5151',
'ac3b113e-de17-e611-80e1-c4346bdc5151',
'ceb1be22-c917-e611-80e1-5065f38ba161',
'ccfde6b8-bf17-e611-80e1-5065f38ba161',
'9d188160-dd17-e611-80e1-c4346bdc5151',
'065b2684-c117-e611-80e1-5065f38ba161',
'120f330e-c617-e611-80e1-5065f38ba161',
'e3242f8b-ff17-e611-80e1-5065f38ba161',
'99257d7e-c917-e611-80e1-5065f38ba161',
'7759f62b-de17-e611-80e1-c4346bdc5151',
'd96a89de-fe17-e611-80e1-5065f38ba161',
'e73646ae-c717-e611-80e1-5065f38ba161',
'7791e5e1-c517-e611-80e1-5065f38ba161',
'31aa81e4-fe17-e611-80e1-5065f38ba161',
'9a35628e-db17-e611-80e1-c4346bdc5151',
'e920c97c-1f18-e611-80e1-5065f38ba161',
'247ce995-cc17-e611-80e1-5065f38ba161',
'1e105125-2018-e611-80e1-5065f38ba161',
'476cdd55-dc17-e611-80e1-c4346bdc5151',
'eb0f1184-c517-e611-80e1-5065f38ba161',
'2a6b18a0-4d1c-e611-80df-5065f38b5751',
'122200af-c617-e611-80e1-5065f38ba161',
'6a718966-ff17-e611-80e1-5065f38ba161',
'774ae60e-ce17-e611-80e1-5065f38ba161',
'322b9c89-fe17-e611-80e1-5065f38ba161',
'27c54222-ca17-e611-80e1-5065f38ba161',
'7f0a5594-c317-e611-80e1-5065f38ba161',
'b5f2c958-501c-e611-80e1-c4346bdc5151',
'ecaba64a-e117-e611-80e1-c4346bdc5151',
'81a85861-9514-e711-8108-5065f38b11d1',
'582d9e35-c217-e611-80e1-5065f38ba161',
'49f46040-501c-e611-80e1-c4346bdc5151',
'9e3a3207-c717-e611-80e1-5065f38ba161',
'097c7f1a-1022-e611-8152-5065f38a5bd1',
'80b797c6-bf17-e611-80e1-5065f38ba161',
'7888f0ce-c217-e611-80e1-5065f38ba161',
'b016df7f-dd17-e611-80e1-c4346bdc5151',
'1491a997-c917-e611-80e1-5065f38ba161',
'f4c8f11f-4d1c-e611-80df-5065f38b5751',
'0f82f9b7-4d1c-e611-80df-5065f38b5751',
'bf90d370-501c-e611-80e1-c4346bdc5151',
'2552e22b-4d1c-e611-80df-5065f38b5751',
'2e176186-df17-e611-80e1-c4346bdc5151',
'37a71f97-ff17-e611-80e1-5065f38ba161',
'18729731-c017-e611-80e1-5065f38ba161',
'e75af6ac-cd17-e611-80e1-5065f38ba161',
'2dfde566-c817-e611-80e1-5065f38ba161',
'248df15a-e217-e611-80e1-c4346bdc5151',
'c48a6d62-c717-e611-80e1-5065f38ba161',
'2f2710a3-ff17-e611-80e1-5065f38ba161',
'28aa111c-0018-e611-80e1-5065f38ba161',
'2367985a-c617-e611-80e1-5065f38ba161',
'1a8f707a-df17-e611-80e1-c4346bdc5151',
'72a8887f-0118-e611-80e1-5065f38ba161',
'd9a51f97-ff17-e611-80e1-5065f38ba161',
'81aafc75-ce17-e611-80e1-5065f38ba161',
'f37c7f1a-1022-e611-8152-5065f38a5bd1',
'0559bc4d-bf17-e611-80e1-5065f38ba161',
'892508b6-607b-e611-8282-5065f38a5bd1',
'fe0b3f82-4d1c-e611-80df-5065f38b5751',
'26bbc37f-c817-e611-80e1-5065f38ba161',
'0a3a94c3-dd17-e611-80e1-c4346bdc5151',
'07da04aa-cb17-e611-80e1-5065f38ba161',
'9853bb56-cd17-e611-80e1-5065f38ba161',
'cbcd5f10-e017-e611-80e1-c4346bdc5151',
'd1d92751-2d18-e611-80df-5065f38b5751',
'6d279873-0118-e611-80e1-5065f38ba161',
'1265d48b-dd17-e611-80e1-c4346bdc5151',
'3ff10566-c917-e611-80e1-5065f38ba161',
'0bc4cb39-ce17-e611-80e1-5065f38ba161',
'062e4d64-511c-e611-8152-5065f38a5bd1',
'939386d5-dd17-e611-80e1-c4346bdc5151',
'35487dd0-db17-e611-80e1-c4346bdc5151',
'e7757f45-db17-e611-80e1-c4346bdc5151',
'aa7b7f1a-1022-e611-8152-5065f38a5bd1',
'857a56f8-c117-e611-80e1-5065f38ba161',
'810e15dc-dd17-e611-80e1-c4346bdc5151',
'95900727-cc17-e611-80e1-5065f38ba161',
'aa0a7d56-c717-e611-80e1-5065f38ba161',
'f12decda-cc17-e611-80e1-5065f38ba161',
'5e1b41d9-c617-e611-80e1-5065f38ba161',
'227c7f1a-1022-e611-8152-5065f38a5bd1',
'332cf17a-c017-e611-80e1-5065f38ba161',
'3c7f33a6-ce17-e611-80e1-5065f38ba161',
'de7f62b4-cc17-e611-80e1-5065f38ba161',
'48b44129-0118-e611-80e1-5065f38ba161',
'bc9d4c2c-501c-e611-80e1-c4346bdc5151',
'c269cb24-cd17-e611-80e1-5065f38ba161',
'21b062b5-3871-e711-811c-e0071b6a71e1',
'23576ecf-8b78-e711-8138-e0071b6a7021',
'2af12209-6566-e711-8144-e0071b7ea5b1',
'5ba159cb-c36b-e711-8147-e0071b7ea5b1',
'8c047d27-1b6b-e711-8137-e0071b6a7021',
'c45a340b-2e67-e711-811a-e0071b6a71e1',
'd2795cb0-b265-e711-8117-e0071b6aa031',
'f11e6ed1-a46c-e711-811a-e0071b6a71e1',
'4336628e-db17-e611-80e1-c4346bdc5151',
'1011e758-0018-e611-80e1-5065f38ba161',
'127e3c55-2699-e511-80e5-3863bb341858',
'129460b9-fe17-e611-80e1-5065f38ba161',
'1b541582-c717-e611-80e1-5065f38ba161',
'28052e7c-cc17-e611-80e1-5065f38ba161',
'2e5c31fe-0118-e611-80e1-5065f38ba161',
'473b75a2-0018-e611-80e1-5065f38ba161',
'47734923-0118-e611-80e1-5065f38ba161',
'5177ba19-e117-e611-80e1-c4346bdc5151',
'5becc7fd-c817-e611-80e1-5065f38ba161',
'65aabf14-ff17-e611-80e1-5065f38ba161',
'a2a9887f-0118-e611-80e1-5065f38ba161',
'ab46ebc0-c617-e611-80e1-5065f38ba161',
'b85bf86a-0018-e611-80e1-5065f38ba161',
'cf3fe9b8-cd17-e611-80e1-5065f38ba161',
'f71cf719-4d1c-e611-80df-5065f38b5751',
'cfe3a497-cb17-e611-80e1-5065f38ba161',
'c58c6fc9-c117-e611-80e1-5065f38ba161',
'1f24f954-d0ef-e611-8102-5065f38a0a31',
'2124f954-d0ef-e611-8102-5065f38a0a31',
'417c7f1a-1022-e611-8152-5065f38a5bd1',
'6c3ecc5a-c8a2-e611-80f5-5065f38b31c1',
'997c7f1a-1022-e611-8152-5065f38a5bd1',
'e37b7f1a-1022-e611-8152-5065f38a5bd1',
'f67b7f1a-1022-e611-8152-5065f38a5bd1',
'ff7c7f1a-1022-e611-8152-5065f38a5bd1',
'369e4eec-c117-e611-80e1-5065f38ba161',
'39cfe679-dd17-e611-80e1-c4346bdc5151',
'acf5eee4-c817-e611-80e1-5065f38ba161',
'feb6c42e-ca17-e611-80e1-5065f38ba161',
'9451173c-7b50-e711-813d-e0071b6af131',
'aecfd9fc-c217-e611-80e1-5065f38ba161',
'5773092a-c817-e611-80e1-5065f38ba161',
'5d186ad4-cb10-e711-8102-5065f38ad991',
'8cf1181e-c817-e611-80e1-5065f38ba161',
'809dc3c0-c317-e611-80e1-5065f38ba161',
'e84bc25d-db17-e611-80e1-c4346bdc5151',
'08ced8f2-c617-e611-80e1-5065f38ba161',
'47a1c357-e117-e611-80e1-c4346bdc5151',
'2e5188aa-531c-e611-80e1-5065f38ba161',
'dd7b7f1a-1022-e611-8152-5065f38a5bd1',
'd360dbf9-4d1c-e611-80df-5065f38b5751',
'e9fbd102-c317-e611-80e1-5065f38ba161',
'58dc6970-db17-e611-80e1-c4346bdc5151',
'6311330e-c617-e611-80e1-5065f38ba161',
'68a5d3ff-4d1c-e611-80df-5065f38b5751',
'487c7f1a-1022-e611-8152-5065f38a5bd1',
'8b8033a6-ce17-e611-80e1-5065f38ba161',
'9d7b7f1a-1022-e611-8152-5065f38a5bd1',
'd18e707a-df17-e611-80e1-c4346bdc5151',
'8cf73fa0-cd17-e611-80e1-5065f38ba161',
'cbcc5f10-e017-e611-80e1-c4346bdc5151',
'677c7f1a-1022-e611-8152-5065f38a5bd1',
'dccd99d1-fe17-e611-80e1-5065f38ba161',
'2a7e5be3-e017-e611-80e1-c4346bdc5151',
'497d7f1a-1022-e611-8152-5065f38a5bd1',
'9010bbd1-cd17-e611-80e1-5065f38ba161',
'c8a9d6c0-2718-e611-80e1-5065f38ba161',
'b9385ee7-0f22-e611-8152-5065f38a5bd1',
'357c7f1a-1022-e611-8152-5065f38a5bd1',
'ca7b7f1a-1022-e611-8152-5065f38a5bd1',
'd2c27014-cc17-e611-80e1-5065f38ba161',
'728b707a-df17-e611-80e1-c4346bdc5151',
'297c7f1a-1022-e611-8152-5065f38a5bd1',
'734fb3d7-cd17-e611-80e1-5065f38ba161',
'0f464732-501c-e611-80e1-c4346bdc5151',
'ad7c4efe-c117-e611-80e1-5065f38ba161',
'05e4c9b2-e017-e611-80e1-c4346bdc5151',
'68385ee7-0f22-e611-8152-5065f38a5bd1',
'1fd87fcb-c417-e611-80e1-5065f38ba161',
'9e4f6b6d-2018-e611-80e1-5065f38ba161',
'1daf8da4-531c-e611-80e1-5065f38ba161',
'13365ee7-0f22-e611-8152-5065f38a5bd1',
'2580a2b4-c517-e611-80e1-5065f38ba161',
'833fe565-2718-e611-80e1-5065f38ba161',
'617d7f1a-1022-e611-8152-5065f38a5bd1',
'5a1177ed-cc17-e611-80e1-5065f38ba161'


)






GO