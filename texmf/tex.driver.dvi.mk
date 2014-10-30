### tex.driver.dvi.mk -- Supervise la production des fichiers DVI

# Author: Michael Grünewald
# Date: Dim  9 sep 2007 14:49:18 CEST
# Cookie: SYNOPSIS TARGET VARIABLE EN DOCUMENTATION

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

# TEX = /usr/local/bin/tex
#
# _TEX_DVI+= lalala.hp920c.ps.dvi
# _TEX_SRC.lalala.hp920c.ps.dvi = lalala.tex
# _TEX_DVI+= lalala.dvi
#
# _TEX_AUX_SUFFIXES = .aux .log
#
# _TEX_VARS = TEXINPUTS TEXMFOUTPUT TEXFORMATS TEXPOOL TFMFONTS
# _TEX_VARS+= INTERACTION JOBNAME FORMAT
# _TEX_VARS+= COMMENT PROGNAME
#
# MULTIPASS = aux ref final
# DRAFT = yes			# Inhibe MULTIPASS
#
# ${var}.{dvi:T} = value


### RÉALISATION

.if !target(__<tex.driver.dvi.mk>__)
__<tex.driver.dvi.mk>__:

#
# Initialisation des paramètres
#

_TEX_AUX_SUFFIXES?= .log

#
# Spécialisation des variables
#

# La spécialisation produit les variables TEXINPUTS.lalala.dvi, elle
# fournit une valeur en cherchant d'abord TEXINPUTS.lalala puis
# TEXINPUTS. Si aucune valeur n'est trouvée, la variable n'est pas
# affectée.

.for var in ${_TEX_VARS} FORMAT.dvi
.for dvi in ${_TEX_DVI}
.if defined(${var}.${dvi:T:.dvi=})&&!empty(${var.${dvi:T:.dvi=}})&&!defined(${var}.${dvi:T})
${var}.${dvi:T} = ${${var}.${dvi:T:.dvi=}}
.endif
.if defined(${var})&&!empty(${var})&&!defined(${var}.${dvi:T})
${var}.${dvi:T} = ${${var}}
.endif
.endfor
.endfor


#
# Définition de _TEX_SRC
#

.for dvi in ${_TEX_DVI}
.if !defined(_TEX_SRC.${dvi:T})||empty(_TEX_SRC.${dvi:T})
_TEX_SRC.${dvi:T}=${dvi:.dvi=.tex}
.endif
.endfor


#
# Création des lignes de commande
#

.for dvi in ${_TEX_DVI}
# On commence par calculer l'environnement d'éxécution
.if defined(TEXINPUTS.${dvi:T})&&!empty(TEXINPUTS.${dvi:T})
.if !defined(USE_STRICT_TEXINPUTS)|| ${USE_STRICT_TEXINPUTS} != yes
_TEX_ENV.${dvi:T}+= TEXINPUTS=".:${TEXINPUTS.${dvi:T}:Q:S/\\ /:/g}:"
.else
_TEX_ENV.${dvi:T}+= TEXINPUTS="${TEXINPUTS.${dvi:T}:Q:S/\\ /:/g}"
.endif
.endif
.if defined(TEXMFOUTPUT.${dvi:T})&&!empty(TEXMFOUTPUT.${dvi:T})
_TEX_ENV.${dvi:T}+= TEXMFOUTPUT=${TEXMFOUTPUT.${dvi:T}:Q}
.endif
.if defined(TEXFORMATS.${dvi:T})&&!empty(TEXFORMATS.${dvi:T})
_TEX_ENV.${dvi:T}+= TEXFORMATS=${TEXFORMATS.${dvi:T}:Q}
.endif
.if defined(TEXPOOL.${dvi:T})&&!empty(TEXPOOL.${dvi:T})
_TEX_ENV.${dvi:T}+= TEXPOOL=${TEXPOOL.${dvi:T}:q}
.endif
.if defined(TFMFONTS.${dvi:T})&&!empty(TFMFONTS.${dvi:T})
_TEX_ENV.${dvi:T}+= TFMFONTS=${TFMFONTS.${dvi:T}:Q}
.endif
# On insère cet environnement sur la ligne de commande
.if defined(_TEX_ENV.${dvi:T})&&!empty(_TEX_ENV.${dvi:T})
_TEX_BUILD.${dvi:T} = ${ENVTOOL} ${_TEX_ENV.${dvi:T}} ${TEX.dvi}
.else
_TEX_BUILD.${dvi:T} = ${TEX.dvi}
.endif
# On traite les variables dont l'argument est transmis au programme
.if defined(FORMAT.dvi.${dvi:T})&&!empty(FORMAT.dvi.${dvi:T})
_TEX_BUILD.${dvi:T}+= -fmt ${FORMAT.dvi.${dvi:T}}
.endif
.if defined(INTERACTION.${dvi:T})&&!empty(INTERACTION.${dvi:T})
_TEX_BUILD.${dvi:T}+= -interaction ${INTERACTION.${dvi:T}}mode
.endif
.if defined(JOBNAME.${dvi:T})&&!empty(JOBNAME.${dvi:T})
_TEX_BUILD.${dvi:T}+= -jobname ${JOBNAME.${dvi:T}}
.endif
.if defined(COMMENT.${dvi:T})&&!empty(COMMENT.${dvi:T})
_TEX_BUILD.${dvi:T}+= -output-comment ${COMMENT.${dvi:T}}
.endif
.if defined(PROGNAME.${dvi:T})&&!empty(PROGNAME.${dvi:T})
_TEX_BUILD.${dvi:T}+= -progname ${PROGNAME.${dvi:T}}
.endif
# On termine en ajoutant le fichier source principal
_TEX_BUILD.${dvi:T}+=${_TEX_SRC.${dvi:T}}
.endfor


#
# Production des recettes
#

# La production des recttes est controlée par les variables
# MULTIPASS et DRAFT.
#
# La dépendance ${dvi}: ${_TEX_SRC.${dvi:T}} est ajoutée
# automatiquement.

# Pour les traitements à plusieurs passes, on utilise des fichiers
# intermédiaires (des `cookies') pour faciliter la gestion des
# dépendances, et permettre l'insertion de passes supplémentaires, par
# exemple pour la préparation des bibliographies ou des index.

.for dvi in ${_TEX_DVI}
.if defined(MULTIPASS)&&!empty(MULTIPASS)&&(${DRAFT} == no)
.undef _TEX_pass_last
.for pass in ${MULTIPASS}
.if defined(_TEX_pass_last)
${COOKIEPREFIX}${dvi:T}.${pass}: ${COOKIEPREFIX}${dvi:T}.${_TEX_pass_last}
.endif
_TEX_pass_last:= ${pass}
.endfor
.for pass in ${MULTIPASS}
${COOKIEPREFIX}${dvi:T}.${pass}: ${_TEX_SRC.${dvi:T}}
	${INFO} 'Multipass job for ${dvi:T} (${pass})'
	${_TEX_BUILD.${dvi:T}}
	@${RM} -f ${dvi}
	@${TOUCH} ${.TARGET}
COOKIEFILES+= ${COOKIEPREFIX}${dvi:T}.${pass}
.endfor
${dvi}: ${_TEX_SRC.${dvi:T}} ${COOKIEPREFIX}${dvi:T}.${_TEX_pass_last}
	${INFO} 'Multipass job for ${dvi:T} (final)'
	${_TEX_BUILD.${dvi:T}}
.else
${dvi}: ${_TEX_SRC.${dvi:T}}
	${_TEX_BUILD.${dvi:T}}
.endif
.endfor

.endif #!target(__<tex.driver.dvi.mk>__)

### End of file `tex.driver.dvi.mk'
