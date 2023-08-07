--SELECT location, date, total_cases, population, (total_cases /population)*100 InfectedPercentage
--FROM covidDeaths
--Where location  = 'nepal'
--ORDER BY 1,2


--Looking at Countries with highest infection rate compared to population
SELECT location,population,MAX(CAST(total_cases as int)) as TotalInfectionCount, MAX((total_cases/population))*100 as InfectedPercentage
FROM covidDeaths
GROUP BY Location, Population
ORDER BY InfectedPercentage DESC


--SELECT MAX(CAST(total_cases as int)) FROM covidDeaths
--WHERE Location = 'cyprus'






--Countries with highest death count per population
SELECT location, population, MAX(CAST(total_deaths as int)) as TotalDeathCount, MAX(total_deaths/population)*100 as DeathPercentage
FROM covidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY TotalDeathCount Desc



--Breaking down by continent
SELECT continent,MAX(CAST(total_deaths as int)) as TotalDeathCount, MAX(total_deaths/population)*100 as DeathPercentage
FROM covidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount Desc

--Global Numbers
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
FROM covidDeaths
WHERE continent is not null
ORDER BY 1,2




---Total Population vs Vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM covidDeaths as dea
JOIN covidVaccination as vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is not NULL
ORDER BY 2,3

---can't perform further operations on RollingPeopleVaccinated so creating CTE

WITH PopVsVac(continent, location, date, population, vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM covidDeaths as dea
JOIN covidVaccination as vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is not NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopVsVac




------TEMP Table method---------
DROP Table if exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM covidDeaths as dea
JOIN covidVaccination as vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is not NULL
--ORDER BY 2,3


SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated


---CREATED VIEWS FOR LATER VIZUALIZATIONS----
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM covidDeaths as dea
JOIN covidVaccination as vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is not NULL
--ORDER BY 2,3


