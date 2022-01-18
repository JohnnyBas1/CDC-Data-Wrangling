CREATE TABLE #zoomin (
	Country nvarchar(255),
	Continent nvarchar(255)
)

Insert Into #zoomin 
Select location, continent
From [Portfolio Project].dbo.CovidDeaths$ og
Where continent = 'North America'
Group by location, continent



Select COUNT(Country)
From #zoomin

-- Result is 35!

Select COUNT(country)
From [Portfolio Project].dbo.NACountries
 -- Result is 32 countries!!

--Something is wrong: Different # of countries in North America.
DECLARE @string VARCHAR(8) = CONVERT(VARCHAR(MAX), 0xA000);
-- Get rids of padding
UPDATE [Portfolio Project].dbo.NACountries
SET Country = REPLACE(Country, @string, '')
--


Select* 
From #zoomin


-- Countries that are incorrectly labeled North America

CREATE TABLE #incorrect(
Incorrect nvarchar(255)
)
INSERT INTO #incorrect (Incorrect)
Select og.Country
From #zoomin og
Left Join [Portfolio Project].dbo.NACountries rl
	ON SUBSTRING(og.Country,1,9) = SUBSTRING(rl.country,1,9) -- FUZZY MATCHING
Where rl.country is NULL


Select*
From #incorrect

UPDATE [Portfolio Project].dbo.CovidDeaths$
	SET
		[Portfolio Project].dbo.CovidDeaths$.continent = NULL
	FROM [Portfolio Project].dbo.CovidDeaths$, #incorrect
	WHERE
		 [Portfolio Project].dbo.CovidDeaths$.location = #incorrect.Incorrect

Select location, Continent
From [Portfolio Project].dbo.CovidDeaths$
WHERE continent = 'South America'
Group by location, continent

UPDATE [Portfolio Project].dbo.CovidDeaths$
	SET
		[Portfolio Project].dbo.CovidDeaths$.continent = 'South America'
		FROM [Portfolio Project].dbo.CovidDeaths$
		WHERE
		[Portfolio Project].dbo.CovidDeaths$.location = 'Aruba'
		OR [Portfolio Project].dbo.CovidDeaths$.location = 'Bonaire Sint Eustatius and Saba'
		OR [Portfolio Project].dbo.CovidDeaths$.location  = 'Curacao'
-- Adding missing NA countries
/*Select *
From [Portfolio Project].dbo.NACountries

INSERT INTO [Portfolio Project].dbo.NACountries (Country)
Select og.Country
From #zoomin og
Left Join [Portfolio Project].dbo.NACountries rl
	ON SUBSTRING(og.Country,1,9) = SUBSTRING(rl.country,1,9) -- FUZZY MATCHING
Where rl.country is NULL AND NOT og.Country = 'Aruba' AND NOT og.Country = 'Bonaire Sint Eustatius and Saba' AND NOT og.Country = 'Curacao'
*/

--DELETE FROM [Portfolio Project].dbo.NACountries WHERE [Projected Population] is NULL
