"WITH table_a AS(
        SELECT file_id, value AS platform_code FROM attribute WHERE name = 'platform_code'
	),
      table_b AS(
      	SELECT file_id, CASE WHEN value = 'M/V Fantasea' OR value = 'M/V Fantasea Wonder' THEN 'Fantasea Wonder' 
	WHEN value = 'M/V SeaFlyte' THEN 'SeaFlyte' 
	WHEN value = 'MV Pacific Celebes' THEN 'Pacific Celebes' 
	WHEN value = 'MV Wana Bhum' THEN 'Wana Bhum'
	WHEN value = 'MV Xutra Bhum' THEN 'Xutra Bhum'
	WHEN value = 'R/V LINNAEUS' THEN 'Linnaeus'
	WHEN value = 'RSV L''Astrolabe' THEN 'L''Astrolabe'
	WHEN value = 'Spirit of Tasmania II' THEN 'Spirit of Tasmania 2'
	ELSE value END AS vessel_name FROM attribute WHERE name = 'site'
	),
      table_c AS(
        SELECT file_id, value AS voyage_number FROM attribute WHERE name = 'voyage_number'
	),
      data AS (
        SELECT trajectory_id,
	url,
	size,
	min(\"TIME\") AS time_start, 
	max(\"TIME\") AS time_end, 
	CASE WHEN COUNT(DISTINCT(geom)) > 1 THEN ST_SimplifyPreserveTopology(make_trajectory(geom ORDER BY \"TIME\"),0.005) ELSE ST_UNION(geom) END AS geom,
    COUNT(\"AIRT\") AS \"AIRT\",
    COUNT(\"ATMP\") AS \"ATMP\",
    COUNT(\"CNDC\") + COUNT(\"CNDC_2\") + COUNT(\"CNDC_3\") AS \"CNDC\",
    COUNT(\"DEWT\") AS \"DEWT\",
    COUNT(\"GPS_HEIGHT\") AS \"GPS_HEIGHT\",
    COUNT(\"PL_CRS\") AS \"PL_CRS\",
    COUNT(\"PL_SPD\") AS \"PL_SPD\",
    COUNT(\"PL_WDIR\") AS \"PL_WDIR\",
    COUNT(\"PL_WSPD\") AS \"PL_WSPD\",
    COUNT(\"PSAL\") + COUNT(\"PSAL_2\") + COUNT(\"PSAL_3\") AS \"PSAL\",
    COUNT(\"RELH\") AS \"RELH\",
    COUNT(\"TEMP\") + COUNT(\"TEMP_2\") + COUNT(\"TEMP_3\") + COUNT(\"TEMP_4\") AS \"TEMP\",
    COUNT(\"WDIR\") AS \"WDIR\",
    COUNT(\"WETT\") AS \"WETT\",
    COUNT(\"WSPD\") AS \"WSPD\"
    FROM measurements
    LEFT JOIN indexed_file ON measurements.trajectory_id = indexed_file.id
    WHERE \"LATITUDE_quality_control\" = 'Z' AND \"LONGITUDE_quality_control\" = 'Z' AND \"LATITUDE\" != 0 AND \"LONGITUDE\" != 0 AND substring(url, '1-min-avg') IS NULL
    GROUP BY trajectory_id,url,size)
SELECT DISTINCT data.trajectory_id,
url,
size,
platform_code,
table_b.vessel_name,
voyage_number,
time_start,
time_end,
geom,
colour,
\"AIRT\" > 0 AS \"AIRT_b\",
\"ATMP\" > 0 AS \"ATMP_b\",
\"CNDC\" > 0 AS \"CNDC_b\",
\"DEWT\" > 0 AS \"DEWT_b\",
\"GPS_HEIGHT\" > 0 AS \"GPS_HEIGHT_b\",
\"PL_CRS\" > 0 AS \"PL_CRS_b\",
\"PL_SPD\" > 0 AS \"PL_SPD_b\",
\"PL_WDIR\" > 0 AS \"PL_WDIR_b\",
\"PL_WSPD\" > 0 AS \"PL_WSPD_b\",
\"PSAL\" > 0 AS \"PSAL_b\",
\"RELH\" > 0 AS \"RELH_b\",
\"TEMP\" > 0 AS \"TEMP_b\",
\"WDIR\" > 0 AS \"WDIR_b\",
\"WETT\" > 0 AS \"WETT_b\",
\"WSPD\" > 0 AS \"WSPD_b\"
FROM data
LEFT JOIN table_a ON data.trajectory_id = table_a.file_id
LEFT JOIN table_b ON data.trajectory_id = table_b.file_id
LEFT JOIN table_c ON data.trajectory_id = table_c.file_id
LEFT JOIN vessel_names ON table_b.vessel_name = vessel_names.vessel_name
WHERE substring(url, '1-min-avg') IS NULL
ORDER BY trajectory_id;"