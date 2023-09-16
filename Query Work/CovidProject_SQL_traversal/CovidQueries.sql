/* 
   This is a project of exploring Covid 19 data

   Skills used: Joins, CTE's ,Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Test selection to see if all the data has been imported into SSMS

Select*
From CovidProject..CovidDeaths
Order by 3,4

Select*
From CovidProject..CovidVaccinations
Order by 3,4

-- Selection of all the data that has continents with filled in values. E.g Conitnet Name

Select*
From CovidProject..CovidDeaths
Where continent is not null
Order by 3,4

-- The selection of keypicked data that is being viewed 
--> Use of convert to resolve an error for numbers presented

Select Location, date, total_cases, new_cases, total_deaths, CONVERT (numeric,population) as Population
From CovidProject..CovidDeaths
Where continent is not null 
order by 1,2

--Selection of location and population density to see if death will effect the density

Select location,total_cases,total_deaths,population_density
From CovidProject..CovidDeaths
Order by location

-- Cases vs deaths in Lithuania
-- The percentage of the population that is infected by Covid and have died in Lithuania

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From CovidProject..CovidDeaths
Where Location = 'Lithuania'
and continent is not null 
order by 1,2

--Countries with the comparison of population and infection

Select Location, CONVERT(numeric,Population) as Population , MAX(total_cases) as TheHighestInfection,  Max((total_cases/population))*100 as PercentInfected
From CovidProject..CovidDeaths
Group by Location, Population
order by PercentInfected desc


-- The continents grouped together showing total deaths per continent

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Total number of cases and deaths per day around the world

Select date, SUM(new_cases) as All_Cases, SUM (cast(new_deaths as int)) as All_Deaths
From CovidProject..CovidDeaths
Where continent is not null
Group by date
Order by 1,2

-- The total number of cases and deaths

Select SUM(new_cases) as All_Cases, SUM (cast(new_deaths as int)) as All_Deaths
From CovidProject..CovidDeaths
Where continent is not null
Order by 1,2

--Joining the tables

Select *
From CovidProject..CovidDeaths Deaths
Join CovidProject..CovidVaccinations Vaccinations
On Deaths.location = Vaccinations.location 
and Deaths.date = Vaccinations.date

-- The number of new vaccinations each day

Select Death.continent, Death.location, Death.date, CONVERT (numeric, Death.population )as Population, Vaccinations.new_vaccinations
From CovidProject..CovidDeaths Death
Join CovidProject..CovidVaccinations Vaccinations
	On Death.location = Vaccinations.location
	and Death.date = Vaccinations.date
where Death.continent is not null 
order by 1,2,3

-- Temp table for calculating Number of vaccinations occuring each day and percent of population vaccinated

DROP Table if exists #PercentOfVaccinations
Create Table #PercentOfVaccinations
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingVaccinations numeric
)
Insert into #PercentOfVaccinations
Select Death.continent, Death.location, Death.date, Death.population, Vaccinations.new_vaccinations, SUM(CONVERT(int,Vaccinations.new_vaccinations)) OVER (Partition by Death.location Order by Death.location, Death.date) as RollingVaccinations
From CovidProject..CovidDeaths Death
Join CovidProject..CovidVaccinations Vaccinations
	On Death.location = Vaccinations.location
	and Death.date = Vaccinations.date
where Death.continent is not null

Select *, (RollingVaccinations/Population)*100
From #PercentOfVaccinations

-- CTE of calculation between population and rolling vaccinations

With VaccinatedPopulation (Continent, Location, Date, population, new_vaccinationss, RollingVaccinations)
as(
Select Death.continent, Death.location, Death.date, Death.population, Vaccinations.new_vaccinations
, SUM(CONVERT(int,Vaccinations.new_vaccinations)) OVER (Partition by Death.Location Order by Death.location, Death.Date) as RollingVaccinations
From CovidProject..CovidDeaths Death
Join CovidProject..CovidVaccinations Vaccinations
	On Death.location = Vaccinations.location
	and Death.date = Vaccinations.date
where Death.continent is not null 
)
Select *, (RollingVaccinations/population)*100 as PercentVaccinated
From VaccinatedPopulation

-- Creation of views for later visualizations

Create View Total_Deaths as
Select Location, date, total_cases, new_cases, total_deaths, CONVERT (numeric,population) as Population
From CovidProject..CovidDeaths
Where continent is not null 

Create View Infection_Percent as 
Select Location, CONVERT(numeric,Population) as Population , MAX(total_cases) as TheHighestInfection,  Max((total_cases/population))*100 as PercentInfected
From CovidProject..CovidDeaths
Group by Location, Population

Create View Lithuania_Infections as
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From CovidProject..CovidDeaths
Where Location = 'Lithuania'
and continent is not null 

