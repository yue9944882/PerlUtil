

package PerlUtil::Web::MultiHttp;


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

our $name_cnt:shared;

#Code Defination Begin

sub multi_http_parse($$$){
	
	my $filename=shift;
	my $thread_num=shift;
	my $html_regex=shift;
	
	my $t1=gettimeofday;
	my %namehash;
	our %filmhash:shared;
	my $loop_cnt;
	my @url_arr;
	
	my $fh;

	# Get Url List into @url_arr 

	open $fh,"<$filename";

	while(<$fh>){
		chomp;
		print $_,"\n";
		push @url_arr,$_;
		$loop_cnt++;	
		print "Target URL Number: $loop_cnt\n";
	}
	close $fh;
	
	print Dumper(@url_arr);
	
	print "\n";


	my @threadlist;
	my $indx=0;
	my $file_indx=0;
	my $file_len=@url_arr;
	
	while($indx<$thread_num){
		my $tmp=$indx;
		my $param=pop @url_arr;
		sleep 1;
		$threadlist[$indx]=threads->create(\&thread_proc,$param,\%filmhash,\$name_cnt,$html_regex);	
		$indx++;
		$file_indx++;
	}

	while($file_indx<=$file_len-$thread_num){
		for my $thread (@threadlist){	
			my $f=$thread->is_joinable;
			if($f){
				$thread->join();
				my $param=pop @url_arr;
				sleep 1;
				if($param){
					$thread=threads->create(\&thread_proc,$param,\%filmhash,\$name_cnt,$html_regex);
				}else{
					$thread=undef;
				}
				$file_indx++;
			}	
		}
	}

	for my $thread (@threadlist){	
		$thread->join() if ($thread);
	}
	
	my $t2=gettimeofday;
	my $diff=$t2-$t1;
	print "Using time $diff\n";
	open $fh,">>result.txt";
	for my $name (keys %filmhash){
		print $fh $name."\n";
	}
	close $fh;
}


#/<meta name="title" content="(.*)"/

sub thread_proc{
	
	my $url=shift;
	my $ref=shift;
	my $nref=shift;
	my $htmlreg=shift;

	print "Requesting ".$url."\n";
	my $html=LWP::Simple::get($url);
	
	#print $html,"\n";
	
	if($html){
		#print "$url Parsing Success!\n";
		my $name;
		
		if($html=~/($htmlreg)/){
			$name=$1;
		}
		
		if(!$ref->{$name}){	
			$ref->{$name}++;
			$$nref=$$nref+1;
			print "Total Extract Number: $$nref \n";
		}
	
	}else{
		print "$url Parsing Failed!\n";
	}
}


1;



