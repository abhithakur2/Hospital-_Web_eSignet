#!/bin/bash


# Function to install Terraform
function install_terraform {
    if ! command -v terraform &> /dev/null
    then
        echo "Installing Terraform with the latest version..."
        curl -LO "https://releases.hashicorp.com/terraform/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')/terraform_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')_linux_amd64.zip" || error_exit "Failed to download Terraform"
        unzip terraform_*.zip || error_exit "Failed to unzip Terraform"
        sudo mv terraform /usr/local/bin/ || error_exit "Failed to move Terraform to /usr/local/bin"
        rm terraform_*.zip || error_exit "Failed to remove Terraform zip file"
        echo "Terraform is installed successfully."
    else
        echo "Terraform is already installed."
    fi
}

# Function to verify Terraform installation
function verify_terraform {
    echo "Verifying Terraform installation..."
    terraform version || error_exit "Terraform is not installed correctly"
}

# Function to initialize Terraform
function initialize_terraform {
    echo "Initializing Terraform..."
    terraform init || error_exit "Failed to initialize Terraform"
}

# Function to check Terraform plan
function check_terraform_plan {
    echo "Checking Terraform plan..."
    terraform plan || error_exit "Terraform plan failed"
}

# Function to apply Terraform changes
function apply_terraform {
    read -p "Do you want to apply the Terraform plan? (Y/N): " APPLY
    if [[ "$APPLY" == "Y" || "$APPLY" == "y" ]]; then
        echo "Applying Terraform..."
        terraform apply -auto-approve || error_exit "Terraform apply failed"
    else
        echo "Terraform apply skipped."
    fi
}


