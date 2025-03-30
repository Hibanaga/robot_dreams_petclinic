# HM 6

# Make script executable

```
chmod +x ~/log_time.sh
```

Run manually

```
./log_time.sh
```

Get list cron jobs 
```
crontab -l
```

For latest task been created Makefile with combinated configuration of vagrant commans to avoid
```
The following error was experienced:

#<Vagrant::Errors::VBoxManageError:"There was an error while executing `VBoxManage`, a CLI used by Vagrant\nfor controlling VirtualBox. 
The command and stderr is shown below.\n\nCommand: [\"storagectl\", \"da41a7bb-95d9-40b6-98ca-4ef5c988341e\", \"--name\", \"SATA\", \"--add\", \"sata\", \"--controller\", \"IntelAHCI\"]\n\nStderr: 
VBoxManage: error: Storage controller named 'SATA' already exists\nVBoxManage: error: 
Details: code VBOX_E_OBJECT_IN_USE (0x80bb000c), component SessionMachine, interface IMachine, callee nsISupports\nVBoxManage: error: 
Context: \"AddStorageController(Bstr(pszCtl).raw(), StorageBus_SATA, ctl.asOutParam())\" at line 1090 of file VBoxManageStorageController.cpp\n">

Please fix this customization and try again.

```