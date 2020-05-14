CREATE PROCEDURE BI.spSalesDateScenario
(
	@CalYear AS VARCHAR(MAX)
,	@ProductCat AS VARCHAR(MAX)
,	@CustomerCountry AS VARCHAR(MAX)
,	@DateScenario AS INT
)
AS
--Order date scenario
IF @DateScenario = 1
SELECT
	D.[Date]
,	C.[Customer Alternate Key] AS [Customer ID]
,	C.[Customer Name]
,	P.[Product Name]
,	C.[Customer City]
,	C.[Customer State Province]
,   F.[Product Standard Cost] AS [Cost]
,	SUM(F.[Order Quantity] * F.[Unit Price]) AS [Sales]
FROM
[BI].[vFact_InternetSales] AS F
INNER JOIN [BI].[vDim_FinDate] AS D ON 
	F.[Order Date Key] = D.[Date Key]
INNER JOIN [BI].[vDim_Product] AS P
	ON F.[Product Key] = P.[Product Key]
INNER JOIN BI.vDim_Customer AS C
	ON F.[Customer Key] = C.[Customer Key]
WHERE 
	D.[Calendar Year] IN (SELECT value FROM STRING_SPLIT(@CalYear,',')) AND
	P.[Product Category] IN (SELECT value FROM STRING_SPLIT(@ProductCat,',')) AND
	C.[Customer Country] IN (SELECT value FROM STRING_SPLIT(@CustomerCountry,','))
GROUP BY 
	F.[Product Standard Cost]
,	D.[Date]
,	C.[Customer Alternate Key]
,	C.[Customer Name]
,	P.[Product Name]
,	C.[Customer City]
,	C.[Customer State Province]


--Shipping date scenario
IF @DateScenario = 2
SELECT
	D.[Date]
,	C.[Customer Alternate Key] AS [Customer ID]
,	C.[Customer Name]
,	P.[Product Name]
,	C.[Customer City]
,	C.[Customer State Province]
,   F.[Product Standard Cost] AS [Cost]
,	SUM(F.[Order Quantity] * F.[Unit Price]) AS [Sales]
FROM
[BI].[vFact_InternetSales] AS F
INNER JOIN [BI].[vDim_FinDate] AS D ON 
	F.[Ship Date Key] = D.[Date Key]
INNER JOIN [BI].[vDim_Product] AS P
	ON F.[Product Key] = P.[Product Key]
INNER JOIN BI.vDim_Customer AS C
	ON F.[Customer Key] = C.[Customer Key]
WHERE 
	D.[Calendar Year] IN (SELECT value FROM STRING_SPLIT(@CalYear,',')) AND
	P.[Product Category] IN (SELECT value FROM STRING_SPLIT(@ProductCat,',')) AND
	C.[Customer Country] IN (SELECT value FROM STRING_SPLIT(@CustomerCountry,','))
GROUP BY 
	F.[Product Standard Cost]
,	D.[Date]
,	C.[Customer Alternate Key]
,	C.[Customer Name]
,	P.[Product Name]
,	C.[Customer City]
,	C.[Customer State Province]

--Due date scenario
IF @DateScenario = 3
SELECT
	D.[Date]
,	C.[Customer Alternate Key] AS [Customer ID]
,	C.[Customer Name]
,	P.[Product Name]
,	C.[Customer City]
,	C.[Customer State Province]
,   F.[Product Standard Cost] AS [Cost]
,	SUM(F.[Order Quantity] * F.[Unit Price]) AS [Sales]
FROM
[BI].[vFact_InternetSales] AS F
INNER JOIN [BI].[vDim_FinDate] AS D ON 
	F.[Due Date Key] = D.[Date Key]
INNER JOIN [BI].[vDim_Product] AS P
	ON F.[Product Key] = P.[Product Key]
INNER JOIN BI.vDim_Customer AS C
	ON F.[Customer Key] = C.[Customer Key]
WHERE 
	D.[Calendar Year] IN (SELECT value FROM STRING_SPLIT(@CalYear,',')) AND
	P.[Product Category] IN (SELECT value FROM STRING_SPLIT(@ProductCat,',')) AND
	C.[Customer Country] IN (SELECT value FROM STRING_SPLIT(@CustomerCountry,','))
GROUP BY 
	F.[Product Standard Cost]
,	D.[Date]
,	C.[Customer Alternate Key]
,	C.[Customer Name]
,	P.[Product Name]
,	C.[Customer City]
,	C.[Customer State Province]