### tex.doc.main.mk -- Produce TeX documents (main part)

# Author: Michael Grünewald
# Date: Dim  9 sep 2007 14:49:18 CEST
# Cookie: SYNOPSIS TARGET VARIABLE EN DOCUMENTATION

# BSDMake Pallàs Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pallàs Scripts
#
# Copyright (C) 2006-2009, 2013 Michael Grünewald
#
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt

#
# Spécialisation de FORMAT
#

# Chaque `device' peut utiliser un format TeX spécifique. La variable
# FORMAT permet d'initialiser les variables FORMAT.${device} avec une
# valeur commune.

.if defined(FORMAT)&&!empty(FORMAT)
.for device in ${TEXDOC_DEVICES}
FORMAT.${_TEX_SUFFIX.${device}}?= ${FORMAT}
.endfor
.endif


#
# Spécialisation de SRCS
#

.for doc in ${_TEX_DOC}
.if defined(SRCS)&&!empty(SRCS)
SRCS.${doc:T}+= ${SRCS}
.endif
.for device in ${TEXDEVICE}
.if defined(SRCS.${doc:T})&&!empty(SRCS.${doc:T})
SRCS.${doc:T}.${device}+= ${SRCS.${doc:T}}
.endif
.endfor
.endfor

#
# Files groups
#

FILESGROUPS+= TEXDOC
TEXDOCDIR?= ${PREFIX}/Documents${APPLICATIONDIR}
TEXDOCOWN?= ${DOCOWN}
TEXDOCGROUP?= ${DOCGROUP}
TEXDOCMODE?= ${DOCMODE}

.if defined(TEXDOCNAME)&&!empty(TEXDOCNAME)
.for doc in ${_TEX_DOC}
TEXDOCNAME.${doc:T}?= ${TEXDOCNAME}
.endfor
.endif

.if defined(TEXDRAFTSTAMP)&&!empty(TEXDRAFTSTAMP)
.for doc in ${_TEX_DOC}
.if defined(TEXDOCNAME.${doc:T})
TEXDOCNAME.${doc:T}:= ${TEXDOCNAME.${doc:T}}${TEXDRAFTSTAMP}
.else
TEXDOCNAME.${doc:T} = ${doc:T}${TEXDRAFTSTAMP}
.endif
.endfor
.endif


#
# Génération des dépendances
#

.for doc in ${_TEX_DOC}
.for device in ${TEXDEVICE}
.if defined(SRCS.${doc:T}.${device})&&!empty(SRCS.${doc:T}.${device})
${doc}.${device}: ${SRCS.${doc:T}.${device}}
.endif
.endfor
.endfor


#
# Pilotes
#

.for device in ${_TEX_DEVICES}
.include "tex.device.${device}.mk"
.endfor

.for driver in ${_TEX_DRIVERS}
.include "tex.driver.${driver}.mk"
.endfor

#
# Objectifs de production de documents
#

do-build: do-build-doc
do-build-doc: ${TEXDOC}

### End of file `tex.doc.main.mk'
