
PKGNAME=TEST

EXTRACT_WRKDIR=work
EXTRACT_ONLY=irix-wrappers.tar
EXTRACT_CMD=/usr/freeware/bin/tar
EXTRACT_BEFORE_ARGS=-xf
_DISTDIR=..
EXTRACT_AFTER_ARGS=

MKDIR=mkdir -p
SETENV=/usr/local2/bin/env
fetch=/usr/local2/bin/fetch
MAKEr=-/usr/local2/bin/bmake

FLAVOR=
FETCH_FILES=frog
# _DEPEND_SPECIALS=
_DEPEND_SPECIALS="raspberry cherry"

.PHONY: fetch-specials fetch

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

_FLAVOR_RECURSIVE_SH= \
	if [ -z "$${recursive_cmd}" ]; then \
		${ECHO_MSG} "_FLAVOR_RECURSIVE_SH requires recursive_cmd to be set to the recursive make target to run." >&2; \
		${FALSE}; \
	fi; \
	if [ "$${recursive_dirs-null}" = "null" ]; then \
		${ECHO_MSG} "_FLAVOR_RECURSIVE_SH requires recursive_dirs to be set to the directories to recurse." >&2; \
		${FALSE}; \
	fi; \
	for dir in $${recursive_dirs}; do \
		unset flavor FLAVOR; \
		case $${dir} in \
			*@*/*) ;; \
			*@*) \
				flavor=$${dir\#*@}; \
				dir=$${dir%@*}; \
				;; \
		esac; \
		case $$dir in \
			/*) ;; \
			*) dir=${PORTSDIR}/$$dir ;; \
		esac; \
		echo "DBG>> _FLAVOR_RECURSIVE_SH: dir='${dir}' dddir='$$dir' ddbdir='$${dir}' ddbr_dir='$${recursive_dirs}' flavor='$$flavor' recursive_cmd='$${recursive_cmd}'." ; \
		(cd $$dir; ${SETENV} $${flavor:+FLAVOR=$${flavor}} ${MAKE} $${recursive_cmd}); \
	done

_FETCH_DEP=${FETCH_FILES}

# _FETCH_SEQ= 150:fetch-depends 300:pre-fetch 450:pre-fetch-script \
		500:do-fetch 550:fetch-specials 700:post-fetch \
		850:post-fetch-script \
		${_OPTIONS_fetch} ${_USES_fetch}

fetch-specials:
	@${ECHO_MSG} "===> Fetching all distfiles required by ${PKGNAME} for building"
	@recursive_cmd="fetch"; \
		recursive_dirs="${_DEPEND_SPECIALS}"; \
		echo "DBG>> fetch-specials - '${_DEPEND_SPECIALS}'" ; \
		${_FLAVOR_RECURSIVE_SH}

fetch: ${_FETCH_DEP} ${_FETCH_REAL_SEQ}
	echo "Gettting stuff ..."
	for t in $? \
	do \
		touch ${t}.got \
	done

${FETCH_FILES}.got:

# # .include <irix.port.mk>
