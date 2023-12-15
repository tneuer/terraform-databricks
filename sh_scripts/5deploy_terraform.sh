#!/usr/bin/env bash
terraform apply -var-file="./variables/dev.tfvars" -auto-approve;
