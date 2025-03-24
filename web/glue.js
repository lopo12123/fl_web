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

class Manager {
    static #singleton = null

    constructor() {
        if (Manager.#singleton) {
            return Manager.#singleton
        }
        Manager.#singleton = this
    }

    #app = null

    _createHostEl() {
        const hostEl = document.createElement('div')
        hostEl.style.position = 'absolute'
        // hostEl.style.zIndex = '-1'
        hostEl.style.width = '100%'
        hostEl.style.height = '100%'
        return hostEl
    }

    /**
     *
     * @returns {Promise<void>}
     */
    prelude() {
        const instance = this
        return new Promise((resolve, reject) => {
            try {
                _flutter.loader.load({
                    onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
                        const engine = await engineInitializer.initializeEngine({
                            multiViewEnabled: true, // Enables embedded mode.
                        });
                        const app = await engine.runApp();
                        instance.#app = app;

                        const el = instance._createHostEl()
                        document.body.append(el)
                        app.addView({
                            hostElement: el
                        })

                        resolve()
                    }
                });
            } catch (err) {
                reject(err)
            }
        })
    }
}

window['@fl'].manager = new Manager()