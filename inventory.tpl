[myhosts]
%{ for ip in web_servers ~}
ubuntu@${ip}
%{ endfor ~}
