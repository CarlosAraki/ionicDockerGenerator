# Some Install 
 npm install -g npm@6.14.4
 npm install -g @ionic/cli@6.12.3

 ionic start appTest blank


# how use
 
docker build . -t appionic/app
docker run -d --name appionic/app --network host appionic/app
docker run -d --name appionic/app --network host appionic/app

docker build -t appcompiler .
