const simpleRand = (alphabet = "abcdefghijklmnopqrstuvwxyz", length = 10) => {
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
 */
window['@fl'] = {
    /**
     * DO NOT modify this since it will be called from dart side.
     *
     * @param channelName {string}
     * @param serialId {string}
     * @param error {string|null}
     * @param response {unknown}
     */
    generalHandler(channelName, serialId, error, response) {
        if (error) {
            console.error(channelName, serialId, error)
        } else {
            console.log(channelName, serialId, response)
        }
    },

    /**
     * This is more of a phantom marker,
     * the actual function will be set once dart is ready.
     *
     * @param channelName {string}
     * @param serialId {string}
     * @param arguments {unknown}
     */
    invokeMethod(channelName, serialId, arguments) {
        // no-op
    }
}
