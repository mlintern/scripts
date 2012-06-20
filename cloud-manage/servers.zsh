# Only works with ZSH, uses zmodload zsh/regex module
servs() { grep "$*" ~/Documents/servers.csv }
servhostname() { grep "$*" ~/Documents/servers.csv | tail -1 | awk -F, '{print $1}' }
servconnect() {
        zmodload zsh/regex
        server=`servs $* | tail -1 | awk -F, '{print $2}'`
        hostname=`servhostname ${server}`
        if [[ "${hostname}" -regex-match ^(prod|test).*$ ]]; then
                ssh_user=ec2-user
        else    
                ssh_user=root
        fi      
        echo "Connecting to ${ssh_user}@$server"
        ssh ${ssh_user}@${server}
}
