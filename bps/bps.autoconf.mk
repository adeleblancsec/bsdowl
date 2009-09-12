### bps.autoconf.mk -- Support pour AUTOCONF

# Author: Micha�l Le Barbier Gr�newald
# Date: Ven 18 avr 2008 09:59:39 CEST
# Lang: fr_FR.ISO8859-1

# $Id$

# Copyright (c) 2008, 2009 Micha�l Le Barbier Gr�newald
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

# CONFIGURE = Makefile.in
# CONFIGURE+= header.in
# .include "bps.autoconf.mk"

### DESCRIPTION

# Si un fichier `configure.ac' ou `configure.in' figure dans notre dossier, ou
# si la variable USE_AUTOCONF est positionn�e � `yes' alors les fichiers
# objets associ�s aux fichiers �num�r�s dans la variable
# CONFIGURE sont ajout�s aux listes de nettoyage `distclean'.


#
# Description des variables
#

# USE_AUTOCONF 
#
#  Contr�le l'utilisation des services du module `bps.autoconf.mk'. Si cette
#  variable n'est pas d�finie par l'utilisateur et que des traces de
#  l'utilisation d'autoconf par le projet sont trouv�es, cette variable est
#  positionn�e � `yes'.

# CONFIGURE
#
#  �num�re les sources trait�es par le script `configure'. Les fichiers objets
#  produits par `autoconf' correspondant � ces sources sont ajout�s �
#  DISTCLEANFILES.
#
#  Si ils existent, les fichiers `Makefile.in' et `Makefile.inc.in' sont
#  automatiquement ajout�s � cette �num�ration.

.if !target(__<bps.autoconf.mk>__)
__<bps.autoconf.mk>__:

.if exists(configure.ac)||exists(autoconf.in)
USE_AUTOCONF?=yes
.endif
USE_AUTOCONF?=no
.if ${USE_AUTOCONF} == yes
.for file in config.status config.log
.if exists(${file})
DISTCLEANFILES+= ${file}
.endif
.endfor
.if exists(autom4te.cache)
DISTCLEANDIRS+= autom4te.cache
.endif
CONFIGURE?=
.for file in Makefile.in Makefile.inc.in
.if exists(${file})&&empty(CONFIGURE:M${file})
CONFIGURE+= ${file}
.endif
.endfor
REALCLEANFILES+= ${CONFIGURE:.in=}
.if exists(configure.ac)||exists(configure.in)
.if !defined(REALCLEANFILES)||empty(REALCLEANFILES:Mconfigure)
REALCLEANFILES+= configure
.endif
.endif
.endif # ${USE_AUTOCONF} == yes
.endif # !target(__<bps.autoconf.mk>__)

### End of file `bps.autoconf.mk'
