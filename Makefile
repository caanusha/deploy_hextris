IMAGE_NAME = hextris
IMAGE_TAG = latest
CLUSTER_NAME = hextris-cluster
HELM_CHART_DIR = ./helm/hextris

.PHONY: build load deploy clean docker-clean terraform-init terraform-apply test

terraform-init:
        cd terraform && terraform init

terraform-apply:
        cd terraform && terraform apply -auto-approve

build:
        @if docker image inspect $(IMAGE_NAME):$(IMAGE_TAG) > /dev/null 2>&1; then \
                echo "Docker image $(IMAGE_NAME):$(IMAGE_TAG) already exists, skipping build"; \
        else \
                echo "Building Docker image..."; \
                docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .; \
        fi

load:
        @echo "Loading Docker image into Kind cluster..."
        kind load docker-image $(IMAGE_NAME):$(IMAGE_TAG) --name $(CLUSTER_NAME)

deploy:
        helm upgrade --install $(IMAGE_NAME) $(HELM_CHART_DIR) \
                --set image.repository=$(IMAGE_NAME),image.tag=$(IMAGE_TAG)

clean:
        helm uninstall $(IMAGE_NAME) || true
        kubectl delete pods,configmap,secret,pvc -l app=$(IMAGE_NAME) || true
        cd terraform && terraform destroy -auto-approve

docker-clean:
        -docker ps -a -q --filter ancestor=$(IMAGE_NAME):$(IMAGE_TAG) | xargs -r docker rm -f
        -docker image rm $(IMAGE_NAME):$(IMAGE_TAG)
        -docker volume ls -q --filter label=app=$(IMAGE_NAME) | xargs -r docker volume rm
test:
        kubectl port-forward svc/hextris 30080:80

all: build terraform-init terraform-apply load deploy