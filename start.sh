#!/bin/bash
bboxesFile=bboxes.txt
if [ -f $bboxesFile ]; then
   index=1
   while IFS= read -r bbox 
   do
        dest=$(cat config.json | jq '.country')
        dest="${dest//\"}"
        country=$dest
        configFile="${country}_area${index}_config.json"
        if [ ! -d "$dest" ]; then
            mkdir $dest
        fi
        cat config.json | jq '.bounding_box='$bbox > $dest/$configFile
        echo "Processing ..........................................: $configFile"
        label-maker download -d $dest -c $dest/$configFile
        label-maker labels -d $dest -c $dest/$configFile
        label-maker images -d $dest -c $dest/$configFile
        label-maker package -d $dest -c $dest/$configFile
        mv $dest/labels.npz $dest/${country}_area${index}_labels.npz
        mv $dest/data.npz $dest/${country}_area${index}_data.npz
        mv $dest/classification.geojson $dest/${country}_area${index}_classification.geojson
        rm $dest/${country}.geojson
        rm $dest/${country}.mbtiles
        rm $dest/${country}-z18.mbtiles
        index=$((index+1))
    done < $bboxesFile
else
    label-maker download
    label-maker labels
    label-maker images
    label-maker package
fi




