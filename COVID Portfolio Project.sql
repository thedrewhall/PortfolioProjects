--Showing data in individual countries
SELECT *
FROM PortfolioProject..['CovidDeaths']
Where continent is not null
order by 3,4
;

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..['CovidDeaths']
Where continent is not null
order by 1,2
;


--Looking at total cases vs total deaths
--Shows likelihood of dying from COVID in United States over time
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
where Location like '%states%'
order by 1,2
;


--Looking at total cases vs population
--Shows total percentage of population in United States has had COVID
Select Location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
From PortfolioProject..['CovidDeaths']
where Location like '%states%'
order by 1,2
;


--Looking at countries with highest case percentage compared to population

Select Location, MAX(total_cases) as HighestInfectionCount, population, MAX((total_cases/population))*100 as CasePercentage
From PortfolioProject..['CovidDeaths']
--where Location like '%states%'
Where continent is not null
Group by Location, Population
order by CasePercentage desc
;


--Looking at countries with highest death percentage compared to population

Select Location, MAX(cast(total_deaths as int)) as TotalDeaths, population as Population, MAX((total_deaths/population))*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
--where Location like '%states%'
Where continent is not null
Group by Location, Population
order by DeathPercentage desc
;


--BREAKING DEATHS DOWN BY CONTINENT

--Showing continents with highest total deaths

Select location as Location, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..['CovidDeaths']
Where continent is null
Group by location
Order by TotalDeaths desc
;


--North America

Select location as Country, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..['CovidDeaths']
Where continent = 'North America'
Group by location
Order by TotalDeaths desc
;

--South America

Select location as Country, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..['CovidDeaths']
Where continent = 'South America'
Group by location
Order by TotalDeaths desc
;

--Europe

Select location as Country, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..['CovidDeaths']
Where continent = 'Europe'
Group by location
Order by TotalDeaths desc
;


--Africa

Select location as Country, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..['CovidDeaths']
Where continent = 'Africa'
Group by location
Order by TotalDeaths desc
;


--Asia

Select location as Country, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..['CovidDeaths']
Where continent = 'Asia'
Group by location
Order by TotalDeaths desc
;


--Oceania

Select location as Country, Max(cast(total_deaths as int)) as TotalDeaths
From PortfolioProject..['CovidDeaths']
Where continent = 'Oceania'
Group by location
Order by TotalDeaths desc
;

--GLOBAL NUMBERS

--Cases and Deaths Per Day

Select date, SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
Where continent is not null
Group By Date
Order by 1, 2
;


--Total Numbers Globally

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..['CovidDeaths']
Where continent is not null
Order by 1, 2
;


--Looking at Total Population vs Vaccinations
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, VaccinatedToDate)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as VaccinatedToDate
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (VaccinatedToDate/Population)*100 as PercentageVaccinated
From PopvsVac
;


--Percentage of Population Vaccinated by Country
--TEMP Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
VaccinatedToDate numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as VaccinatedToDate
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null


Select *, (VaccinatedToDate/Population)*100 as PercentageVaccinated
From #PercentPopulationVaccinated
;


--Creating View to store data for later visualizations

Create View PercentPopulatonVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as VaccinatedToDate
From PortfolioProject..['CovidDeaths'] dea
Join PortfolioProject..['CovidVaccinations'] vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
;

Select *
From PercentPopulatonVaccinated
;