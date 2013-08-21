use 5.008;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Bio::SeqWare::Db::Connection',
    license             => 'gpl',
    dist_author         => q{Stuart R. Jefferys <srjefferys (at) gmail (dot) com>},
    dist_version_from   => 'lib/Bio/SeqWare/Db/Connection.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl'                 => '0.008',
        'Bio::SeqWare::Config' => '0.000001',
        'DBI'                  => 0,
        'DBD::Pg'              => 0,
    },
    add_to_cleanup     => [ 'p5-Bio-SeqWare-Db-Connection-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
