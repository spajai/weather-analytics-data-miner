#!/usr/bin/perl -w

use strict;

use Getopt::Long;
use Data::Dumper;
use FindBin;
use lib qq($FindBin::Bin/../lib);
use File::Find;
use Net::RabbitFoot;
use YAML qw (LoadFile);
use Data::Dumper;
use Yahoo::Weather::Api;

use Core;
no strict;

my $c = Core->new();
my $channel = 1;
my $mongo = $c->connect_db();
my $rmq = $c->connect_rabbitmq();


# no strict;
 # print "Instance METHOD IS  " . Data::Dumper::Dumper( \%{ref ($c )."::" });
# print Data::Dumper::Dumper($self);

    # print "Instance METHOD IS  " . Dumper( \%{ref ($rmq )."::" });
foreach (1..100){
print $_;
    if($rmq->is_connected()){
        $c->connect_rabbitmq()->send_data_to_rmq("hello sexy Monika sexy");
        # print Dumper  $rmq->is_received();
    }
}


=pod
my $queue = 'weather_data_queue';
my $routing_key = 'weather_api_data';
my $queue_option = {
   # passive => $boolean,     #default 0
   durable => 1,     #default 0
   # exclusive => $boolean,   #default 0
   auto_delete => 1, #default 1
};
my $exchange = 'weather_api_data_exchange';
my $echange_option = {
   exchange_type => 'direct',  #default 'direct'
   # passive => $boolean,     #default 0
   durable => 1,     #default 0
   auto_delete => 1, #default 0
};



my $publish_option = {
       # exchange => $exchange,                     #default 'amq.direct'
       # mandatory => $boolean,                     #default 0
       # immediate => $boolean,                     #default 0
       # force_utf8_in_header_strings => $boolean,  #default 0
 };


 my $props = {
       # content_type => $string,
       # content_encoding => $string,
       # correlation_id => $string,
       # reply_to => $string,
       # expiration => $string,
       # message_id => $string,
       # type => $string,
       # user_id => $string,
       # app_id => $string,
       # delivery_mode => $integer,
       # priority => $integer,
       # timestamp => $integer,
       # headers => $headers # This should be a hashref of keys and values.
 };





for (1..200000) {
if ($rmq->is_connected()) {
    $rmq->exchange_declare($channel, $exchange, $echange_option);
    $rmq->queue_declare($channel, $queue, $queue_option);  
    $rmq->queue_bind($channel, $queue, $exchange, $routing_key);
    # print $rmq->publish($channel, $routing_key, "testing my app");
    print $rmq->publish($channel, $routing_key, "testing my app", { exchange => $exchange });
    print "\n$_";
}

}
=pod

my $api = Yahoo::Weather::Api->new();

my @city = qw/
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
pune
mumbai
delhi
banglore
khed
nashik
kolkata
kochi
ranchi
mohali
nagpur
indore
india
/;


my $conn = Net::RabbitFoot->new()->load_xml_spec()->connect(
    host => '192.168.1.11',
    port => 5672,
    user => 'test',
    pass => 'test',
    vhost => '/',
);

my $chan = $conn->open_channel();

# print Dumper $chan;

my $response;
foreach (@city) {
$response = $api->get_weather_data({search => $_});

$chan->publish(
    exchange => 'test',
    routing_key => "Data for $_",
    body => $response,
);
print " [x] Sent 'Hello World!'\n" if ($response);

}
$conn->close();