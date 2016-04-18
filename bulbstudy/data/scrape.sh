#!/usr/bin/bash
# scrape energy cost data from the us energy information administration

# config
month_csv="MONTH,NUMBER
january,01
february,02
march,03
april,04
may,05
june,06
july,07
august,08
september,09
october,10
november,11
december,12"

# setup
cd "$(dirname "$0")"
mkdir -p src extracted converted src

# download data
wget -P src --no-clobber https://www.eia.gov/electricity/monthly/current_year/{january,february,march,april,may,june,july,august,september,october,november,december}{2011..2016}.zip

# organize by iso date
mkdir -p unzipped
rm -f unzipped/*
for archive in src/*.zip; do
    archive_name=$(basename "$archive")

    year=$(grep -o "[0-9]*" <<< "$archive_name")
    month_name=$(cut -d "2" -f 1 <<< "$archive_name")

    # convert january -> 01; february -> 02; etc
    month_number=$(grep "^$month_name," <<< "$month_csv" | cut -d "," -f 2)


    7z x "$archive" -ounzipped > /dev/null
    find unzipped -type f ! -iname '*5_*6_a*' -exec rm -f {} \;
    spreadsheet=$(find unzipped -type f)
    cp -v $spreadsheet extracted/${year}-${month_number}.${spreadsheet##*.} 2> /dev/null || \
        echo "could not find spreadsheet for $month_name $year"
    rm -f unzipped/*
done

# convert to csv for easy parsing
libreoffice --headless --convert-to csv --outdir converted extracted/*
