Cordova Plugin Touchbar
======

A Cordova plugin to access and configure TouchBar on compatible MacBook Pro models from JavaScript. 
In its current state this plugin may not useful at all and only serves as a traininground for me
to learn Objective-c and Cordova plugin development.


#Example

```
TouchBar.defineTouchBarItems([{
            type: "NSButton",
            image: TouchBarPlugin.identifiers.images.NSImageNameTouchBarBookmarksTemplate,
            title: 'Title',
            identifier: 'Button1'
        }, {
            type: "NSSlider",
            title: "",
            identifier: 'Slider',
            minValue: 0,
            maxValue: 100,
        }])
        .then(() => {
            TouchBar.setDefaultItemIdentifiers(['Button1', 'Slider', TouchBarPlugin.identifiers.elements.otherItemsProxy]);
            TouchBar.on('Button1', 'tap', () => {
                alert('tapped')
            });
            TouchBar.on('Slider', 'change', function (newValue) {
                console.log(newValue)
            })
        });
```
