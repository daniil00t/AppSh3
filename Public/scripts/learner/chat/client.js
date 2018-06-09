(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var App, React;

React = require('react');

App = require('./app');

React.render(React.createElement(App, null), document.getElementById('app'));



},{"./app":2,"react":"react"}],2:[function(require,module,exports){
var App, Header, React;

React = require("react");

Header = require("./components/header");

App = React.createClass({
  displayName: "App",
  render: function() {
    return React.createElement(Header, null);
  }
});

module.exports = App;



},{"./components/header":3,"react":"react"}],3:[function(require,module,exports){
var Header, React;

React = require("react");

Header = React.createClass({
  displayName: "Header",
  render: function() {
    return React.createElement("header", null, "\t\t\tHeader");
  }
});

module.exports = Header;



},{"react":"react"}]},{},[1]);
