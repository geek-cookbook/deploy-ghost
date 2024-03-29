FROM bitnami/ghost:latest

USER root

RUN install_packages jq
RUN mkdir -p /.npm && chmod -R g+rwX,o+rw /.npm

COPY post_ghost_config.sh /
RUN chmod +x /post_ghost_config.sh \
    && cp /opt/bitnami/scripts/ghost/entrypoint.sh /tmp/entrypoint.sh \
    && sed '/info "\*\* Ghost setup finished! \*\*"/ a . /post_ghost_config.sh' /tmp/entrypoint.sh > /opt/bitnami/scripts/ghost/entrypoint.sh \
    && mkdir /funkypenguin/ -p \
    && chown -R 1001 /funkypenguin

ENV AWS_ACCESS_KEY_ID="AWS_ACCESS_KEY_ID" \
    AWS_ACCESS_SECRET_KEY="AWS_ACCESS_SECRET_KEY" \
    AWS_REGION="AWS_REGION" \
    AWS_BUCKET="AWS_BUCKET" \
    AWS_SIGNATURE_VERSION="v4" \
    AWS_ASSETHOST="https://static.funkypenguin.co.nz"

USER 1001

# We can't use /bitnami/ghost in the pod because it gets overwritten by an emptyDir
RUN cd /funkypenguin \
    && npm i --silent ghost-storage-adapter-s3 && \
    cd node_modules/ghost-storage-adapter-s3 && \
    npm install

