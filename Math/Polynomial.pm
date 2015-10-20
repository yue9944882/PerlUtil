
package PerlUtil::Math::Polynomial;

use strict;
use warnings;

use Regexp::Common;

our $VERSION='1.00';

require Exporter;

our @ISA= qw/Exporter/;

our @EXPORT=qw/parse_poly check_poly/;

our @EXPORT_OK=qw/parse_poly check_poly/;

our %EXPORT_TAGS=(
	
);


#Code Defination Begin

my $num_reg=$RE{num}{real};
my $op_reg=qr/[+-*/^]/;

sub parse_poly ($$){
	
	my $poly=shift;
	my $x_var=shift;

	my $check=&check_poly($poly);
	
	#Check if the given parameter is a polynomial

	unless($check){
		die "Parsing Process Cannot Continue..\nExiting...\n";
	}


	#Parsing Polynomial
	
	
	
}

#Recursively Parse Polynomial with brancket

sub parse_brck($$){
	
	my $sub_poly=shift;
	my $x_var=shift;
	
	my $in_brck;
	
	while($sub_poly=~/\( (.*) \)/gx){
		
		$in_brck=$1;
		&parse_brck($sub_poly,$x_var);
		
	}
	
	if($in_brck=~s/x/$x_var/){
		print "x->$x_var: $in_brck"."\n";
	}
	
	if($in_brck=~/($num_reg)\s*($op_reg)\s*($num_reg)/x){
		my $ans=&calc_poly($2,$1,$3);
		
	}
	
}

sub check_poly($){
	my $poly=shift;

	if($poly=~/^(.+)=([ \(\)\*\/+-^x\d ]+)$/x){
		print "Check Polynomial Sucess!\n";
		return 1;
	}else{
		print "Check Polynomial Failed!\n";
		return undef;
	}
}


sub calc_poly($$$){
	my $op=shift;
	my $num1=shift;
	my $num2=shift;

	my $ret;
	
	if($op eq '+'){
		$ret=$num1+$num2;	
	}elsif($op eq '-'){
		$ret=$num1-$num2;
	}elsif($op eq '*'){
		$ret=$num1*$num2;
	}elsif($op eq '/'){
		$ret=$num1/$num2;
	}elsif($op eq '^'){
		$ret=$num1**$num2;
	}else{
		die 'Operator Recgnization Error!';
	}
	
}


1;

__END__





