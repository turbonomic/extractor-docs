---
layout: default
title: Enabling the Data Exporter
---

To support the Data Exporter, {{ site.data.vars.Product_Short }} provides an extractor component 
that can stream data to a standard format. You can load that data into search and analytics 
services such as Elasticsearch.

To enable the Data Exporter, you must:  

* Enable the extractor component.  
  The extractor is a component that runs as part your {{ site.data.vars.Product_Short }} 
  installation. The extractor is not enabled by default.

* Deploy a connector that delivers the extractor's stream to your data service.  
  The extractor publishes {{ site.data.vars.Product_Short }} data as Kafka topics. The connector 
  enables your data service to consume the data topic. This document includes a deployment file 
  for a sample Elasticsearch connector.


​