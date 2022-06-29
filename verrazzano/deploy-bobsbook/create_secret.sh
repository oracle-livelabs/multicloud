#!/bin/bash

x=`docker login container-registry.oracle.com -u $1 -p $2`

if [ "$x" == 'Login Succeeded' ]
then
   docker logout
   kubectl create secret docker-registry bobs-books-repo-credentials  --docker-server=container-registry.oracle.com  --docker-username=$1 --docker-password=$2 --docker-email=$1  -n bobs-books
else
   echo "Incorrect Login Credentials "
fi