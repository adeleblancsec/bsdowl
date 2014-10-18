### bps.man.mk -- Install manual pages

# Auteur: Michael Grünewald
# Date: Sat Oct 18 11:35:50 CEST 2014

# BSD Owl Scripts (https://bitbucket.org/michipili/bsdowl)
# This file is part of BSD Owl Scripts
#
# Copyright © 2005–2014 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt


### SYNOPSIS

# .include "bps.man.mk"


### DESCRIPTION

### VARIABLES

# DESTDIR [not set]
#  Change the tree where the manual pages get installed.
#
# MAN [not set]
#  Manual pages to be installed.
#
# MANDIR [${SHAREDIR}/man/man]
#  Base path for manual installation.
#
# MANOWN [${SHAREOWN}]
#  Manual owner.
#
# MANGRP [${SHAREGRP}]
#  Manual group.
#
# MANMODE [${SHAREMODE}]
#  Manual mode.
#
# MANSECTIONS [1 2 3 4 5 6 7 8 9 n l]
#  Manual sections.
#
# MANFILTER [not set]
#  Filter processing raw man pages before compressing or installing.


### TARGETS

# do-build-man
#  Filter and compress manual pages.
#
# do-install-man
#  Install manual pages.


### IMPLEMENTATION

.if !target(__<bps.man.mk>__)
__<bps.man.mk>__:

MANDIR?=		${PREFIX}/share/man
MANMODE?=		${SHAREMODE}
MANOWN?=		${SHAREOWN}
MANGRP?=		${SHAREGRP}
MANSECTIONS?=		1 2 3 4 5 6 7 8 9 n l
MANINSTALL?=		${INSTALL} -o ${MANOWN} -g ${MANGRP} -m ${MANMODE}
MANCOMPRESSCMD?=	gzip
MANCOMPRESSEXT?=	.gz

.if defined(MANFILTER)
MANTOOL?=		( ${MANFILTER} | ${MANCOMPRESSCMD} )
.else
MANTOOL?=		${MANCOMPRESSCMD}
.endif

do-build:		buildman
do-install:		installmandirs
do-install:		installman

buildman:		.PHONY
installman:		.PHONY

.if defined(MAN) && !empty(MAN)
.for section in ${MANSECTIONS}
.for man in ${MAN:M*.${section}}
MANDIR.${man:T}=	${MANDIR}/man${section}
.endfor
.endfor

installmandirs:
.for section in ${MANSECTIONS}
.if !empty(MAN:M*.${section})
	@${INSTALL_DIR} ${DESTDIR}${MANDIR}/man${section}
.endif
.endfor

.for man in ${MAN}
CLEANFILES+=		${man}${MANCOMPRESSEXT}
${man}${MANCOMPRESSEXT}: ${man}
	${MANTOOL} < ${.ALLSRC} > ${.TARGET}
buildman: ${man}${MANCOMPRESSEXT}
installman: installman-${man:T}
installman-${man:T}: ${man}${MANCOMPRESSEXT} .PHONY
	${MANINSTALL} ${.ALLSRC} ${DESTDIR}${MANDIR.${man:T}}
.endfor
.endif

.endif #!target(__<bps.man.mk>__)

### End of file `bps.man.mk'
