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

# DEBUG
# echo "Env args>>"
# echo "env: ""${@}"
# echo "Env args."
# echo "Env # args: '$#'."

IRIX_ENV=/sbin/env

if [ $# -eq 0 ]; then
	${IRIX_ENV}
else


	output=;
	inherit=;
	user=;
	class=;
	altpath=;
	string=;
	name=;
	verbose=no;
	extraverbose=no;

	set -A savargs
	set -A keepargs
	let "i=0"
	let "j=0"
	let "k=0"

	for a in "${@}"
	do
		savargs[${i}]="${a}"
#		echo "DBG>> $0 - arg[${i}]: '${a}'."
		let "i=i + 1"
	done

	# echo ${savargs[@]}

	# just to check for valid options, don't change the actual input arguments
	# set -- `getopt 0iL:U:P:S:u:v $*`
	# echo "Env # args: '${#}'."

	argsz=${i};

	while [ ${j} -lt ${argsz} ]
	do
		flag=`echo "${savargs[${j}]}" | cut -b 1`

		if [ "${flag}" != "-" ]; then
			break;
		elif [ "${savargs[${j}]}" = "-0" ]; then
			output=null
		elif [ "${savargs[${j}]}" = "-i" ]; then
			inherit="-i"
		elif [ "${savargs[${j}]}" =  "-L" ]; then
			let "j=j + 1" 
			class=${savargs[${j}]}
		elif [ "${savargs[${j}]}" = "-U" ]; then
			let "j=j + 1" 
			user=${savargs[${j}]}
		elif [ "${savargs[${j}]}" = "-P" ]; then
			let "j=j + 1" 
			altpath=${savargs[${j}]}
		elif [ "${savargs[${j}]}" = "-S" ]; then
			let "j=j + 1" 
			string="${savargs[${j}]}"
		elif [ "${savargs[${j}]}" = "-u" ]; then
			let "j=j + 1" 
			name=${savarg[${j}]}
		elif [ "${savargs[${j}]}" = "-v" ]; then
			if [ "${verbase}" = "no" ]; then
				verbose=yes
			else
				extraverbose=yes
			fi
		elif [ `echo "${savargs[${j}]}" | grep '^-L\(+*\)$'` ]; then
			class=${savargs[${j}]#-L}
		elif [ `echo "${savargs[${j}]}" | grep '^-U\(+*\)$'` ]; then
			user=${savargs[${j}]#-U}
		elif [ `echo "${savargs[${j}]}" | grep '^-P\(+*\)$'` ]; then
			altpath=${savargs[${j}]#-P}
		elif [ `echo "${savargs[${j}]}" | grep '^-S\(+*\)$'` ]; then
			string="${savargs[${j}]#-S}"
		elif [ `echo "${savargs[${j}]}" | grep '^-u\(+*\)$'` ]; then
			name=${savagrs[${j}]#-S}
		else
			break;
		fi
		let "j=j + 1" 
	done

	let "keepsz=${#savargs[@]} - j"

	while [ ${k} -lt ${keepsz} ]
	do
#		keepargs[${k}]="\"${savargs[${j}]}\""
		keepargs[${k}]="${savargs[${j}]}"
		let "j=j + 1" 
		let "k=k + 1" 
	done
 
	# echo "Env after setop: # keepargs: ${#keepargs[@]}"
	# echo "Env keepargs: '" "${keepargs[@]}" "'."

	if [ "${string}" ] || [ "${user}" ] || [ "${class}" ]; then

		if [ "${string}" ]; then
			# echo "Expand: '${string}'."
			SARGS="${string}"
		fi
# TODO		if [ "${user}" ]; then
#			echo "User Lookup: '${user}'."
#		fi
#		if [ "${class}" ]; then
#			echo "Login Class Lookup: '${class}'."
#		fi

		# echo "env: " "$*"

		${IRIX_ENV} ${inherit} ${SARGS} "${keepargs[@]}"
	else

# DEBUG
#		i=0
#		for a in "${keepargs[@]}"
#		do
#			echo "DBG>> $0 - arg[${i}]: '${a}'."
#			let "i=i + 1"
#		done
#
		echo "DBG>> '""${IRIX_ENV}" "${inherit}" "${keepargs[@]}" "'."

		${IRIX_ENV} ${inherit} "${keepargs[@]}"
	fi

fi
