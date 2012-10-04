var http = require('http'),
    ss = require('socketstream'),
    everyauth = require('everyauth');

ss.client.define('pol', {
    view: 'pol.html',
    css:  [
        'game.styl',
        'libs'
    ],
    code: [
        'libs',
        'pol',
        'system'
    ],
    tmpl: '*'
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
        session.userId = userName;
        session.save();
        return true;
    })
    .redirectPath('/');
everyauth.everymodule.handleLogout( function (req, res) {
    delete req.session.userId;
    req.session.save();
    req.logout(); // The logout method is added for you by everyauth, too
    this.redirect(res, this.logoutRedirectPath());
});

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
//        session.userId = userName;
//        session.save();
//        return true;
//    })
//    .redirectPath('/pol');
