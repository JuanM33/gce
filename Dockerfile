FROM python:3.7-slim-buster

RUN apt-get update
RUN apt-get install -y procps

COPY . .

RUN pip3 install -r /docker/requirements.txt

#------------------------------------------------------
# SET the Service Account path ENV
#------------------------------------------------------
ENV GOOGLE_APPLICATION_CREDENTIALS "/source/credentials/"

#------------------------------------------------------
# Set time zone
#------------------------------------------------------
RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/Mexico_City /etc/localtime

#------------------------------------------------------
# This variable is used by containerMonitor.py to know when the execution
# is on GCE, for local set to 0. Overwritten by building with automation scripts
#------------------------------------------------------
ARG GCE_env_var=0
ENV RUNNING_ON_COMPUTE_ENGINE=$GCE_env_var

#------------------------------------------------------
# This variable is used to know when the execution is on debug mode
# For debug set to 1 (Default).
# For production set to 0.
# Overwritten by building with cloudbuild.yaml and cloudbuild-trigger.yaml
#------------------------------------------------------
ARG debug_env_var=1
ENV DEBUG=$debug_env_var

#------------------------------------------------------
# Entrypoint
#------------------------------------------------------
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "'./start.sh'"]
