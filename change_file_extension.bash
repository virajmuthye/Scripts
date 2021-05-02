#changes the file extension
#changes file extensios from txt to text
#corresponding changes in the script below can be made to change different extensions to different extensions

for f in *.txt; do 
    mv -- "$f" "${f%.txt}.text"
done
