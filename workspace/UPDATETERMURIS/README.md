
## Purpose

This talend project is used to update term URI's in MCP metadata to match term URI's in a supplied concept scheme.

## Usage

### Prerequisites
Using this project to update term URI's, requires Talend Open Studio to be installed with IMOS User Components and for this repository to be cloned for access within Talend Open Studio. 

### To Run

 * Import this project into Talend Open studio
 * Open the Update job
 * Configure context parameters as specified below
 * Run the the job.

### Context Parameters

#### Externalisation parameters 

Used to enable execution of this job as a packaged java application using externally sourced context parameters as per talend harvesters

parameter | description
---- | ----
paramFile | location of the file from which to load other context parameters (NOT REQUIRED when running this job within Talend Open Studio and configuring context parameters there)
logDir | location of the directory where log files will be written (before and after copies of the metadata are written to this directory for comparison)

#### GeoNetwork parameters

Used to specify the database connection details of the GeoNetwork instance to update.  For RC and Production instances - port forwarding is needed to establish an external connection that can be used within Talend Open Studio

#### Source parameters

Used to specify the type of term to update and the skos/rdf file to be used to replacement term URI's

Use the following containerElement values to update applicable terms:

containerElement | thesaurusFile to use
---- | ----
parameterName | parameter discovery vocabulary file
parameterUnits | units of measure vocabulary file
parameterDeterminationInstrument | instrument vocabulary file
parameterAnalysisMethod | analysis method vocabulary
platform | platform vocabulary file

#### Notes on processing

The xsl used to perform the update only updates the vocabularyTermURL element of a term to the URI of a concept only if:

 * the term occurs within the element specified
 * the term matches the preferred label of the concept

If more than one concept is found in the thesaurus with a preferred label matching the term, an exception will be thrown.  

Check the end of the before file in the log directory to see the metadata record being processed when an exception is thrown processing a metadata record.

