### tex.device.dvi.mk -- R�clame la production de fichiers DVI

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

# Ce module analyse les param�tres re�us de tex.texdoc.mk et passe
# commande � tex.driver.dvi.mk pour la production des fichiers DVI
# recquis par ces param�tres.


#
# Commande la cr�ation de ${doc}.dvi
#

.for doc in ${_TEX_DOC}
_TEX_DVI+= ${doc}.dvi
.endfor


#
# Sp�cialisation des variables
#

.for doc in ${_TEX_DOC}
.for var in ${_TEX_VARS}
.if defined(${var}.${doc:T})&&!empty(${var}.${doc:T})&&!defined(${var}.${doc:T}.dvi)
${var}.${doc:T}.dvi = ${${var}.${doc:T}}
.endif
.endfor
.endfor


#
# Clean files
#

# Note: si on inverse les deux boucles SFX et DVI, cela ne marche
# plus, le param�tre formel SFX n'est pas remplac�! (DVI en premier,
# SFX en second.) Ceci peut peut-�tre s'expliquer d'apr�s les r�gles
# de traitement des boucles for, mais je ne sais pas clarifier ce
# comportement.

.if !empty(TEXDEVICE:Mdvi)
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


#
# Build and install files
#

.if !empty(TEXDEVICE:Mdvi)
DOCUMENT+= ${_TEX_DOC:=.dvi}
.endif

### End of file `tex.device.dvi.mk'
