#!/usr/bin/perl

use strict;
use warnings;

use LWP::UserAgent;
use JSON;

my $city = $ARGV[0] // "Iasi,ro";
my $api_url = "http://api.openweathermap.org/data/2.5/forecast/daily?q=" . $city . "&mode=json&units=metric&cnt=5";

my $ua = LWP::UserAgent->new;
my $data;

my $response = $ua->get($api_url);
if ($response->is_success) {
	$data = $response->decoded_content;
} else {
	die $response->status_line;
}

my $json = JSON->new;
my $decoded = $json->decode($data);

$data = $decoded->{list};
foreach my $entry (@$data) {
    print "Date: " . scalar localtime $entry->{dt};
    print "\n  Temperature: " . int($entry->{temp}->{day}) . "\n";
    print "  Description: " . $entry->{weather}->[0]->{description} . "\n";
    print "  Humidity: " . $entry->{humidity} . "\n";
    print "  Pressure: " . $entry->{pressure} . "\n";
    print "  Wind Speed: " . $entry->{speed} . "\n";

}

