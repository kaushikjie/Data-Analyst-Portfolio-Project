/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/


--create database PortfolioProject

--select * 
--from coviddeaths
--order by 3,4

--Select *
--From PortfolioProject..CovidDeaths
--Where continent is not null 
--order by 3,4

--select * 
--from covidVaccinations
--order by 3,4

/* Select data that are going to use*/

--select location, DATE, total_cases,new_cases,total_deaths, population
--from coviddeaths
--where location like 'india'
--order by 1,2

--alter table coviddeaths
--alter column total_deaths int;

--alter table coviddeaths
--alter column total_cases int;

--alter table coviddeaths
--alter column total_cases_per_million float;

--alter table coviddeaths
--alter column total_deaths_per_million float;

--alter table coviddeaths
--alter column reproduction_rate float;


/* Looking at total deaths over total cases as in percentage*/

--select location, DATE, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
--from coviddeaths
--where location like 'INDIA'
--order by 1,2


/* Looking at total cases of covid-19 over total population as in percentage*/

--select location, DATE, total_cases, population, (total_cases/population) * 100 as CasePercentage
--from coviddeaths
--where location like 'india'
--order by 1,2




/* Looking at countries with Highest Infection Rate compared to Population*/

--select location, population, MAX(total_cases) as HghestInfectionCount, MAX((total_cases/population)*100) as PercentPopualtionInfected
--from coviddeaths
--where continent is not null
--group by location, population
--order by PercentPopualtionInfected desc 


/* Showing highest death count per population*/

--select location, population, MAX(cast(total_deaths as int))as TotalDeathCount
--from coviddeaths
----where location like 'india'
--where continent is not null
--group by location, population
--order by TotalDeathCount desc 


/* Let's breakup things by continent
:
*/
--select continent, SUM(cast(new_deaths as int)) as DeathCountPerContinent
--from coviddeaths
--where continent is not null
--group by continent
--order by DeathCountPerContinent


/* Let's see each day cases and each day deaths also each day death percentage in relation to date worldwide.
*/

--select DATE, SUM(new_cases) as NewCasesEachDay, SUM(cast(new_deaths as int)) as NewDeathsEachDay,
--(SUM(cast(new_deaths as int))/SUM(new_cases)) * 100 as DailyDeathPercentage
--from coviddeaths
--where continent is not null
--group by date
--order by date



/*Joining coviddeaths table with covidvaccinations*/

--select * 
--from coviddeaths dea
--join covidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date


/* Looking at total population vs total vaccines done in relation to date,location and also new_deaths and new_cases happend in relation to date 
and location.*/

--select dea.continent, dea.location,dea.date,dea.population,dea.new_cases,dea.new_deaths,vac.new_vaccinations,
--SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccines_Per_Location
--from coviddeaths dea
--join covidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3


/* Using CTE  and Percentage of people got vaccianted in any location? */

--with pop_vs_vac (continent, location, date, population, new_cases, new_deaths, new_vaccinations, Rolling_Vaccines_Per_Location)
--as 
--(
--select dea.continent, dea.location,dea.date,dea.population,dea.new_cases,dea.new_deaths,vac.new_vaccinations,
--SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccines_Per_Location
--from coviddeaths dea
--join covidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null
--)
--select *, (Rolling_Vaccines_Per_Location/population) * 100 as Percent_Population_Vaccianted 
--from pop_vs_vac



/* Using Temp Tables and again to find what percenatge of people got vaccinated in any location in relation to the location population?*/

--drop table if exists #PercentPopulationVaccinated
--create table #PercentPopulationVaccinated
--(
--continent nvarchar(500),
--location nvarchar (500),
--date datetime,
--population numeric,
--new_cases numeric,
--new_deaths numeric,
--new_vaccinations numeric,
--Rolling_Vaccines_Per_Location numeric
--)
--insert into #PercentPopulationVaccinated
--select dea.continent, dea.location,dea.date,dea.population,dea.new_cases,dea.new_deaths,vac.new_vaccinations,
--SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccines_Per_Location
--from coviddeaths dea
--join covidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null


--select *, (Rolling_Vaccines_Per_Location/population)*100 as Percent_Population_Vaccianted
--from #PercentPopulationVaccinated



/* Creating a view to store data for future/later data visualisations*/

--create view PercentPopulationVaccinated as 
--select dea.continent, dea.location,dea.date,dea.population,dea.new_cases,dea.new_deaths,vac.new_vaccinations,
--SUM(convert(int,vac.new_vaccinations )) over (partition by dea.location order by dea.location, dea.date) as Rolling_Vaccines_Per_Location
--from coviddeaths dea
--join covidVaccinations vac
--	on dea.location = vac.location
--	and dea.date = vac.date
--where dea.continent is not null

--select * from percentpopulationvaccinated





