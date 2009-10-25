### tex.texdoc.ps.mk -- R�clame la production de fichiers PostScript

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

# La production des fichiers PostScript est param�tr�e par
# l'imprimante � laquelle est destin� le fichier. Dees param�tres
# sp�ciaux permettent de cibler la publication �l�ctronique
# (i.e. l'imprimante est un interpr�te PostScript comme GHOSTSCRIPT).

### SYNOPSIS

# PRINTERS = hp920c lex4400
#
# Peuvent appara�tre toutes les imprimantes ayant �t� configur�es avec
# texconfig --- ou d'une autre fa�on.


### R�ALISATION

#
# Augmentation de PRINTERS
#

# Un membre hp920c.ps dans la variable TEXDEVICE ajoute hp920c � la
# variable PRINTERS.

.if !empty(TEXDEVICE:M*.ps:.ps=)
.for printer in ${TEXDEVICE:M*.ps:.ps=}
.if empty(PRINTERS:M${printer})
PRINTERS+= ${printer}
.endif
.endfor
.endif

#
# R�clamation de fichiers
#

.for doc in ${_TEX_DOC}
.for device in ${TEXDEVICE:M*ps}
_TEX_PS+= ${doc}.${device}
_TEX_DVI+= ${doc}.${device}.dvi
_TEX_SRC.${doc}.${device}.dvi = ${doc}.tex
JOBNAME.${doc}.${device}.dvi = ${doc}.${device}
.endfor
.endfor


#
# Build and install files
#

.if !empty(TEXDEVICE:M*ps)
.for device in ${TEXDEVICE:M*ps}
TEXDOC+= ${_TEX_DOC:=.${device}}
.for doc in ${_TEX_DOC}
.if defined(TEXDOCNAME.${doc:T})&&!empty(TEXDOCNAME.${doc:T})
TEXDOCNAME.${doc:T}.${device} = ${TEXDOCNAME.${doc:T}}.${device}
.endif
.endfor
.endfor
.endif



#
# Cleanfiles
#

.if !empty(TEXDEVICE:M*ps)
.for sfx in ${_TEX_AUX_SUFFIXES}
.for ps in ${_TEX_PS}
.if empty(CLEANFILES:M${ps})
CLEANFILES+= ${ps}
.endif
.for itm in ${ps:.ps=${sfx}}
.if empty(CLEANFILES:M${itm})
CLEANFILES+= ${itm}
.endif
.endfor
.endfor
.endfor
.for sfx in ${_TEX_AUX_SUFFIXES}
.for dvi in ${_TEX_DVI}
.if empty(CLEANFILES:M${dvi})
CLEANFILES+= ${dvi}
.endif
.for itm in ${dvi:.dvi=${sfx}}
.if empty(CLEANFILES:M${itm})
CLEANFILES+= ${itm}
.endif
.endfor
.endfor
.endfor
.endif

### End of file `tex.device.ps.mk'
