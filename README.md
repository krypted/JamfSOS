# JamfGPS
Proof of Concept App That Sends GPS Coordinates To A Jamf Extension Attribute Called "gps"

This app sends GPS coordinates (e.g. "-41.9902,34.00029475" into an extension attribute called gps. 

This app is meant to be a proof of concept and not put into production. When opened it will display a simple map view.

![alt text](https://github.com/krypted/JamfGPS/blob/master/JamfGPSScreen.png | =250x500)

The view controller sends core location data to the Jamf Pro UAPI or to be more specific sends MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01).

For now we're simply constructing the URL to POST to as components.path = "/uapi/inventory/obj/mobileDevice/1/update" on a host defined in the app. 

That 1 integer is static so it just works for one device. 

You can use the Jamf Pro Certificates API to remove the token from the app and dynamically obtain the device ID using appconfig feedback.
