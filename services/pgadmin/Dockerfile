# CUSTOM DOCKER IMAGE FOR A PGADMIN SLIM CLIENT - BÁLINT TÓTH - 2024. 09. 26 #

FROM dpage/pgadmin4:latest

USER root:root

RUN \

addgroup -g 2000 -S dock_group && \
adduser -G dock_group -u 2000 -s /sbin/nologin -S -H dock_user && \

chown -R dock_user:dock_group /pgadmin4 /var/lib/pgadmin

USER dock_user:dock_group

ENTRYPOINT ["/container-config/entrypoint.sh"]

# SOURCES:
# https://hub.docker.com/r/dpage/pgadmin4/
