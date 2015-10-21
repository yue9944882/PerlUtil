
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
my $op_reg1=qr/[\^]/;
my $op_reg2=qr/[\*\/]/;
my $op_reg3=qr/[\+\-]/;

our $PI=3.141592653897;

our $inf=99999999999;

sub parse_poly ($$){
	
	my $poly=shift;
	my $x_var=shift;
	my $ret;

	my $check=&check_poly($poly);
	
	#Check if the given parameter is a polynomial

	unless($check){
		die "Parsing Process Cannot Continue..\nExiting...\n";
	}


	#Parsing Polynomial
	
	if($poly=~/=\s*(.*)$/){
		$ret=&parse_brck($1,$x_var);		
	}
	
	return $ret;
}

#Recursively Parse Polynomial with brancket

sub parse_brck($$){
	
	my $sub_poly=shift;
	my $x_var=shift;
	
	my $in_brck;
	
	my $rec_flag;
	

	while(1){		
		
		print "sub:$sub_poly\n";
		
		$in_brck=take_brck($sub_poly);
		
		print "inb:$in_brck\n";
		
		last if($in_brck eq $sub_poly);
		
		my $brckval=&parse_brck($in_brck,$x_var);
		
		print "bcv:$brckval\n";
	
		my $tmp=$in_brck;
		
		while($tmp=~s/((?<!\\)[\(\)\^\+\-\*\/])/\\$1/){
			;
		}
		
		$sub_poly=~s/\($tmp\)/$brckval/;
		
		$rec_flag=1;
		
	}
	
	my $ans;
	
	if($rec_flag){
		
		while(1){
			
			print "******\n";
			
			$sub_poly=~s/x/$x_var/;
			
			if($sub_poly=~/(?:\+|\-)*(($num_reg)\s*($op_reg1)\s*($num_reg))/){
				#print"1";
				$ans=&calc_poly($3,$2,$4);
				my $tmp=$1;
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}
				$sub_poly=~s/$tmp/$ans/;	
			}elsif($sub_poly=~/(?:\+|\-)*(($num_reg)\s*($op_reg2)\s*($num_reg))/){
				#print"2";
				$ans=&calc_poly($3,$2,$4);
				my $tmp=$1;
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}
				$sub_poly=~s/$tmp/$ans/;	
			}elsif($sub_poly=~/(?:\+|\-)*(($num_reg)\s*($op_reg3)\s*($num_reg))/){
				#print"3";
				$ans=&calc_poly($3,$2,$4);
				my $tmp=$1;
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}
				$sub_poly=~s/$tmp/$ans/;	
			}elsif($sub_poly=~/(sin($num_reg))/){
				#print"4";
				$ans=sin $2;
				my $tmp=$1;
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}
			
				print "pattern:$tmp\n";
			
				$sub_poly=~s/$tmp/$ans/;	
				
				print "===>$sub_poly\n";	
			}elsif($sub_poly=~/^($num_reg)$/){
				#print"5";
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
			
			
			if($sub_poly=~/(?:\+|\-)*(($num_reg)\s*($op_reg1)\s*($num_reg))/){
				$ans=&calc_poly($3,$2,$4);
				print "$ans","\n";
				my $tmp=$1;	
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}		
				print "pattern:$tmp\n";			
				$sub_poly=~s/$tmp/$ans/;					
				print "===>$sub_poly\n";			
			}elsif($sub_poly=~/(?:\+|\-)*(($num_reg)\s*($op_reg2)\s*($num_reg))/){
				$ans=&calc_poly($3,$2,$4);
				print "$ans","\n";		
				my $tmp=$1;
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}
				print "pattern:$tmp\n";
				$sub_poly=~s/$tmp/$ans/;	
				print "===>$sub_poly\n";	
			}elsif($sub_poly=~/(?:\+|\-)*(($num_reg)\s*($op_reg3)\s*($num_reg))/){
				$ans=&calc_poly($3,$2,$4);
				print "$ans","\n";		
				my $tmp=$1;
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}
				print "pattern:$tmp\n";
				$sub_poly=~s/$tmp/$ans/;	
				print "===>$sub_poly\n";	
			}elsif($sub_poly=~/(sin($num_reg))/){
				$ans=sin $2;
				
				my $tmp=$1;
				
				while($tmp=~s/((?<!\\)[\^\+\-\*\/])/\\$1/){
					;
				}
			
				print "pattern:$tmp\n";
			
				$sub_poly=~s/$tmp/$ans/;	
				
				print "===>$sub_poly\n";	
			}elsif($sub_poly=~/^($num_reg)/){
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

	if($poly=~/^(.+)=([sincos\(\)\*\/\+\-\^x\d ]+)$/x){
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
	
	print "op:$op\n";
	print "num1:$num1\n";
	print "num2:$num2\n";
	
	if($op eq '+'){
		$ret=$num1+$num2;	
	}elsif($op eq '-'){
		$ret=$num1-$num2;
	}elsif($op eq '*'){
		$ret=$num1*$num2;
	}elsif($op eq '/'){
		if($num2==0){$num2=$inf;}
		$ret=$num1/$num2;
	}elsif($op eq '^'){
		$ret=$num1**$num2;
	}else{
		die 'Operator Recgnization Error!';
	}
}

sub take_brck($){
	
	my $exp=shift;
	my @stack=split //,$exp;
	my $start;
	my $brck_cnt=0;
	my $top;
	my $rec_flag;
	my $ret;
	
	my @in_brck;
	
	while(1){
		last if (($#stack+1)==0);
		last if ($start && ($brck_cnt==0));
		
		$top=shift @stack;
		
		if($rec_flag){
			push @in_brck,$top;
		}
		
		if($top eq '('){
			$start=1;
			$rec_flag=1;
			$brck_cnt++;
		}
		if($top eq ')'){
			$brck_cnt--;
			if($brck_cnt==0){
				pop @in_brck;
			}
		}
	}
	
	if($rec_flag){
		$ret=join "",@in_brck;
		return $ret;
	}else{
		return $exp;
	}
}


1;

__END__





