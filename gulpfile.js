// Node modules
var fs = require('fs'), vm = require('vm'), chalk = require('chalk');

// Gulp and plugins
var gulp = require('gulp'), concat = require('gulp-concat'),
  replace = require('gulp-replace'), uglify = require('gulp-uglify');

// Gulp minify for smallinizing our CSS
var minify = require('gulp-minify-css');

// Gulp filesize for printing sizes before and after minification
var size = require('gulp-size');

// SASS compiler
var sass = require('gulp-sass');

// Deleting files
var vinylPaths = require('vinyl-paths');
var del = require('del');

// Source maps
var sourcemaps = require('gulp-sourcemaps');

var node_path = 'node_modules/';

var dest_path = 'priv/static/';

// Minifies all JS files and copies to target path. Files are not concatenated
gulp.task('js', function() {
  return gulp.src([
      // Uncomment these two lines if you need bootstrap or jQuery
      node_path + 'jquery/dist/jquery.js',
      node_path + 'bootstrap-sass/assets/javascripts/bootstrap.js',
      'web/static/js/*.js'
    ])
  .pipe(concat('app.js'))
  .pipe(sourcemaps.init())
  .pipe(size({title: 'Original JS'}))
  .pipe(uglify({ preserveComments: false }).on('error', console.error.bind(console)))
  .pipe(size({title: 'Minified JS'}))
  .pipe(sourcemaps.write('./'))
  .pipe(gulp.dest(dest_path + 'js/'));
});

// Compiles SASS files. Will create one output file for each input file, but usually you
// only have app.scss which will be output as app.css
gulp.task('css', function() {
  return gulp.src([
      'web/static/css/*.scss'
    ])
    .pipe(sass().on('error', sass.logError))
    .pipe(sourcemaps.init())
    .pipe(size({title: 'Compiled CSS'}))
    .pipe(minify())
    .pipe(size({title: 'Minified CSS'}))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest(dest_path + 'css/'));
  });

// Copies images
gulp.task('images', function() {
  return gulp.src('web/static/images/*')
  .pipe(gulp.dest(dest_path + 'images/'));
});

// Copies images
gulp.task('build-images', function() {
  var contents = fs.readFileSync('config/config.exs', 'utf8');
  var beginStrDataPath = contents.substring(contents.indexOf('data_path'));
  var dataPath = beginStrDataPath.substring(beginStrDataPath.indexOf('"'), beginStrDataPath.indexOf(','));
  dataPath = dataPath.replace(new RegExp('"', 'g'), '').trim() + '/images/*';
  return gulp.src(dataPath)
  .pipe(gulp.dest(dest_path + 'images/'));
});

// Copies fonts
gulp.task('fonts', function() {
  return gulp.src([
    node_path + 'font-awesome/fonts/*',
    node_path + 'bootstrap-sass/assets/fonts/bootstrap/*'
  ])
  .pipe(gulp.dest(dest_path + 'fonts/'));
});

// Removes all files from dest_path
gulp.task('clean', function() {
  return gulp.src(dest_path + '**/*', { read: false })
  .pipe(vinylPaths(del));
});

gulp.task('build-production', ['js', 'css', 'images', 'fonts'], function(callback) {
  callback();
  console.log('\nPlaced optimized files in ' + chalk.magenta(dest_path));
});

gulp.task('default', ['js', 'css', 'images', 'build-images' 'fonts'], function(callback) {
  callback();
  console.log('\nPlaced optimized files in ' + chalk.magenta(dest_path));
});
