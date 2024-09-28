
  SELECT 
	c.CustomerID,
	c.CustomerName,
	c.Email,
	c.Gender,
	c.Age,
	g.Country,
	g.City
FROM dbo.customers AS c
LEFT JOIN
	dbo.geography g
ON c.GeographyID = g.GeographyID;