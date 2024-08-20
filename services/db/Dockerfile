# CUSTOM DOCKER IMAGE FOR THE THESIS DATABASE - BÁLINT TÓTH - 2024. 08. 19 #

FROM alpine:latest

RUN \

addgroup -g 2000 -S dock_group && \
adduser -G dock_group -u 2000 -s /sbin/nologin -S -H dock_user && \

apk add --no-cache postgresql && \

mkdir -p /run/postgresql && \
chown dock_user:dock_group /run/postgresql

USER dock_user:dock_group

ENTRYPOINT ["/container-config/entrypoint.sh"]

# SOURCES:
# https://www.postgresql.org/download/linux/debian/
