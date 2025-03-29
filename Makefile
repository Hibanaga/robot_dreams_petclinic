up:
	vagrant up
reload:
	vagrant reload
reload-provision:
	vagrant reload --provision
destroy:
	vagrant destroy -f && rm -rf extra_disk.vdi