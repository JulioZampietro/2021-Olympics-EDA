-- Count of athletes by country, in descending orderAthletes
-- There is a clear similarity between this list and medals by country
select NOC, count(NOC) as Qtd_Athletes
from Athletes
group by NOC
order by Qtd_Athletes Desc

-- Creation of "efficiency" metric (quantity of medals / quantity of athletes)
select a.NOC, count(a.NOC) as Qtd_Athletes, Total, Total/count(a.NOC) as Efficiency
from Athletes a
inner join Medals m
on a.NOC = m.NOC
group by a.NOC
order by Qtd_Athletes Desc
-- For some reason this query does not work as intended, and Efficiency always shows as zero.
-- I have tried rounding, casting all values as decimals, and other potential solutions, to no avail.
-- The issue seems to be with Total values, but I was unable to perform a workaround in SQL.
-- Therefore, this part of the EDA was conducted with python, used to create the Efficiency_ranking table.
-- One initial consideration is that countries that do better in collective sports will potentially do worse
-- in this efficiency metric, as it only considers total athletes divided by total medals. One soccer medal
-- requires over a dozen athletes, while one weightlifting medal requires only one athlete.

-- Calculating "efficiency" in terms of per cpaita GDP (2021 values; see documentation for null values)
-- The People's Republic of China is a clear winner in terms of medal efficiency by per capita GDP
select m.NOC, Total, gdp_per_capita, round((Total/gdp_per_capita)*1000, 4) as Efficiency
from medals m
left join Percapita2021 pc
on m.NOC = pc.Entity
order by Efficiency desc

-- Calculating "efficiency" in terms of total GDP (2021 values; see documentation for null values)
-- The resulting table is very different from the per capita GDP table. Some countries
-- are inefficient in transforming their total GDP into olympic medals.
select m.NOC, Total, total_gdp, total_gdp/Total as Efficiency
from medals m
left join Country_gdp c
on m.NOC = c.Entity
order by Efficiency desc

-- But how does GDP and per capita GDP correlate to sending athletes to the Olympic Games in the first place?
-- Calculating for per capita GDP
select a.NOC, total_athletes, gdp_per_capita, round((total_athletes/gdp_per_capita)*1000, 4) as Efficiency
from Athletes_per_country a
left join Percapita2021 pc
on a.NOC = pc.Entity
order by Efficiency desc

-- Discovering the ratio between athletes in collective and individual sports
-- This is important to define countries which are "primarily collective" or "primarily individual"
select s.classification, count(a.Name) as Per_Classification
from Athletes a
left join Sport_Classification s
on a.Discipline = s.Discipline
group by s.Classification
-- The result is 5174 collective (46,67%) and 5911 individual (53,32%)

-- Classifies countries into primarily individual or collective
WITH IndividualCounts AS (
  SELECT NOC, COUNT(*) AS IndividualCount
  FROM (select a.Name, a.Noc, a.Discipline, s.Classification as Sport_Class
		from Athletes a
		left join Sport_Classification s
		on a.Discipline = s.Discipline)
  WHERE Sport_Class = 'Individual'
  GROUP BY NOC
),
CollectiveCounts AS (
  SELECT NOC, COUNT(*) AS CollectiveCount
  FROM (select a.Name, a.Noc, a.Discipline, s.Classification as Sport_Class
		from Athletes a
		left join Sport_Classification s
		on a.Discipline = s.Discipline)
  WHERE Sport_Class = 'Collective'
  GROUP BY NOC
),
Ratios AS (
  SELECT 
    IC.NOC,
    COALESCE(CAST(CC.CollectiveCount AS FLOAT) / IC.IndividualCount, 0) AS CollectiveToIndividualRatio
  FROM 
    IndividualCounts IC
  LEFT JOIN CollectiveCounts CC ON IC.NOC = CC.NOC
)
SELECT 
  NOC,
  CASE 
    WHEN CollectiveToIndividualRatio > 0.875 THEN 'Collective'
    ELSE 'Individual'
  END AS DominantClassification
FROM Ratios;
