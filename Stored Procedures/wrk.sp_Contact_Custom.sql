SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*************************************************
Created By: PJ Pepa
Created On: 
Updated By: 
Update Date: 2018-06-13
Update Notes: altered existing wrk.sp_Contact_Custom on criteria sent over by Jets. 
Reviewed By:
Review Date:
Review Notes:
**************************************************/


CREATE PROCEDURE [wrk].[sp_Contact_Custom]
AS 

MERGE INTO dbo.Contact_Custom Target
USING dbo.Contact source
ON source.[SSB_CRMSYSTEM_CONTACT_ID] = target.[SSB_CRMSYSTEM_CONTACT_ID]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([SSB_CRMSYSTEM_ACCT_ID], [SSB_CRMSYSTEM_CONTACT_ID]) VALUES (source.[SSB_CRMSYSTEM_ACCT_ID], Source.[SSB_CRMSYSTEM_CONTACT_ID])
WHEN NOT MATCHED BY SOURCE THEN
DELETE ;

EXEC dbo.sp_CRMProcess_ConcatIDs 'Contact';


--UPDATE a
--SET SeasonTicket_Years = recent.SeasonTicket_Years
----SELECT *
--FROM dbo.[Contact_Custom] a
--INNER JOIN dbo.CRMProcess_DistinctContacts recent ON [recent].[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]

UPDATE a
SET a.new_ssbcrmsystemssidwinner = b.[SSID]
, a.new_ssbcrmsystemssidwinnersourcesystem = b.SourceSystem
, a.mobilephone = b.PhoneCell
, a.telephone2 = b.PhoneHome
, a.new_telephone2_stripped = REPLACE(REPLACE(REPLACE(REPLACE(b.PhoneHome,'(',''),' ',''),'-',''),')','')
, a.new_telephone1_stripped = REPLACE(REPLACE(REPLACE(REPLACE(b.PhonePrimary,'(',''),' ',''),'-',''),')','')
, a.new_mobilephone_stripped = REPLACE(REPLACE(REPLACE(REPLACE(b.phonecell,'(',''),' ',''),'-',''),')','')
FROM [dbo].Contact_Custom a
INNER JOIN dbo.[vwCompositeRecord_ModAcctID] b ON b.[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]
WHERE b.[SSB_CRMSYSTEM_CONTACT_ID] = [a].[SSB_CRMSYSTEM_CONTACT_ID]

/*
===========================================
Total STH Spend 
===========================================
*/
SELECT ts.SSB_CRMSYSTEM_CONTACT_ID, SUM(ts.TotalRevenue) AS TotalRevenue  INTO #totalspend FROM (
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, SUM(fts.TotalRevenue) AS TotalRevenue
FROM Jets.dbo.FactTicketSales fts 
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod
		ON mod.DimCustomerId = fts.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc
		ON pc.DimPriceCodeId = fts.DimPriceCodeId
	JOIN Jets.dbo.DimPlan dp 
		ON dp.DimPlanId = fts.DimPlanId
WHERE  ( --fts.DimSeasonId = 14
                  ((pc.PC1 like ( '[A-X]' ) and pc.pc2 is null)
						OR (pc.PC1 like ( '[A-X]' ) and isnull(pc.PC2, '') = 't' ))
                 AND dp.PlanCode LIKE '18FS'
                 AND fts.IsComp <> 1)
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
	UNION 
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, SUM(fts2.TotalRevenue) AS TotalRevenue
FROM Jets.dbo.FactTicketSalesHistory fts2
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod 
		ON mod.DimCustomerId = fts2.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc
		ON pc.DimPriceCodeId = fts2.DimPriceCodeId
	JOIN Jets.dbo.DimPlan dp 
		ON dp.DimPlanId = fts2.DimPlanId
WHERE  ( --fts2.DimSeasonId = 14
                  ((pc.PC1 like ( '[A-X]' ) and pc.pc2 is null)
						OR (pc.PC1 like ( '[A-X]' ) and isnull(pc.PC2, '') = 't' ))
                 AND dp.PlanCode LIKE '18FS'
                 AND fts2.IsComp <> 1)
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
) AS ts 
GROUP BY ts.SSB_CRMSYSTEM_CONTACT_ID

UPDATE cc
SET cc.new_total_STH_spend = ts.TotalRevenue  
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #totalspend ts 
ON ts.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE ts.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID


/*
===========================================
STH Flag 
===========================================
*/
 

SELECT sf.SSB_CRMSYSTEM_CONTACT_ID, sf.STHflag INTO #STHflag FROM (
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID
	, CASE WHEN ((pc.PC1 like ( '[A-X]' ) and pc.pc2 is null
						OR (pc.PC1 like ( '[A-X]' ) and isnull(pc.PC2, '') = 't'))
                 AND dp.PlanCode LIKE '18FS'
                 AND fts.IsComp <> 1)
			THEN 1 
			ELSE 0 
			END AS STHflag
FROM Jets.dbo.FactTicketSales fts 
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod
		ON mod.DimCustomerId = fts.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc
		ON pc.DimPriceCodeId = fts.DimPriceCodeId
	JOIN Jets.dbo.DimPlan dp 
		ON dp.DimPlanId = fts.DimPlanId
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
	,pc.PC1
	,pc.PC2
	,dp.PlanCode
	,fts.IsComp
UNION 
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID
	, CASE WHEN ((pc.PC1 like ( '[A-X]' ) and pc.pc2 is null
						OR (pc.PC1 like ( '[A-X]' ) and isnull(pc.PC2, '') = 't'))
                 AND dp.PlanCode LIKE '18FS'
                 AND fts2.IsComp <> 1)
			THEN 1 
			ELSE 0 
			END AS STHflag
FROM Jets.dbo.FactTicketSalesHistory fts2
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod
		ON mod.DimCustomerId = fts2.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc
		ON pc.DimPriceCodeId = fts2.DimPriceCodeId
	JOIN Jets.dbo.DimPlan dp 
		ON dp.DimPlanId = fts2.DimPlanId
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
	,pc.PC1
	,pc.PC2
	,dp.PlanCode
	,fts2.IsComp
) AS sf 
GROUP BY sf.SSB_CRMSYSTEM_CONTACT_ID, sf.STHflag

UPDATE cc
SET cc.new_STH_Flag = sth.[STHflag] 
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #sthflag sth 
ON sth.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE sth.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
/*
===========================================
Total Group Spend 
===========================================
*/
SELECT g.SSB_CRMSYSTEM_CONTACT_ID, SUM(g.TotalGroupSpend) AS TotalGroupSpend INTO #group FROM (
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID
	,SUM(fts.BlockPurchasePrice) AS TotalGroupSpend
FROM Jets.dbo.FactTicketSales fts 
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod 
		ON mod.DimCustomerId = fts.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc 
		ON fts.DimPriceCodeId = pc.DimPriceCodeId
	JOIN Jets.dbo.DimEvent de 
		ON de.DimEventId = fts.DimEventId
WHERE pc.PC1 LIKE '[A-X]'
		AND pc.PC2 = 'G'
		AND de.EventCode like 'NYJ%'
		AND fts.IsComp = 0 
GROUP BY 
	mod.SSB_CRMSYSTEM_CONTACT_ID
UNION
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID
	,SUM(fts2.BlockPurchasePrice) AS TotalGroupSpend
FROM Jets.dbo.FactTicketSalesHistory fts2 
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod
		ON mod.DimCustomerId = fts2.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc 
		ON fts2.DimPriceCodeId = pc.DimPriceCodeId
	JOIN Jets.dbo.DimEvent de 
		ON de.DimEventId = fts2.DimEventId
WHERE pc.PC1 LIKE '[A-X]'
		AND pc.PC2 = 'G'
		AND de.EventCode like 'NYJ%'
		AND fts2.IsComp = 0 
GROUP BY 
	mod.SSB_CRMSYSTEM_CONTACT_ID 
) AS g	
GROUP BY g.SSB_CRMSYSTEM_CONTACT_ID

UPDATE cc
SET cc.new_total_group_spend = gs.TotalGroupSpend 
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #group gs
ON gs.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE gs.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID						 
/*
===========================================
Broker Flag 
===========================================
*/
SELECT b.SSB_CRMSYSTEM_CONTACT_ID, b.IsBroker AS IsBroker INTO #broker FROM (
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, fts.IsBroker
FROM Jets.dbo.FactTicketSales fts 
JOIN Jets.dbo.vwDimCustomer_ModAcctId mod
ON  mod.DimCustomerId = fts.DimCustomerId
WHERE fts.IsComp = 0
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID, 
	fts.IsBroker
UNION 
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, fts2.IsBroker
FROM Jets.dbo.FactTicketSalesHistory fts2 
JOIN Jets.dbo.vwDimCustomer_ModAcctId mod 
ON mod.DimCustomerId = fts2.DimCustomerId
WHERE fts2.IsComp = 0
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID, 
	fts2.IsBroker
) AS b
GROUP BY b.SSB_CRMSYSTEM_CONTACT_ID, b.IsBroker


UPDATE cc
SET cc.new_broker_flag = brk.IsBroker
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #broker brk 
ON brk.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE brk.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID 

/*
===========================================
Last email open date 
===========================================
*/
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, MAX(imc.Event_Timestamp) LastEmailOpen INTO #emailopen 
FROM Jets.ods.IMC_RawRecipient imc 
JOIN dbo.dimcustomer dc
ON dc.EmailPrimary = imc.Email
JOIN Jets.dbo.vwDimCustomer_ModAcctId mod
ON mod.DimCustomerId = dc.DimCustomerId
WHERE imc.Event_Type = 'Open'
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID

UPDATE cc
SET cc.new_last_email_open_date = eo.LastEmailOpen
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #emailopen eo 
ON eo.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE eo.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
/*
===========================================
STH since date -- original? What if they stopped buying for a couple years then came back? 
===========================================
*/
SELECT sd.SSB_CRMSYSTEM_CONTACT_ID, MIN(sd.sthdate) AS STH_Since_Date INTO #sthdate FROM (
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID
	,CASE WHEN ( --fts.DimSeasonId = 14
                  ((pc.PC1 like ( '[A-X]' ) and pc.pc2 is null)
						OR (pc.PC1 like ( '[A-X]' ) and isnull(pc.PC2, '') = 't' ))
                 AND dp.PlanCode LIKE '18FS'
                 AND fts.IsComp <> 1
				 AND MIN(dd.CalDate) <> NULL
				)
			THEN MIN(dd.CalDate)
			ELSE NULL  
			END AS sthdate
FROM Jets.dbo.FactTicketSales fts 
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod 
		ON mod.DimCustomerId = fts.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc
		ON pc.DimPriceCodeId = fts.DimPriceCodeId
	JOIN Jets.dbo.DimPlan dp 
		ON dp.DimPlanId = fts.DimPlanId
	JOIN Jets.dbo.DimDate dd 
		ON fts.DimDateId = dd.DimDateId
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
	,pc.PC1
	,pc.PC2
	,dp.PlanCode
	,fts.IsComp
	UNION 
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID
	,CASE WHEN ( --fts.DimSeasonId = 14
                  ((pc.PC1 like ( '[A-X]' ) and pc.pc2 is null)
						OR (pc.PC1 like ( '[A-X]' ) and isnull(pc.PC2, '') = 't' ))
                 AND dp.PlanCode LIKE '18FS'
                 AND fts2.IsComp <> 1
				 AND MIN(dd.CalDate) <> NULL
				)
			THEN MIN(dd.CalDate)
			ELSE NULL 
			END AS sthdate
FROM Jets.dbo.FactTicketSalesHistory fts2
	JOIN Jets.dbo.vwDimCustomer_ModAcctId mod 
		ON mod.DimCustomerId = fts2.DimCustomerId
	JOIN Jets.dbo.DimPriceCode pc
		ON pc.DimPriceCodeId = fts2.DimPriceCodeId
	JOIN Jets.dbo.DimPlan dp 
		ON dp.DimPlanId = fts2.DimPlanId
			JOIN Jets.dbo.DimDate dd 
		ON fts2.DimDateId = dd.DimDateId
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
	,pc.PC1
	,pc.PC2
	,dp.PlanCode
	,fts2.IsComp
) AS sd 
GROUP BY sd.SSB_CRMSYSTEM_CONTACT_ID

UPDATE cc
SET cc.new_STH_since_date = sd.STH_Since_Date
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #sthdate sd 
ON sd.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE sd.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID

/*
===========================================
STH Tenure USE jets.FortressRollover
===========================================
*/

SELECT st.SSB_CRMSYSTEM_CONTACT_ID, SUM(Tenure) AS STH_Tenure INTO #sthtenure FROM (
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, 
		roll.Tenure
FROM dbo.FactTicketSales fts 
	JOIN dbo.vwDimCustomer_ModAcctId mod 
		ON mod.DimCustomerId = fts.DimCustomerId
	JOIN jets.FortressRollover_toArchtics roll 
		ON roll.SSID_acct_id = fts.SSID_acct_id
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
	,roll.Tenure

UNION 
SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, 
		roll.Tenure
FROM dbo.FactTicketSalesHistory ftsh 
	JOIN dbo.vwDimCustomer_ModAcctId mod 
		ON mod.DimCustomerId = ftsh.DimCustomerId
	JOIN jets.FortressRollover roll 
		ON roll.SSID_acct_id = ftsh.SSID_acct_id
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID
	,roll.Tenure ) AS st 
GROUP BY st.SSB_CRMSYSTEM_CONTACT_ID

UPDATE cc
SET cc.new_STH_tenure = st.STH_Tenure
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #sthtenure st 
ON st.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE st.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID



/*
===========================================
Jets Loyalty Points Balance USE AZURE
===========================================
*/


SELECT mod.SSB_CRMSYSTEM_CONTACT_ID, SUM(CONVERT(INT,ft.loyaltyBalance)) AS LoyaltyBalance 
INTO #loyalty
FROM Jets.ods.Fortress_MemberBalanceInformation ft
JOIN Jets.dbo.vwDimCustomer_ModAcctId mod 
	 ON RIGHT(ft.patronID, LEN(ft.patronID) - 1) = mod.DimCustomerId
GROUP BY mod.SSB_CRMSYSTEM_CONTACT_ID

UPDATE cc
SET cc.new_loyalty_points_balance = l.LoyaltyBalance
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #loyalty l 
ON l.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE l.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID


/*
===========================================
Silverpop Opt Ins
===========================================
*/

SELECT mod.SSB_CRMSYSTEM_CONTACT_ID
	,CASE WHEN imc.Recipient_Type = 'Normal'
	THEN 1
	ELSE 0 
	END AS Silverpop_OptIns
INTO #optin
FROM Jets.dbo.vwDimCustomer_ModAcctId mod
	JOIN dbo.DimCustomer dc 
		ON mod.DimCustomerId = dc.DimCustomerId
	JOIN Jets.ods.IMC_RawRecipient imc 
		ON imc.Email = dc.EmailPrimary

UPDATE cc
SET cc.new_silverpop_opt_ins = o.Silverpop_OptIns
FROM Jets_Integration.dbo.Contact_Custom cc
LEFT JOIN #optin o
ON o.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE o.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID

/*
===========================================
PSL Holder 
===========================================
*/

SELECT DISTINCT dmac.SSB_CRMSYSTEM_CONTACT_ID, 1 AS [PSL Flag]
INTO #PSL
	FROM 
	Jets.dbo.FactTicketSales fts INNER JOIN 
	Jets.dbo.DimSeason ds ON fts.DimSeasonId = ds.DimSeasonId
	INNER JOIN Jets.dbo.vwDimCustomer_ModAcctId dmac ON dmac.DimCustomerId = fts.DimCustomerId AND dmac.SourceSystem = 'TM'
	WHERE ds.SeasonName = 'psl'	
	AND fts.BlockPurchasePrice > 0


SELECT dmac.SSB_CRMSYSTEM_CONTACT_ID
INTO #STH
FROM Jets.dbo.FactTicketSales fts (NOLOCK)
INNER JOIN Jets.dbo.DimPlan dp (NOLOCK) ON fts.DimPlanId = dp.DimPlanId
INNER JOIN Jets.dbo.vwDimCustomer_ModAcctId dmac ON dmac.DimCustomerId = fts.DimCustomerId AND dmac.SourceSystem = 'TM'
WHERE dp.PlanClass = 'FS'
AND fts.DimSeasonId = 34


SELECT DISTINCT #PSL.SSB_CRMSYSTEM_CONTACT_ID, [PSL Flag]  INTO #pslfinal
FROM #PSL INNER JOIN #STH ON #STH.SSB_CRMSYSTEM_CONTACT_ID = #PSL.SSB_CRMSYSTEM_CONTACT_ID

UPDATE cc
SET cc.new_PSL_holder = psl.[PSL Flag]
FROM dbo.Contact_Custom cc
LEFT JOIN #pslfinal psl
ON psl.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID
WHERE psl.SSB_CRMSYSTEM_CONTACT_ID = cc.SSB_CRMSYSTEM_CONTACT_ID


EXEC dbo.sp_CRMLoad_Contact_ProcessLoad_Criteria

GO
