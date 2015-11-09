/* ByteArrayUploader - Version 1.0 - 200705251920 - by Filippo Gregoretti
	Gets a ByteArray object and sends it to a server side call with multipart/form.
	Data defaults to work with Ruby server file eceiver made by Darren for JibJab, but other parameters can be set.

TYPE OF CLASS
	Instantiable

USAGE
	var myUploader = new ByteArrayUploader();
	myUploader.setParameters({_listener:this, _targetUrl:"http://www.mysite.com/myscript"});
	myUploader.sendBinary(ba:ByteArray);

CONSTRUCTOR OBJECT PARAMETERS (with default values)
	_targetUrl				S - "http://devx-02.jibjab.com/starring_you/upload_head_image"
	_fileNameFieldName		S - "uploaded_data"
	_fileName				S - "graphic_image.png"
	_fileDataFieldName		S - "graphic[uploaded_data]"
	_submitFieldName		S - "Upload"
	_submitValue			S - "Submit Query"
	_boundary				S - "---------------------------7d76d1b56035e"
	_contentType			S - "application/octet-stream"
	_usePOST				B - set to true for POST, false for GET. Defaults to POST
	_listener				O - listener object


METHODS
	parseBitmap([params:Object]) : String;
		Parses the movieclip set in params.clip and returns the string (if linesPerFrame is set to 0 or not set);
		If linesPerFrame is set to >=1, parsing will be made in progression and resulting string will be broadcasted with the event "onParseBitmapComplete".
		Constructor parameters can be overwritten from here.
		If linesPerFrame == 0, returns a string with the parsed bitmap, otherwise result is returned by the brodacasted callback listener.onParseBitmapComplete();
		
	getString() : String;
		Returns the string of a previously parsed bitmap.
	
	getBitmapData() : BitmapData;
		Returns the BitmapData object from the parsed MovieClip;
	
	
	getBitmapFromString(bitmapString:String) : BitmapData;
		With the previously formatted string as parameter, it returns a BitmapData object correctly formed.
	
EVENTS - The class broadcasts events in the _listener object.
		onByteArrayUploader_open(e:Event, myUploader:ByteArrayUploader);
		onByteArrayUploader_httpStatus(e:Event, myUploader:ByteArrayUploader);
		onByteArrayUploader_complete(e:Event, myUploader:ByteArrayUploader);
		onByteArrayUploader_ioError(e:Event, myUploader:ByteArrayUploader);
		onByteArrayUploader_securityError(e:Event, myUploader:ByteArrayUploader);
		onByteArrayUploader_progress(e:Event, myUploader:ByteArrayUploader);
		onByteArrayUploader_allEvents(e:Event, myUploader:ByteArrayUploader); 		- Broadcasted on all events

*/




package FlxerGallery.main {
	
	import								flash.utils.ByteArray;
	import								flash.net.*;
	import								flash.events.*;
	import								flash.utils.ByteArray;
	import								flash.net.URLRequest;
	import								flash.net.URLRequestMethod;
	import								flash.net.URLLoader;
	import								flash.events.Event;
	import								flash.events.HTTPStatusEvent;
	import								flash.events.ProgressEvent;
	import								flash.events.SecurityErrorEvent;
	import								flash.events.IOErrorEvent;
	import								flash.events.Event;
	
	public class ByteArrayUploader {
		// USER VARIABLES
		private var _targetUrl					:String = "http://devx-02.jibjab.com/starring_you/upload_head_image";
// 		private var _targetUrl					:String = "http://www.alphaserver.net/_test/flash/upload/test2.php";
		private var _fileNameFieldName			:String = "Filename";
		private var _fileName					:String = "graphic_image.png";
		private var _fileDataFieldName			:String = "Filedata";
		private var _submitFieldName			:String = "Upload";
		private var _submitValue				:String = "Submit Query";
		private var _pre						:String = "--";
		private var _boundary					:String = "---------------------------11845939021488195771539665531";
		private var _contentType				:String = "application/octet-stream";
		private var _guid						:String = ""; // "b6c309f8-f0ab-4230-b561-b1985890c85a";
		private var _usePOST					:Boolean = true;
		private var _request					:URLRequest;
		private var _urlLoader					:URLLoader;
		
		
		// SYSTEM VARIABLES
		private var _fileData					:ByteArray;
		private var _listener					:Object;
		
		
		public function ByteArrayUploader			() {
			
		}
		public function sendBinary				(binData:ByteArray) {
			if (!_urlLoader)					init();
			// SETUP REQUEST
			_request			 			= new URLRequest(_targetUrl);
			var requestByteArray:ByteArray 		= new ByteArray;
			requestByteArray.writeMultiByte 		(_pre + _boundary + '\r\nContent-Disposition: form-data; name="' + "guid" + '"\r\n\r\n' + _guid + '\r\n',"iso-8859-1");
			requestByteArray.writeMultiByte 		(_pre + _boundary + '\r\nContent-Disposition: form-data; name="' + _fileNameFieldName + '"\r\n\r\n' + _fileName + '\r\n',"iso-8859-1");
			requestByteArray.writeMultiByte		(_pre + _boundary + '\r\nContent-Disposition: form-data; name="' + _fileDataFieldName + '"; filename="' + _fileName + '"\r\nContent-Type: application/octet-stream\r\n\r\n',"iso-8859-1"); 
			requestByteArray.writeBytes			(binData, 0, binData.length);
			requestByteArray.writeMultiByte		('\r\n',"iso-8859-1");
			requestByteArray.writeMultiByte		(_pre + _boundary + '\r\nContent-Disposition: form-data; name="' + _submitFieldName + '"\r\n\r\n' + _submitValue + '\r\n',"iso-8859-1"); 
			requestByteArray.writeMultiByte		(_pre + _boundary + '--\r\n',"iso-8859-1");
			_request.data 					= requestByteArray;
			_request.method 					= _usePOST ? URLRequestMethod.POST : URLRequestMethod.GET;
			_request.contentType 				= "multipart/form-data; boundary=" + _boundary;
			trace							("ByteArrayUploader> -----SENDING FOLLOWING DATA----\n" + requestByteArray);
			// GO!!!!
			_urlLoader.load					(_request);
		}
		public function init					() {
			// SETUP URL LOADER
			_urlLoader						= new URLLoader();
			_urlLoader.addEventListener 			(SecurityErrorEvent.SECURITY_ERROR , onHandler);
			_urlLoader.addEventListener 			(IOErrorEvent.IO_ERROR , onHandler);
			_urlLoader.addEventListener 			(Event.COMPLETE, onHandler);
			_urlLoader.addEventListener 			(Event.OPEN, onHandler);
			_urlLoader.addEventListener 			(HTTPStatusEvent.HTTP_STATUS , onHandler);
			_urlLoader.addEventListener 			(ProgressEvent.PROGRESS , onHandler);
		}
		public function onHandler				(e:Event) {
			var feedbackCall:String			= "onByteArrayUploader_" + e.type;
			trace("ByteArrayUploader EVENT> " + e.type);
			if (_listener[feedbackCall]) 			_listener[feedbackCall](e, this);
			if (_listener.onByteArrayUploader_allEvents) _listener.onByteArrayUploader_allEvents(e, this);
			if (e.type == "complete") {
				trace("COMPLETE: <" + e.target.data+">");
				if (isUploadSuccessful(e.target.data)) {
					trace					("ByteArrayUploader> UPLOAD SUCCESSFUL");
					if (_listener.onByteArrayUploader_success) _listener.onByteArrayUploader_success();
				}
				else {
					trace					("ByteArrayUploader> UPLOAD ERROR: " + e.target.data);
					if (_listener.onByteArrayUploader_failure) _listener.onByteArrayUploader_failure();
				}
			}
			else if (e.type == "ioError" || e.type == "httpError") {
				trace						("ByteArrayUploader> UPLOAD ERROR <IGNORE AND BYPASS> ");
				if (_listener.onByteArrayUploader_success) _listener.onByteArrayUploader_success();
// 				if (_listener.onByteArrayUploader_failure) _listener.onByteArrayUploader_failure(e.target.data);
			}
		}
		public function isUploadSuccessful			(o:Object) : Boolean {
			return						o.toString().indexOf('esito=1') != -1;
		}

		public function setParameters			(p:Object) {
			for (var i in p)					this[i] = p[i];
		}
	}
}