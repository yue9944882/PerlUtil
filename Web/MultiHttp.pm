

package PerlUtil::Web::MultiHttp;

use strict;
use warnings;


use LWP::Simple;

use threads;
use threads::shared;
use Thread;
use URI;
use Time::HiRes qw/gettimeofday/;
use Data::Dumper;
use feature qw/state/;



our $VERSION='1.00';

require Exporter;

our @ISA=qw/Exporter/;

our @EXPORT=qw/multi_http_parse/;

our %EXPORT_TAGS=(

);



#Code Defination Begin

sub multi_http_parse{
	my $t1=gettimeofday;
	my %namehash;
	our %filmhash:shared;
	my $loop_cnt;
	my @url_arr;
	state $name_cnt:shared;


	while(<>){
	
		chomp;
	
		if(/.+productId:\s+(\S+) /x){
		
			chomp $1;
		
			unless($namehash{$1}){

				$namehash{$1}++;
		
				my $url="http://www.amazon.com/dp/".$1;
			
				push @url_arr,$url;
			
			}else{
				next;
		}

		$loop_cnt++;
		
		print "\r$loop_cnt";
	
	}
	}




	my @threadlist;

	$indx=0;

	my $file_indx=0;

	my $file_len=@url_arr;

	while($indx<30){
		my $tmp=$indx;
		my $param=pop @url_arr;
		sleep 1;
		$threadlist[$indx]=threads->create(\&thread_proc,$param,\%filmhash,\$name_cnt);	
		$indx++;
		$file_indx++;
	}

	while($file_indx<=$file_len){
		for my $thread (@threadlist){	
			my $f=$thread->is_joinable;
			if($f){
				$thread->join();
				my $param=pop @url_arr;
				sleep 1;
				$thread=threads->create(\&thread_proc,$param,\%filmhash,\$name_cnt);
				$file_indx++;
			}	
		}
	}

	for my $thread (@threadlist){	
		$thread->join();
	}
	
}



sub get_film{
	
	my $html=shift;
	
	if($html=~/<meta name="title" content="(.*)"/){	
		my $tmp=$1;
		if($tmp=~/Amazon.com:\s*(.*?):/){
			return $1;
		}elsif($tmp=~/(.*):/){
			return $1;
		}else{
			return $tmp;
		}
	}
	return "none";
}


sub thread_proc{
	
	my $url=shift;
	my $ref=shift;
	my $nref=shift;

	print "Requesting ".$url."\n";
	my $html=LWP::Simple::get($url);
	if($html){
		print "$url Parsing Success!\n";
		my @ret=&get_film($html);	
		my $name=shift @ret;	
		if($name=~/(.*?)\s*\[VHS\]/){
			$name=$1;
		}
		if(!$ref->{$name}){	
			$ref->{$name}++;
			$$nref=$$nref+1;
			print "Totally Film Number: $$nref \n";
		}
		print $name."\n";
	
	}else{
		print "$url Parsing Failed!\n";
	}
	
}

my $t2=gettimeofday;

my $diff=$t2-$t1;

print "Using time $diff\n";

open $fh,">>result.txt";

for my $name (keys %filmhash){
	print $fh $name."\n";
}

close $fh;

