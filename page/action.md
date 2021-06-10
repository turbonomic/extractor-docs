---
layout: default
title: Action Object
---

The extractor sends action data to Kafka:
* Every 6 hours for pending actions.
* Immediatly after an action completes, whether completion is success or failure.

Each action object has 
two top-level fields:

* `timestamp`: When the action object was broadcast.
* `action`: The data that describes the given action.


## Sample Action Object
<details>
<summary>Click to Show/Hide:</summary>
{% include codeSamples/basicActionObject.html %}
</details>



## Common Entity Object Fields
Every `action` object includes the following fields:
<details>
<summary>Click to Show/Hide:</summary>
<ul>
<li><p><code>oid</code>: The action object identifier.</p></li>
<li><p><code>creationTime</code>: When {{ site.data.vars.Product_Short }} created the action.</p></li>
<li><p><code>type</code>: The action type. Can be one of:</p>
{% include genFiles/action_type.html %}
</li>
<li><p><code>state</code>: The state the action is in at the time the JASON object is created. Can be one of:</p></li>
{% include genFiles/action_state.html %}
<li><p><code>mode</code>: The mode for the action execution. Can be one of:</p>
<ul>
<li><p><code>AUTOMATIC</code></p></li>
<li><p><code>MANUAL</code></p></li>
<li><p><code>RECOMMEND</code></p></li>
</ul>
</li>
<li><p><code>category</code>: The category of action. Can be one of:</p>
{% include genFiles/action_category.html %}
</li>
<li><p><code>severity</code>: The severity of the action.  Can be one of:</p>
{% include genFiles/severity.html %}
</li>

<li><p><code>description</code>: The description that {{ site.data.vars.Product_Short }} generates for the action.</p></li>
<li><p><code>explanation</code>: The condition that the action is addressing.  For example, `Q2 VCPU Congestion`.</p></li>
<li><p><code>target</code>: The entity that the action operates on.</p></li>
<li><p><code>related</code>: An array of entities or groups that are related to the target entity.</p></li>
<li><p>Action Info: Information to describe the action. Depending on the type of action, can be one of:</p>
    <ul>
    <li><p><code>moveInfo</code></p></li>
    <li><p><code>resizeInfo</code></p></li>
    <li><p><code>deleteInfo</code></p></li>
    <li><p><code>buyRiInfo</code></p></li>
    </ul>
<p>For example, a <code>moveInfo</code> field describes the FROM and TO for the move:</p>
<pre>
    "moveInfo": {
      "from": {
        "oid": "73741823904848",
        "name": "hp-bl433.eng.vmturbo.com",
        "type": "PHYSICAL_MACHINE"
      },
      "to": {
        "oid": "73741823904864",
        "name": "hp-bl435.eng.vmturbo.com",
        "type": "PHYSICAL_MACHINE"
      }
    }
</pre>
</li>
</ul>

</details>




