---
layout: default
title: Enabling the Extractor Component
---

The first step to enabling the Data Exporter is to enable the extractor component. To enable the extractor:

1. Open an SSH terminal session to your Turbonomic instance.  
   Log in with the System Administrator that you set up when you installed {{ site.data.vars.Product_Short }}:

    Username: `turbo`  
    Password: `[your_private_password]`

2. Edit the cr.yaml file to enable the extractor component.  
   In the same SSH session, open the cr.yaml file for editing. For example:  
   `vi /opt/turbonomic/kubernetes/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml`
   
3. Edit the entry for the extractor component.
   
    > **NOTE:** If you have enabled Embedded Reporting, then the extractor component will 
    > already be enabled (set to `true`). 
    > 
    > You should uderstand that it is possible to enable the Data Exporter without enabling 
    > Embedded Reports, just as it is possible to enable Embedded Reports without enabling 
    > the Data Exporter.  
    Search for the extractor entry in the cr.yaml file. It should appear as:  
    ```
    extractor:
      enabled: false
    ```  
    Change the entry to `true`.
4. Edit the entry for the extractor properties.  
   Search for the extractor entry in the cr.yaml file. It should appear as:  
    ```
    properties:
      extractor:
        enableDataExtraction: false
    ```    
    Change the entry to `true`.
5. Save and apply your changes to the platform.  
   After you save your changes, use `kubectl` to apply the changes:  
   ```
   kubectl apply -f \
   /opt/turbonomic/kubernetes/operator/deploy/crds/charts_v1alpha1_xl_cr.yaml  
   ```

6. Restart the extractor component.     
   `kubectl delete extractor`  
      
7. Verify that the extractor component is running.  
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
   



