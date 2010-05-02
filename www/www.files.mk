### www.files.mk -- A bps.files.mk wrapper for my www

# Author: Micha�l Le Barbier Gr�newald
# Date: Jeu 13 mar 2008 21:58:28 CET
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

# Exemple de fichier ma�tre, plac� dans le r�pertoire principal du
# document WWW � publier (lorsque les fichiers servant � la
# pr�paration de ce document sont r�peartis dans une hi�rarchie du
# syst�me de fichiers).
#
# SUBDIR = style
# SUBDIR+= main
#
# # We have to set PREFIX, otherwise the switch credential mechanism
# # will break.
#
# PREFIX = ${HOME}
# WWWBASE = ${PREFIX}/Documents/www
#
# .include "www.files.mk"

# Exemple de fichier subordonn�, plac� dans l'hypoth�tique dossier
# ./style.
#
# WWW = classic.css
# WWW+= classic_sz.css
# WWW+= layout.css
# WWW+= modern.css
# WWW+= modern_sz.css
# WWW+= paragraph.css
#
# WWWDIR = ${WWWBASE}/style
#
# .include "www.files.mk"


### DESCRIPTION

# L'assistant de publication de documents WWW fournit une assistance
# pour l'installation des fichiers du document dans le syst�me de
# fichiers local.
#
# Aucune assistance pour la publication sur un syst�me de fichiers
# distant n'est actuellement assur�e par ce module, elle peut
# n�namoins �tre facilement r�alis�e � parir d'une installation dans
# le syst�me de fichier local.
#
# Si aucune des variables WWWDIR et SUBDIR n'a re�u une valeur, un
# message d'erreur est affich� et le porgramme MAKE se termine.

#
# Description des variables
#

# WWWBASE
#
#   R�pertoire racine du document cible (la version install�e).
#
#   Lorsque cette variable a une valeur, cette valeur est transmise
#   aux sous-processus MAKE, de cette fa�on elle peut �tre utilis�e
#   pour d�finir correctement WWWDIR.

# WWW, WWWOWN, WWWGRP, WWWMODE, WWWDIR
#
#   Param�tres de la proc�dure d'installation.
#
#   Ces param�tres sont document�s dans le module bps.files.mk.

# SUBDIR
#
#   Liste des sous-dossiers dans lesquels les fichiers du document
#   sont r�partis.
#
#   Ce param�tre est utilis� comme pour bps.subdir.mk.

.include "bps.init.mk"

USE_WWW_OWNERSHIP?= no

.if ${USE_WWW_OWNERSHIP} == yes
WWWOWN?= www
WWWGRP?= www
WWWMODE?= 440
.endif

FILESGROUPS+= WWW

.if !defined(WWWDIR) && (!defined(SUBDIR) || empty(SUBDIR))
.error Proper use needs a WWWDIR or SUBDIR value
.endif

.if empty(.MAKEFLAGS:MWWWBASE)
.if defined(WWWBASE)&&!empty(WWWBASE)
.MAKEFLAGS: WWWBASE='${WWWBASE}'
.endif
.endif

.include "bps.files.mk"
.include "bps.clean.mk"
.include "bps.usertarget.mk"
.include "bps.subdir.mk"

### End of file `www.files.mk'
