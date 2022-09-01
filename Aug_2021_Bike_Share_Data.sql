  /*
Cleaning Data in SQL Queries
*/


SELECT *
FROM ProjectProfiles.dbo._202108_divvy_tripdata


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Start Date Format


ALTER TABLE ProjectProfiles.dbo._202108_divvy_tripdata
ADD start_date DATE;

Update ProjectProfiles.dbo._202108_divvy_tripdata
SET start_date = CONVERT(DATE,started_at)


ALTER TABLE ProjectProfiles.dbo._202108_divvy_tripdata
ADD end_date DATE;

UPDATE ProjectProfiles.dbo._202108_divvy_tripdata
SET end_date = CONVERT(DATE,ended_at)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Start Station Name Null Data


UPDATE a
SET start_station_name = ISNULL(a.start_station_name,b.start_station_name)
FROM ProjectProfiles.dbo._202108_divvy_tripdata a
JOIN ProjectProfiles.dbo._202108_divvy_tripdata b
	ON a.start_station_id = b.start_station_id
	AND a.ride_id <> b.ride_id
WHERE a.start_station_name is null


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates Addresses


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY start_station_id
				 ORDER BY 
				 ride_id
					) row_num

FROM ProjectProfiles.dbo._202108_divvy_tripdata

)

DELETE
From RowNumCTE
Where row_num > 1


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
FROM ProjectProfiles.dbo._202108_divvy_tripdata


ALTER TABLE ProjectProfiles.dbo._202108_divvy_tripdata
DROP COLUMN started_at, ended_at, start_station_id, end_station_id, start_lat, start_lng, end_lat, end_lng, end_station_name