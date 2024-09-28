--Common Table Expression (CTE) to identify and tag duplicate records
WITH DuplicateRecords AS (
	SELECT 
		JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		Stage,
		Action,
		Duration,

		ROW_NUMBER() OVER (
			PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
			ORDER BY JourneyID)
		AS row_num
	FROM dbo.customer_journey)


-- select all records from the CTE where row_num > 1, which indicates duplicate entries
SELECT *
FROM DuplicateRecords
WHERE row_num > 1
ORDER BY JourneyID

--select the final cleaned and standardized data
SELECT
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	Action,
	COALESCE(Duration, avg_duration) AS Duration

FROM (
--subquery to process and clean the data
	SELECT	
		JourneyID,
		CustomerID,
		ProductID,
		VisitDate,
		UPPER(Stage) AS Stage,
		Action,
		Duration,
		AVG(Duration) OVER (PARTITION BY VisitDate) AS avg_duration,
		ROW_NUMBER() OVER (
			PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action
			ORDER BY JourneyID)
			AS row_num
		FROM dbo.customer_journey) AS subquery
	WHERE row_num = 1;

	
  
