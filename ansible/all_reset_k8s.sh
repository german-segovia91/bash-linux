ansible-playbook delete_k8s.yml --ask-become-pass;sleep 120
ansible-playbook ip_forward.yml --ask-become-pass;sleep 10
#ansible-playbook resetk8s.yml --ask-become-pass
