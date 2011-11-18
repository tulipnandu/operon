#!/usr/bin/perl

#use strict;
use warnings;

use LWP::UserAgent;
use XML::LibXML;
use XML::XPath;

# Declare the subroutines
sub trim($);

my $ua = LWP::UserAgent->new;
$ua->env_proxy;

open  my $protIds, '/users/tulip_nandu/Desktop/2.txt' or die 'Couldn\'t open file!';
open  my $protDomainOut, '>', 'C:\\Protein-Domain-Details.txt' or die 'Couldn\'t open file to write!';

while (<$protIds>){

#my $prot_id = 'CREB1_HUMAN';
chomp;
my $prot_id = $_;
my $res = $ua->get('http://pfam.janelia.org/protein/'.$prot_id.'?output=xml');

die "error: failed to retrieve XML: " . $res->status_line . "\n"
  unless $res->is_success;

my $xml = $res->content;

#print $xml."\n";

$xp = XML::XPath->new(xml => $xml);
print $xp."\n";
my @domainIds = $xp->findnodes('//matches/match/');
($prot_desc) = $xp->findnodes('//entry/description/text()');
my ($prot_name) = $xp->findnodes('//entry/@accession');

print "protein name: " . $prot_id . "\n";
print "protein desc: " . trim($prot_desc->string_value()) . "\n";
print "protein accession: " . $prot_name->string_value() . "\n";
foreach $domainId (@domainIds){
	my $dId = $domainId->string_value();
	print "\tdomain: " . $dId . "\n";
	my $res2 = $ua->get('http://pfam.janelia.org/family/'.$dId.'?output=xml');
	
	die "error: failed to retrieve XML: " . $res->status_line . "\n"
	  unless $res2->is_success;
	
	my $xml2 = $res2->content;

	my $xp2 = XML::XPath->new(xml => $xml2);

	my @entries = $xp2->findnodes('//go_terms/category[@name=\'function\']/term');
	
	if(@entries > 0){
		foreach $entry (@entries){
			print "\t\tfunction: " . $entry->string_value() . "\n";
			print $protDomainOut $prot_id . "\t". $prot_name->string_value() . "\t" . trim($prot_desc->string_value()) . "\t" . $dId . "\t" . $entry->string_value() . "\n";
		}
	}else{
		print "\t\tNo Functions Found!\n";
		print $protDomainOut $prot_id . "\t". $prot_name->string_value() . "\t" . trim($prot_desc->string_value()) . "\t" . $dId . "\t\n";
	}
}
}

close($protDomainOut);

sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

