cd ~/62070045_assignment/src/details || git clone -b dev git@github.com:Fyefee/itkmitl-bookinfo-details.git ~/62070045_assignment/src/details
docker build -t details ~/62070045_assignment/src/details/
docker run -d --name details -p 8081:8081 details

cd ~/62070045_assignment/src/ratings || git clone -b dev git@github.com:Fyefee/itkmitl-bookinfo-ratings.git ~/62070045_assignment/src/ratings
docker build -t ratings ~/62070045_assignment/src/ratings/
docker run -d --name mongodb -p 27017:27017 -v  ~/62070045_assignment/src/ratings/databases:/docker-entrypoint-initdb.d bitnami/mongodb:5.0.2-debian-10-r2
docker run -d --name ratings -p 8080:8080 --link mongodb:mongodb -e SERVICE_VERSION=v2 -e 'MONGO_DB_URL=mongodb://mongodb:27017/ratings' ratings

cd ~/62070045_assignment/src/reviews || git clone -b dev git@github.com:Fyefee/itkmitl-bookinfo-reviews.git ~/62070045_assignment/src/reviews
docker build -t reviews ~/62070045_assignment/src/reviews/
docker run -d --name reviews -p 8082:8082 --link ratings:ratings -e ENABLE_RATINGS=true -e STAR_COLOR=salmon -e RATINGS_SERVICE=http://ratings:8080 reviews

cd ~/62070045_assignment/src/productpage || git clone -b dev git@github.com:Fyefee/itkmitl-bookinfo-productpage.git ~/62070045_assignment/src/productpage
docker build -t productpage ~/62070045_assignment/src/productpage/
docker run -d --name productpage -p 8083:8083 --link details:details -e DETAILS_HOSTNAME=http://details:8081 --link reviews:reviews -e REVIEWS_HOSTNAME=http://reviews:8082 --link ratings:ratings -e RATINGS_HOSTNAME=http://ratings:8080 productpage



