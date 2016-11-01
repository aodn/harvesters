"SELECT
  substring(url, '/[[:digit:]]+_([[:alnum:]]+)_[^/]+$') AS location,
  substring(url, '/([[:digit:]]+)_[^/]+$')::date AS survey_date
FROM indexed_file
WHERE id = " + context.file_id + ";"
