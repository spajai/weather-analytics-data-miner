package Core;

use strict;
use warnings;
use Net::RabbitFoot;
use YAML qw (LoadFile);
use Core::DB;
use Core::RMQ;
use Core::LOG;
use FindBin qw($Bin);
use Carp;


# use Data::Dumper;
# local *Net::AMQP::RabbitMQ::send_data_to_rmq = sub { die;};


# use lib dirname($Bin);
use lib '../lib';
sub new {
    my $class = shift;
    my $self = {};
    bless ($self, $class);

    $self->{config} = LoadFile('../config/configuration.yaml');
    _check_requires($self); 
    _validate_conf($self); #requirements pass

    return $self;
}

sub destroy {
    my $self = shift;
    return $self = {};
}

sub connect_db {
    my $db = Core::DB->new(shift);
    return $db->connect_db();
}

sub connect_rabbitmq {
    my $rmq = Core::RMQ->new(shift);
    return $rmq->connect_rabbitmq();
    # return Core::RMQ->new(@_)->connect_rabbitmq();
}

sub internet_connected {


}

sub _validate_conf {
    #check if required values passed are correct
    my $self = shift;
    my $config = $self->{config};
    my $db_cfg = $config->{Mongoconfig};
    my $api_cfg = $config->{api};
    my $rmq_cfg = $config->{Rabbitmq};
    my $pub_cnf = $rmq_cfg->{publish_conf};
    my $q_cnf = $rmq_cfg->{queue_conf};
    my $ex_cnf = $rmq_cfg->{exchange_conf};

    #set default if config values not present
    #Don't bother if user has provided the DSN
    if (!$db_cfg->{dsn}) {
        $db_cfg->{host} ||= 'localhost';
        $db_cfg->{port} ||= '27017';
        $db_cfg->{db_name} ||= 'local';
        $db_cfg->{default_username} ||= 'admin';  #default
        $db_cfg->{default_password} ||= 'pass';   #default
        delete $db_cfg->{username} if (!defined $db_cfg->{username});
        delete $db_cfg->{password} if (!defined $db_cfg->{password});
    }
    #delete undef
    delete @{$rmq_cfg}              { grep { ! defined $rmq_cfg->{$_} }               keys %$rmq_cfg };
    delete @{$pub_cnf->{options}}   { grep { ! defined $pub_cnf->{options}->{$_} }    keys %{$pub_cnf->{options}}};
    delete @{$pub_cnf->{properties}}{ grep { ! defined $pub_cnf->{properties}->{$_} } keys %{$pub_cnf->{properties}}};
    delete @{$q_cnf->{options}}     { grep { ! defined $q_cnf->{options}->{$_} }      keys %{$q_cnf->{options}}};
    delete @{$ex_cnf->{options}}    { grep { ! defined $ex_cnf->{options}->{$_} }     keys %{$ex_cnf->{options}}};
    #Delete empty hash
    delete $pub_cnf->{options}      if (! scalar keys %{$pub_cnf->{options}} );
    delete $pub_cnf->{properties}   if (! scalar keys %{$pub_cnf->{properties}} );
    delete $rmq_cfg->{publish_conf} if (! scalar keys %{$rmq_cfg->{publish_conf}});
    delete $q_cnf->{options}        if (! scalar keys %{$q_cnf->{options}});
    delete $rmq_cfg->{queue_conf}   if (! scalar keys %{$rmq_cfg->{queue_conf}});
    delete $ex_cnf->{options}       if (! scalar keys %{$ex_cnf->{options}});
    delete $ex_cnf->{options}       if (! scalar keys %{$ex_cnf->{options}});
    delete $rmq_cfg->{exchange_conf}if (! scalar keys %{$rmq_cfg->{exchange_conf}});
    #set rabbitmq 
    $rmq_cfg->{host} ||= 'localhost';
    $rmq_cfg->{port} ||= '5672';
    $rmq_cfg->{vhost} ||= '/';
    $rmq_cfg->{user} ||= 'guest'; #default
    $rmq_cfg->{password} ||= 'guest'; #default
    return;
}
sub _check_requires {
    my $self = shift;
    croak "No Config Found" unless (exists $self->{config});
    my $config = $self->{config};

    croak "No configuration file found" unless (-e '../config/configuration.yaml');
    croak "RabbitMq configuration not Found under Rabbitmq key" if (!defined $config->{Rabbitmq} && exists $config->{Rabbitmq});
    croak "Api configuration not Found under api key" if (!(defined $config->{api} && exists $config->{api}));
    croak "MongoDB configuration not Found under key Mongoconfig" if (! (defined $config->{Mongoconfig} && exists $config->{Mongoconfig}));

#check the required modules version
#check librabry
#rmq
#mongo
    return;

}




1;