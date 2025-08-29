output "csf_dev_vm_ip" {
  description = "private ip address of CSF dev vm"
  value       = aws_instance.csf_dev_vm.private_ip
}

output "csf_dev_db_hostname" {
  description = "hostname of CSF dev db"
  value       = aws_db_instance.csf_dev_rds.address
}

output "jenkins_ssh_public_key" {
  value = data.external.jenkins_pubkey.result["pubkey"]
}
