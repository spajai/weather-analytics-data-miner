package Core::RMQ;
use strict;
use warnings;
use utf8;

use Data::Dumper;
use strict;

use File::Basename;
use FindBin qw($Bin);
use lib dirname($Bin) . '../../lib';
use Carp;
require Core;
use parent qw(Core);
# use base qw(Core);
# extends 'Core';
use Net::AMQP::RabbitMQ;
use Net::RabbitMQ::Management::API;

sub new {
    my $class = shift;
    my $base = $class->SUPER::new();
    return bless($base,$class);
}

sub connect_rabbitmq {
    my $self = shift;

    my $rmq_options = $self->{config}->{Rabbitmq};
    croak "Rabbitmq options not found" unless ($rmq_options);
    $self->{_rmq} = Net::AMQP::RabbitMQ->new();
    croak "RabbitMQ host missing" unless ($rmq_options->{host});
    my $rmq_conf = $self->{config}->{Rabbitmq};
    my $channel  = $rmq_conf->{channel} || 1;

    my %option;
    foreach  my $key (sort keys %{$rmq_options}) {
        next unless (defined $rmq_options->{$key} && exists $rmq_options->{$key});
        $option{$key} = $rmq_options->{$key} if($rmq_options->{$key} ne '');
    }

    eval {
        my $connection  = $self->{_rmq}->connect($rmq_options->{host},\%option ); 
         # $self->{_rmq}->connect($rmq_options->{host},\%option ); 
        $self->{_rmq}->channel_open($channel);
        # return $self if ($connection);
        
    }; 
    if ($@){
        croak "Unble to connect to RabbitMQ Server ERROR '$@'";
    }
    return $self;
}

sub is_connected {
    my $self = shift;
    return $self->{_rmq}->is_connected();
}

sub is_received {
    my $self = shift;
    my $t = shift || 0;
    return$self->{_rmq}->recv($t);
}

sub send_data_to_rmq {
    my  $self =  shift;
    my $message = shift;
    #set safe options and user preferances
    $self->_set_rmq_options();

    my $rmq_conf = $self->{config}->{Rabbitmq};
    my $channel  = $rmq_conf->{channel} || 1;
    my $exchange = $rmq_conf->{exchange};
    my $routing_key = $rmq_conf->{routing_key};
    my $queue = $rmq_conf->{queue};
    my $queue_option = $rmq_conf->{queue_conf}->{options};
    my $exchange_option = $rmq_conf->{exchange_conf}->{options};
    my $publish_options = $rmq_conf->{publish_conf}->{options};
    my $publish_properties = $rmq_conf->{publish_conf}->{properties};
    my $publish = 0;
    eval {
        if ($self->{_rmq}->is_connected()) {
            $self->{_rmq}->exchange_declare($channel, $exchange, $exchange_option);
            $self->{_rmq}->queue_declare($channel, $queue, $queue_option);  
            $self->{_rmq}->queue_bind($channel, $queue, $exchange, $routing_key);
            $self->{_rmq}->publish($channel, $routing_key, $message, $publish_options, $publish_properties);
            $publish = 1;
        }
    };
    if ($@){
        croak "RabbitMQ Publishing Error '$@'";
    }
    return $publish;
}

sub _set_rmq_options {
    my $self = shift;
    croak "RabbitMq Configuration Missing" unless ($self->{config}->{Rabbitmq});
    my $rmq_cfg = $self->{config}->{Rabbitmq};

    #default mq setting
    $rmq_cfg->{routing_key} ||= 'weather_api_data';
    $rmq_cfg->{queue}       ||= 'weather.data.queue';
    $rmq_cfg->{exchange}    ||= 'weather.api.data.exchange';
    #safe RabbitMQ conf
    $rmq_cfg->{queue_conf}->{options}      ||= {durable => 1};
    $rmq_cfg->{exchange_conf}->{options}   ||= {exchange_type => 'direct', durable => 1,};
    $rmq_cfg->{publish_conf}->{options}    ||= {exchange => $rmq_cfg->{exchange}};
    $rmq_cfg->{publish_conf}->{properties} ||= {delivery_mode => 2,};

}

1;