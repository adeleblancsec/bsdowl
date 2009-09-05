### ocaml.searches.mk -- D�termination du chemin de recherche

# Author: Micha�l Le Barbier Gr�newald
# Date: Sam  7 jul 2007 20:26:31 CEST
# Lang: fr_FR.ISO8859-1

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

# Ce module calcule la variable _OCAML_SEARCHES, c'est une liste
# d'options pouvant �tre pass�e en argument des outils de compilation
# OCAML.
#
# Ce module n'est pas destin� � l'usager.

# SEARCHES+= ../library
#
# .include "ocaml.init.mk"
# .include "ocaml.searches.mk"


### DESCRIPTION

# SEARCHES
#  Liste de dossiers � consulter pour trouver les fichiers `cmi',
#  `cmo', `cmx', `cma' et `cmxa'. Les termes de la liste sont exprim�s
#  relativement � .OBJDIR.


.if !target(__<ocaml.searches.mk>__)
__<ocaml.searches.mk>__:

.if defined(SEARCHES)&&!empty(SEARCHES)
_OCAML_SEARCHES=${SEARCHES:C/^/-I /}
# Les fichiers necessitant une recherche op�r�e par MAKE sont ceux
# dont les suffixes sont: .cmo .cma .cmx .cmxa et .a. Les fichiers
# dont le suffixe est .cmi n'apparaissent pas sur la ligne de
# commande.
#.PATH.cmi: ${SEARCHES}
.PATH.cmo: ${SEARCHES}
.PATH.cmx: ${SEARCHES}
.PATH.cmxa: ${SEARCHES}
.PATH.cma: ${SEARCHES}
.PATH.a: ${SEARCHES}
.PATH.o: ${SEARCHES}
.endif

.if defined(_OCAML_SEARCHES) && !empty(_OCAML_SEARCHES)
.for tool in MLCI MLCB MLCN MLLB MLLN
${tool}FLAGS+=${_OCAML_SEARCHES}
.endfor
.endif

.endif # !target(__<ocaml.searches.mk>__)

### End of file `ocaml.searches.mk'
