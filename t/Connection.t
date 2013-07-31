#! /usr/bin/env perl

use Carp;                 # Caller-relative error messages
use Bio::SeqWare::Config; # SeqWare settings

use Test::More 'tests' => 1 + 3;   # Main testing module; run this many subtests
                                   # in BEGIN + subtests (subroutines).

# Note: Author tests require a valid ~/seqware/settings file and the ability
# to connect to a postgress database using the settings from that file, for
# live testing.

if ( ! $ENV{'RELEASE_TESTING'} ) {
	    diag( 'Skipping 2 author-only tests' );
    }

BEGIN {
	use_ok( 'Bio::SeqWare::Db::Connection' );
}

my $CLASS = 'Bio::SeqWare::Db::Connection';

my $CONFIG_FILE_OBJ = Bio::SeqWare::Config->new();

my $CONNECT_INFO_HR = {
    'dbUser'      => $CONFIG_FILE_OBJ->get('dbUser'),
    'dbPassword'  => $CONFIG_FILE_OBJ->get('dbPassword'),
    'dbSchema'    => $CONFIG_FILE_OBJ->get('dbSchema'),
    'dbHost'      => $CONFIG_FILE_OBJ->get('dbHost'),
};

my $DB_FROM_CONFIG;
my $DB_FROM_INFO;
if ( $ENV{'RELEASE_TESTING'} ) {
    $DB_FROM_CONFIG = $CLASS->new( $CONFIG_FILE_OBJ );
    $DB_FROM_INFO   = $CLASS->new( $CONNECT_INFO_HR );
}

subtest( 'new()' => \&testNew );
subtest( 'new(BAD)' => \&testNewBAD );
subtest( 'getGetConnection()' => \&testGetConnection );

sub testNew {
    if ( $ENV{'RELEASE_TESTING'} ) {
	    plan( tests => 2 );
    }
    else {
        plan( skip_all => 'Author test only, run if RELEASE_TESTING set' );
    }

	{
	    ok($DB_FROM_CONFIG, "New from config file object");
	}
	{
	    ok($DB_FROM_INFO, "New from info hash-ref");
	}
}

sub testNewBAD {
	plan( tests => 5 );
    {
        my $badConnectInfo = {
            'dbUser'      => "",
            'dbPassword'  => "TEST",
            'dbSchema'    => "TEST",
            'dbHost'      => "TEST",
        };
        eval{ $CLASS->new( $badConnectInfo ); };
        $got = $@;
        $want = qr/^Error\: \"dbUser\" not defined/;
        like( $got, $want, "error on missing dbUser");
    }
    {
        my $badConnectInfo = {
            'dbUser'      => "TEST",
            'dbPassword'  => undef,
            'dbSchema'    => "TEST",
            'dbHost'      => "TEST",
        };
        eval{ $CLASS->new( $badConnectInfo ); };
        $got = $@;
        $want = qr/^Error\: \"dbPassword\" not defined/;
        like( $got, $want, "error on missing dbPassword");
    }
    {
        my $badConnectInfo = {
            'dbUser'      => "TEST",
            'dbPassword'  => "TEST",
            'dbSchema'    => 0,
            'dbHost'      => "TEST",
        };
        eval{ $CLASS->new( $badConnectInfo ); };
        $got = $@;
        $want = qr/^Error\: \"dbSchema\" not defined/;
        like( $got, $want, "error on missing dbSchema");
    }
    {
        my $badConnectInfo = {
            'dbUser'      => "TEST",
            'dbPassword'  => "TEST",
            'dbSchema'    => "TEST",
            'dbHost'      => "",
        };
        eval{ $CLASS->new( $badConnectInfo ); };
        $got = $@;
        $want = qr/^Error\: \"dbHost\" not defined/;
        like( $got, $want, "error on missing dbHost");
    }
    {
        eval{ $CLASS->new(); };
        $got = $@;
        $want = qr/^Error\: Hash-ref or Bio\:\:SeqWare\:\:Config object parameter required\./;
        like( $got, $want, "error on missing param");
    }
}

sub testGetConnection {
    if ( $ENV{'RELEASE_TESTING'} ) {
	    plan( tests => 2 );
    }
    else {
        plan( skip_all => 'Author test only, run if RELEASE_TESTING set' );
    }

	{
        my $dbh = $DB_FROM_CONFIG->getConnection();
        ok( $dbh, "Connection from config-based db object");
        $dbh->disconnect();
	}
	{
        my $dbh = $DB_FROM_INFO->getConnection();
        ok( $dbh, "Connection from hash-ref-based db object");
        $dbh->disconnect();
	}
}
