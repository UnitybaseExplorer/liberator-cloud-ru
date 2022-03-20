# Deploy disBalacer on GCP Cloud Run
Create Container Instances with disBalacer Liberator on GCP Cloud Run

## General preparation
- Create  Google Cloud Account https://console.cloud.google.com/freetrial/signup/tos
- Create new project:
    - In navigation menu go to **IAM & Admin -> Manage resources**
    - Click **Create Project**, name the project as **disliberator** & click Crate
    - Copy the ID of the project & save it. It will be used later as vlaue <PRIJECT_ID>

- Install Google Cloud CLI https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe


## Prepare container
- Clone this repo
` git clone https://github.com/UnitybaseExplorer/liberator-cloud-run.git`

- Run Google Cloud Tools for PowerShell (Windows) & cd to cloned repo
`cd full/path-to-cloned-repo/liberator-cloud-run`

- Create project & artifacts repo, build & push container to it:
    - `$project_id="<PRIJECT_ID>"` (replace <PRIJECT_ID> with ID of the project created earlier)
    - `gcloud artifacts repositories create $project_id-repo --repository-format=docker --location=us-central1 --description="Docker $project_id repository"`
    - `docker build -t us-central1-docker.pkg.dev/$project_id/$project_id-repo/liberator:latest .`

- Test container
`docker run --rm -p 8080:8080 us-central1-docker.pkg.dev/$project_id/$project_id-repo/liberator`


## Deploy / redeploy container instances
- Deploy container instances
`for ($num = 0; $num -le 9; $num++) {gcloud run deploy liberator-service-$num --image us-central1-docker.pkg.dev/$project_id/$project_id-repo/liberator --region europe-west1 --project=$project_id --platform managed --allow-unauthenticated --quiet --min-instances 1 --max-instances=3 --cpu=1 --memory=1Gi}`

## Read logs
`for ($num = 0; $num -le 9; $num++) {Write-Host "liberator-service-$num status:"; gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=liberator-service-$num" --project $project_id --limit 10 --flatten textPayload --format=list}`