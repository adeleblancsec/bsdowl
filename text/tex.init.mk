### tex.init.mk -- Service d'initialisation

# Author: Micha�l Le Barbier Gr�newald
# Date: Dim  9 sep 2007 14:49:18 CEST
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

.if !target(__<tex.init.mk>__)
__<tex.init.mk>__:

TEXMFDIR?= ${PREFIX}/share/texmf
WEB2CDIR?= ${TEXMFDIR}/web2c

TEXDEVICE?= dvi
TEX?= pdftex
DVITEX?= ${TEX}
PDFTEX?= pdftex

# Les variables �num�r�es par _TEX_VARS sont des variables d'instance
# supportant une sp�cialisation pour chaque cible.
_TEX_VARS+= TEXINPUTS TEXMFOUTPUT TEXFORMATS TEXPOOL TFMFONTS
_TEX_VARS+= INTERACTION JOBNAME TEXFORMATS
_TEX_VARS+= COMMENT PROGNAME

_TEX_DOC?= ${DOCS:.tex=}

_TEX_DEVICES?= pdf ps dvi

_TEX_SUFFIX.dvi = .dvi
_TEX_SUFFIX.pdf = .pdf
_TEX_SUFFIX.ps = .ps

_TEX_DRIVER.dvi?= dvi
_TEX_DRIVER.pdf?= pdftex
_TEX_DRIVER.ps?= dvips

_TEX_COOKIE = .cookie.

COOKIEFILES =

do-clean-cookies:
	@${RM} -f ${COOKIEFILES}

do-clean: do-clean-cookies

.for device in ${_TEX_DEVICES}
_TEX_DRIVERS+= ${_TEX_DRIVER.${device}}
.endfor

.endif #!target(__<tex.init.mk>__)

### End of file `tex.init.mk'
