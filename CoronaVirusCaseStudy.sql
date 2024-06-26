CREATE DATABASE coronavirus_data;
USE coronavirus_data;
SELECT * FROM coronavirus_data.`corona virus dataset`;


#--Q1. Write a code to check NULL values
SELECT
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS province_nulls,
    SUM(CASE WHEN "Country/Region" IS NULL THEN 1 ELSE 0 END) AS countryregion_nulls,
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS latitude_nulls,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS longitude_nulls,
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS date_nulls,
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS confirmed_nulls,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS deaths_nulls,
    SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS recovered_nulls
FROM coronavirus_data.`corona virus dataset`;


#--Q2. If NULL values are present, update them with zeros for all columns. 
#No null values present in any columns


#-- Q3. check total number of rows
   SELECT COUNT(*) AS total_rows FROM coronavirus_data.`corona virus dataset`;
   #-- Answer: total_rows = 78386
                                
                                
#-- Q4. Check what is start_date and end_date
SELECT 
    MIN(STR_TO_DATE(Date, '%d-%m-%Y')) AS start_date,
    MAX(STR_TO_DATE(Date, '%d-%m-%Y')) AS end_date
FROM
    `coronavirus_data`.`corona virus dataset`
WHERE
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) IN (2020 , 2021);
#-- Answer: Pandemic started at '2020-01-22' and ended at '2021-06-13'


#-- Q5. Number of month present in dataset
SELECT 
    COUNT(DISTINCT CONCAT(YEAR(STR_TO_DATE(Date, '%d-%m-%Y')),
                '-',
                MONTH(STR_TO_DATE(Date, '%d-%m-%Y')))) AS number_of_months
FROM
    `coronavirus_data`.`corona virus dataset`
WHERE
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) BETWEEN 2020 AND 2021;
    #-- Answer: No. of Months present is 18
    
    
    #-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT 
    YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    MONTH(STR_TO_DATE(Date, '%d-%m-%Y')) AS month,
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered
FROM `coronavirus_data`.`corona virus dataset`
WHERE YEAR(STR_TO_DATE(Date, '%d-%m-%Y')) BETWEEN 2020 AND 2021
GROUP BY YEAR(STR_TO_DATE(Date, '%d-%m-%Y')), MONTH(STR_TO_DATE(Date, '%d-%m-%Y'))
ORDER BY year, month;


#-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS month,
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    SUBSTRING_INDEX(GROUP_CONCAT(Confirmed
                ORDER BY Confirmed DESC),
            ',',
            1) AS most_frequent_confirmed,
    SUBSTRING_INDEX(GROUP_CONCAT(Deaths
                ORDER BY Deaths DESC),
            ',',
            1) AS most_frequent_deaths,
    SUBSTRING_INDEX(GROUP_CONCAT(Recovered
                ORDER BY Recovered DESC),
            ',',
            1) AS most_frequent_recovered
FROM
    `coronavirus_data`.`corona virus dataset`
GROUP BY year , month
ORDER BY year , month;


#-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM
    `coronavirus_data`.`corona virus dataset`
GROUP BY year
ORDER BY year;


#-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    max(Confirmed) AS max_confirmed,
    max(Deaths) AS max_deaths,
    max(Recovered) AS max_recovered
FROM
    `coronavirus_data`.`corona virus dataset`
GROUP BY year
ORDER BY year;


#-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS month,
    SUM(Confirmed) AS total_confirmed_cases,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM `coronavirus_data`.`corona virus dataset`
GROUP BY year, month
ORDER BY year, month;


#-- Q11. Check how corona virus spread out with respect to confirmed case
#--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Confirmed) AS total_confirmed_cases,
    AVG(Confirmed) AS avg_confirmed_cases,
    VARIANCE(Confirmed) AS variance_confirmed_cases,
    STDDEV(Confirmed) AS stddev_confirmed_cases
FROM
    `coronavirus_data`.`corona virus dataset`;
    
    
#-- Q12. Check how corona virus spread out with respect to death case per month
#--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    EXTRACT(YEAR FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS year,
    EXTRACT(MONTH FROM STR_TO_DATE(Date, '%d-%m-%Y')) AS month,
    SUM(Deaths) AS total_deaths_cases,
    avg(Deaths) AS avg_deaths_cases,
    variance(Deaths) AS variance_deaths_cases,
    stddev(Deaths) as stddev_deaths_cases
FROM `coronavirus_data`.`corona virus dataset`
GROUP BY year, month
ORDER BY year, month;


#-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    SUM(Recovered) AS total_recovered_cases,
    AVG(Recovered) AS avg_recovered_cases,
    VARIANCE(Recovered) AS variance_recovered_cases,
    STDDEV(Recovered) AS stddev_recovered_cases
FROM
    `coronavirus_data`.`corona virus dataset`;
    
    
#-- Q14. Find Country having highest number of the Confirmed case
SELECT 
    `Country/Region`, SUM(Confirmed) AS total_confirmed_cases
FROM
    `coronavirus_data`.`corona virus dataset`
GROUP BY `Country/Region`
ORDER BY total_confirmed_cases desc
LIMIT 1;


#-- Q16. Find top 5 countries having highest recovered case
SELECT 
    `Country/Region`, 
    SUM(Recovered) AS total_recovered_cases
FROM
    `coronavirus_data`.`corona virus dataset`
GROUP BY `Country/Region`
ORDER BY total_recovered_cases DESC
LIMIT 5;


#-- Q15. Find Country having lowest number of the death case
SELECT 
    `Country/Region`, SUM(Deaths) AS total_deaths_cases
FROM
    `coronavirus_data`.`corona virus dataset`
GROUP BY `Country/Region`
HAVING SUM(Deaths) = (SELECT 
        MIN(total_deaths_cases)
    FROM
        (SELECT 
            SUM(Deaths) AS total_deaths_cases
        FROM
            `coronavirus_data`.`corona virus dataset`
        GROUP BY `Country/Region`) AS min_deaths)
        
        




        
        


        
        
        









   
   
   
   
   
   
   
