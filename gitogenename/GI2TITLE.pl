my $input = "./uid57761 GI Count.csv";
my $output = "./uid57761 GI Count_title.txt";



$|=1;
open( OUT,"+>$output")|| die "can't open";

my $totalLine;
open( IN,"< $input")|| die "can't open";
while($line = <IN>)
{
    $totalLine++;
}

my $progress;
open( IN,"< $input")|| die "can't open";
while($line = <IN>)
{
    chomp($line);
    my @toks = split(",",$line);
    my $title = GI2TITLE($toks[1]);
    print OUT $toks[0]."\t".$toks[1]."\t".$title."\t".$toks[2]."\n";
    
    $progress++;
    if($progress%5 == 0)
    {
        print $progress."/".$totalLine."\n";
        sleep(1);
    }
}

sub GI2TITLE
{
    use LWP::Simple;
    my $gi = $_[0];
    my $url='http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?'.
    		'db=nuccore&id='.$gi;
    my $result = get($url);
    
    my $title;
    my @lines = split("\n",$result);
    for(my $i=0;$i<=$#lines;$i++)
    {
        if(index($lines[$i],'Item Name="Title"') != -1)
        {
            $title = substr($lines[$i],index($lines[$i],'>')+1);
            $title = substr($title,0,index($title,'<'));
            last;
        }
    }
    
    return $title;
}
