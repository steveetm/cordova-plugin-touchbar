const exec = require('cordova/exec');

const PLUGIN_NAME = 'TouchBarPlugin';

String.prototype.capitalize = function () {
    return this.charAt(0).toUpperCase() + this.slice(1);
};
const {
    TBUniqueIdentifierViolationError,
    TBIdentifierNotDefined,
    TBMissingConfiguration
} = require('./errors');

class TouchBarItem {
    constructor(properties) {
        this.events = {};
        if (!properties) {
            throw new TBMissingConfiguration()
        }
        this.properties = properties;
        if (!properties.identifier) {
            properties.identifier = `${properties.type}.autogenid.${TouchBarItem.generateId()}`;
        }
    }

    static generateId() {
        if (!this.generator) {
            let i = 0;
            this.generator = () => i++;
        }
        return this.generator();
    }


    addEventListener(event, handler) {
        if (!this.events[event]) {
            this.events[event] = [];
        }
        this.events[event].push(handler);
    }

    removeEventListener(event, handler) {
        if (!this.events[event]) {
            this.events[event] = [];
        }
        this.events[event] = this.events[event].filter(element => element !== handler);
    }

    dispatchEvent(event, scope, ...args) {
        const eventName = `on${event.capitalize()}`;
        if (this.properties[eventName]) {
            this.properties[eventName].call(this, ...args);
        }
        if (this.events[event] && this.events[event].length > 0) {
            this.events[event].forEach(event => event.call(scope, ...args));
        }
    }

    setProperties(newProperties) {
        exec(null, null, PLUGIN_NAME, 'modifyNSButton', newProperties);

    }
}

class TouchBar {
    constructor() {
        this._touchBarItems = {};
    }

    _isExists(identifier) {
        return Boolean(this._touchBarItems[identifier]);
    }

    _checkItemIdentifiers(itemIdentifiers) {
        window.identifiers = require('./identifiers');
        const searchArray = [...Object.keys(this._touchBarItems), ...Object.values(identifiers.elements)];
        window.searchArray= searchArray;
        window.itemIdentifiers= itemIdentifiers;
        const missingItems = itemIdentifiers.filter(identifier => searchArray.indexOf(identifier) < 0);
        if (missingItems.length > 0) {
            throw new TBIdentifierNotDefined('Identifiers not defined', itemIdentifiers);
        }
    }

    setDefaultItemIdentifiers(itemIdentifiers) {
        const self = this;
        return new Promise((resolve, reject) => {
            self._checkItemIdentifiers(itemIdentifiers);
            exec(resolve, reject, PLUGIN_NAME, 'setDefaultItemIdentifiers', [...itemIdentifiers]);
        });
    }

    eventHandler(eventObj) {
        const eventType = eventObj.event;
        const value = eventObj.value;
        const identifier = eventObj.identifier;

        const TouchBarItem = this.getItem(identifier);

        if (TouchBarItem) {
            TouchBarItem.dispatchEvent(eventType, TouchBarItem, value);
        }
    }

    defineTouchBarItems(items) {
        const self = this;
        let duplicateItems = [];
        return new Promise((resolve, reject) => {
            items.forEach(item => {
                if (self._isExists(item.identifier)) {
                    duplicateItems.push(item);
                }
                if (!item instanceof TouchBarItem) {
                    self._touchBarItems[item.identifier] = item;
                } else {
                    self._touchBarItems[item.identifier] = new TouchBarItem(item);
                }
            });
            if (duplicateItems.length > 0) {
                reject(new TBUniqueIdentifierViolationError('Unique identifier expected on every item', duplicateItems));
            } else {
                exec(resolve, null, PLUGIN_NAME, 'defineTouchBarItems', items);
                this._setCallbackHandler(this.eventHandler.bind(this));
            }
        });
    }

    getItem(identifier) {
        return this._touchBarItems[identifier];
    }

    on(identifier, event, handler) {
        if (this.getItem(identifier)) {
            this.getItem(identifier).addEventListener(event, handler);
        }
    }

    un(identifier, event, handler) {
        if (this.getItem(identifier)) {
            this.getItem(identifier).removeEventListener(event, handler);
        }
    }

    _setCallbackHandler(callback) {
        exec(callback, null, PLUGIN_NAME, '_setCallbackHandler', []);
    }

}

module.exports = {
    TouchBar,
    TouchBarItem,
    identifiers: require('./identifiers')
};


///