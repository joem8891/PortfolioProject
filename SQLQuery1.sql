--select * from 
--[dbo].['Covid Deaths$']


--select * from 
--[dbo].['Covid Vaccination$']


select location, date,total_cases, total_deaths, population 
from [dbo].['Covid Deaths$']
order by 1,2

-- Looking at total cases vs total deaths

select location, date,total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
from [dbo].['Covid Deaths$']
where location like '%states%' 
order by 1,2

-- Looking at total cases vs populations

select location, date,total_cases, population, (total_cases/population) * 100 as PercentofPopulation
from [dbo].['Covid Deaths$']
--where location like '%states%' 
order by 1,2

-- Looking at countries with highest infection rate  comapred to population

select location, Population ,max(total_cases) as highestInfectionCount, Max (total_cases/population) * 100 as PercentofPopulationInfected
from [dbo].['Covid Deaths$']
--where location like '%states%' 
Group by location, population
order by PercentofPopulationInfected desc

-- Showing Countries with highest death count per population

select location, Max (cast(total_deaths as int)) as Totaldeathcount
from [dbo].['Covid Deaths$']
--where location like '%states%' 
Group by location
order by Totaldeathcount desc

--- Analysis by Continent

select continent, Max (cast(total_deaths as int)) as Totaldeathcount
from [dbo].['Covid Deaths$']
--where location like '%states%' 
Where continent is not null
Group by continent
order by Totaldeathcount desc

-- Global Numbers

Select sum (new_cases) as totalCases, sum ( cast(new_deaths as int)) as TotalDeath, sum(cast (new_deaths As INT))/sum(new_cases)*100 as DeathPercentage
from [dbo].['Covid Deaths$'] 
Where continent is not null
--Group by date
order by 1,2 

----- Total Population vs Vaccination

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)

as 

(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum (convert (BIGINT,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/Population)*100
From PortofolioProject..['Covid Deaths$'] dea
join PortofolioProject..['Covid Vaccination$'] vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

-- USET CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)

as 

(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum (convert (BIGINT,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/Population)*100
From PortofolioProject..['Covid Deaths$'] dea
join PortofolioProject..['Covid Vaccination$'] vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac

--- Temp table


Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeoplevaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum (convert (BIGINT,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/Population)*100
From PortofolioProject..['Covid Deaths$'] dea
join PortofolioProject..['Covid Vaccination$'] vac
     on dea.location = vac.location
     and dea.date = vac.date
--where dea.continent is not null
--order by 2,3
Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


-- Creating view to store data for later visualizations

Create view PercentpopulationVaccinated as
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, sum (convert (BIGINT,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated/Population)*100
From PortofolioProject..['Covid Deaths$'] dea
join PortofolioProject..['Covid Vaccination$'] vac
     on dea.location = vac.location
     and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *
From [dbo].[PercentpopulationVaccinated]