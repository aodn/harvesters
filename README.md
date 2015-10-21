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

