#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

my $names = 'Fred Flinstone and Wilma Flinstone';

if($names =~ m/(?<last_name>\w+) and \w+ \g{last_name}/){
    say "I saw $+{last_name}";
    say "$1";
}

$_ = "yabba dabba doo   ";
if(/y(.)(.)\2\1/gs){
    say "match!".($`).($&).($');
}

my $opt = "sm";
my $regex = qr/(?sm)(\d+)/;
my $regex_2 = qr/(\d+)/sm;
say $regex;
say $regex_2;

# my $num = 12345;
# my $opt = "sm";
# my $regstr = 'qr/(\\d+)/' . $opt;
# my $regex;
# eval '$regex = ' . $regstr;

# say $regex;