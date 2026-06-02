#!/bin/bash
set -e

# Visual colors for terminal confirmation output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}>>> Entering Core Infrastructure Directory...${NC}"
cd terraform/core

echo -e "${BLUE}>>> Initializing OpenTofu Plugins...${NC}"
tofu init

echo -e "${BLUE}>>> Launching Core Infrastructure Apply...${NC}"
tofu apply -auto-approve

echo -e "\n${GREEN}===============================================${NC}"
echo -e "${GREEN}       CORE VERIFICATION CHECKS                ${NC}"
echo -e "${GREEN}===============================================${NC}"

# Extract structural outputs directly from OpenTofu's state
STATUS=$(tofu output -raw core_status)
LB_IP=$(tofu output -raw load_balancer_ip)
DB_VOL=$(tofu output -raw volume_db_id)

echo -e "Deployment Status: ${GREEN}${STATUS}${NC}"
echo -e "Load Balancer IP:  ${GREEN}${LB_IP}${NC}"
echo -e "Database Volume:   ${GREEN}${DB_VOL}${NC}"
echo -e "==============================================="
echo -e "${BLUE}Next step: Run ./provision-app.sh to spin up compute hosts.${NC}"