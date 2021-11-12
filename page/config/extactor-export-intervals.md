---
layout: default
title: Configuring Data Export Intervals
---

By default, the Data Exporter sends JSON data for entities, actions, and groups at 10-minute intervals. 
This usually gives a good flow of data that your data search and analysis services can ingest.

For very large environments, it is possible that the quantity of data can overwhelm the ability of your 
service to ingest it at 10-minute intervals. In the worst case, this can result in Out Of Memory 
errors in your service connector. If this occurs, lengthening the interval can reduce the overall 
volume of data your service has to ingest.

You can configure the data export interval in the extractor component for action data and entity and group 
data.  


1. Open an SSH terminal session to your Turbonomic instance.  
   Log in with the System Administrator that you set up when you installed {{ site.data.vars.Product_Short }}:

    Username: `turbo`  
    Password: `[your_private_password]`

2. Edit the cr.yaml file to add export intervals to the extractor component.  
   In the same SSH session, open the cr.yaml file for editing. For example:  
   `vi /opt/turbonomic/kubernetes/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml`
   
3. Edit the entry for the extractor properties.  
   Search for the extractor properties entry in the cr.yaml file. It should appear as:  
    ```
    properties:
      extractor:
        enableDataExtraction: true
    ```    
4. Add the properties to control the export intervals.
   By default, the extractor exports data every 10 minutes.  You can add properties to the 
   extractor to change the interval. Each setting is in units of minutes.  
   With these settings, you can specify intervals:
   - Globally  
     `globalExtractionIntervalMins`  
     If you want to change the interval for all extractor data exports, use this  
     property. 
   - For Entities and Groups  
     `entityExtractionIntervalMins`  
     To specify an export interval for entity and group data, use this property. If it is present in 
     the extractor properties, this setting takes precedence for entities and groups. 
   - For Actions   
     `actionExtractionIntervalMins`  
     To specify an export interval for actions data, use this property. If it is present in 
     the extractor properties, this setting takes precedence for actions. 
     
   For example, the following specification sets a 30-minute interval on entities and groups, and 
   a 15-minute interval on actions:    
   
    ```
    properties:
      extractor:
        enableDataExtraction: true
        entityExtractionIntervalMins: 30
        actionExtractionIntervalMins: 15
    ```    
   
4. Save and apply your changes to the platform.  
   After you save your changes, use `kubectl` to apply the changes:  
   ```
   kubectl apply -f \
   /opt/turbonomic/kubernetes/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml  
   ```
5. Verify that the extractor component is running.  
   Give the platform enough time to restart the components. Then execute the command:  
   `kubectl get pods -n turbonomic`  
   
   You should see output similar to the following:  
   ```
   NAME                                         READY   STATUS    RESTARTS 
   ...
   extractor-5f41dd61c4-4d6lq                   1/1     Running   0   
   ...
   ```  
   Look for an entry for the `extractor` component. If the entry is present, ready, and running, then the 
   extractor component is installed and running.
   



