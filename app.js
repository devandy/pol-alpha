var http = require('http'),
    ss = require('socketstream'),
    everyauth = require('everyauth');

ss.client.define('pol', {
    view: 'pol.html',
    css:  ['libs'],
    code: [
        'libs/jquery.min.js',
        'libs/jquery-ui.min.js',
        'libs/jquery.ui.position.js',
        'libs/jquery-transit.min.js',
        'libs/jquery.contextMenu.js',
        'libs/underscore.min.js',
        'libs/backbone-min.js',
        'libs/bootstrap.min.js',
        'pol'],
    tmpl: '*'
});

ss.http.route('/chat', function(req, res){
  res.serveClient('chat');
});
ss.http.route('/', function(req, res){
    res.serveClient('pol');
});
everyauth.facebook
    .scope('email')
    .appId('262276250559418')
    .appSecret('291a6d02a5026ce17d00c7f35716a879')
    .findOrCreateUser( function (session, accessToken, accessTokExtra, fbUserMetadata) {
        var userName = fbUserMetadata.name;
        console.log('Facebook Username is', userName);
        session.userId = userName;
        session.save();
        return true;
    })
    .redirectPath('/');

ss.http.middleware.prepend(ss.http.connect.bodyParser());
ss.http.middleware.append(everyauth.middleware());

// Code Formatters
ss.client.formatters.add(require('ss-coffee'));
ss.client.formatters.add(require('ss-stylus'));

// Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use(require('ss-hogan'));

// Minimize and pack assets if you type: SS_ENV=production node app.js
if (ss.env === 'production') ss.client.packAssets();

// Start web server
var server = http.Server(ss.http.middleware);
server.listen(3000);

// Start SocketStream
ss.start(server);




//everyauth.twitter
//    .consumerKey('CMkKT5wVGNukREhvC68M7g')
//    .consumerSecret('kqSXhbPzPM3CY5NT7Cbuk1ezsJfrWGNBd37Sdi7unQw')
//    .findOrCreateUser( function (session, accessToken, accessTokenSecret, twitterUserMetadata) {
//        var userName = twitterUserMetadata.screen_name;
//        console.log('Twitter Username is', userName);
//        session.userId = userName;
//        session.save();
//        return true;
//    })
//    .redirectPath('/pol');
