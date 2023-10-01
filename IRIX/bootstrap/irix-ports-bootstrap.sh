#!/bin/sh -x

prefix="/usr/local2"
irix_mks="/share/ports/mk"
irix_wrappers="/irix-wrappers"
build_in="/tmp/ports"
cur_dir=`pwd`

delete=no
loc_archive=
boot_bmake=no
boot_dialog=no
boot_ncurses=no


bmake_archive="http://www.crufty.net/ftp/pub/sjg/bmake.tar.gz"
bmake_taz=`basename ${bmake_archive}`

ncurses_archive=https://invisible-island.net/archives/ncurses/ncurses-6.4.tar.gz
ncurses_taz=`basename ${ncurses_archive}`

dialog_archive=https://invisible-island.net/archives/dialog/dialog.tar.gz
dialog_taz=`basename ${dialog_archive}`

irix_port_mks="irix.port.mk irix.port.post.mk irix.port.pre.mk"
irix_wrappers_sh="irix.env.sh irix.fetch.sh irix.pkg.sh"

SGI_FREEWARE=/usr/freeware/bin
WGET=/usr/freeware/bin/wget
GZCAT="gzcat"
TAR=/usr/freeware/bin/tar

# echo "args: $*"

if [ $# -eq 0 ]; then
	echo "Usage: '${0} [-c] [-m] [-d] [-n] -b /build/dir [-a /archive/local] prefix=/install/dir'."
else

	if [ ! -d "${SGI_FREEWARE}" ] || [ ! -f `which ${GZCAT}` ]; then
		echo "Error: assumes SGI Freeware & gzcat are avalible."
		exit 1
	fi

	while :
	do
#		echo "arg: '${1}'."
		case "$1" in
			-c) delete=yes ;;
			-m) boot_bmake=yes ;;
			-n) boot_ncurses=yes ;;
			-d) boot_dialog=yes ;;
			-b) build_in=$2 ; shift ;;
			-a) loc_archive=$2 ; shift ;;
			--) shift; break;;
			*) break;;
		esac
		shift 
	done

	if [[ $# = 1 ]] && [[ "$1" = prefix=/* ]]; then

		prefix_dir=${1#prefix=}
		mkdir -p ${build_in}

		#
		# get & build bmake
		#
		if [ ${boot_bmake} = "yes" ]; then
			( cd ${build_in}
				if [ -f ${bmake_taz} ]; then
					rm ${bmake_taz}
				fi
				${WGET} ${bmake_archive}
				if [ ! -e ${bmake_taz} ]; then
					cp ${loc_archive}/${bmake_taz} .
					if [  $? = 0 ]; then
						echo "Info: found '${bmake_taz}' in local archive." 
					else
						echo "Error: Unable to find or get '${bmake_taz}'."
						exit 1 
					fi
				fi 
				${GZCAT} ${bmake_taz} | ${TAR} -xvf -
				( cd bmake
					./configure CC=c99 CFLAGS="-64 -mips4 -O2" LDFLAGS="-64 -mips4" prefix=${prefix_dir} 
					sh ./make-bootstrap.sh
					make install
				)
				if [ $? != 0 ]; then
					echo "Error: bmake build returned failure code, aborting."
					exit 1
				fi
			)
			if [ -d ${prefix_dir} ]; then

				mkdir -p ${prefix_dir}/share/ports/mk
				cp ..${irix_mks}/*.mk ${prefix_dir}${irix_mks}
				( cd ${prefix_dir}/share/mk
					for f in ${irix_port_mks}
					do
						ln -s ../ports/mk/${f} ${f}
					done
				)

				cp ..${irix_wrappers}/*.sh ${prefix_dir}/bin
				( cd ${prefix_dir}/bin
					for f in ${irix_wrappers_sh}
					do
						x=${f#irix.}
						x=${x%.sh}
						ln -s ${f} ${x} 
					done
				)
			else
				echo "Error: failed to create directory - '${prefix_dir}'."
			fi
		fi

		#
		# get & build ncurses
		#
		if [ ${boot_ncurses} = "yes" ]; then

			( cd ${build_in}
				if [ -f ${ncurses_taz} ]; then
					rm ${ncurses_taz}
				fi
				${WGET} ${ncurses_archive}
				if [ ! -e ${ncurses_taz} ]; then
					cp ${loc_archive}/${ncurses_taz} .
					if [ $? = 0 ]; then
						echo "Info: found '${ncurses_taz}' in local archive." 
					else
						echo "Error: Unable to find or get '${ncurses_taz}'."
						exit 1 
					fi
				fi 
				${GZCAT} ${ncurses_taz} | ${TAR} -xvf -
				ncurses_dir=ncurses-6.4
				( cd ${ncurses_dir}
					./configure CC=c99 CFLAGS="-64 -mips4 -O2" LDFLAGS="-64 -mips4" CXX=CC CXXFLAGS="-64 -mips4 -LANG:std" --without-debug --prefix=${prefix_dir} 
					make
					make install
				)
#				if [ $? != 0 ]; then
#					echo "Error: ncurses build returned failure code, aborting."
#					exit 1
#				fi

			)
		fi

		#
		# get & build dialog
		#
		if [ ${boot_dialog} = "yes" ]; then

			( cd ${build_in}
				if [ -f ${dialog_taz} ]; then
					rm ${dialog_taz}
				fi
				${WGET} ${dialog_archive}
				if [ ! -e ${dialog_taz} ]; then
					cp ${loc_archive}/${dialog_taz} .
					if [ $? = 0 ]; then
						echo "Info: found '${dialog_taz}' in local archive." 
					else
						echo "Error: Unable to find or get '${dialog_taz}'."
						exit 1 
					fi
				fi 
				${GZCAT} ${dialog_taz} | ${TAR} -xvf -
				dialog_dir=`ls | grep dialog- | cut -f1 -d" "`
				( cd ${dialog_dir}
					./configure CC=c99 CFLAGS="-64 -mips4 -O2" LDFLAGS="-64 -mips4" --with-ncurses --prefix=${prefix_dir} 
					${prefix_dir}/bin/bmake -f makefile 
					${prefix_dir}/bin/bmake -f makefile install-full
				)
#				if [ $? != 0 ]; then
#					echo "Error: dialog build returned failure code, aborting."
#					exit 1
#				fi

			)
		fi

		if [ ${delete} = "yes" ]; then
			rm -rf ${build_in}
		fi
	else
		echo "Usage: '${0} [-c] [-m] [-d] [-n] -b /build/dir prefix=/install/dir'."
	fi
fi
