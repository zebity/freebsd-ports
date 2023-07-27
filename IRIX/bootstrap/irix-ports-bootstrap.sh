#!/bin/sh -x

prefix="/usr/local2"
irix_mks="/share/ports/mk"
irix_wrappers="/irix-wrappers"
build_in="/tmp/ports"
cur_dir=`pwd`

delete=no

bmake_archive="http://www.crufty.net/ftp/pub/sjg/bmake.tar.gz"
bmake_tar=`basename ${bmake_archive}`
irix_port_mks="irix.port.mk irix.port.post.mk irix.port.pre.mk"
irix_wrappers_sh="irix.env.sh irix.fetch.sh irix.pkg.sh"

SGI_FREEWARE=/usr/freeware/bin
WGET=/usr/freeware/bin/wget
GZCAT="gzcat"
TAR=/usr/freeware/bin/tar

# echo "args: $*"

if [ $# -eq 0 ]; then
	echo "Usage: '${0} -d -b /build/dir prefix=/install/dir'."
else

	if [ ! -d "${SGI_FREEWARE}" ] || [ ! -f `which ${GZCAT}` ]; then
		echo "Error: assumes SGI Freeware & gzcat are avalible."
		exit 1
	fi

	while :
	do
#		echo "arg: '${1}'."
		case "$1" in
			-d) delete=yes ;;
			-b) build_in=$2 ; shift ;;
			--) shift; break;;
			*) break;;
		esac
		shift 
	done

	if [[ $# = 1 ]] && [[ "$1" = prefix=/* ]]; then

		prefix_dir=${1#prefix=}

		mkdir -p ${build_in}
		cd ${build_in}
		if [ -f ${bmake_tar} ]; then
			rm ${bmake_tar}
		fi
		${WGET} ${bmake_archive}
		${GZCAT} ${bmake_tar} | ${TAR} -xvf -
		cd bmake
		./configure CC=c99 CFLAGS="-64 -mips4 -O2" LDFLAGS="-64 -mips4" ${1}
		sh ./make-bootstrap.sh
		make install

		if [ "${delete}" = "yes" ]; then
			cd ..
			rm ${bmake_tar}
			rm -rf bmake
		fi

		cd ${cur_dir}

		if [ -d ${prefix_dir} ]; then

			mkdir -p ${prefix_dir}/share/ports/mk
			cp ..${irix_mks}/*.mk ${prefix_dir}${irix_mks}
			cd ${prefix_dir}/share/mk
			for f in ${irix_port_mks}
			do
				ln -s ../ports/mk/${f} ${f}
			done

			cd ${cur_dir}
			cp ..${irix_wrappers}/*.sh ${prefix_dir}/bin
			cd ${prefix_dir}/bin
			for f in ${irix_wrappers_sh}
			do
				x=${f#irix.}
				x=${x%.sh}
				ln -s ${f} ${x} 
			done
			cd ${cur_dir}
		else
			echo "Error: failed to create directory - '${prefix_dir}'."
		fi
	else
		echo "Usage: '${0} -b /build/dir prefix=/install/dir'."
	fi
fi
