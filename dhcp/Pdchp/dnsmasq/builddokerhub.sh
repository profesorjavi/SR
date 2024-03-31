REGISTRY="profesorjavi"
PROJECT_NAME="dnsmasq"

VERSION="1.0"
docker build --pull --no-cache --tag $REGISTRY/$PROJECT_NAME .
docker push $REGISTRY/$PROJECT_NAME

VERSION="latest"
docker build --pull --no-cache --tag $REGISTRY/$PROJECT_NAME:$VERSION .
docker push $REGISTRY/$PROJECT_NAME:$VERSION