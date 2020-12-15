 #!/bin/bash
 get_status () {
 not_ready=true
 nc -z 127.0.0.1 8080
 if [ $? -ne 0 ]
 then
   echo "waiting for jenkins to start"
else
   echo "Jenkins starts successfully"
   not_ready=false
fi
}

while $not_ready
do
  get_status
  sleep 5
done
