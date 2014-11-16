### bps.project.mk -- Maintenance for software projects

# Author: Michael Grünewald
# Date: Sam 19 avr 2008 16:27:56 CEST

# BSD Owl Scripts (https://github.com/michipili/bsdowl)
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

# PACKAGE=		heat
# VERSION =		1.1.0
# OFFICER=		release-engineer@heat.org
#
# MODULE=		langc.lib:librational
# MODULE+=		langc.lib:libfibonacci
# MODULE+=		langc.prog:heat
#
# .include "bps.project.mk"


### DESCRIPTION

# This maintenance module for software projects should be the “master”
# Makefile of a package source tree.
#
# Beyond supporting the build and test of the software project, it
# also supports other functions like linting or the production of
# GPG-signed tarballs, and the preparation of a developper's subshell.


# Variables:
#
#
#  SRCDIR, WRKDIR, PACKAGE, PACKAGEDIR, VERSION, OFFICER, MODULE, EXTERNAL
#   See bps.package.mk
#
#
#  DISTDIR [${.OBJDIR}]
#   The folder used to publish distribution files and signatures
#
#   A useful value could be 'DISTDIR=${HOME}/Distfiles/${PACKAGE}/${VERSION}'.
#   It can be set from the environment but special care has to be
#   taken to prevent the expansion of ${PACKAGE} and ${VERSION} by
#   the shell.
#
#
#  DISTNAME [${PACKAGENAME}-${VERSION}]
#   The name used to produce tarballs
#
#   This name is also the name of the root directory appearing at the
#   root of the archive.
#
#
#  DISTSIGN
#   The list of extra distribution files which should be signed
#
#
#  DISTNOSIGN
#   The list of extra distribution files which do not need to be signed
#
#
#  DISTEXCLUDE [set by a strategy]
#   The list of files or directories which should not be distributed
#
#   The files enumerated by the DISTEXCLUDE variable are excluded from
#   the tarball distribution. The list of files produced by autoconf
#   is automatically added to this list.
#
#
#  PROJECTENV
#   The list of variables passed to the environment of subshells
#
#
#  PROJECTLIBRARY [Library]
#   The folder used as project library
#
#
#  PROJECTLIBRARYMAKE [Library/Make]
#   The folder holding project specific makefiles
#
#
#  PROJECTLIBRARYSHELL [Library/Ancillary]
#   The folder holding project specific scripts
#
#
#  SUBSHELLDIR [not set]
#   A folder to change to before popping up a subshell


# Targets:
#
#  Each target has the classical decomposition “pre-do-post” which
#  eases their customisation.
#
#
#  dist
#   Create, sign and publish distribution files
#
#    Important note fot GNU tar users: The GNU tar command does not
#    have an option “dereference symbolic links provided on the
#    command line”.  It is therefore forbidden to use symbolic links in
#    the source tree of a project.
#
#
# subshell
#  Pop up a user subshell


### IMPLEMENTATION

.if !target(__<bps.project.mk>__)
__<bps.project.mk>__:

DISTNAME?=		${PACKAGE}-${VERSION}
DISTDIR?=		${.OBJDIR}
GPG?=			${_BPS_GPG}

.include "bps.init.mk"


#
# Data for compression tools
#

_PROJECT_COMPRESS_TOOLS?=	${_BPS_COMPRESS}
_PROJECT_COMPRESS.suffix.none=
_PROJECT_COMPRESS.flag.none=
_PROJECT_COMPRESS.suffix.gzip=	.gz
_PROJECT_COMPRESS.flag.gzip=	-z
_PROJECT_COMPRESS.suffix.bzip2=	.bz2
_PROJECT_COMPRESS.flag.bzip2=	-j
_PROJECT_COMPRESS.suffix.xz=	.xz
_PROJECT_COMPRESS.flag.xz=	-J


#
# Production des archives
#  initialisation
#

.for tool in ${_PROJECT_COMPRESS_TOOLS}
.for f in ${DISTNAME}.tar${_PROJECT_COMPRESS.suffix.${tool}}
DISTSIGN+=		${DISTDIR}/${f}
DISTEXCLUDE+=		${f}
.endfor
.endfor


#
# Strategy to detect auo-excluded files
#

.for f in CVS .cvsignore .svn .gitignore .git .product
.if exists(${f})
DISTEXCLUDE+=		${f}
.endif
.endfor

.if defined(CONFIGURE)&&!empty(CONFIGURE:M*.in)
.for f in ${CONFIGURE:M*.in}
DISTEXCLUDE+=		${DISTNAME}/${f:.in=}
.endfor
.endif


#
# Production rule for archives
#

.for tool in ${_PROJECT_COMPRESS_TOOLS}
${DISTDIR}/${DISTNAME}.tar${_PROJECT_COMPRESS.suffix.${tool}}::
	${LN_S} ${SRCDIR} ${DISTDIR}/${DISTNAME}
	${TAR} -c\
	  ${_PROJECT_COMPRESS.flag.${tool}}\
	  -f ${.TARGET}\
	  -C ${DISTDIR}\
	  -h\
	  ${DISTEXCLUDE:S@^@--exclude @}\
	  --exclude ${DISTNAME}/${DISTNAME}\
	  ${DISTNAME}
	${RM} -f ${DISTDIR}/${DISTNAME}
.endfor


#
# Production rule for signatures
#

.for f in ${DISTSIGN}
${f:=.sig}: ${f}
	cd ${DISTDIR} && ${GPG} -u '${OFFICER}' -b ${.ALLSRC}
.endfor


#
# Targets
#

do-dist-projectdistdir:
	${INSTALL_DIR} ${DISTDIR}


#
# Hospitality
#

.if !target(pre-dist)
pre-dist:
	${NOP}
.endif

.if !target(post-dist)
post-dist:
	${NOP}
.endif


#
# Distribution
#

.if !target(do-dist)
do-dist: do-dist-projectdistdir
do-dist: do-dist-distnosign
do-dist: do-dist-distsign
do-dist: do-dist-sign
.endif

.if !empty(DISTNOSIGN)
do-dist-distnosign: ${DISTNOSIGN}
.else
do-dist-distnosign:
	${NOP}
.endif

.if !empty(DISTSIGN)
do-dist-distsign: ${DISTSIGN}
do-dist-sign: ${DISTSIGN:=.sig}
.else
do-dist-distsign do-dist-sign:
	${NOP}
.endif

do-dist-distnosign do-dist-distsign do-dist-sign: do-dist-projectdistdir

dist: pre-dist do-dist post-dist
.ORDER: pre-dist do-dist post-dist

#
# Initialisation of PROJECTLIBRARY
#

.if !defined(PROJECTLIBRARY)&&exists(${SRCDIR}/Library)
PROJECTLIBRARY=		${SRCDIR}/Library
.endif

.if defined(PROJECTLIBRARY)
.export PROJECTLIBRARY
.endif


#
# Initialisation of PROJECTLIBRARYMAKE
#

.if !defined(PROJECTLIBRARYMAKE)
.if defined(PROJECTLIBRARY)&&exists(${PROJECTLIBRARY}/Make)
PROJECTLIBRARYMAKE=	${PROJECTLIBRARY}/Make
.elif defined(PROJECTLIBRARY)&&exists(${PROJECTLIBRARY}/Mk)
PROJECTLIBRARYMAKE=	${PROJECTLIBRARY}/Mk
.elif exists(${SRCDIR}/Mk)
PROJECTLIBRARYMAKE=	${SRCDIR}/Mk
.endif
.endif

.if defined(PROJECTLIBRARYMAKE)
.export PROJECTLIBRARYMAKE
.if empty(.MAKEFLAGS:M${PROJECTLIBRARYMAKE})
.MAKEFLAGS: -I ${PROJECTLIBRARYMAKE}
.endif
.endif


#
# Initialisation de PROJECTLIBRARYSHELL
#

.if !defined(PROJECTLIBRARYSHELL)
.if defined(PROJECTLIBRARY) && exists(${PROJECTLIBRARY}/Ancillary)
PROJECTLIBRARYSHELL=	${PROJECTLIBRARY}/Ancillary
.elif exists(${SRCDIR}/Ancillary)
PROJECTLIBRARYSHELL=	${SRCDIR}/Ancillary)
.endif
.endif


#
# Developper's subhsell
#

.if defined(PROJECTEXPORT)&&!empty(PROJECTEXPORT)
.for v in ${PROJECTEXPORT}
PROJECTENV+=		$v="${$v}"
.endfor
.endif

.if defined(PROJECTLIBRARYSHELL)
PROJECTENV+=		PATH="${PROJECTLIBRARYSHELL}:${PATH}"
.endif


# The SHELL variable is defined in user's environment
SUBSHELLDIR?=		.
subshell: .PHONY
	${INFO} "Entering developper's subshell"
	@cd ${SUBSHELLDIR} && ${ENVTOOL} ${PROJECTENV} ${SHELL}
	${INFO} "Exiting developper's subshell"

#
# Delegating targets to subdirectories
#

.if defined(MODULE)
SUBDIR+=		${MODULE:C@.*\:@@}
.endif

.include "bps.subdir.mk"

obj: do-obj-subdir

.endif # !target(__<bps.project.mk>__)

### End of file `bps.project.mk'
