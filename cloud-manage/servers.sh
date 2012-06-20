set-prod() {
. ~/.ec2/production_account.sh
ssh-add $EC2_SSH_ID
}

set-test() {
. ~/.ec2/testing_account.sh
ssh-add $EC2_SSH_ID
}

servs() { 
grep "$*" $EC2_CURRENT_LIST
}
servlist() {
cat $EC2_CURRENT_LIST |awk -F, '{print $1 " " $2}'
}

#Fix this function so it doesn't depend on another file (sshconnect):
wservconnect() {
	server=`servs $* | tail -1 | awk -F, '{print $2}'`
	shortname=`servs $* | tail -1 | awk -F, '{print $1}' |sed "s/\..*//g"`
	tmux list-session 2>/dev/null |grep attached > /dev/null
	if [ $? -eq 0 ]; then
		tmux neww -n $shortname "sshconnect $server"
	else
		echo "No tmux session found"

	fi
	
}

servconnect() {
	server=`servs $* | tail -1 | awk -F, '{print $2}'`
	shortname=`servs $* | tail -1 | awk -F, '{print $1}' |sed "s/\..*//g"`
	tmux list-session 2>/dev/null |grep attached > /dev/null
	if [ $? -eq 0 ]; then
		tmux rename-window $shortname
		sshconnect $server
		tmux rename-window local
	else
		sshconnect $server
	fi
	
}

updatelist() {
	~/Projects/server-scripts/cloud-manage/servers.rb -a $EC2_ACCESS_KEY -s $EC2_SECRET_KEY -k $EC2_SSH_ID -o $EC2_CURRENT_LIST run
}
