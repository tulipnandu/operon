use LWP::Simple;

my %gi2name;

my $progress = 0;
my $dir1="./AAA/";
if(opendir(DIR1,$dir1))
{
	my @files1 = readdir(DIR1);
	for(my $f1=2;$f1<=$#files1;$f1++)
	{
		
		if($files1[$f1] ne "._.DS_Store" && $files1[$f1] ne ".DS_Store" )
		{
			my $dir2 = $files1[$f1];
			$dir2 =~ s/_//;
			$dir2 =$dir1.$files1[$f1]."/".$dir2.".txt";

			my $giCount=0;
			open (IN, "<$dir2") || die "couldn't open the file!";
			while($line = <IN>)
			{
				$giCount++;
			}

			my $subProgress=0;
			open (IN, "<$dir2") || die "couldn't open the file!";
			while($line = <IN>)
			{
				chomp($line);
				if(!exists $gi2name{$line})
				{
					my $geneName = GI2GS($line);
					$gi2name{$line}=$geneName;

					
					sleep(1);
				}	

				$subProgress++;
				print "Completed: ".$progress."/".($#files1-2)."\t".$subProgress."/".$giCount."\n";			
			}
		}
		
	}
	$progress++;
	print "Completed: ".$progress."/".($#files1-2)."\n";
}

open(OUT,"+>./GI2GeneName.txt");
while(($key,$value) = each(%gi2name))
{
	print OUT $key,"\t",$value."\n";
}
###############################################################################
sub GI2GS
{
    my $GI = $_[0];

    my $url='http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?'.
            'db=nuccore&&id='.$GI;
    my $result = get($url);

    my $gs;
    my @lines = split("\n",$result);
    for(my $i=0;$i<=$#lines;$i++)
    {
        if(index($lines[$i],'Name="Title"') != -1)
        {
            $gs = substr($lines[$i],index($lines[$i],'>')+1);
            $gs = substr($gs,0,index($gs,'<'));
            last;
        }
    }
    
    return $gs;

}
