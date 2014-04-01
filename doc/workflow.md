## Proposed new workflow (DRAFT - WIP)

### Setting up Talend to use the harvester repo workspace

* Clone the harvester repository to your local machine i.e.

 ```
git clone git@github.com:aodn/harvester.git
```

* Open Talend Open Studio project selection dialog
* Change the workspace by hitting the Change button after the current workspace name
* Select the workspace directory in the local harvester repository you created above
* Restart Talend when asked
* Create a new project or import an existing one from this workspace 
* Go to Window / Preferences and change the User component folder under Talend / Components to the location of your local talend components repository

### To add or change a harvester 

* Pull any updates to the master branch and then create a branch in which you will make your changes
 ```
git checkout master
git pull 
git checkout -b {short-change-name}
```
* To create a new harvester select create new project and enter in the name of the new project and optionally a description
* To modify an existing harvester you will need to import it into the workspace if you haven't already and then open it up.

### To deploy changes to the Release Candidate environment

* Once you have made and tested your changes push your new branch to github
 ```
 git push -u origin {short-change-name}
 ```
* The modified harvester should be reviewed by another talend developer by pulling updates to the repository from github to their local repository, cchecking out the branch created above, importing the project if necessary into Talend Open Studio and reviewing chnages made as per description in the pull request
* When the harvester has been reviewed and any agreed changes have been made, the reviewer will merge the pull request into master and delete the branch from github.
* A developer will make/review any changes required to deploy the changes and deploy the harvester to the Release Candidate environment

### To deploy changes to Production

The harvester will be deployed to production by a developer on request when
* the harvester has been deployed and run successfully in the Release Candidate environment
* geoserver performance alerts have been addressed
* the harvest has been checked and confirmed as running correctly


