#!/usr/bin/perl -w
# Created by Ben Okopnik on Sat May 10 08:56:33 EDT 2008
#
# Copyright (C) 2008 Ben Okopnik <ben@okopnik.com>
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

use strict;
use CGI::Carp qw/fatalsToBrowser warningsToBrowser/;
use CGI ':standard';
$|++;

open D, "/usr/share/dict/words" or die "/usr/share/dict/words: $!\n";
chomp(my @dict = <D>);
close D;

my @domains = qw/aero arpa biz com coop edu gov info int mil net org/;

sub colors {
	'#' . sprintf "%02X%02X%02X", map {int rand(256) + 1} 1..3;
}

sub words {
    my @words = map $dict[rand @dict], 1..rand($_[1])+$_[0];
	tr/'//d for @words;
	return @words if wantarray;
	join " ", @words;
}

sub email {
	my $name = join "", map {("a".."z")[rand(26)+1]} 1..rand(10)+5;
	my $e = "$name\@" . join("", words(2,3)) . 
		"." . $domains[rand @domains];
	$e =~ tr/ //d;
	a({ -href => "mailto:$e" }, $e);
	}

sub links {
	my $self = $0;
	$self =~ s#.*/##;
	a({ -href => "$self?" . words(1,1)}, words(1,3));
}

print header, start_html(
	-title   => join(" ", map {ucfirst} words(1,5)),
	-bgcolor => '#' . colors(),
	-meta    => {
		robots => 'noindex, nofollow',
	}
);

print h1(map ucfirst, words(1,4));

for (1 .. rand(15) + 4){
	my $para;
	for (1 .. rand(7) + 7){
		my $sentence;
		for (words(3, 7)){
			my $r = rand;
			$sentence .= 	$r < 0.9 ? $_ : $r > 0.95 ? email() : links();
			$r = rand;
			$sentence .= 	$r <  0.8 ? " " : ", ";
		}
		$sentence =~ s/(?:,?\s+)*$//;
		$para .= ucfirst "$sentence. ";
	}
	print p({-style => 'color:' . colors()}, $para), "\n";
}

print end_html();

sleep 1;

