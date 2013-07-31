#! /usr/bin/env perl

use 5.008;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Bio::SeqWare::Db::Connection' ) || print "Bail out!\n";
}

diag( "Testing Bio::SeqWare::Db::Connection $Bio::SeqWare::Db::Connection::VERSION, Perl $], $^X" );
