### First time installation
```
git clone https://github.com/jacksonlmakl/data_flow_tool.git
cd data_flow_tool
git remote remove origin
sed -i "s/localhost:/<YOUR HOST IP ADDRESS HERE>:/g" "templates/index.html"

 ./setup.sh 

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
Platform Manager: http://<your-host-address>:8081/

Airflow Prod: http://<your-host-address>:8080/home
Airflow Dev: http://<your-host-address>:8082/home
Jupyter DAG Editor Dev: http://<your-host-address>:8888


```


