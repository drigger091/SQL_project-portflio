/*

covid 19 data exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/



select *
from Portfolio_project1..covid_death$
where continent is not null
order by 3,4

--select *
--from Portfolio_project1..covid_vaccinations$
--order by 3,4

--selecting the data we are going to be using

select location,date,total_cases,new_cases,total_deaths,population
from Portfolio_project1..covid_death$
where continent is not null
order by 1,2

--new way of showing the head data
select location,date,total_cases,new_cases,total_deaths,population
from Portfolio_project1..covid_death$
--group by location 
where continent is not null
order by total_deaths desc


-- looking at total cases vs totalDeaths
-- shows the likelihood of dying if one contracts covid in their country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from Portfolio_project1..covid_death$
--where location like '%states%'
where continent is not null
order by 1,2

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from Portfolio_project1..covid_death$
where location like 'India'
and  continent is not null
order by 1,2




--lookng at the total cases vs the population
-- shows what percentage got covid
select location,date,population,total_cases,(total_cases/population)*100 as contractpercentage
from Portfolio_project1..covid_death$
where location like '%states%'
 and  continent is not null
order by 1,2

select location,date,population,total_cases,(total_cases/population)*100 as contractpercentage
from Portfolio_project1..covid_death$
where location like 'India'
and  continent is not null
order by 1,2

--which countries has the highest infection rate
select location,population,MAX(total_cases) as  highestinfectioncount,MAX((total_cases/population))*100 as contractpercentage
from Portfolio_project1..covid_death$
--where location like '%states%'
where continent is not null
group by location,population
order by contractpercentage desc






--showing the countries with highest death count per population
--death is used as a varchar we change it to int using cast
select location ,MAX(cast(total_deaths as int))as totalDeathcount
from Portfolio_project1..covid_death$
--where location like 'canada'
where continent is not null
Group by location
order by totalDeathcount desc



-- BREAKING THINGS DOWN BY CONTINENT


-- showing the continents with the highest death counts
select continent ,MAX(cast(total_deaths as int))as totalDeathcount
from Portfolio_project1..covid_death$
where continent is not null
Group by continent
order by totalDeathcount desc


--showing countries with the highest infection rate continent wise

select location,MAX(total_cases) as  highestinfectioncount,MAX((total_cases/population))*100 as contractpercentage
from Portfolio_project1..covid_death$
where continent like 'Asia'
and continent is not null
group by location
order by contractpercentage desc





--showing countries with the highest death toll rate continent wise

select location ,MAX(cast(total_deaths as int))as totalDeathcount
from Portfolio_project1..covid_death$
where continent like 'north%'
and continent is not null
Group by location
order by totalDeathcount desc





-- Global numbers

select date,SUM(new_cases) as totalcases,SUM(CAST(new_deaths as int)) as totaldeaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100
as Deathpercentage
from Portfolio_project1..covid_death$
--where location like 'India'
where  continent is not null
group by date
order by Deathpercentage desc
--order by 1,2

--finding out the total cases and deaths globally
select SUM(new_cases) as totalcases,SUM(CAST(new_deaths as int)) as totaldeaths,
SUM(CAST(new_deaths as int))/SUM(new_cases)*100
as Deathpercentage
from Portfolio_project1..covid_death$
--where location like 'India'
where  continent is not null
--group by date
--order by Deathpercentage desc
--order by 1,2

-- fetching the second table for more information
select *
from Portfolio_project1..covid_vaccinations$


-- JOINING THE TWO TABLES covid_deaths and covid_Vaccinations on location and date
select *
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date

--looking at total population vs total vaccinations

select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

order by 2,3




--looking for total population vs total vaccinations(adding up using partition by)using new_vaccinations perday

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.location 
, dea.date) as rollingpeopleVaccinated
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
and dea.location like '%states%'
order by 2,3


--using CTE

with popvsvac(Continent,location,Date,Population,new_vaccinations,rollingpeopleVaccinated)
as
(

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.location 
, dea.date) as rollingpeopleVaccinated
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
and dea.location like '%states%'
--order by 2,3
)

select *,(rollingpeopleVaccinated/Population)*100
from popvsvac

-- temp table
Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rollingpeopleVaccinated numeric
)



insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations )) OVER (Partition by dea.location Order by dea.location 
, dea.date) as rollingpeopleVaccinated
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- dea.location like '%states%'
--order by 2,3

select *,(rollingpeopleVaccinated/Population)*100
from #PercentPopulationVaccinated








-- checking the vaccination rate

select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations,
(vac.new_vaccinations/dea.population)*100 as vaccinationRate
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--and dea.continent like '%america'
and vac.new_vaccinations is not null
order by 1,2




--creating views to store data for later visualizations

Create view PercentPopulationVaccinated as
select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations,
(vac.new_vaccinations/dea.population)*100 as vaccinationRate
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--and dea.continent like '%america'
and vac.new_vaccinations is not null
--order by 1,2



--create views for population vs new vaccinations

Create view Vaccinationvslocationandpopulation as
select dea.continent ,dea.location,dea.date,dea.population,vac.new_vaccinations
from Portfolio_project1..covid_death$ dea
join Portfolio_project1..covid_vaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

--order by 2,3
