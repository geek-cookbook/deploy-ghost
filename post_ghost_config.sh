#!/bin/bash -e
cp /bitnami/ghost/config.production.json /tmp/config.tmp.json

jq -r --arg keyId $AWS_ACCESS_KEY_ID --arg accessKey $AWS_ACCESS_SECRET_KEY --arg region $AWS_REGION --arg bucket $AWS_BUCKET \
    '. + { storage: { active: "s3", s3: { accessKeyId: $keyId, secretAccessKey: $accessKey, region: $region, bucket: $bucket } } }' \
    /tmp/config.tmp.json > /bitnami/ghost/config.production.json

cd /funkypenguin
mkdir -p /bitnami/ghost/content/adapters/storage/s3
cp -r ./node_modules/ghost-storage-adapter-s3/* /bitnami/ghost/content/adapters/storage/s3/