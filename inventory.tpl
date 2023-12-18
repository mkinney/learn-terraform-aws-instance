[myhosts]
%{ for ip in app_servers ~}
ubuntu@${ip}
%{ endfor ~}
