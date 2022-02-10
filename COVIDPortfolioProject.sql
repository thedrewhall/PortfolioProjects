--Showing data in individual countries

SELECT *
FROM PortfolioProject..['CovidDeaths']
WHERE continent IS NOT null
ORDER BY 3,4
;

--Looking at total cases vs total deaths

--Shows likelihood of dying from COVID in United States over time

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..['CovidDeaths']
WHERE location LIKE '%states%'
ORDER BY 1,2
;


--Looking at total cases vs population

--Shows total percentage of population in United States has had COVID

SELECT location, date, total_cases, population, (total_cases/population*100 AS CasePercentage
FROM PortfolioProject..['CovidDeaths']
WHERE location LIKE '%states%'
ORDER BY 1,2
;


--Looking at countries with highest case percentage compared to population

SELECT location, MAX(total_cases) AS HighestInfectionCount, population, MAX((total_cases/population))*100 as CasePercentage
FROM PortfolioProject..['CovidDeaths']
WHERE continent IS NOT null
GROUP BY location, population
ORDER BY CasePercentage DESC
						;


--Looking at countries with highest death percentage compared to population
						 
SELECT location, MAX(cast(total_deaths AS int)) as TotalDeaths, population AS Population, MAX((total_deaths/population))*100 as DeathPercentage
FROM PortfolioProject..['CovidDeaths']
WHERE continent IS NOT null
GROUP BY location, population
ORDER BY DeathPercentage DESC
;


--BREAKING DEATHS DOWN BY CONTINENT

--Showing continents with highest total deaths

SELECT location as Location, MAX(cast(total_deaths AS int)) AS TotalDeaths
FROM PortfolioProject..['CovidDeaths']
WHERE continent IS null
GROUP BY location
ORDER BY TotalDeaths DESC
;


--North America

SELECT location AS Country, MAX(cast(total_deaths AS int)) AS TotalDeaths
FROM PortfolioPRoject..['CovidDeaths']
WHERE continent  = 'North America'
GROUP BY location
ORDER BY TotalDeaths DESC
;

--South America

SELECT location AS Country, MAX(cast(total_deaths AS int)) AS TotalDeaths
FROM PortfolioPRoject..['CovidDeaths']
WHERE continent  = 'South America'
GROUP BY location
ORDER BY TotalDeaths DESC
;						 

--Europe

SELECT location AS Country, MAX(cast(total_deaths AS int)) AS TotalDeaths
FROM PortfolioPRoject..['CovidDeaths']
WHERE continent  = 'Europe'
GROUP BY location
ORDER BY TotalDeaths DESC
;


--Africa

SELECT location AS Country, MAX(cast(total_deaths AS int)) AS TotalDeaths
FROM PortfolioPRoject..['CovidDeaths']
WHERE continent  = 'Africa'
GROUP BY location
ORDER BY TotalDeaths DESC
;


--Asia

SELECT location AS Country, MAX(cast(total_deaths AS int)) AS TotalDeaths
FROM PortfolioPRoject..['CovidDeaths']
WHERE continent  = 'Asia'
GROUP BY location
ORDER BY TotalDeaths DESC
;


--Oceania

SELECT location AS Country, MAX(cast(total_deaths AS int)) AS TotalDeaths
FROM PortfolioPRoject..['CovidDeaths']
WHERE continent  = 'Oceania'
GROUP BY location
ORDER BY TotalDeaths DESC
;

--GLOBAL NUMBERS

--Cases and Deaths Per Day

SELECT date, SUM(new_cases) AS TotalCases, SUM(cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..['CovidDeaths']
WHERE continent IS NOT null
GROUP BY date
ORDER BY 1,2
;


--Total Numbers Globally
						 
SELECT SUM(new_cases) AS TotalCases, SUM(Cast(new_deaths AS int)) AS TotalDeaths, SUM(cast(new_deaths AS int)/SUM(new_cases)*100 AS DeathPercentage
FROM PortfolioProject..['CovidDeaths']
WHERE continent IS NOT null
ORDER BY 1,2 
;


--Looking at Total Population vs Vaccinations
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, VaccinatedToDate)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS VaccinatedToDate
FROM PortfolioProject..['CovidDeaths'] dea
JOIN PortfolioProject..['CovidVaccinations'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
)
SELECT *, (VaccinatedToDate/Population)*100 AS PercentageVaccinated
FROM PopvsVac
;


--Percentage of Population Vaccinated by Country
--TEMP Table

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccinatedToDate numeric
)


INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS VaccinatedToDate
FROM PortfolioProject..['CovidDeaths'] dea
JOIN PortfolioProject..['CovidVaccinations'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null


SELECT *, (VaccinatedToDate/Population)*100 AS PercentageVaccinated
FROM #PercentPopulationVaccinated
;


--Creating View to store data for later visualizations

CREATE VIEW PercentPopulatonVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition BY dea.location ORDER BY dea.location, dea.date) AS VaccinatedToDate
FROM PortfolioProject..['CovidDeaths'] dea
JOIIN PortfolioProject..['CovidVaccinations'] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT null
;

SELECT *
FROM PercentPopulatonVaccinated
;
