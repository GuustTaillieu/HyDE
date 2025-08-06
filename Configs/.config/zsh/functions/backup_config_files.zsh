function backup_configs {
	pushd $HOME/HyDE/Scripts/ > /dev/null
	sh sync_configs.sh
	popd > /dev/null
}
