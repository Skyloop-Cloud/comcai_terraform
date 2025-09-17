# Comcai Terraform Şablonu

Modern web uygulaması için tam AWS altyapısı. Görseldeki mimariye uygun olarak tasarlanmıştır.

## 🏗️ Mimari Bileşenleri

### **API Gateway** → **ALB** → **ECS** → **ElastiCache Redis**
### **S3** (Dosya Depolama) + **ECR** (Container Registry)

## 📁 Dosya Yapısı

```
Comcai/
├── main.tf              # Ana dosya - modülleri çağırır
├── provider.tf          # AWS provider tanımı
├── variables.tf         # Değişkenler
├── outputs.tf           # Çıktılar
└── modules/
    ├── api_gateway/     # API Gateway modülü
    ├── vpc/             # VPC modülü (public/private subnets, NAT)
    ├── alb/             # Application Load Balancer
    ├── ecs/             # Elastic Container Service
    ├── ecr/             # Elastic Container Registry
    ├── s3/              # S3 bucket
    └── elasticache/     # ElastiCache Redis
```

## 🔧 AWS Servisleri

### **1. API Gateway**
- REST API endpoint
- Lambda proxy integration
- Regional deployment

### **2. VPC (Virtual Private Cloud)**
- **Public Subnets**: ALB ve NAT Gateway için
- **Private Subnets**: ECS ve ElastiCache için
- **NAT Gateway**: Private subnet'lerin internet erişimi
- **Security Groups**: Her servis için ayrı güvenlik

### **3. ALB (Application Load Balancer)**
- Public subnet'lerde
- ECS service'e trafik yönlendirme
- Health check endpoint: `/health`

### **4. ECS (Elastic Container Service)**
- **Fargate** launch type
- Private subnet'lerde
- 2 task instance
- S3 ve Redis'e erişim

### **5. ECR (Elastic Container Registry)**
- Container image repository
- Lifecycle policy (10 image sakla)
- Image scanning enabled

### **6. S3 (Simple Storage Service)**
- Application file storage
- Versioning enabled
- Lifecycle policy (90 gün)
- CORS configuration

### **7. ElastiCache Redis**
- **Multi-AZ** enabled
- **Automatic failover**
- **Encryption** at rest ve transit
- Private subnet'lerde

## 🌐 Network Yapısı

```
Internet
    ↓
API Gateway
    ↓
ALB (Public Subnet)
    ↓
ECS Tasks (Private Subnet)
    ↓
ElastiCache Redis (Private Subnet)
    ↓
S3 (VPC dışı)
```

## 📊 VPC CIDR Yapısı

- **VPC**: `10.0.0.0/16`
- **Public Subnets**: 
  - `10.0.1.0/24` (eu-central-1a)
  - `10.0.2.0/24` (eu-central-1b)
- **Private Subnets**:
  - `10.0.10.0/24` (eu-central-1a)
  - `10.0.20.0/24` (eu-central-1b)

## 🔐 Security Groups

### **ALB Security Group**
- Port 80, 443 (HTTP/HTTPS) - Internet'ten
- Port 80, 443 - ECS'e

### **ECS Security Group**
- Port 80, 443 - ALB'den
- Port 6379 - Redis'e

### **ElastiCache Security Group**
- Port 6379 - ECS'den

## 🚀 Kullanım

### 1. AWS Credentials
```bash
export AWS_PROFILE=develop
```

### 2. Terraform Komutları
```bash
cd Comcai/

# İlk kurulum
terraform init

# Plan oluştur
terraform plan

# Uygula
terraform apply

# Sil
terraform destroy
```

### 3. Container Image Push
```bash
# ECR'ye login
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin <ECR_URI>

# Image build
docker build -t comcai .

# Tag
docker tag comcai:latest <ECR_URI>:latest

# Push
docker push <ECR_URI>:latest
```

## 📋 Environment Variables

ECS container'ında şu environment variable'lar mevcut:
- `REDIS_ENDPOINT`: Redis connection string
- `S3_BUCKET`: S3 bucket name
- `ENVIRONMENT`: dev/staging/prod

## 🔍 Monitoring

- **CloudWatch Logs**: ECS task logs
- **ALB Access Logs**: HTTP request logs
- **ElastiCache Metrics**: Redis performance
- **API Gateway Logs**: API request logs

## 💰 Maliyet Optimizasyonu

- **ECS Fargate**: t2.micro equivalent
- **ElastiCache**: cache.t3.micro
- **S3**: Lifecycle policy ile maliyet düşürme
- **NAT Gateway**: Sadece 1 instance

## 🛡️ Güvenlik

- **Private subnets**: ECS ve Redis
- **Security groups**: Minimal erişim
- **Encryption**: S3, ElastiCache, ECR
- **VPC**: Network isolation
- **IAM roles**: Least privilege

## 📈 Scaling

- **ECS**: Auto scaling (desired_count = 2)
- **ALB**: Multi-AZ deployment
- **ElastiCache**: Multi-AZ with failover
- **S3**: Unlimited storage

## 🔧 Troubleshooting

### ECS Task Başlamıyor
```bash
# CloudWatch logs kontrol et
aws logs describe-log-groups --log-group-name-prefix "/ecs/comcai"

# ECS service durumu
aws ecs describe-services --cluster comcai-cluster --services comcai-service
```

### ALB Health Check Failed
```bash
# Target group health
aws elbv2 describe-target-health --target-group-arn <TARGET_GROUP_ARN>
```

### Redis Bağlantı Sorunu
```bash
# Redis endpoint kontrol
aws elasticache describe-replication-groups --replication-group-id comcai-redis
```

## 📝 Notlar

- Tüm kaynaklar `comcai` prefix'i ile oluşturulur
- Environment: `dev` (variables.tf'de değiştirilebilir)
- Region: `eu-central-1` (Frankfurt)
- Multi-AZ deployment için 2 availability zone kullanılır


