-- Stacking the total data of 3 years by Union and making a CTE

WITH HotelData AS
(
SELECT * FROM PortfolioProject..data2018
union
SELECT * FROM PortfolioProject..data2019
union
SELECT * FROM PortfolioProject..data2020
)

SELECT * FROM HotelData



-- Calculating Total revenue per year and segmenting by hotel type



WITH HotelData AS
(
SELECT * FROM PortfolioProject..data2018
union
SELECT * FROM PortfolioProject..data2019
union
SELECT * FROM PortfolioProject..data2020
)
SELECT 
	arrival_date_year,
	hotel,
	SUM(stays_in_weekend_nights+stays_in_week_nights) as Total_Nights,
	ROUND(SUM((stays_in_weekend_nights+stays_in_week_nights)*adr),0) as Revenue
FROM HotelData
WHERE is_canceled = 0
GROUP BY arrival_date_year, hotel;



-- Joing MarketSegment and Meals table, calculating reveneue taking discount into consideration


WITH 

HotelData AS
(
SELECT * FROM PortfolioProject..data2018
union
SELECT * FROM PortfolioProject..data2019
union
SELECT * FROM PortfolioProject..data2020
)


SELECT 
	*,
	(a.stays_in_weekend_nights + a.stays_in_week_nights) as Total_Nights,
	((a.stays_in_weekend_nights + a.stays_in_week_nights) * a.adr * (1.0 - b.Discount)) as Revenue
FROM HotelData a
	join
	PortfolioProject..market_segment b
	ON a.market_segment = b.market_segment
	join 
	PortfolioProject..meal_cost c
	ON a.meal = c.meal
	WHERE a.is_canceled = 0;



-- Total Revenue, Total Nights, Avg. ADR, Avg. Discount

WITH 

HotelData AS
(
SELECT * FROM PortfolioProject..data2018
union
SELECT * FROM PortfolioProject..data2019
union
SELECT * FROM PortfolioProject..data2020
)


SELECT 
	SUM (((a.stays_in_weekend_nights + a.stays_in_week_nights) * a.adr * (1.0 - b.Discount))) as Total_Revenue,
	SUM ((a.stays_in_weekend_nights + a.stays_in_week_nights)) as Total_Nights,
	AVG (a.adr) as Avg_adr,
	AVG (b.Discount) as Avg_Discount
FROM HotelData a
	join
	PortfolioProject..market_segment b
	ON a.market_segment = b.market_segment
	WHERE a.is_canceled = 0;


