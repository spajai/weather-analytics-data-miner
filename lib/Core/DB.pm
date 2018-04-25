package Core::DB;

use strict;
use warnings;
use utf8;

use File::Basename;
use FindBin qw($Bin);
use lib dirname($Bin) . '../../lib';
use MongoDB;
use Carp;
use parent qw(Core);

sub new {
    my $class = shift;
    my $base = $class->SUPER::new();
    return bless ($base , $class);
}

sub connect_db {
    my $self = shift;
    my $db_options = $self->{config}->{Mongoconfig};
    croak "Mongoconfig not found" unless ($db_options);
    my $def_pass = delete $db_options->{default_username};
    my $def_user = delete $db_options->{default_password};
    my $dsn = $db_options->{dsn} || '';
    my %option;

    if ($dsn ne '') {
        $self->{_db} = MongoDB->connect($dsn) || croak "Unable to connect to MongoDB";
    } else {
        if (! $db_options->{host} =~ /^mongodb:\/\//) {
            $dsn = 'mongodb://';
        }
        $dsn .= $db_options->{host};

        foreach  my $key (sort keys %{$db_options}) {
            $option{$key} = $db_options->{$key} if($db_options->{$key} ne '');
        }

        $self->{_db} =  MongoDB::MongoClient->new(%option) || croak "Unable to connect to MongoDB";
    }
    return $self;
}

1;