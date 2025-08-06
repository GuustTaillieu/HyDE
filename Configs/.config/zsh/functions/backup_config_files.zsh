function backup_configs {
	pushd $HOME/HyDE/Scripts/ > /dev/null
	sh $HOME/HyDE/Scripts/sync_configs.sh
	popd > /dev/null
}
