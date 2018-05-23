## sparkvisor
Simple script to restart system processes:

`sudo ./sparkvisor.sh -s [SERVICE_NAME] [ARGUMENTS] `

### EXAMPLE COMMAND
Check Nginx server every 30 seconds, try to restart every 5 seconds for 10 times, output log and console

`sudo ./sparkvisor.sh -s nginx -i 30 -w 5 -a 10 -v 1 -l webstart.log`

#### [ Arguments ]
-s 
##### service to monitor (required parameter)
-i
#### check interval in seconds (default=30)
-w
#### number of seconds to wait before restarting service (default=10)
-a 
#### number of attempts to restart the service (default=5)
-v 
#### more verbose output for testing purposes
-l
#### log file location
