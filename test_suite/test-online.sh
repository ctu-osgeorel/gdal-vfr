#!/bin/sh

DB=vfr
DATE="20140430"

if test -z "$1" ; then
    PGM="pg"
    OPT="--dbname $DB"
else
    if [ "$1" = "ogr" ] ; then
        PGM="ogr"
        OPT="--format PostgreSQL --dsn PG:dbname=$DB"
    else
        PGM="oci"
        OPT="--user test --passwd test"
    fi
fi

if [ "PGM" != "oci" ] ; then
    psql -d $DB -f cleandb.sql 2>/dev/null
fi

echo "Using vfr2${PGM}..."

# first pass (empty DB)
echo "First pass (empty DB...)"
../vfr2${PGM}.py --date $DATE --type OB_564729_UKSH $OPT

# second pass (already exists)
echo "Second pass (already exists...)"
../vfr2${PGM}.py --date $DATE --type OB_564729_UKSH $OPT

# third pass (overwrite)
echo "Third pass (overwrite...)"
../vfr2${PGM}.py --date $DATE --type OB_564729_UKSH $OPT --o

if [ "$PGM" = "pg" ] ; then
    echo "Fourth pass (schema per file...)"
    ../vfr2${PGM}.py --date $DATE --type OB_564729_UKSH $OPT -s
fi

exit 0