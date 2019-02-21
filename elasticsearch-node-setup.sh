#!/bin/bash

sudo yum update

# Java 8 Installation
sudo yum install java-1.8.0 -y
sudo yum remove java-1.7.0-openjdk -y

# Elasticsearch 6.6.0 Installation
rpm -i https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.0.rpm

sudo echo ES_HEAP_SIZE="\"-Xms1g -Xmx1g\"" >> /etc/sysconfig/elasticsearch
sudo echo MAX_LOCKED_MEMORY=unlimited >> /etc/sysconfig/elasticsearch

# Discovery EC2 plugin is used for the nodes to create the cluster in AWS
sudo echo -e "y\n" | /usr/share/elasticsearch/bin/elasticsearch-plugin install discovery-ec2

# Shortest configuration for Elasticsearch nodes to find each other
sudo echo "cluster.name: advanceai" >> /etc/elasticsearch/elasticsearch.yml
#sudo echo "discovery.zen.hosts_provider: ec2" >> /etc/elasticsearch/elasticsearch.yml
#sudo echo "cloud.node.auto_attributes: true" >> /etc/elasticsearch/elasticsearch.yml
#sudo echo "cluster.routing.allocation.awareness.attributes: aws_availability_zone" >> /etc/elasticsearch/elasticsearch.yml
#sudo echo "network.host: ["_ec2_"]" >> /etc/elasticsearch/elasticsearch.yml

#sudo /usr/share/elasticsearch/bin/elasticsearch-keystore add discovery.ec2.access_key
#sudo /usr/share/elasticsearch/bin/elasticsearch-keystore add discovery.ec2.secret_key

sudo chkconfig --add elasticsearch

sudo service elasticsearch start

echo "Node setup finished!" > ~/terraform.txt