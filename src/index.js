import { NativeModules, NativeEventEmitter } from 'react-native';

const { WebViewNativeModule } = NativeModules;
const emitter = new NativeEventEmitter(WebViewNativeModule);

export const open = ({ url, html }) => WebViewNativeModule.open({ url, html });
export const addListener = (cb) => {
    const sub = emitter.addListener('WebViewNativeEvent', cb);
    return () => sub.remove();
};

export default { open, addListener };


