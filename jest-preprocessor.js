var coffee = require('coffeescript');
var babelJest = require('babel-jest');
var babelOptions = JSON.parse(require('fs').readFileSync('./.babelrc'));

module.exports = {
    process: function(src, path) {
        if (path.endsWith('.coffee')) {
            src = coffee.compile(src, {bare: true});
        }
        src = babelJest.process(src, path, babelOptions);
        return src;
    }
};
