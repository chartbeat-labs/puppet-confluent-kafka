#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with confluent_kafka](#setup)
    * [What confluent_kafka affects](#what-confluent_kafka-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with confluent_kafka](#beginning-with-confluent_kafka)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Unofficial module for install and managing Confluent's ([http://confluent.io/]) distribution of Kafka.

Currently only tested on Ubuntu 12.04

[![Build Status](https://travis-ci.org/chartbeat-labs/puppet-confluent-kafka.svg)](https://travis-ci.org/chartbeat-labs/puppet-confluent-kafka)

## Module Description

Module that manages the installation and configuration of Confluent's distribution of Kafka.  Currently only supports brokers

## Setup

### What confluent_kafka affects

* Installs Kafka package, service and java if specified

### Beginning with confluent_kafka

```puppet
    class { 'confluent_kafka': }
```

## Usage

###Classes

####Class: `confluent_kafka`
Main class for the module, will install the package

###Types:

####Type: `confluent_kafka::topic`
Create/Delete topic in cluster
```puppet
    confluent_kafka::topic { 'topic_name':
      ensure             => present,
      replication_factor => 3,
      partitions         => 16,
    }
```

## Reference

###Classes
####Public Classes
 * [`confluent_kafka`]
####Private Classes
 * [`confluent_kafka::config`]
 * [`confluent_kafka::install`]
 * [`confluent_kafka::service`]
 * [`confluent_kafka::params`]

## Limitations
This module is tested on the following platforms:

 * Ubuntu 12.04

