#!/bin/sh

# NAME:
#	irix.pkg.sh - optimistic wrapper for FreeBSD pkg command
#
# SYNOPSIS:
#	pkg [-v] [-d] [-l]	[-N]
#	 [-j <jail name	or id> | -c <chroot path> | -r <root directory>]
#	 [-C <configuration file>] [-R <repository configuration directory>]
#	 [-4 | -6] <command> <flags>
#
# DESCRIPTION:
#	Trys to be compatible with FreeBSD pkg.
#	Does not do "bootsrap" build from ports, as this point here is to avoid
#	new non IRIX tools and seperate DB being useed.
#       Returns 0 == ok
#	        1 == not ok
#	
#
# OPTIONS:
#	The following options are supported by pkg:
#
#     -v, --version
#	     Display the current version of pkg.
#
#     -d, --debug
#	     Show debug	information.
#
#     -l, --list
#	     List all the available command names.
#
#     -o	<option=value>,	--option <option=value>
#	     Set configuration option for pkg from the command line.
#
#     -N	     Activation	status check mode.
#
#     -j	<jail name or id>, --jail <jail	name or	id>
#
#     -c	<chroot	path>, --chroot	<chroot	path>
#
#     -r	<root directory>, --rootdir <root directory>
#
#     -C	<configuration file>, --config <configuration file>
#
#     -R	<repo conf dir>, --repo-conf-dir <repo conf dir>
#
#     -4	     pkg will use IPv4 for fetching repository and packages.
#
#     -6	     pkg will use IPv6 for fetching repository and packages.
#
# COMMANDS:
#     add     Install a package from either a local source or a remote one.
#
#     bootstrap This is for compatibility with the pkg(7) bootstrapper, ignore
#
#     create  Create a package.
#
#     delete  Delete a package from the database and the system.
#
#     info    Display information about installed packages and package files.
#
#     query   Query information about installed packages and package files.
#
#     register  Register a package in the database.
#
#     version Summarize installed versions of packages.
#
# BUGS:
#	Only tested on single IRIX 6.5.30 platform ...
#	
# AUTHOR:
#	John Hartley - zebity@yahoo.com
#
#	@(#) Copyright (c) John Hartley
#
#	This file is provided in the hope that it will
#	be of use.  There is absolutely NO WARRANTY.
#	Permission to copy, redistribute or otherwise
#	use this file is hereby granted provided that 
#	the above copyright notice and this notice are
#	left intact. 
#      
#	Please send copies of changes and bug-fixes to:
#	zebity@yahoo.com
#

set -- `getopt vdlNj:c:r:C:R:46 $*`

version=;
debug=no
list=;
options=;
activaton=;
jail=;
chroot=;
root=;
config=;
repo=;
ipv4=;
ipv6=;

# curl = `which ${CURL}`

if [ -f /usr/sbin/inst ]; then
	IRIX_INST=/usr/sbin/inst
else
	echo "IRIX '/usr/sbin/inst' missing, aborting!"
	return 1
fi

while :
do
        case "$1" in
        --)     shift; break;;
        -[46N])   ;; # ignore
	-v)	version=yes ;; 
        -d)     debug=yes ;;
        -l)     list=yes ;;
        -o)     options=${options} $2; shift;;
        -j)     jail=$2; shift;;
        -c)     chroot=$2; shift;;
	-r)	root=$2; shift;;
	-C)	config=$2; shift;;
	-R)	repo=$2; shift;;
	*)	break;;
	esac
	shift
done

if [ ${version} ]; then
	instver=`showprods -En eoe.sw.base | sed -e '/eoe\.sw\.base/!d;/eoe\.sw\.base/s/\(.*\)eoe\.sw\.base\( *\)\([0-9]*\)\( *\)\(.*\)/\3/;'`
	echo "${instver}"
	exit 0

fi

# a bug in HP-UX's /bin/sh, means we need to re-set $*
# after any calls to add_path()
args="$*"

# restore saved $*
set -- $args

if [ $# -gt 0 ]; then

	echo "pkg(IRIX) command: '$1'."

	case "$1" in
	register)	;;
	delete)	;;
	info)		;;
	version)	if [ $2 ] && [ $2 = "-t" ]; then
				echo "="
			else
				instver=`showprods -En eoe.sw.base | sed -e '/eoe\.sw\.base/!d;/eoe\.sw\.base/s/\(.*\)eoe\.sw\.base\( *\)\([0-9]*\)\( *\)\(.*\)/\3/;'`
				echo "pkg-${instver} ="
			fi
			;;
	create)		;;
	add)		;;
	query)		;;
	*)		echo "pkg (IRIX) unsupported command: '${1}'."
			exit 1
			;;
	esac

fi

exit 0 
