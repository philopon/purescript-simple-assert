var gulp       = require('gulp');
var purescript = require('gulp-purescript');
var foreach    = require('gulp-foreach');
var mocha      = require('gulp-mocha');

var path       = require('path');

var sources =
    ['bower_components/purescript-*/src/**/*.purs'
    ,'src/**/*.purs'
    ];

var ffis = ['bower_components/purescript-*/src/**/*.js']

gulp.task('psc', function(){
  return purescript.psc({
    src: sources,
    ffi: ffis
    });
});

gulp.task('psci', function(){
  return purescript.psci({
    src: sources,
    ffi: ffis
    });
});

gulp.task('pscDocs', function(){
  return purescript.pscDocs({
    src: sources,
    docgen: 'Test.Assert.Simple'
  }).pipe(gulp.dest('docs.md'));
});

gulp.task('default', ['psc', 'psci', 'pscDocs'])
