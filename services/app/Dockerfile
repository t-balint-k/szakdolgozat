# CUSTOM DOCKER IMAGE FOR THE THESIS APP - BÁLINT TÓTH - 2024. 08. 19 #

FROM debian:bookworm

RUN \

groupadd -g 2000 -r dock_group && \
useradd -g 2000 -u 2000 -r -M -N dock_user && \

apt update && \
apt install -y wget && \
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
dpkg -i packages-microsoft-prod.deb && \
rm packages-microsoft-prod.deb && \

apt update && \
apt upgrade && \
apt install -y dotnet-sdk-8.0 && \

mkdir /home/dock_user && \
chown dock_user:dock_group /home/dock_user

USER dock_user:dock_group

ENTRYPOINT ["/container-config/entrypoint.sh"]

# SOURCES:
#
# https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian
# https://hub.docker.com/_/debian/tags
