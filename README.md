### First time installation
```
git clone https://github.com/jacksonlmakl/data_flow_tool.git
cd data_flow_tool
 ./setup.sh &

./launch_app.sh &

./launch_jupyter.sh 
```

### On Instance Restart
```
./launch_app.sh &
./launch_jupyter.sh
```
You can always use this command to see into a containers file system:

```
docker exec -it <container_id_or_name> /bin/bash
```

### Links
```
Airflow: http://<your-host-address>:8080/home
Automation Manager: http://<your-host-address>:8081/
Jupyter Notebook DAG Editor: http://<your-host-address>:8888
Airflow Test Environment: http://<your-host-address>:8082/home

```


