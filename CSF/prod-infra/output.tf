output "csf_prod_vm_ip" {
  description = "private ip address of CSF prod vm"
  value       = aws_instance.csf_prod_vm.private_ip
}

output "csf_prod_db_hostname" {
  description = "hostname of CSF prod db"
  value       = aws_db_instance.csf_prod_db.address
}

output "jenkins_ssh_public_key" {
  value = data.external.jenkins_pubkey.result["pubkey"]
}
