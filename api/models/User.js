var sortKeys = require('sort-keys');

/**
* User.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

// TODO: Hacer que el email sea obligatorio pero el nombre de usuario no.
// El nombre de usuario es más bien la forma corta del email

module.exports = {

  // Enforce model schema in the case of schemaless databases
  schema: true,

  attributes: {
    username  : {
      type: 'string',
      unique: true,
    },

    email     : {
      type: 'email',
      unique: true,
      required: true
    },

    passports : {
      collection: 'Passport',
      via: 'user'
    },

    toJSON: function() {
      var obj = this.toObject();
      delete obj.passports;
      return sortKeys(obj);
    }
  }
};
