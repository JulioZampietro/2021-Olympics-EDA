# Exploratory Data Analysis: 2021 Tokyo Olympics total medals

## Description
A portfolio project aimed at analyzing the most important variables when considering total medal yields in the 2021 Tokyo Olympics. The main focus was in finding a possible alternative for better results regarding total medals. Data was obtained from various reputable sources and manipulated using SQL and Python, both for table creation and analysis. After an initial period of exploratory analysis, we discovered that there is a strong correlation between total medals and aggregate metrics (total GDP, total sports spending), as well as between total medals and the amount of athletes each country effectively sent to the Olympic games. Not only that, but countries that excelled in total medals were those with an emphasis on collective sports (see definition below). This seems counterintuitive at first, considering that individual sports have the best medal-opportunity-per-athlete ratio. We conclude that countries with less resources emphasize individual sports precisely because of this ratio, while those with better economic conditions can also strongly invest in more costly (collective) sports, earning medals in both categories. Our final recommendation is that countries that wish to earn more medals should spend more in sports across the board, instead of focusing on either individual or collective sports.

## Tools used
- SQL and Python pandas for table creation, data manipulation and finding correlations.
- Python matplotlib and seaborn for graphs, Excel for tables in report.
- Microsoft Word for report writing.

## Data sources and necessary manipulations
1. 2021 Tokyo Olympics data: https://www.kaggle.com/datasets/arjunprasadsarkhel/2021-olympics-in-tokyo/data
Faults with dataset:
    i. Gender data segregated by sport only, not country or any other metric
   ii. Medals segregated by country, not sport/gender/athlete
  iii. Some mistakes by table creator (e.g. WANG Yang is both a hockey coach from the People's Republic of China and sailing (People's Republic of China) and table tennis (Slovakia) athlete

2. GDP per capita data (based on World Bank data): https://ourworldindata.org/grapher/gdp-per-capita-worldbank?tab=table&time=2022..latest
Via python pandas:
- Changed country names to match Olympic data (Russia for ROC, United States for United States of America, etc.)
- Selected data for 2021 only (countries without World Bank data for this year were excluded, which means there are no per capita GDP data for Cuba, Venezuela, Taiwan and Syrian Arab Republic for 2021)

3. GDP per country (based on World Bank data): https://ourworldindata.org/grapher/national-gdp-constant-usd-wb?tab=table
Via python pandas:
- Changed country names to match Olympic data (Russia for ROC, United States for United States of America, etc.)
- Selected data for 2021 only (Countries without World Bank data for this year were excluded, which means there are no per capita GDP data for Venezuela, Taiwan and Syrian Arab Republic for 2021. Different from per capita data, there are World Bank estimates for Cuba's total GDP)

4. Education spending: https://ourworldindata.org/government-spending
Originally in % of GDP, the GDP per country database was used to transform values into absolute spending values.

5. Gini index: https://ourworldindata.org/grapher/economic-inequality-gini-index
Filtered original data to only include most recent measurement. Nonetheless, most countries do not have measurements for 2021, but only for previous years, which renders this measurement a bit less accurate.

6. Sports investing data (EU): https://ec.europa.eu/eurostat/databrowser/view/gov_10a_exp/default/table?lang=en


## Database tables
1. Athletes
Table containing name, NOC (National Olympic Committee, aka. country), and sport. Obtained through Kaggle.

2. Athletes_per_country
Aggregate of athletes per NOC. Obtained through manipulating the Athletes table with SQL.

3. Coaches
Table containing name, NOC, and sport for each coach. Obtained through Kaggle.

4. Country_Classification
Table containing the classification of each country based on amount of athletes in collective and individual sports. Created via SQL query, in which the ratio of collective/individual athletes of each country was compared to the general ratio of collective/individual athletes (5174/5911, or 0.875). Countries with a ratio larger than 0.875 were considered collective. For the definition of collective and individual, see table 10 (Sport_Classification) below.

5. Country_gdp
Table containing NOC, year and total GDP for each country. Obtained through World Bank data.

6. Efficiency_ranking
Table containing NOC and the ratio of total medals per total athletes for each country, ordered by the efficiency metric. Obtained through SQL query.

7. EntriesGender
Table containing sport, male, female, and total athletes. Obtained through Kaggle.

8. Medals
Table containing NOC, and the amount of gold, silver, bronze and total medals. Obtained through Kaggle.

9. Percapita2021
Table containing NOC, year and per capita GDP for each country. Obtained through World Bank data.

10. Sport_Classification
Table containing sport and its classification into primarily collective or individual. Individual sports are those in which the majority of medal opportunities come from individual categories (e.g. men's individual archery, women's 100 metres, etc.) This means that sports such as Judo, which has one collective category and 14 individual categories, are considered primarily individual. Sports traditionally thought of as individual, but that offer more collective than individual medals (e.g. archery, badminton) were considered collective. When there was an equal offer of individual and collective medals (e.g. canoe sprint, cycling track, diving), these were considered collective.
