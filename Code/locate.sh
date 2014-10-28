#! /bin/sh
# Created by Tim Stuart

index=  proc=  repo=  yhindex=  size=  genome=  keep=  helpmsg=  

# required flags are followed by :
while getopts x:p:c:y:s:g:kh opt; do
  case $opt in
  x)
      index=$OPTARG
      ;;
  p)
      proc=$OPTARG
      ;;
  c)
      repo=$OPTARG
      ;;
  y)
      yhindex=$OPTARG
      ;;
  s)
      size=$OPTARG
      ;;
  g)
      genome=$OPTARG
      ;;
  k)
      keep=$OPTARG
      ;;
  r)
      recursive=$OPTARG
      ;;
  h)
      helpmsg=true
      ;;
  esac
done
shift $((OPTIND - 1))

if [ "$helpmsg" == true ]; then
  echo "
  Usage:
    locate.sh [options] -p <proc> -s <size> -x <path/to/bowtie2/index> -y <path/to/yaha/index> -c <path/to/repo> -g <genome>

  Where:
   <proc> is number of processors to use
   <size> is average size of PE fragments sequenced
   <genome> is the organism. Currently supports Arabidopsis (TAIR10 or TAIR9) and Brachypodium.

  Options:
   -k <path>    keep concordantly mapped reads, store at <path>
   -r           run on all subdirectories (recursive)

  Output files:
    * bowtie log file: <name>.log
    * discordant reads bedfile
    * optional concordant reads samfile (use -k <path>)
    * split reads bedfile
    * TE insertions bedfile
    * TE deletions bedfile (TE present in Col-0 but not accession). Limited to finding TEs >200 bp, <20000 bp
    * compressed fastq files
    "
  exit
fi

if [ "$genome" == "TAIR10" ]; then
    gff=$repo/GFF/Arabidopsis/TAIR9_TE.bed
    strip='/Pt/d;/Mt/d;s/chr//g'
elif [ "$genome" == "TAIR9" ]; then
    gff=$repo/GFF/Arabidopsis/TAIR9_TE.bed
    strip='/chrM/d;/chrC/d;s/chr//g'
elif [ "$genome" == "Brachypodium" ]; then
    gff=$repo/GFF/Brachypodium/Brachy_TE_v2.2.bed
    strip='/scaffold_/d;s/Bd//g'
else
    echo "Unsupported genome"
    exit
fi

if [ "$keep" ]; then
    keep=$keep
else
    keep=/dev/null
fi

if [ "$recursive" ]; then
  for directory in ./*; do
      if [ -d "$directory" ]; then
          cd $directory
          sh $repo/Code/process_single.sh -p $proc -x $index -c $repo -y $yhindex -s $size -g $genome -k $keep -q $strip
          cd ..
      fi
  done

else
  sh $repo/Code/process_single.sh -p $proc -x $index -c $repo -y $yhindex -s $size -g $gff -k $keep -q $strip
fi