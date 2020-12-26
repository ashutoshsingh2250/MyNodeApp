#!/usr/bin/env node

//const dotenv = require('dotenv');
//dotenv.config();

const port = process.env.PORT;
const node_env = process.env.NODE_ENV;
let streamValue;

console.log(`NODE_ENV=${node_env}`)
console.log(`PORT=${port}`);

//Start reading from stdin so that we don't exit the process.
process.stdin.resume();

process.argv.forEach((val, index) => {
    if(val=='--stream'){
        streamValue = process.argv[index+1];
        console.log("streamValue="+streamValue);
    }
    //console.log(`${index}: ${val}`)
});


const EventEmitter = require('events')
const eventEmitter = new EventEmitter()
const fs=require('fs')

const folderName = `/Users/abc/Desktop/AddSkill/MyNodeApp/${node_env}`;
const subfolderdest = `/Users/abc/Desktop/AddSkill/MyNodeApp/${node_env}/dest`;
const subfoldersrc = `/Users/abc/Desktop/AddSkill/MyNodeApp/${node_env}/src`; 

eventEmitter.on('createFolders', () => {
    try {
        if (!fs.existsSync(folderName)) {
          fs.mkdirSync(folderName)
            if((!fs.existsSync(subfolderdest)) || (!fs.existsSync(subfoldersrc))) {
                fs.mkdirSync(subfolderdest);
                fs.mkdirSync(subfoldersrc);
            }
        }
    } catch (err) {
        console.error(err)
    }
})
//eventEmitter.emit('createFolders')


const moment=require('moment')
const fileName = moment().format('YYYY_MM_DD_HH_MM_SS');
const srcFilePath = `/Users/abc/Desktop/AddSkill/MyNodeApp/${node_env}/src/${fileName}.txt`;
const destFilePath= `/Users/abc/Desktop/AddSkill/MyNodeApp/${node_env}/dest/${fileName}.txt`;

eventEmitter.on('createSourceFile', () => {
    fs.writeFileSync(srcFilePath, 'Learn Node FS module - Src', (err) => {
        if (err) throw err;
        console.log('Src File is created successfully.');
    }); 
});
//eventEmitter.emit('createSourceFile');


eventEmitter.on('createDestFile', ()=> {
    if(streamValue) {
	console.log('inside streamValue=true');
	let writeStream=fs.createWriteStream(`${destFilePath}`)
	writeStream.write('This is a dest file stream.')
	writeStream.on('finish', ()=> {
	    console.log('Wrote Dest File - Streaming Copy')
	})

    } else {
	console.log('inside streamValue=false')
	fs.writeFileSync(destFilePath, 'Learn Node FS module - Dest', (err) => { 
	    if (err) throw err;
	    console.log('Dest File is created successfully.')
        })
    }
})

eventEmitter.emit('createFolders')
eventEmitter.emit('createSourceFile')
eventEmitter.emit('createDestFile')


process.on('SIGINT', ()=> {
    console.log('Received Interrupt Signal')
    process.exit(2)
})
