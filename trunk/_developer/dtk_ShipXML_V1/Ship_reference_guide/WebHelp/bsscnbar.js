/////////////////////////////////////////////////////////////////////////////
// RoboHELP� Navigator Bar for WebHelp
// Copyright � 1999-2000 eHelp Corporation.  All rights reserved.

// Version= 4.30

// Warning:  Do not modify this file.  It is generated by RoboHELP� and changes will be overwritten.

// This file is used to support Navigator bar in WebHelp
// The main functions are Sync toc. Show or Hide Navigator Panel. 

// call onBsscNavHide() from bsscright frame.
// Hide the bsscleft frame(Nav). and show the current topic.

// call onBsscNavShow() from any frame except bsscright.
// Show the bsscleft frame(Nav). and show the current topic in the bsscright frame. and sync toc.

// call onBsscNavSync() from bsscright frame.
// there will be two situation.
// 1. Nav is visible.  Just Sync the toc.( show the Contents panel and highlight the related topic).
// 2. Nav is invisible. First Show the Nav panel. and then Sync the toc.


// onBsscNavSync(strRelHomePage) strRelHomePage is the Relative Path of the First Page, from the current page's view.
// other function will be called by onContent(). do not call them directly.

// onBsscNavSync is modified from onContents() in SyncFromTopic.js. add support DHTML sync. 

// BsscNavHasNavFrame() determine the Nav frame exists or not


var gbDHTML = false;

var strAgent   = navigator.userAgent.toLowerCase();
var strVersion = navigator.appVersion.toLowerCase();

var gnVerMajor = parseInt(strVersion);
var gnVerMinor = parseFloat(strVersion);

var gbNS     = ((strAgent.indexOf("mozilla") != -1) && ((strAgent.indexOf('spoofer') == -1) && (strAgent.indexOf('compatible') == -1)));
var gbIE     = (strAgent.indexOf("msie") != -1);
var gbOpera  = (strAgent.indexOf("opera") != -1);
var gbHotJava= (strVersion.indexOf("hotjava") != -1);

var gbWin16   = ((strVersion.indexOf("win16") != -1) || (strVersion.indexOf("windows 3.1") != -1));
var gbWindows = ((strAgent.indexOf("win") != -1) || (strAgent.indexOf("16bit") != -1));
var gbMac     = (strAgent.indexOf("mac") != -1);
var gbWebTV   = (strAgent.indexOf("webtv") != -1);
var gbSunOS   = (strAgent.indexOf("sunos") != -1);

var gbNS2         = ((gbNS) && (gnVerMajor == 2));
var gbNS3         = ((gbNS) && (gnVerMajor == 3));
var gbNS4         = ((gbNS) && (gnVerMajor >= 4));
var gbIE4         = ((gbIE) && (gnVerMajor >= 4));
var gbIE400		  = (strAgent.indexOf("msie 4.0;") != -1);
var gbIE3         = ((gbIE) && (gnVerMajor <= 3));
var gbIE302before = ((gbIE3) && ((strAgent.indexOf("3.00") != -1)||(strAgent.indexOf("3.0a") != -1)||(strAgent.indexOf("3.0b")!=-1)||(strAgent.indexOf("3.01")!=-1))); 

var gbIE5	  = ((gbIE4) && (strAgent.indexOf("msie 5") != -1));

var nViewFrameType = 2;  //1: DTHTML 2:Applet 3: HTML2 list

if (gbIE4 && gbDHTML) nViewFrameType = 1;
if (gbIE4 && gbSunOS) nViewFrameType = 1;

if (gbWin16)          nViewFrameType = 3;
if (gbIE3 && gbMac)   nViewFrameType = 3;
if (gbNS2)            nViewFrameType = 3;
if (gbNS3 && gbMac)   nViewFrameType = 3;
if (gbOpera)          nViewFrameType = 3;
if (gbHotJava)        nViewFrameType = 3;
if (gbWebTV)          nViewFrameType = 3;
if (gbIE302before)    nViewFrameType = 3;

if ((gbNS4) && (window.screen) && (window.screen.colorDepth == 4))
{
   nViewFrameType = 3;
}

function BsscNavIsList() {
	return (nViewFrameType == 3 || (gbIE4 && !gbIE5 && gbMac));
}

var gbstrNavnAgent   = navigator.userAgent.toLowerCase();

var gbNavnNS    = false;
var gbNavnIE	= false;
gbNavnNS 	= ((gbstrNavnAgent.indexOf("mozilla") != -1) && ((gbstrNavnAgent.indexOf('spoofer') == -1) && (gbstrNavnAgent.indexOf('compatible') == -1)));
gbNavnIE    	= (gbstrNavnAgent.indexOf("msie") != -1);

var gbstrAbsHomePageURL = "";
var gbstrRelHomePageURL = "";
var gbCurrentTopicURL   = "";
var gHomePage = null;

function _bsscnBarEqualURL(strAbsHomePageURL, strCurrentURL)
{
	var strNormalstrAbsHomePageURL = strAbsHomePageURL.toLowerCase();
	var strNormalstrCurrentURL = strCurrentURL.toLowerCase();

	strNormalstrAbsHomePageURL = _bsscnBarConvertToURLFormat(strNormalstrAbsHomePageURL);
	strNormalstrCurrentURL = _bsscnBarConvertToURLFormat(strNormalstrCurrentURL);

	if (strNormalstrAbsHomePageURL == strNormalstrCurrentURL)
		return true;
	else 
		return false;
}

// change ��� to %E0%E1%E3
function _bsscnBarConvertToURLFormat(strURL)
{
	var strResURL = "";
	var i = 0;
	if (!gbNS4 && !gbIE4) return strURL;
	for (i = 0; i < strURL.length; i ++)
	{
		var nCode = strURL.charCodeAt(i);
		if (nCode > 127) {
			strResURL += "%";
			var strTemp = String.fromCharCode(HEXToCharCode(nCode/16), HEXToCharCode(nCode%16));
			strResURL += strTemp
		}
		else 
			strResURL += strURL.charAt(i);
	}
	if (strResURL.indexOf("file:/") == 0 && strResURL.indexOf("file:///") == -1) {
		strResURL = strResURL.replace("file:/", "file:///");
	}
	return strResURL;
}

function HEXToCharCode(n)
{
	if (n < 10) {
		return '0'.charCodeAt(0) + n;
	}
	else if (n < 16) {
		return 'A'.charCodeAt(0) + (n - 10);
	}
	else
		return 0;
}

function _bsscnBarGetStartPage(pwindow) {
	var strAbsHomePageURL = _bsscnBarGetAbsHomePageURL();
	var strCurrentURL = pwindow.document.URL;
	strCurrentURL = _bsscnBarReplaceSlash(strCurrentURL);
	var nEndPos  = strCurrentURL.indexOf('#');
	if (nEndPos != -1) {
		strCurrentURL = strCurrentURL.substring(0, nEndPos);
	}
	if (_bsscnBarEqualURL(strAbsHomePageURL, strCurrentURL)) {
		return pwindow;
	}
	else {
		if (pwindow.parent.frames.length != 0 && pwindow.parent != pwindow && pwindow.parent != null) 
		{
			gbCurrentTopicURL = strCurrentURL;
			return _bsscnBarGetStartPage(pwindow.parent);
		}
		else 
			if (typeof(pwindow.gbHomePage) != "undefined") 
				return pwindow;
			else
				return null;

	}
}

function _bsscnBarGetOutMostTopic(pwindow) {
	var strAbsHomePageURL = _bsscnBarGetAbsHomePageURL();
	var strCurrentURL = pwindow.document.URL;
	strCurrentURL = _bsscnBarReplaceSlash(strCurrentURL);

	var strOutStartPage = pwindow.gbstrRelHomePageURL;
	if (typeof(strOutStartPage) == "undefined") return null;

	var strOutAbsHomePageURL = _bsscnBarGetOutAbsHomePageURL(strCurrentURL, strOutStartPage);

	if (_bsscnBarEqualURL(strAbsHomePageURL, strOutAbsHomePageURL)) {
		if (pwindow.parent.frames.length != 0 && pwindow.parent != pwindow && pwindow.parent != null) {
			var pfind = _bsscnBarGetOutMostTopic(pwindow.parent);
			if (pfind == null) {
				gbCurrentTopicURL = strCurrentURL;
				return pwindow;
			}
			else
				return pfind;
		}
		else  {
			gbCurrentTopicURL = strCurrentURL;
			return pwindow;
		}
	}
	else
		return null;
}

function _bsscnBarGetOutAbsHomePageURL(strCurrentURL, strOutStartPage)
{
	var strRelHomePage = _bsscnBarReplaceSlash(strOutStartPage);
	
	strCurrentURL = _bsscnBarReplaceSlash(strCurrentURL);
	
	var strCurrentPath = _bsscnBarGetPath(strCurrentURL);
	var strCurrentFile = _bsscnBarGetFileName(strCurrentURL);
	
	var strAbsHomePageURL = _bsscnBarGetAbsoluteHomePageURL(strRelHomePage, strCurrentPath);
	
	return strAbsHomePageURL;
}

function BsscNavHasNavFrame()
{
	var bHomePage = false;
	if (gHomePage == null)
		gHomePage = 	_bsscnBarGetStartPage(parent);	

	if (gHomePage != null)
		bHomePage = true;
	return bHomePage;
}

// call onBsscNavHide() from bsscright frame.
// Hide the bsscleft frame(Nav). and show the current topic.
function onBsscNavHide()
{
	
	if (BsscNavHasNavFrame()) {
		var strCurrentURL = document.URL;
		var OutTopic = _bsscnBarGetOutMostTopic(window);
		if (OutTopic != null) {
			if (gbCurrentTopicURL.length > 0) 
				strCurrentURL = gbCurrentTopicURL;
		}
		
		if (strCurrentURL.toLowerCase().indexOf("file://") == 0) {
			strCurrentURL = _bsscnBarReplaceSpecialChar(strCurrentURL);
		}
		gHomePage.document.location.replace(strCurrentURL);
	}
}

// call onBsscNavShow() from any frame except bsscright.
// Show the bsscleft frame(Nav). and show the current topic in the bsscright frame. and sync toc.
function onBsscNavShow()
{
	if (!BsscNavHasNavFrame()) {

		var strAbsHomePageURL = _bsscnBarGetAbsHomePageURL();
		var strAbsHomePagePath = _bsscnBarGetPath(strAbsHomePageURL);

		strAbsHomePagePath = strAbsHomePagePath + "/";
	
		var strCurrentURL = document.URL;
		strCurrentURL = _bsscnBarReplaceSlash(strCurrentURL);

		var OutTopic = _bsscnBarGetOutMostTopic(window);
		if (OutTopic != null)
			if (gbCurrentTopicURL.length > 0) 
				strCurrentURL = gbCurrentTopicURL;

		var startpos  = strCurrentURL.indexOf(strAbsHomePagePath);
		if (startpos != -1) {
			strRelativeURL = strCurrentURL.substring(startpos + strAbsHomePagePath.length, strCurrentURL.length);
			if (strAbsHomePageURL.toLowerCase().indexOf("file://") == 0) 
				strAbsHomePageURL = _bsscnBarReplaceSpecialChar(strAbsHomePageURL);
			if (OutTopic != null) {
				if (gbIE400) // ie 4.00 can not recognize the bookmark locally.
					OutTopic.location.replace(strAbsHomePageURL);
				else
					OutTopic.location.replace(strAbsHomePageURL+"#" + strRelativeURL);
			}
		}
	}
}

function _bsscnBarGetAbsHomePageURL()
{
	if ( gbstrAbsHomePageURL.length > 0) return gbstrAbsHomePageURL;

	var strRelHomePage = _bsscnBarReplaceSlash(gbstrRelHomePageURL);
	
	var strCurrentURL = document.URL;
	strCurrentURL = _bsscnBarReplaceSlash(strCurrentURL);
	
	var strCurrentPath = _bsscnBarGetPath(strCurrentURL);
	var strCurrentFile = _bsscnBarGetFileName(strCurrentURL);
	
	gbstrAbsHomePageURL = _bsscnBarGetAbsoluteHomePageURL(strRelHomePage, strCurrentPath);
	
	return gbstrAbsHomePageURL;
}

function onBsscAutoSync()
{
	var strAbsHomePageURL = _bsscnBarGetAbsHomePageURL();
	var strAbsHomePagePath = _bsscnBarGetPath(strAbsHomePageURL);

	strAbsHomePagePath = strAbsHomePagePath + "/";
	
	var strCurrentURL = document.URL;
	strCurrentURL = _bsscnBarReplaceSlash(strCurrentURL);
	
	var startpos  = strCurrentURL.indexOf(strAbsHomePagePath);
	
	if (startpos != -1) {
		strRelativeURL = strCurrentURL.substring(startpos + strAbsHomePagePath.length, strCurrentURL.length);
		if (BsscNavHasNavFrame()) {
			if(gbNavnIE) {// IE
				if (gHomePage.document.frames[0].document.applets.length > 0) {
					if (typeof(gHomePage.document.frames[0].document.applets["webhelp"]) != "undefined") {
						if (!gbIE4 || !gbWindows || gHomePage.document.frames[0].gbLoading != "unknown") 
							gHomePage.document.frames[0].document.applets["webhelp"].Command("AutoSync", strRelativeURL);
					}
				}
				else {
					// probably DHTML
					if (typeof(gHomePage.document.frames[0].document.frames["Tabs"]) != "undefined") {
						var tabFrame = gHomePage.document.frames[0].document.frames["Tabs"];
						_bsscnBarAutoSync(strRelativeURL);
					} 
					else { // it must be list
					}
				}
			}
			else { // Probably Netscape.
				if (gHomePage.frames[0].document.applets.length > 0) {
					if (typeof(gHomePage.frames[0].document.applets["webhelp"]) != "undefined") {
						gHomePage.frames[0].document.applets["webhelp"].Command("AutoSync", strRelativeURL);
					}
				}
				else {
					// probably DHTML
					if (typeof(gHomePage.document.frames[0].document.frames["Tabs"]) != "undefined") {
						_bsscnBarAutoSync(strRelativeURL);
					}
					else { // it must be list
					}
				}
			}
		}
	}
}

function onBsscNavSync()
{
	var strAbsHomePageURL = _bsscnBarGetAbsHomePageURL();
	var strAbsHomePagePath = _bsscnBarGetPath(strAbsHomePageURL);

	strAbsHomePagePath = strAbsHomePagePath + "/";
	
	var strCurrentURL = document.URL;
	strCurrentURL = _bsscnBarReplaceSlash(strCurrentURL);
	
	var startpos  = strCurrentURL.indexOf(strAbsHomePagePath);
	
	if (startpos != -1) {
		strRelativeURL = strCurrentURL.substring(startpos + strAbsHomePagePath.length, strCurrentURL.length);
		if (BsscNavHasNavFrame()) {
			if(gbNavnIE) {// IE
				if (gHomePage.document.frames[0].document.applets.length > 0) {
					if (typeof(gHomePage.document.frames[0].document.applets["webhelp"]) != "undefined") {
						gHomePage.document.frames[0].document.applets["webhelp"].Command("SyncToc", strRelativeURL);
					}
				}
				else {
					// probably DHTML
					if (typeof(gHomePage.document.frames[0].document.frames["Tabs"]) != "undefined") {
						var tabFrame = gHomePage.document.frames[0].document.frames["Tabs"];
						_bsscnBarSelectTOC(strRelativeURL);
					} 
					else { // it must be list
					}
				}
			}
			else { // Probably Netscape.
				if (gHomePage.frames[0].document.applets.length > 0) {
					if (typeof(gHomePage.frames[0].document.applets["webhelp"]) != "undefined") {
						gHomePage.frames[0].document.applets["webhelp"].Command("SyncToc", strRelativeURL);
					}
				}
				else {
					// probably DHTML
					if (typeof(gHomePage.document.frames[0].document.frames["Tabs"]) != "undefined") {
						_bsscnBarSelectTOC(strRelativeURL);
					}
					else { // it must be list
					}
				}
			}
		}
		else
			//location.replace(strAbsHomePageURL+"#" + strRelativeURL);
			onBsscNavShow();
	}
}


// replace %20 to ' '
function _bsscnBarReplaceSpecialChar(strURL)
{	
	var strReplacedURL = "";
	for (i = 0; i < strURL.length; i ++ )
	{
		if (strURL.charAt(i) == '%') {
			if (strURL.substring(i + 1, i + 3) == "20") {
				strReplacedURL = strReplacedURL + " ";
				i += 2;
			}
			else
			    strReplacedURL = strReplacedURL + strURL.charAt(i);
		}
		else
		    strReplacedURL = strReplacedURL + strURL.charAt(i);
	}
	return strReplacedURL;
}


// replace \\ to /
function _bsscnBarReplaceSlash(strURL)
{	
	var strReplacedURL = "";
	for (i = 0; i < strURL.length; i ++ )
	{
		if (strURL.charAt(i) == '\\') 
			strReplacedURL = strReplacedURL + "/"
		else
		    strReplacedURL = strReplacedURL + strURL.charAt(i);
	}
	return strReplacedURL;
}

// generate absolute URL for the first page.
function _bsscnBarGetAbsoluteHomePageURL(strRelHomePage, strCurrentPath)
{
	if (strCurrentPath.charAt(strCurrentPath.length - 1) == '/') 
		strCurrentPath = strCurrentPath.substring(0, strCurrentPath.length -1);
	for (;;) {
		upDirPos = strRelHomePage.indexOf("../")
		if (upDirPos == 0) {
			DirPos = strCurrentPath.lastIndexOf("/")
			if (DirPos != -1) {
			strCurrentPath = strCurrentPath.substring(0, DirPos)
			}
			strRelHomePage = strRelHomePage.substring(3, strRelHomePage.length);
		}
		if (upDirPos != 0) break;
	}
	return strCurrentPath + "/" + strRelHomePage;
}

function _bsscnBarGetPath(strURL)
{
	pathpos = strURL.lastIndexOf("/");
	if (pathpos > 0)
		return strURL.substring(0, pathpos);
	else 
		return "";
}

function _bsscnBarGetFileName(strURL)
{
	pathpos = strURL.lastIndexOf("/");
	if (pathpos > 0)
		return strURL.substring(pathpos + 1, strURL.length);
	else
		return strURL;
}

function _bsscnBarGetTabFrame()
{
	if (gHomePage == null) return null;
	if(gbNavnIE) {// IE
		return gHomePage.document.frames[0];
	}
	else { // Netscape
		return gHomePage.frames[0];
	}
}

function _bsscnBarAutoSync(strRelativeURL)
{
	var TabFrame = _bsscnBarGetTabFrame();
	if ("function" == typeof(TabFrame.autosync))
		TabFrame.autosync(strRelativeURL);
}



function _bsscnBarSelectTOC(strRelativeURL)
{
	var TabFrame = _bsscnBarGetTabFrame();
	if ("function" == typeof(TabFrame.syncToc))
		TabFrame.syncToc(strRelativeURL);
}


function _bsscnBarOnError(message)
{
	if(-1 != message.indexOf("denied") 
		|| -1 != message.indexOf("Object required"))
	 return true;
}

onerror = _bsscnBarOnError;