    var exec = require('cordova/exec');

    var FilesPlugin = function () {
    };

	FilesPlugin.prototype.openWith = function (path, successCallback, errorCallback) {
		if (errorCallback == null) { errorCallback = function () { } }
        if (typeof errorCallback != "function") {
            console.log("FilesPlugin.openWith failure: failure parameter not a function");
            return
        }

        if (typeof successCallback != "function") {
            console.log("FilesPlugin.openWith failure: success callback parameter must be a function");
            return
        }
		exec(successCallback, errorCallback, "FilesPlugin", "openWith", [path]);
	};

	FilesPlugin.prototype.resolveNativePath = function (path, successCallback, errorCallback) {
        if (errorCallback == null) { errorCallback = function () { } }
        if (typeof successCallback != "function") {
            console.log("FilePath.resolveNativePath failure: success callback parameter must be a function");
            return;
        }
        exec(successCallback, errorCallback, "FilesPlugin", "resolveNativePath", [path]);
    };

    FilesPlugin.prototype.checkAppVersion = function (path, successCallback, errorCallback) {
        if (errorCallback == null) { errorCallback = function () { } }
        if (typeof successCallback != "function") {
            console.log("FilePath.checkAppVersion failure: success callback parameter must be a function");
            return;
        }
        exec(successCallback, errorCallback, "FilesPlugin", "checkAppVersion", [path]);
    };

    FilesPlugin.prototype.avialableStorageSpace = function (path, successCallback, errorCallback) {
        if (errorCallback == null) { errorCallback = function () { } }
        if (typeof successCallback != "function") {
            console.log("FilePath.avialableStorageSpace failure: success callback parameter must be a function");
            return;
        }
        exec(successCallback, errorCallback, "FilesPlugin", "avialableStorageSpace", [path]);
    };

    FilesPlugin.prototype.usedStoargeSpace = function (path, successCallback, errorCallback) {
        if (errorCallback == null) { errorCallback = function () { } }
        if (typeof successCallback != "function") {
            console.log("FilePath.usedStoargeSpace failure: success callback parameter must be a function");
            return;
        }
        exec(successCallback, errorCallback, "FilesPlugin", "usedStoargeSpace", [path]);
    };

    FilesPlugin.prototype.writeBinaryData = function (fileName, data, position, successCallback, errorCallback) {
        if (errorCallback == null) { errorCallback = function () { } }
        if (typeof errorCallback != "function") {
            console.log("FilesPlugin.writeBinaryData failure: failure parameter not a function");
            return
        }

        if (typeof successCallback != "function") {
            console.log("FilesPlugin.writeBinaryData failure: success callback parameter must be a function");
            return
        }
        exec(successCallback, errorCallback, "FilesPlugin", "writeBinaryData", [fileName, data, position]);
    };

    FilesPlugin.prototype.uploadFile = function (params, successCallback, errorCallback) {
        if (errorCallback == null) { errorCallback = function () { } }

        if (typeof errorCallback != "function") {
            console.log("FilesPlugin.uploadFile failure: failure parameter not a function");
            return
        }

        if (typeof successCallback != "function") {
            console.log("FilesPlugin.uploadFile failure: success callback parameter must be a function");
            return
        }

        exec(successCallback, errorCallback, "FilesPlugin", "uploadFile", [params]);
    };

    FilesPlugin.prototype.downloadFile = function (params, successCallback, errorCallback) {
        if (errorCallback == null) { errorCallback = function () { } }

        if (typeof errorCallback != "function") {
            console.log("FilesPlugin.downloadFile failure: failure parameter not a function");
            return
        }

        if (typeof successCallback != "function") {
            console.log("FilesPlugin.downloadFile failure: success callback parameter must be a function");
            return
        }

        exec(successCallback, errorCallback, "FilesPlugin", "downloadFile", [params]);
    };

    if (!window.plugins) {
        window.plugins = {};
    }

    if (!window.plugins.FilesPlugin) {
        window.plugins.FilesPlugin = new FilesPlugin();
    }

    if (module.exports) {
        module.exports = window.plugins.FilesPlugin;
    }
