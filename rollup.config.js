import path from 'path';
import babel from 'rollup-plugin-babel';
import commonjs from 'rollup-plugin-commonjs';
import {terser} from 'rollup-plugin-terser';
import resolve from 'rollup-plugin-node-resolve';

var input = path.join(__dirname, 'lib', 'incito.js');

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
        extensions: ['.js', '.jsx', '.es6', '.es', '.mjs']
    });

let configs = [
    {
        input,
        output: {
            file: outputs.CJS,
            format: 'cjs'
        },
        plugins: [
            commonjs({
                extensions: ['.js']
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
            commonjs({
                extensions: ['.js']
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
            commonjs({
                extensions: ['.js']
            }),
            getBabelPlugin(),
            resolve({browser: true})
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
            commonjs({
                extensions: ['.js']
            }),
            getBabelPlugin(),
            resolve({browser: true}),
            terser()
        ]
    }
];

// Only output unminified browser bundle in development mode
if (process.env.NODE_ENV === 'development') configs = [configs[2]];

export default configs;
