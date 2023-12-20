[myhosts]
%{ for ip in web_servers ~}
ubuntu@${ip} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
%{ endfor ~}
