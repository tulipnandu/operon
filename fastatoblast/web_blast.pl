use URI::Escape;
use LWP::UserAgent;
use HTTP::Request::Common qw(POST);
open (OUT,"+>./outputFile.txt");
$ua = LWP::UserAgent->new;

$argc = $#ARGV + 1;

if ($argc < 3)
    {
    print "usage: web_blast.pl program database query [query]...\n";
    print "where program = megablast, blastn, blastp, rpsblast, blastx, tblastn, tblastx\n\n";
    print "example: web_blast.pl blastp nr protein.fasta\n";
    print "example: web_blast.pl rpsblast cdd protein.fasta\n";
    print "example: web_blast.pl megablast nt dna1.fasta dna2.fasta\n";

    exit 1;
}

$program = shift;
$database = shift;

if ($program eq "megablast")
    {
    $program = "blastn&MEGABLAST=on";
    }

if ($program eq "rpsblast")
    {
    $program = "blastp&SERVICE=rpsblast";
    }

# read and encode the queries
foreach $query (@input)
    {
    open(QUERY,$query);
    while(<QUERY>)
        {
        $encoded_query = $encoded_query . uri_escape($_);
        }
    }

# build the request
$args = "CMD=Put&PROGRAM=$program&DATABASE=$database&QUERY=" . $encoded_query;

$req = new HTTP::Request POST => 'http://www.ncbi.nlm.nih.gov/blast/Blast.cgi';
$req->content_type('application/x-www-form-urlencoded');
$req->content($args);

# get the response
$response = $ua->request($req);

# parse out the request id
$response->content =~ /^    RID = (.*$)/m;
$rid=$1;

# parse out the estimated time to completion
$response->content =~ /^    RTOE = (.*$)/m;
$rtoe=$1;

# wait for search to complete
sleep $rtoe;

# poll for results
while (true)
    {
    sleep 5;

    $req = new HTTP::Request GET => "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_OBJECT=SearchInfo&RID=$rid";
    $response = $ua->request($req);

    if ($response->content =~ /\s+Status=WAITING/m)
        {
        # print STDERR "Searching...\n";
        next;
        }

    if ($response->content =~ /\s+Status=FAILED/m)
        {
        print STDERR "Search $rid failed; please report to blast-help\@ncbi.nlm.nih.gov.\n";
        exit 4;
        }

    if ($response->content =~ /\s+Status=UNKNOWN/m)
        {
        print STDERR "Search $rid expired.\n";
        exit 3;
        }

    if ($response->content =~ /\s+Status=READY/m) 
        {
        if ($response->content =~ /\s+ThereAreHits=yes/m)
            {
            #  print STDERR "Search complete, retrieving results...\n";
            last;
            }
        else
            {
            print STDERR "No hits found.\n";
            exit 2;
            }
        }

    # if we get here, something unexpected happened.
    exit 5;
    } # end poll loop

# retrieve and display results
$req = new HTTP::Request GET => "http://www.ncbi.nlm.nih.gov/blast/Blast.cgi?CMD=Get&FORMAT_TYPE=XML&RID=$rid";
$response = $ua->request($req);
open (OUT,"+>./outputFile.txt");
print OUT $response->content;
exit 0;