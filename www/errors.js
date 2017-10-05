class TBError extends Error {
    constructor(msg) {
        super(msg);
        this.name = this.constructor.name;
    }
}

class TBUniqueIdentifierViolationError extends TBError {
    constructor(msg, identifiers) {
        super(msg);
        this.violatingIdentifiers = identifiers;
    }
}

class TBIdentifierNotDefined extends TBError {
    constructor(msg, identifiers) {
        super(msg);
        this.missingIdentifiers = identifiers;
    }
}

class TBMissingConfiguration extends TBError {
    constructor() {
        super('You must specifiy .properties configuration object');
    }
}

module.exports = {
    TBError,
    TBUniqueIdentifierViolationError,
    TBIdentifierNotDefined,
    TBMissingConfiguration
};