

--Select *
--From [Portfolio Project]..CovidVaccinations$
--order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portfolio Project]..CovidDeaths$
order by 1, 2


-- Looking at Total Cases vs Total Deaths

Select Location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_deaths/population))*100 as PercentPopulationInfected
From [Portfolio Project]..CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc



-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2, 3

-- Using CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Temp Table
Drop Table if exists #PercentPopVac
Create Table #PercentPopVac
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopVac
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopVac

-- Create view to store data for later visualization

CREATE VIEW PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
From [Portfolio Project]..CovidDeaths$ dea
Join [Portfolio Project]..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null

SELECT TOP (1000) [continent]
		,[location]
		.[date]
	FROM [Portfolio Project].[dbo].[PercentPopulationVaccinated]