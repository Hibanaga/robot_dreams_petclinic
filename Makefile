up:
	vagrant up
reload:
	make destroy && vagrant up
destroy:
	vagrant destroy -f && rm -rf extra_disk.vdi
ssh:
	vagrant ssh
status:
	vagrant global-status
