# echo Is this a Ruby project? (Y/N)
# read ruby
# echo Are you using circle ci? (Y/N)
# read circle
#
# cp ./files/general/ .

ruby=
circle=
until [[ $ruby = "y" || $ruby = "n" ]] && [[ $circle = "y" || $circle = "n" ]]; do
  echo "Is this a Ruby project? (Y/N)"
  read ruby
  echo "Are you using circle ci? (Y/N)"
  read circle
done

echo "Copying the dockerizing files"
cp -r ./files/general/* ./test

if [[ $ruby = "y" ]]; then
  echo "Copying Ruby setup files"
  cp -r ./files/ruby/scripts/* ./test/scripts/
fi

if [[ $circle = "y" ]]; then
  echo "Copying Circle CI setup files"
  cp -r ./files/circle_ci/* ./test/
fi
