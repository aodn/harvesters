"
WITH std_agg AS ( 
       SELECT string_agg(distinct value, ', ') AS standard_names
       FROM variable_attribute 
       WHERE file_id = " + context.fileId + " AND 
             name='standard_name' AND
             value !~ 'flag$'
     ), long_agg AS (
       SELECT string_agg(distinct value, ', ') AS long_names
       FROM variable_attribute
       WHERE file_id = " + context.fileId + " AND
             name='long_name' AND
             value !~ 'flag$'
     ), var_agg AS (
       SELECT string_agg(name, ', ') AS variables
       FROM variable
       WHERE file_id = " + context.fileId + " AND
             name !~ '_quality_control$'
     )
UPDATE file_metadata m
  SET
    feature_type = getglobalattribute(f.id, 'featureType'),
    file_version = substring(f.url, '_FV0([012])'),
    toolbox_version = getglobalattribute(f.id, 'toolbox_version'),
    toolbox_input_file = getglobalattribute(f.id, 'toolbox_input_file'),
    compliance_checker_version = getglobalattribute(f.id, 'compliance_checker_version'),
    compliance_checker_imos_version = getglobalattribute(file_id, 'compliance_checker_imos_version'),
    compliance_checks_passed = getglobalattribute(f.id, 'compliance_checks_passed'),
    site_code = getglobalattribute(f.id, 'site_code'),
    platform_code = getglobalattribute(f.id, 'platform_code'),
    deployment_code = getglobalattribute(f.id, 'deployment_code'),
    deployment_number = getglobalattribute(f.id, 'deployment_number'),
    instrument = getglobalattribute(f.id, 'instrument'),
    instrument_serial_number = getglobalattribute(f.id, 'instrument_serial_number'),
    instrument_nominal_depth = getglobalattribute(f.id, 'instrument_nominal_depth'),
    geospatial_vertical_min = getglobalattributeasdouble(f.id, 'geospatial_vertical_min'),
    geospatial_vertical_max = getglobalattributeasdouble(f.id, 'geospatial_vertical_max'),
    date_created = getglobalattributeastimestamp(f.id, 'date_created'),
    time_coverage_start = getglobalattributeastimestamp(f.id, 'time_coverage_start'),
    time_coverage_end = getglobalattributeastimestamp(f.id, 'time_coverage_end'),
    time_deployment_start = getglobalattributeastimestamp(f.id, 'time_deployment_start'),
    time_deployment_end = getglobalattributeastimestamp(f.id, 'time_deployment_end'),
    geom = st_geomfromtext('POINT(' || longitude::text || ' ' || latitude::text || ')', 4326),
    data_category = coalesce(substring(url, '/(Temperature|(CTD|Biogeochem)_(timeseries|profiles)|Velocity|Wave|CO2|Meteorology|Surface_[^/]+|Sub-surface_[^/]+|Sediment_traps|aggregated_products|aggregated_timeseries|hourly_timeseries|gridded_timeseries/)'),
                             substring(url, '/(Pulse|FluxPulse)/')),
    variables = v.variables,
    standard_names = s.standard_names,
    long_names = l.long_names,
    realtime = (f.url ~* 'real[-_]?time'),
    deleted = false
  FROM indexed_file f, std_agg s, var_agg v, long_agg l
  WHERE m.file_id = f.id AND f.id = " + context.fileId
