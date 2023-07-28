#!/bin/sh -x

# NAME:
#	irix.fetch.sh - optimistic wrapper for FreeBSD fetch command
#
# SYNOPSIS:
#	fetch [-146AadFlMmnPpqRrsUv] [-B bytes] [--bind-address=host]
#	   [--ca-cert=file] [--ca-path=dir] [--cert=file] [--crl=file]
#	   [-i file] [--key=file] [-N file] [--no-passive] [--no-proxy=list]
#	   [--no-sslv3]	[--no-tlsv1] [--no-verify-hostname] [--no-verify-peer]
#	   [-o file] [--referer=URL] [-S bytes]	[-T seconds]
#	   [--user-agent=agent-string] [-w seconds] URL	...
#
# DESCRIPTION:
#	Not Compatible with FreeBSD fetch, as this only handle http
#       Hence "optimistic", all requests will be passed to SGI freeware wget
#       Returns 0 == ok
#	        1 == not ok
#	
#
# OPTIONS:
#    The following options are available fpr fetch (but ignored):
#
#     -1, --one-file
#
#     -4, --ipv4-only
#
#     -6, --ipv6-only
#
#     -A, --no-redirect
#
#     -a, --retry
#
#     -B	bytes, --buffer-size=bytes
#
#     --bind-address=host
#
#     -c	dir	 The file to retrieve is in directory dir on the remote	host.
#
#     --ca-cert=file
#		 [SSL] Path to certificate bundle containing trusted CA	cer-
#		 tificates.
#
#     --ca-path=dir
#		 [SSL] The directory dir contains trusted CA hashes.
#
#     --cert=file
#		 [SSL] file is a PEM encoded client certificate/key which will
#		 be used in client certificate authentication.
#
#     --crl=file	 [SSL] Points to certificate revocation	list file, which has
#		 to be in PEM format and may contain peer certificates that
#		 have been revoked.
#
#     -d, --direct
#
#     -F, --force-restart
#
#     -f	file	 The file to retrieve is named file on the remote host.
#
#     -h	host	 The file to retrieve is located on the	host host.
#
#     -i	file, --if-modified-since=file
#
#     --key=file	 [SSL] file is a PEM encoded client key	that will be used in
#		 client	certificate authentication in case key and client cer-
#		 tificate are stored separately.
#
#     -l, --symlink
#
#     -M
#
#     -m, --mirror
#
#     -N	file, --netrc=file
#
#     -n, --no-mtime
#
#     --no-passive
#
#     --no-proxy=list
#
#     --no-sslv3	 [SSL] Do not allow SSL	version	3 when negotiating the connec-
#		 tion.
#
#     --no-tlsv1	 [SSL] Do not allow TLS	version	1 when negotiating the connec-
#
#     --no-verify-hostname
#
#     --no-verify-peer
#
#     -o	file, --output=file
#
#     -P
#
#     -p, --passive
#
#     --referer=URL
#
#     -q, --quiet
#
#     -R, --keep-output
#
#     -r, --restart
#
#     -S	bytes, --require-size=bytes
#
#     -s, --print-size
#
#     -T	seconds, --timeout=seconds
#
#     -U, --passive-portrange-default
#
#     --user-agent=agent-string
#
#     -v, --verbose
#
#     -w	seconds, --retry-delay=seconds
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

set -- `getopt 146AaB:c:dFf:h:i:lMmN:o:PpqRrS:sT:Uvw: $*`

bytes=;
one=no
dir=;
file=;
host=;
ifile=;
nfile=;
ofile=;
sbytes=;
seconds=;
wseconds=;

# curl = `which ${CURL}`

if [ -f /usr/freeware/bin/wget ]; then
	WGET=/usr/freeware/bin/wget
else
	return 1
fi

while :
do
        case "$1" in
        --)     shift; break;;
        -[46adFlMmnPpqRraUv])   ;; # ignore
	-1)	one=yes ;; 
        -B)     bytes=$2; shift;;
        -c)     dir=$2; shift;;
        -f)     file=$2; shift;;
        -h)     host=$2; shift;;
        -i)     ifile=$2; shift;;
	-N)	nfile=$2; shift;;
	-o)	ofile=$2; shift;;
	-S)	sbytes=$2; shift;;
	-T)	seconds=$2; shift;;
	-w)	wseconds=$2; shift;;
	*)	break;;
	esac
	shift
done

# a bug in HP-UX's /bin/sh, means we need to re-set $*
# after any calls to add_path()
args="$*"

# restore saved $*
set -- $args

# get list of files
files=
while [ $# -gt 0 ]
do
	files="$files $1"
	shift
done
# last one 
# file="$files $1"
# shift

# DBG echo "files: '${files}'"

for f in $files
do
	b=`basename $f`
	if [ -f $b ]; then
		echo "Skiping as file alread exists: '$b'."
	else
		https=`echo "${f}" | cut -b 1-6`
		http=`echo "${f}" | cut -b 1-5`
		if [ "${https}" = "https:" ]; then
			l=${#f}
		 	r=`echo "${f}" | cut -b 7-${l}`
			gf="http:"${r}
			echo "Changing to http: '${gf}'."
		elif [ "${http}" = "http:" ]; then
			gf=${f}
			echo "Get with http: '${gf}'."
		else
			gf="http://"${f}
			echo "Optimistic change to: '${gf}'."
		fi
		${WGET} ${gf}
		if [ $? -eq 0 ] && [ "${one}" = "yes" ]; then
			return 0
		fi
	fi
done
exit 0 
