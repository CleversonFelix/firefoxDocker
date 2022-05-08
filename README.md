# firefoxDocker
Run a firefox browser in a Docker Containner

##How to Use  
chmod +x newBrowser.sh  
###Building a docker image and running a firefox containner. "user" refers to a main user with uid 1000, a current user.  
sudo ./newBrowser.sh "user" "build"  
###Before a first run, "build" param is not necessary...  
sudo ./newBrowser.sh "user"
