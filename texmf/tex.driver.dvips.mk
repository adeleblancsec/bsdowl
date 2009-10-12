### tex.driver.dvips.mk -- Organise la production des fichiers PostScript

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

.if !target(__<tex.driver.dvips.mk>__)
__<tex.driver.dvips.mk>__:

DVIPS?= dvips

#
# Sp�cialisation des variables
#

# Par ordre de sp�cialisation croissante:
#  DVIPSFLAGS,
#  DVIPSFLAGS.document,
#  DVIPSFLAGS.document.ps,
#  DVIPSFLAGS.document.printer.ps.

.for var in DVIPSFLAGS DVIPS
.for doc in ${_TEX_DOC}
.if defined(${var})&&!empty(${var})&&!defined(${var}.${doc:T})
${var}.${doc:T} = ${${var}}
.endif
.if defined(${var}.${doc:T})&&!empty(${var}.${doc:T})&&!defined(${var}.${doc:T}.ps)
${var}.${doc:T}.ps = ${${var}.${doc:T}}
.endif
.for printer in ${PRINTERS}
.if defined(${var}.${doc:T}.ps)&&!empty(${var}.${doc:T}.ps)&&!defined(${var}.${doc:T}.${printer}.ps)
${var}.${doc:T}.${printer}.ps = ${${var}.${doc:T}.ps}
.endif
.endfor
.endfor
.endfor

#
# Cr�ation des lignes de commande
#

.for ps in ${_TEX_PS}
_DVIPS_BUILD.${ps:T} = ${DVIPS}
.for printer in ${PRINTERS}
# Le pr�dicat == insiste pour avoir une variable � gauche. La
# bidouille __loop__ le satisfait.
__loop__=${printer}
.if ${__loop__} == ${ps:C/.ps$//:C/^.*\.//} 
_DVIPS_BUILD.${ps:T}+= -P ${printer}
.endif
.undef __loop__
.endfor
.if defined(DVIPSFLAGS.${ps:T})&&!empty((DVIPSFLAGS.${ps:T})
_DVIPS_BUILD.${ps:T}+= ${DVIPSFLAGS.${ps:T}}
.endif
_DVIPS_BUILD.${ps:T}+= -o ${ps} ${ps}.dvi
.endfor

#
# Recettes
#

.for ps in ${_TEX_PS}
${ps}: ${ps}.dvi
	${_DVIPS_BUILD.${ps:T}}
.endfor

.endif #!target(__<tex.driver.dvips.mk>__)

### End of file `tex.driver.dvips.mk'
