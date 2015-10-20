
package PerlUtil::Math::Polynomial;

use strict;
use warnings;

our $VERSION='1.00';

require Exporter;

our @ISA= qw/Exporter/;

our @EXPORT=qw/parse_poly check_poly/;

our @EXPORT_OK=qw/parse_poly check_poly/;

our %EXPORT_TAGS=(
	
);


#Code Defination Begin

sub parse_poly ($){
	
	my $poly=shift;

	my $check=&check_poly($poly);
	
	#Check if the given parameter is a polynomial

	unless($check){die 'Parsing Process Cannot Continue..\nExiting...\n';}

	#Parsing Polynomial
}


sub check_poly($){
	my $poly=shift;

	if($poly=~/^(.+)=([ \(\)\*\/+-^x\d ]+)$/x){
		print "Check Polynomial Sucess!\n";
		return undef;
	}else{
		print "Check Polynomial Failed!\n";
		return 1;
	}
}





1;

__END__





