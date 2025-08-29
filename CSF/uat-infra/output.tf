output "csf_uat_vm_ip" {
  description = "private ip address of CSF uat vm"
  value       = aws_instance.csf_uat_vm.private_ip
}

output "csf_uat_db_hostname" {
  description = "hostname of CSF uat db"
  value       = aws_db_instance.csf_uat_rds.address
}

output "jenkins_ssh_public_key" {
  value = data.external.jenkins_pubkey.result["pubkey"]
}
