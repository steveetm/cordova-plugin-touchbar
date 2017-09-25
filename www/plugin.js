cordova.define("cordova-plugin-touchbar.plugin", function (require, exports, module) {

    var exec = require('cordova/exec');

    var PLUGIN_NAME = 'TouchBarPlugin';

    var TouchBar = {
            _identifiers: {},
            setDefaultItemIdentifiers: function (itemIdentifiers, cb) {
                exec(cb, null, PLUGIN_NAME, 'setDefaultItemIdentifiers', [...itemIdentifiers]);
            },
            buttonEventHandler: function (eventObj) {
                let pressedButton = Object.keys(this._identifiers).find((identifierKey) => {
                    return this._identifiers[identifierKey].identifier === eventObj.identifier
                });

                if (pressedButton) {
                    this._identifiers[pressedButton].onTap();
                }
            },
            defineTouchBarItems: function (items, cb) {
                items.forEach(item => this._identifiers[item.identifier] = item);
                exec(cb, null, PLUGIN_NAME, 'defineTouchBarItems', items);
                this._setCallbackHandler(this.buttonEventHandler.bind(this));

            },
            _setCallbackHandler: function (callback) {
                exec(callback, null, PLUGIN_NAME, '_setCallbackHandler', []);
            },
            identifiers: {
                otherItemsProxy:
                    'NSTouchBarItemIdentifierOtherItemsProxy',
                characterPicker:
                    'NSTouchBarItemIdentifierCharacterPicker',
                fixedSpaceSmall:
                    'NSTouchBarItemIdentifierFixedSpaceSmall',
                fixedSpaceLarge:
                    'NSTouchBarItemIdentifierFixedSpaceLarge'
            }
        }
    ;

    module.exports = TouchBar;

})
;
