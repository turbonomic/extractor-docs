---
layout: default
title: Increasing the Elasticsearch Field Limit
---

For exports to Elasticsearch, it is possible that you will encounter the following error:  

`Elasticsearch: Limit of total fields [1000] has been exceeded`


In the connector's logstash logs, you might see an error similar to the following:

<details>
<summary>Expand to see the sample error:</summary>
<pre>[2021-05-28T17:16:15,252][INFO ][o.e.a.b.TransportShardBulkAction] [node1] [turbonomic6][0] mapping update reje
cted by primary
java.lang.IllegalArgumentException: Limit of total fields [1000] has been exceeded
        at org.elasticsearch.index.mapper.MappingLookup.checkFieldLimit(MappingLookup.java:200) ~[elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.index.mapper.MappingLookup.checkLimits(MappingLookup.java:192) ~[elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.index.mapper.DocumentMapper.validate(DocumentMapper.java:152) ~[elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.index.mapper.MapperService.newDocumentMapper(MapperService.java:429) ~[elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.index.mapper.MapperService.applyMappings(MapperService.java:407) ~[elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.index.mapper.MapperService.mergeAndApplyMappings(MapperService.java:390) ~[elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.index.mapper.MapperService.merge(MapperService.java:384) ~[elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.action.bulk.TransportShardBulkAction.executeBulkItemRequest(TransportShardBulkAction.java:281) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.action.bulk.TransportShardBulkAction$2.doRun(TransportShardBulkAction.java:164) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:26) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.action.bulk.TransportShardBulkAction.performOnPrimary(TransportShardBulkAction.java:209) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.action.bulk.TransportShardBulkAction.dispatchedShardOperationOnPrimary(TransportShardBulkAction.java:115) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.action.bulk.TransportShardBulkAction.dispatchedShardOperationOnPrimary(TransportShardBulkAction.java:74) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.action.support.replication.TransportWriteAction$1.doRun(TransportWriteAction.java:168) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.common.util.concurrent.ThreadContext$ContextPreservingAbstractRunnable.doRun(ThreadContext.java:732) [elasticsearch-7.12.0.jar:7.12.0]
        at org.elasticsearch.common.util.concurrent.AbstractRunnable.run(AbstractRunnable.java:26) [elasticsearch-7.12.0.jar:7.12.0]
        at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1128) [?:?]
        at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628) [?:?]
        at java.lang.Thread.run(Thread.java:834) [?:?]</pre>
</details>

If you encounter this error, Elastic search might not ingest the full set of data. For example, Elasticsearch might not 
show some entities that you can see in the {{ site.data.vars.Product_Short }} user interface.

<p>This error occurs when the number of fields in a single JSON object exceeds the default limit of 1000. 
For information about this limit, see 
<a href="https://www.elastic.co/guide/en/elasticsearch/reference/master/mapping-settings-limit.html">
Mapping limit settings</a> in the Elasticsearch documentation.
</p>

To correct this issue, you can increase the field limit:
<ul>
<li><p>In Kibana:</p>
<p>Got to <b>Index Management > Settings</b> and in crease the limit. For more information, 
see 
<a href="https://www.elastic.co/guide/en/elasticsearch/reference/current/index-mgmt.html#view-edit-indices">
Index management</a> in the Elasticsearch documentation.</p>
</li>
<li>
<p>Directly in Elasticsearch</p>
<p>You can execute the following command:</p>
<pre>curl -X PUT -H "Content-Type: application/json" -d "{\"index.mapping.total_fields.limit\": 2000}" \
http://{elasticsearch_ip}:9200/{index_name}/_settings</pre>
<p>Wjere <code>{elasticsearch_ip}</code> is the IP address of your Elasticsearch, 
and <code>{index_name}</code>  is the name of the index that exceeds the field limit.</p>
</li>
</ul>



The extractor publishes {{ site.data.vars.Product_Short }} data as Kafka topics. To load 
this data into a search and analysis service, you must deploy a connector to that service. 
For example, if you want to load the data into Elasticsearch, then you must deploy an 
Easticsearch connector.

You deploy the connector in the same Kubernetes node that runs the {{ site.data.vars.Product_Short }} 
platform. To do this, create a Kubernetes *Deployment* that declares the pods you need for 
the connector. Below, you can see a sample deployment of a connector to Elasticsearch.

To deploy the connector, you create a deployment yaml file on the same host that is running the 
extractor component, and execute the command:

`kubectl create -f <MyConnectorDeployment.yaml>`

Where `<MyConnectorDeployment.yaml>` is the name of the deployment file. 

Assume the name of the deployed pod is `es-kafka-connect`. To verify that the connector is 
running, execute `kubectl get pods -n turbonomic`. You should see output similar to: 

```
NAME                                                READY   STATUS    RESTARTS 
...
es-kafka-connect-5f41dd61c4-4d6lq                   1/1     Running   0   
...
```

After you deploy the connector, wait for a cycle of {{ site.data.vars.Product_Short }} analysis 
(approximately ten minutes). Then you should be able to see the entities and actions from your 
{{ site.data.vars.Product_Short }} environment, loaded as JSON in your data service. 

## Connector Deployment Example
Assume that you want to deploy a connector to Elasticsearch so that service 
can process the exported data. For example, you could use Kibana with Elasticsearch 
to display data dashboards. Let's say you have:

* Deployed Elasticsearch to a VM on the network where you are running Turbonomic. 
  The Elasticsearch host is visible from the Turbonomic Kubernetes node. You will specify 
  this host address in the connector deployment.

* Set up an Elasticsearch index to load the Turbonomic data. You will specify this 
  index in the connector deployment.

The following listing is a deployment that uses a Logstash image to collect the 
extractor data and pipe it to the Elasticsearch host. The deployment also sets up 
storage volumes, configures the input from the extractor, and configures output to 
the Elasticsearch instance.

As you go over the listing, pay attention to the following:

* The location of the Elasticsearch host and the login credentials:  
  ```
...
        env:
          - name: ES_HOSTS
            value: "<UrlToMyElasticsearchHost>"
          - name: ES_USER
            value: "<MyElasticsearchUser>"
          - name: ES_PASSWORD
            valueFrom:
              secretKeyRef:
                name: <MyES_KeyName>
                key: <MyES_Key>
...
```  
  Logstash will use the following environment variables:
  * `ES_HOSTS`: to identify where to pipe the exported data.
  * `ES_USER`: to identify the user account on Elasticsearch.
  * `ES_PASSWORD`: for the account login. This connector example assumes that you have 
    stored the Elasticsearch password as a Kubernetes Secret.
  
* The name of the Kafka topic:  
```
...
    output {
      elasticsearch {
        index => "<MyElasticsearchIndex>"
        hosts => [ "${ES_HOSTS}" ]
      }
    }
...
```  
  The Logstash input configuration expects a single topic named `turbonomic.exporter`.
* The Logstash output configuration is to the Elasticsearch server that is identified by the 
  `ES_HOSTS` environment variable. You specify your own Elasticsearch index in place of 
  `<MyElasticsearchIndex>`.
```
...
    output {
      elasticsearch {
        index => "<MyElasticsearchIndex>"
        hosts => [ "${ES_HOSTS}" ]
      }
    }
...
```

### Sample Listing: Elasticsearch Connector

This listing is a sample of a deployment file that can work to create an Elasticsearch 
connector for the Data Exporter. Note that you will need to change some settings, 
such as username and password. You also might need to specify ports and other settings 
to make the connector comply with your specific environment.

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: elasticsearch-kafka-connect
  labels:
    app.kubernetes.io/name: elasticsearch-kafka-connect
spec:
  replicas: 1
  selector:
    matchLabels:
      app.kubernetes.io/name: elasticsearch-kafka-connect
  template:
    metadata:
      labels:
        app.kubernetes.io/name: elasticsearch-kafka-connect
    spec:
      containers:
      - name: logstash
        image: docker.elastic.co/logstash/logstash:7.10.1
        ports:
          - containerPort: 25826
        env:
          - name: ES_HOSTS
            value: "<UrlToMyElasticsearchHost>"
          - name: ES_USER
            value: "<MyElasticsearchUser>"
          - name: ES_PASSWORD
            valueFrom:
              secretKeyRef:
                name: <MyES_KeyName>
                key: <MyES_Key>
        resources:
          limits:
            memory: 4Gi
        volumeMounts:
          - name: config-volume
            mountPath: /usr/share/logstash/config
          - name: logstash-pipeline-volume
            mountPath: /usr/share/logstash/pipeline
      volumes:
      - name: config-volume
        configMap:
          name: logstash-configmap
          items:
            - key: logstash.yml
              path: logstash.yml
      - name: logstash-pipeline-volume
        configMap:
          name: logstash-configmap
          items:
            - key: logstash.conf
              path: logstash.conf
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: logstash-configmap
data:
  logstash.yml: |
    http.host: "0.0.0.0"
    path.config: /usr/share/logstash/pipeline
  logstash.conf: |
    input {
      kafka {
        topics => ["turbonomic.exporter"]
        bootstrap_servers => "kafka:9092"
        client_id => "logstash"
        group_id => "logstash"
        codec => "json"
        type => "json"
        session_timeout_ms => "60000"   # Rebalancing if consumer is found dead
        request_timeout_ms => "70000"   # Resend request after 70 seconds
      }
    }
    filter {
    }
    output {
      elasticsearch {
        index => "<MyElasticsearchIndex>"
        hosts => [ "${ES_HOSTS}" ]
        user => "${ES_USER}"
        password => "${ES_PASSWORD}"
      }
    }
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: elasticsearch-kafka-connect
  name: elasticsearch-kafka-connect
spec:
  ports:
    - name: "25826"
      port: 25826
      targetPort: 25826
  selector:
    app: elasticsearch-kafka-connect
```




