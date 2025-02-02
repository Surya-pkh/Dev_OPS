# Create a directory called ""my_folder""
mkdir my_folder

# navigate into it 
cd my_folder

#create a file named ""my_file.txt"" with some text.
echo "This is is the Original file" > my_file.txt

# Then, create another file named ""another_file.txt"" with some text.
echo "another file has been created" > another_file.txt

# Concatenate the content of ""another_file.txt"" to ""my_file.txt"" and display the updated content.
cat another_file.txt >> my_file.txt
cat my_file.txt

# Finally, list all files and directories in the current directory.
ls -l
