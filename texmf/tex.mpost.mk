### tex.mpost.mk -- Cr�ation de figures avec METAPOST

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

### SYNOPSIS

# FIGS = conics.mp
# FIGS+= desargues.mp
#
# FIGS.lalala = pappus.mp
#
# .include "tex.mpost.mk"

#
# Description
#

# MPTEXINPUTS
#
#  This special variable shadows TEXINPUTS when it is defined, this will ease
#  the share of figure files across several files. Note that, in this case,
#  figures should be put in a separate folder.

#
# Pseudo-outils
#

MPOST?= mpost
MPTEX?= ${TEX.dvi}
MP2EPS?= mp2eps
MP2PDF?= mp2pdf
MP2PNG?= mp2png

MPOST_DEVICE.dvi?= eps
MPOST_DEVICE.ps?= eps
MPOST_DEVICE.pdf?= pdf

_MPOST_FIG?=
_MPOST_VARS+= MPINPUTS
_MPOST_VARS+= MPTEX
_MPOST_VARS+= MPTEXINPUTS

.if !empty(TEXDEVICE:M*.ps)
.for device in ${TEXDEVICE:M*.ps}
MPOST_DEVICE.${device} = ${MPOST_DEVICE.ps}
.endfor
.endif

MPOST_TOOL.eps = ${MP2EPS}
MPOST_TOOL.pdf = ${MP2PDF}
MPOST_TOOL.png = ${MP2PNG}

#
# Analyse des fichiers de figures
#

.for fig in ${FIGS}
.if empty(_MPOST_FIG:M${fig})
_MPOST_FIG+=${fig}
.endif
.endfor

.for doc in ${_TEX_DOC}
.if defined(FIGS.${doc:T})&&!empty(FIGS.${doc:T})
.for fig in ${FIGS.${doc:T}}
.if empty(_MPOST_FIG:M${fig})
_MPOST_FIG+=${fig}
.endif
.endfor
.endif
.endfor

.for fig in ${_MPOST_FIG}
.cookie.${fig:T}: ${fig}
	@${SED} -n 's/^beginfig(\([0-9][0-9]*\)).*/${fig:.mp=}.\1/p' ${.ALLSRC} > ${.TARGET}
depend: .cookie.${fig:T}
.if exists(.cookie.${fig:T})
_MPOST_LIST.${fig:T}!= cat .cookie.${fig:T}
.else
_MPOST_LIST.${fig:T} =
.endif
COOKIEFILES+= .cookie.${fig:T}
.endfor

#
# Ajout des sources
#

.if defined(_TEX_DOC)&&!empty(_TEX_DOC)
.for doc in ${_TEX_DOC}

.if defined(FIGS)&&!empty(FIGS)
FIGS.${doc:T}+= ${FIGS}
.endif

.if defined(FIGS.${doc:T})
.for fig in ${FIGS.${doc:T}}
.for device in ${TEXDEVICE}
SRCS.${doc:T}.${device}+= ${_MPOST_LIST.${fig:T}:=.${MPOST_DEVICE.${device}}}
.endfor
.endfor
.endif

.endfor
.endif

#
# Cr�ation des lignes de commande pour METAPOST
#

# Les fichiers METAPOST peuvent contenir des commandes TeX. Ils
# doivent donc �tre �x�cut�s dans le m�me environnement que si le
# fichier devait �tre trait� par TeX.
#
# On passe donc les variables TEXINPUTS, TEXFORMATS, etc. dans
# l'environnement du programme METAPOST.

.for var in ${_TEX_VARS} ${_MPOST_VARS}
.for fig in ${FIGS}
.if defined(${var})&&!empty(${var})&&!defined(${var}.${fig:T})
${var}.${fig:T} = ${${var}}
.endif
.endfor
.endfor

.for fig in ${FIGS}
.if defined(MPTEX.${fig:T})&&!empty(MPTEX.${fig:T})
_MPOST_ENV.${fig:T}+= TEX=${MPTEX.${fig:T}:Q}
.endif
.if defined(MPINPUTS.${fig:T})&&!empty(MPINPUTS.${fig:T})
_MPOST_ENV.${fig:T}+= MPINPUTS=${MPINPUTS.${fig:T}:Q:S/\\ /:/g}
.endif
.if defined(MPTEXINPUTS.${fig:T})&&!empty(MPTEXINPUTS.${fig:T})
_MPOST_ENV.${fig:T}+= TEXINPUTS=${MPTEXINPUTS.${fig:T}:Q:S/\\ /:/g}
.elif defined(TEXINPUTS.${fig:T})&&!empty(TEXINPUTS.${fig:T})
_MPOST_ENV.${fig:T}+= TEXINPUTS=${TEXINPUTS.${fig:T}:Q:S/\\ /:/g}
.endif
.if defined(TEXMFOUTPUT.${fig:T})&&!empty(TEXMFOUTPUT.${fig:T})
_MPOST_ENV.${fig:T}+= TEXMFOUTPUT=${TEXMFOUTPUT.${fig:T}:Q}
.endif
.if defined(TEXFORMATS.${fig:T})&&!empty(TEXFORMATS.${fig:T})
_MPOST_ENV.${fig:T}+= TEXFORMATS=${TEXFORMATS.${fig:T}:Q}
.endif
.if defined(TEXPOOL.${fig:T})&&!empty(TEXPOOL.${fig:T})
_MPOST_ENV.${fig:T}+= TEXPOOL=${TEXPOOL.${fig:T}:q}
.endif
.if defined(TFMFONTS.${fig:T})&&!empty(TFMFONTS.${fig:T})
_MPOST_ENV.${fig:T}+= TFMFONTS=${TFMFONTS.${fig:T}:Q}
.endif
# On tient compte de l'environnement pour construire la ligne de commande
.if defined(_MPOST_ENV.${fig:T})&&!empty(_MPOST_ENV.${fig:T})
_MPOST_BUILD.${fig:T} = ${ENVTOOL} ${_MPOST_ENV.${fig:T}} ${MPOST}
.else
_MPOST_BUILD.${fig:T} = ${MPOST}
.endif
.endfor

#
# Chemins de recherche
#

# Si la variable MPINPUTS est d�finie, on utilise sa valeur pour
# .PATH.mp.

.SUFFIXES: .mp
.if defined(MPINPUTS)&&!empty(MPINPUTS)
.PATH.mp: ${MPINPUTS}
.endif


#
# Traitement des fichiers par METAPOST
#

.for fig in ${_MPOST_FIG}
${_MPOST_LIST.${fig:T}}: ${fig}
	${_MPOST_BUILD.${fig:T}} ${.ALLSRC}
.endfor


#
# Traitement ult�rieur des fichiers
#

# Remarque: � cause de la boucle `for device', si plusieurs fichiers
# PostScript sont produits, plusieurs recettes pour les figures EPS
# sont potentiellement g�n�r�es. On corrige ce comportement (d�finir
# plusieurs recettes pour produire un ficheir donn� est une erreur) en
# testant l'existence d'une recette pour produire le fichier de
# figure avant de proposer la recette g�n�r�e automatiquement dans la
# boucle.

.for fig in ${_MPOST_FIG}
.for device in ${TEXDEVICE}
.for item in ${_MPOST_LIST.${fig:T}}
.if !target(${item}.${MPOST_DEVICE.${device}})
${item}.${MPOST_DEVICE.${device}}: ${item}
	${MPOST_TOOL.${MPOST_DEVICE.${device}}} ${.ALLSRC}
.endif
.endfor
.endfor
.endfor


#
# Cleanfiles
#

.for fig in ${_MPOST_FIG}
CLEANFILES+= ${fig:.mp=.log} ${fig:.mp=.mpx} ${_MPOST_LIST.${fig:T}}
.endfor

.for fig in ${_MPOST_FIG}
.for device in ${TEXDEVICE}
.for item in ${_MPOST_LIST.${fig:T}}
CLEANFILES+= ${item}.${MPOST_DEVICE.${device}}
.endfor
.endfor
.endfor

.for file in mpxerr.log mpxerr.tex
.if exists(${file})
CLEANFILES+= ${file}
.endif
.endfor

### End of file `tex.mpost.mk'
