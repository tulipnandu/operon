my $inputFile = "./uid57659.txt";
my $outputFile = "./uid57659 GI Count.csv";

my %giCount;
open( IN,"< $inputFile")|| die "can't open $inputFile";
while(my $line = <IN>)
{
    chomp($line);
    my @toks = split("\t",$line);
    my @subToks = split('\|',$toks[1]);
    $giCount{$subToks[1]}++;
}

my $uid = substr($inputFile,rindex($inputFile,"/")+1);
$uid = substr($uid,0,index($uid,"."));
my @countOrder = sort{$giCount{$b}<=>$giCount{$a}} keys %giCount;
open( OUT,"+>$outputFile")|| die "can't open";
for(my $i=0;$i<=$#countOrder;$i++)
{
    print OUT $uid.",".$countOrder[$i].",".$giCount{$countOrder[$i]}."\n";
}
