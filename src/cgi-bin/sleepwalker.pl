#!/usr/bin/perl -w

use strict;
use DBI;
use DBD::mysql;
use LWP::Simple qw(get);
use Time::Local;
use Date::Parse;

use CGI::Carp qw(fatalsToBrowser);

use CGI qw(:standard);

use Socket;

my $aktip;
my $aktmac;
my %machash;
my %hostnamehash;

print header('application/json');

my $hostfile = "/var/www/public_html/sleepwalker/hostlist.txt";
open (DATA,"$hostfile") or die "Couldnt open File";
my @lines = <DATA>;
close (DATA);

foreach my $line (@lines){

if ($line =~ /\d{3}\../){
($aktip) = $line =~/(\d+\.\d+\.\d+\.\d+)/;
($aktmac) = $line =~/((\S{2}:){4}\S{2})/;
$machash{$aktip} = $aktmac;

my $akthostname = gethostbyaddr(inet_aton($aktip), AF_INET );
if ($akthostname){
$hostnamehash{$aktip}=$akthostname;

}
else
{
$hostnamehash{$aktip}="EMPTY";
}


}


}
my $jsonstring.="{\"ips\": [";

for my $aktkey(keys %machash){

$jsonstring.="\"$aktkey\","

}

chop $jsonstring;

$jsonstring.="],\"macs\": [";

for my $aktkey(keys %machash){

$jsonstring.="\"$machash{$aktkey}\",";

}
chop $jsonstring;

$jsonstring.="],\"hostnames\": [";
for my $aktkey(keys %machash){

$jsonstring.="\"$hostnamehash{$aktkey}\",";

}
chop $jsonstring;

$jsonstring.="]}";



print $jsonstring;

exit 0;
