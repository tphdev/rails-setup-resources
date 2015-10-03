insert_after(){
  STRMATCH=$1
  PRINTVAL=$2
  FILENAME=$3

  awk "/$STRMATCH/{print;print \"$PRINTVAL\";next}1" $FILENAME > ./somewhere.tmp && mv ./somewhere.tmp $FILENAME   
}

echo "-------------------------"
echo "New Project"
echo "-------------------------"
echo $1 "-------"
echo "-------------------------"

#Sets up new rails project
rails new $1

#Define Paths from ROOT Directory
JS_PATH="./app/assets/javascripts/"
CSS_PATH="./app/assets/stylesheets/"

#Changes Into ROOT Directory for project
cd $1

#Add Standard Gems
echo "gem 'faker'"  >> Gemfile
echo "gem 'acts_as_follower'" >> Gemfile
echo "gem 'simple_form'" >> Gemfile
echo "gem 'bootstrap-sass', '~> 3.3.5'" >> Gemfile
echo "gem 'rails_12factor'" >> Gemfile
echo "gem 'underscore-rails" 


# Add Minitest to the gemlist
echo "gem 'minitest-rails'" >> Gemfile

gemlist=(
  "  gem 'launchy'"
  "  gem 'minitest-reporters'" 
  "  gem 'minitest-rails-capybara'" 
)

buildit=""
for i in "${gemlist[@]}" ; do
 buildit="$i\n$buildit"
done

insert_after 'group :development, :test do' "$buildit"  ./Gemfile

bundle install

#add underscore to requires
insert_after '\/\/= require jquery_ujs' "//= require underscore" $JS_PATH/application.js

#Setup Bootstrap
mv $CSS_PATH/application.css $CSS_PATH/application.scss
echo "@import 'bootstrap-sprockets';" >> $CSS_PATH/application.scss
echo "@import 'bootstrap';" >> $CSS_PATH/application.scss

#boilerplate css
curl https://raw.githubusercontent.com/t3patterson/resources/master/boilerplate.scss >> $CSS_PATH/application.scs