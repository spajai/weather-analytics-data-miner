use strict;
use warnings;

$|++;
use AnyEvent;
use Net::RabbitFoot;

my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
    host => '192.168.1.11',
    port => 5672,
    user => 'test',
    pass => 'test',
    vhost => '/',
);

my $ch = $conn->open_channel();


$ch->declare_queue(queue => 'test');

sub callback {
    my $var = shift;
    my $body = $var->{body}->{payload};
    print " [x] Received $body\n";
}

$ch->consume(
    on_consume => \&callback,
    no_ack => 0,
);

