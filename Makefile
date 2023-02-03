install:
	@apt update -y
	@apt install -y python3.9 pip gnupg software-properties-common terraform
	@pip3 install -r requirements.txt

test:
	@~/.local/bin/checkov --directory infrastructure/terraform

deploy:
	@terraform -chdir=infrastructure/terraform apply -auto-approve 