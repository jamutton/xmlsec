#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=. 

THEDIR=`pwd`
cd $srcdir
DIE=0

(autoconf --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have autoconf installed to compile xmlsec."
	DIE=1
}

(libtool --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have libtool installed to compile xmlsec."
	DIE=1
}

(autoheader --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have autoheader installed to compile xmlsec."
	DIE=1
}

(autoconf --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have autoconf installed to compile xmlsec."
	DIE=1
}
(automake --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have automake installed to compile xmlsec."
	DIE=1
}

if test "$DIE" -eq 1; then
	exit 1
fi

test -f include/xmlsec/xmldsig.h  || {
	echo "You must run this script in the top-level xmlsec directory"
	exit 1
}

echo "Running libtoolize..."
libtoolize --copy --force
if [ "$?" != "0" ] ; then echo "Error running libtoolize" ; exit 1 ; fi
echo "Running aclocal..."
aclocal --force -I m4
if [ "$?" != "0" ] ; then echo "Error running aclocal" ; exit 1 ; fi
echo "Running autoheader..."
autoheader --force
if [ "$?" != "0" ] ; then echo "Error running autoheader" ; exit 1 ; fi
echo "Running autoconf..."
autoconf --force
if [ "$?" != "0" ] ; then echo "Error running autoconf" ; exit 1 ; fi
echo "Running automake..."
automake --gnu --add-missing
if [ "$?" != "0" ] ; then echo "Error running automake" ; exit 1 ; fi
echo "Running autoconf..."
autoconf
if [ "$?" != "0" ] ; then echo "Error running autoconf" ; exit 1 ; fi

cd $THEDIR

if test x$OBJ_DIR != x; then
    mkdir -p "$OBJ_DIR"
    cd "$OBJ_DIR"
fi

conf_flags="--enable-maintainer-mode" #--enable-iso-c
echo Running configure $conf_flags "$@" ...
$srcdir/configure $conf_flags "$@"

echo 
echo "... you may now use ./configure"
echo " don't forget --enable-maintainer-mode was run by default before"
echo " then type 'make' to compile xmlsec."
