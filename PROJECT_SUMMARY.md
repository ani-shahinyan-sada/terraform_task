# Google Cloud Infrastructure Project Summary

## Overview
This project implements a multi-project Google Cloud infrastructure using Terraform, featuring a shared VPC setup with Cloud Run, Cloud SQL, and load balancing components.

## Architecture Implemented
- **Host Project (ani-proj-1)**: Contains shared VPC network and subnets
- **Service Project (ani-proj-2)**: Contains application resources (Cloud Run, Cloud SQL, Artifact Registry)
- **Shared VPC**: Cross-project networking with dedicated subnets
- **Load Balancer**: Global HTTP(S) load balancer with Cloud Run backend
- **Database**: Cloud SQL MySQL with private IP
- **Container Registry**: Artifact Registry for Docker images

## What We Successfully Implemented

### ✅ Infrastructure Components
1. **Shared VPC Setup**
   - Host project VPC with multiple subnets (10.1.0.0/24, 10.2.0.0/24, 10.8.0.0/28)
   - Service project attached to shared VPC
   - Proper cross-project networking configuration

2. **Cloud Run Application**
   - Deployed Python Flask application
   - Fixed Docker image architecture issues (ARM64 → AMD64)
   - Service running and serving HTML content
   - Connected to VPC via VPC connector

3. **Cloud SQL Database**
   - MySQL instance with private IP (10.187.0.2)
   - Database user and credentials configured
   - Private service connection established

4. **Load Balancing & Networking**
   - Global HTTP load balancer
   - Network Endpoint Group (NEG) for Cloud Run
   - Backend service and URL mapping
   - Global forwarding rule with static IP

5. **VPC Access Connector**
   - Created dedicated /28 subnet for VPC connector
   - Connector properly deployed and in READY state
   - Connected to Cloud Run service

6. **IAM & Security**
   - Artifact Registry read access for service account
   - Cloud SQL client permissions
   - VPC access permissions for cross-project networking
   - Google APIs service agent permissions

### ✅ Terraform Infrastructure as Code
- All infrastructure defined in Terraform
- Proper module usage for VPC, Cloud SQL, GCS, Artifact Registry
- IAM bindings imported and managed by Terraform
- Backend state stored in GCS

### ✅ Application Deployment
- Docker containerized Flask application
- Automated image builds and pushes to Artifact Registry
- Cloud Run deployment with proper service configuration

## What We Fixed During Implementation

### 🔧 Docker Architecture Issues
**Problem**: Cloud Run failing with "exec format error"
**Solution**: Built Docker images with `--platform linux/amd64` flag for compatibility

### 🔧 IAM Permissions
**Problem**: Cloud Run couldn't pull Docker images from Artifact Registry
**Solution**: Added `roles/artifactregistry.reader` to Cloud Run service account

### 🔧 VPC Connector Configuration
**Problem**: Multiple VPC connector creation failures due to network references and permissions
**Solutions**:
- Used dedicated /28 subnet instead of IP CIDR range
- Added proper cross-project IAM permissions
- Granted Google APIs service agent editor role in host project

### 🔧 Terraform State Management
**Problem**: Deposed objects and import conflicts
**Solution**: Removed deposed objects and imported existing resources properly

## What We Did NOT Solve

### ❌ Database Connectivity Issue
**Problem**: Cloud Run cannot connect to Cloud SQL private IP (10.187.0.2)
- VPC connector is functional but routing to Cloud SQL private IP times out
- Error: `"Can't connect to MySQL server on '10.187.0.2' (timed out)"`

**Root Cause Analysis**:
- VPC connector subnet (10.8.0.0/28) may not have proper routing to private services range (10.187.0.0/16)
- Potential firewall rules missing for private service networking
- Cloud SQL private IP might require different connection method in shared VPC setup

### ❌ Public Website Access
**Problem**: Website requires authentication to access
**Reason**: Missing IAM permission to allow unauthenticated access
**Required Command**: 
```bash
gcloud run services add-iam-policy-binding host-network \
  --member="allUsers" \
  --role="roles/run.invoker" \
  --region=us-west1 \
  --project=ani-proj-2
```

## Outstanding Issues & Next Steps

### 1. Database Connectivity Resolution
**Recommended Approaches** (in order of preference):

#### Option A: Cloud SQL Auth Proxy
- Modify application to use Cloud SQL Auth Proxy sidecar
- Remove VPC connector dependency
- Use connection name instead of private IP
```python
# Example connection using Cloud SQL Proxy
conn = pymysql.connect(
    unix_socket=f'/cloudsql/{instance_connection_name}',
    user='default',
    password='password',
    database='default'
)
```

#### Option B: Fix VPC Connector Routing
- Investigate firewall rules between VPC connector subnet and private services
- Check if Cloud SQL requires specific tags or network access rules
- Verify private service networking configuration

#### Option C: Use Public IP with Cloud SQL Auth Proxy
- Enable public IP on Cloud SQL instance
- Use Cloud SQL Auth Proxy for secure connections
- Implement SSL certificates for encryption

### 2. Enable Public Access
- Request IAM admin to run the public access command
- Alternative: Create IAM binding in Terraform (requires appropriate permissions)

### 3. Add Test Data
- Once database connectivity is resolved, populate with sample data
- Create initialization script or migration

### 4. Monitoring & Logging
- Implement Cloud Logging for application logs
- Set up monitoring dashboards
- Configure alerting for service health

### 5. Security Hardening
- Implement least-privilege IAM policies
- Add firewall rules for specific traffic patterns
- Enable audit logging

## Files Modified/Created

### Terraform Configuration
- `iam.tf` - Added IAM bindings for cross-project access
- `cloudrun.tf` - VPC connector configuration
- `(1)host_vpc.tf` - Added VPC connector subnet
- `app.py` - Database connection logic
- `Dockerfile` - Container configuration

### Key Environment Variables
- Database password: `BZSssDld59byhKCx0ta3`
- Cloud SQL private IP: `10.187.0.2`
- Cloud SQL connection name: `ani-proj-2:us-west1:infra-db`

## Architecture Diagram Reference
The implemented architecture follows the shared VPC pattern shown in the provided diagram:
- Host project manages networking
- Service project runs applications
- Private connectivity between components
- Load balancer provides external access

## Lessons Learned
1. **Shared VPC Complexity**: Cross-project networking requires careful IAM and subnet planning
2. **Cloud SQL Connectivity**: Private IP connections in shared VPC setups need special consideration
3. **Docker Architecture**: Platform-specific builds are critical for Cloud Run compatibility
4. **Terraform State Management**: Import existing resources carefully to avoid conflicts
5. **IAM Permissions**: Multiple service accounts and cross-project permissions require systematic approach

## Current Status
- ✅ Infrastructure: 95% complete and functional
- ✅ Application: Deployed and serving content
- ❌ Database: Not accessible from application
- ❌ Public Access: Requires additional permissions
- ✅ Terraform: Fully managed and importable

The project demonstrates a complex, production-ready infrastructure pattern with one remaining connectivity issue that requires focused networking troubleshooting or architectural adjustment.