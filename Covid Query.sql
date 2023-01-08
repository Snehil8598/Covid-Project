select *
from dbo.CovidDeaths$

select *
from dbo.CovidVaccinations$

select location, date, population, total_cases, new_cases, total_deaths, new_deaths
from CovidDeaths$
order by 1,2;

--total cases vs total deaths
select location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from CovidDeaths$
order by 1,2;

--total cases vs population
select location, date, population, total_cases, total_deaths, (total_cases/population)*100 as Percentage_Affected
from CovidDeaths$
where location = 'United States'
order by Percentage_Affected desc;

--Finding max affected percentage per day in a location 
select location, max(population) as Population, max(total_cases) as Highest_Case_count_In_a_Day, max((total_cases/population)*100) as Highest_Percent_affected_per_day
from CovidDeaths$
group by location, population
order by Highest_Percent_affected_per_day desc;

--Finding total death rate percentage
select location,population,(SUM(CAST(total_deaths as int)/population)*100) as Total_deaths_rate
from CovidDeaths$
where continent is not null
group by location, population 
order by Total_deaths_rate desc;

--Global Numbers
select date, SUM(new_cases) as Global_New_Cases, SUM(cast(new_deaths as int)) as Global_New_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Global_Death_Precentage
from CovidDeaths$
where continent is not null
group by date
order by Global_Death_Precentage desc;

--Joining tables
select c.continent, c.location, c.date, c.population, c.new_vaccinations, c.Rolling_new_vacc_per_continent, (c.Rolling_new_vacc_per_continent/c.population)*100 as Percent_Vaccinated
from
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) over (Partition by dea.location order by dea.location,dea.date) as Rolling_new_vacc_per_continent
from CovidDeaths$ dea
join CovidVaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
) as c;