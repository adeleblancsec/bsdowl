### bps.subdir.mk -- Manage subdirectories

# Author: Micha�l Gr�newald
# Date: Ven 10 f�v 2006 16:24:23 GMT
# Lang: fr_FR.ISO8859-1

# $Id$

# Copyright (c) 2006, 2007, 2008, Micha�l Gr�newald
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#    1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#    2. Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#
#    3. The name of the author may not be used to endorse or promote
#    products derived from this software without specific prior written
#    permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


### SYNOPSIS

# SUBDIR+= library
# SUBDIR+= program
# SUBDIR+= manual
#
# .include "bps.subdir.mk"


### DESCRIPTION

# Diffuse la demande de production des cibles ``interface
# utilisateur'' (all, etc.) vers les sous r�pertoires apparaissant
# dans SUBDIR.

.include "bps.init.mk"
.include "bps.clean.mk"
.include "bps.credentials.mk"

.if !target(__<bps.subdir.mk>__)
__<bps.subdir.mk>__:

_SUBDIR_TARGETS+= ${_MAKE_USERTARGET}
_SUBDIR_PREFIX?=

.if defined(SUBDIR) && !empty(SUBDIR) && !defined(NO_SUBDIR)
.PHONY: ${SUBDIR}
_SUBDIR: .USE
.for item in ${SUBDIR}
	${INFO} "${_SUBDIR_PREFIX}${item} (${.TARGET})"
	@cd ${.CURDIR}/${item}\
	  &&${MAKE} _SUBDIR_PREFIX=${_SUBDIR_PREFIX}${item}/ ${.TARGET}
.endfor
.endif

${SUBDIR}::
	${INFO} "${.TARGET} (all)"
	@cd ${.CURDIR}/${.TARGET}; ${MAKE} all

.for target in ${_SUBDIR_TARGETS}
.if !target(${target}-switch-credentials)
${target}: _SUBDIR
.endif
.endfor

.endif #!target(__<bps.subdir.mk>__)

### End of file `bps.subdir.mk'