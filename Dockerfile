# Use the official Airflow image with Python 3.8
FROM apache/airflow:2.5.1-python3.8

# Set environment variables
ENV AIRFLOW_HOME=/opt/airflow
ENV PIP_USER=false
ENV HOME=/root

USER airflow
# Create necessary directories and set permissions
# USER root
# RUN mkdir -p /opt/airflow/logs /opt/airflow/dags && #     chown -R airflow: /opt/airflow

# Copy everything from the current directory to the working directory in the Docker image
# COPY . /opt/airflow/
# Copy the tarball into the Docker image
COPY requirements.txt /opt/airflow/requirements.txt
COPY airflow_home.tar.gz /opt/airflow/
COPY entry_point.sh  /opt/airflow/
# Ensure entry_point.sh is executable
USER root
RUN chmod +x /opt/airflow/entry_point.sh
USER airflow

RUN tar -xzvf /opt/airflow/airflow_home.tar.gz -C /opt/airflow && rm /opt/airflow/airflow_home.tar.gz
RUN rm -rf /opt/airflow/dags
RUN cp -rf /opt/airflow/airflow_home/dags/ /opt/airflow/
RUN rm -rf /opt/airflow/airflow_home

COPY secrets.yaml /opt/airflow/dags/secrets.yaml
COPY secrets.yaml /opt/airflow/secrets.yaml

# Install python3-venv if it's not installed
USER root
RUN apt-get update && apt-get install -y python3-venv

# Switch to the airflow user
# USER airflow

# Create the virtual environment
RUN python3 -m venv /opt/airflow/airflow_venv

# Upgrade pip and install dependencies
RUN /opt/airflow/airflow_venv/bin/pip install --upgrade pip
RUN /opt/airflow/airflow_venv/bin/pip install dbt dbt-snowflake
RUN /opt/airflow/airflow_venv/bin/pip install -r /opt/airflow/requirements.txt

# Set the working directory
WORKDIR /opt/airflow

# Set the entrypoint
ENTRYPOINT ["/opt/airflow/entry_point.sh"]
