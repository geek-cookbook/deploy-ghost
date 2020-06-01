FROM bitnami/ghost:latest

USER root

RUN install_packages jq
RUN mkdir -p /.npm && chmod -R g+rwX,o+rw /.npm

COPY post_ghost_config.sh /
RUN chmod +x /post_ghost_config.sh \
    && cp /app-entrypoint.sh /tmp/app-entrypoint.sh \
    && sed '/info "Starting ghost... "/ a . /post_ghost_config.sh' /tmp/app-entrypoint.sh > /app-entrypoint.sh 

ENV AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID" \
    AWS_ACCESS_SECRET_KEY="AWS_ACCESS_SECRET_KEY" \
    AWS_REGION="AWS_REGION" \
    AWS_BUCKET="AWS_BUCKET" 

USER 1001

RUN cd /bitnami/ghost \
    && npm i --silent ghost-storage-adapter-s3 \ 
    && mkdir -p /bitnami/ghost/content/adapters/storage/s3 \
    && cp -r ./node_modules/ghost-storage-adapter-s3/* /bitnami/ghost/content/adapters/storage/s3/ 