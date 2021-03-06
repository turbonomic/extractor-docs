---
layout: default
title: Configuring Data Export Intervals
---

By default, the Data Exporter sends JSON data for entities and groups at 10-minute intervals. 
This usually gives a good flow of data that your data search and analysis services can ingest.

For very large environments, it is possible that the quantity of data can overwhelm the ability of your 
service to ingest it. In the worst case, this can result in Out Of Memory 
errors in your service connector. If this occurs, lengthening the export interval can reduce the overall 
volume of data your service has to ingest.

You can configure the data export interval in the extractor component for action data and for entity and group 
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
   By default, the extractor exports entity and group data every 10 minutes, and action data 
   every 6 hours.  You can add properties to the 
   extractor to change the interval. Each setting is in units of minutes.  
   With these settings, you can specify intervals:
   - Globally  
     `globalExtractionIntervalMins`  
     If you want to set a single interval for all extractor data exports (entities, groups, and actions), 
     use this property.   
   - For Entities and Groups  
     `entityExtractionIntervalMins`  
     To specify an export interval for entity and group data, use this property. If it is present in 
     the extractor properties, this setting takes precedence for entities and groups. 
   - For Actions   
     `actionExtractionIntervalMins`  
     To specify an export interval for actions data, use this property. If it is present in 
     the extractor properties, this setting takes precedence for actions. 
     
   For example, the following specification sets a 30-minute interval on entities and groups, and 
   a one-hour interval on actions:    
   
    ```
    properties:
      extractor:
        enableDataExtraction: true
        entityExtractionIntervalMins: 30
        actionExtractionIntervalMins: 60
    ```    
   
4. Save and apply your changes to the platform.  
   After you save your changes, use `kubectl` to apply the changes:  
   ```
   kubectl apply -f \
   /opt/turbonomic/kubernetes/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml  
   ```

5. Restart the extractor component.  
     
   First, get the name of the extractor pod:
   `kubectl get pods -n turbonomic`  
   
   You should see output similar to the following:  
   ```
   NAME                                         READY   STATUS    RESTARTS 
   ...
   extractor-5f41dd61c4-4d6lq                   1/1     Running   0   
   ...
   ```     

   Search the listing for the extractor pod, and use that as the pod name.  Then delete the pod 
   to force it to restart. For the example above, enter the command:   
   `kubectl delete pod extractor-5f41dd61c4-4d6lq`  
   
6. Verify that the extractor component is running.  
   Give the platform enough time to restart the components. Then execute the command:  
   `kubectl get pods -n turbonomic`  
   
   You should see the extractor pod in the listing, and its status should be `RUNNING`.
   



