#!/bin/bash

# networks
docker network create -d overlay frontend

docker network create -d overlay backend


# services
docker service create --name vote --network frontend --replicas 2 -p 5000:80 dockersamples/examplevotingapp_vote

docker service create --name redis --network frontend --replicas 2 redis:alpine

docker service create --name worker --network frontend --network backend --replicas 2 dockersamples/examplevotingapp_worker

docker service create --name db --network backend --mount type=volume,source=db-data,target=/var/lib/postgresql/data -e POSTGRES_PASSWORD=mypass postgres:15-alpine

docker service create --name result --network backend -p 5001:80 dockersamples/examplevotingapp_result

