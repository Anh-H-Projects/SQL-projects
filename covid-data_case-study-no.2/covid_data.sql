/*Q1: Select data that we are going to be using.*/

select location, date, total_cases, new_cases, total_deaths, population
from covid_data
order by location, date
-------------------------------------------------------------------------------------------------------------------

/*Q2: Looking at Total Cases vs. Total Deaths.*/

select location, date, total_cases, total_deaths,
(total_deaths/total_cases)*100 as death_percentage
from covid_data
-------------------------------------------------------------------------------------------------------------------

/*Q3: Looking at Total Cases vs. Population in Vietnam.*/

select location, date, total_cases, population, 
       round((total_cases/population)::numeric*100, 2)||'%' as total_case_percentage
from covid_data
where location = 'Vietnam' and total_cases is not null
order by date
-------------------------------------------------------------------------------------------------------------------

/*Q4: Looking at Countries with Highest Infection Rate compared to Population.*/
--Explain: Column "total_cases" contains accumulated summed values, which means the highest value is the true total of infected cases.

select location, 
       population, 
       max(total_cases) as highest_infection_numbers,
       round((max(total_cases/population))::numeric*100, 2)||'%' as percent_population_infected
from covid_data
where total_cases is not null and continent is not null
group by location, population
order by percent_population_infected desc
-------------------------------------------------------------------------------------------------------------------

/*Q5: Showing Countries with Highest Death Count per Population.*/
---Explain: Column "total_deaths" contains accumulated summed values, which means the highest value is the true total of deaths.

select location, 
       population, 
       max(total_deaths) as highest_death_count,
       round((max(total_deaths/population))::numeric*100, 2)||'%' as percent_population_death
from covid_data
where total_deaths is not null and continent is not null
group by location, population
order by percent_population_death desc
-------------------------------------------------------------------------------------------------------------------

/*Q6: Showing Continents with Highest Death Count.*/

select continent, max(total_deaths) as highest_death_count
from covid_data
where continent is not null
group by continent
order by highest_death_count desc
-------------------------------------------------------------------------------------------------------------------

/*Q7: Global Numbers by Date.*/
	
select date,
       sum(new_cases) as total_cases, 
       sum(new_deaths) as total_deaths, 
       round((sum(new_deaths) / sum(new_cases))::numeric * 100, 2)||'%' as death_percentage
from covid_data
where new_cases > 0
group by date
order by date
-------------------------------------------------------------------------------------------------------------------

/*Q8: Looking at Total Population vs. People_Vaccinated.*/
--Explain: Column "people_vaccinated" contains accumulated summed values, which mean the higest value is the true total of people vaccinated.

select continent, location, date, population, people_vaccinated,
       max(people_vaccinated) over(partition by location) as total_people_vaccinated,
	   round(
		   ((max(people_vaccinated) over(partition by location))/population)::numeric*100, 2
	        )||'%' as people_vaccinated_percentage
from covid_data
where continent is not null
order by location, date
-------------------------------------------------------------------------------------------------------------------

/*Q9: Create View.*/

create view population_vaccs_percentage as
select continent, location, date, population, people_vaccinated,
       max(people_vaccinated) over(partition by location) as total_people_vaccinated,
	   round(
		   ((max(people_vaccinated) over(partition by location))/population)::numeric*100, 2
	        )||'%' as people_vaccinated_percentage
from covid_data
where continent is not null
order by location, date
