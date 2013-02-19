#!/bin/bash

set -e

_check()
{
    [ "$(git-qseries | tr -d '\n')" = "$1" ]
    [ "$(git-qapplied | tr -d '\n')" = "$2" ]
    [ "$(git-qunapplied | tr -d '\n')" = "$3" ]
    [ "$(cat a)" = "$4" ]

    if [ "$(git-qnext)" != "" ]; then
	git-qshow | git apply
	git reset --hard
    fi
}

PATH="..:$PATH"

mkdir tmp
cd tmp

# create a test repository
git init
touch a
git add a
git commit -a -m a
for i in 1 2 3; do
    echo patch$i > a
    git commit -a -m patch$i
done
git branch backup

git-qinit

# check git-qrevert
git-qrevert master^^^
for i in 1 2 3; do
    git-qrename "${i}_patch$i" "$i"
done
_check "123" "" "123" ""

git-qpush
_check "123" "1" "23" "patch1"
git-qcommit
git-qrevert master^
git-qrename "patch1" "1"
_check "123" "" "123" ""

git-qpop
_check "123" "" "123" ""

git-qpush
git-qpush
git-qcommit
_check "3" "" "3" "patch2"

# check git-qpick
git reset master^^ --hard
git-qpick backup^
git-qrename "patch2" "2"
git-qpick backup^^
git-qrename "patch1" "1"
tac .git/patches/master/series > .git/patches/master/series.tmp
mv .git/patches/master/series.tmp .git/patches/master/series
_check "123" "" "123" ""

git-qpush
git-qpush
git-qpush
_check "123" "123" "" "patch3"
git-qcommit
_check "" "" "" "patch3"

# check git-qimport
git format-patch -3
git-qimport *.patch
git reset master^^^ --hard
for i in 1 2 3; do
    git-qrename "${i}_patch$i" "$i"
done
git-qpush
git-qpush
git-qpush
_check "123" "123" "" "patch3"

# cleanup
cd ..
rm -rf tmp

echo "** Passed **"
