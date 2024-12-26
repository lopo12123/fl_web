/**
 * @typedef {'ping' | 'share-card'} FLFnName
 */

/**
 * thanks to [moki](https://github.com/ClearLuvMoki)
 *
 * @typedef {function(name: FLFnName, serialId: string, args: unknown): void} FLHandler
 */
const mokiRand = (alphabet = "abcdefghijklmnopqrstuvwxyz", length = 10) => {
    const alphabetLength = alphabet.length;
    let result = '';
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * alphabetLength);
        result += alphabet[randomIndex];
    }
    return result;
}

/**
 * interop object
 *
 * 1. inject 'handler' field by flutter app
 * 2. add handlers start with 'on' in js-side
 *
 * @private this should not be used or modified directly
 * @type {{handler: FLHandler}}
 */
window['@fl'] = {
    /**
     * @param serialId {string}
     * @param echo {Object}
     */
    onPing(serialId, echo) {
        console.log('resp::ping', serialId, echo)
    },
    /**
     * @param serialId {string}
     * @param bytes {Uint8Array}
     */
    onFreeDrawCaptured(serialId, bytes) {
        // console.log('resp::free-draw', serialId, bytes)

        const url = URL.createObjectURL(new Blob([bytes], {type: 'image/png'}))
        const a = document.createElement('a')
        a.href = url
        a.download = `${mokiRand()}.png`
        a.click()
        URL.revokeObjectURL(url)
    },
    /**
     * @param serialId {string}
     * @param bytes {Uint8Array}
     */
    onShareCardGenerated(serialId, bytes) {
        console.log('resp::share-card', serialId, bytes)
        // TODO: use it as you like
    }
}


/**
 * send message to flutter app
 * @param name {FLFnName}
 * @param serialId {string}
 * @param args {unknown}
 */
window.callFL = (name, serialId, args) => {
    // TODO
}
