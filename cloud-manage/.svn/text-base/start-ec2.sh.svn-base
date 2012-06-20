#!/bin/sh

# Assumes ec2-tools are setup correctly

environment='';
hosttype='';
groups=(-g "SSH Access"); # Security groups, starts with default of SSH Access.
size='auto'; # Instance size, user specified
auto_size=''; # Instance size, if user specified auto
error=''; # Global for
userdatafile=''; # Gets set by output_userdata, generated based on options
ami=''; # Determined in check_size
# Note that these AMI's are region specific (east). Need additonal logic for west region
# TODO: Should probably not use EBS backed AMI's (mirror production)
ami_ebs_32='ami-8c1fece5'; # Default 32-bit AMI
ami_s3_32='ami-2a1fec43';
ami_ebs_64='ami-8e1fece7'; # Default 64-bit AMI
ami_s3_64='ami-221fec4b';
use_ami=''; # User specified AMI or figured out AMI as fallback
zone=''; # Currently restricted to east

function help() {
	echo "usage: $0 [-a AMI -t SIZE] -e ENVIRONMENT -h HOSTTYPE -z ZONE"
	echo "        AMI: AMI to use. If unspecified, uses ${ami_ebs_64} (64-bit) or ${ami_ebs_32} (32-bit)";
	echo "        ENVIRONMENT: dev, test, prod"
	echo "        HOSTTYPE: blogapptst, bloglvstst, etc"
	echo "        SIZE: Instance size. auto, t1.micro, m1.large, etc. Auto picks based on hosttype/env"
	echo "        ZONE: us-east-1a, us-east-1b, us-east-1c, us-east-1d"
}

# Exit on error
function error_exit() {
	if [ -n "${error}" ]; then
		echo "ERROR: ${error}";
		help;
		exit 1;
	fi
}

# The TEMP_FILE will be passed to ec2-run-instances as user data file
# The format requires CloudInit to be useful
function output_userdata() {
        TEMP_FILE=/tmp/userdata-$(uuidgen).sh
	cat > ${TEMP_FILE} <<EOD
#!
TEMP_FILE=/tmp/boot-\$(uuidgen).sh
curl -s -o \${TEMP_FILE} http://puppet.eng.compendiumblog.com/configure.sh
chmod +x \${TEMP_FILE}
mkdir -p /var/db/compendium
echo "${zone}" > /var/db/compendium/zone
exec \$TEMP_FILE -e ${environment} -h ${hosttype}
EOD
	userdatafile=$TEMP_FILE
}

# Validates host type specified by user
function check_hosttype() {
	host=$1;
        TEMP_FILE=/tmp/hosts-$(uuidgen).sh
        curl -s -o ${TEMP_FILE} http://puppet.eng.compendiumblog.com/app/host.registration/types?OutputType=sh 2>&1 > /dev/null
        source ${TEMP_FILE};
	rm -f $TEMP_FILE;

	if [ -n "${ERROR}" ]; then
		error=${ERROR};
		return
	fi
	for i in ${HOSTS}; do
		if [ $i == $host ]; then
			return;
		fi
	done
	error="Host not found. Valid hosts are ${HOSTS}";
	return;
}

# Validates specified instance size
function check_size() {
	sz=$1;
	case $sz in
		auto)
			echo "Going to determine instance size based on hosttype and environment";
			;;
		t1.micro)
			echo "Micro Instance: 64-bit, 613MB RAM, 1xCPU, EBS Only, \$0.02/hr";
			ami=$ami_ebs_64;
			;;
		m1.small)
			echo "Standard Small Instance: 32-bit, 1.7GB RAM, 1xCPU, 160GB disk, \$0.085/hr";
			ami=$ami_s3_32;
			;;
		m1.large)
			echo "Standard Large Instance: 64-bit, 7.5GB RAM, 4xCPU, 850GB disk, \$0.34/hr";
			ami=$ami_s3_64;
			;;
		m1.xlarge)
			echo "Standard XL Instance: 64-bit, 15GB RAM, 8xCPU, 1690GB disk, \$0.50/hr";
			ami=$ami_s3_64;
			;;
		m2.xlarge)
			echo "High-Mem XL Instance: 64-bit, 17GB RAM, 6xCPU, 420GB disk, \$0.50/hr";
			ami=$ami_s3_64;
			;;
		m2.2xlarge)
			echo "High-Mem Double XL Instance: 64-bit, 34GB RAM, 13xCPU, 850GB disk, \$1.00/hr";
			ami=$ami_s3_64;
			;;
		m2.4xlarge)
			echo "High-Mem Quad XL Instance: 64-bit, 68GB RAM, 26xCPU, 1690GB disk, \$2.00/hr";
			ami=$ami_s3_64;
			;;
		c1.medium)
			echo "High-CPU Medium Instance: 32-bit, 1.7GB RAM, 5xCPU, 350GB disk, \$0.17/hr";
			ami=$ami_s3_32;
			;;
		c1.xlarge)
			echo "High-CPU XL Instance: 64-bit, 7GB RAM, 20xCPU, 1690GB disk, \$0.68/hr"
			ami=$ami_s3_64;
			;;
		cc1.4xlarge)
			echo "Quadruple XL Instance: 64-bit, 23GB RAM, 33xCPU, 1690GB disk, \$1.60/hr"
			ami=$ami_s3_64;
			;;
		cg1.4xlarge)
			echo "Quadruple XL GPU Instance: 64-bit, 22GB RAM, 33xCPU, 2xGPU, 1690GB disk, \$2.10/hr";
			ami=$ami_s3_64;
			;;
		*)
			error="Invalid size specified. See EC2 documentation for valid values.";
			;;
	esac
	return;
}
function pick_size() {
	echo "Selecting instance size based on environment and hosttype";
	if [[ "${environment}" == "test" || "${environment}" == "dev" ]]; then
		size="t1.micro";
		return;
	fi
	case $hosttype in
		cldsqlsrv)
			size="c1.xlarge";
			;;
		cbcldsrv|mgmt)
			size="m1.small";
			;;
		cldsession)
			size="m1.large";
			;;
		*)
			size="c1.medium";
			;;
	esac
}

function check_zone() {
	az=$1;
	case $az in
		us-east-1a)
			;;
		us-east-1b)
			;;
		us-east-1c)
			;;
		us-east-1d)
			;;
		*)
			error="Invalid zone specified";
			return;
			;;
	esac
	if [ -z "$az" ]; then
		error="No zone specified";
		return;
	fi
	return;
}
function check_environment() {
	env=$1;
	case $env in
		prod)
			ssh_key="rightscale-EC2-US"
			;;
		dev)
			ssh_key="eng-testing"
			;;
		test)
			ssh_key="eng-testing"
			;;
		*)
			error="Invalid environment specified";
			return;
			;;
	esac
	if [ -z "$env" ]; then
		error="An environment must be specified";
		return;
	fi
	return;
}

while getopts "a:e:h:t:z:" opt; do
	case $opt in
		a)
			use_ami=$OPTARG;
			;;
		e)
			check_environment $OPTARG;
			error_exit
			environment=$OPTARG;
			;;
		h)
			check_hosttype $OPTARG;
			error_exit
			hosttype=$OPTARG;
			;;
		t)
			check_size $OPTARG;
			error_exit
			size=$OPTARG;
			;;
		z)
			check_zone $OPTARG;
			error_exit
			zone=$OPTARG;
			;;
		\?)
			help;
			exit 1;
			;;
	esac
done

if [ -z "${hosttype}" ]; then
	error="No host type specified with -h option";
elif [ -z "${environment}" ]; then
	error="No environment specified with -e option";
elif [ -z "${size}" ]; then
	error="No size specified with -s option";
fi
if [ -z "${zone}" ]; then
	error="No zone specified with -z option";
fi
error_exit

if [ "${size}" == "auto" ]; then
	pick_size
	check_size $size
fi
if [ -z "${size}" ]; then
	error="No size could be determined";
	error_exit
fi
error_exit

if [ -z "${use_ami}" ]; then
	use_ami=$ami;
fi
if [ -z "${use_ami}" ]; then
	error="No usable AMI found";
	error_exit
fi

output_userdata

# Do not change the array stuff, it's terrible
function append_groups() {
	for i in "$@"; do
		groups+=(-g "$i");
	done
}

# Security groups
case $hosttype in
	cldsession|prodsesssrv)
		append_groups "Bacula" "PrdSess" 'PrdGroup';
		;;
	cldsqlsrv|prodsqlsrv)
		append_groups "Bacula" "PrdSql" 'PrdGroup';
		;;
	prescldsrv|blogcldsrv|prodpressrv|prodblogsrv)
		append_groups "PrdApp" 'PrdGroup';
		;;
	cbcldsrv|prodcallsrv)
		append_groups "PrdCB" 'PrdGroup';
		;;
	cldlvssrv|prodproxysrv)
		append_groups 'PrdLB' 'PrdGroup';
		;;
	mgmt|prodmgmtsrv)
		append_groups 'PrdMgmt' 'Bacula' 'PrdGroup';
		;;
	cldlogsrv|prodlogsrv)
		append_groups 'PrdMgmt' 'PrdMail' 'PrdGroup' 'PrdLogging';
		;;
	solrcldsrv|prodsolrsrv)
		append_groups 'PrdSolr' 'PrdGroup';
		;;
	# Test Environment
	test)
		append_groups 'Bacula' 'TestGroup';
		;;
	cbtstsrv|testcallsrv)
		append_groups "Test CB" 'TestGroup';
		;;
	blogapptst|presapptst|testblogsrv|testpressrv)
		append_groups "Test Environment AppSrv" 'TestGroup';
		;;
	bloglvstst|testlvssrv|testproxysrv)
		append_groups "Test Environment LB" 'TestGroup';
		;;
	solrtstsrv|testsolrsrv)
		append_groups "Test Solr" 'TestGroup';
		;;
	blogsqltst|testsqlsrv)
		append_groups "Test Environment SQL" 'TestGroup';
		;;
	sesststsrv|testsesssrv)
		append_groups "Test Environment Session" 'TestGroup';
		;;
	*)
		echo "No security groups found for hosttype $hosttype. This requires changing this script. Exiting.";
		exit;
esac

ec2-run-instances \
	-z ${zone} \
	-k ${ssh_key} \
	-t ${size} \
	"${groups[@]}" \
	-f ${userdatafile} \
	${ami};
rm -f $userdatafile
