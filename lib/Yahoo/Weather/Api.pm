package Yahoo::Weather::Api;

use strict;
use warnings;
use Core;
use YAML qw (LoadFile);
use Data::Dumper;
use LWP::UserAgent;
use URI::Escape;
my $ua = LWP::UserAgent->new();
# my $safe = URI::Escape;
use utf8;
my $config = LoadFile('../config/configuration.yaml');
my $yql = 'select * from weather.forecast where woeid in (select woeid from geo.places(1) where text="';
my $url_start = 'https://query.yahooapis.com/v1/public/yql?q=';
my $url_end = '&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys';


sub new {
    return bless my $self = {} , shift;
}

sub get_weather_data {
    my ($self,$args) = (@_);
    return if ref $args ne 'HASH';
    return if !$args->{search};
    $yql .= $args->{search}.'")';
    my $res = $ua->get($url_start.uri_escape($yql).$url_end);
    return $res->content;
}

sub _validate {
    my ($self,$args) = (@_);
    return if ref $args ne 'HASH';
}