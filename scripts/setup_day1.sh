#!/bin/bash

# Java Installation
sudo apt update
sudo apt install -y default-jdk

# Maven Installation
sudo apt install -y maven

# Print versions
java -version
mvn -version
