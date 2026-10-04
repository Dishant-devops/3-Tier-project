# ⛺ YelpCamp

YelpCamp is a full-stack web application where users can add, view, and rate campgrounds by location. Users can sign up, log in, upload campground images, and explore all campgrounds on an interactive cluster map.

The project is containerized with **Docker** and deployed on **AWS EKS**. The infrastructure is created with **Terraform**, and the whole build and deployment process is automated with **GitHub Actions**.

---

##  Technologies Used

**Application**
- Node.js and Express: web server
- Bootstrap: front-end design
- MongoDB Atlas: database
- Passport (local strategy): login and authentication
- Cloudinary: image storage
- Mapbox: cluster map
- Helmet: security

**DevOps**
- Terraform: creates the AWS infrastructure
- Docker and Docker Hub: container and image storage
- Kubernetes (Amazon EKS): runs the app
- GitHub Actions with OIDC: CI/CD pipeline
- Kubernetes Gateway API and Load Balancer: send user traffic to the app

---

##  How It Works

```
User → Load Balancer → Gateway → HTTPRoute → Kubernetes Service → App Pods (EKS)
```

- The app runs inside an **EKS cluster** placed in **private subnets**.
- The **Gateway API** (Gateway + HTTPRoute) decides how traffic is routed to the app.
- The **Load Balancer** is created automatically for the Gateway and sits in a **public subnet**.
- Terraform creates everything: VPC, public and private subnets, route tables, and the EKS cluster.

---

##  Project Structure

> Change the folder names to match your repository.

```
.
├── .github/workflows/   # GitHub Actions pipelines
├── 3-Tier-Full-Stack    # Main application file and Dockerfile
├── deployment/          # Kubernetes files (Deployment, Service, ConfigMap)
├── infra/               # Terraform code (modules for VPC and EKS)
└── README.md
```

---

##  Run the App Locally

### Step 1: Create accounts

You need free accounts on:
- [Cloudinary](https://cloudinary.com/)
- [Mapbox](https://www.mapbox.com/)
- [MongoDB Atlas](https://www.mongodb.com/atlas)

### Step 2: Create a `.env` file

Create a file named `.env` in the same folder as `app.js` and add:

```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_KEY=your_key
CLOUDINARY_SECRET=your_secret
MAPBOX_TOKEN=your_mapbox_token
DB_URL=your_mongodb_atlas_url
SECRET=any_secret_value
```

>  Do not upload the `.env` file to GitHub.

### Step 3: Build the Docker image

```bash
docker build -t yelpcamp .
```

### Step 4: Run the container

```bash
docker run -p 3000:3000 --env-file .env yelpcamp
```

Then open `http://localhost:3000` in your browser.

---

##  Infrastructure (Terraform)

Terraform is used in a **modular way**. Each part is kept in its own module.

| Module | What it creates |
|--------|-----------------|
| VPC | VPC, public subnets, private subnets, route tables |
| EKS | EKS cluster running in private subnets |

Commands:

```bash
cd infra
terraform init
terraform plan
terraform apply
```

---

##  CI/CD with GitHub Actions

The pipeline runs automatically when code is pushed. It does the following:

1. Logs in to AWS using **OIDC** (no AWS access keys needed)
2. Builds the Docker image
3. Pushes the image to **Docker Hub**
4. Deploys the app to the **EKS cluster**

### GitHub Secrets needed

| Secret | Use |
|--------|-----|
| `DOCKERHUB_USERNAME` | Docker Hub username |
| `DOCKERHUB_TOKEN` | Docker Hub access token |

---

##  Branching Strategy

```
dev  →  Pull Request  →  main
```

1. Push all changes to the **`dev`** branch first.
2. Create a **Pull Request** from `dev` to `main`.
3. After review, **merge** into `main`.

This keeps the `main` branch safe and stable.

---

## Kubernetes Files

| File | What it does |
|------|--------------|
| Deployment | Runs the app pods using the Docker Hub image |
| Service | Exposes the pods inside the cluster |
| ConfigMap | Stores app settings |
| Gateway | Entry point of the cluster, creates the Load Balancer |
| HTTPRoute | Routes incoming requests to the app Service |

```bash
kubectl apply -f k8s/
kubectl get pods
```

---

##  Deployment Steps (AWS)

Follow these steps in order.

**Step 1: Set up AWS access for GitHub (OIDC)**
- In AWS IAM, add GitHub as an OIDC identity provider.
- Create an IAM role that GitHub Actions can use, and copy its ARN.

**Step 2: Add GitHub Secrets**
- Go to *Repository → Settings → Secrets and variables → Actions*.
- Add `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`.

**Step 3: Create the infrastructure**
- Push your Terraform code to the `dev` branch.
- Create a Pull Request from `dev` to `main` and merge it.
- GitHub Actions (or `terraform apply`) creates the VPC, subnets, route tables, and EKS cluster.

**Step 4: Connect to the EKS cluster**

```bash
aws eks update-kubeconfig --region <your-region> --name <your-cluster-name>
kubectl get nodes
```

**Step 5: Build and push the Docker image**
- The pipeline does this automatically. To do it manually:

```bash
docker build -t <dockerhub-username>/yelpcamp:latest .
docker push <dockerhub-username>/yelpcamp:latest
```

**Step 6: Deploy the app on Kubernetes**

```bash
kubectl apply -f k8s/
kubectl get pods
kubectl get svc
```

**Step 7: Check the Gateway and HTTPRoute**

```bash
kubectl get gateway
kubectl get httproute
```

Wait until the Gateway shows an **ADDRESS** (this is the Load Balancer DNS name).

**Step 8: Open the app**
- Open `http://<gateway-address>` in your browser.

---

##  Cleanup

To avoid extra AWS charges, delete everything when you are done:

```bash
kubectl delete -f k8s/
cd infra
terraform destroy
```

---

