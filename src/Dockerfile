FROM debian:latest
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /odm

RUN apt-get update -qq > /dev/null
RUN apt-get install tor -y -qq > /dev/null

COPY ./script.sh /odm/script.sh
RUN chmod +x script.sh
CMD [ "./script.sh" ] 