### bps.subdir.mk -- Manage subdirectories

# Author: Micha�l Le Barbier Gr�newald
# Date: Ven 10 f�v 2006 16:24:23 GMT
# Lang: fr_FR.ISO8859-1

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

# SUBDIR+= library
# SUBDIR+= program
# SUBDIR+= manual
#
# .include "bps.subdir.mk"


### DESCRIPTION

# Diffuse la demande de production des cibles administratives �num�r�es par la
# variables _SUBDIR_TARGET vers les sous-r�pertoires �num�r�s par la variable
# SUBDIR.
#
# Pour chaque cible administrative ${target}, une cible do-${target}-subdir
# est d�finie, la r�gle de production de cette cible lance le sous-traitement
# de ${target} dans les sous-r�pertoires �num�r�s dans SUBDIR.
#
# Les cibles administratives sont marqu�es par l'attribut `.PHONY'.
#
# � moins qu'une cible ${target}-switch-credentials existe, la cible
# do-${target}-subdir devient un pr�requis de ${target}. Ce comportement
# permet l'utilsiation conjointe de ce module de directives avec le module
# `bps.credentials.mk'.


#
# Description des variables
#

# USE_SUBDIR
#
#  Drapeau de contr�le de la rediffusion des ordres de production vers les
#  sous-dossiers.
#
#  La rediffusion des ordres de production vers les sous-dossiers a lieu
#  lorsque la variable USE_SUBDIR est positionn�e � `yes'. En l'absence
#  d'initialisation explicite, lorsque SUBDIR est initialis�e la variable
#  USE_SUBDIR re�oit la valeur implicite `yes'.

# SUBDIR
#
#  Liste des sous-dossiers vers lesquels les ordres de production sont
#  rediffus�s.

# _SUBDIR_TARGET
#
#  Liste des ordres de production devant �tre rediffus�s.
#
#  Les ordres de production �num�r�s par la variable _MAKE_USERTARGET
#  (bps.usertarget.mk) sont automatiquement ajout�s � cette variable.


### IMPL�MENTATION

.include "bps.init.mk"
.include "bps.credentials.mk"

.if !target(__<bps.subdir.mk>__)
__<bps.subdir.mk>__:

_SUBDIR_TARGET+= ${_MAKE_USERTARGET}
_SUBDIR_PREFIX?=

.if defined(SUBDIR) && !empty(SUBDIR)
USE_SUBDIR?= yes
.endif

.if ${USE_SUBDIR} == yes
.PHONY: ${SUBDIR}
_SUBDIR: .USE
.for item in ${SUBDIR}
	${INFO} "${_SUBDIR_PREFIX}${item} (${.TARGET:S/^do-//:S/-subdir$//})"
	@cd ${.CURDIR}/${item}\
	  &&${MAKE} _SUBDIR_PREFIX=${_SUBDIR_PREFIX}${item}/ ${.TARGET:S/^do-//:S/-subdir$//}
.endfor

${SUBDIR}::
	${INFO} "${.TARGET} (all)"
	@cd ${.CURDIR}/${.TARGET}; ${MAKE} all

.for target in ${_SUBDIR_TARGET}
do-${target}-subdir: _SUBDIR
	${NOP}
.if !target(${target}-switch-credentials)
${target}: do-${target}-subdir
.endif
.endfor

.endif # ${USE_SUBDIR} == yes
.endif #!target(__<bps.subdir.mk>__)

.include "bps.clean.mk"

### End of file `bps.subdir.mk'
