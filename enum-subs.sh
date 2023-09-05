#!/bin/bash


# Define text formatting
bold=$(tput bold)
underline=$(tput smul)
reset=$(tput sgr0)
yellow=$(tput setaf 3)

# Function to print a formatted title
print_title() {
    echo "${bold}${underline}${yellow}== $1 ==${reset}"
}

# Function to fetch subdomains using crt.sh
crt() {
    curl -s "https://crt.sh/?q=%25.$1" | grep -oE "[\.a-zA-Z0-9-]+\.$1" | sort -u
}

# Run amass and save the output to subs_amass.txt
print_title "Running amass..."
amass enum -d $domain -passive | tee subs_amass.txt

# Run subfinder and save the output to subs_subfinder.txt
print_title "Running subfinder..."
subfinder -d $domain -recursive -silent -t 200 | tee subs_subfinder.txt

# Run assetfinder and save the output to subs_assetfinder.txt
print_title "Running assetfinder..."
assetfinder --subs-only $domain | tee subs_assetfinder.txt

# Run gau and save the output to subs_gau.txt
print_title "Running gau..."
gau -subs $domain | cut -d / -f 3 | sort -u | tee subs_gau.txt

# Run subenum and save the output to subs_subenum.txt
print_title "Running subenum..."
/home/ahmed/hacking/tools/SubEnum/subenum.sh -d $domain | tee subs_subenum.txt

# Run crt function and save the output to subs_crt.txt
print_title "Running crt..."
crt $domain | tee subs_crt.txt

# Run theHarvester and save the output to harvest.txt
print_title "Running theHarvester..."
theHarvester -d $domain -b all | tee harvest.txt

echo "${bold}${yellow}All tools have finished.${reset}"
