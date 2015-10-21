
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
my $op_reg=qr/[\+\-\*\/\^]/;

sub parse_poly ($$){
	
	my $poly=shift;
	my $x_var=shift;

	my $check=&check_poly($poly);
	
	#Check if the given parameter is a polynomial

	unless($check){
		die "Parsing Process Cannot Continue..\nExiting...\n";
	}


	#Parsing Polynomial
	
	if($poly=~/=\s*(.*)$/){
		&parse_brck($1,$x_var);		
	}
	
	
}

#Recursively Parse Polynomial with brancket

sub parse_brck($$){
	
	my $sub_poly=shift;
	my $x_var=shift;
	
	my $in_brck;
	
	my $rec_flag;
	
	
	while($sub_poly=~/.*?\( (.*) \).*?/gx){
		
		last unless($1);
		
		$in_brck=$1;
		
		my $brckval=&parse_brck($in_brck,$x_var);
	
		my $tmp=$1;
		
		$tmp=~s/([\^\+\-\*\/])/\\$1/;
		
		print "$tmp\n";
		
		$sub_poly=~s/\($tmp\)/$brckval/;
		
		print "After no brancket: $sub_poly\n";
		
		$rec_flag=1;
		
	}
	
	my $ans;
	
	if($rec_flag){
		
		while(1){
			
			print "******\n";
			
			$sub_poly=~s/x/$x_var/;
			
			print "$sub_poly","\n";
			
			if($sub_poly=~/^(($num_reg)\s*($op_reg)\s*($num_reg))/){
				$ans=&calc_poly($3,$2,$4);
				my $tmp=$1;
				$tmp=~s/([\^\+\-\*\/])/\\$1/;
				$sub_poly=~s/$tmp/$ans/;	
			}elsif($sub_poly=~/^($num_reg)$/){
				$ans=$1;
				last;
			}else{
				die 'Loop Error!';
			}
		}
		
	}else{
	
		print "&&&&&&&\n";
	
		while(1){
			
			$sub_poly=~s/x/$x_var/;
			
			
			if($sub_poly=~/^(($num_reg)\s*($op_reg)\s*($num_reg))/){
				$ans=&calc_poly($3,$2,$4);
				
				my $tmp=$1;
				
				$tmp=~s/([\^\+\-\*\/])/\\$1/;
					
				$sub_poly=~s/$tmp/$ans/;				
			
			}elsif($sub_poly=~/^($num_reg)$/){
				$ans=$1;
				last;
			}else{
				die 'Loop Error!';
			}
		}	
		
	}
	
	return $ans;
}



sub check_poly($){
	my $poly=shift;

	if($poly=~/^(.+)=([ \(\)\*\/\+\-\^x\d ]+)$/x){
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





