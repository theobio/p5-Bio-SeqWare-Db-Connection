# NAME

Bio::SeqWare::Db::Connection - Grab new SeqWare database connections easily.

# VERSION

Version 0.000.002

# SYNOPSIS

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

# DESCRIPTION

This module serves as an interface between DBI and the SeqWare system to allow
connections to be obtainined easily given the settings in a SeqWare
config file. This avoids some of the boilerplate code in scripts and localizes
future changes. Most implortantly, it removes passwords from scripts.

Does not currently support any getter or setter
methods for the connection information, any management of the handle after
creation, or any database other than postgres.

# CLASS METHODS

## new( ... )

    my $swDbManager = new( $swConfigFileObject );
    my $swDbManager = new( $paramHR );

Creates and returns a `Bio::SeqWare::Db::Connection` object to generate database
handles for accessing a postgres-hosted SeqWare database. After creating this
manager object, can then call `$swDbManager->getConnection()` to create a normal
DBI database connection handle.

Regardless of whether the `Bio::SeqWare::Config` object or a `$paramHR`
hash-ref is used to provide connection information, the four keys
`qw( dbUser dbPassword dbHost dbSchema )` are required. If any are undefined,
a fatal error occurs. The ability to actually create a connection
is not validated, just that some attempt was made to provide the required info.

# INSTANCE METHODS

## getConnection

    my $dbh = $dbManager->getConnection();
    my $dbh = $dbManager->getConnection( { RaiseError => 1,
                                           AutoCommit => 1, } );

Returns a normal DBI Connection handle that can be used to work with the
database. DBI options can be passed as a parameter, by default to provided
handle is configured to AutoCommit and to RaiseError.

# AUTHOR

Stuart R. Jefferys, `srjefferys (at) gmail (dot) com`

# CONTRIBUTING

This module is developed and hosted on GitHub, at
[p5-Bio-SeqWare-Db-Connection ](http://search.cpan.org/perldoc?https:#/github.com/theobio/p5-Bio-SeqWare-Db-Connection). It
is not currently on CPAN, and I don't have any immediate plans to post it
there unless requested by core SeqWare developers (It is not my place to
set out a module name hierarchy for the project as a whole :)

# INSTALLATION

You can install a version of this module directly from github using

      $ cpanm git://github.com/theobio/p5-Bio-SeqWare-Db-Connection.git@v0.000.002
    or
      $ cpanm https://github.com/theobio/p5-Bio-SeqWare-Db-Connection/archive/v0.000.002.tar.gz

Any version can be specified by modifying the tag name, following the @;
the above installs the latest _released_ version. If you leave off the @version
part of the link, you can install the bleading edge pre-release, if you don't
care about bugs...

You can select and download any package for any released version of this module
directly from [https://github.com/theobio/p5-Bio-SeqWare-Db-Connection/releases](https://github.com/theobio/p5-Bio-SeqWare-Db-Connection/releases).
Installing is then a matter of unzipping it, changing into the unzipped
directory, and then executing the normal (C>Module::Build>) incantation:

     perl Build.PL
     ./Build
     ./Build test
     ./Build install

# BUGS AND SUPPORT

No known bugs are present in this release. Unknown bugs are a virtual
certainty. Please report bugs (and feature requests) though the
Github issue tracker associated with the development repository, at:

[https://github.com/theobio/p5-Bio-SeqWare-Db-Connection/issues](https://github.com/theobio/p5-Bio-SeqWare-Db-Connection/issues)

Note: you must have a GitHub account to submit issues.

# ACKNOWLEDGEMENTS

This module was developed for use with [SegWare ](http://search.cpan.org/perldoc?http:#/seqware.github.io).

# LICENSE AND COPYRIGHT

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
