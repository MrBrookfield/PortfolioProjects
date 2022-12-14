  /*
Cleaning Data in SQL Queries
*/


SELECT *
FROM PortfolioProjects.dbo._202108_divvy_tripdata


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Start Date Format


ALTER TABLE PortfolioProjects.dbo._202108_divvy_tripdata
ADD start_date DATE;

Update PortfolioProjects.dbo._202108_divvy_tripdata
SET start_date = CONVERT(DATE,started_at)


ALTER TABLE PortfolioProjects.dbo._202108_divvy_tripdata
ADD end_date DATE;

UPDATE PortfolioProjects.dbo._202108_divvy_tripdata
SET end_date = CONVERT(DATE,ended_at)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Start Station Name Null Data


UPDATE a
SET start_station_name = ISNULL(a.start_station_name,b.start_station_name)
FROM PortfolioProjects.dbo._202108_divvy_tripdata a
JOIN PortfolioProjects.dbo._202108_divvy_tripdata b
	ON a.start_station_id = b.start_station_id
	AND a.ride_id <> b.ride_id
WHERE a.start_station_name IS NULL


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates Addresses


WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY start_station_id
				 ORDER BY 
				 ride_id
					) row_num

FROM PortfolioProjects.dbo._202108_divvy_tripdata

)

DELETE
FROM RowNumCTE
WHERE row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
FROM PortfolioProjects.dbo._202108_divvy_tripdata


ALTER TABLE PortfolioProjects.dbo._202108_divvy_tripdata
DROP COLUMN started_at, ended_at, start_station_id, end_station_id, start_lat, start_lng, end_lat, end_lng, end_station_name