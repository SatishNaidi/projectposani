var config = require('12factor-config');
 
var cfg = config({
    mongoURI : {
        env      : 'MONGODB_URI',
        type     : 'string', // default
        required : true,
    }
});
