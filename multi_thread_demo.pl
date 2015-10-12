
use warnings;
use diagnostics;

use threads;
use threads::shared;
use Thread;


use Data::Dumper;

sub thread_proc{
	
	my $param=shift;
	while(1){
		print "PROC: $param\n";
		sleep 2;
	}
	
}


my @threadlist;

$indx=0;

while($indx<20){
	
	my $tmp=$indx;
	
	$threadlist[$indx]=threads->create(\&thread_proc,$tmp);
	
	$indx++;
}


for my $thread (@threadlist){
	$thread->join();
}

