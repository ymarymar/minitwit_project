#!/bin/bash
set -e

# Visual formatting colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Step 1: Deploying Compute Infrastructure (App Layer) ===${NC}"
cd terraform/app
tofu init
tofu apply -auto-approve

echo -e "\n${YELLOW}=== Step 2: Giving DigitalOcean 15 seconds to index droplet tags... ===${NC}"
sleep 15

echo -e "\n${BLUE}=== Step 3: Moving to Ansible space ===${NC}"
cd ../../ansible

echo -e "${BLUE}>>> Confirming Dynamic Inventory is reading live cloud state...${NC}"
ansible-inventory -i inventory.digitalocean.yml --graph

echo -e "\n${BLUE}>>> Waiting for SSH daemons to fully wake up on Droplets...${NC}"
ansible -i inventory.digitalocean.yml all -m wait_for_connection --timeout=120

echo -e "\n${GREEN}=== Step 4: Launching Main Deployment Playbook ===${NC}"
ansible-playbook -i inventory.digitalocean.yml site.yml