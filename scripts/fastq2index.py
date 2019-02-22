'''
fastq2index.py
================

:Author: Nick Ilott
:Tags: Python

Purpose
-------

Takes a fastq file as input and outputs the barcode indexes for the reads in the form:

@header
index
+
quality

The quality is an arbitrary ascii encoded character. I give it ! as this is 0.

Usage
-----

.. Example use case

Example::

   python fastq2index.py --log=index.log

Type::

   python cgat_script_template.py --help

for command line help.

Command line options
--------------------

'''

import sys
import cgatcore.experiment as E
import cgat.Fastq as Fastq

def main(argv=None):
    """script main.
    parses command line options in sys.argv, unless *argv* is given.
    """

    if argv is None:
        argv = sys.argv

    # setup command line parser
    parser = E.OptionParser(version="%prog version: $Id$",
                            usage=globals()["__doc__"])

    # add common options (-h/--help, ...) and parse command line
    (options, args) = E.start(parser, argv=argv)

    for record in Fastq.iterate(options.stdin):
        barcode = record.identifier.split(":")[-1]
        options.stdout.write("@" + record.identifier + "\n" + barcode + "\n" + "+" + "\n" + "!"*len(barcode) + "\n")
    
    # write footer and output benchmark information.
    E.stop()

if __name__ == "__main__":
    sys.exit(main(sys.argv))
