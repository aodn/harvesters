"SELECT
  substring(url, '/NSWOEH_[[:digit:]]+_([[:alnum:]]+)_[^/]+$') AS location,
  substring(url, '/NSWOEH_([[:digit:]]+)_[^/]+$')::date AS survey_date
FROM indexed_file
WHERE id = " + context.file_id + ";"
