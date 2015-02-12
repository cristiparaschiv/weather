#!/usr/bin/perl

use strict;
use warnings;

use LWP::UserAgent;
use JSON;

my $city = $ARGV[0] // "Iasi,ro";
my $api_url = "http://api.openweathermap.org/data/2.5/weather?q=" . $city;

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

my $weather = {
	'temperature' => $decoded->{main}->{temp} - 273.15,
	'humidity' => $decoded->{main}->{humidity} . "%",
	'pressure' => $decoded->{main}->{pressure} . "hpa",
	'wind_speed' => $decoded->{wind}->{speed} . "m/s",
	'sunrise' => (localtime($decoded->{sys}->{sunrise}))[2] . ":" . (localtime($decoded->{sys}->{sunrise}))[1],
	'sunset' => (localtime($decoded->{sys}->{sunset}))[2] . ":" . (localtime($decoded->{sys}->{sunset}))[1],
};

print "$decoded->{name}\n\n";
print "Temperature: ";
my $form_temp = sprintf("%.1f", $weather->{temperature});
print "$form_temp\n";
print "Humidity: $weather->{humidity}\n";
print "Pressure: $weather->{pressure}\n";
print "Wind Speed: $weather->{wind_speed}\n";
print "Sunrise: $weather->{sunrise}\n";
print "Sunset: $weather->{sunset}\n";

