// permet de transformer la librairie node.js en api
var express = require('express');

//résout un problème avec CORS
var cors = require('cors')

// permet de parser les données reçues avec POST
var bodyParser = require("body-parser");

// importe les classes de José Maillard et Lucas Trampal
var BullGamma = require("./machine/bullGamma").BullGamma;
var constants = require("./machine/constants");
var Debug = require("./control/debug").Debug;
var Editor = require("./control/editor").Editor;
var Execution = require("./control/execution").Execution;
var CodeLibrary = require("./control/code_lib").CodeLibrary;

// paramètres du serveur.
var HOSTNAME = '192.168.1.18';
var PORT = 8001;



class ServedMachine {

	constructor() {
		this.bullGamma = new BullGamma   ();
    this.debug     = new Debug       (this.bullGamma);
    this.editor    = new Editor      (this.bullGamma);
    this.execution = new Execution   (this.bullGamma);
    this.codelib   = new CodeLibrary ();
	}

  loadProgram(name) {
    this.editor.editConnexionArray(
			this.codelib.getProgram(name, "series3")
		);
		this.editor.editDrum(
			this.codelib.getProgram(name, "drum") || ""
		);
		for (let i=1; i<constants.NB_BANAL_MEMORIES; i++) {
			if (this.codelib.getProgram(name, "m" + i)) {
				this.debug.setMemory(this.codelib.getProgram(name, "m" + i), i, 0);
			}
		}
		this.execution.console.push('Programme "' + this.codelib.getDisplayName(name) + '" chargé');
  }

	continue() {
		this.execution.executeUntil(0, 3);
		console.log(this.execution.getCurrentLine());
	}

	titille() {
		this.execution.executeNextInstruction();
	}

  // hexcode est un string composé de mots de 4 lettres hexadecimales
	editConnexionArray(hexCode) {
		this.editor.editConnexionArray(hexCode);
	}

	editDrum(hexCode) {
		this.editor.editDrum(hexCode);
	}

};

testmachine = new ServedMachine();
testmachine.loadProgram("suite_de_fibonacci");
var activeMachines = {0:testmachine};



var app = express();
var router = express.Router();


// cree une machine et renvoie son numéro
router.route('/cree_machine')
.get(function(req,res){
			i = 0;
			while (activeMachines[i]){i++;}
			machine = new ServedMachine();
			activeMachines[i] = machine;
			console.log("machine " + i + " créée");
			res.json({message : "" + i});
});

// cree une machine et renvoie son numéro
router.route('/supprime_machine')
.get(function(req,res){
			console.log("supprime machine " + req.query.id);
	    res.json({message : "machine deletion order received"});
			if (req.query.id != undefined && parseInt(req.query.id) != 0){
				console.log("machine " + req.query.id + " supprimée");
				delete activeMachines[parseInt(req.query.id)];
			}
			//req.query.id
});


// cree une machine et renvoie son numéro
router.route('/charge_programme')
.get(function(req,res){
			console.log("charge programme");
	    res.json({message : "program loading request received"});
			activeMachines[req.query.id].loadProgram("suite_de_fibonacci");
});


// renvoie le contenu de la console
router.route('/console')
.get(function(req,res){
			console.log("console de la machine " + req.query.id);
	    res.json({message : activeMachines[req.query.id].execution.console.getLines()});
});

// execute le programme en continu
router.route('/continue')
.get(function(req,res){
 			console.log("continue de la machine " + req.query.id);
 			res.json({message : "continue order received"});
			activeMachines[req.query.id].continue();
});

// execute le programme en continu
router.route('/titille')
.get(function(req,res){
 			console.log("titille de la machine " + req.query.id);
 			res.json({message : "titille order received"});
			activeMachines[req.query.id].titille();
});

// charge une suite d'instructions sur le tableau de connexions
router.route('/edit_connexion_array')
.get(function(req,res){
 			console.log("edition du panneau de connexion de la machine " + req.query.id);
 			res.json({message : "connexion edition order received"});
			activeMachines[req.query.id].editConnexionArray(req.query.program);
});

// recrée une nouvelle machine <=> reboot de la machine
router.route('/reboot')
.get(function(req,res){
 			console.log("reboot de la machine " + req.query.id);
 			res.json({message : "reboot order received"});
			machine = new ServedMachine();
			activeMachines[req.query.id] = machine;
			console.log("machine " + req.query.id + " reboot");
});


app.use(cors())
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(router);
app.listen(PORT, HOSTNAME, function(){
	console.log("serveur lancé: "+ HOSTNAME +":"+PORT+"\n");
});
