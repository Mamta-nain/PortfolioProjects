select * from PortfolioProject..CovidDeaths order by 3,4
select * from PortfolioProject..CovidVaccinations order by 3,4
Select location, date, total_cases, new_cases, total_deaths, population from PortfolioProject..CovidDeaths order by 1,2

--To find number of death vs no of cases
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage from PortfolioProject..CovidDeaths
where location like 'canada' order by 1,2


Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_percentage from PortfolioProject..CovidDeaths
where location ='India' order by 1,2

--To find total cases vs Population shows total no of people who got infected by Covid


Select location, max(total_cases) as highest_cases, max((total_cases/population))*100 as Max_population_infected from PortfolioProject..CovidDeaths
group by location, population order by Max_population_infected desc


Select location, max(cast(total_deaths as int)) as highest_death_cases from PortfolioProject..CovidDeaths group by location order by highest_death_cases desc


Select continent, max(cast(total_deaths as int)) as highest_death_cases from PortfolioProject..CovidDeaths
where continent is not NULL group by continent order by highest_death_cases 


Select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations 
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as total_vaccination
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
  on dea.location=vac.location
  and dea.date=vac.date
where dea.continent is not null
order by 2,3



---With CTE

with popvsvav (continent,location,date,population,new_vaccination,total_vaccination)
as
(
Select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations 
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as total_vaccination
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
  on dea.location=vac.location
  and dea.date=vac.date
where dea.continent is not null
)
select *,(total_vaccination/population)*100
from popvsvav




-----Temp Table

create table #percentpopvac(
continent varchar(255),
location varchar(255),
date datetime,
population numeric,
new_vaccination numeric,
total_vaccination numeric
)

Insert into #percentpopvac
Select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations 
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as total_vaccination
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
  on dea.location=vac.location
  and dea.date=vac.date

select *,(total_vaccination/population)*100
from #percentpopvac



---Create View
create view perpopvac as
Select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations 
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as total_vaccination
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
  on dea.location=vac.location
  and dea.date=vac.date
where dea.continent is not null


select * from dbo.perpopvac
