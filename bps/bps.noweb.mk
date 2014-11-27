### bps.noweb.mk -- Support literate programming with noweb

# Author: Michael Grünewald
# Date: Sam Oct  3 2009 19:10:53 CEST

# BSD Owl Scripts (https://bitbucket.org/michipili/bsdowl)
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

# USES+=		noweb
#
# NOTANGLE=		code1.c
# NOTANGLE+=		code1.h
# NOTANGLE+=		code2.c
#
# NOWEAVE=		document
# NOWEAVE_DEVICE=	latex html
#
# NOWEB=		source1.nw
# NOWEB+=		source2.nw
#
# .include "bps.init.mk"

### DESCRIPTION

# Require the use of `noweb' to produce object files described by
# input files enumerated in the NOWEB variable.
#
# The files enumerated by the NOTANGLE variable (program files) are
# produced with a call to `notangle', this is called _tangling_.
#
# The documents enumerated by the NOWEAVE variable (documentation files)
# are produced with a call to `noweave', this is called _weaving_.
#
# The variable NOWEAVE_DEVICE controls the output format of the
# weaving procedure.  If it is defined, the NOWEAVE_MASTER variable
# contains the name of the master document that wishes to include
# weaving output.


# Variables:
#
#
#  NOWEB
#   Enumerate `noweb' source files
#
#   This list is passed to `noweave' for weaving and to `notangle' for
#   tangling.
#
#   Each target in the NOWEAVE or NOTANGLE list can provide its own
#   specialised value for this variable.
#
#
#  NOTANGLE
#   Enumerate tangling target files
#
#
#  NOWEAVE_DEVICE [latex html]
#   Enumerate target devices for the documentation
#
#   Possible values are sublists of: tex latex html troff text.
#
#
#  NOWEAVE
#   Enumerate target documents
#
#
#  NOTANGLE_LINE_HINTS [not set]
#   Format to use for line hints generated by `noweave'
#
#   This variable can be set to any value acceptable by `noweave's `-L'
#   flag.  These values are described in `noweave(1)'.
#
#
#  NOTANGLE_TABS
#   Space between tab stops
#
#   If this variable is set to "yes" or an integer T then tabs are copied
#   untouched in the output and sequences of spaces are converted into
#   tabs, combining 8 or T spaces into a tabulation character.
#
#
#  NOTANGLE_FILTER
#   List of filters to be used by `notangle'
#
#   See the `-filter' option in `notangle(1)'.
#
#
#  NOTANGLE_MARKUP
#   Syntactic analyser to use on source files
#
#   See the `-markup' option in `notangle(1)'.
#
#
#  NOWEAVE_MASTER
#   Master document for `noweave's output
#
#   If this variable is set, it will prevent the generation of some
#   header and footer of the document by `noweave;.
#
#
#  NOWEAVE_CHUNKS [latex]
#   Format used by documentation chunks
#
#   This value controls the utilisation of filter converting from
#   documentation chunk format to output device format.
#
#   Possible values are: tex, latex, troff, custom.
#
#
#  NOWEAVE_FILTER
#   List of filters that shall be used by `noweave'
#
#   See the `-filter' option in `noweave(1)'.
#
#
#  NOWEAVE_MARKUP
#   Syntactic analyser to use on source files
#
#   See the `-markup' option in `noweave(1)'.
#
#
#  NOWEAVE_INDEX
#   Flag controlling the preparation of an index
#
#   It is only taken into account for output devices html and latex.
#
#
#  NOWEAVE_AUTODEFS
#   Language for which definitions should be guessed
#
#
#  NOWEAVE_HTML_CSS
#   Path to the CSS
#
#   It is only taken into account for the html output device.
#
#
#  NOWEAVE_LATEX_WRAPPER [yes]
#   Flag controlling the emission of a document wrapper
#
#   If the value of this variable is "yes", then `noweave' will wrap
#   its output into a header and footer.  You can customize this header
#   and footer with some of the `NOWEAVE_LATEX_*' and `NOWEAVE_HTML_*'
#   variables described below.
#
#   If you want to supply your own wrapper in your noweb sources, you
#   must set this variable to "delay".
#
#   If this variable  is set to another value, `noweave's output will be
#   suitable for inclusion in a larger document.
#
#   This flag controls the `-n' and `-delay' options described in
#   `noweave(1)'.
#
#
#  NOWEAVE_LATEX_DEFS
#   File containing `l2h' definitions
#
#   LaTeX files whose names are enumerated by this variable are
#   filtered to extract `l2h' definitions helping the conversion from
#   your LaTeX document into HTML.
#
#   The output file is `l2h.defs'.
#
#
#  NOWEAVE_LATEX_OPTION
#   Enumerate options for noweb LaTeX package
#
#
#  NOWEAVE_LATEX_PAGENO
#   Flag controlling decoration of cunks by page numbers
#
#   This flag controls the `-x' option of `noweave(1)'.
#
#
#  NOWEAVE_LATEX_SIMPLIFY
#   Filter used to simplify a LaTeX before processing with l2h
#
#
#  NOWEAVE_LATEX_DOCUMENTCLASS
#   LaTeX document class to be used instead of `article'
#
#   Note: this variable has only an effect if NOWEAVE_LATEX_WRAPPER
#   has been set to `yes'.
#
#
#  NOWEAVE_LATEX_PREAMBLE
#   Preamble to insert at the beginning of a LaTeX file
#
#   If the value of this variable is the name of a file, then the
#   content of this file is used as preamble, otherwise the
#   expansion of the variable is used as preamble.
#
#   Note: this variable has only an effect if NOWEAVE_LATEX_WRAPPER
#   has been set to `yes'.


### IMPLEMENTATION

.if !target(__<bps.init.mk>__)
.error bps.noweb.mk cannot be included directly.
.endif

.if !target(__<bps.noweb.mk>__)&&!empty(_USES_OPTIONS:Mnoweb)
__<bps.noweb.mk>__:

.SUFFIXES: .nw

NOWEAVE_GROUP?=		DOC
NOWEAVE_DEVICE?=	latex html
NOWEAVE_CHUNKS?=	latex
NOWEAVE_INDEX?=		yes
NOWEAVE_LATEX_WRAPPER?=	yes
#NOWEAVE_LATEX_DEFS?=
NOWEAVE_LATEX_DEFS_FILE?=l2h.defs

NOWEB_CLEAN?=		realclean

_NOTANGLE_TOOL?=	notangle
_NOWEAVE_TOOL?=		noweave
#_NOWEAVE_SED?=

_NOWEAVE_CHUNKS=	tex latex troff custom
_NOWEAVE_DEVICES=	texte tex latex troff html
#_NOWEAVE_OBJS =

_NOTANGLE_VARS=		NOWEB
_NOTANGLE_VARS+=	NOTANGLE_LINE_HINTS
_NOTANGLE_VARS+=	NOTANGLE_FILTER
_NOTANGLE_VARS+=	NOTANGLE_MARKUP
_NOTANGLE_VARS+=	_NOTANGLE_TOOL

_NOWEAVE_VARS=		NOWEB
_NOWEAVE_VARS+=		NOWEAVE_FILTER
_NOWEAVE_VARS+=		NOWEAVE_MARKUP
_NOWEAVE_VARS+=		NOWEAVE_INDEX
_NOWEAVE_VARS+=		NOWEAVE_AUTODEFS
_NOWEAVE_VARS+=		NOWEAVE_MASTER
_NOWEAVE_VARS+=		_NOWEAVE_TOOL

.for device in ${_NOWEAVE_DEVICES}
_NOWEAVE_VARS+=		_NOWEAVE_SED.${device}
.endfor

.for device in ${_NOWEAVE_DEVICES}
_NOWEAVE_SED.${device}?=${_NOWEAVE_SED}
.endfor

_NOWEAVE_FILTER.tex.tex?=
_NOWEAVE_FILTER.latex.latex?=
.if defined(NOWEAVE_LATEX_SIMPLIFY)&&!empty(NOWEAVE_LATEX_SIMPLIFY)
_NOWEAVE_FILTER.latex.html?= '${NOWEAVE_LATEX_SIMPLIFY:S/'/'\''/g} | l2h'
# Fool Emacs'
.else
_NOWEAVE_FILTER.latex.html?=l2h
.endif
_NOWEAVE_FILTER.troff.troff?=

.for chunk in ${_NOWEAVE_CHUNKS}
.for device in ${_NOWEAVE_DEVICES}
_NOWEAVE_FILTER.${chunk}.${device}?=no
.endfor
.endfor

_NOWEAVE_DEVICE.suffix.texte=	.text
_NOWEAVE_DEVICE.suffix.tex=	.tex
_NOWEAVE_DEVICE.suffix.latex=	.tex
_NOWEAVE_DEVICE.suffix.troff=	.mm
_NOWEAVE_DEVICE.suffix.html=	.html

_NOWEAVE_DEVICE.flag.texte=	-n -tex
_NOWEAVE_DEVICE.flag.tex=	-tex
_NOWEAVE_DEVICE.flag.latex=	-latex
_NOWEAVE_DEVICE.flag.troff=	-troff
_NOWEAVE_DEVICE.flag.html=	-html

.for device in ${_NOWEAVE_DEVICES}
_NOWEAVE_DEVICE.filter.${device}=\
	  ${_NOWEAVE_FILTER.${NOWEAVE_CHUNKS}.${device}}
.endfor

.for tool in NOTANGLE NOWEAVE
.for var in ${_${tool}_VARS}
#${var}?=
.endfor
.endfor

#
# Tools preparation
#


.if defined(NOTANGLE_LINE_HINTS)&&!empty(NOTANGLE_LINE_HINTS)
_NOTANGLE_TOOL+=	-L$'{NOTANGLE_LINE_HINTS}'
.endif

.if defined(NOTANGLE_TABS)&&!empty(NOTANGLE_TABS)
.if "${_NOTANGLE_TABS}" == yes
_NOTANGLE_TOOL+=	-t
.else
_NOTANGLE_TOOL+=	-t${NOTANGLE_TABS}
.endif
.endif


#
# Variables specialisation
#

.for tool in NOTANGLE NOWEAVE
.for var in ${_${tool}_VARS}
.for file in ${${tool}}
.if !defined(${var}.${file:T})
${var}.${file:T}?= ${${var}}
.endif
.endfor
.endfor
.endfor


#
# Tangling
#

.for file in ${NOTANGLE}
.if defined(NOTANGLE_MARKUP.${file:T})&&!empty(NOTANGLE_MARKUP.${file:T})
_NOTANGLE_TOOL.${file:T}+=-markup ${NOTANGLE_MARKUP.${file:T}}
.endif
.if defined(NOTANGLE_FILTER.${file:T})&&!empty(NOTANGLE_FILTER.${file:T})
_NOTANGLE_TOOL.${file:T}+=${NOTANGLE_FILTER.${file:T}:C/^/-filter /g}
.endif
${file}: ${NOWEB.${file:T}}
	${_NOTANGLE_TOOL.${file:T}} -R${.TARGET} ${.ALLSRC} | cpif ${.TARGET}
.endfor

do-clean-notangle:
	${RM} -f ${NOTANGLE}

do-${NOWEB_CLEAN}: do-clean-notangle


#
# Weaving
#

.for file in ${NOWEAVE}
.for device in ${NOWEAVE_DEVICE:Nlatex:Ntex}
${NOWEAVE_GROUP}+= ${file:T}${_NOWEAVE_DEVICE.suffix.${device}}
.endfor
.if !empty(NOWEAVE_DEVICE:Mlatex)||!empty(NOWEAVE_DEVICE:Mtex)
.if defined(NOWEAVE_MASTER.${file:T})&&!empty(NOWEAVE_MASTER.${file:T})
DOCS+= ${NOWEAVE_MASTER.${file:T}}
SRCS.${NOWEAVE_MASTER.${file:T}}+= ${file:T}${_NOWEAVE_DEVICE.suffix.latex}
.else
DOCS+=			${file:T}
.endif
.endif
.endfor


#
# Prepare tools
#
.for file in ${NOWEAVE}
.for device in ${NOWEAVE_DEVICE}
_NOWEAVE_TOOL.${device}.${file:T}?= ${_NOWEAVE_TOOL.${file:T}}
_NOWEAVE_TOOL.${device}.${file:T}+= ${_NOWEAVE_DEVICE.flag.${device}}
.if defined(NOWEAVE_MARKUP.${file:T})&&!empty(NOWEAVE_MARKUP.${file:T})
_NOWEAVE_TOOL.${device}.${file:T}+= -markup ${NOWEAVE_MARKUP.${file:T}}
.endif
.if defined(NOWEAVE_FILTER.${file:T})&&!empty(NOWEAVE_FILTER.${file:T})
_NOWEAVE_TOOL.${device}.${file:T}+= ${NOWEAVE_FILTER.${file:T}:C/^/-filter /g}
.endif
.if defined(_NOWEAVE_DEVICE.filter.${device})&&!empty(_NOWEAVE_DEVICE.filter.${device})
_NOWEAVE_TOOL.${device}.${file:T}+= -filter ${_NOWEAVE_DEVICE.filter.${device}}
.endif
.endfor
.endfor

.if defined(NOWEAVE_MASTER)&&!empty(NOWEAVE_MASTER)
NOWEAVE_LATEX_WRAPPER=	no
.endif

#
# LaTeX specific preparations
#
.if !empty(NOWEAVE_DEVICE:Mlatex)
.if ${NOWEAVE_LATEX_WRAPPER} == yes
.if defined(NOWEAVE_LATEX_PREAMBLE)&&!empty(NOWEAVE_LATEX_PREAMBLE)
.if exists(${NOWEAVE_LATEX_PREAMBLE})
_NOWEB.latex_preamble!= tr -d '\n' < ${NOWEAVE_LATEX_PREAMBLE}
.else
_NOWEB.latex_preamble!= printf "%s" "${NOWEAVE_LATEX_PREAMBLE}" | tr -d '\n'
.endif
.endif
.for file in ${NOWEAVE}
.if defined(NOWEAVE_LATEX_PREAMBLE)&&!empty(NOWEAVE_LATEX_PREAMBLE)
_NOWEAVE_SED.latex.${file:T}+= -e '1s/^\\documentclass{article}/\\documentclass{article}${_NOWEB.latex_preamble:S%\\%\\\\%g}/'
.endif
.if defined(NOWEAVE_LATEX_DOCUMENTCLASS)&&!empty(NOWEAVE_LATEX_DOCUMENTCLASS)
_NOWEAVE_SED.latex.${file:T}+= -e '1s/^\\documentclass{article}/\\documentclass{${NOWEAVE_LATEX_DOCUMENTCLASS}}/'
.endif
.endfor
.elif ${NOWEAVE_LATEX_WRAPPER} == delay
.for file in ${NOWEAVE}
_NOWEAVE_TOOL.latex.${file:T}+= -delay
.endfor
.else # ${NOWEAVE_LATEX_WRAPPER} == yes || delay
.for file in ${NOWEAVE}
_NOWEAVE_TOOL.latex.${file:T}+= -n
.endfor
.endif
.endif #!empty(NOWEAVE_DEVICE:Mlatex)

#
# HTML specific preparation
#
.if !empty(NOWEAVE_DEVICE:Mhtml)
.if defined(NOWEAVE_LATEX_DEFS)&&!empty(NOWEAVE_LATEX_DEFS)
CLEANFILES+= ${NOWEAVE_LATEX_DEFS_FILE}
${NOWEAVE_LATEX_DEFS_FILE}: ${NOWEAVE_LATEX_DEFS}
	grep '^% l2h ' ${.ALLSRC} | cpif ${.TARGET}
.for file in ${NOWEAVE}
${file}${_NOWEAVE_DEVICE.suffix.html}: ${NOWEAVE_LATEX_DEFS_FILE}
.endfor
.endif
.endif

#
# Index and autodefs
#
.for file in ${NOWEAVE}
.for device in ${NOWEAVE_DEVICE:Nlatex}
.if ${NOWEAVE_INDEX.${file:T}} == yes
_NOWEAVE_TOOL.${device}.${file:T}+= -index
.endif
.endfor
.for device in ${NOWEAVE_DEVICE:Mlatex}
.if ${NOWEAVE_INDEX.${file:T}} == yes && !(${NOWEAVE_LATEX_WRAPPER} == delay)
_NOWEAVE_TOOL.${device}.${file:T}+= -index
.endif
.endfor
.endfor

.for file in ${NOWEAVE}
.for device in ${NOWEAVE_DEVICE}
.if defined(NOWEAVE_AUTODEFS.${file:T})&&!empty(NOWEAVE_AUTODEFS.${file:T})
_NOWEAVE_TOOL.${device}.${file:T}+= -autodefs ${NOWEAVE_AUTODEFS.${file:T}}
.endif
.endfor
.endfor

#
# Document production
#
.for file in ${NOWEAVE}
.for device in ${NOWEAVE_DEVICE}
_NOWEAVE_CMD.${device}.${file} = ${_NOWEAVE_TOOL.${device}.${file:T}}
_NOWEAVE_CMD.${device}.${file}+= ${.ALLSRC}

#
# Special production rules for HTML
#
.if ${_NOWEAVE_DEVICES:M${device}} == html
_NOWEAVE_CMD.${device}.${file}+= | htmltoc
_NOWEAVE_SED.${device}.${file}+= -e 's%^<tableofcontents>$$%<div id="tableofcontents">%'
_NOWEAVE_SED.${device}.${file}+= -e 's%^</tableofcontents>$$%</div>%'
.if defined(NOWEAVE_HTML_CSS)&&!empty(NOWEAVE_HTML_CSS)
_NOWEAVE_SED.${device}.${file}+= -e '2s%</head>%<link rel="stylesheet" title="Classic" type="text/css" href="${NOWEAVE_HTML_CSS}" /></head>%'
.endif
.endif

#
# SED filter
#
.if !empty(_NOWEAVE_SED.${device}.${file:T})
_NOWEAVE_CMD.${device}.${file}+= | sed ${_NOWEAVE_SED.${device}.${file:T}}
.endif
_NOWEAVE_CMD.${device}.${file}+= | cpif ${.TARGET}
_NOWEAVE_OBJS+= ${file}${_NOWEAVE_DEVICE.suffix.${device}}
${file}${_NOWEAVE_DEVICE.suffix.${device}}: ${NOWEB.${file:T}}
	${_NOWEAVE_CMD.${device}.${file}}
.endfor
.endfor

do-clean-noweave:
	${RM} -f ${_NOWEAVE_OBJS}

do-${NOWEB_CLEAN}: do-clean-noweave

.endif #!target(__<bps.noweb.mk>__)
