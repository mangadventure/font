require! {
  fs,
  readline,
  gulp,
  \gulp-sass,
  \gulp-fontello,
  \gulp-fontello-import,
  os: {EOL: N}
}

gulp.task \fontello:import (done) !->
  gulp-fontello-import.importSvg do
    svgsrc: \icons
    config: \config.json
    done

gulp.task \fontello:download ->
  gulp.src \config.json
    .pipe gulpFontello assetsOnly: false
    .pipe gulp.dest __dirname

gulp.task \dist:transform (done) ->
  readline.createInterface do
    input: fs.createReadStream \css/mangadventure-codes.css
    output: fs.createWriteStream \src/_codes.scss
  .on \line !->
    m = it.match /^\.mi-([\w-]+):before.*'\\([0-9a-f]+)'.*/
    @output.write if m is null
      then "$codes: (#N"
      else "  '#{m.1}': '#{m.2}',#N"
    global.range = m?.2
  .on \close !->
    @output.write ");#N#N\$range: 'u+f101-#range';#N"
    done!

gulp.task \dist:compile ->
  gulp.src \src/mangadventure.scss
    .pipe gulp-sass(
      outputStyle: \compressed
      compiler: require \node-sass
    ).on \error gulp-sass.logError
    .pipe gulp.dest \dist

gulp.task \fontello gulp.series <[fontello:import fontello:download]>

gulp.task \dist gulp.series <[dist:transform dist:compile]>

gulp.task \default gulp.series <[fontello dist]>
