/*
 * This script will check old Laine-style hashes when the page has been loaded and redirects
 * to the correct address if such a hash is found.
 * This is done in JS because the hash is not sent to the server.
 */

(function () {
  var RE = [
    [
      /^\#\!\/(\d{4})\/(\d\d)\/(\d\d)\/(.*)$/,
      '/$1/$2/$3/$4'
    ],
    [
      /^\#\!\/tag\/([^\/]+)$/,
      '/tag/$1'
    ],
    [
      /^\#\!\/tag\/([^\/]+)(\/\d+)$/,
      '/tag/$1/p/$2'
    ],
    [
      /^\#\!\/archives\/(\d{4})$/,
      '/archive/$1'
    ],
    [
      /^\#\!\/archives\/(\d{4})(\/\d+)$/,
      '/archive/$1/p/$2'
    ],
    [
      /^\#\!\/archives\/(\d{4})\/(\d\d)$/,
      '/archive/$1/$2'
    ],
    [
      /^\#\!\/archives\/(\d{4})\/(\d\d)(\/\d+)$/,
      '/archive/$1/$2/p/$3'
    ],
    [
      /^\#\!\/(.*)$/,
      '/$1'
    ]
  ];

  var currentHash = window.location.hash;

  if (currentHash) {
    for (var i = 0; i < RE.length; ++i) {
      var results = RE[i][0].exec(currentHash);

      if (results !== null) {
        window.location.replace(currentHash.replace(RE[i][0], RE[i][1]));
        break;
      }
    }
  }
}());
