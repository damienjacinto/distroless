# distroless
Presentation distroless

gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable servicenetworking.googleapis.com

gcloud iam service-accounts create terraform

gcloud projects add-iam-policy-binding distroless --member serviceAccount:terraform@distroless.iam.gserviceaccount.com --role roles/compute.admin
gcloud projects add-iam-policy-binding distroless --member serviceAccount:terraform@distroless.iam.gserviceaccount.com --role roles/iam.serviceAccountUser
gcloud projects add-iam-policy-binding distroless --member serviceAccount:terraform@distroless.iam.gserviceaccount.com --role roles/resourcemanager.projectIamAdmin
gcloud projects add-iam-policy-binding distroless --member serviceAccount:terraform@distroless.iam.gserviceaccount.com --role roles/container.admin


