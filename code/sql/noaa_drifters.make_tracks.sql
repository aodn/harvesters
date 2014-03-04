"
INSERT INTO track(driftnum, file_id, geom, time_coverage_start, time_coverage_end)
  SELECT 
    driftnum,
    file_id,
    make_trajectory(geom ORDER BY date),
    min(date), 
    max(date)
  FROM measurement
  WHERE file_id = '" + context.fileId + "'
  GROUP BY driftnum, file_id
;"
