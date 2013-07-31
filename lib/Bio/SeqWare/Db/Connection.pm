package Bio::SeqWare::Db::Connection;

use 5.008;         # No reason, just being specific. Update your per.!
use strict;        # Don't allow unsafe perl constructs.
use warnings;      # Enable all optional warnings.
use Carp;          # Base the locations of reported errors on caller's code.
use DBI;           # DBI
use DBD::Pg;       # Postgres driver, required as assuming postgres back-end

=head1 NAME

Bio::SeqWare::Db::Connection - Grab new SeqWare database connections easily.

=cut

=head1 VERSION

Version 0.000.001

=cut

our $VERSION = '0.000001';

=head1 SYNOPSIS

    use Bio::SeqWare::Db::Connection;

    # Setting connection with parameters from the SeqWare config file
    my $swConfigObj = Bio::SeqWare::Config->new();
    my $swConnectionBuilder = Bio::SeqWare::Db::Connection->new( $swConfigObj );
    my $dbh = $swConnectionBuilder->getConnection();

    # Setting connection with manual parameters
    my $paramHR = { 'dbUser'     => "USER",
                    'dbPassword' => "PASSWORD",
                    'dbHost      => "MY.HOST.NAME_OR_ADDRESS"
                    'dbSchema    => "MY_DB_SCHEMA_NAME"
    };
    my $swConnectionBuilder = Bio::SeqWare::Db::Connection->new( $paramHR );
    my $dbh = $swConnectionBuilder->getConnection();

=cut

=head1 DESCRIPTION

This module serves as an interface between DBI and the SeqWare system to allow
connections to be obtainined easily given the settings in a SeqWare
config file. This avoids some of the boilerplate code in scripts and localizes
future changes. Most implortantly, it removes passwords from scripts.

Does not currently support any getter or setter
methods for the connection information, any management of the handle after
creation, or any database other than postgres.

=cut

=head1 CLASS METHODS

=cut

=head2 new( ... )

    my $swDbManager = new( $swConfigFileObject );
    my $swDbManager = new( $paramHR );

Creates and returns a C<Bio::SeqWare::Db::Connection> object to generate database
handles for accessing a postgres-hosted SeqWare database. After creating this
manager object, can then call C<< $swDbManager->getConnection() >> to create a normal
DBI database connection handle.

Regardless of whether the C<Bio::SeqWare::Config> object or a C<$paramHR>
hash-ref is used to provide connection information, the four keys
C<qw( dbUser dbPassword dbHost dbSchema )> are required. If any are undefined,
a fatal error occurs. The ability to actually create a connection
is not validated, just that some attempt was made to provide the required info.

=cut

sub new {
    my $class = shift;
    my $connectInfo = shift;
    my $self = {};
    if (ref $connectInfo eq "Bio::SeqWare::Config") {
        $self->{'_dbUser'}     = $connectInfo->get('dbUser');
        $self->{'_dbPassword'} = $connectInfo->get('dbPassword');
        $self->{'_dbSchema'}     = $connectInfo->get('dbSchema');
        $self->{'_dbHost'}     = $connectInfo->get('dbHost');
    }
    elsif (ref $connectInfo eq "HASH") {
        $self->{'_dbUser'}     = $connectInfo->{'dbUser'};
        $self->{'_dbPassword'} = $connectInfo->{'dbPassword'};
        $self->{'_dbSchema'}   = $connectInfo->{'dbSchema'};
        $self->{'_dbHost'}     = $connectInfo->{'dbHost'};
    }
    else {
        croak( "Error: Hash-ref or Bio::SeqWare::Config object parameter required." );
    }

    # Validate data, minimally.
    if (! $self->{'_dbUser'}) {
        croak( "Error: \"dbUser\" not defined" );
    }
    if (! $self->{'_dbPassword'}) {
        croak( "Error: \"dbPassword\" not defined." );
    }
    if (! $self->{'_dbSchema'}) {
        croak( "Error: \"dbSchema\" not defined." );
    }
    if (! $self->{'_dbHost'}) {
        croak( "Error: \"dbHost\" not defined." );
    }

    bless $self, $class;
    return $self;
}

=head1 INSTANCE METHODS

=cut

=head2 getConnection

    my $dbh = $dbManager->getConnection();

Returns a normal DBI Connection handle that can be used to work with the
database. This handle is configured to AutoCommit and to RaiseError.

Future versions may allow providing parameters.

=cut

sub getConnection {
    my $self = shift;

    my $dbn = "DBI:Pg:dbname=$self->{'_dbSchema'};host=$self->{'_dbHost'}";
    my $dbh=DBI->connect(
        $dbn,
        $self->{'_dbUser'},
        $self->{'_dbPassword'},
        {RaiseError => 1, AutoCommit => 1}
    );

    # Guard code: this should not run as above should be fatal on bad connections
    if (! $dbh) {
        croak "Could not connect to the database: $!";
    }

     return $dbh
}

=head1 AUTHOR

Stuart R. Jefferys, C<srjefferys (at) gmail (dot) com>

=cut

=head1 CONTRIBUTING

This module is developed and hosted on GitHub, at
L<p5-Bio-SeqWare-Db-Connection | 
https://github.com/theobio/p5-Bio-SeqWare-Db-Connection>. It
is not currently on CPAN, and I don't have any immediate plans to post it
there unless requested by core SeqWare developers (It is not my place to
set out a module name hierarchy for the project as a whole :)

=cut

=head1 INSTALLATION

You can install a version of this module directly from github using

    $ cpanm git://github.com/theobio/p5-Bio-SeqWare-Db-Connection.git@v0.000.001

Any version can be specified by modifying the tag name, following the @;
the above installs the latest I<released> version. If you leave off the @version
part of the link, you can install the bleading edge pre-release, if you don't
care about bugs...

You can select and download any package for any released version of this module
directly from L<https://github.com/theobio/p5-Bio-SeqWare-Db-Connection/releases>.
Installing is then a matter of unzipping it, changing into the unzipped
directory, and then executing the normal (C>Module::Build>) incantation:

     perl Build.PL
     ./Build
     ./Build test
     ./Build install

=cut

=head1 BUGS AND SUPPORT

No known bugs are present in this release. Unknown bugs are a virtual
certainty. Please report bugs (and feature requests) though the
Github issue tracker associated with the development repository, at:

L<https://github.com/theobio/p5-Bio-SeqWare-Db-Connection/issues>

Note: you must have a GitHub account to submit issues.

=cut

=head1 ACKNOWLEDGEMENTS

This module was developed for use with L<SegWare | http://seqware.github.io>.

=cut

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Stuart R. Jefferys.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

=cut


1; # End of Bio::SeqWare::Db::Connection
