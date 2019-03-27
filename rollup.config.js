import coffeescript from 'rollup-plugin-coffee-script';
import commonjs from 'rollup-plugin-commonjs';
import resolve from 'rollup-plugin-node-resolve';
import {terser} from 'rollup-plugin-terser';
import path from 'path';
import babel from 'rollup-plugin-babel';
import globals from 'rollup-plugin-node-globals';

var input = path.join(__dirname, 'lib', 'coffeescript', 'incito.coffee');

var outputs = {
    // Exclusive bundles(external `require`s untouched), for node, webpack etc.
    CJS: path.join(__dirname, 'dist', 'incito.cjs.js'), // CommonJS
    ES: path.join(__dirname, 'dist', 'incito.es.js'), // ES Module
    // Inclusive bundles(external `require`s resolved), for browsers etc.
    UMD: path.join(__dirname, 'dist', 'incito.js'),
    UMDMin: path.join(__dirname, 'dist', 'incito.min.js')
};

const getBabelPlugin = () =>
    babel({
        exclude: ['node_modules/**'],
        extensions: ['.js', '.jsx', '.es6', '.es', '.mjs', '.coffee']
    });

let configs = [
    {
        input,
        output: {
            file: outputs.CJS,
            format: 'cjs'
        },
        plugins: [
            coffeescript(),
            commonjs({
                extensions: ['.js', '.coffee']
            }),
            getBabelPlugin()
        ]
    },
    {
        input,
        output: {
            file: outputs.ES,
            format: 'es'
        },
        plugins: [
            coffeescript(),
            commonjs({
                extensions: ['.js', '.coffee']
            }),
            getBabelPlugin()
        ]
    },
    {
        input,
        output: {
            file: outputs.UMD,
            format: 'umd',
            name: 'Incito'
        },
        plugins: [
            coffeescript(),
            resolve({
                jsnext: true,
                main: true,
                browser: true,
                preferBuiltins: false
            }),
            commonjs({
                extensions: ['.js', '.coffee']
            }),
            globals(),
            getBabelPlugin()
        ]
    },
    {
        input,
        output: {
            file: outputs.UMDMin,
            format: 'umd',
            name: 'Incito'
        },
        plugins: [
            coffeescript(),
            resolve({
                jsnext: true,
                main: true,
                browser: true,
                preferBuiltins: false
            }),
            commonjs({
                extensions: ['.js', '.coffee']
            }),
            globals(),
            getBabelPlugin(),
            terser()
        ]
    }
];

// Only output unminified browser bundle in development mode
if (process.env.NODE_ENV === 'development') configs = [configs[2]];

export default configs;
