/*********************************/
/*****		Global Require		******/
/*********************************/
'use strict';

var gulp = require('gulp');
var gulpif = require('gulp-if');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var stripDebug = require('gulp-strip-debug');
var minifyhtml = require('gulp-minify-html');
var sass = require('gulp-sass');
var rename = require('gulp-rename');
var file = require('file');
var clean = require('gulp-clean');
var postcss = require('gulp-postcss');
var autoprefixer = require('autoprefixer');
var flexibility = require('postcss-flexibility');
var cleanCSS  = require('gulp-clean-css');

//gulpif(if문사용) , file(폴더 읽기 - 파일읽고 싶은 경우는 fs = require('fs'))


/*********************************/
/******** Global Variables *******/
/*********************************/
var src = '';
var isProd = false;
var dist = '';
var DEV_FILE_LIST = [];
var DEV_DIR_LIST_JS = ['./js/'];
var DEV_DIR_LIST_CSS = ['./css/'];
var preprocessors = [
    autoprefixer({browsers: ['last 30 versions'], cascade: false}),
    flexibility(),
];

/*********************************/
/*****	Global Configuration *****/
/*********************************/
/*
 gulp.src([
	'public/src/js/loginForm.js'
	'public/src/js/slider/*.js'
	'!public/src/js/slider/slider-beta.js'
	] ...);
	=> !는 !뒤에 파일은 포함하지 말라는 의미 , 바로 앞 와일드카드
	
	stripDebug : alert과 console 제거
	uglify  : 압축
	concat : 병합 이름.
	dest : 출력위치
	
	path 세팅 
	하단 js : 부분의 js/모든폴더/devjs/*.js 를 가르킨다.
 */

var paths = {
		js: 'js/**/devjs/*.js',
		scss: '/scss/*.scss',
		html: '/**/*.html'
	};



/*gulp.src('js/main/devjs/*.js')
.pipe(stripDebug())
.pipe(uglify())
.pipe(concat('main.js'))
.pipe(gulp.dest('js/main'));
*/


/*
 * DEV_DIR_LIST 배열의 callback으로 path를 받고 그것을 file.walkSync(path, function(dirPath, dirs, files)
 * 이렇게 넘겨줌 
 * 
 * file.walkSync(start, callback)
 * start 아래의 모든 폴더들을 callback 함수로 받음  (dirPath, dirs, files) => files
 * 
 * */

gulp.task('devListJs', function(done) {
    DEV_FILE_LIST = [];
    DEV_DIR_LIST_JS.forEach(function(path) {
        file.walkSync(path, function(dirPath, dirs, files) {
            files.forEach(function(fileName) {
                if((fileName.indexOf('js') != -1) && dirPath.indexOf('devjs') != -1) {
                    DEV_FILE_LIST.push({
                        src : dirPath + '\\' + fileName,
                        dest : dirPath + '\\..\\',
                        dirPath : dirPath,
                        fName : fileName
                    });
                }
            });
        });
    });
    done();
});

gulp.task('devListCss', function(done) {
    DEV_FILE_LIST = [];
    DEV_DIR_LIST_CSS.forEach(function(path) {
        file.walkSync(path, function(dirPath, dirs, files) {
            files.forEach(function(fileName) {
                if(fileName.indexOf('scss') != -1 && dirPath.indexOf('scss') != -1 && fileName.indexOf('_') == -1) {
                	DEV_FILE_LIST.push({
                        src : dirPath + '\\' + fileName,
                        dest : dirPath + '\\..\\',
                        dirPath : dirPath,
                        fName : fileName
                    });
                }
            });
        });
    });
    done();
});

gulp.task('js', function() {
    var taskName = 'watchaem';
    gulp.start(['devListJs']);
    gulp.start(['common-minify-js']);
    //gulp.start(['common-minify-editor']);
    
    DEV_FILE_LIST.forEach(function(list) {
    	gulp.src(list.src)
    	.pipe(gulpif(isProd, stripDebug()))
        .pipe(gulpif(isProd, uglify().on('error', function(e) {
            console.log(e);
        })))
    	.pipe(concat(list.fName))
    	.pipe(gulp.dest(list.dest));
    });
});

gulp.task('css', function() {
    //여러 태스크 실행가능.
    gulp.start(['devListCss']);
    gulp.start(['common-minify-css']);
    
    DEV_FILE_LIST.forEach(function(list) {
    	gulp.src(list.src)
        .pipe(concat(list.fName))
        .pipe(sass({
            outputStyle: isProd ? 'compressed' : 'expanded',
            includePaths: [require('node-bourbon').includePaths]
        }).on('error', sass.logError))
        //.pipe(rename({ basename: list.fName }))
        .pipe(postcss(preprocessors))
        .pipe(gulp.dest(list.dest))
        .on('end', function() {
            console.log('Finished : ' +list.src);
        });
    	
    });
});

gulp.task('common-minify-css', () => {
    return gulp.src('./css/_common.css')
   .pipe(cleanCSS())
   .pipe(concat('common.css'))
   .pipe(gulp.dest('./css/'));
});

gulp.task('common-minify-js', () => {
    return gulp.src('./js/_common.js')
    .pipe(gulpif(isProd, stripDebug()))
    .pipe(gulpif(isProd, uglify().on('error', function(e) {
        console.log(e);
    })))
    .pipe(concat('common.js'))
    .pipe(gulp.dest('./js/'));
});

// editor 사용 minify

var paths = {
    editorLibJs : 'js/editor/lib/**/*.js',
    editorLibCss : 'js/editor/lib/**/*.css',
    editorDistJs : 'js/editor/dist/*.js',
    editorDistCss : 'js/editor/dist/*.css'
    
};

gulp.task('common-minify-editor', () => {
    gulp.start(['common-minify-editorcss']);
    return gulp.src([paths.editorLibJs, paths.editorDistJs ])
    .pipe(gulpif(isProd, stripDebug()))
    .pipe(gulpif(isProd, uglify().on('error', function(e) {
        console.log(e);
    })))
    .pipe(concat('editor.js'))
    .pipe(gulp.dest('./js/editor/'));
});

gulp.task('common-minify-editorcss', () => {
    return gulp.src([paths.editorLibCss, paths.editorDistCss ])
   .pipe(cleanCSS())
   .pipe(concat('editor.css'))
   .pipe(gulp.dest('./js/editor/'));
});

