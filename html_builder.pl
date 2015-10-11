use warnings;
use diagnostics;

use HTML::TreeBuilder;
use LWP::Simple;
use Data::Dumper;

use utf8;

my $html=LWP::Simple::get("http://net.gaoguangyu.com");

my $tree=HTML::TreeBuilder->new;

$tree->ignore_ignorable_whitespace(0);
$tree->parse ($html);
$tree->eof();

#Scanning HTML Tree

sub untag_html{
	my $html=shift;
	return $html unless ref $html;
	
	my $text='';
	for my $item (@{$html->{"_content"}}){
		$text.=untag_html($item);
	}
	return $text
}

binmode STDOUT,":utf8";

print &untag_html($tree);

