# CUSTOM DOCKER IMAGE FOR IDE & VERSION CONTROL - BÁLINT TÓTH - 2024. 08. 19 #

FROM debian:bookworm

RUN \

groupadd -g 2000 -r dock_group && \
useradd -g 2000 -u 2000 -d /container-data -r -M -N dock_user && \

apt update && \
apt install -y curl wget git && \
curl -fsSL https://code-server.dev/install.sh | bash && \
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
dpkg -i packages-microsoft-prod.deb && \
rm packages-microsoft-prod.deb && \

apt update && \
apt upgrade && \
apt install -y dotnet-sdk-8.0

USER dock_user:dock_group

ENTRYPOINT ["/container-config/entrypoint.sh"]

# SOURCES:
#
# https://coder.com/docs/code-server/install#debian-ubuntu
