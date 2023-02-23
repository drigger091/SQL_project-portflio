--list of SQL queries set up for the tableau visualization project

select *
from Portfolio_project1..covid_death$



--1) query 1
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, 
SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio_project1..covid_death$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



--Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2



--2) second query
-- i took these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe as in the SQL exploratio we discovered that there was certain inconsistency with the
-- continent column

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Portfolio_project1..covid_death$
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International','Upper middle income','Lower middle income',
'low income','High income')
Group by location
order by TotalDeathCount desc



-- query 3


Select Location, Population, MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as PercentPopulationInfected
From Portfolio_project1..covid_death$
where location not in ('World', 'European Union', 'International','Upper middle income','Lower middle income',
'low income','High income','North America','Asia','Oceania','Africa')
Group by Location,Population
order by PercentPopulationInfected desc



--query4


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount, 
Max((total_cases/population))*100 as PercentPopulationInfected
From Portfolio_project1..covid_death$
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc