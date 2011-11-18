use LWP::Simple;
open( OUT,"+> /users/tulip_nandu/desktop/locationtest.txt");
open( IN,"< /users/tulip_nandu/desktop/location1.txt");
while(my $line = <IN>)
{
chomp($line);
print OUT getFASTA("CP000828.1",$line);
}



sub getFASTA
{
my $id = $_[0];
my $start_stop = $_[1];
my $start = substr($start_stop,0,index($start_stop,'.'));
my $stop = substr($start_stop,rindex($start_stop,'.')+1);
my $url = 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&rettype=FASTA&seq_start='.$start.'&seq_stop='.$stop.'&id='.$id;
my $result = get($url);
return $result;
}



