### tex.files.mk -- Installation de fichiers pour un syst�me TeX

# Author: Micha�l Le Barbier Gr�newald
# Date: Dim  9 sep 2007 17:32:25 CEST
# Lang: fr_FR.ISO8859-15

# $Id$

# BSDMake Pall�s Scripts (http://home.gna.org/bsdmakepscripts/)
# This file is part of BSDMake Pall�s Scripts
# 
# Copyright (C) Micha�l Le Barbier Gr�newald - 2006-2009
# 
# This file must be used under the terms of the CeCILL-B.
# This source file is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at
# http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt

### SYNOPSIS

# TEXGROUP = TEXSRC
# TEXSRC+= lmodern.sty
# TEXSRC+= ts1lmvtt.fd
# ...
# FORMAT = latex
# APPLICATION = lm
# TEXDIR = ${TEXMFDIR}/tex/${FORMAT}${APPLICATIONDIR}
#
# .include "tex.files.ml"

# Le fragment pr�c�dent s'arrange pour que `build' d�pende des
# fichiers figurant dans la liste TEX et pour que `install' installe
# ces fichiers dans ${TEXDIR}.

.include "bps.init.mk"
.include "texmf.init.mk"

TEXGROUP?= TEXSRC
FILESGROUPS+= ${TEXGROUP}
FORMAT?= plain
APPLICATION?= misc
DOCUMENTDIR?= ${TEXMFDIR}/doc/${FORMAT}${APPLICATIONDIR}
${TEXGROUP}DIR?= ${TEXMFDIR}/tex/${FORMAT}${APPLICATIONDIR}

.if defined(${TEXGROUP})&&!empty(${TEXGROUP})
post-install: post-install-mktexlsr
post-install-mktexlsr:
.if ${UID} == 0
	${ENVTOOL} TEXMFHOME='/dev/null' mktexlsr
.else
	mktexlsr
.endif
.endif

.include "bps.files.mk"
.include "bps.usertarget.mk"

### End of file `tex.files.mk'
