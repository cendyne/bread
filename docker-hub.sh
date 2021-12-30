set -e
# Too many platforms and it'll run out of memory..
PLATFORMS="linux/amd64,linux/arm64"
DATE=$(date '+%Y-%m-%dT%H:%M:%S')

if [ -z "$GITHUB_SHA" ]; then
echo "Guessing GITHUB_SHA"
GITHUB_SHA=$(git rev-parse HEAD)
fi

echo "${GITHUB_SHA}" > static/version.txt

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USER" --password-stdin

echo "Building and pushing to"
echo "- $DOCKER_REPO:latest"
echo "- $DOCKER_REPO:${GITHUB_SHA:0:7}"
# This script is only meant to run on main in github
docker buildx build --platform "$PLATFORMS" . \
    --target=app \
    --tag "$DOCKER_REPO:latest" \
    --tag "$DOCKER_REPO:${GITHUB_SHA:0:7}" \
    --label "org.opencontainers.image.revision=$GITHUB_SHA" \
    --label "org.opencontainers.image.created=$DATE" \
    --label "org.opencontainers.image.source=https://github.com/cendyne/bread" \
    --push