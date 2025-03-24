const simpleRand = (alphabet = "abcdefghijklmnopqrstuvwxyz", length = 10) => {
    const alphabetLength = alphabet.length;
    let result = '';
    for (let i = 0; i < length; i++) {
        const randomIndex = Math.floor(Math.random() * alphabetLength);
        result += alphabet[randomIndex];
    }
    return result;
}

// TODO: hide element behind page
const createHostElement = () => {
    const hostEl = document.createElement('div')
    hostEl.style.position = 'absolute'
    // hostEl.style.zIndex = '-1'
    hostEl.style.width = '100%'
    hostEl.style.height = '100%'
    return hostEl
}

/**
 * @typedef {Map<String, { resolve: (response: unknown) => void, reject: (error: string) => void }>} HandlerPool
 */

/**
 * interop object
 */
window['@fl'] = {
    /**
     * @type {HandlerPool}
     */
    _pool: new Map(),

    /**
     * DO NOT modify this since it will be called from dart side.
     *
     * @param channelName {string}
     * @param serialId {string}
     * @param error {string|null}
     * @param response {unknown}
     */
    generalHandler(channelName, serialId, error, response) {
        const handlerKey = `${channelName}:${serialId}`
        const handler = this._pool.get(handlerKey)
        if (!handler) throw new Error(`! no handler found for invocation (${channelName}:${serialId})`)

        if (error) {
            handler.reject(error)
        } else {
            handler.resolve(response)
        }
        this._pool.delete(handlerKey)
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
    },

    /**
     * Setup flutter engine and add a view to dom.
     * @returns {Promise<view>}
     */
    prelude() {
        const instance = this
        return new Promise((resolve, reject) => {
            try {
                _flutter.loader.load({
                    onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
                        // initialize engine and app
                        const engine = await engineInitializer.initializeEngine({
                            multiViewEnabled: true, // Enables embedded mode.
                        });
                        const app = await engine.runApp();

                        // register handler for 'ready' event, which will be called from dart side after page is ready
                        instance._pool.set('ready:', {resolve, reject})
                        const el = createHostElement()
                        document.body.append(el)
                        app.addView({hostElement: el})
                    }
                });
            } catch (err) {
                reject(err)
            }
        })
    },

    /**
     * underlying call
     * @param {string} channel channel name
     * @param {unknown} payload payload to send
     */
    _interact(channel, payload) {
        return new Promise((resolve, reject) => {
            const serial = simpleRand()
            this._pool.set(`${channel}:${serial}`, {resolve, reject})
            this.invokeMethod(channel, serial, payload)
        })
    },

    /**
     * @template {unknown} T
     * @param {T} message
     * @return {Promise<T>}
     */
    echo(message) {
        return this._interact('echo', message)
    },

    /**
     * 生成文献的分享卡片
     * @param info data for rendering paper card
     * @return {Uint8Array} buffer of the image
     */
    buildPaperCard(info) {
        return this._interact('paper', info)
    }
}

// DEV ONLY: auto launch
setTimeout(() => window['@fl'].prelude(), 100)

// Example:
//
// await window['@fl'].prelude()
// const resp = await window['@fl'].echo('hello')
// console.assert(resp == 'hello', 'never!')