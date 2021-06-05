---
layout: default
title: Deploying a Connector
---

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




