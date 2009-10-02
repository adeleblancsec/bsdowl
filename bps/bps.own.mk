### bps.own.mk -- Variables pour les utilisateurs, groupes, permissions ...

# Auteur: Micha�l Gr�newald
# Date: Ven 10 f�v 2006 10:40:49 GMT
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

# .include "bps.own.mk"


### DESCRIPTION


# Ce module d�finit pour ses clients des param�tres pour
# l'installation des objets, soit leur emplacement, leur propi�taire,
# leur groupe et leur droits d'acc�s.

# Pour les valeurs implictes de ces param�tes, le module distingue le
# cas de l'utilisateur root des autres. Dans le premier cas, il estime
# que `root' souahite installer des programmes pour qu'ils soient
# disponibles pour tous les utilisateurs de la machine, ce qui se
# traduit dans le choix des permissions et de PREFIX, et dans l'autre
# cas il estime que les objets sont destin�s � une utilisation priv�e,
# ce qui est �galement refl�t� par les permissions et PREFIX.

# Variable BINDIR BINOWN BINGRP BINMODE
# Ces variables d�crivent le site d'accueil BINDIR, le propri�taire
# (BINOWN, BINGRP) et les droits d'acc�s (BINMODE) pour les objets
# du groupe BIN. Les objets de ce groupe sont des objets binaires
# ex�cutables, r�sulat d'un assemblage et d'une �dition de liens, ou
# parfois un fichier interpr�t� (script).
#
# D'autres groupes sont d�finis dans ce module, soit BIN, SHARE, DOC,
# LIB, dont le nom est semble-t-il assez explicite.
#  Nota: hier(7) d�finit le type de fichier � placer dans SHAREDIR.
#  SeeAlso: bsd.own.mk, bsd.files.mk, hier(7).


### IMPL�MENTATION

.if !target(__<bps.own.mk>__)
__<bps.own.mk>__:

.if defined(UID)&&(${UID} == 0)
_OWN_DIRMODE?=	755
_OWN_BINMODE?=	555
_OWN_DTAMODE?=	444
_OWN_OWN?=	root
_OWN_GRP?=	wheel
.else
_OWN_DIRMODE?=	750
_OWN_BINMODE?=	550
_OWN_DTAMODE?=	440
_OWN_OWN?=	${USER}
_OWN_GRP?=	${GROUP}
.endif

BINDIR?=	${PREFIX}/bin
BINMODE?=	${_OWN_BINMODE}
BINOWN?=	${_OWN_OWN}
BINGRP?=	${_OWN_GRP}

LIBDIR?=	${PREFIX}/lib
LIBMODE?=	${_OWN_DTAMODE}
LIBOWN?=	${_OWN_OWN}
LIBGRP?=	${_OWN_GRP}

SHAREDIR?=	${PREFIX}/share${APPLICATIONDIR}
SHAREMODE?=	${_OWN_DTAMODE}
SHAREOWN?=	${_OWN_OWN}
SHAREGRP?=	${_OWN_GRP}

DOCDIR?=	${PREFIX}/share/doc${APPLICATIONDIR}
DOCMODE?=	${_OWN_DTAMODE}
DOCOWN?=	${_OWN_OWN}
DOCGRP?=	${_OWN_GRP}

.endif #!target(__<bps.own.mk>__)

### End of file `bps.own.mk'
