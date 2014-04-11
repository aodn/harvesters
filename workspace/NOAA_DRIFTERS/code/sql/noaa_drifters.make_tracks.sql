"
INSERT INTO track(driftnum, file_id, geom, date_utc, duration)
  SELECT 
    driftnum, 
    file_id, 
    make_trajectory(geom ORDER BY time),
    date_utc,
    max(time) - min(time)
  FROM (
    SELECT driftnum,  file_id, geom, time,
      date(time AT TIME ZONE 'UTC') AS date_utc
      FROM measurement
    UNION
    SELECT driftnum,  file_id, geom, time,
      date(time AT TIME ZONE 'UTC' - interval '6 hours') AS date_utc
      FROM measurement
    ) AS dates
  WHERE file_id = " + context.fileId + "
  GROUP BY driftnum, file_id, date_utc
  ORDER BY driftnum, file_id, date_utc
;"
