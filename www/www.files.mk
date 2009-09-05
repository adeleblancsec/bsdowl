### www.files.mk -- A bps.files.mk wrapper for my www

# Author: Micha�l Le Barbier Gr�newald
# Date: Jeu 13 mar 2008 21:58:28 CET
# Lang: fr_FR.ISO8859-15

# $Id$

# Copyright (c) 2006, 2007, 2008, 2009 Micha�l Le Barbier Gr�newald
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

# Exemple de fichier ma�tre, plac� dans le r�pertoire principal du
# document WWW � publier (lorsque les fichiers servant � la
# pr�paration de ce document sont r�peartis dans une hi�rarchie du
# syst�me de fichiers).
#
# SUBDIR = style
# SUBDIR+= main
#
# WWWBASE = ${HOME}/Documents/www
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

FILESGROUPS+= WWW

.if !defined(WWWDIR) && (!defined(SUBDIR) || empty(SUBDIR))
.error Proper use needs a WWWDIR or SUBDIR value
.endif

WWWOWN?= www
WWWGRP?= www
WWWMODE?= 440

.if empty(.MAKEFLAGS:MWWWBASE)
.if defined(WWWBASE)&&!empty(WWWBASE)
.MAKEFLAGS: WWWBASE=${WWWBASE}
.endif
.endif

.include "bps.files.mk"
.include "bps.subdir.mk"

### End of file `www.files.mk'
