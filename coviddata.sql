
Select * 
From PortofolioProject..CovidDeaths
where continent is not null
order by 3,4

Select * 
From PortofolioProject..CovidVaccination
order by 3,4
drop table PortofolioProject..CovidVaccination

--Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortofolioProject..CovidDeaths
order by 1,2

--Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
where location like '%indonesia%'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got covid

Select Location, date, total_cases, Population, (total_cases/Population)*100 as CasesPercentage
From PortofolioProject..CovidDeaths
--where location like '%indonesia%'
order by 1,2

--Looking at Countries with Highest Infection Rate Compared to Population

Select Location, Population, max(total_cases) as HighestInfectionCount, max(total_cases/Population)*100 as PercentPopulationInfected
From PortofolioProject..CovidDeaths
--where location like '%indonesia%'
Group by Location, Population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, max(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
--where location like '%indonesia%'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
--where location like '%indonesia%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--Showing continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount
From PortofolioProject..CovidDeaths
--where location like '%indonesia%'
where continent is not null
Group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

Select sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths ,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortofolioProject..CovidDeaths
--where location like '%indonesia%'
where continent is not null
--Group by date
order by 1,2

--Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3


--USE CTE

with PopvsVac (Continent, location, date, population, New_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select * , (RollingPeopleVaccinated/population)*100
from PopvsVac

-- TEMP TABLE

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
 
insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select * , (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated

--Creating View to store data for later visualizations

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortofolioProject..CovidDeaths dea
join PortofolioProject..CovidVaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from dbo.PercentPopulationVaccinated










