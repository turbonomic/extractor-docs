---
layout: default
title: Entity Object
---

The extractor sends JSON documents to Kafka for individual entities. Each object has 
two top-level fields:

* `timestamp`: When the entity was broadcast
* `entity`: The object that describes the given entity.


## Sample Entity Object
<details>
<summary>Click to Show/Hide:</summary>
{% include codeSamples/basicEntityObject.html %}
</details>



## Common Entity Object Fields
Every `entity` object includes the following fields:
<details>
<summary>Click to Show/Hide:</summary>
{% include genFiles/entity.html %}
</details>





## Supported Entity Types:
{{ site.data.vars.Product_Short }} can export data for the following types of entities.
<details>
<summary>Click to Show/Hide::</summary>
{% include genFiles/entity_type.html %}
</details>

## Supported Metric Types:
{{ site.data.vars.Product_Short }} tracks different metrics for different types of entities. 
For a given entity object, you will get the metric data that is appropriate for that entity. 
This list is all the metric types that the Data Exporter supports.
<details>
<summary>Click to Show/Hide::</summary>
{% include genFiles/metric_type.html %}
</details>


## Supported Related Entity Types:
Related entities are entities that are connected to the given entity in the supply chain. 
For example, a VM entity can have containers and applications running on it, while it 
uses disk space from related storage. For a given object, the data includes all the related 
entities. The supported related types can be any of the supported entities, or any of 
the group types listed here.
<details>
<summary>Click to Show/Hide::</summary>
{% include genFiles/related_types.html %}
</details>


