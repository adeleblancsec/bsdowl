### tex.driver.dvi.mk -- Supervise la production des fichiers DVI

# Author: Micha�l Gr�newald
# Date: Dim  9 sep 2007 14:49:18 CEST
# Lang: fr_FR.ISO8859-15

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
# DRAFT = Yes			# Inhibe MULTIPASS
#
# ${var}.{dvi:T} = value


### R�ALISATION

.if !target(__<tex.driver.dvi.mk>__)
__<tex.driver.dvi.mk>__:

#
# Initialisation des param�tres
#

_TEX_AUX_SUFFIXES?= .log

#
# Sp�cialisation des variables
#

# La sp�cialisation produit les variables TEXINPUTS.lalala.dvi, elle
# fournit une valeur en cherchant d'abord TEXINPUTS.lalala puis
# TEXINPUTS. Si aucune valeur n'est trouv�e, la variable n'est pas
# affect�e.

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
# D�finition de _TEX_SRC
#

.for dvi in ${_TEX_DVI}
.if !defined(_TEX_SRC.${dvi:T})||empty(_TEX_SRC.${dvi:T})
_TEX_SRC.${dvi:T}=${dvi:.dvi=.tex}
.endif
.endfor


#
# Cr�ation des lignes de commande
#

.for dvi in ${_TEX_DVI}
# On commence par calculer l'environnement d'�x�cution
.if defined(TEXINPUTS.${dvi:T})&&!empty(TEXINPUTS.${dvi:T})
_TEX_ENV.${dvi:T}+= TEXINPUTS=${TEXINPUTS.${dvi:T}:Q:S/\\ /:/g}
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
# On ins�re cet environnement sur la ligne de commande
.if defined(_TEX_ENV.${dvi:T})&&!empty(_TEX_ENV.${dvi:T})
_TEX_BUILD.${dvi:T} = ${ENVTOOL} ${_TEX_ENV.${dvi:T}} ${DVITEX}
.else
_TEX_BUILD.${dvi:T} = ${DVITEX}
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

# La production des recttes est control�e par les variables
# MULTIPASS et DRAFT.
#
# La d�pendance ${dvi}: ${_TEX_SRC.${dvi:T}} est ajout�e
# automatiquement.

# Pour les traitements � plusieurs passes, on utilise des fichiers
# interm�diaires (des `cookies') pour faciliter la gestion des
# d�pendances, et permettre l'insertion de passes suppl�mentaires, par
# exemple pour la pr�paration des bibliographies ou des index.

_TEX_COOKIE = .cookie.

.for dvi in ${_TEX_DVI}
.if defined(MULTIPASS)&&!empty(MULTIPASS)&&!defined(DRAFT)
.undef _TEX_pass_last
.for pass in ${MULTIPASS}
.if defined(_TEX_pass_last)
${_TEX_COOKIE}${dvi:T}.${pass}: ${_TEX_COOKIE}${dvi:T}.${_TEX_pass_last}
.endif
_TEX_pass_last:= ${pass}
.endfor
.for pass in ${MULTIPASS}
${_TEX_COOKIE}${dvi:T}.${pass}: ${_TEX_SRC.${dvi:T}}
	${INFO} 'Multipass job for ${dvi:T} (${pass})'
	${_TEX_BUILD.${dvi:T}}
	@${RM} -f ${dvi}
	@${TOUCH} ${.TARGET}
CLEANFILES+= ${_TEX_COOKIE}${dvi:T}.${pass}
.endfor
${dvi}: ${_TEX_SRC.${dvi:T}} ${_TEX_COOKIE}${dvi:T}.${_TEX_pass_last}
	${INFO} 'Multipass job for ${dvi:T} (final)'
	${_TEX_BUILD.${dvi:T}}
.else
${dvi}: ${_TEX_SRC.${dvi:T}}
	${_TEX_BUILD.${dvi:T}}
.endif
.endfor

.endif #!target(__<tex.driver.dvi.mk>__)

### End of file `tex.driver.dvi.mk'
