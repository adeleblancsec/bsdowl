#!/bin/sh

# $Id$

echo 'We prepare a new makefile'
read -p 'filename: ' FILENAME
read -p 'comment: ' COMMENT
DATE=`date`

m4 -g\
    -D __FILENAME__="${FILENAME}" \
    -D __COMMENT__="${COMMENT}" \
    -D __DATE__="${DATE}" \
    -D __YEAR__="${YEAR}" \
    > ${FILENAME} <<'EOF'
changecom()dnl
changequote(,)dnl
### __FILENAME__ -- __COMMENT__

# Author: Micha�l Le Barbier Gr�newald
# Date: __DATE__
# Lang: fr_FR.ISO8859-1

# $Id$

# Copyright (c) 2009 Micha�l Le Barbier Gr�newald
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

### DESCRIPTION

.if !target(__<__FILENAME__>__)
__<__FILENAME__>__:

.endif # !target(__<__FILENAME__>__)

### End of file `__FILENAME__'
EOF
