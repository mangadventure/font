require! {
  fs,
  readline,
  gulp,
  \gulp-stylus,
  \gulp-fontello,
  \gulp-fontello-import
}

gulp.task \fontello:import (done) !->
  gulp-fontello-import.importSvg do
    svgsrc: \icons
    config: \config.json
    done

gulp.task \fontello:download ->
  gulp.src \config.json
    .pipe gulp-fontello assetsOnly: false
    .pipe gulp.dest __dirname

gulp.task \dist:transform (done) ->
  readline.createInterface do
    input: fs.createReadStream \css/mangadventure-codes.css
    output: fs.createWriteStream \src/codes.styl
  .on \line !->
    m = it.match /^\.mi-([\w-]+):before.*'\\([0-9a-f]+)'.*/
    @output.write if m is null
      then "codes = {\n"
      else "  #{m.1}: #{m.2},\n"
    global.range = m?.2
  .on \close !->
    @output.write "}\n\nrange = \"u+f101-#range\"\n"
    done!

gulp.task \dist:compile ->
  gulp.src \src/mangadventure.styl
    .pipe gulp-stylus compress: true
    .pipe gulp.dest \dist

gulp.task \fontello gulp.series <[fontello:import fontello:download]>

gulp.task \dist gulp.series <[dist:transform dist:compile]>

gulp.task \default gulp.series <[fontello dist]>
