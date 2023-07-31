
EXTRACT_WRKDIR=work
EXTRACT_ONLY=irix-wrappers.tar
EXTRACT_CMD=/usr/freeware/bin/tar
EXTRACT_BEFORE_ARGS=-xf
_DISTDIR=..
EXTRACT_AFTER_ARGS=

MKDIR=mkdir -p

do-fetch:
	/usr/local2/bin/env dp_DISABLE_SIZE='' dp_DISTDIR='/usr/ports/distfiles/' dp_DISTINFO_FILE='/usr/ports/ports-mgmt/dialog4ports/distinfo' dp_DIST_SUBDIR='' dp_ECHO_MSG='echo' dp_FETCH_AFTER_ARGS='' dp_FETCH_BEFORE_ARGS='' dp_FETCH_CMD='/usr/local2/bin/fetch -Fpr' dp_FETCH_ENV=SSL_NO_VERIFY_PEER=1\ SSL_NO_VERIFY_HOSTNAME=1 dp_FORCE_FETCH_ALL='' dp_FORCE_FETCH_LIST='' dp_MASTER_SITE_BACKUP='http://distcache.FreeBSD.org/ports-distfiles/' dp_MASTER_SITE_OVERRIDE='' dp_MASTER_SORT_AWK='BEGIN { RS = " "; ORS = " "; IGNORECASE = 1 ; gl = "://[^/]*/"; } /:\/\/[^\/]*\// { good["://[^/]*/"] = good["://[^/]*/"] " " $0 ; next; } { rest = rest " " $0; } END { n=split(gl, gla); for(i=1;i<=n;i++) { print good[gla[i]]; } print rest; }' dp_NO_CHECKSUM='' dp_RANDOMIZE_SITES='' dp_SCRIPTSDIR='/usr/ports/Mk/Scripts' dp_TARGET='do-fetch' dp_DEVELOPER= _MASTER_SITES_DEFAULT=https://files.etoilebsd.net/dialog4ports/\ http://mirror.shatow.net/freebsd/dialog4ports/ dp_SITE_FLAVOR=MASTER /bin/sh /usr/ports/Mk/Scripts/irix.do-fetch.sh 'dialog4ports-0.1.6.tar.gz'

_PORTS_DIRECTORIES+=    ${PKG_DBDIR} ${PREFIX} ${WRKDIR} ${EXTRACT_WRKDIR} \
                                                ${STAGEDIR}${PREFIX} ${WRKDIR}/pkg ${BINARY_LINKDIR} \
                                                ${PKGCONFIG_LINKDIR}

do-extract: ${EXTRACT_WRKDIR}
	@for file in ${EXTRACT_ONLY}; do \
	echo "DBG>> do-extract: file='${file}' dollarsfile='$$file' workdir='${EXTRACT_WRKDIR}' cmd='${EXTRACT_CMD}' before='${EXTRACT_BEFORE_ARGS}' distfile='${_DISTDIR}/$$file' after='${EXTRACT_AFTER_ARGS}'."; \
	if ! ( cd ${EXTRACT_WRKDIR} && ${EXTRACT_CMD} ${EXTRACT_BEFORE_ARGS} ${_DISTDIR}/$$file ${EXTRACT_AFTER_ARGS} ); \
	then \
		${ECHO_MSG} "===>  Failed to extract \"${_DISTDIR}/$$file\"."; \
		exit 1; \
	fi; \
	done

${_PORTS_DIRECTORIES}:
	${MKDIR} ${.TARGET}


# # .include <irix.port.mk>
