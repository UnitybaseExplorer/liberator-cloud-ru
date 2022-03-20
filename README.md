# launcher-disbalancer

# GCP cloud run

## create repo & push image
gcloud init
gcloud projects create disliberator --name="disliberator"
gcloud artifacts repositories create disliberator-repo --repository-format=docker --location=us-central1 --description="Docker repository"
docker build -t us-central1-docker.pkg.dev/disliberator/disliberator-repo/liberator:latest .
<!-- docker run --rm -p 8080:8080 us-central1-docker.pkg.dev/disliberator/disliberator-repo/liberator -->

gcloud auth configure-docker us-central1-docker.pkg.dev
docker push us-central1-docker.pkg.dev/disliberator/disliberator-repo/liberator:latest

## deploy container to Cloud Run
<!-- gcloud run deploy liberator-service --image us-central1-docker.pkg.dev/serverlessrun/liberator-repo/liberator --region us-central1 --project=serverlessrun --platform managed --allow-unauthenticated --quiet --min-instances 1 --max-instances=3 -->

POWERSHELL // --region $regions[$num]
$regions=@("australia-southeast1", "europe-north1", "europe-west1", "northamerica-northeast1", "southamerica-east1", "us-central1", "us-west1", "asia-south1", "asia-southeast1", "europe-west4")
for ($num = 0; $num -le 9; $num++) {gcloud run deploy liberator-service-$num --image us-central1-docker.pkg.dev/serverlessrun/liberator-repo/liberator --region europe-west1 --project=serverlessrun --platform managed --allow-unauthenticated --quiet --min-instances 1 --max-instances=3 --cpu=1 --memory=1Gi}


===========

gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=liberator-service" --project serverlessrun --limit 10 --flatten textPayload --format=list

for ($num = 0; $num -le 9; $num++) {Write-Host "liberator-service-$num status:"; gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=liberator-service-$num" --project serverlessrun --limit 10 --flatten textPayload --format=list}