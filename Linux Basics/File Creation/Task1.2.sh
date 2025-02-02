# Create 20 files with .txt extensions 
for i in {1..20}; do touch "file_$i.txt"; done
# rename the first 5 files to .yml extension  
for i in {1..5}; do mv "file_$i.txt" "file_$i.yml"; done
# Print the latest created top 5 files among the total no of files".
ls-lt | head -5
