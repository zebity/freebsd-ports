#!/bin/sh

# NAME:
#	irix.env.sh - wrapper for FreeBSD env command
#
# SYNOPSIS:
#     env [-0iv]	[-L|-U user[/class]] [-u name] [name=value ...]
#     env [-iv] [-L|-U user[/class]] [-P	altpath] [-S string] [-u name]
#	 [name=value ...] utility [argument ...]
#
# DESCRIPTION:
#	Trys to bne compatible with FreeBSD env
#       Returns 0 == ok
#	        1 == not ok
#	
#
# OPTIONS:
##     The options are as	follows:
#
#     -0     End each output line with NUL, not	newline.
#
#     -i     Execute the utility with only those environment variables speci-
#	     fied by name=value	options.  The environment inherited by env is
#	     ignored completely.
#
#     -L	| -U user[/class]
#	     Add the environment variable definitions from login.conf(5) for
#	     the specified user	and login class	to the environment, after pro-
#	     cessing any -i or -u options, but before processing any
#	     name=value	options.  If -L	is used, only the system-wide
#	     /etc/login.conf.db	file is	read; if -U is used, then the speci-
#	     fied user's ~/.login_conf is read as well.	 The user may be spec-
#	     ified by name or by uid.  If a username of	`-' is given, then no
#	     user lookup will be done, the login class will default to
#	     `default' if not explicitly given,	and no substitutions will be
#	     done on the values.
#
#     -P	altpath
#	     Search the	set of directories as specified	by altpath to locate
#	     the specified utility program, instead of using the value of the
#	     PATH environment variable.
#
#     -S	string
#	     Split apart the given string into multiple	strings, and process
#	     each of the resulting strings as separate arguments to the	env
#	     utility.  The -S option recognizes	some special character escape
#	     sequences and also	supports environment-variable substitution, as
#	     described below.
#
#     -u	name
#	     If	the environment	variable name is in the	environment, then re-
#	     move it before processing the remaining options.  This is similar
#	     to	the unset command in sh(1).  The value for name	must not in-
#	     clude the `=' character.
#
#     -v	Print verbose information, extra with -v -v
#
# BUGS:
#	Not tested ...
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

echo "Env args: '$*'"

IRIX_ENV=/sbin/env

if [ $* -eq 1 ]; then
	${IRIX_ENV}
else

	savargs="$*"

	set -- `getopt 0iL:U:P:S:u:v $*`

	output=:
	inherit=;
	user=;
	class=;
	altpath=;
	string=;
	name=;
	verbose=no;
	extraverbose=no;
	space=" "

	while :
	do
       	 case "$1" in
       	 --)     shift; break;;
		-0)	output=null ;; 
       	 -i)     inherit="-i" ;;
       	 -L)     class=$2; shift;;
       	 -U)     user=$2; shift;;
       	 -P)     altpath=$2; shift;;
       	 -S)     string=$2; shift;;
	 -u)	name=$2; shift;;
	 -v)	if [ ${verbose} = "no" ]; then
			verbose=yes
		else
			extraverbaose=yes
		fi
		;;
	 *)	break;;
	 esac
	 shift
	done

	if [ ${string} ] || [ ${user} ] || [ ${class} ]; then
		
 
		if [ "${string}" ]; then
			echo "Expand: '${string}'."
		fi
		if [ "${user}" ]; then
			echo "User Lookup: '${user}'."
		fi
		if [ "${class}" ]; then
			echo "Login Class Lookup: '${class}'."
		fi

		# a bug in HP-UX's /bin/sh, means we need to re-set $*
		# after any calls to add_path()
		args="$*"

		# restore saved $*
		set -- $args

		namval=
		utility=

		while :
		do
			echo "namval: %%'$1'%%"
			nam=`echo "$1" | cut -s -d= -f1`
			if [ "$nam" ]; then
				namval="${namval}""${space}""$1"
				shift
			else
				utility="$1"
				shift
				break;
			fi
		done;


		echo "env: ${inherit} ${namval} ${utility} $*"

		${IRIX_ENV} ${inherit} ${namval} ${utility} $*
	else

		${IRIX_ENV} "${savargs}"
	fi

fi
