# harvesters

This repository contains Talend harvester projects

# Invocation Of Talend In Production

 * `talend_show` - Shows all queued and running talend processes (in order of execution)
 * `talend_show_queued` - Shows only queued talend processes (in order of execution)
 * `talend_show_running` - Shows only running talend processes
 * `talend_log JOB_NAME` - Shows the last log for the talend job (has auto complete, so `<TAB><TAB>` will complete the job name)
 * `talend_run JOB_NAME` - Queues a talend job for execution (has auto complete, so `<TAB><TAB>` will complete the job name)
 * `talend_dequeue JOB_NAME` - Removes a queued talend job from the execution queue (has auto complete, so `<TAB><TAB>` will complete the job name)
 * `talend_urgent JOB_NAME` - Runs a talend job urgently (next in queue) or prioritizes an already queued job run to run next in queue (has auto complete, so `<TAB><TAB>` will complete the job name)
 * `talend_run_all` - Queues all talend processes for execution
 * `talend_version JOB_NAME` - Shows the build and commit version for the talend job (has auto complete, so `<TAB><TAB>` will complete the job name)

## bin/update-harvester.sh

Convert a harvester from using index-all harvesting components to manifest harvesting components

	Usage: update-harvester.sh <harvester directory>

Notes:

- assumes a context group named source or Source contains existing source parameters
- adds fileList and base context parameters to source context group
- removes sourceDir, include and exclude parameter from source context, top job and subjobs
- renames iIndexFiles to iUpdateIndex, and updates parameters to reflect changes
- renames iXXXXResources to iXXXXFileList and adds die on error parameter
- changes all context.url instances in component parameters to context.url + "/" + context.base
- adds base context parameter subjobs currently containing a url parameter
- adds base and fileList context parameterd to top job

# Best practices

## Complex SQL requests

Complex SQL requests sometimes require complex joints between tables. Nested SELECTs to achieve such operations are to be avoided (bad performance and clarity/ease of maintenance), instead one can actually explicitly write which type of joint needs to be to performed (like INNER JOIN or LEFT OUTER JOIN) between tables and on which fields.

In terms of being less prone to a mistake, of ease of understanding and maintenance, nested queries are not ranking first.

For SOOP_BA harvester I find the following SQL request :

```
SELECT vessel_name, platform_code,  colour 
FROM vessel_names 
WHERE (
   SELECT  vessel_name 
   FROM deployments 
   WHERE file_id = " + context.file_id +" 
) =  vessel_name
```

Not too complex, I can rapidly understand that we want to retrieve the content of the table vessel_names for the file_id = context.file_id, making a join with the table deployments on the common field vessel_name.

This is equivalent to the following SQL request :

```
SELECT vn.vessel_name, vn.platform_code, vn.colour 
FROM vessel_names vn 
   INNER JOIN deployments d 
      ON vn.vessel_name = d.vessel_name 
WHERE d.file_id = " + context.file_id +"
```

First you can see that I use aliases for the tables (vn for vessel_names) so that the fields mentioned in the select are explicitly the ones from the table I want (vn.vessel_name is the field vessel_name from the table vessel_names).

Second we clearly see that the request is articulated around the table vessel_names and that we are only going to retrieve some information when there is a match between vn.vessel_names and d.vessel_name (INNER JOIN ... ON ...). If an entry in the deployments table has its field vessel_name empty or not matching any vessel_name in the vessel_names table then we would retrieve nothing for this entry.

However, this SQL request is part of a larger set of requests that are articulated around the table deployments (the WHERE d.file_id = " + context.file_id +" makes this actually obvious) and its field file_id, so we want to provide NULL results for this deployment regarding vessel_names otherwise this deployment entry will not be processed.

What we can do in order not to miss any deployment is this request :

```
SELECT vn.vessel_name, vn.platform_code, vn.colour 
FROM soop_ba.deployments d 
   LEFT OUTER JOIN vessel_names vn 
      ON vn.vessel_name = d.vessel_name 
WHERE d.file_id = " + context.file_id +"
```

This time we make it explicit that the request is articulated around the table deployments and it is also explicit that we want NULL results when there is not an exact joint with the table vessel_names since we use LEFT OUTER JOIN.
