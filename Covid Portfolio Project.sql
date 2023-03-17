Select *
from Porfolioprojects ..Coviddeaths
where continent is not null
order by 3 ,4


Select location, date, total_cases, new_cases,total_deaths, population
from Porfolioprojects ..Coviddeaths
order by 1,2

---looking at total cases vs total death


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
from Porfolioprojects..Coviddeaths
where location like '%states%'
order by 1,2

---Total cases vs Population
---Shows what percentage of population got covid


Select location, date, population, total_cases, (total_cases/population)*100 as Deathpercentage
from Porfolioprojects..Coviddeaths
where location like '%states%'
order by 1,2

---Countries with highest infection rate compared to population

Select location, population, MAX (total_cases) as highestinfectionCount, MAX ((total_cases/population))*100 as Percentagepopulationinfected
from Porfolioprojects ..Coviddeaths
group by Location, population
order by Percentagepopulationinfected desc


---Countries with the Highest dealth count per popolulation
Select location, MAX (total_deaths) as totaldeathsCount
from Porfolioprojects ..Coviddeaths
where continent is not null
group by Location 
order by totaldeathsCount desc


---Continents

Select Continent, MAX (total_deaths) as totaldeathsCount
from Porfolioprojects ..Coviddeaths
---where location like '%state%'
where continent is not null
group by Continent 
order by totaldeathsCount desc

Select location, MAX (total_deaths) as totaldeathsCount
from Porfolioprojects ..Coviddeaths
where continent is null
group by Location 
order by totaldeathsCount desc

---Continents with the highest death count per population

Select Continent, MAX (total_deaths) as totaldeathsCount
from Porfolioprojects ..Coviddeaths
---where location like '%state%'
where continent is not null
group by Continent 
order by totaldeathsCount desc

---Global Numbers

Select date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercentage
from Porfolioprojects ..Coviddeaths
---where location like '%state%'
where continent is not null 
order by 1,2

----GLOBAL NUMBERS

Select SUM(new_cases) AS total_cases, SUM (new_deaths) as total_deaths, SUM (new_cases)*100 as Deathpercentage
from Porfolioprojects ..Coviddeaths
     ---where location like '%state%'
where continent is not null
---group by date
order by 1,2


--Looking at total population vs vacinnations

select dea.continent,dea.location,dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (PARTITION by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated 
,(rollingpeoplevaccinated/population)*100
from Porfolioprojects..Coviddeaths dea
join Porfolioprojects..Covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

----Use CTE

with Popvsvac (continent, location,date,population, new_vaccinations, rollingpeoplevaccinated) 
as
(
select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (PARTITION by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated 
   ---,(rollingpeoplevaccinated/population)*100
from Porfolioprojects..Coviddeaths dea
join Porfolioprojects..Covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
----order by 2,3
)
Select*,(rollingpeoplevaccinated/population)*100
from Popvsvac

---Temp Table

select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (PARTITION by dea.location order by dea.location,
dea.date) as rollingpeoplevaccinated 
   ---,(rollingpeoplevaccinated/population)*100
from Porfolioprojects..Coviddeaths dea
join Porfolioprojects..Covidvacination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
----order by 2,3

---Temp Table

Drop table if exists #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

Insert into #percentpopulationvaccinated
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) over (PARTITION by dea.location order by dea.location,
   dea.date) as rollingpeoplevaccinated 
   ---,(rollingpeoplevaccinated/population)*100
from Porfolioprojects..Coviddeaths dea
join Porfolioprojects..Covidvacination vac
   on dea.location = vac.location
   and dea.date = vac.date
----where dea.continent is not null
----order by 2,3

select *, (rollingpeopleVaccinated/Population)*100
from #percentpopulationvaccinated

---Create a view to store data for later visualization.

create view percentpopulationvaccinated as 
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(int,vac.new_vaccinations)) over (PARTITION by dea.location order by dea.location,
   dea.date) as rollingpeoplevaccinated 
   from Porfolioprojects..Coviddeaths dea
join Porfolioprojects..Covidvacination vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null

select *
from dbo.percentpopulationvaccinated