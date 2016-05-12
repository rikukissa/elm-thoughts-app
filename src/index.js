
var Elm = require('./Main');
var styles = require('./Stylesheets');

var app = Elm.embed(Elm.Main, document.getElementById('main'), { swap: false });

var prevThoughs = [];

app.ports.scrollDown.subscribe(function(newThoughts) {

  if(prevThoughs.length === newThoughts.length) {
    return;
  }

  prevThoughs = newThoughts;

  var $thoughts = document.getElementById('thoughts');

  if(!$thoughts) {
    return;
  }

  setTimeout(function() {
    $thoughts.scrollTop = $thoughts.scrollHeight;
  }, 100)
});
