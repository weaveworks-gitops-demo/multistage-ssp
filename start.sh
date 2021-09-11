ssh-keygen -t rsa -C "weaveworks.workshop" -f "./key.pem" -q -N ""
ssh-keyscan -H github.com > ./known_hosts