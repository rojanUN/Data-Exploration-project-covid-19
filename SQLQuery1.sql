--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM covidDeaths
--ORDER BY 1,2


--Looking at Total Cases vs Total Deaths 
SELECT location,date, total_cases,total_deaths, (CAST(total_deaths as decimal)/CAST(total_cases as decimal))*100 DeathPercentage
FROM covidDeaths
WHERE location = 'Nepal'
ORDER BY 1,2
