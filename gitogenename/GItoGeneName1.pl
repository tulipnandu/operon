{\rtf1\ansi\ansicpg1252\cocoartf1038\cocoasubrtf350
{\fonttbl\f0\fswiss\fcharset0 ArialMT;\f1\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red25\green67\blue135;}
\paperw11900\paperh16840\margl1440\margr1440\vieww9000\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\ql\qnatural

\f0\fs26 \cf0 use LWP;\
print GI2GS("
\f1 113880062
\f0 ");\
###############################################################################\
sub GI2GS\
\{\
\'a0\'a0 \'a0my $GI = $_[0];\
\
\'a0\'a0 \'a0my $url='{\field{\*\fldinst{HYPERLINK "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?"}}{\fldrslt \cf2 \ul \ulc2 http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?}}'.\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0'db=protein&&id='.$GI;\
\'a0\'a0 \'a0my $result = get($url);\
\
\'a0\'a0 \'a0my $gs;\
\'a0\'a0 \'a0my @lines = split("\\n",$result);\
\'a0\'a0 \'a0for(my $i=0;$i<=$#lines;$i++)\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0if(index($lines[$i],'Name="Title"') != -1)\
\'a0\'a0 \'a0 \'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$gs = substr($lines[$i],index($lines[$i],'>')+1);\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$gs = substr($gs,0,index($gs,'[')-1);\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0last;\
\'a0\'a0 \'a0 \'a0 \'a0\}\
\'a0\'a0 \'a0\}\
\'a0\'a0 \'a0\
\'a0\'a0 \'a0my $geneID = GS2GID($gs);\
\'a0\'a0 \'a0my $geneSymbol = GID2GS($geneID);\
\'a0\'a0 \'a0return $geneSymbol;\
\}\
###############################################################################\
sub GID2GS\
\{\
\'a0\'a0 \'a0my $geneID = $_[0];\
\'a0\'a0 \'a0my $url='{\field{\*\fldinst{HYPERLINK "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?"}}{\fldrslt \cf2 \ul \ulc2 http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?}}'.\
\'a0\'a0 \'a0		'db=gene&id='.$geneID;\
\'a0\'a0 \'a0my $result = get($url);\
\
\'a0\'a0 \'a0my $geneSymbol;\
\'a0\'a0 \'a0my $currentID;\
\'a0\'a0 \'a0my @lines = split("\\n",$result);\
\'a0\'a0 \'a0for(my $i=0;$i<=$#lines;$i++)\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0if(index($lines[$i],'Name="Name"') != -1)\
\'a0\'a0 \'a0 \'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$geneSymbol = substr($lines[$i],index($lines[$i],'>')+1);\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$geneSymbol = substr($geneSymbol,0,index($geneSymbol,'<'));\
\'a0\'a0 \'a0 \'a0 \'a0\}\
\
\'a0\'a0 \'a0 \'a0 \'a0if(index($lines[$i],'Name="CurrentID"') != -1)\
\'a0\'a0 \'a0 \'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$currentID = substr($lines[$i],index($lines[$i],'>')+1);\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$currentID = substr($currentID,0,index($currentID,'<'));\
\'a0\'a0 \'a0 \'a0 \'a0\}\
\'a0\'a0 \'a0\}\
\
\'a0\'a0 \'a0if($currentID ne "" && $currentID != 0)\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0return GID2GS($currentID);\
\'a0\'a0 \'a0\}\
\'a0\'a0 \'a0else\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0return $geneSymbol;\
\'a0\'a0 \'a0\}\
\}\
###############################################################################\
sub GS2GID\
\{\
\'a0\'a0 \'a0my $geneSymbol = $_[0];\
\
\'a0\'a0 \'a0my $url1='{\field{\*\fldinst{HYPERLINK "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?"}}{\fldrslt \cf2 \ul \ulc2 http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?}}'.\
\'a0\'a0 \'a0		 'db=gene&cmd=search&term='.$geneSymbol;\
\'a0\'a0 \'a0my $result1 = get($url1);\
\
\'a0\'a0 \'a0my $geneID;\
\'a0\'a0 \'a0my @lines1 = split("\\n",$result1);\
\'a0\'a0 \'a0for(my $i=0;$i<=$#lines1;$i++)\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0if(index($lines1[$i],'<Id>') != -1)\
\'a0\'a0 \'a0 \'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$geneID = substr($lines1[$i],index($lines1[$i],'>')+1);\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0$geneID = substr($geneID,0,index($geneID,'<'));\
\'a0\'a0 \'a0 \'a0 \'a0 \'a0 \'a0last;\
\'a0\'a0 \'a0 \'a0 \'a0\}\
\'a0\'a0 \'a0\}\
\
\'a0\'a0 \'a0#check if it is replaced\
\'a0\'a0 \'a0my $url2='{\field{\*\fldinst{HYPERLINK "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?"}}{\fldrslt \cf2 \ul \ulc2 http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?}}'.\
\'a0\'a0 \'a0		 'db=gene&id='.$geneID;\
\'a0\'a0 \'a0my $result2 = get($url2);\
\
\'a0\'a0 \'a0my $currentID = 0;\
\'a0\'a0 \'a0if(index($result2,'Name="CurrentID"') != -1)\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0$currentID = substr($result2,index($result2,'Name="CurrentID"'));\
\'a0\'a0 \'a0 \'a0 \'a0$currentID = substr($currentID,index($currentID,'>')+1);\
\'a0\'a0 \'a0 \'a0 \'a0$currentID = substr($currentID,0,index($currentID,'<'));\
\'a0\'a0 \'a0\}\
\
\'a0\'a0 \'a0if($currentID == 0)\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0return $geneID;\
\'a0\'a0 \'a0\}\
\'a0\'a0 \'a0else\
\'a0\'a0 \'a0\{\
\'a0\'a0 \'a0 \'a0 \'a0return $currentID;\
\'a0\'a0 \'a0\}\
\}\
###############################################################################\
}