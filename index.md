---
layout: default
title: Using the Data Exporter
---

The {{ site.data.vars.Product_Short }} platform includes the Data Exporter, which 
you can choose to enable when you install the platform. The Data Exporter streams 
 {{ site.data.vars.Product_Short }} data about entities and actions as JSON documents that it 
 then publishes to a Kafka topic. 
 
 The exporter publishes at different frequencies, depending on the type of data:
 
 * Entity data: Published every 10 minutes.
 
 * Actions data:
   * Pending actions: Published every 6 hours. You can configure this via the `actionExtractionIntervalMins` variable.
   * Executed actions: Published immediately after the action completes, either with success or failure.
 
 You can load the exported data into search and analytics services such as Elasticsearch, and use those 
 services to visualize or analyze the entities and actions in your {{ site.data.vars.Product_Short }} 
 environment.
 
 With the Data Exporter you can build custom tracking of changes to your environment, 
 and follow the details as {{ site.data.vars.Product_Short }} keeps your applications 
 healthy.


<p>This document describes the {{ site.data.vars.Product_Short }} Data Exporter. 
For general information information about {{ site.data.vars.Product_Short }}, 
see the full {{ site.data.vars.Product_Short }} documentation 
<a href="https://docs.turbonomic.com/">HERE</a>.</p>