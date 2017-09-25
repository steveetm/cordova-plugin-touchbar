Cordova Plugin Touchbar
======

A Cordova plugin to access and configure TouchBar on compatible MacBook Pro models from JavaScript. 
In its current state this plugin may not useful at all and only serves as a traininground for me
to learn Objective-c and Cordova plugin development.


#Example

```
TouchBarPlugin.defineTouchBarItems([
{
    type:'NSButton',
    title:'Button title',
    identifier:'very.unique.identifier',
    onTap: ()=>console.log('Button tapped')
},
{
    type: 'NSSlider',
    identifier:'very.unique.slider.identifier'
}
]);

TouchBarPlugin.setDefaultItemIdentifiers([
    'very.unique.identifier',
    TouchBarPlugin.identifiers.fixedSpaceLarge,
    'very.unique.slider.identifier',
    TouchBarPlugin.identifiers.otherItemsProxy
]);
```
