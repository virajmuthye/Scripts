#changes file extensios from txt to text
for f in *.txt; do 
    mv -- "$f" "${f%.txt}.text"
done
