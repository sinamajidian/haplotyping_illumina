



# You need samtools and bowtie2



mkdir software
cd software



git clone https://github.com/smajidian/haplotyping_illumina.git


#python2 -m pip install scipy --user
#python2 -m pip install numpy --user
#python2 -m pip install biopython --user






cd software
wget https://www.niehs.nih.gov/research/resources/assets/docs/artbinchocolatecherrycake03.19.15linux64.tgz
tar -xvzf artbinchocolatecherrycake03.19.15linux64.tgz

cat ~/.profile
vi ~/.profile
#export PATH=/mnt/scratch/???/software/art_bin_ChocolateCherryCake:$PATH

source ~/.profile # in each working session



# Do it in screen but typing it
#for temporarily exit press  crl+a crl+d
# for come back type screen -r

screen
# press enter
cd software
git clone --recursive git://github.com/ekg/freebayes.git
cd
make

cat ~/.profile
vi ~/.profile
#export PATH=/mnt/scratch/???/software/?:$PATH



cd software
wget https://www.brown.edu/Research/Istrail_Lab/resources/hapcompass_v0.8.2.zip
unzip hapcompass_v0.8.2.zip


cd software

wget http://data.broadinstitute.org/igv/projects/downloads/2.5/IGV_Linux_2.5.2.zip
unzip IGV_Linux_2.5.2.zip

java -Xmx750m -jar /mnt/scratch/??/software/IGV_2.4.16/lib/igv.jar &
